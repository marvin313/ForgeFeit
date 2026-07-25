import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../domain/planning_models.dart';
import '../domain/system_exercise_catalog.dart';
import 'remote_planning_data_source.dart';

typedef PlanningIdGenerator = String Function();
typedef PlanningClock = DateTime Function();

class PendingPlanningUpload {
  const PendingPlanningUpload({
    required this.queueId,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.entityVersion,
    required this.entity,
    required this.attemptCount,
    this.lastError,
  });

  final String queueId;
  final String userId;
  final PlanningEntityType entityType;
  final String entityId;
  final int entityVersion;
  final Object entity;
  final int attemptCount;
  final String? lastError;
}

/// Offline-first persistence for splits, templates, and exercise planning.
///
/// Every mutation writes the user-visible record and its durable outbox marker
/// in one SQLite transaction. Cloud uploads always use the device-generated
/// UUID, making retries idempotent.
class OfflineFirstPlanningRepository {
  factory OfflineFirstPlanningRepository({
    required AppDatabase database,
    required RemotePlanningDataSource remote,
    PlanningIdGenerator? idGenerator,
    PlanningClock? clock,
  }) => OfflineFirstPlanningRepository._(
    database,
    remote,
    idGenerator ?? _generateUuid,
    clock ?? _utcNow,
  );

  OfflineFirstPlanningRepository._(
    this._database,
    this._remote,
    this._idGenerator,
    this._clock,
  );

  final AppDatabase _database;
  final RemotePlanningDataSource _remote;
  final PlanningIdGenerator _idGenerator;
  final PlanningClock _clock;

  Stream<List<WorkoutSplit>> watchSplits(String userId) {
    final owner = _validatedId(userId, 'userId');
    final query = _database.select(_database.workoutSplits)
      ..where((row) => row.userId.equals(owner) & row.deletedAt.isNull())
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_splitFromRow)),
    );
  }

  /// Watches all templates, or one split/No Split when [allSplits] is false.
  Stream<List<WorkoutTemplate>> watchTemplates(
    String userId, {
    bool allSplits = true,
    String? splitId,
  }) {
    final owner = _validatedId(userId, 'userId');
    final validatedSplitId = splitId == null
        ? null
        : _validatedId(splitId, 'splitId');
    final query = _database.select(_database.workoutTemplates)
      ..where((row) {
        var predicate = row.userId.equals(owner) & row.deletedAt.isNull();
        if (!allSplits) {
          predicate =
              predicate &
              (validatedSplitId == null
                  ? row.splitId.isNull()
                  : row.splitId.equals(validatedSplitId));
        }
        return predicate;
      })
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_templateFromRow)),
    );
  }

  Stream<List<CustomExercise>> watchCustomExercises(String userId) {
    final owner = _validatedId(userId, 'userId');
    final query = _database.select(_database.customExercises)
      ..where((row) => row.userId.equals(owner) & row.deletedAt.isNull())
      ..orderBy([
        (row) => OrderingTerm.desc(row.isFavourite),
        (row) => OrderingTerm.desc(row.lastUsedAt),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_customExerciseFromRow)),
    );
  }

  Stream<List<TemplateExercise>> watchTemplateExercises(
    String userId,
    String templateId,
  ) {
    final owner = _validatedId(userId, 'userId');
    final template = _validatedId(templateId, 'templateId');
    final query = _database.select(_database.templateExercises)
      ..where(
        (row) =>
            row.userId.equals(owner) &
            row.templateId.equals(template) &
            row.deletedAt.isNull(),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.createdAt),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_templateExerciseFromRow)),
    );
  }

  Future<PlanningSnapshot> getSnapshot(
    String userId, {
    bool includeDeleted = false,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final splitQuery = _database.select(_database.workoutSplits)
      ..where(
        (row) =>
            row.userId.equals(owner) &
            (includeDeleted ? const Constant(true) : row.deletedAt.isNull()),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
    final templateQuery = _database.select(_database.workoutTemplates)
      ..where(
        (row) =>
            row.userId.equals(owner) &
            (includeDeleted ? const Constant(true) : row.deletedAt.isNull()),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);
    final customQuery = _database.select(_database.customExercises)
      ..where(
        (row) =>
            row.userId.equals(owner) &
            (includeDeleted ? const Constant(true) : row.deletedAt.isNull()),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    final entryQuery = _database.select(_database.templateExercises)
      ..where(
        (row) =>
            row.userId.equals(owner) &
            (includeDeleted ? const Constant(true) : row.deletedAt.isNull()),
      )
      ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]);

    return PlanningSnapshot(
      splits: (await splitQuery.get()).map(_splitFromRow),
      templates: (await templateQuery.get()).map(_templateFromRow),
      customExercises: (await customQuery.get()).map(_customExerciseFromRow),
      templateExercises: (await entryQuery.get()).map(_templateExerciseFromRow),
    );
  }

  Future<WorkoutSplit> createSplit({
    required String userId,
    required String name,
    String? description,
    String icon = 'folder',
    int colorValue = 0xFF169BFF,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final validatedName = _requiredText(name, 'name', 100);
    final validatedDescription = _optionalText(
      description,
      'description',
      1000,
    );
    final validatedIcon = _requiredText(icon, 'icon', 16);
    _validateColor(colorValue);
    final now = _now();
    final split = WorkoutSplit(
      id: _newId(),
      userId: owner,
      name: validatedName,
      description: validatedDescription,
      icon: validatedIcon,
      colorValue: colorValue,
      sortOrder: await _nextSplitOrder(owner),
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

    await _database.transaction(() async {
      await _insertSplit(split);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutSplit,
        entityId: split.id,
        entityVersion: split.version,
        now: now,
      );
    });
    return split;
  }

  Future<WorkoutSplit> updateSplit({
    required String userId,
    required String splitId,
    required String name,
    required String? description,
    required String icon,
    required int colorValue,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(splitId, 'splitId');
    final validatedName = _requiredText(name, 'name', 100);
    final validatedDescription = _optionalText(
      description,
      'description',
      1000,
    );
    final validatedIcon = _requiredText(icon, 'icon', 16);
    _validateColor(colorValue);
    return _database.transaction(() async {
      final current = await _requireActiveSplit(owner, id);
      final now = _now();
      final updated = WorkoutSplit(
        id: current.id,
        userId: current.userId,
        name: validatedName,
        description: validatedDescription,
        icon: validatedIcon,
        colorValue: colorValue,
        sortOrder: current.sortOrder,
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateSplitRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutSplit,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      return updated;
    });
  }

  Future<WorkoutSplit> renameSplit({
    required String userId,
    required String splitId,
    required String name,
  }) async {
    final current = await _requireActiveSplit(
      _validatedId(userId, 'userId'),
      _validatedId(splitId, 'splitId'),
    );
    return updateSplit(
      userId: userId,
      splitId: splitId,
      name: name,
      description: current.description,
      icon: current.icon,
      colorValue: current.colorValue,
    );
  }

  Future<void> reorderSplits({
    required String userId,
    required List<String> orderedSplitIds,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final orderedIds = orderedSplitIds
        .map((id) => _validatedId(id, 'splitId'))
        .toList(growable: false);
    _requireUniqueIds(orderedIds, 'orderedSplitIds');
    await _database.transaction(() async {
      final rows =
          await (_database.select(_database.workoutSplits)..where(
                (row) => row.userId.equals(owner) & row.deletedAt.isNull(),
              ))
              .get();
      _requireCompleteReorder(
        expectedIds: rows.map((row) => row.id),
        orderedIds: orderedIds,
        field: 'orderedSplitIds',
      );
      final byId = {for (final row in rows) row.id: row};
      final now = _now();
      for (var index = 0; index < orderedIds.length; index++) {
        final row = byId[orderedIds[index]]!;
        if (row.sortOrder == index) continue;
        final version = row.version + 1;
        await (_database.update(_database.workoutSplits)..where(
              (candidate) =>
                  candidate.id.equals(row.id) & candidate.userId.equals(owner),
            ))
            .write(
              WorkoutSplitsCompanion(
                sortOrder: Value(index),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.workoutSplit,
          entityId: row.id,
          entityVersion: version,
          now: now,
        );
      }
    });
  }

  Future<WorkoutSplit> duplicateSplit({
    required String userId,
    required String splitId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(splitId, 'splitId');
    return _database.transaction(() async {
      final source = await _requireActiveSplit(owner, id);
      final now = _now();
      final copy = WorkoutSplit(
        id: _newId(),
        userId: owner,
        name: _copyName(source.name, 100),
        description: source.description,
        icon: source.icon,
        colorValue: source.colorValue,
        sortOrder: await _nextSplitOrder(owner),
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _insertSplit(copy);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutSplit,
        entityId: copy.id,
        entityVersion: 1,
        now: now,
      );

      final templates =
          await (_database.select(_database.workoutTemplates)
                ..where(
                  (row) =>
                      row.userId.equals(owner) &
                      row.splitId.equals(source.id) &
                      row.deletedAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      for (var index = 0; index < templates.length; index++) {
        await _copyTemplateBundle(
          source: _templateFromRow(templates[index]),
          destinationSplitId: copy.id,
          destinationSortOrder: index,
          now: now,
          appendCopySuffix: false,
        );
      }
      return copy;
    });
  }

  /// Soft-deletes a split after moving every template to [destinationSplitId].
  /// A null destination is the permanent, virtual "No Split" section.
  Future<void> deleteSplit({
    required String userId,
    required String splitId,
    String? destinationSplitId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(splitId, 'splitId');
    final destination = destinationSplitId == null
        ? null
        : _validatedId(destinationSplitId, 'destinationSplitId');
    if (destination == id) {
      throw ArgumentError.value(
        destinationSplitId,
        'destinationSplitId',
        'Templates must be moved to No Split or a different split.',
      );
    }

    await _database.transaction(() async {
      final split = await _requireActiveSplit(owner, id);
      if (destination != null) {
        await _requireActiveSplit(owner, destination);
      }
      final templates =
          await (_database.select(_database.workoutTemplates)
                ..where(
                  (row) =>
                      row.userId.equals(owner) &
                      row.splitId.equals(id) &
                      row.deletedAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      var nextOrder = await _nextTemplateOrder(owner, destination);
      final now = _now();
      for (final template in templates) {
        final version = template.version + 1;
        await (_database.update(_database.workoutTemplates)..where(
              (row) => row.id.equals(template.id) & row.userId.equals(owner),
            ))
            .write(
              WorkoutTemplatesCompanion(
                splitId: Value(destination),
                sortOrder: Value(nextOrder++),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.workoutTemplate,
          entityId: template.id,
          entityVersion: version,
          now: now,
        );
      }

      final deletedVersion = split.version + 1;
      await (_database.update(
        _database.workoutSplits,
      )..where((row) => row.id.equals(id) & row.userId.equals(owner))).write(
        WorkoutSplitsCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(deletedVersion),
        ),
      );
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutSplit,
        entityId: id,
        entityVersion: deletedVersion,
        now: now,
      );
    });
  }

  Future<WorkoutTemplate> createTemplate({
    required String userId,
    required String name,
    String? splitId,
    String icon = 'workout',
    int colorValue = 0xFF169BFF,
    String? notes,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final destination = splitId == null
        ? null
        : _validatedId(splitId, 'splitId');
    final validatedName = _requiredText(name, 'name', 100);
    final validatedIcon = _requiredText(icon, 'icon', 16);
    final validatedNotes = _optionalText(notes, 'notes', 4000);
    _validateColor(colorValue);

    return _database.transaction(() async {
      if (destination != null) {
        await _requireActiveSplit(owner, destination);
      }
      final now = _now();
      final template = WorkoutTemplate(
        id: _newId(),
        userId: owner,
        splitId: destination,
        name: validatedName,
        icon: validatedIcon,
        colorValue: colorValue,
        notes: validatedNotes,
        sortOrder: await _nextTemplateOrder(owner, destination),
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _insertTemplate(template);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutTemplate,
        entityId: template.id,
        entityVersion: 1,
        now: now,
      );
      return template;
    });
  }

  Future<WorkoutTemplate> updateTemplate({
    required String userId,
    required String templateId,
    required String name,
    required String? splitId,
    required String icon,
    required int colorValue,
    required String? notes,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateId, 'templateId');
    final destination = splitId == null
        ? null
        : _validatedId(splitId, 'splitId');
    final validatedName = _requiredText(name, 'name', 100);
    final validatedIcon = _requiredText(icon, 'icon', 16);
    final validatedNotes = _optionalText(notes, 'notes', 4000);
    _validateColor(colorValue);

    return _database.transaction(() async {
      final current = await _requireActiveTemplate(owner, id);
      if (destination != null) {
        await _requireActiveSplit(owner, destination);
      }
      final moved = current.splitId != destination;
      final now = _now();
      final updated = WorkoutTemplate(
        id: current.id,
        userId: current.userId,
        splitId: destination,
        name: validatedName,
        icon: validatedIcon,
        colorValue: colorValue,
        notes: validatedNotes,
        sortOrder: moved
            ? await _nextTemplateOrder(owner, destination)
            : current.sortOrder,
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateTemplateRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutTemplate,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      if (moved) {
        await _normalizeTemplateOrder(owner, current.splitId, now);
      }
      return updated;
    });
  }

  Future<WorkoutTemplate> renameTemplate({
    required String userId,
    required String templateId,
    required String name,
  }) async {
    final current = await _requireActiveTemplate(
      _validatedId(userId, 'userId'),
      _validatedId(templateId, 'templateId'),
    );
    return updateTemplate(
      userId: userId,
      templateId: templateId,
      name: name,
      splitId: current.splitId,
      icon: current.icon,
      colorValue: current.colorValue,
      notes: current.notes,
    );
  }

  Future<WorkoutTemplate> moveTemplate({
    required String userId,
    required String templateId,
    String? destinationSplitId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateId, 'templateId');
    final destination = destinationSplitId == null
        ? null
        : _validatedId(destinationSplitId, 'destinationSplitId');
    return _database.transaction(() async {
      final current = await _requireActiveTemplate(owner, id);
      if (destination != null) {
        await _requireActiveSplit(owner, destination);
      }
      if (current.splitId == destination) {
        return current;
      }
      final now = _now();
      final updated = WorkoutTemplate(
        id: current.id,
        userId: owner,
        splitId: destination,
        name: current.name,
        icon: current.icon,
        colorValue: current.colorValue,
        notes: current.notes,
        sortOrder: await _nextTemplateOrder(owner, destination),
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateTemplateRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutTemplate,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      await _normalizeTemplateOrder(owner, current.splitId, now);
      return updated;
    });
  }

  Future<void> reorderTemplates({
    required String userId,
    required String? splitId,
    required List<String> orderedTemplateIds,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final group = splitId == null ? null : _validatedId(splitId, 'splitId');
    final orderedIds = orderedTemplateIds
        .map((id) => _validatedId(id, 'templateId'))
        .toList(growable: false);
    _requireUniqueIds(orderedIds, 'orderedTemplateIds');
    await _database.transaction(() async {
      if (group != null) {
        await _requireActiveSplit(owner, group);
      }
      final rows = await _activeTemplateRows(owner, group);
      _requireCompleteReorder(
        expectedIds: rows.map((row) => row.id),
        orderedIds: orderedIds,
        field: 'orderedTemplateIds',
      );
      final byId = {for (final row in rows) row.id: row};
      final now = _now();
      for (var index = 0; index < orderedIds.length; index++) {
        final row = byId[orderedIds[index]]!;
        if (row.sortOrder == index) continue;
        final version = row.version + 1;
        await (_database.update(_database.workoutTemplates)..where(
              (candidate) =>
                  candidate.id.equals(row.id) & candidate.userId.equals(owner),
            ))
            .write(
              WorkoutTemplatesCompanion(
                sortOrder: Value(index),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.workoutTemplate,
          entityId: row.id,
          entityVersion: version,
          now: now,
        );
      }
    });
  }

  Future<WorkoutTemplate> duplicateTemplate({
    required String userId,
    required String templateId,
    String? destinationSplitId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateId, 'templateId');
    return _database.transaction(() async {
      final source = await _requireActiveTemplate(owner, id);
      final destination = destinationSplitId == null
          ? source.splitId
          : _validatedId(destinationSplitId, 'destinationSplitId');
      if (destination != null) {
        await _requireActiveSplit(owner, destination);
      }
      return _copyTemplateBundle(
        source: source,
        destinationSplitId: destination,
        destinationSortOrder: await _nextTemplateOrder(owner, destination),
        now: _now(),
      );
    });
  }

  Future<void> deleteTemplate({
    required String userId,
    required String templateId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateId, 'templateId');
    await _database.transaction(() async {
      final template = await _requireActiveTemplate(owner, id);
      final now = _now();
      final entries =
          await (_database.select(_database.templateExercises)..where(
                (row) =>
                    row.userId.equals(owner) &
                    row.templateId.equals(id) &
                    row.deletedAt.isNull(),
              ))
              .get();
      for (final entry in entries) {
        final version = entry.version + 1;
        await (_database.update(_database.templateExercises)..where(
              (row) => row.id.equals(entry.id) & row.userId.equals(owner),
            ))
            .write(
              TemplateExercisesCompanion(
                deletedAt: Value(now),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.templateExercise,
          entityId: entry.id,
          entityVersion: version,
          now: now,
        );
      }

      final deletedVersion = template.version + 1;
      await (_database.update(
        _database.workoutTemplates,
      )..where((row) => row.id.equals(id) & row.userId.equals(owner))).write(
        WorkoutTemplatesCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(deletedVersion),
        ),
      );
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.workoutTemplate,
        entityId: id,
        entityVersion: deletedVersion,
        now: now,
      );
      await _normalizeTemplateOrder(owner, template.splitId, now);
    });
  }

  Future<CustomExercise> createCustomExercise({
    required String userId,
    required String name,
    required MuscleGroup primaryMuscleGroup,
    Iterable<MuscleGroup> secondaryMuscleGroups = const [],
    required ExerciseEquipment equipment,
    Iterable<String> aliases = const [],
    Iterable<String> keywords = const [],
    String? instructions,
    String? personalNotes,
    bool isFavourite = false,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final validatedName = _requiredText(name, 'name', 120);
    final validatedInstructions = _optionalText(
      instructions,
      'instructions',
      8000,
    );
    final validatedNotes = _optionalText(personalNotes, 'personalNotes', 4000);
    final secondary = _validatedSecondaryMuscles(
      primaryMuscleGroup,
      secondaryMuscleGroups,
    );
    final validatedAliases = _validatedSearchTerms(aliases, 'aliases');
    final validatedKeywords = _validatedSearchTerms(keywords, 'keywords');
    final now = _now();
    final exercise = CustomExercise(
      id: _newId(),
      userId: owner,
      name: validatedName,
      primaryMuscleGroup: primaryMuscleGroup,
      secondaryMuscleGroups: secondary,
      equipment: equipment,
      aliases: validatedAliases,
      keywords: validatedKeywords,
      instructions: validatedInstructions,
      personalNotes: validatedNotes,
      isFavourite: isFavourite,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

    await _database.transaction(() async {
      await _insertCustomExercise(exercise);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.customExercise,
        entityId: exercise.id,
        entityVersion: 1,
        now: now,
      );
    });
    return exercise;
  }

  Future<CustomExercise> updateCustomExercise({
    required String userId,
    required String exerciseId,
    required String name,
    required MuscleGroup primaryMuscleGroup,
    required Iterable<MuscleGroup> secondaryMuscleGroups,
    required ExerciseEquipment equipment,
    Iterable<String>? aliases,
    Iterable<String>? keywords,
    required String? instructions,
    required String? personalNotes,
    required bool isFavourite,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(exerciseId, 'exerciseId');
    final validatedName = _requiredText(name, 'name', 120);
    final validatedInstructions = _optionalText(
      instructions,
      'instructions',
      8000,
    );
    final validatedNotes = _optionalText(personalNotes, 'personalNotes', 4000);
    final secondary = _validatedSecondaryMuscles(
      primaryMuscleGroup,
      secondaryMuscleGroups,
    );
    return _database.transaction(() async {
      final current = await _requireActiveCustomExercise(owner, id);
      final now = _now();
      final validatedAliases = aliases == null
          ? current.aliases
          : _validatedSearchTerms(aliases, 'aliases');
      final validatedKeywords = keywords == null
          ? current.keywords
          : _validatedSearchTerms(keywords, 'keywords');
      final updated = CustomExercise(
        id: current.id,
        userId: current.userId,
        name: validatedName,
        primaryMuscleGroup: primaryMuscleGroup,
        secondaryMuscleGroups: secondary,
        equipment: equipment,
        aliases: validatedAliases,
        keywords: validatedKeywords,
        trackingType: current.trackingType,
        weightRelevant: current.weightRelevant,
        repetitionsRelevant: current.repetitionsRelevant,
        distanceRelevant: current.distanceRelevant,
        durationRelevant: current.durationRelevant,
        bodyweightRelevant: current.bodyweightRelevant,
        instructions: validatedInstructions,
        personalNotes: validatedNotes,
        isFavourite: isFavourite,
        lastUsedAt: current.lastUsedAt,
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateCustomExerciseRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.customExercise,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      return updated;
    });
  }

  Future<CustomExercise> setCustomExerciseFavourite({
    required String userId,
    required String exerciseId,
    required bool isFavourite,
  }) async {
    final current = await _requireActiveCustomExercise(
      _validatedId(userId, 'userId'),
      _validatedId(exerciseId, 'exerciseId'),
    );
    return updateCustomExercise(
      userId: userId,
      exerciseId: exerciseId,
      name: current.name,
      primaryMuscleGroup: current.primaryMuscleGroup,
      secondaryMuscleGroups: current.secondaryMuscleGroups,
      equipment: current.equipment,
      aliases: current.aliases,
      keywords: current.keywords,
      instructions: current.instructions,
      personalNotes: current.personalNotes,
      isFavourite: isFavourite,
    );
  }

  Future<void> deleteCustomExercise({
    required String userId,
    required String exerciseId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(exerciseId, 'exerciseId');
    await _database.transaction(() async {
      final current = await _requireActiveCustomExercise(owner, id);
      final now = _now();
      final version = current.version + 1;
      await (_database.update(
        _database.customExercises,
      )..where((row) => row.id.equals(id) & row.userId.equals(owner))).write(
        CustomExercisesCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(version),
        ),
      );
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.customExercise,
        entityId: id,
        entityVersion: version,
        now: now,
      );
    });
  }

  Future<TemplateExercise> addExerciseToTemplate({
    required String userId,
    required String templateId,
    required ExerciseSelection exercise,
    TemplateExerciseConfiguration configuration =
        const TemplateExerciseConfiguration(),
  }) async {
    final owner = _validatedId(userId, 'userId');
    final template = _validatedId(templateId, 'templateId');
    _validateConfiguration(configuration);
    return _database.transaction(() async {
      await _requireActiveTemplate(owner, template);
      final selection = await _canonicalSelection(owner, exercise);
      final now = _now();
      final entry = TemplateExercise(
        id: _newId(),
        userId: owner,
        templateId: template,
        customExerciseId: selection.customExerciseId,
        systemExerciseKey: selection.systemExerciseKey,
        exerciseName: selection.name,
        primaryMuscleGroup: selection.primaryMuscleGroup,
        equipment: selection.equipment,
        workingSets: configuration.workingSets,
        warmupSets: configuration.warmupSets,
        targetRepsMin: configuration.targetRepsMin,
        targetRepsMax: configuration.targetRepsMax,
        targetWeight: configuration.targetWeight,
        restSeconds: configuration.restSeconds,
        rpeTarget: configuration.rpeTarget,
        rirTarget: configuration.rirTarget,
        notes: _optionalText(configuration.notes, 'notes', 4000),
        sortOrder: await _nextExerciseOrder(owner, template),
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _insertTemplateExercise(entry);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.templateExercise,
        entityId: entry.id,
        entityVersion: 1,
        now: now,
      );
      if (selection.customExerciseId case final customId?) {
        await _markCustomExerciseUsed(owner, customId, now);
      }
      return entry;
    });
  }

  Future<TemplateExercise> updateTemplateExercise({
    required String userId,
    required String templateExerciseId,
    required TemplateExerciseConfiguration configuration,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateExerciseId, 'templateExerciseId');
    _validateConfiguration(configuration);
    final notes = _optionalText(configuration.notes, 'notes', 4000);
    return _database.transaction(() async {
      final current = await _requireActiveTemplateExercise(owner, id);
      await _requireActiveTemplate(owner, current.templateId);
      final now = _now();
      final updated = TemplateExercise(
        id: current.id,
        userId: current.userId,
        templateId: current.templateId,
        customExerciseId: current.customExerciseId,
        systemExerciseKey: current.systemExerciseKey,
        exerciseName: current.exerciseName,
        primaryMuscleGroup: current.primaryMuscleGroup,
        equipment: current.equipment,
        workingSets: configuration.workingSets,
        warmupSets: configuration.warmupSets,
        targetRepsMin: configuration.targetRepsMin,
        targetRepsMax: configuration.targetRepsMax,
        targetWeight: configuration.targetWeight,
        restSeconds: configuration.restSeconds,
        rpeTarget: configuration.rpeTarget,
        rirTarget: configuration.rirTarget,
        notes: notes,
        sortOrder: current.sortOrder,
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateTemplateExerciseRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.templateExercise,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      return updated;
    });
  }

  Future<TemplateExercise> replaceTemplateExercise({
    required String userId,
    required String templateExerciseId,
    required ExerciseSelection replacement,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateExerciseId, 'templateExerciseId');
    return _database.transaction(() async {
      final current = await _requireActiveTemplateExercise(owner, id);
      await _requireActiveTemplate(owner, current.templateId);
      final selection = await _canonicalSelection(owner, replacement);
      final now = _now();
      final updated = TemplateExercise(
        id: current.id,
        userId: owner,
        templateId: current.templateId,
        customExerciseId: selection.customExerciseId,
        systemExerciseKey: selection.systemExerciseKey,
        exerciseName: selection.name,
        primaryMuscleGroup: selection.primaryMuscleGroup,
        equipment: selection.equipment,
        workingSets: current.workingSets,
        warmupSets: current.warmupSets,
        targetRepsMin: current.targetRepsMin,
        targetRepsMax: current.targetRepsMax,
        targetWeight: current.targetWeight,
        restSeconds: current.restSeconds,
        rpeTarget: current.rpeTarget,
        rirTarget: current.rirTarget,
        notes: current.notes,
        sortOrder: current.sortOrder,
        createdAt: current.createdAt,
        updatedAt: now,
        version: current.version + 1,
      );
      await _updateTemplateExerciseRow(updated);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.templateExercise,
        entityId: id,
        entityVersion: updated.version,
        now: now,
      );
      if (selection.customExerciseId case final customId?) {
        await _markCustomExerciseUsed(owner, customId, now);
      }
      return updated;
    });
  }

  Future<TemplateExercise> duplicateTemplateExercise({
    required String userId,
    required String templateExerciseId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateExerciseId, 'templateExerciseId');
    return _database.transaction(() async {
      final source = await _requireActiveTemplateExercise(owner, id);
      await _requireActiveTemplate(owner, source.templateId);
      final rows = await _activeTemplateExerciseRows(owner, source.templateId);
      final now = _now();
      for (final row in rows.where((row) => row.sortOrder > source.sortOrder)) {
        final version = row.version + 1;
        await (_database.update(_database.templateExercises)..where(
              (candidate) =>
                  candidate.id.equals(row.id) & candidate.userId.equals(owner),
            ))
            .write(
              TemplateExercisesCompanion(
                sortOrder: Value(row.sortOrder + 1),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.templateExercise,
          entityId: row.id,
          entityVersion: version,
          now: now,
        );
      }

      final copy = TemplateExercise(
        id: _newId(),
        userId: owner,
        templateId: source.templateId,
        customExerciseId: source.customExerciseId,
        systemExerciseKey: source.systemExerciseKey,
        exerciseName: source.exerciseName,
        primaryMuscleGroup: source.primaryMuscleGroup,
        equipment: source.equipment,
        workingSets: source.workingSets,
        warmupSets: source.warmupSets,
        targetRepsMin: source.targetRepsMin,
        targetRepsMax: source.targetRepsMax,
        targetWeight: source.targetWeight,
        restSeconds: source.restSeconds,
        rpeTarget: source.rpeTarget,
        rirTarget: source.rirTarget,
        notes: source.notes,
        sortOrder: source.sortOrder + 1,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _insertTemplateExercise(copy);
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.templateExercise,
        entityId: copy.id,
        entityVersion: 1,
        now: now,
      );
      return copy;
    });
  }

  Future<void> removeTemplateExercise({
    required String userId,
    required String templateExerciseId,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final id = _validatedId(templateExerciseId, 'templateExerciseId');
    await _database.transaction(() async {
      final current = await _requireActiveTemplateExercise(owner, id);
      await _requireActiveTemplate(owner, current.templateId);
      final now = _now();
      final version = current.version + 1;
      await (_database.update(
        _database.templateExercises,
      )..where((row) => row.id.equals(id) & row.userId.equals(owner))).write(
        TemplateExercisesCompanion(
          deletedAt: Value(now),
          updatedAt: Value(now),
          version: Value(version),
        ),
      );
      await _enqueue(
        userId: owner,
        type: PlanningEntityType.templateExercise,
        entityId: id,
        entityVersion: version,
        now: now,
      );
      await _normalizeExerciseOrder(owner, current.templateId, now);
    });
  }

  Future<void> reorderTemplateExercises({
    required String userId,
    required String templateId,
    required List<String> orderedTemplateExerciseIds,
  }) async {
    final owner = _validatedId(userId, 'userId');
    final template = _validatedId(templateId, 'templateId');
    final orderedIds = orderedTemplateExerciseIds
        .map((id) => _validatedId(id, 'templateExerciseId'))
        .toList(growable: false);
    _requireUniqueIds(orderedIds, 'orderedTemplateExerciseIds');
    await _database.transaction(() async {
      await _requireActiveTemplate(owner, template);
      final rows = await _activeTemplateExerciseRows(owner, template);
      _requireCompleteReorder(
        expectedIds: rows.map((row) => row.id),
        orderedIds: orderedIds,
        field: 'orderedTemplateExerciseIds',
      );
      final byId = {for (final row in rows) row.id: row};
      final now = _now();
      for (var index = 0; index < orderedIds.length; index++) {
        final row = byId[orderedIds[index]]!;
        if (row.sortOrder == index) continue;
        final version = row.version + 1;
        await (_database.update(_database.templateExercises)..where(
              (candidate) =>
                  candidate.id.equals(row.id) & candidate.userId.equals(owner),
            ))
            .write(
              TemplateExercisesCompanion(
                sortOrder: Value(index),
                updatedAt: Value(now),
                version: Value(version),
              ),
            );
        await _enqueue(
          userId: owner,
          type: PlanningEntityType.templateExercise,
          entityId: row.id,
          entityVersion: version,
          now: now,
        );
      }
    });
  }

  Future<int> pendingCount(String userId) async {
    final owner = _validatedId(userId, 'userId');
    final count = _database.plannerSyncQueue.id.count();
    final query = _database.selectOnly(_database.plannerSyncQueue)
      ..addColumns([count])
      ..where(_database.plannerSyncQueue.userId.equals(owner));
    return (await query.getSingle()).read(count) ?? 0;
  }

  Future<List<PendingPlanningUpload>> pendingUploads(String userId) async {
    final owner = _validatedId(userId, 'userId');
    final queueRows =
        await (_database.select(_database.plannerSyncQueue)
              ..where((row) => row.userId.equals(owner))
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();
    final sortedRows = [...queueRows]
      ..sort((a, b) {
        final typeComparison = planningEntityTypeFromWire(a.entityType)
            .uploadPriority
            .compareTo(planningEntityTypeFromWire(b.entityType).uploadPriority);
        return typeComparison != 0
            ? typeComparison
            : a.createdAt.compareTo(b.createdAt);
      });

    final result = <PendingPlanningUpload>[];
    for (final queue in sortedRows) {
      try {
        final type = planningEntityTypeFromWire(queue.entityType);
        final entity = await _loadEntity(owner, type, queue.entityId);
        final entityVersion = _entityVersion(entity);
        if (entityVersion != queue.entityVersion) {
          // This can only happen after an interrupted transaction from a much
          // older app version. Repair the outbox before exposing the upload.
          final now = _now();
          final repaired =
              await (_database.update(_database.plannerSyncQueue)..where(
                    (row) =>
                        row.id.equals(queue.id) &
                        row.entityVersion.equals(queue.entityVersion),
                  ))
                  .write(
                    PlannerSyncQueueCompanion(
                      entityVersion: Value(entityVersion),
                      attemptCount: const Value(0),
                      lastError: const Value(null),
                      lastAttemptAt: const Value(null),
                      updatedAt: Value(now),
                    ),
                  );
          if (repaired == 0) {
            // A concurrent edit advanced this queue row after it was read.
            // Skip the stale snapshot; the coordinator will see the still-
            // pending row and run another pass.
            continue;
          }
        }
        result.add(
          PendingPlanningUpload(
            queueId: queue.id,
            userId: owner,
            entityType: type,
            entityId: queue.entityId,
            entityVersion: entityVersion,
            entity: entity,
            attemptCount: entityVersion == queue.entityVersion
                ? queue.attemptCount
                : 0,
            lastError: entityVersion == queue.entityVersion
                ? queue.lastError
                : null,
          ),
        );
      } on Object catch (error) {
        // A stale or malformed outbox row must remain durable for diagnosis,
        // but it must not prevent unrelated template exercise mutations from
        // reaching the cloud in this same pass.
        await _recordPreparationFailure(queue, error);
      }
    }
    return List.unmodifiable(result);
  }

  /// Returns the safe reason a queued record could not be materialized for
  /// upload. The record stays in SQLite; valid planning changes still upload.
  Future<String?> pendingPreparationError(String userId) async {
    final owner = _validatedId(userId, 'userId');
    final rows =
        await (_database.select(_database.plannerSyncQueue)
              ..where(
                (row) =>
                    row.userId.equals(owner) &
                    row.lastError.like('$_preparationErrorPrefix%'),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();
    return rows.isEmpty ? null : rows.first.lastError;
  }

  Future<void> upload(PendingPlanningUpload pending) async {
    final Object winner = switch (pending.entityType) {
      PlanningEntityType.workoutSplit => await _remote.upsertWorkoutSplit(
        pending.entity as WorkoutSplit,
      ),
      PlanningEntityType.workoutTemplate => await _remote.upsertWorkoutTemplate(
        pending.entity as WorkoutTemplate,
      ),
      PlanningEntityType.customExercise => await _remote.upsertCustomExercise(
        pending.entity as CustomExercise,
      ),
      PlanningEntityType.templateExercise =>
        await _remote.upsertTemplateExercise(
          pending.entity as TemplateExercise,
        ),
    };
    await _adoptUploadedWinner(pending, winner);
  }

  Future<void> _adoptUploadedWinner(
    PendingPlanningUpload pending,
    Object winner,
  ) async {
    if (_entityId(winner) != pending.entityId ||
        _entityUserId(winner) != pending.userId ||
        _entityVersion(winner) < pending.entityVersion) {
      throw StateError('Supabase returned an invalid planning sync winner.');
    }
    await _database.transaction(() async {
      final queue =
          await (_database.select(_database.plannerSyncQueue)..where(
                (row) =>
                    row.id.equals(pending.queueId) &
                    row.entityVersion.equals(pending.entityVersion),
              ))
              .getSingleOrNull();
      if (queue == null) {
        // A concurrent local edit owns the newer queue version and must win
        // locally until its own conditional cloud upload completes.
        return;
      }
      switch (winner) {
        case WorkoutSplit value:
          await _upsertSplit(value);
        case WorkoutTemplate value:
          await _upsertTemplate(value);
        case CustomExercise value:
          await _upsertCustomExercise(value);
        case TemplateExercise value:
          await _upsertTemplateExercise(value);
        default:
          throw StateError('Unsupported planning sync winner type.');
      }
    });
  }

  /// Removes only the exact version that was uploaded.
  ///
  /// If the user edited the entity during the network request, its newer queue
  /// version remains pending and will be uploaded on the next pass.
  Future<bool> completeUpload(String queueId, int uploadedEntityVersion) async {
    final removed =
        await (_database.delete(_database.plannerSyncQueue)..where(
              (row) =>
                  row.id.equals(queueId) &
                  row.entityVersion.equals(uploadedEntityVersion),
            ))
            .go();
    return removed == 1;
  }

  Future<void> recordUploadFailure(
    String queueId,
    int uploadedEntityVersion,
    String error,
  ) async {
    final row =
        await (_database.select(_database.plannerSyncQueue)..where(
              (candidate) =>
                  candidate.id.equals(queueId) &
                  candidate.entityVersion.equals(uploadedEntityVersion),
            ))
            .getSingleOrNull();
    if (row == null) return;
    final now = _now();
    await (_database.update(_database.plannerSyncQueue)..where(
          (candidate) =>
              candidate.id.equals(queueId) &
              candidate.entityVersion.equals(uploadedEntityVersion),
        ))
        .write(
          PlannerSyncQueueCompanion(
            attemptCount: Value(row.attemptCount + 1),
            lastError: Value(_boundedError(error)),
            lastAttemptAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> _recordPreparationFailure(
    PlannerSyncQueueRow queue,
    Object error,
  ) {
    final message = _boundedError(
      '$_preparationErrorPrefix ${error.runtimeType}.',
    );
    final now = _now();
    return (_database.update(_database.plannerSyncQueue)..where(
          (row) =>
              row.id.equals(queue.id) &
              row.entityVersion.equals(queue.entityVersion),
        ))
        .write(
          PlannerSyncQueueCompanion(
            attemptCount: Value(queue.attemptCount + 1),
            lastError: Value(message),
            lastAttemptAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> restore(String userId) async {
    final owner = _validatedId(userId, 'userId');
    final snapshot = await _remote.fetchSnapshot(owner);
    _validateRemoteSnapshot(snapshot, owner);
    await _database.transaction(() async {
      final pendingRows = await (_database.select(
        _database.plannerSyncQueue,
      )..where((row) => row.userId.equals(owner))).get();
      final pendingKeys = {
        for (final row in pendingRows) '${row.entityType}:${row.entityId}',
      };
      final localSplits = {
        for (final row in await (_database.select(
          _database.workoutSplits,
        )..where((candidate) => candidate.userId.equals(owner))).get())
          row.id: row.version,
      };
      final localCustomExercises = {
        for (final row in await (_database.select(
          _database.customExercises,
        )..where((candidate) => candidate.userId.equals(owner))).get())
          row.id: row.version,
      };
      final localTemplates = {
        for (final row in await (_database.select(
          _database.workoutTemplates,
        )..where((candidate) => candidate.userId.equals(owner))).get())
          row.id: row.version,
      };
      final localTemplateExercises = {
        for (final row in await (_database.select(
          _database.templateExercises,
        )..where((candidate) => candidate.userId.equals(owner))).get())
          row.id: row.version,
      };
      bool isPending(PlanningEntityType type, String id) =>
          pendingKeys.contains('${type.wireValue}:$id');
      bool isOlderThanLocal(
        String id,
        int remoteVersion,
        Map<String, int> localVersions,
      ) => (localVersions[id] ?? 0) > remoteVersion;

      // Parent-first insertion satisfies every local foreign key. Pending
      // local records win at entity granularity. The version check also closes
      // the small race where an upload clears its queue row after this restore
      // fetched an older snapshot but before the transaction starts.
      for (final split in snapshot.splits) {
        if (!isPending(PlanningEntityType.workoutSplit, split.id) &&
            !isOlderThanLocal(split.id, split.version, localSplits)) {
          await _upsertSplit(split);
        }
      }
      for (final custom in snapshot.customExercises) {
        if (!isPending(PlanningEntityType.customExercise, custom.id) &&
            !isOlderThanLocal(
              custom.id,
              custom.version,
              localCustomExercises,
            )) {
          await _upsertCustomExercise(custom);
        }
      }
      for (final template in snapshot.templates) {
        if (!isPending(PlanningEntityType.workoutTemplate, template.id) &&
            !isOlderThanLocal(template.id, template.version, localTemplates)) {
          await _upsertTemplate(template);
        }
      }
      for (final entry in snapshot.templateExercises) {
        if (!isPending(PlanningEntityType.templateExercise, entry.id) &&
            !isOlderThanLocal(
              entry.id,
              entry.version,
              localTemplateExercises,
            )) {
          await _upsertTemplateExercise(entry);
        }
      }
    });
  }

  Future<void> _insertSplit(WorkoutSplit split) {
    return _database
        .into(_database.workoutSplits)
        .insert(_splitCompanion(split));
  }

  Future<void> _upsertSplit(WorkoutSplit split) {
    return _database
        .into(_database.workoutSplits)
        .insertOnConflictUpdate(_splitCompanion(split));
  }

  Future<void> _updateSplitRow(WorkoutSplit split) => _upsertSplit(split);

  WorkoutSplitsCompanion _splitCompanion(WorkoutSplit split) {
    return WorkoutSplitsCompanion.insert(
      id: split.id,
      userId: split.userId,
      name: split.name,
      description: Value(split.description),
      icon: split.icon,
      colorValue: split.colorValue,
      sortOrder: Value(split.sortOrder),
      createdAt: split.createdAt,
      updatedAt: split.updatedAt,
      deletedAt: Value(split.deletedAt),
      version: Value(split.version),
    );
  }

  Future<void> _insertTemplate(WorkoutTemplate template) {
    return _database
        .into(_database.workoutTemplates)
        .insert(_templateCompanion(template));
  }

  Future<void> _upsertTemplate(WorkoutTemplate template) {
    return _database
        .into(_database.workoutTemplates)
        .insertOnConflictUpdate(_templateCompanion(template));
  }

  Future<void> _updateTemplateRow(WorkoutTemplate template) =>
      _upsertTemplate(template);

  WorkoutTemplatesCompanion _templateCompanion(WorkoutTemplate template) {
    return WorkoutTemplatesCompanion.insert(
      id: template.id,
      userId: template.userId,
      splitId: Value(template.splitId),
      name: template.name,
      icon: template.icon,
      colorValue: template.colorValue,
      notes: Value(template.notes),
      sortOrder: Value(template.sortOrder),
      createdAt: template.createdAt,
      updatedAt: template.updatedAt,
      deletedAt: Value(template.deletedAt),
      version: Value(template.version),
    );
  }

  Future<void> _insertCustomExercise(CustomExercise exercise) {
    return _database
        .into(_database.customExercises)
        .insert(_customExerciseCompanion(exercise));
  }

  Future<void> _upsertCustomExercise(CustomExercise exercise) {
    return _database
        .into(_database.customExercises)
        .insertOnConflictUpdate(_customExerciseCompanion(exercise));
  }

  Future<void> _updateCustomExerciseRow(CustomExercise exercise) =>
      _upsertCustomExercise(exercise);

  CustomExercisesCompanion _customExerciseCompanion(CustomExercise exercise) {
    return CustomExercisesCompanion.insert(
      id: exercise.id,
      userId: exercise.userId,
      name: exercise.name,
      primaryMuscleGroup: exercise.primaryMuscleGroup.wireValue,
      secondaryMuscleGroupsJson: Value(
        jsonEncode([
          for (final group in exercise.secondaryMuscleGroups) group.wireValue,
        ]),
      ),
      equipment: exercise.equipment.wireValue,
      aliasesJson: Value(jsonEncode(exercise.aliases)),
      searchKeywordsJson: Value(jsonEncode(exercise.keywords)),
      instructions: Value(exercise.instructions),
      personalNotes: Value(exercise.personalNotes),
      isFavourite: Value(exercise.isFavourite),
      lastUsedAt: Value(exercise.lastUsedAt),
      createdAt: exercise.createdAt,
      updatedAt: exercise.updatedAt,
      deletedAt: Value(exercise.deletedAt),
      version: Value(exercise.version),
    );
  }

  Future<void> _insertTemplateExercise(TemplateExercise exercise) {
    return _database
        .into(_database.templateExercises)
        .insert(_templateExerciseCompanion(exercise));
  }

  Future<void> _upsertTemplateExercise(TemplateExercise exercise) {
    return _database
        .into(_database.templateExercises)
        .insertOnConflictUpdate(_templateExerciseCompanion(exercise));
  }

  Future<void> _updateTemplateExerciseRow(TemplateExercise exercise) =>
      _upsertTemplateExercise(exercise);

  TemplateExercisesCompanion _templateExerciseCompanion(
    TemplateExercise exercise,
  ) {
    return TemplateExercisesCompanion.insert(
      id: exercise.id,
      userId: exercise.userId,
      templateId: exercise.templateId,
      customExerciseId: Value(exercise.customExerciseId),
      systemExerciseKey: Value(exercise.systemExerciseKey),
      exerciseName: exercise.exerciseName,
      primaryMuscleGroup: exercise.primaryMuscleGroup.wireValue,
      equipment: exercise.equipment.wireValue,
      workingSets: Value(exercise.workingSets),
      warmupSets: Value(exercise.warmupSets),
      targetRepsMin: Value(exercise.targetRepsMin),
      targetRepsMax: Value(exercise.targetRepsMax),
      targetWeight: Value(exercise.targetWeight),
      restSeconds: Value(exercise.restSeconds),
      rpeTarget: Value(exercise.rpeTarget),
      rirTarget: Value(exercise.rirTarget),
      notes: Value(exercise.notes),
      sortOrder: Value(exercise.sortOrder),
      createdAt: exercise.createdAt,
      updatedAt: exercise.updatedAt,
      deletedAt: Value(exercise.deletedAt),
      version: Value(exercise.version),
    );
  }

  Future<void> _enqueue({
    required String userId,
    required PlanningEntityType type,
    required String entityId,
    required int entityVersion,
    required DateTime now,
  }) async {
    final existing =
        await (_database.select(_database.plannerSyncQueue)..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.entityType.equals(type.wireValue) &
                  row.entityId.equals(entityId),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await _database
          .into(_database.plannerSyncQueue)
          .insert(
            PlannerSyncQueueCompanion.insert(
              id: _newId(),
              userId: userId,
              entityType: type.wireValue,
              entityId: entityId,
              entityVersion: entityVersion,
              createdAt: now,
              updatedAt: now,
            ),
          );
      return;
    }
    await (_database.update(
      _database.plannerSyncQueue,
    )..where((row) => row.id.equals(existing.id))).write(
      PlannerSyncQueueCompanion(
        entityVersion: Value(entityVersion),
        attemptCount: const Value(0),
        lastError: const Value(null),
        lastAttemptAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<Object> _loadEntity(
    String userId,
    PlanningEntityType type,
    String entityId,
  ) async {
    switch (type) {
      case PlanningEntityType.workoutSplit:
        final row =
            await (_database.select(_database.workoutSplits)..where(
                  (candidate) =>
                      candidate.id.equals(entityId) &
                      candidate.userId.equals(userId),
                ))
                .getSingleOrNull();
        if (row != null) return _splitFromRow(row);
      case PlanningEntityType.workoutTemplate:
        final row =
            await (_database.select(_database.workoutTemplates)..where(
                  (candidate) =>
                      candidate.id.equals(entityId) &
                      candidate.userId.equals(userId),
                ))
                .getSingleOrNull();
        if (row != null) return _templateFromRow(row);
      case PlanningEntityType.customExercise:
        final row =
            await (_database.select(_database.customExercises)..where(
                  (candidate) =>
                      candidate.id.equals(entityId) &
                      candidate.userId.equals(userId),
                ))
                .getSingleOrNull();
        if (row != null) return _customExerciseFromRow(row);
      case PlanningEntityType.templateExercise:
        final row =
            await (_database.select(_database.templateExercises)..where(
                  (candidate) =>
                      candidate.id.equals(entityId) &
                      candidate.userId.equals(userId),
                ))
                .getSingleOrNull();
        if (row != null) return _templateExerciseFromRow(row);
    }
    throw StateError(
      'A pending ${type.wireValue} record is missing from local storage.',
    );
  }

  int _entityVersion(Object entity) => switch (entity) {
    WorkoutSplit value => value.version,
    WorkoutTemplate value => value.version,
    CustomExercise value => value.version,
    TemplateExercise value => value.version,
    _ => throw StateError('Unsupported planning entity type.'),
  };

  String _entityId(Object entity) => switch (entity) {
    WorkoutSplit value => value.id,
    WorkoutTemplate value => value.id,
    CustomExercise value => value.id,
    TemplateExercise value => value.id,
    _ => throw StateError('Unsupported planning entity type.'),
  };

  String _entityUserId(Object entity) => switch (entity) {
    WorkoutSplit value => value.userId,
    WorkoutTemplate value => value.userId,
    CustomExercise value => value.userId,
    TemplateExercise value => value.userId,
    _ => throw StateError('Unsupported planning entity type.'),
  };

  Future<WorkoutSplit> _requireActiveSplit(
    String userId,
    String splitId,
  ) async {
    final row =
        await (_database.select(_database.workoutSplits)..where(
              (candidate) =>
                  candidate.id.equals(splitId) &
                  candidate.userId.equals(userId) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Workout split was not found for this user.');
    }
    return _splitFromRow(row);
  }

  Future<WorkoutTemplate> _requireActiveTemplate(
    String userId,
    String templateId,
  ) async {
    final row =
        await (_database.select(_database.workoutTemplates)..where(
              (candidate) =>
                  candidate.id.equals(templateId) &
                  candidate.userId.equals(userId) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Workout template was not found for this user.');
    }
    return _templateFromRow(row);
  }

  Future<CustomExercise> _requireActiveCustomExercise(
    String userId,
    String exerciseId,
  ) async {
    final row =
        await (_database.select(_database.customExercises)..where(
              (candidate) =>
                  candidate.id.equals(exerciseId) &
                  candidate.userId.equals(userId) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Custom exercise was not found for this user.');
    }
    return _customExerciseFromRow(row);
  }

  Future<TemplateExercise> _requireActiveTemplateExercise(
    String userId,
    String exerciseId,
  ) async {
    final row =
        await (_database.select(_database.templateExercises)..where(
              (candidate) =>
                  candidate.id.equals(exerciseId) &
                  candidate.userId.equals(userId) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw StateError('Template exercise was not found for this user.');
    }
    return _templateExerciseFromRow(row);
  }

  Future<List<WorkoutTemplateRow>> _activeTemplateRows(
    String userId,
    String? splitId,
  ) {
    final query = _database.select(_database.workoutTemplates)
      ..where(
        (row) =>
            row.userId.equals(userId) &
            row.deletedAt.isNull() &
            (splitId == null
                ? row.splitId.isNull()
                : row.splitId.equals(splitId)),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.createdAt),
      ]);
    return query.get();
  }

  Future<List<TemplateExerciseRow>> _activeTemplateExerciseRows(
    String userId,
    String templateId,
  ) {
    final query = _database.select(_database.templateExercises)
      ..where(
        (row) =>
            row.userId.equals(userId) &
            row.templateId.equals(templateId) &
            row.deletedAt.isNull(),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.sortOrder),
        (row) => OrderingTerm.asc(row.createdAt),
      ]);
    return query.get();
  }

  Future<int> _nextSplitOrder(String userId) async {
    final rows =
        await (_database.select(_database.workoutSplits)..where(
              (row) => row.userId.equals(userId) & row.deletedAt.isNull(),
            ))
            .get();
    return _nextOrder(rows.map((row) => row.sortOrder));
  }

  Future<int> _nextTemplateOrder(String userId, String? splitId) async {
    final rows = await _activeTemplateRows(userId, splitId);
    return _nextOrder(rows.map((row) => row.sortOrder));
  }

  Future<int> _nextExerciseOrder(String userId, String templateId) async {
    final rows = await _activeTemplateExerciseRows(userId, templateId);
    return _nextOrder(rows.map((row) => row.sortOrder));
  }

  Future<void> _normalizeTemplateOrder(
    String userId,
    String? splitId,
    DateTime now,
  ) async {
    final rows = await _activeTemplateRows(userId, splitId);
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      if (row.sortOrder == index) continue;
      final version = row.version + 1;
      await (_database.update(_database.workoutTemplates)..where(
            (candidate) =>
                candidate.id.equals(row.id) & candidate.userId.equals(userId),
          ))
          .write(
            WorkoutTemplatesCompanion(
              sortOrder: Value(index),
              updatedAt: Value(now),
              version: Value(version),
            ),
          );
      await _enqueue(
        userId: userId,
        type: PlanningEntityType.workoutTemplate,
        entityId: row.id,
        entityVersion: version,
        now: now,
      );
    }
  }

  Future<void> _normalizeExerciseOrder(
    String userId,
    String templateId,
    DateTime now,
  ) async {
    final rows = await _activeTemplateExerciseRows(userId, templateId);
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      if (row.sortOrder == index) continue;
      final version = row.version + 1;
      await (_database.update(_database.templateExercises)..where(
            (candidate) =>
                candidate.id.equals(row.id) & candidate.userId.equals(userId),
          ))
          .write(
            TemplateExercisesCompanion(
              sortOrder: Value(index),
              updatedAt: Value(now),
              version: Value(version),
            ),
          );
      await _enqueue(
        userId: userId,
        type: PlanningEntityType.templateExercise,
        entityId: row.id,
        entityVersion: version,
        now: now,
      );
    }
  }

  Future<WorkoutTemplate> _copyTemplateBundle({
    required WorkoutTemplate source,
    required String? destinationSplitId,
    required int destinationSortOrder,
    required DateTime now,
    bool appendCopySuffix = true,
  }) async {
    final copy = WorkoutTemplate(
      id: _newId(),
      userId: source.userId,
      splitId: destinationSplitId,
      name: appendCopySuffix ? _copyName(source.name, 100) : source.name,
      icon: source.icon,
      colorValue: source.colorValue,
      notes: source.notes,
      sortOrder: destinationSortOrder,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    await _insertTemplate(copy);
    await _enqueue(
      userId: source.userId,
      type: PlanningEntityType.workoutTemplate,
      entityId: copy.id,
      entityVersion: 1,
      now: now,
    );

    final sourceEntries = await _activeTemplateExerciseRows(
      source.userId,
      source.id,
    );
    for (var index = 0; index < sourceEntries.length; index++) {
      final sourceEntry = _templateExerciseFromRow(sourceEntries[index]);
      final copyEntry = TemplateExercise(
        id: _newId(),
        userId: source.userId,
        templateId: copy.id,
        customExerciseId: sourceEntry.customExerciseId,
        systemExerciseKey: sourceEntry.systemExerciseKey,
        exerciseName: sourceEntry.exerciseName,
        primaryMuscleGroup: sourceEntry.primaryMuscleGroup,
        equipment: sourceEntry.equipment,
        workingSets: sourceEntry.workingSets,
        warmupSets: sourceEntry.warmupSets,
        targetRepsMin: sourceEntry.targetRepsMin,
        targetRepsMax: sourceEntry.targetRepsMax,
        targetWeight: sourceEntry.targetWeight,
        restSeconds: sourceEntry.restSeconds,
        rpeTarget: sourceEntry.rpeTarget,
        rirTarget: sourceEntry.rirTarget,
        notes: sourceEntry.notes,
        sortOrder: index,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _insertTemplateExercise(copyEntry);
      await _enqueue(
        userId: source.userId,
        type: PlanningEntityType.templateExercise,
        entityId: copyEntry.id,
        entityVersion: 1,
        now: now,
      );
    }
    return copy;
  }

  Future<ExerciseSelection> _canonicalSelection(
    String userId,
    ExerciseSelection selection,
  ) async {
    switch (selection.source) {
      case ExerciseSource.system:
        final key = _requiredText(
          selection.exerciseId,
          'systemExerciseKey',
          160,
        );
        final canonical = SystemExerciseCatalog.byKey(key);
        if (canonical == null) {
          throw ArgumentError.value(
            key,
            'exercise',
            'Unknown system exercise.',
          );
        }
        return canonical;
      case ExerciseSource.custom:
        final custom = await _requireActiveCustomExercise(
          userId,
          _validatedId(selection.exerciseId, 'customExerciseId'),
        );
        return custom.selection;
    }
  }

  Future<void> _markCustomExerciseUsed(
    String userId,
    String exerciseId,
    DateTime now,
  ) async {
    final current = await _requireActiveCustomExercise(userId, exerciseId);
    final version = current.version + 1;
    await (_database.update(_database.customExercises)..where(
          (row) => row.id.equals(exerciseId) & row.userId.equals(userId),
        ))
        .write(
          CustomExercisesCompanion(
            lastUsedAt: Value(now),
            updatedAt: Value(now),
            version: Value(version),
          ),
        );
    await _enqueue(
      userId: userId,
      type: PlanningEntityType.customExercise,
      entityId: exerciseId,
      entityVersion: version,
      now: now,
    );
  }

  WorkoutSplit _splitFromRow(WorkoutSplitRow row) {
    return WorkoutSplit(
      id: row.id,
      userId: row.userId,
      name: row.name,
      description: row.description,
      icon: row.icon,
      colorValue: row.colorValue,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
      deletedAt: row.deletedAt?.toUtc(),
      version: row.version,
    );
  }

  WorkoutTemplate _templateFromRow(WorkoutTemplateRow row) {
    return WorkoutTemplate(
      id: row.id,
      userId: row.userId,
      splitId: row.splitId,
      name: row.name,
      icon: row.icon,
      colorValue: row.colorValue,
      notes: row.notes,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
      deletedAt: row.deletedAt?.toUtc(),
      version: row.version,
    );
  }

  CustomExercise _customExerciseFromRow(CustomExerciseRow row) {
    final decoded = jsonDecode(row.secondaryMuscleGroupsJson);
    if (decoded is! List) {
      throw const FormatException(
        'Invalid locally stored secondary muscle groups.',
      );
    }
    final aliases = _decodeStringList(row.aliasesJson, 'aliases');
    final keywords = _decodeStringList(
      row.searchKeywordsJson,
      'search keywords',
    );
    return CustomExercise(
      id: row.id,
      userId: row.userId,
      name: row.name,
      primaryMuscleGroup: muscleGroupFromWire(row.primaryMuscleGroup),
      secondaryMuscleGroups: decoded.map((value) {
        if (value is! String) {
          throw const FormatException(
            'Invalid locally stored secondary muscle group.',
          );
        }
        return muscleGroupFromWire(value);
      }),
      equipment: exerciseEquipmentFromWire(row.equipment),
      aliases: aliases,
      keywords: keywords,
      instructions: row.instructions,
      personalNotes: row.personalNotes,
      isFavourite: row.isFavourite,
      lastUsedAt: row.lastUsedAt?.toUtc(),
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
      deletedAt: row.deletedAt?.toUtc(),
      version: row.version,
    );
  }

  List<String> _decodeStringList(String encoded, String field) {
    final decoded = jsonDecode(encoded);
    if (decoded is! List || decoded.any((value) => value is! String)) {
      throw FormatException('Invalid locally stored $field.');
    }
    return decoded.cast<String>();
  }

  TemplateExercise _templateExerciseFromRow(TemplateExerciseRow row) {
    return TemplateExercise(
      id: row.id,
      userId: row.userId,
      templateId: row.templateId,
      customExerciseId: row.customExerciseId,
      systemExerciseKey: row.systemExerciseKey,
      exerciseName: row.exerciseName,
      primaryMuscleGroup: muscleGroupFromWire(row.primaryMuscleGroup),
      equipment: exerciseEquipmentFromWire(row.equipment),
      workingSets: row.workingSets,
      warmupSets: row.warmupSets,
      targetRepsMin: row.targetRepsMin,
      targetRepsMax: row.targetRepsMax,
      targetWeight: row.targetWeight,
      restSeconds: row.restSeconds,
      rpeTarget: row.rpeTarget,
      rirTarget: row.rirTarget,
      notes: row.notes,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt.toUtc(),
      updatedAt: row.updatedAt.toUtc(),
      deletedAt: row.deletedAt?.toUtc(),
      version: row.version,
    );
  }

  void _validateRemoteSnapshot(PlanningSnapshot snapshot, String userId) {
    void requireOwner(String actual, String type) {
      if (actual != userId) {
        throw StateError(
          'Remote $type ownership did not match the signed-in user.',
        );
      }
    }

    final splitIds = <String>{};
    for (final split in snapshot.splits) {
      requireOwner(split.userId, 'workout split');
      _validatedId(split.id, 'remote split id');
      _validateVersion(split.version);
      if (!splitIds.add(split.id)) {
        throw StateError('Remote workout split IDs were duplicated.');
      }
    }
    final customIds = <String>{};
    for (final custom in snapshot.customExercises) {
      requireOwner(custom.userId, 'custom exercise');
      _validatedId(custom.id, 'remote custom exercise id');
      _validateVersion(custom.version);
      if (!customIds.add(custom.id)) {
        throw StateError('Remote custom exercise IDs were duplicated.');
      }
    }
    final templateIds = <String>{};
    for (final template in snapshot.templates) {
      requireOwner(template.userId, 'workout template');
      _validatedId(template.id, 'remote template id');
      _validateVersion(template.version);
      if (template.splitId case final splitId?) {
        if (!splitIds.contains(splitId)) {
          throw StateError('Remote template referenced an unknown split.');
        }
      }
      if (!templateIds.add(template.id)) {
        throw StateError('Remote workout template IDs were duplicated.');
      }
    }
    final entryIds = <String>{};
    for (final entry in snapshot.templateExercises) {
      requireOwner(entry.userId, 'template exercise');
      _validatedId(entry.id, 'remote template exercise id');
      _validateVersion(entry.version);
      if (!templateIds.contains(entry.templateId)) {
        throw StateError(
          'Remote template exercise referenced an unknown template.',
        );
      }
      final customId = entry.customExerciseId;
      final systemKey = entry.systemExerciseKey;
      if ((customId == null) == (systemKey == null)) {
        throw StateError(
          'Remote template exercise had an invalid exercise source.',
        );
      }
      if (customId != null && !customIds.contains(customId)) {
        throw StateError(
          'Remote template exercise referenced an unknown custom exercise.',
        );
      }
      _validateConfiguration(entry.configuration);
      if (!entryIds.add(entry.id)) {
        throw StateError('Remote template exercise IDs were duplicated.');
      }
    }
  }

  void _validateConfiguration(TemplateExerciseConfiguration configuration) {
    if (configuration.workingSets < 1 || configuration.workingSets > 100) {
      throw ArgumentError.value(
        configuration.workingSets,
        'workingSets',
        'Working sets must be between 1 and 100.',
      );
    }
    if (configuration.warmupSets < 0 || configuration.warmupSets > 100) {
      throw ArgumentError.value(
        configuration.warmupSets,
        'warmupSets',
        'Warm-up sets must be between 0 and 100.',
      );
    }
    if (configuration.targetRepsMin < 1 ||
        configuration.targetRepsMax < configuration.targetRepsMin ||
        configuration.targetRepsMax > 1000) {
      throw ArgumentError(
        'The target rep range must be ordered and between 1 and 1000.',
      );
    }
    _validateOptionalNumber(
      configuration.targetWeight,
      'targetWeight',
      minimum: 0,
      maximum: 9999999.999,
      decimalPlaces: 3,
    );
    if (configuration.restSeconds < 0 || configuration.restSeconds > 7200) {
      throw ArgumentError.value(
        configuration.restSeconds,
        'restSeconds',
        'Rest must be between 0 and 7200 seconds.',
      );
    }
    _validateOptionalNumber(
      configuration.rpeTarget,
      'rpeTarget',
      minimum: 1,
      maximum: 10,
      decimalPlaces: 1,
    );
    _validateOptionalNumber(
      configuration.rirTarget,
      'rirTarget',
      minimum: 0,
      maximum: 10,
      decimalPlaces: 1,
    );
    _optionalText(configuration.notes, 'notes', 4000);
  }

  void _validateOptionalNumber(
    double? value,
    String field, {
    required double minimum,
    double? maximum,
    int? decimalPlaces,
  }) {
    if (value == null) return;
    if (!value.isFinite ||
        value < minimum ||
        (maximum != null && value > maximum)) {
      throw ArgumentError.value(value, field, 'Invalid numeric target.');
    }
    if (decimalPlaces case final places?) {
      var scale = 1.0;
      for (var index = 0; index < places; index++) {
        scale *= 10;
      }
      final scaled = value * scale;
      if ((scaled - scaled.round()).abs() > 0.000001) {
        throw ArgumentError.value(
          value,
          field,
          'Use no more than $places decimal places.',
        );
      }
    }
  }

  List<MuscleGroup> _validatedSecondaryMuscles(
    MuscleGroup primary,
    Iterable<MuscleGroup> groups,
  ) {
    final unique = <MuscleGroup>[];
    for (final group in groups) {
      if (group != primary && !unique.contains(group)) {
        unique.add(group);
      }
    }
    if (unique.length > 14) {
      throw ArgumentError.value(
        groups,
        'secondaryMuscleGroups',
        'No more than 14 secondary muscle groups are allowed.',
      );
    }
    return List.unmodifiable(unique);
  }

  String _validatedId(String value, String field) {
    final normalized = value.trim().toLowerCase();
    if (!_uuidPattern.hasMatch(normalized)) {
      throw ArgumentError.value(value, field, 'A valid UUID is required.');
    }
    return normalized;
  }

  String _newId() => _validatedId(_idGenerator(), 'generatedId');

  DateTime _now() => _clock().toUtc();

  String _requiredText(String value, String field, int maximumLength) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.runes.length > maximumLength) {
      throw ArgumentError.value(
        value,
        field,
        'Must be between 1 and $maximumLength characters.',
      );
    }
    return normalized;
  }

  String? _optionalText(String? value, String field, int maximumLength) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim();
    if (normalized.runes.length > maximumLength) {
      throw ArgumentError.value(
        value,
        field,
        'Must not exceed $maximumLength characters.',
      );
    }
    return normalized;
  }

  List<String> _validatedSearchTerms(Iterable<String> values, String field) {
    final result = <String>[];
    final normalizedValues = <String>{};
    for (final value in values) {
      final term = value.trim();
      if (term.isEmpty) continue;
      if (term.runes.length > 80) {
        throw ArgumentError.value(
          value,
          field,
          'Each search term must not exceed 80 characters.',
        );
      }
      final normalized = normalizeExerciseSearchText(term);
      if (normalized.isNotEmpty && normalizedValues.add(normalized)) {
        result.add(term);
      }
    }
    if (result.length > 40) {
      throw ArgumentError.value(
        values,
        field,
        'No more than 40 search terms are allowed.',
      );
    }
    return List.unmodifiable(result);
  }

  void _validateColor(int value) {
    if (value < 0 || value > 0xFFFFFFFF) {
      throw ArgumentError.value(
        value,
        'colorValue',
        'Colour must be a 32-bit ARGB value.',
      );
    }
  }

  void _validateVersion(int version) {
    if (version < 1) {
      throw StateError('Remote planning versions must be positive.');
    }
  }

  void _requireUniqueIds(List<String> ids, String field) {
    if (ids.toSet().length != ids.length) {
      throw ArgumentError.value(ids, field, 'IDs must be unique.');
    }
  }

  void _requireCompleteReorder({
    required Iterable<String> expectedIds,
    required List<String> orderedIds,
    required String field,
  }) {
    final expected = expectedIds.toSet();
    if (orderedIds.length != expected.length ||
        !orderedIds.every(expected.contains)) {
      throw ArgumentError.value(
        orderedIds,
        field,
        'A reorder must include every active item in this group exactly once.',
      );
    }
  }
}

int _nextOrder(Iterable<int> orders) {
  var maximum = -1;
  for (final order in orders) {
    if (order > maximum) maximum = order;
  }
  return maximum + 1;
}

String _copyName(String name, int maximumLength) {
  const suffix = ' Copy';
  final available = maximumLength - suffix.length;
  final base = name.runes.length <= available
      ? name
      : String.fromCharCodes(name.runes.take(available));
  return '$base$suffix';
}

String _boundedError(String error) {
  final normalized = error.trim();
  final value = normalized.isEmpty ? 'Planning sync failed.' : normalized;
  return value.length <= 1000 ? value : value.substring(0, 1000);
}

const _preparationErrorPrefix =
    'Planning sync could not prepare a queued change:';

final RegExp _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);

String _generateUuid() => const Uuid().v4();

DateTime _utcNow() => DateTime.now().toUtc();
