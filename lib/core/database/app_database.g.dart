// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutsTable extends Workouts
    with TableInfo<$WorkoutsTable, WorkoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _performedAtMeta = const VerificationMeta(
    'performedAt',
  );
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
    'performed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    exerciseName,
    performedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('performed_at')) {
      context.handle(
        _performedAtMeta,
        performedAt.isAcceptableOrUnknown(
          data['performed_at']!,
          _performedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_performedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      performedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}performed_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class WorkoutRow extends DataClass implements Insertable<WorkoutRow> {
  final String id;
  final String userId;
  final String exerciseName;
  final DateTime performedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutRow({
    required this.id,
    required this.userId,
    required this.exerciseName,
    required this.performedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['performed_at'] = Variable<DateTime>(performedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      userId: Value(userId),
      exerciseName: Value(exerciseName),
      performedAt: Value(performedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutRow copyWith({
    String? id,
    String? userId,
    String? exerciseName,
    DateTime? performedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkoutRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    exerciseName: exerciseName ?? this.exerciseName,
    performedAt: performedAt ?? this.performedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutRow copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      performedAt: data.performedAt.present
          ? data.performedAt.value
          : this.performedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('performedAt: $performedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, exerciseName, performedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.exerciseName == this.exerciseName &&
          other.performedAt == this.performedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> exerciseName;
  final Value<DateTime> performedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    required String userId,
    required String exerciseName,
    required DateTime performedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       exerciseName = Value(exerciseName),
       performedAt = Value(performedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? exerciseName,
    Expression<DateTime>? performedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (performedAt != null) 'performed_at': performedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? exerciseName,
    Value<DateTime>? performedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseName: exerciseName ?? this.exerciseName,
      performedAt: performedAt ?? this.performedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('performedAt: $performedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setOrderMeta = const VerificationMeta(
    'setOrder',
  );
  @override
  late final GeneratedColumn<int> setOrder = GeneratedColumn<int>(
    'set_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    userId,
    weight,
    reps,
    setOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('set_order')) {
      context.handle(
        _setOrderMeta,
        setOrder.isAcceptableOrUnknown(data['set_order']!, _setOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutId, setOrder},
  ];
  @override
  WorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      setOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSetRow extends DataClass implements Insertable<WorkoutSetRow> {
  final String id;
  final String workoutId;
  final String userId;
  final double weight;
  final int reps;
  final int setOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutSetRow({
    required this.id,
    required this.workoutId,
    required this.userId,
    required this.weight,
    required this.reps,
    required this.setOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['user_id'] = Variable<String>(userId);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    map['set_order'] = Variable<int>(setOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      userId: Value(userId),
      weight: Value(weight),
      reps: Value(reps),
      setOrder: Value(setOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetRow(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      userId: serializer.fromJson<String>(json['userId']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      setOrder: serializer.fromJson<int>(json['setOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'userId': serializer.toJson<String>(userId),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'setOrder': serializer.toJson<int>(setOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutSetRow copyWith({
    String? id,
    String? workoutId,
    String? userId,
    double? weight,
    int? reps,
    int? setOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkoutSetRow(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    userId: userId ?? this.userId,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    setOrder: setOrder ?? this.setOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutSetRow copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSetRow(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      userId: data.userId.present ? data.userId.value : this.userId,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      setOrder: data.setOrder.present ? data.setOrder.value : this.setOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetRow(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('userId: $userId, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('setOrder: $setOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    userId,
    weight,
    reps,
    setOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetRow &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.userId == this.userId &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.setOrder == this.setOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSetRow> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> userId;
  final Value<double> weight;
  final Value<int> reps;
  final Value<int> setOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.userId = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.setOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String workoutId,
    required String userId,
    required double weight,
    required int reps,
    this.setOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       userId = Value(userId),
       weight = Value(weight),
       reps = Value(reps),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutSetRow> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? userId,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? setOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (userId != null) 'user_id': userId,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (setOrder != null) 'set_order': setOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? userId,
    Value<double>? weight,
    Value<int>? reps,
    Value<int>? setOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      setOrder: setOrder ?? this.setOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (setOrder.present) {
      map['set_order'] = Variable<int>(setOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('userId: $userId, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('setOrder: $setOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    userId,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {workoutId},
  ];
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final String id;
  final String workoutId;
  final String userId;
  final int attemptCount;
  final String? lastError;
  final DateTime? lastAttemptAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueRow({
    required this.id,
    required this.workoutId,
    required this.userId,
    required this.attemptCount,
    this.lastError,
    this.lastAttemptAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['user_id'] = Variable<String>(userId);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      userId: Value(userId),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      userId: serializer.fromJson<String>(json['userId']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'userId': serializer.toJson<String>(userId),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueRow copyWith({
    String? id,
    String? workoutId,
    String? userId,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueRow(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    userId: userId ?? this.userId,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueRow copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      userId: data.userId.present ? data.userId.value : this.userId,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('userId: $userId, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutId,
    userId,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.userId == this.userId &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> userId;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.userId = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String workoutId,
    required String userId,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       userId = Value(userId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncQueueRow> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? userId,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (userId != null) 'user_id': userId,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? userId,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      userId: userId ?? this.userId,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('userId: $userId, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSplitsTable extends WorkoutSplits
    with TableInfo<$WorkoutSplitsTable, WorkoutSplitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    description,
    icon,
    colorValue,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSplitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSplitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSplitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $WorkoutSplitsTable createAlias(String alias) {
    return $WorkoutSplitsTable(attachedDatabase, alias);
  }
}

class WorkoutSplitRow extends DataClass implements Insertable<WorkoutSplitRow> {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String icon;
  final int colorValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const WorkoutSplitRow({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.icon,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['icon'] = Variable<String>(icon);
    map['color_value'] = Variable<int>(colorValue);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  WorkoutSplitsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSplitsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: Value(icon),
      colorValue: Value(colorValue),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory WorkoutSplitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSplitRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String>(icon),
      'colorValue': serializer.toJson<int>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  WorkoutSplitRow copyWith({
    String? id,
    String? userId,
    String? name,
    Value<String?> description = const Value.absent(),
    String? icon,
    int? colorValue,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => WorkoutSplitRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    icon: icon ?? this.icon,
    colorValue: colorValue ?? this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  WorkoutSplitRow copyWithCompanion(WorkoutSplitsCompanion data) {
    return WorkoutSplitRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSplitRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    description,
    icon,
    colorValue,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSplitRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class WorkoutSplitsCompanion extends UpdateCompanion<WorkoutSplitRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> icon;
  final Value<int> colorValue;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const WorkoutSplitsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSplitsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.description = const Value.absent(),
    required String icon,
    required int colorValue,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       icon = Value(icon),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutSplitRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSplitsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? icon,
    Value<int>? colorValue,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return WorkoutSplitsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSplitsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomExercisesTable extends CustomExercises
    with TableInfo<$CustomExercisesTable, CustomExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleGroupMeta =
      const VerificationMeta('primaryMuscleGroup');
  @override
  late final GeneratedColumn<String> primaryMuscleGroup =
      GeneratedColumn<String>(
        'primary_muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _secondaryMuscleGroupsJsonMeta =
      const VerificationMeta('secondaryMuscleGroupsJson');
  @override
  late final GeneratedColumn<String> secondaryMuscleGroupsJson =
      GeneratedColumn<String>(
        'secondary_muscle_groups_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionsMeta = const VerificationMeta(
    'instructions',
  );
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
    'instructions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalNotesMeta = const VerificationMeta(
    'personalNotes',
  );
  @override
  late final GeneratedColumn<String> personalNotes = GeneratedColumn<String>(
    'personal_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aliasesJsonMeta = const VerificationMeta(
    'aliasesJson',
  );
  @override
  late final GeneratedColumn<String> aliasesJson = GeneratedColumn<String>(
    'aliases_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _searchKeywordsJsonMeta =
      const VerificationMeta('searchKeywordsJson');
  @override
  late final GeneratedColumn<String> searchKeywordsJson =
      GeneratedColumn<String>(
        'search_keywords_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _isFavouriteMeta = const VerificationMeta(
    'isFavourite',
  );
  @override
  late final GeneratedColumn<bool> isFavourite = GeneratedColumn<bool>(
    'is_favourite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favourite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    instructions,
    personalNotes,
    aliasesJson,
    searchKeywordsJson,
    isFavourite,
    lastUsedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('primary_muscle_group')) {
      context.handle(
        _primaryMuscleGroupMeta,
        primaryMuscleGroup.isAcceptableOrUnknown(
          data['primary_muscle_group']!,
          _primaryMuscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleGroupMeta);
    }
    if (data.containsKey('secondary_muscle_groups_json')) {
      context.handle(
        _secondaryMuscleGroupsJsonMeta,
        secondaryMuscleGroupsJson.isAcceptableOrUnknown(
          data['secondary_muscle_groups_json']!,
          _secondaryMuscleGroupsJsonMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
        _instructionsMeta,
        instructions.isAcceptableOrUnknown(
          data['instructions']!,
          _instructionsMeta,
        ),
      );
    }
    if (data.containsKey('personal_notes')) {
      context.handle(
        _personalNotesMeta,
        personalNotes.isAcceptableOrUnknown(
          data['personal_notes']!,
          _personalNotesMeta,
        ),
      );
    }
    if (data.containsKey('aliases_json')) {
      context.handle(
        _aliasesJsonMeta,
        aliasesJson.isAcceptableOrUnknown(
          data['aliases_json']!,
          _aliasesJsonMeta,
        ),
      );
    }
    if (data.containsKey('search_keywords_json')) {
      context.handle(
        _searchKeywordsJsonMeta,
        searchKeywordsJson.isAcceptableOrUnknown(
          data['search_keywords_json']!,
          _searchKeywordsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_favourite')) {
      context.handle(
        _isFavouriteMeta,
        isFavourite.isAcceptableOrUnknown(
          data['is_favourite']!,
          _isFavouriteMeta,
        ),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      primaryMuscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle_group'],
      )!,
      secondaryMuscleGroupsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_muscle_groups_json'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      instructions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructions'],
      ),
      personalNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_notes'],
      ),
      aliasesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aliases_json'],
      )!,
      searchKeywordsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_keywords_json'],
      )!,
      isFavourite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favourite'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CustomExercisesTable createAlias(String alias) {
    return $CustomExercisesTable(attachedDatabase, alias);
  }
}

class CustomExerciseRow extends DataClass
    implements Insertable<CustomExerciseRow> {
  final String id;
  final String userId;
  final String name;
  final String primaryMuscleGroup;
  final String secondaryMuscleGroupsJson;
  final String equipment;
  final String? instructions;
  final String? personalNotes;
  final String aliasesJson;
  final String searchKeywordsJson;
  final bool isFavourite;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const CustomExerciseRow({
    required this.id,
    required this.userId,
    required this.name,
    required this.primaryMuscleGroup,
    required this.secondaryMuscleGroupsJson,
    required this.equipment,
    this.instructions,
    this.personalNotes,
    required this.aliasesJson,
    required this.searchKeywordsJson,
    required this.isFavourite,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup);
    map['secondary_muscle_groups_json'] = Variable<String>(
      secondaryMuscleGroupsJson,
    );
    map['equipment'] = Variable<String>(equipment);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || personalNotes != null) {
      map['personal_notes'] = Variable<String>(personalNotes);
    }
    map['aliases_json'] = Variable<String>(aliasesJson);
    map['search_keywords_json'] = Variable<String>(searchKeywordsJson);
    map['is_favourite'] = Variable<bool>(isFavourite);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  CustomExercisesCompanion toCompanion(bool nullToAbsent) {
    return CustomExercisesCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      primaryMuscleGroup: Value(primaryMuscleGroup),
      secondaryMuscleGroupsJson: Value(secondaryMuscleGroupsJson),
      equipment: Value(equipment),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      personalNotes: personalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(personalNotes),
      aliasesJson: Value(aliasesJson),
      searchKeywordsJson: Value(searchKeywordsJson),
      isFavourite: Value(isFavourite),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory CustomExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscleGroup: serializer.fromJson<String>(
        json['primaryMuscleGroup'],
      ),
      secondaryMuscleGroupsJson: serializer.fromJson<String>(
        json['secondaryMuscleGroupsJson'],
      ),
      equipment: serializer.fromJson<String>(json['equipment']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      personalNotes: serializer.fromJson<String?>(json['personalNotes']),
      aliasesJson: serializer.fromJson<String>(json['aliasesJson']),
      searchKeywordsJson: serializer.fromJson<String>(
        json['searchKeywordsJson'],
      ),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'primaryMuscleGroup': serializer.toJson<String>(primaryMuscleGroup),
      'secondaryMuscleGroupsJson': serializer.toJson<String>(
        secondaryMuscleGroupsJson,
      ),
      'equipment': serializer.toJson<String>(equipment),
      'instructions': serializer.toJson<String?>(instructions),
      'personalNotes': serializer.toJson<String?>(personalNotes),
      'aliasesJson': serializer.toJson<String>(aliasesJson),
      'searchKeywordsJson': serializer.toJson<String>(searchKeywordsJson),
      'isFavourite': serializer.toJson<bool>(isFavourite),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  CustomExerciseRow copyWith({
    String? id,
    String? userId,
    String? name,
    String? primaryMuscleGroup,
    String? secondaryMuscleGroupsJson,
    String? equipment,
    Value<String?> instructions = const Value.absent(),
    Value<String?> personalNotes = const Value.absent(),
    String? aliasesJson,
    String? searchKeywordsJson,
    bool? isFavourite,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => CustomExerciseRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
    secondaryMuscleGroupsJson:
        secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
    equipment: equipment ?? this.equipment,
    instructions: instructions.present ? instructions.value : this.instructions,
    personalNotes: personalNotes.present
        ? personalNotes.value
        : this.personalNotes,
    aliasesJson: aliasesJson ?? this.aliasesJson,
    searchKeywordsJson: searchKeywordsJson ?? this.searchKeywordsJson,
    isFavourite: isFavourite ?? this.isFavourite,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  CustomExerciseRow copyWithCompanion(CustomExercisesCompanion data) {
    return CustomExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscleGroup: data.primaryMuscleGroup.present
          ? data.primaryMuscleGroup.value
          : this.primaryMuscleGroup,
      secondaryMuscleGroupsJson: data.secondaryMuscleGroupsJson.present
          ? data.secondaryMuscleGroupsJson.value
          : this.secondaryMuscleGroupsJson,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      personalNotes: data.personalNotes.present
          ? data.personalNotes.value
          : this.personalNotes,
      aliasesJson: data.aliasesJson.present
          ? data.aliasesJson.value
          : this.aliasesJson,
      searchKeywordsJson: data.searchKeywordsJson.present
          ? data.searchKeywordsJson.value
          : this.searchKeywordsJson,
      isFavourite: data.isFavourite.present
          ? data.isFavourite.value
          : this.isFavourite,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomExerciseRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('personalNotes: $personalNotes, ')
          ..write('aliasesJson: $aliasesJson, ')
          ..write('searchKeywordsJson: $searchKeywordsJson, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    instructions,
    personalNotes,
    aliasesJson,
    searchKeywordsJson,
    isFavourite,
    lastUsedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomExerciseRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.primaryMuscleGroup == this.primaryMuscleGroup &&
          other.secondaryMuscleGroupsJson == this.secondaryMuscleGroupsJson &&
          other.equipment == this.equipment &&
          other.instructions == this.instructions &&
          other.personalNotes == this.personalNotes &&
          other.aliasesJson == this.aliasesJson &&
          other.searchKeywordsJson == this.searchKeywordsJson &&
          other.isFavourite == this.isFavourite &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class CustomExercisesCompanion extends UpdateCompanion<CustomExerciseRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> primaryMuscleGroup;
  final Value<String> secondaryMuscleGroupsJson;
  final Value<String> equipment;
  final Value<String?> instructions;
  final Value<String?> personalNotes;
  final Value<String> aliasesJson;
  final Value<String> searchKeywordsJson;
  final Value<bool> isFavourite;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const CustomExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscleGroup = const Value.absent(),
    this.secondaryMuscleGroupsJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.instructions = const Value.absent(),
    this.personalNotes = const Value.absent(),
    this.aliasesJson = const Value.absent(),
    this.searchKeywordsJson = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomExercisesCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String primaryMuscleGroup,
    this.secondaryMuscleGroupsJson = const Value.absent(),
    required String equipment,
    this.instructions = const Value.absent(),
    this.personalNotes = const Value.absent(),
    this.aliasesJson = const Value.absent(),
    this.searchKeywordsJson = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       primaryMuscleGroup = Value(primaryMuscleGroup),
       equipment = Value(equipment),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CustomExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? primaryMuscleGroup,
    Expression<String>? secondaryMuscleGroupsJson,
    Expression<String>? equipment,
    Expression<String>? instructions,
    Expression<String>? personalNotes,
    Expression<String>? aliasesJson,
    Expression<String>? searchKeywordsJson,
    Expression<bool>? isFavourite,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (primaryMuscleGroup != null)
        'primary_muscle_group': primaryMuscleGroup,
      if (secondaryMuscleGroupsJson != null)
        'secondary_muscle_groups_json': secondaryMuscleGroupsJson,
      if (equipment != null) 'equipment': equipment,
      if (instructions != null) 'instructions': instructions,
      if (personalNotes != null) 'personal_notes': personalNotes,
      if (aliasesJson != null) 'aliases_json': aliasesJson,
      if (searchKeywordsJson != null)
        'search_keywords_json': searchKeywordsJson,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? primaryMuscleGroup,
    Value<String>? secondaryMuscleGroupsJson,
    Value<String>? equipment,
    Value<String?>? instructions,
    Value<String?>? personalNotes,
    Value<String>? aliasesJson,
    Value<String>? searchKeywordsJson,
    Value<bool>? isFavourite,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CustomExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      secondaryMuscleGroupsJson:
          secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      personalNotes: personalNotes ?? this.personalNotes,
      aliasesJson: aliasesJson ?? this.aliasesJson,
      searchKeywordsJson: searchKeywordsJson ?? this.searchKeywordsJson,
      isFavourite: isFavourite ?? this.isFavourite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryMuscleGroup.present) {
      map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup.value);
    }
    if (secondaryMuscleGroupsJson.present) {
      map['secondary_muscle_groups_json'] = Variable<String>(
        secondaryMuscleGroupsJson.value,
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (personalNotes.present) {
      map['personal_notes'] = Variable<String>(personalNotes.value);
    }
    if (aliasesJson.present) {
      map['aliases_json'] = Variable<String>(aliasesJson.value);
    }
    if (searchKeywordsJson.present) {
      map['search_keywords_json'] = Variable<String>(searchKeywordsJson.value);
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<bool>(isFavourite.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('personalNotes: $personalNotes, ')
          ..write('aliasesJson: $aliasesJson, ')
          ..write('searchKeywordsJson: $searchKeywordsJson, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitIdMeta = const VerificationMeta(
    'splitId',
  );
  @override
  late final GeneratedColumn<String> splitId = GeneratedColumn<String>(
    'split_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_splits (id) ON DELETE NO ACTION',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    splitId,
    name,
    icon,
    colorValue,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('split_id')) {
      context.handle(
        _splitIdMeta,
        splitId.isAcceptableOrUnknown(data['split_id']!, _splitIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      splitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplateRow extends DataClass
    implements Insertable<WorkoutTemplateRow> {
  final String id;
  final String userId;
  final String? splitId;
  final String name;
  final String icon;
  final int colorValue;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const WorkoutTemplateRow({
    required this.id,
    required this.userId,
    this.splitId,
    required this.name,
    required this.icon,
    required this.colorValue,
    this.notes,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || splitId != null) {
      map['split_id'] = Variable<String>(splitId);
    }
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_value'] = Variable<int>(colorValue);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      userId: Value(userId),
      splitId: splitId == null && nullToAbsent
          ? const Value.absent()
          : Value(splitId),
      name: Value(name),
      icon: Value(icon),
      colorValue: Value(colorValue),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory WorkoutTemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplateRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      splitId: serializer.fromJson<String?>(json['splitId']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'splitId': serializer.toJson<String?>(splitId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorValue': serializer.toJson<int>(colorValue),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  WorkoutTemplateRow copyWith({
    String? id,
    String? userId,
    Value<String?> splitId = const Value.absent(),
    String? name,
    String? icon,
    int? colorValue,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => WorkoutTemplateRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    splitId: splitId.present ? splitId.value : this.splitId,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorValue: colorValue ?? this.colorValue,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  WorkoutTemplateRow copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplateRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      splitId: data.splitId.present ? data.splitId.value : this.splitId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('splitId: $splitId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    splitId,
    name,
    icon,
    colorValue,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplateRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.splitId == this.splitId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorValue == this.colorValue &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplateRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> splitId;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> colorValue;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.splitId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    required String id,
    required String userId,
    this.splitId = const Value.absent(),
    required String name,
    required String icon,
    required int colorValue,
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       icon = Value(icon),
       colorValue = Value(colorValue),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<WorkoutTemplateRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? splitId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? colorValue,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (splitId != null) 'split_id': splitId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorValue != null) 'color_value': colorValue,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? splitId,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? colorValue,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      splitId: splitId ?? this.splitId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (splitId.present) {
      map['split_id'] = Variable<String>(splitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('splitId: $splitId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorValue: $colorValue, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplateExercisesTable extends TemplateExercises
    with TableInfo<$TemplateExercisesTable, TemplateExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _customExerciseIdMeta = const VerificationMeta(
    'customExerciseId',
  );
  @override
  late final GeneratedColumn<String> customExerciseId = GeneratedColumn<String>(
    'custom_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_exercises (id) ON DELETE NO ACTION',
    ),
  );
  static const VerificationMeta _systemExerciseKeyMeta = const VerificationMeta(
    'systemExerciseKey',
  );
  @override
  late final GeneratedColumn<String> systemExerciseKey =
      GeneratedColumn<String>(
        'system_exercise_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleGroupMeta =
      const VerificationMeta('primaryMuscleGroup');
  @override
  late final GeneratedColumn<String> primaryMuscleGroup =
      GeneratedColumn<String>(
        'primary_muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workingSetsMeta = const VerificationMeta(
    'workingSets',
  );
  @override
  late final GeneratedColumn<int> workingSets = GeneratedColumn<int>(
    'working_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _warmupSetsMeta = const VerificationMeta(
    'warmupSets',
  );
  @override
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
    'warmup_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetRepsMinMeta = const VerificationMeta(
    'targetRepsMin',
  );
  @override
  late final GeneratedColumn<int> targetRepsMin = GeneratedColumn<int>(
    'target_reps_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _targetRepsMaxMeta = const VerificationMeta(
    'targetRepsMax',
  );
  @override
  late final GeneratedColumn<int> targetRepsMax = GeneratedColumn<int>(
    'target_reps_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _targetWeightMeta = const VerificationMeta(
    'targetWeight',
  );
  @override
  late final GeneratedColumn<double> targetWeight = GeneratedColumn<double>(
    'target_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _rpeTargetMeta = const VerificationMeta(
    'rpeTarget',
  );
  @override
  late final GeneratedColumn<double> rpeTarget = GeneratedColumn<double>(
    'rpe_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirTargetMeta = const VerificationMeta(
    'rirTarget',
  );
  @override
  late final GeneratedColumn<double> rirTarget = GeneratedColumn<double>(
    'rir_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    templateId,
    customExerciseId,
    systemExerciseKey,
    exerciseName,
    primaryMuscleGroup,
    equipment,
    workingSets,
    warmupSets,
    targetRepsMin,
    targetRepsMax,
    targetWeight,
    restSeconds,
    rpeTarget,
    rirTarget,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('custom_exercise_id')) {
      context.handle(
        _customExerciseIdMeta,
        customExerciseId.isAcceptableOrUnknown(
          data['custom_exercise_id']!,
          _customExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('system_exercise_key')) {
      context.handle(
        _systemExerciseKeyMeta,
        systemExerciseKey.isAcceptableOrUnknown(
          data['system_exercise_key']!,
          _systemExerciseKeyMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('primary_muscle_group')) {
      context.handle(
        _primaryMuscleGroupMeta,
        primaryMuscleGroup.isAcceptableOrUnknown(
          data['primary_muscle_group']!,
          _primaryMuscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleGroupMeta);
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('working_sets')) {
      context.handle(
        _workingSetsMeta,
        workingSets.isAcceptableOrUnknown(
          data['working_sets']!,
          _workingSetsMeta,
        ),
      );
    }
    if (data.containsKey('warmup_sets')) {
      context.handle(
        _warmupSetsMeta,
        warmupSets.isAcceptableOrUnknown(data['warmup_sets']!, _warmupSetsMeta),
      );
    }
    if (data.containsKey('target_reps_min')) {
      context.handle(
        _targetRepsMinMeta,
        targetRepsMin.isAcceptableOrUnknown(
          data['target_reps_min']!,
          _targetRepsMinMeta,
        ),
      );
    }
    if (data.containsKey('target_reps_max')) {
      context.handle(
        _targetRepsMaxMeta,
        targetRepsMax.isAcceptableOrUnknown(
          data['target_reps_max']!,
          _targetRepsMaxMeta,
        ),
      );
    }
    if (data.containsKey('target_weight')) {
      context.handle(
        _targetWeightMeta,
        targetWeight.isAcceptableOrUnknown(
          data['target_weight']!,
          _targetWeightMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rpe_target')) {
      context.handle(
        _rpeTargetMeta,
        rpeTarget.isAcceptableOrUnknown(data['rpe_target']!, _rpeTargetMeta),
      );
    }
    if (data.containsKey('rir_target')) {
      context.handle(
        _rirTargetMeta,
        rirTarget.isAcceptableOrUnknown(data['rir_target']!, _rirTargetMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      customExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_exercise_id'],
      ),
      systemExerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_exercise_key'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      primaryMuscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle_group'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      workingSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}working_sets'],
      )!,
      warmupSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warmup_sets'],
      )!,
      targetRepsMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_min'],
      )!,
      targetRepsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_reps_max'],
      )!,
      targetWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      rpeTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe_target'],
      ),
      rirTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rir_target'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $TemplateExercisesTable createAlias(String alias) {
    return $TemplateExercisesTable(attachedDatabase, alias);
  }
}

class TemplateExerciseRow extends DataClass
    implements Insertable<TemplateExerciseRow> {
  final String id;
  final String userId;
  final String templateId;
  final String? customExerciseId;
  final String? systemExerciseKey;
  final String exerciseName;
  final String primaryMuscleGroup;
  final String equipment;
  final int workingSets;
  final int warmupSets;
  final int targetRepsMin;
  final int targetRepsMax;
  final double? targetWeight;
  final int restSeconds;
  final double? rpeTarget;
  final double? rirTarget;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const TemplateExerciseRow({
    required this.id,
    required this.userId,
    required this.templateId,
    this.customExerciseId,
    this.systemExerciseKey,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    required this.equipment,
    required this.workingSets,
    required this.warmupSets,
    required this.targetRepsMin,
    required this.targetRepsMax,
    this.targetWeight,
    required this.restSeconds,
    this.rpeTarget,
    this.rirTarget,
    this.notes,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['template_id'] = Variable<String>(templateId);
    if (!nullToAbsent || customExerciseId != null) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId);
    }
    if (!nullToAbsent || systemExerciseKey != null) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey);
    }
    map['exercise_name'] = Variable<String>(exerciseName);
    map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup);
    map['equipment'] = Variable<String>(equipment);
    map['working_sets'] = Variable<int>(workingSets);
    map['warmup_sets'] = Variable<int>(warmupSets);
    map['target_reps_min'] = Variable<int>(targetRepsMin);
    map['target_reps_max'] = Variable<int>(targetRepsMax);
    if (!nullToAbsent || targetWeight != null) {
      map['target_weight'] = Variable<double>(targetWeight);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    if (!nullToAbsent || rpeTarget != null) {
      map['rpe_target'] = Variable<double>(rpeTarget);
    }
    if (!nullToAbsent || rirTarget != null) {
      map['rir_target'] = Variable<double>(rirTarget);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  TemplateExercisesCompanion toCompanion(bool nullToAbsent) {
    return TemplateExercisesCompanion(
      id: Value(id),
      userId: Value(userId),
      templateId: Value(templateId),
      customExerciseId: customExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(customExerciseId),
      systemExerciseKey: systemExerciseKey == null && nullToAbsent
          ? const Value.absent()
          : Value(systemExerciseKey),
      exerciseName: Value(exerciseName),
      primaryMuscleGroup: Value(primaryMuscleGroup),
      equipment: Value(equipment),
      workingSets: Value(workingSets),
      warmupSets: Value(warmupSets),
      targetRepsMin: Value(targetRepsMin),
      targetRepsMax: Value(targetRepsMax),
      targetWeight: targetWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeight),
      restSeconds: Value(restSeconds),
      rpeTarget: rpeTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(rpeTarget),
      rirTarget: rirTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(rirTarget),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory TemplateExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      customExerciseId: serializer.fromJson<String?>(json['customExerciseId']),
      systemExerciseKey: serializer.fromJson<String?>(
        json['systemExerciseKey'],
      ),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      primaryMuscleGroup: serializer.fromJson<String>(
        json['primaryMuscleGroup'],
      ),
      equipment: serializer.fromJson<String>(json['equipment']),
      workingSets: serializer.fromJson<int>(json['workingSets']),
      warmupSets: serializer.fromJson<int>(json['warmupSets']),
      targetRepsMin: serializer.fromJson<int>(json['targetRepsMin']),
      targetRepsMax: serializer.fromJson<int>(json['targetRepsMax']),
      targetWeight: serializer.fromJson<double?>(json['targetWeight']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      rpeTarget: serializer.fromJson<double?>(json['rpeTarget']),
      rirTarget: serializer.fromJson<double?>(json['rirTarget']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'templateId': serializer.toJson<String>(templateId),
      'customExerciseId': serializer.toJson<String?>(customExerciseId),
      'systemExerciseKey': serializer.toJson<String?>(systemExerciseKey),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'primaryMuscleGroup': serializer.toJson<String>(primaryMuscleGroup),
      'equipment': serializer.toJson<String>(equipment),
      'workingSets': serializer.toJson<int>(workingSets),
      'warmupSets': serializer.toJson<int>(warmupSets),
      'targetRepsMin': serializer.toJson<int>(targetRepsMin),
      'targetRepsMax': serializer.toJson<int>(targetRepsMax),
      'targetWeight': serializer.toJson<double?>(targetWeight),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'rpeTarget': serializer.toJson<double?>(rpeTarget),
      'rirTarget': serializer.toJson<double?>(rirTarget),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  TemplateExerciseRow copyWith({
    String? id,
    String? userId,
    String? templateId,
    Value<String?> customExerciseId = const Value.absent(),
    Value<String?> systemExerciseKey = const Value.absent(),
    String? exerciseName,
    String? primaryMuscleGroup,
    String? equipment,
    int? workingSets,
    int? warmupSets,
    int? targetRepsMin,
    int? targetRepsMax,
    Value<double?> targetWeight = const Value.absent(),
    int? restSeconds,
    Value<double?> rpeTarget = const Value.absent(),
    Value<double?> rirTarget = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => TemplateExerciseRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    templateId: templateId ?? this.templateId,
    customExerciseId: customExerciseId.present
        ? customExerciseId.value
        : this.customExerciseId,
    systemExerciseKey: systemExerciseKey.present
        ? systemExerciseKey.value
        : this.systemExerciseKey,
    exerciseName: exerciseName ?? this.exerciseName,
    primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
    equipment: equipment ?? this.equipment,
    workingSets: workingSets ?? this.workingSets,
    warmupSets: warmupSets ?? this.warmupSets,
    targetRepsMin: targetRepsMin ?? this.targetRepsMin,
    targetRepsMax: targetRepsMax ?? this.targetRepsMax,
    targetWeight: targetWeight.present ? targetWeight.value : this.targetWeight,
    restSeconds: restSeconds ?? this.restSeconds,
    rpeTarget: rpeTarget.present ? rpeTarget.value : this.rpeTarget,
    rirTarget: rirTarget.present ? rirTarget.value : this.rirTarget,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  TemplateExerciseRow copyWithCompanion(TemplateExercisesCompanion data) {
    return TemplateExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      customExerciseId: data.customExerciseId.present
          ? data.customExerciseId.value
          : this.customExerciseId,
      systemExerciseKey: data.systemExerciseKey.present
          ? data.systemExerciseKey.value
          : this.systemExerciseKey,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      primaryMuscleGroup: data.primaryMuscleGroup.present
          ? data.primaryMuscleGroup.value
          : this.primaryMuscleGroup,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      workingSets: data.workingSets.present
          ? data.workingSets.value
          : this.workingSets,
      warmupSets: data.warmupSets.present
          ? data.warmupSets.value
          : this.warmupSets,
      targetRepsMin: data.targetRepsMin.present
          ? data.targetRepsMin.value
          : this.targetRepsMin,
      targetRepsMax: data.targetRepsMax.present
          ? data.targetRepsMax.value
          : this.targetRepsMax,
      targetWeight: data.targetWeight.present
          ? data.targetWeight.value
          : this.targetWeight,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      rpeTarget: data.rpeTarget.present ? data.rpeTarget.value : this.rpeTarget,
      rirTarget: data.rirTarget.present ? data.rirTarget.value : this.rirTarget,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExerciseRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('templateId: $templateId, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('workingSets: $workingSets, ')
          ..write('warmupSets: $warmupSets, ')
          ..write('targetRepsMin: $targetRepsMin, ')
          ..write('targetRepsMax: $targetRepsMax, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('rpeTarget: $rpeTarget, ')
          ..write('rirTarget: $rirTarget, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    templateId,
    customExerciseId,
    systemExerciseKey,
    exerciseName,
    primaryMuscleGroup,
    equipment,
    workingSets,
    warmupSets,
    targetRepsMin,
    targetRepsMax,
    targetWeight,
    restSeconds,
    rpeTarget,
    rirTarget,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateExerciseRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.templateId == this.templateId &&
          other.customExerciseId == this.customExerciseId &&
          other.systemExerciseKey == this.systemExerciseKey &&
          other.exerciseName == this.exerciseName &&
          other.primaryMuscleGroup == this.primaryMuscleGroup &&
          other.equipment == this.equipment &&
          other.workingSets == this.workingSets &&
          other.warmupSets == this.warmupSets &&
          other.targetRepsMin == this.targetRepsMin &&
          other.targetRepsMax == this.targetRepsMax &&
          other.targetWeight == this.targetWeight &&
          other.restSeconds == this.restSeconds &&
          other.rpeTarget == this.rpeTarget &&
          other.rirTarget == this.rirTarget &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class TemplateExercisesCompanion extends UpdateCompanion<TemplateExerciseRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> templateId;
  final Value<String?> customExerciseId;
  final Value<String?> systemExerciseKey;
  final Value<String> exerciseName;
  final Value<String> primaryMuscleGroup;
  final Value<String> equipment;
  final Value<int> workingSets;
  final Value<int> warmupSets;
  final Value<int> targetRepsMin;
  final Value<int> targetRepsMax;
  final Value<double?> targetWeight;
  final Value<int> restSeconds;
  final Value<double?> rpeTarget;
  final Value<double?> rirTarget;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const TemplateExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    this.systemExerciseKey = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.primaryMuscleGroup = const Value.absent(),
    this.equipment = const Value.absent(),
    this.workingSets = const Value.absent(),
    this.warmupSets = const Value.absent(),
    this.targetRepsMin = const Value.absent(),
    this.targetRepsMax = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.rpeTarget = const Value.absent(),
    this.rirTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplateExercisesCompanion.insert({
    required String id,
    required String userId,
    required String templateId,
    this.customExerciseId = const Value.absent(),
    this.systemExerciseKey = const Value.absent(),
    required String exerciseName,
    required String primaryMuscleGroup,
    required String equipment,
    this.workingSets = const Value.absent(),
    this.warmupSets = const Value.absent(),
    this.targetRepsMin = const Value.absent(),
    this.targetRepsMax = const Value.absent(),
    this.targetWeight = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.rpeTarget = const Value.absent(),
    this.rirTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       templateId = Value(templateId),
       exerciseName = Value(exerciseName),
       primaryMuscleGroup = Value(primaryMuscleGroup),
       equipment = Value(equipment),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TemplateExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? templateId,
    Expression<String>? customExerciseId,
    Expression<String>? systemExerciseKey,
    Expression<String>? exerciseName,
    Expression<String>? primaryMuscleGroup,
    Expression<String>? equipment,
    Expression<int>? workingSets,
    Expression<int>? warmupSets,
    Expression<int>? targetRepsMin,
    Expression<int>? targetRepsMax,
    Expression<double>? targetWeight,
    Expression<int>? restSeconds,
    Expression<double>? rpeTarget,
    Expression<double>? rirTarget,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (templateId != null) 'template_id': templateId,
      if (customExerciseId != null) 'custom_exercise_id': customExerciseId,
      if (systemExerciseKey != null) 'system_exercise_key': systemExerciseKey,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (primaryMuscleGroup != null)
        'primary_muscle_group': primaryMuscleGroup,
      if (equipment != null) 'equipment': equipment,
      if (workingSets != null) 'working_sets': workingSets,
      if (warmupSets != null) 'warmup_sets': warmupSets,
      if (targetRepsMin != null) 'target_reps_min': targetRepsMin,
      if (targetRepsMax != null) 'target_reps_max': targetRepsMax,
      if (targetWeight != null) 'target_weight': targetWeight,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (rpeTarget != null) 'rpe_target': rpeTarget,
      if (rirTarget != null) 'rir_target': rirTarget,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplateExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? templateId,
    Value<String?>? customExerciseId,
    Value<String?>? systemExerciseKey,
    Value<String>? exerciseName,
    Value<String>? primaryMuscleGroup,
    Value<String>? equipment,
    Value<int>? workingSets,
    Value<int>? warmupSets,
    Value<int>? targetRepsMin,
    Value<int>? targetRepsMax,
    Value<double?>? targetWeight,
    Value<int>? restSeconds,
    Value<double?>? rpeTarget,
    Value<double?>? rirTarget,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return TemplateExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      templateId: templateId ?? this.templateId,
      customExerciseId: customExerciseId ?? this.customExerciseId,
      systemExerciseKey: systemExerciseKey ?? this.systemExerciseKey,
      exerciseName: exerciseName ?? this.exerciseName,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      equipment: equipment ?? this.equipment,
      workingSets: workingSets ?? this.workingSets,
      warmupSets: warmupSets ?? this.warmupSets,
      targetRepsMin: targetRepsMin ?? this.targetRepsMin,
      targetRepsMax: targetRepsMax ?? this.targetRepsMax,
      targetWeight: targetWeight ?? this.targetWeight,
      restSeconds: restSeconds ?? this.restSeconds,
      rpeTarget: rpeTarget ?? this.rpeTarget,
      rirTarget: rirTarget ?? this.rirTarget,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (customExerciseId.present) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId.value);
    }
    if (systemExerciseKey.present) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (primaryMuscleGroup.present) {
      map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (workingSets.present) {
      map['working_sets'] = Variable<int>(workingSets.value);
    }
    if (warmupSets.present) {
      map['warmup_sets'] = Variable<int>(warmupSets.value);
    }
    if (targetRepsMin.present) {
      map['target_reps_min'] = Variable<int>(targetRepsMin.value);
    }
    if (targetRepsMax.present) {
      map['target_reps_max'] = Variable<int>(targetRepsMax.value);
    }
    if (targetWeight.present) {
      map['target_weight'] = Variable<double>(targetWeight.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (rpeTarget.present) {
      map['rpe_target'] = Variable<double>(rpeTarget.value);
    }
    if (rirTarget.present) {
      map['rir_target'] = Variable<double>(rirTarget.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('templateId: $templateId, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('workingSets: $workingSets, ')
          ..write('warmupSets: $warmupSets, ')
          ..write('targetRepsMin: $targetRepsMin, ')
          ..write('targetRepsMax: $targetRepsMax, ')
          ..write('targetWeight: $targetWeight, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('rpeTarget: $rpeTarget, ')
          ..write('rirTarget: $rirTarget, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlannerSyncQueueTable extends PlannerSyncQueue
    with TableInfo<$PlannerSyncQueueTable, PlannerSyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlannerSyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityVersionMeta = const VerificationMeta(
    'entityVersion',
  );
  @override
  late final GeneratedColumn<int> entityVersion = GeneratedColumn<int>(
    'entity_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    entityType,
    entityId,
    entityVersion,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planner_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannerSyncQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_version')) {
      context.handle(
        _entityVersionMeta,
        entityVersion.isAcceptableOrUnknown(
          data['entity_version']!,
          _entityVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityVersionMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, entityType, entityId},
  ];
  @override
  PlannerSyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannerSyncQueueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_version'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlannerSyncQueueTable createAlias(String alias) {
    return $PlannerSyncQueueTable(attachedDatabase, alias);
  }
}

class PlannerSyncQueueRow extends DataClass
    implements Insertable<PlannerSyncQueueRow> {
  final String id;
  final String userId;
  final String entityType;
  final String entityId;
  final int entityVersion;
  final int attemptCount;
  final String? lastError;
  final DateTime? lastAttemptAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlannerSyncQueueRow({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.entityVersion,
    required this.attemptCount,
    this.lastError,
    this.lastAttemptAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_version'] = Variable<int>(entityVersion);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlannerSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return PlannerSyncQueueCompanion(
      id: Value(id),
      userId: Value(userId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      entityVersion: Value(entityVersion),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlannerSyncQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannerSyncQueueRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityVersion: serializer.fromJson<int>(json['entityVersion']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'entityVersion': serializer.toJson<int>(entityVersion),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlannerSyncQueueRow copyWith({
    String? id,
    String? userId,
    String? entityType,
    String? entityId,
    int? entityVersion,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlannerSyncQueueRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    entityVersion: entityVersion ?? this.entityVersion,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlannerSyncQueueRow copyWithCompanion(PlannerSyncQueueCompanion data) {
    return PlannerSyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityVersion: data.entityVersion.present
          ? data.entityVersion.value
          : this.entityVersion,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannerSyncQueueRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityVersion: $entityVersion, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    entityType,
    entityId,
    entityVersion,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannerSyncQueueRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityVersion == this.entityVersion &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlannerSyncQueueCompanion extends UpdateCompanion<PlannerSyncQueueRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> entityVersion;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlannerSyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityVersion = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannerSyncQueueCompanion.insert({
    required String id,
    required String userId,
    required String entityType,
    required String entityId,
    required int entityVersion,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       entityVersion = Value(entityVersion),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlannerSyncQueueRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? entityVersion,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (entityVersion != null) 'entity_version': entityVersion,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannerSyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? entityVersion,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlannerSyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityVersion: entityVersion ?? this.entityVersion,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityVersion.present) {
      map['entity_version'] = Variable<int>(entityVersion.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannerSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityVersion: $entityVersion, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveWorkoutSessionsTable extends ActiveWorkoutSessions
    with TableInfo<$ActiveWorkoutSessionsTable, ActiveWorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveWorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTemplateIdMeta = const VerificationMeta(
    'sourceTemplateId',
  );
  @override
  late final GeneratedColumn<String> sourceTemplateId = GeneratedColumn<String>(
    'source_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _restTimerStateMeta = const VerificationMeta(
    'restTimerState',
  );
  @override
  late final GeneratedColumn<String> restTimerState = GeneratedColumn<String>(
    'rest_timer_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('idle'),
  );
  static const VerificationMeta _restTimerDurationSecondsMeta =
      const VerificationMeta('restTimerDurationSeconds');
  @override
  late final GeneratedColumn<int> restTimerDurationSeconds =
      GeneratedColumn<int>(
        'rest_timer_duration_seconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _restTimerTargetEndAtMeta =
      const VerificationMeta('restTimerTargetEndAt');
  @override
  late final GeneratedColumn<DateTime> restTimerTargetEndAt =
      GeneratedColumn<DateTime>(
        'rest_timer_target_end_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _restTimerRemainingSecondsMeta =
      const VerificationMeta('restTimerRemainingSeconds');
  @override
  late final GeneratedColumn<int> restTimerRemainingSeconds =
      GeneratedColumn<int>(
        'rest_timer_remaining_seconds',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _autoStartRestTimerMeta =
      const VerificationMeta('autoStartRestTimer');
  @override
  late final GeneratedColumn<bool> autoStartRestTimer = GeneratedColumn<bool>(
    'auto_start_rest_timer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_start_rest_timer" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    sourceTemplateId,
    startedAt,
    notes,
    weightUnit,
    restTimerState,
    restTimerDurationSeconds,
    restTimerTargetEndAt,
    restTimerRemainingSeconds,
    autoStartRestTimer,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveWorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source_template_id')) {
      context.handle(
        _sourceTemplateIdMeta,
        sourceTemplateId.isAcceptableOrUnknown(
          data['source_template_id']!,
          _sourceTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('rest_timer_state')) {
      context.handle(
        _restTimerStateMeta,
        restTimerState.isAcceptableOrUnknown(
          data['rest_timer_state']!,
          _restTimerStateMeta,
        ),
      );
    }
    if (data.containsKey('rest_timer_duration_seconds')) {
      context.handle(
        _restTimerDurationSecondsMeta,
        restTimerDurationSeconds.isAcceptableOrUnknown(
          data['rest_timer_duration_seconds']!,
          _restTimerDurationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rest_timer_target_end_at')) {
      context.handle(
        _restTimerTargetEndAtMeta,
        restTimerTargetEndAt.isAcceptableOrUnknown(
          data['rest_timer_target_end_at']!,
          _restTimerTargetEndAtMeta,
        ),
      );
    }
    if (data.containsKey('rest_timer_remaining_seconds')) {
      context.handle(
        _restTimerRemainingSecondsMeta,
        restTimerRemainingSeconds.isAcceptableOrUnknown(
          data['rest_timer_remaining_seconds']!,
          _restTimerRemainingSecondsMeta,
        ),
      );
    }
    if (data.containsKey('auto_start_rest_timer')) {
      context.handle(
        _autoStartRestTimerMeta,
        autoStartRestTimer.isAcceptableOrUnknown(
          data['auto_start_rest_timer']!,
          _autoStartRestTimerMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveWorkoutSessionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveWorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sourceTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_template_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      )!,
      restTimerState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rest_timer_state'],
      )!,
      restTimerDurationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_timer_duration_seconds'],
      )!,
      restTimerTargetEndAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_timer_target_end_at'],
      ),
      restTimerRemainingSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_timer_remaining_seconds'],
      )!,
      autoStartRestTimer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_start_rest_timer'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ActiveWorkoutSessionsTable createAlias(String alias) {
    return $ActiveWorkoutSessionsTable(attachedDatabase, alias);
  }
}

class ActiveWorkoutSessionRow extends DataClass
    implements Insertable<ActiveWorkoutSessionRow> {
  final String id;
  final String userId;
  final String name;
  final String? sourceTemplateId;
  final DateTime startedAt;
  final String? notes;
  final String weightUnit;
  final String restTimerState;
  final int restTimerDurationSeconds;
  final DateTime? restTimerTargetEndAt;
  final int restTimerRemainingSeconds;
  final bool autoStartRestTimer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const ActiveWorkoutSessionRow({
    required this.id,
    required this.userId,
    required this.name,
    this.sourceTemplateId,
    required this.startedAt,
    this.notes,
    required this.weightUnit,
    required this.restTimerState,
    required this.restTimerDurationSeconds,
    this.restTimerTargetEndAt,
    required this.restTimerRemainingSeconds,
    required this.autoStartRestTimer,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || sourceTemplateId != null) {
      map['source_template_id'] = Variable<String>(sourceTemplateId);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['weight_unit'] = Variable<String>(weightUnit);
    map['rest_timer_state'] = Variable<String>(restTimerState);
    map['rest_timer_duration_seconds'] = Variable<int>(
      restTimerDurationSeconds,
    );
    if (!nullToAbsent || restTimerTargetEndAt != null) {
      map['rest_timer_target_end_at'] = Variable<DateTime>(
        restTimerTargetEndAt,
      );
    }
    map['rest_timer_remaining_seconds'] = Variable<int>(
      restTimerRemainingSeconds,
    );
    map['auto_start_rest_timer'] = Variable<bool>(autoStartRestTimer);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  ActiveWorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return ActiveWorkoutSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      sourceTemplateId: sourceTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTemplateId),
      startedAt: Value(startedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      weightUnit: Value(weightUnit),
      restTimerState: Value(restTimerState),
      restTimerDurationSeconds: Value(restTimerDurationSeconds),
      restTimerTargetEndAt: restTimerTargetEndAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restTimerTargetEndAt),
      restTimerRemainingSeconds: Value(restTimerRemainingSeconds),
      autoStartRestTimer: Value(autoStartRestTimer),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory ActiveWorkoutSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveWorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      sourceTemplateId: serializer.fromJson<String?>(json['sourceTemplateId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
      restTimerState: serializer.fromJson<String>(json['restTimerState']),
      restTimerDurationSeconds: serializer.fromJson<int>(
        json['restTimerDurationSeconds'],
      ),
      restTimerTargetEndAt: serializer.fromJson<DateTime?>(
        json['restTimerTargetEndAt'],
      ),
      restTimerRemainingSeconds: serializer.fromJson<int>(
        json['restTimerRemainingSeconds'],
      ),
      autoStartRestTimer: serializer.fromJson<bool>(json['autoStartRestTimer']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'sourceTemplateId': serializer.toJson<String?>(sourceTemplateId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'notes': serializer.toJson<String?>(notes),
      'weightUnit': serializer.toJson<String>(weightUnit),
      'restTimerState': serializer.toJson<String>(restTimerState),
      'restTimerDurationSeconds': serializer.toJson<int>(
        restTimerDurationSeconds,
      ),
      'restTimerTargetEndAt': serializer.toJson<DateTime?>(
        restTimerTargetEndAt,
      ),
      'restTimerRemainingSeconds': serializer.toJson<int>(
        restTimerRemainingSeconds,
      ),
      'autoStartRestTimer': serializer.toJson<bool>(autoStartRestTimer),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  ActiveWorkoutSessionRow copyWith({
    String? id,
    String? userId,
    String? name,
    Value<String?> sourceTemplateId = const Value.absent(),
    DateTime? startedAt,
    Value<String?> notes = const Value.absent(),
    String? weightUnit,
    String? restTimerState,
    int? restTimerDurationSeconds,
    Value<DateTime?> restTimerTargetEndAt = const Value.absent(),
    int? restTimerRemainingSeconds,
    bool? autoStartRestTimer,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => ActiveWorkoutSessionRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    sourceTemplateId: sourceTemplateId.present
        ? sourceTemplateId.value
        : this.sourceTemplateId,
    startedAt: startedAt ?? this.startedAt,
    notes: notes.present ? notes.value : this.notes,
    weightUnit: weightUnit ?? this.weightUnit,
    restTimerState: restTimerState ?? this.restTimerState,
    restTimerDurationSeconds:
        restTimerDurationSeconds ?? this.restTimerDurationSeconds,
    restTimerTargetEndAt: restTimerTargetEndAt.present
        ? restTimerTargetEndAt.value
        : this.restTimerTargetEndAt,
    restTimerRemainingSeconds:
        restTimerRemainingSeconds ?? this.restTimerRemainingSeconds,
    autoStartRestTimer: autoStartRestTimer ?? this.autoStartRestTimer,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  ActiveWorkoutSessionRow copyWithCompanion(
    ActiveWorkoutSessionsCompanion data,
  ) {
    return ActiveWorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      sourceTemplateId: data.sourceTemplateId.present
          ? data.sourceTemplateId.value
          : this.sourceTemplateId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      restTimerState: data.restTimerState.present
          ? data.restTimerState.value
          : this.restTimerState,
      restTimerDurationSeconds: data.restTimerDurationSeconds.present
          ? data.restTimerDurationSeconds.value
          : this.restTimerDurationSeconds,
      restTimerTargetEndAt: data.restTimerTargetEndAt.present
          ? data.restTimerTargetEndAt.value
          : this.restTimerTargetEndAt,
      restTimerRemainingSeconds: data.restTimerRemainingSeconds.present
          ? data.restTimerRemainingSeconds.value
          : this.restTimerRemainingSeconds,
      autoStartRestTimer: data.autoStartRestTimer.present
          ? data.autoStartRestTimer.value
          : this.autoStartRestTimer,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('sourceTemplateId: $sourceTemplateId, ')
          ..write('startedAt: $startedAt, ')
          ..write('notes: $notes, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('restTimerState: $restTimerState, ')
          ..write('restTimerDurationSeconds: $restTimerDurationSeconds, ')
          ..write('restTimerTargetEndAt: $restTimerTargetEndAt, ')
          ..write('restTimerRemainingSeconds: $restTimerRemainingSeconds, ')
          ..write('autoStartRestTimer: $autoStartRestTimer, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    sourceTemplateId,
    startedAt,
    notes,
    weightUnit,
    restTimerState,
    restTimerDurationSeconds,
    restTimerTargetEndAt,
    restTimerRemainingSeconds,
    autoStartRestTimer,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveWorkoutSessionRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.sourceTemplateId == this.sourceTemplateId &&
          other.startedAt == this.startedAt &&
          other.notes == this.notes &&
          other.weightUnit == this.weightUnit &&
          other.restTimerState == this.restTimerState &&
          other.restTimerDurationSeconds == this.restTimerDurationSeconds &&
          other.restTimerTargetEndAt == this.restTimerTargetEndAt &&
          other.restTimerRemainingSeconds == this.restTimerRemainingSeconds &&
          other.autoStartRestTimer == this.autoStartRestTimer &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class ActiveWorkoutSessionsCompanion
    extends UpdateCompanion<ActiveWorkoutSessionRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String?> sourceTemplateId;
  final Value<DateTime> startedAt;
  final Value<String?> notes;
  final Value<String> weightUnit;
  final Value<String> restTimerState;
  final Value<int> restTimerDurationSeconds;
  final Value<DateTime?> restTimerTargetEndAt;
  final Value<int> restTimerRemainingSeconds;
  final Value<bool> autoStartRestTimer;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const ActiveWorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.sourceTemplateId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.restTimerState = const Value.absent(),
    this.restTimerDurationSeconds = const Value.absent(),
    this.restTimerTargetEndAt = const Value.absent(),
    this.restTimerRemainingSeconds = const Value.absent(),
    this.autoStartRestTimer = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveWorkoutSessionsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    this.sourceTemplateId = const Value.absent(),
    required DateTime startedAt,
    this.notes = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.restTimerState = const Value.absent(),
    this.restTimerDurationSeconds = const Value.absent(),
    this.restTimerTargetEndAt = const Value.absent(),
    this.restTimerRemainingSeconds = const Value.absent(),
    this.autoStartRestTimer = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       startedAt = Value(startedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveWorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? sourceTemplateId,
    Expression<DateTime>? startedAt,
    Expression<String>? notes,
    Expression<String>? weightUnit,
    Expression<String>? restTimerState,
    Expression<int>? restTimerDurationSeconds,
    Expression<DateTime>? restTimerTargetEndAt,
    Expression<int>? restTimerRemainingSeconds,
    Expression<bool>? autoStartRestTimer,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (sourceTemplateId != null) 'source_template_id': sourceTemplateId,
      if (startedAt != null) 'started_at': startedAt,
      if (notes != null) 'notes': notes,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (restTimerState != null) 'rest_timer_state': restTimerState,
      if (restTimerDurationSeconds != null)
        'rest_timer_duration_seconds': restTimerDurationSeconds,
      if (restTimerTargetEndAt != null)
        'rest_timer_target_end_at': restTimerTargetEndAt,
      if (restTimerRemainingSeconds != null)
        'rest_timer_remaining_seconds': restTimerRemainingSeconds,
      if (autoStartRestTimer != null)
        'auto_start_rest_timer': autoStartRestTimer,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveWorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String?>? sourceTemplateId,
    Value<DateTime>? startedAt,
    Value<String?>? notes,
    Value<String>? weightUnit,
    Value<String>? restTimerState,
    Value<int>? restTimerDurationSeconds,
    Value<DateTime?>? restTimerTargetEndAt,
    Value<int>? restTimerRemainingSeconds,
    Value<bool>? autoStartRestTimer,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return ActiveWorkoutSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      sourceTemplateId: sourceTemplateId ?? this.sourceTemplateId,
      startedAt: startedAt ?? this.startedAt,
      notes: notes ?? this.notes,
      weightUnit: weightUnit ?? this.weightUnit,
      restTimerState: restTimerState ?? this.restTimerState,
      restTimerDurationSeconds:
          restTimerDurationSeconds ?? this.restTimerDurationSeconds,
      restTimerTargetEndAt: restTimerTargetEndAt ?? this.restTimerTargetEndAt,
      restTimerRemainingSeconds:
          restTimerRemainingSeconds ?? this.restTimerRemainingSeconds,
      autoStartRestTimer: autoStartRestTimer ?? this.autoStartRestTimer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sourceTemplateId.present) {
      map['source_template_id'] = Variable<String>(sourceTemplateId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (restTimerState.present) {
      map['rest_timer_state'] = Variable<String>(restTimerState.value);
    }
    if (restTimerDurationSeconds.present) {
      map['rest_timer_duration_seconds'] = Variable<int>(
        restTimerDurationSeconds.value,
      );
    }
    if (restTimerTargetEndAt.present) {
      map['rest_timer_target_end_at'] = Variable<DateTime>(
        restTimerTargetEndAt.value,
      );
    }
    if (restTimerRemainingSeconds.present) {
      map['rest_timer_remaining_seconds'] = Variable<int>(
        restTimerRemainingSeconds.value,
      );
    }
    if (autoStartRestTimer.present) {
      map['auto_start_rest_timer'] = Variable<bool>(autoStartRestTimer.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('sourceTemplateId: $sourceTemplateId, ')
          ..write('startedAt: $startedAt, ')
          ..write('notes: $notes, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('restTimerState: $restTimerState, ')
          ..write('restTimerDurationSeconds: $restTimerDurationSeconds, ')
          ..write('restTimerTargetEndAt: $restTimerTargetEndAt, ')
          ..write('restTimerRemainingSeconds: $restTimerRemainingSeconds, ')
          ..write('autoStartRestTimer: $autoStartRestTimer, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveWorkoutExercisesTable extends ActiveWorkoutExercises
    with TableInfo<$ActiveWorkoutExercisesTable, ActiveWorkoutExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveWorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES active_workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseSourceMeta = const VerificationMeta(
    'exerciseSource',
  );
  @override
  late final GeneratedColumn<String> exerciseSource = GeneratedColumn<String>(
    'exercise_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseKeyMeta = const VerificationMeta(
    'exerciseKey',
  );
  @override
  late final GeneratedColumn<String> exerciseKey = GeneratedColumn<String>(
    'exercise_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemExerciseKeyMeta = const VerificationMeta(
    'systemExerciseKey',
  );
  @override
  late final GeneratedColumn<String> systemExerciseKey =
      GeneratedColumn<String>(
        'system_exercise_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customExerciseIdMeta = const VerificationMeta(
    'customExerciseId',
  );
  @override
  late final GeneratedColumn<String> customExerciseId = GeneratedColumn<String>(
    'custom_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleGroupMeta =
      const VerificationMeta('primaryMuscleGroup');
  @override
  late final GeneratedColumn<String> primaryMuscleGroup =
      GeneratedColumn<String>(
        'primary_muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _secondaryMuscleGroupsJsonMeta =
      const VerificationMeta('secondaryMuscleGroupsJson');
  @override
  late final GeneratedColumn<String> secondaryMuscleGroupsJson =
      GeneratedColumn<String>(
        'secondary_muscle_groups_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackingTypeMeta = const VerificationMeta(
    'trackingType',
  );
  @override
  late final GeneratedColumn<String> trackingType = GeneratedColumn<String>(
    'tracking_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightRelevantMeta = const VerificationMeta(
    'weightRelevant',
  );
  @override
  late final GeneratedColumn<bool> weightRelevant = GeneratedColumn<bool>(
    'weight_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weight_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _repetitionsRelevantMeta =
      const VerificationMeta('repetitionsRelevant');
  @override
  late final GeneratedColumn<bool> repetitionsRelevant = GeneratedColumn<bool>(
    'repetitions_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repetitions_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _distanceRelevantMeta = const VerificationMeta(
    'distanceRelevant',
  );
  @override
  late final GeneratedColumn<bool> distanceRelevant = GeneratedColumn<bool>(
    'distance_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("distance_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationRelevantMeta = const VerificationMeta(
    'durationRelevant',
  );
  @override
  late final GeneratedColumn<bool> durationRelevant = GeneratedColumn<bool>(
    'duration_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("duration_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _bodyweightRelevantMeta =
      const VerificationMeta('bodyweightRelevant');
  @override
  late final GeneratedColumn<bool> bodyweightRelevant = GeneratedColumn<bool>(
    'bodyweight_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bodyweight_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _plannedWorkingSetsMeta =
      const VerificationMeta('plannedWorkingSets');
  @override
  late final GeneratedColumn<int> plannedWorkingSets = GeneratedColumn<int>(
    'planned_working_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedWarmupSetsMeta = const VerificationMeta(
    'plannedWarmupSets',
  );
  @override
  late final GeneratedColumn<int> plannedWarmupSets = GeneratedColumn<int>(
    'planned_warmup_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minTargetRepsMeta = const VerificationMeta(
    'minTargetReps',
  );
  @override
  late final GeneratedColumn<int> minTargetReps = GeneratedColumn<int>(
    'min_target_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxTargetRepsMeta = const VerificationMeta(
    'maxTargetReps',
  );
  @override
  late final GeneratedColumn<int> maxTargetReps = GeneratedColumn<int>(
    'max_target_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rpeTargetMeta = const VerificationMeta(
    'rpeTarget',
  );
  @override
  late final GeneratedColumn<double> rpeTarget = GeneratedColumn<double>(
    'rpe_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirTargetMeta = const VerificationMeta(
    'rirTarget',
  );
  @override
  late final GeneratedColumn<double> rirTarget = GeneratedColumn<double>(
    'rir_target',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sessionId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    trackingType,
    weightRelevant,
    repetitionsRelevant,
    distanceRelevant,
    durationRelevant,
    bodyweightRelevant,
    plannedWorkingSets,
    plannedWarmupSets,
    minTargetReps,
    maxTargetReps,
    targetWeightKg,
    restSeconds,
    rpeTarget,
    rirTarget,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveWorkoutExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_source')) {
      context.handle(
        _exerciseSourceMeta,
        exerciseSource.isAcceptableOrUnknown(
          data['exercise_source']!,
          _exerciseSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseSourceMeta);
    }
    if (data.containsKey('exercise_key')) {
      context.handle(
        _exerciseKeyMeta,
        exerciseKey.isAcceptableOrUnknown(
          data['exercise_key']!,
          _exerciseKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseKeyMeta);
    }
    if (data.containsKey('system_exercise_key')) {
      context.handle(
        _systemExerciseKeyMeta,
        systemExerciseKey.isAcceptableOrUnknown(
          data['system_exercise_key']!,
          _systemExerciseKeyMeta,
        ),
      );
    }
    if (data.containsKey('custom_exercise_id')) {
      context.handle(
        _customExerciseIdMeta,
        customExerciseId.isAcceptableOrUnknown(
          data['custom_exercise_id']!,
          _customExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('primary_muscle_group')) {
      context.handle(
        _primaryMuscleGroupMeta,
        primaryMuscleGroup.isAcceptableOrUnknown(
          data['primary_muscle_group']!,
          _primaryMuscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleGroupMeta);
    }
    if (data.containsKey('secondary_muscle_groups_json')) {
      context.handle(
        _secondaryMuscleGroupsJsonMeta,
        secondaryMuscleGroupsJson.isAcceptableOrUnknown(
          data['secondary_muscle_groups_json']!,
          _secondaryMuscleGroupsJsonMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('tracking_type')) {
      context.handle(
        _trackingTypeMeta,
        trackingType.isAcceptableOrUnknown(
          data['tracking_type']!,
          _trackingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackingTypeMeta);
    }
    if (data.containsKey('weight_relevant')) {
      context.handle(
        _weightRelevantMeta,
        weightRelevant.isAcceptableOrUnknown(
          data['weight_relevant']!,
          _weightRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightRelevantMeta);
    }
    if (data.containsKey('repetitions_relevant')) {
      context.handle(
        _repetitionsRelevantMeta,
        repetitionsRelevant.isAcceptableOrUnknown(
          data['repetitions_relevant']!,
          _repetitionsRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repetitionsRelevantMeta);
    }
    if (data.containsKey('distance_relevant')) {
      context.handle(
        _distanceRelevantMeta,
        distanceRelevant.isAcceptableOrUnknown(
          data['distance_relevant']!,
          _distanceRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceRelevantMeta);
    }
    if (data.containsKey('duration_relevant')) {
      context.handle(
        _durationRelevantMeta,
        durationRelevant.isAcceptableOrUnknown(
          data['duration_relevant']!,
          _durationRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationRelevantMeta);
    }
    if (data.containsKey('bodyweight_relevant')) {
      context.handle(
        _bodyweightRelevantMeta,
        bodyweightRelevant.isAcceptableOrUnknown(
          data['bodyweight_relevant']!,
          _bodyweightRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyweightRelevantMeta);
    }
    if (data.containsKey('planned_working_sets')) {
      context.handle(
        _plannedWorkingSetsMeta,
        plannedWorkingSets.isAcceptableOrUnknown(
          data['planned_working_sets']!,
          _plannedWorkingSetsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedWorkingSetsMeta);
    }
    if (data.containsKey('planned_warmup_sets')) {
      context.handle(
        _plannedWarmupSetsMeta,
        plannedWarmupSets.isAcceptableOrUnknown(
          data['planned_warmup_sets']!,
          _plannedWarmupSetsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedWarmupSetsMeta);
    }
    if (data.containsKey('min_target_reps')) {
      context.handle(
        _minTargetRepsMeta,
        minTargetReps.isAcceptableOrUnknown(
          data['min_target_reps']!,
          _minTargetRepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minTargetRepsMeta);
    }
    if (data.containsKey('max_target_reps')) {
      context.handle(
        _maxTargetRepsMeta,
        maxTargetReps.isAcceptableOrUnknown(
          data['max_target_reps']!,
          _maxTargetRepsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxTargetRepsMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('rpe_target')) {
      context.handle(
        _rpeTargetMeta,
        rpeTarget.isAcceptableOrUnknown(data['rpe_target']!, _rpeTargetMeta),
      );
    }
    if (data.containsKey('rir_target')) {
      context.handle(
        _rirTargetMeta,
        rirTarget.isAcceptableOrUnknown(data['rir_target']!, _rirTargetMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveWorkoutExerciseRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveWorkoutExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_source'],
      )!,
      exerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_key'],
      )!,
      systemExerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_exercise_key'],
      ),
      customExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_exercise_id'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      primaryMuscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle_group'],
      )!,
      secondaryMuscleGroupsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_muscle_groups_json'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      trackingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_type'],
      )!,
      weightRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weight_relevant'],
      )!,
      repetitionsRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repetitions_relevant'],
      )!,
      distanceRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}distance_relevant'],
      )!,
      durationRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}duration_relevant'],
      )!,
      bodyweightRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bodyweight_relevant'],
      )!,
      plannedWorkingSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_working_sets'],
      )!,
      plannedWarmupSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_warmup_sets'],
      )!,
      minTargetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_target_reps'],
      )!,
      maxTargetReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_target_reps'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      rpeTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe_target'],
      ),
      rirTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rir_target'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ActiveWorkoutExercisesTable createAlias(String alias) {
    return $ActiveWorkoutExercisesTable(attachedDatabase, alias);
  }
}

class ActiveWorkoutExerciseRow extends DataClass
    implements Insertable<ActiveWorkoutExerciseRow> {
  final String id;
  final String userId;
  final String sessionId;
  final String exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final String primaryMuscleGroup;
  final String secondaryMuscleGroupsJson;
  final String equipment;
  final String trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;
  final int plannedWorkingSets;
  final int plannedWarmupSets;
  final int minTargetReps;
  final int maxTargetReps;
  final double? targetWeightKg;
  final int restSeconds;
  final double? rpeTarget;
  final double? rirTarget;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const ActiveWorkoutExerciseRow({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.exerciseSource,
    required this.exerciseKey,
    this.systemExerciseKey,
    this.customExerciseId,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    required this.secondaryMuscleGroupsJson,
    required this.equipment,
    required this.trackingType,
    required this.weightRelevant,
    required this.repetitionsRelevant,
    required this.distanceRelevant,
    required this.durationRelevant,
    required this.bodyweightRelevant,
    required this.plannedWorkingSets,
    required this.plannedWarmupSets,
    required this.minTargetReps,
    required this.maxTargetReps,
    this.targetWeightKg,
    required this.restSeconds,
    this.rpeTarget,
    this.rirTarget,
    this.notes,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_source'] = Variable<String>(exerciseSource);
    map['exercise_key'] = Variable<String>(exerciseKey);
    if (!nullToAbsent || systemExerciseKey != null) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey);
    }
    if (!nullToAbsent || customExerciseId != null) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId);
    }
    map['exercise_name'] = Variable<String>(exerciseName);
    map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup);
    map['secondary_muscle_groups_json'] = Variable<String>(
      secondaryMuscleGroupsJson,
    );
    map['equipment'] = Variable<String>(equipment);
    map['tracking_type'] = Variable<String>(trackingType);
    map['weight_relevant'] = Variable<bool>(weightRelevant);
    map['repetitions_relevant'] = Variable<bool>(repetitionsRelevant);
    map['distance_relevant'] = Variable<bool>(distanceRelevant);
    map['duration_relevant'] = Variable<bool>(durationRelevant);
    map['bodyweight_relevant'] = Variable<bool>(bodyweightRelevant);
    map['planned_working_sets'] = Variable<int>(plannedWorkingSets);
    map['planned_warmup_sets'] = Variable<int>(plannedWarmupSets);
    map['min_target_reps'] = Variable<int>(minTargetReps);
    map['max_target_reps'] = Variable<int>(maxTargetReps);
    if (!nullToAbsent || targetWeightKg != null) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    if (!nullToAbsent || rpeTarget != null) {
      map['rpe_target'] = Variable<double>(rpeTarget);
    }
    if (!nullToAbsent || rirTarget != null) {
      map['rir_target'] = Variable<double>(rirTarget);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  ActiveWorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return ActiveWorkoutExercisesCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      exerciseSource: Value(exerciseSource),
      exerciseKey: Value(exerciseKey),
      systemExerciseKey: systemExerciseKey == null && nullToAbsent
          ? const Value.absent()
          : Value(systemExerciseKey),
      customExerciseId: customExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(customExerciseId),
      exerciseName: Value(exerciseName),
      primaryMuscleGroup: Value(primaryMuscleGroup),
      secondaryMuscleGroupsJson: Value(secondaryMuscleGroupsJson),
      equipment: Value(equipment),
      trackingType: Value(trackingType),
      weightRelevant: Value(weightRelevant),
      repetitionsRelevant: Value(repetitionsRelevant),
      distanceRelevant: Value(distanceRelevant),
      durationRelevant: Value(durationRelevant),
      bodyweightRelevant: Value(bodyweightRelevant),
      plannedWorkingSets: Value(plannedWorkingSets),
      plannedWarmupSets: Value(plannedWarmupSets),
      minTargetReps: Value(minTargetReps),
      maxTargetReps: Value(maxTargetReps),
      targetWeightKg: targetWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeightKg),
      restSeconds: Value(restSeconds),
      rpeTarget: rpeTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(rpeTarget),
      rirTarget: rirTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(rirTarget),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory ActiveWorkoutExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveWorkoutExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseKey: serializer.fromJson<String>(json['exerciseKey']),
      systemExerciseKey: serializer.fromJson<String?>(
        json['systemExerciseKey'],
      ),
      customExerciseId: serializer.fromJson<String?>(json['customExerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      primaryMuscleGroup: serializer.fromJson<String>(
        json['primaryMuscleGroup'],
      ),
      secondaryMuscleGroupsJson: serializer.fromJson<String>(
        json['secondaryMuscleGroupsJson'],
      ),
      equipment: serializer.fromJson<String>(json['equipment']),
      trackingType: serializer.fromJson<String>(json['trackingType']),
      weightRelevant: serializer.fromJson<bool>(json['weightRelevant']),
      repetitionsRelevant: serializer.fromJson<bool>(
        json['repetitionsRelevant'],
      ),
      distanceRelevant: serializer.fromJson<bool>(json['distanceRelevant']),
      durationRelevant: serializer.fromJson<bool>(json['durationRelevant']),
      bodyweightRelevant: serializer.fromJson<bool>(json['bodyweightRelevant']),
      plannedWorkingSets: serializer.fromJson<int>(json['plannedWorkingSets']),
      plannedWarmupSets: serializer.fromJson<int>(json['plannedWarmupSets']),
      minTargetReps: serializer.fromJson<int>(json['minTargetReps']),
      maxTargetReps: serializer.fromJson<int>(json['maxTargetReps']),
      targetWeightKg: serializer.fromJson<double?>(json['targetWeightKg']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      rpeTarget: serializer.fromJson<double?>(json['rpeTarget']),
      rirTarget: serializer.fromJson<double?>(json['rirTarget']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseKey': serializer.toJson<String>(exerciseKey),
      'systemExerciseKey': serializer.toJson<String?>(systemExerciseKey),
      'customExerciseId': serializer.toJson<String?>(customExerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'primaryMuscleGroup': serializer.toJson<String>(primaryMuscleGroup),
      'secondaryMuscleGroupsJson': serializer.toJson<String>(
        secondaryMuscleGroupsJson,
      ),
      'equipment': serializer.toJson<String>(equipment),
      'trackingType': serializer.toJson<String>(trackingType),
      'weightRelevant': serializer.toJson<bool>(weightRelevant),
      'repetitionsRelevant': serializer.toJson<bool>(repetitionsRelevant),
      'distanceRelevant': serializer.toJson<bool>(distanceRelevant),
      'durationRelevant': serializer.toJson<bool>(durationRelevant),
      'bodyweightRelevant': serializer.toJson<bool>(bodyweightRelevant),
      'plannedWorkingSets': serializer.toJson<int>(plannedWorkingSets),
      'plannedWarmupSets': serializer.toJson<int>(plannedWarmupSets),
      'minTargetReps': serializer.toJson<int>(minTargetReps),
      'maxTargetReps': serializer.toJson<int>(maxTargetReps),
      'targetWeightKg': serializer.toJson<double?>(targetWeightKg),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'rpeTarget': serializer.toJson<double?>(rpeTarget),
      'rirTarget': serializer.toJson<double?>(rirTarget),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  ActiveWorkoutExerciseRow copyWith({
    String? id,
    String? userId,
    String? sessionId,
    String? exerciseSource,
    String? exerciseKey,
    Value<String?> systemExerciseKey = const Value.absent(),
    Value<String?> customExerciseId = const Value.absent(),
    String? exerciseName,
    String? primaryMuscleGroup,
    String? secondaryMuscleGroupsJson,
    String? equipment,
    String? trackingType,
    bool? weightRelevant,
    bool? repetitionsRelevant,
    bool? distanceRelevant,
    bool? durationRelevant,
    bool? bodyweightRelevant,
    int? plannedWorkingSets,
    int? plannedWarmupSets,
    int? minTargetReps,
    int? maxTargetReps,
    Value<double?> targetWeightKg = const Value.absent(),
    int? restSeconds,
    Value<double?> rpeTarget = const Value.absent(),
    Value<double?> rirTarget = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => ActiveWorkoutExerciseRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sessionId: sessionId ?? this.sessionId,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseKey: exerciseKey ?? this.exerciseKey,
    systemExerciseKey: systemExerciseKey.present
        ? systemExerciseKey.value
        : this.systemExerciseKey,
    customExerciseId: customExerciseId.present
        ? customExerciseId.value
        : this.customExerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
    secondaryMuscleGroupsJson:
        secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
    equipment: equipment ?? this.equipment,
    trackingType: trackingType ?? this.trackingType,
    weightRelevant: weightRelevant ?? this.weightRelevant,
    repetitionsRelevant: repetitionsRelevant ?? this.repetitionsRelevant,
    distanceRelevant: distanceRelevant ?? this.distanceRelevant,
    durationRelevant: durationRelevant ?? this.durationRelevant,
    bodyweightRelevant: bodyweightRelevant ?? this.bodyweightRelevant,
    plannedWorkingSets: plannedWorkingSets ?? this.plannedWorkingSets,
    plannedWarmupSets: plannedWarmupSets ?? this.plannedWarmupSets,
    minTargetReps: minTargetReps ?? this.minTargetReps,
    maxTargetReps: maxTargetReps ?? this.maxTargetReps,
    targetWeightKg: targetWeightKg.present
        ? targetWeightKg.value
        : this.targetWeightKg,
    restSeconds: restSeconds ?? this.restSeconds,
    rpeTarget: rpeTarget.present ? rpeTarget.value : this.rpeTarget,
    rirTarget: rirTarget.present ? rirTarget.value : this.rirTarget,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  ActiveWorkoutExerciseRow copyWithCompanion(
    ActiveWorkoutExercisesCompanion data,
  ) {
    return ActiveWorkoutExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseSource: data.exerciseSource.present
          ? data.exerciseSource.value
          : this.exerciseSource,
      exerciseKey: data.exerciseKey.present
          ? data.exerciseKey.value
          : this.exerciseKey,
      systemExerciseKey: data.systemExerciseKey.present
          ? data.systemExerciseKey.value
          : this.systemExerciseKey,
      customExerciseId: data.customExerciseId.present
          ? data.customExerciseId.value
          : this.customExerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      primaryMuscleGroup: data.primaryMuscleGroup.present
          ? data.primaryMuscleGroup.value
          : this.primaryMuscleGroup,
      secondaryMuscleGroupsJson: data.secondaryMuscleGroupsJson.present
          ? data.secondaryMuscleGroupsJson.value
          : this.secondaryMuscleGroupsJson,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      trackingType: data.trackingType.present
          ? data.trackingType.value
          : this.trackingType,
      weightRelevant: data.weightRelevant.present
          ? data.weightRelevant.value
          : this.weightRelevant,
      repetitionsRelevant: data.repetitionsRelevant.present
          ? data.repetitionsRelevant.value
          : this.repetitionsRelevant,
      distanceRelevant: data.distanceRelevant.present
          ? data.distanceRelevant.value
          : this.distanceRelevant,
      durationRelevant: data.durationRelevant.present
          ? data.durationRelevant.value
          : this.durationRelevant,
      bodyweightRelevant: data.bodyweightRelevant.present
          ? data.bodyweightRelevant.value
          : this.bodyweightRelevant,
      plannedWorkingSets: data.plannedWorkingSets.present
          ? data.plannedWorkingSets.value
          : this.plannedWorkingSets,
      plannedWarmupSets: data.plannedWarmupSets.present
          ? data.plannedWarmupSets.value
          : this.plannedWarmupSets,
      minTargetReps: data.minTargetReps.present
          ? data.minTargetReps.value
          : this.minTargetReps,
      maxTargetReps: data.maxTargetReps.present
          ? data.maxTargetReps.value
          : this.maxTargetReps,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      rpeTarget: data.rpeTarget.present ? data.rpeTarget.value : this.rpeTarget,
      rirTarget: data.rirTarget.present ? data.rirTarget.value : this.rirTarget,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutExerciseRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('trackingType: $trackingType, ')
          ..write('weightRelevant: $weightRelevant, ')
          ..write('repetitionsRelevant: $repetitionsRelevant, ')
          ..write('distanceRelevant: $distanceRelevant, ')
          ..write('durationRelevant: $durationRelevant, ')
          ..write('bodyweightRelevant: $bodyweightRelevant, ')
          ..write('plannedWorkingSets: $plannedWorkingSets, ')
          ..write('plannedWarmupSets: $plannedWarmupSets, ')
          ..write('minTargetReps: $minTargetReps, ')
          ..write('maxTargetReps: $maxTargetReps, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('rpeTarget: $rpeTarget, ')
          ..write('rirTarget: $rirTarget, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    sessionId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    trackingType,
    weightRelevant,
    repetitionsRelevant,
    distanceRelevant,
    durationRelevant,
    bodyweightRelevant,
    plannedWorkingSets,
    plannedWarmupSets,
    minTargetReps,
    maxTargetReps,
    targetWeightKg,
    restSeconds,
    rpeTarget,
    rirTarget,
    notes,
    sortOrder,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveWorkoutExerciseRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseKey == this.exerciseKey &&
          other.systemExerciseKey == this.systemExerciseKey &&
          other.customExerciseId == this.customExerciseId &&
          other.exerciseName == this.exerciseName &&
          other.primaryMuscleGroup == this.primaryMuscleGroup &&
          other.secondaryMuscleGroupsJson == this.secondaryMuscleGroupsJson &&
          other.equipment == this.equipment &&
          other.trackingType == this.trackingType &&
          other.weightRelevant == this.weightRelevant &&
          other.repetitionsRelevant == this.repetitionsRelevant &&
          other.distanceRelevant == this.distanceRelevant &&
          other.durationRelevant == this.durationRelevant &&
          other.bodyweightRelevant == this.bodyweightRelevant &&
          other.plannedWorkingSets == this.plannedWorkingSets &&
          other.plannedWarmupSets == this.plannedWarmupSets &&
          other.minTargetReps == this.minTargetReps &&
          other.maxTargetReps == this.maxTargetReps &&
          other.targetWeightKg == this.targetWeightKg &&
          other.restSeconds == this.restSeconds &&
          other.rpeTarget == this.rpeTarget &&
          other.rirTarget == this.rirTarget &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class ActiveWorkoutExercisesCompanion
    extends UpdateCompanion<ActiveWorkoutExerciseRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<String> exerciseSource;
  final Value<String> exerciseKey;
  final Value<String?> systemExerciseKey;
  final Value<String?> customExerciseId;
  final Value<String> exerciseName;
  final Value<String> primaryMuscleGroup;
  final Value<String> secondaryMuscleGroupsJson;
  final Value<String> equipment;
  final Value<String> trackingType;
  final Value<bool> weightRelevant;
  final Value<bool> repetitionsRelevant;
  final Value<bool> distanceRelevant;
  final Value<bool> durationRelevant;
  final Value<bool> bodyweightRelevant;
  final Value<int> plannedWorkingSets;
  final Value<int> plannedWarmupSets;
  final Value<int> minTargetReps;
  final Value<int> maxTargetReps;
  final Value<double?> targetWeightKg;
  final Value<int> restSeconds;
  final Value<double?> rpeTarget;
  final Value<double?> rirTarget;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const ActiveWorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseKey = const Value.absent(),
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.primaryMuscleGroup = const Value.absent(),
    this.secondaryMuscleGroupsJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.trackingType = const Value.absent(),
    this.weightRelevant = const Value.absent(),
    this.repetitionsRelevant = const Value.absent(),
    this.distanceRelevant = const Value.absent(),
    this.durationRelevant = const Value.absent(),
    this.bodyweightRelevant = const Value.absent(),
    this.plannedWorkingSets = const Value.absent(),
    this.plannedWarmupSets = const Value.absent(),
    this.minTargetReps = const Value.absent(),
    this.maxTargetReps = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.rpeTarget = const Value.absent(),
    this.rirTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveWorkoutExercisesCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    required String exerciseSource,
    required String exerciseKey,
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    required String exerciseName,
    required String primaryMuscleGroup,
    this.secondaryMuscleGroupsJson = const Value.absent(),
    required String equipment,
    required String trackingType,
    required bool weightRelevant,
    required bool repetitionsRelevant,
    required bool distanceRelevant,
    required bool durationRelevant,
    required bool bodyweightRelevant,
    required int plannedWorkingSets,
    required int plannedWarmupSets,
    required int minTargetReps,
    required int maxTargetReps,
    this.targetWeightKg = const Value.absent(),
    required int restSeconds,
    this.rpeTarget = const Value.absent(),
    this.rirTarget = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sessionId = Value(sessionId),
       exerciseSource = Value(exerciseSource),
       exerciseKey = Value(exerciseKey),
       exerciseName = Value(exerciseName),
       primaryMuscleGroup = Value(primaryMuscleGroup),
       equipment = Value(equipment),
       trackingType = Value(trackingType),
       weightRelevant = Value(weightRelevant),
       repetitionsRelevant = Value(repetitionsRelevant),
       distanceRelevant = Value(distanceRelevant),
       durationRelevant = Value(durationRelevant),
       bodyweightRelevant = Value(bodyweightRelevant),
       plannedWorkingSets = Value(plannedWorkingSets),
       plannedWarmupSets = Value(plannedWarmupSets),
       minTargetReps = Value(minTargetReps),
       maxTargetReps = Value(maxTargetReps),
       restSeconds = Value(restSeconds),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveWorkoutExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseKey,
    Expression<String>? systemExerciseKey,
    Expression<String>? customExerciseId,
    Expression<String>? exerciseName,
    Expression<String>? primaryMuscleGroup,
    Expression<String>? secondaryMuscleGroupsJson,
    Expression<String>? equipment,
    Expression<String>? trackingType,
    Expression<bool>? weightRelevant,
    Expression<bool>? repetitionsRelevant,
    Expression<bool>? distanceRelevant,
    Expression<bool>? durationRelevant,
    Expression<bool>? bodyweightRelevant,
    Expression<int>? plannedWorkingSets,
    Expression<int>? plannedWarmupSets,
    Expression<int>? minTargetReps,
    Expression<int>? maxTargetReps,
    Expression<double>? targetWeightKg,
    Expression<int>? restSeconds,
    Expression<double>? rpeTarget,
    Expression<double>? rirTarget,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseKey != null) 'exercise_key': exerciseKey,
      if (systemExerciseKey != null) 'system_exercise_key': systemExerciseKey,
      if (customExerciseId != null) 'custom_exercise_id': customExerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (primaryMuscleGroup != null)
        'primary_muscle_group': primaryMuscleGroup,
      if (secondaryMuscleGroupsJson != null)
        'secondary_muscle_groups_json': secondaryMuscleGroupsJson,
      if (equipment != null) 'equipment': equipment,
      if (trackingType != null) 'tracking_type': trackingType,
      if (weightRelevant != null) 'weight_relevant': weightRelevant,
      if (repetitionsRelevant != null)
        'repetitions_relevant': repetitionsRelevant,
      if (distanceRelevant != null) 'distance_relevant': distanceRelevant,
      if (durationRelevant != null) 'duration_relevant': durationRelevant,
      if (bodyweightRelevant != null) 'bodyweight_relevant': bodyweightRelevant,
      if (plannedWorkingSets != null)
        'planned_working_sets': plannedWorkingSets,
      if (plannedWarmupSets != null) 'planned_warmup_sets': plannedWarmupSets,
      if (minTargetReps != null) 'min_target_reps': minTargetReps,
      if (maxTargetReps != null) 'max_target_reps': maxTargetReps,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (rpeTarget != null) 'rpe_target': rpeTarget,
      if (rirTarget != null) 'rir_target': rirTarget,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveWorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sessionId,
    Value<String>? exerciseSource,
    Value<String>? exerciseKey,
    Value<String?>? systemExerciseKey,
    Value<String?>? customExerciseId,
    Value<String>? exerciseName,
    Value<String>? primaryMuscleGroup,
    Value<String>? secondaryMuscleGroupsJson,
    Value<String>? equipment,
    Value<String>? trackingType,
    Value<bool>? weightRelevant,
    Value<bool>? repetitionsRelevant,
    Value<bool>? distanceRelevant,
    Value<bool>? durationRelevant,
    Value<bool>? bodyweightRelevant,
    Value<int>? plannedWorkingSets,
    Value<int>? plannedWarmupSets,
    Value<int>? minTargetReps,
    Value<int>? maxTargetReps,
    Value<double?>? targetWeightKg,
    Value<int>? restSeconds,
    Value<double?>? rpeTarget,
    Value<double?>? rirTarget,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return ActiveWorkoutExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseKey: exerciseKey ?? this.exerciseKey,
      systemExerciseKey: systemExerciseKey ?? this.systemExerciseKey,
      customExerciseId: customExerciseId ?? this.customExerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      secondaryMuscleGroupsJson:
          secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
      equipment: equipment ?? this.equipment,
      trackingType: trackingType ?? this.trackingType,
      weightRelevant: weightRelevant ?? this.weightRelevant,
      repetitionsRelevant: repetitionsRelevant ?? this.repetitionsRelevant,
      distanceRelevant: distanceRelevant ?? this.distanceRelevant,
      durationRelevant: durationRelevant ?? this.durationRelevant,
      bodyweightRelevant: bodyweightRelevant ?? this.bodyweightRelevant,
      plannedWorkingSets: plannedWorkingSets ?? this.plannedWorkingSets,
      plannedWarmupSets: plannedWarmupSets ?? this.plannedWarmupSets,
      minTargetReps: minTargetReps ?? this.minTargetReps,
      maxTargetReps: maxTargetReps ?? this.maxTargetReps,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      restSeconds: restSeconds ?? this.restSeconds,
      rpeTarget: rpeTarget ?? this.rpeTarget,
      rirTarget: rirTarget ?? this.rirTarget,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseSource.present) {
      map['exercise_source'] = Variable<String>(exerciseSource.value);
    }
    if (exerciseKey.present) {
      map['exercise_key'] = Variable<String>(exerciseKey.value);
    }
    if (systemExerciseKey.present) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey.value);
    }
    if (customExerciseId.present) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (primaryMuscleGroup.present) {
      map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup.value);
    }
    if (secondaryMuscleGroupsJson.present) {
      map['secondary_muscle_groups_json'] = Variable<String>(
        secondaryMuscleGroupsJson.value,
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (trackingType.present) {
      map['tracking_type'] = Variable<String>(trackingType.value);
    }
    if (weightRelevant.present) {
      map['weight_relevant'] = Variable<bool>(weightRelevant.value);
    }
    if (repetitionsRelevant.present) {
      map['repetitions_relevant'] = Variable<bool>(repetitionsRelevant.value);
    }
    if (distanceRelevant.present) {
      map['distance_relevant'] = Variable<bool>(distanceRelevant.value);
    }
    if (durationRelevant.present) {
      map['duration_relevant'] = Variable<bool>(durationRelevant.value);
    }
    if (bodyweightRelevant.present) {
      map['bodyweight_relevant'] = Variable<bool>(bodyweightRelevant.value);
    }
    if (plannedWorkingSets.present) {
      map['planned_working_sets'] = Variable<int>(plannedWorkingSets.value);
    }
    if (plannedWarmupSets.present) {
      map['planned_warmup_sets'] = Variable<int>(plannedWarmupSets.value);
    }
    if (minTargetReps.present) {
      map['min_target_reps'] = Variable<int>(minTargetReps.value);
    }
    if (maxTargetReps.present) {
      map['max_target_reps'] = Variable<int>(maxTargetReps.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (rpeTarget.present) {
      map['rpe_target'] = Variable<double>(rpeTarget.value);
    }
    if (rirTarget.present) {
      map['rir_target'] = Variable<double>(rirTarget.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('trackingType: $trackingType, ')
          ..write('weightRelevant: $weightRelevant, ')
          ..write('repetitionsRelevant: $repetitionsRelevant, ')
          ..write('distanceRelevant: $distanceRelevant, ')
          ..write('durationRelevant: $durationRelevant, ')
          ..write('bodyweightRelevant: $bodyweightRelevant, ')
          ..write('plannedWorkingSets: $plannedWorkingSets, ')
          ..write('plannedWarmupSets: $plannedWarmupSets, ')
          ..write('minTargetReps: $minTargetReps, ')
          ..write('maxTargetReps: $maxTargetReps, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('rpeTarget: $rpeTarget, ')
          ..write('rirTarget: $rirTarget, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActiveWorkoutSetsTable extends ActiveWorkoutSets
    with TableInfo<$ActiveWorkoutSetsTable, ActiveWorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActiveWorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES active_workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<String> sessionExerciseId =
      GeneratedColumn<String>(
        'session_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES active_workout_exercises (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<double> rir = GeneratedColumn<double>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sessionId,
    sessionExerciseId,
    setType,
    weightKg,
    repetitions,
    durationSeconds,
    distanceMeters,
    rpe,
    rir,
    isCompleted,
    notes,
    sortOrder,
    completedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'active_workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActiveWorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActiveWorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActiveWorkoutSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rir'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ActiveWorkoutSetsTable createAlias(String alias) {
    return $ActiveWorkoutSetsTable(attachedDatabase, alias);
  }
}

class ActiveWorkoutSetRow extends DataClass
    implements Insertable<ActiveWorkoutSetRow> {
  final String id;
  final String userId;
  final String sessionId;
  final String sessionExerciseId;
  final String setType;
  final double? weightKg;
  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? rpe;
  final double? rir;
  final bool isCompleted;
  final String? notes;
  final int sortOrder;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const ActiveWorkoutSetRow({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.setType,
    this.weightKg,
    this.repetitions,
    this.durationSeconds,
    this.distanceMeters,
    this.rpe,
    this.rir,
    required this.isCompleted,
    this.notes,
    required this.sortOrder,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    map['session_exercise_id'] = Variable<String>(sessionExerciseId);
    map['set_type'] = Variable<String>(setType);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<double>(rir);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  ActiveWorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return ActiveWorkoutSetsCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      sessionExerciseId: Value(sessionExerciseId),
      setType: Value(setType),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      isCompleted: Value(isCompleted),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory ActiveWorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActiveWorkoutSetRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sessionExerciseId: serializer.fromJson<String>(json['sessionExerciseId']),
      setType: serializer.fromJson<String>(json['setType']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      rir: serializer.fromJson<double?>(json['rir']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'sessionExerciseId': serializer.toJson<String>(sessionExerciseId),
      'setType': serializer.toJson<String>(setType),
      'weightKg': serializer.toJson<double?>(weightKg),
      'repetitions': serializer.toJson<int?>(repetitions),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
      'rpe': serializer.toJson<double?>(rpe),
      'rir': serializer.toJson<double?>(rir),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  ActiveWorkoutSetRow copyWith({
    String? id,
    String? userId,
    String? sessionId,
    String? sessionExerciseId,
    String? setType,
    Value<double?> weightKg = const Value.absent(),
    Value<int?> repetitions = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    Value<double?> rir = const Value.absent(),
    bool? isCompleted,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => ActiveWorkoutSetRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sessionId: sessionId ?? this.sessionId,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    setType: setType ?? this.setType,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
    rpe: rpe.present ? rpe.value : this.rpe,
    rir: rir.present ? rir.value : this.rir,
    isCompleted: isCompleted ?? this.isCompleted,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  ActiveWorkoutSetRow copyWithCompanion(ActiveWorkoutSetsCompanion data) {
    return ActiveWorkoutSetRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      setType: data.setType.present ? data.setType.value : this.setType,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      rir: data.rir.present ? data.rir.value : this.rir,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutSetRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sessionId,
    sessionExerciseId,
    setType,
    weightKg,
    repetitions,
    durationSeconds,
    distanceMeters,
    rpe,
    rir,
    isCompleted,
    notes,
    sortOrder,
    completedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActiveWorkoutSetRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.setType == this.setType &&
          other.weightKg == this.weightKg &&
          other.repetitions == this.repetitions &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.rpe == this.rpe &&
          other.rir == this.rir &&
          other.isCompleted == this.isCompleted &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class ActiveWorkoutSetsCompanion extends UpdateCompanion<ActiveWorkoutSetRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<String> sessionExerciseId;
  final Value<String> setType;
  final Value<double?> weightKg;
  final Value<int?> repetitions;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<double?> rpe;
  final Value<double?> rir;
  final Value<bool> isCompleted;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const ActiveWorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.setType = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rpe = const Value.absent(),
    this.rir = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActiveWorkoutSetsCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    required String sessionExerciseId,
    required String setType,
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rpe = const Value.absent(),
    this.rir = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sessionId = Value(sessionId),
       sessionExerciseId = Value(sessionExerciseId),
       setType = Value(setType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ActiveWorkoutSetRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? sessionExerciseId,
    Expression<String>? setType,
    Expression<double>? weightKg,
    Expression<int>? repetitions,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<double>? rpe,
    Expression<double>? rir,
    Expression<bool>? isCompleted,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (setType != null) 'set_type': setType,
      if (weightKg != null) 'weight_kg': weightKg,
      if (repetitions != null) 'repetitions': repetitions,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (rpe != null) 'rpe': rpe,
      if (rir != null) 'rir': rir,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActiveWorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sessionId,
    Value<String>? sessionExerciseId,
    Value<String>? setType,
    Value<double?>? weightKg,
    Value<int?>? repetitions,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<double?>? rpe,
    Value<double?>? rir,
    Value<bool>? isCompleted,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return ActiveWorkoutSetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      setType: setType ?? this.setType,
      weightKg: weightKg ?? this.weightKg,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      rpe: rpe ?? this.rpe,
      rir: rir ?? this.rir,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<String>(sessionExerciseId.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (rir.present) {
      map['rir'] = Variable<double>(rir.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActiveWorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletedWorkoutSessionsTable extends CompletedWorkoutSessions
    with TableInfo<$CompletedWorkoutSessionsTable, CompletedWorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedWorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceActiveSessionIdMeta =
      const VerificationMeta('sourceActiveSessionId');
  @override
  late final GeneratedColumn<String> sourceActiveSessionId =
      GeneratedColumn<String>(
        'source_active_session_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceTemplateIdMeta = const VerificationMeta(
    'sourceTemplateId',
  );
  @override
  late final GeneratedColumn<String> sourceTemplateId = GeneratedColumn<String>(
    'source_template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseCountMeta = const VerificationMeta(
    'exerciseCount',
  );
  @override
  late final GeneratedColumn<int> exerciseCount = GeneratedColumn<int>(
    'exercise_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workingSetCountMeta = const VerificationMeta(
    'workingSetCount',
  );
  @override
  late final GeneratedColumn<int> workingSetCount = GeneratedColumn<int>(
    'working_set_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCompletedSetsMeta =
      const VerificationMeta('totalCompletedSets');
  @override
  late final GeneratedColumn<int> totalCompletedSets = GeneratedColumn<int>(
    'total_completed_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRepetitionsMeta = const VerificationMeta(
    'totalRepetitions',
  );
  @override
  late final GeneratedColumn<int> totalRepetitions = GeneratedColumn<int>(
    'total_repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalVolumeKgMeta = const VerificationMeta(
    'totalVolumeKg',
  );
  @override
  late final GeneratedColumn<double> totalVolumeKg = GeneratedColumn<double>(
    'total_volume_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalRecordCountMeta =
      const VerificationMeta('personalRecordCount');
  @override
  late final GeneratedColumn<int> personalRecordCount = GeneratedColumn<int>(
    'personal_record_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sourceActiveSessionId,
    sourceTemplateId,
    name,
    notes,
    weightUnit,
    startedAt,
    endedAt,
    durationSeconds,
    exerciseCount,
    workingSetCount,
    totalCompletedSets,
    totalRepetitions,
    totalVolumeKg,
    personalRecordCount,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletedWorkoutSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_active_session_id')) {
      context.handle(
        _sourceActiveSessionIdMeta,
        sourceActiveSessionId.isAcceptableOrUnknown(
          data['source_active_session_id']!,
          _sourceActiveSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('source_template_id')) {
      context.handle(
        _sourceTemplateIdMeta,
        sourceTemplateId.isAcceptableOrUnknown(
          data['source_template_id']!,
          _sourceTemplateIdMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('exercise_count')) {
      context.handle(
        _exerciseCountMeta,
        exerciseCount.isAcceptableOrUnknown(
          data['exercise_count']!,
          _exerciseCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseCountMeta);
    }
    if (data.containsKey('working_set_count')) {
      context.handle(
        _workingSetCountMeta,
        workingSetCount.isAcceptableOrUnknown(
          data['working_set_count']!,
          _workingSetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workingSetCountMeta);
    }
    if (data.containsKey('total_completed_sets')) {
      context.handle(
        _totalCompletedSetsMeta,
        totalCompletedSets.isAcceptableOrUnknown(
          data['total_completed_sets']!,
          _totalCompletedSetsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCompletedSetsMeta);
    }
    if (data.containsKey('total_repetitions')) {
      context.handle(
        _totalRepetitionsMeta,
        totalRepetitions.isAcceptableOrUnknown(
          data['total_repetitions']!,
          _totalRepetitionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRepetitionsMeta);
    }
    if (data.containsKey('total_volume_kg')) {
      context.handle(
        _totalVolumeKgMeta,
        totalVolumeKg.isAcceptableOrUnknown(
          data['total_volume_kg']!,
          _totalVolumeKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalVolumeKgMeta);
    }
    if (data.containsKey('personal_record_count')) {
      context.handle(
        _personalRecordCountMeta,
        personalRecordCount.isAcceptableOrUnknown(
          data['personal_record_count']!,
          _personalRecordCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletedWorkoutSessionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedWorkoutSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceActiveSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_active_session_id'],
      ),
      sourceTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_template_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      exerciseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_count'],
      )!,
      workingSetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}working_set_count'],
      )!,
      totalCompletedSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_completed_sets'],
      )!,
      totalRepetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_repetitions'],
      )!,
      totalVolumeKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume_kg'],
      )!,
      personalRecordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personal_record_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CompletedWorkoutSessionsTable createAlias(String alias) {
    return $CompletedWorkoutSessionsTable(attachedDatabase, alias);
  }
}

class CompletedWorkoutSessionRow extends DataClass
    implements Insertable<CompletedWorkoutSessionRow> {
  final String id;
  final String userId;
  final String? sourceActiveSessionId;
  final String? sourceTemplateId;
  final String name;
  final String? notes;
  final String weightUnit;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  final int exerciseCount;
  final int workingSetCount;
  final int totalCompletedSets;
  final int totalRepetitions;
  final double totalVolumeKg;
  final int personalRecordCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const CompletedWorkoutSessionRow({
    required this.id,
    required this.userId,
    this.sourceActiveSessionId,
    this.sourceTemplateId,
    required this.name,
    this.notes,
    required this.weightUnit,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.exerciseCount,
    required this.workingSetCount,
    required this.totalCompletedSets,
    required this.totalRepetitions,
    required this.totalVolumeKg,
    required this.personalRecordCount,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || sourceActiveSessionId != null) {
      map['source_active_session_id'] = Variable<String>(sourceActiveSessionId);
    }
    if (!nullToAbsent || sourceTemplateId != null) {
      map['source_template_id'] = Variable<String>(sourceTemplateId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['weight_unit'] = Variable<String>(weightUnit);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['exercise_count'] = Variable<int>(exerciseCount);
    map['working_set_count'] = Variable<int>(workingSetCount);
    map['total_completed_sets'] = Variable<int>(totalCompletedSets);
    map['total_repetitions'] = Variable<int>(totalRepetitions);
    map['total_volume_kg'] = Variable<double>(totalVolumeKg);
    map['personal_record_count'] = Variable<int>(personalRecordCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  CompletedWorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return CompletedWorkoutSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      sourceActiveSessionId: sourceActiveSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceActiveSessionId),
      sourceTemplateId: sourceTemplateId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTemplateId),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      weightUnit: Value(weightUnit),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationSeconds: Value(durationSeconds),
      exerciseCount: Value(exerciseCount),
      workingSetCount: Value(workingSetCount),
      totalCompletedSets: Value(totalCompletedSets),
      totalRepetitions: Value(totalRepetitions),
      totalVolumeKg: Value(totalVolumeKg),
      personalRecordCount: Value(personalRecordCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory CompletedWorkoutSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedWorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceActiveSessionId: serializer.fromJson<String?>(
        json['sourceActiveSessionId'],
      ),
      sourceTemplateId: serializer.fromJson<String?>(json['sourceTemplateId']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      exerciseCount: serializer.fromJson<int>(json['exerciseCount']),
      workingSetCount: serializer.fromJson<int>(json['workingSetCount']),
      totalCompletedSets: serializer.fromJson<int>(json['totalCompletedSets']),
      totalRepetitions: serializer.fromJson<int>(json['totalRepetitions']),
      totalVolumeKg: serializer.fromJson<double>(json['totalVolumeKg']),
      personalRecordCount: serializer.fromJson<int>(
        json['personalRecordCount'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sourceActiveSessionId': serializer.toJson<String?>(
        sourceActiveSessionId,
      ),
      'sourceTemplateId': serializer.toJson<String?>(sourceTemplateId),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'weightUnit': serializer.toJson<String>(weightUnit),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'exerciseCount': serializer.toJson<int>(exerciseCount),
      'workingSetCount': serializer.toJson<int>(workingSetCount),
      'totalCompletedSets': serializer.toJson<int>(totalCompletedSets),
      'totalRepetitions': serializer.toJson<int>(totalRepetitions),
      'totalVolumeKg': serializer.toJson<double>(totalVolumeKg),
      'personalRecordCount': serializer.toJson<int>(personalRecordCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  CompletedWorkoutSessionRow copyWith({
    String? id,
    String? userId,
    Value<String?> sourceActiveSessionId = const Value.absent(),
    Value<String?> sourceTemplateId = const Value.absent(),
    String? name,
    Value<String?> notes = const Value.absent(),
    String? weightUnit,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationSeconds,
    int? exerciseCount,
    int? workingSetCount,
    int? totalCompletedSets,
    int? totalRepetitions,
    double? totalVolumeKg,
    int? personalRecordCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => CompletedWorkoutSessionRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sourceActiveSessionId: sourceActiveSessionId.present
        ? sourceActiveSessionId.value
        : this.sourceActiveSessionId,
    sourceTemplateId: sourceTemplateId.present
        ? sourceTemplateId.value
        : this.sourceTemplateId,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    weightUnit: weightUnit ?? this.weightUnit,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    exerciseCount: exerciseCount ?? this.exerciseCount,
    workingSetCount: workingSetCount ?? this.workingSetCount,
    totalCompletedSets: totalCompletedSets ?? this.totalCompletedSets,
    totalRepetitions: totalRepetitions ?? this.totalRepetitions,
    totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
    personalRecordCount: personalRecordCount ?? this.personalRecordCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  CompletedWorkoutSessionRow copyWithCompanion(
    CompletedWorkoutSessionsCompanion data,
  ) {
    return CompletedWorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceActiveSessionId: data.sourceActiveSessionId.present
          ? data.sourceActiveSessionId.value
          : this.sourceActiveSessionId,
      sourceTemplateId: data.sourceTemplateId.present
          ? data.sourceTemplateId.value
          : this.sourceTemplateId,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      exerciseCount: data.exerciseCount.present
          ? data.exerciseCount.value
          : this.exerciseCount,
      workingSetCount: data.workingSetCount.present
          ? data.workingSetCount.value
          : this.workingSetCount,
      totalCompletedSets: data.totalCompletedSets.present
          ? data.totalCompletedSets.value
          : this.totalCompletedSets,
      totalRepetitions: data.totalRepetitions.present
          ? data.totalRepetitions.value
          : this.totalRepetitions,
      totalVolumeKg: data.totalVolumeKg.present
          ? data.totalVolumeKg.value
          : this.totalVolumeKg,
      personalRecordCount: data.personalRecordCount.present
          ? data.personalRecordCount.value
          : this.personalRecordCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceActiveSessionId: $sourceActiveSessionId, ')
          ..write('sourceTemplateId: $sourceTemplateId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('workingSetCount: $workingSetCount, ')
          ..write('totalCompletedSets: $totalCompletedSets, ')
          ..write('totalRepetitions: $totalRepetitions, ')
          ..write('totalVolumeKg: $totalVolumeKg, ')
          ..write('personalRecordCount: $personalRecordCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    sourceActiveSessionId,
    sourceTemplateId,
    name,
    notes,
    weightUnit,
    startedAt,
    endedAt,
    durationSeconds,
    exerciseCount,
    workingSetCount,
    totalCompletedSets,
    totalRepetitions,
    totalVolumeKg,
    personalRecordCount,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedWorkoutSessionRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sourceActiveSessionId == this.sourceActiveSessionId &&
          other.sourceTemplateId == this.sourceTemplateId &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.weightUnit == this.weightUnit &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.exerciseCount == this.exerciseCount &&
          other.workingSetCount == this.workingSetCount &&
          other.totalCompletedSets == this.totalCompletedSets &&
          other.totalRepetitions == this.totalRepetitions &&
          other.totalVolumeKg == this.totalVolumeKg &&
          other.personalRecordCount == this.personalRecordCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class CompletedWorkoutSessionsCompanion
    extends UpdateCompanion<CompletedWorkoutSessionRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> sourceActiveSessionId;
  final Value<String?> sourceTemplateId;
  final Value<String> name;
  final Value<String?> notes;
  final Value<String> weightUnit;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationSeconds;
  final Value<int> exerciseCount;
  final Value<int> workingSetCount;
  final Value<int> totalCompletedSets;
  final Value<int> totalRepetitions;
  final Value<double> totalVolumeKg;
  final Value<int> personalRecordCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const CompletedWorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceActiveSessionId = const Value.absent(),
    this.sourceTemplateId = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.exerciseCount = const Value.absent(),
    this.workingSetCount = const Value.absent(),
    this.totalCompletedSets = const Value.absent(),
    this.totalRepetitions = const Value.absent(),
    this.totalVolumeKg = const Value.absent(),
    this.personalRecordCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletedWorkoutSessionsCompanion.insert({
    required String id,
    required String userId,
    this.sourceActiveSessionId = const Value.absent(),
    this.sourceTemplateId = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.weightUnit = const Value.absent(),
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required int exerciseCount,
    required int workingSetCount,
    required int totalCompletedSets,
    required int totalRepetitions,
    required double totalVolumeKg,
    this.personalRecordCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationSeconds = Value(durationSeconds),
       exerciseCount = Value(exerciseCount),
       workingSetCount = Value(workingSetCount),
       totalCompletedSets = Value(totalCompletedSets),
       totalRepetitions = Value(totalRepetitions),
       totalVolumeKg = Value(totalVolumeKg),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CompletedWorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sourceActiveSessionId,
    Expression<String>? sourceTemplateId,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<String>? weightUnit,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationSeconds,
    Expression<int>? exerciseCount,
    Expression<int>? workingSetCount,
    Expression<int>? totalCompletedSets,
    Expression<int>? totalRepetitions,
    Expression<double>? totalVolumeKg,
    Expression<int>? personalRecordCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sourceActiveSessionId != null)
        'source_active_session_id': sourceActiveSessionId,
      if (sourceTemplateId != null) 'source_template_id': sourceTemplateId,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (exerciseCount != null) 'exercise_count': exerciseCount,
      if (workingSetCount != null) 'working_set_count': workingSetCount,
      if (totalCompletedSets != null)
        'total_completed_sets': totalCompletedSets,
      if (totalRepetitions != null) 'total_repetitions': totalRepetitions,
      if (totalVolumeKg != null) 'total_volume_kg': totalVolumeKg,
      if (personalRecordCount != null)
        'personal_record_count': personalRecordCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletedWorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String?>? sourceActiveSessionId,
    Value<String?>? sourceTemplateId,
    Value<String>? name,
    Value<String?>? notes,
    Value<String>? weightUnit,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationSeconds,
    Value<int>? exerciseCount,
    Value<int>? workingSetCount,
    Value<int>? totalCompletedSets,
    Value<int>? totalRepetitions,
    Value<double>? totalVolumeKg,
    Value<int>? personalRecordCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CompletedWorkoutSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sourceActiveSessionId:
          sourceActiveSessionId ?? this.sourceActiveSessionId,
      sourceTemplateId: sourceTemplateId ?? this.sourceTemplateId,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      weightUnit: weightUnit ?? this.weightUnit,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      exerciseCount: exerciseCount ?? this.exerciseCount,
      workingSetCount: workingSetCount ?? this.workingSetCount,
      totalCompletedSets: totalCompletedSets ?? this.totalCompletedSets,
      totalRepetitions: totalRepetitions ?? this.totalRepetitions,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      personalRecordCount: personalRecordCount ?? this.personalRecordCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceActiveSessionId.present) {
      map['source_active_session_id'] = Variable<String>(
        sourceActiveSessionId.value,
      );
    }
    if (sourceTemplateId.present) {
      map['source_template_id'] = Variable<String>(sourceTemplateId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (exerciseCount.present) {
      map['exercise_count'] = Variable<int>(exerciseCount.value);
    }
    if (workingSetCount.present) {
      map['working_set_count'] = Variable<int>(workingSetCount.value);
    }
    if (totalCompletedSets.present) {
      map['total_completed_sets'] = Variable<int>(totalCompletedSets.value);
    }
    if (totalRepetitions.present) {
      map['total_repetitions'] = Variable<int>(totalRepetitions.value);
    }
    if (totalVolumeKg.present) {
      map['total_volume_kg'] = Variable<double>(totalVolumeKg.value);
    }
    if (personalRecordCount.present) {
      map['personal_record_count'] = Variable<int>(personalRecordCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sourceActiveSessionId: $sourceActiveSessionId, ')
          ..write('sourceTemplateId: $sourceTemplateId, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('exerciseCount: $exerciseCount, ')
          ..write('workingSetCount: $workingSetCount, ')
          ..write('totalCompletedSets: $totalCompletedSets, ')
          ..write('totalRepetitions: $totalRepetitions, ')
          ..write('totalVolumeKg: $totalVolumeKg, ')
          ..write('personalRecordCount: $personalRecordCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletedWorkoutExercisesTable extends CompletedWorkoutExercises
    with
        TableInfo<
          $CompletedWorkoutExercisesTable,
          CompletedWorkoutExerciseRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedWorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES completed_workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceActiveExerciseIdMeta =
      const VerificationMeta('sourceActiveExerciseId');
  @override
  late final GeneratedColumn<String> sourceActiveExerciseId =
      GeneratedColumn<String>(
        'source_active_exercise_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exerciseSourceMeta = const VerificationMeta(
    'exerciseSource',
  );
  @override
  late final GeneratedColumn<String> exerciseSource = GeneratedColumn<String>(
    'exercise_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseKeyMeta = const VerificationMeta(
    'exerciseKey',
  );
  @override
  late final GeneratedColumn<String> exerciseKey = GeneratedColumn<String>(
    'exercise_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemExerciseKeyMeta = const VerificationMeta(
    'systemExerciseKey',
  );
  @override
  late final GeneratedColumn<String> systemExerciseKey =
      GeneratedColumn<String>(
        'system_exercise_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customExerciseIdMeta = const VerificationMeta(
    'customExerciseId',
  );
  @override
  late final GeneratedColumn<String> customExerciseId = GeneratedColumn<String>(
    'custom_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primaryMuscleGroupMeta =
      const VerificationMeta('primaryMuscleGroup');
  @override
  late final GeneratedColumn<String> primaryMuscleGroup =
      GeneratedColumn<String>(
        'primary_muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _secondaryMuscleGroupsJsonMeta =
      const VerificationMeta('secondaryMuscleGroupsJson');
  @override
  late final GeneratedColumn<String> secondaryMuscleGroupsJson =
      GeneratedColumn<String>(
        'secondary_muscle_groups_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackingTypeMeta = const VerificationMeta(
    'trackingType',
  );
  @override
  late final GeneratedColumn<String> trackingType = GeneratedColumn<String>(
    'tracking_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightRelevantMeta = const VerificationMeta(
    'weightRelevant',
  );
  @override
  late final GeneratedColumn<bool> weightRelevant = GeneratedColumn<bool>(
    'weight_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weight_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _repetitionsRelevantMeta =
      const VerificationMeta('repetitionsRelevant');
  @override
  late final GeneratedColumn<bool> repetitionsRelevant = GeneratedColumn<bool>(
    'repetitions_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("repetitions_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _distanceRelevantMeta = const VerificationMeta(
    'distanceRelevant',
  );
  @override
  late final GeneratedColumn<bool> distanceRelevant = GeneratedColumn<bool>(
    'distance_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("distance_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationRelevantMeta = const VerificationMeta(
    'durationRelevant',
  );
  @override
  late final GeneratedColumn<bool> durationRelevant = GeneratedColumn<bool>(
    'duration_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("duration_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _bodyweightRelevantMeta =
      const VerificationMeta('bodyweightRelevant');
  @override
  late final GeneratedColumn<bool> bodyweightRelevant = GeneratedColumn<bool>(
    'bodyweight_relevant',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bodyweight_relevant" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedSetCountMeta = const VerificationMeta(
    'completedSetCount',
  );
  @override
  late final GeneratedColumn<int> completedSetCount = GeneratedColumn<int>(
    'completed_set_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workingSetCountMeta = const VerificationMeta(
    'workingSetCount',
  );
  @override
  late final GeneratedColumn<int> workingSetCount = GeneratedColumn<int>(
    'working_set_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalRepetitionsMeta = const VerificationMeta(
    'totalRepetitions',
  );
  @override
  late final GeneratedColumn<int> totalRepetitions = GeneratedColumn<int>(
    'total_repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalVolumeKgMeta = const VerificationMeta(
    'totalVolumeKg',
  );
  @override
  late final GeneratedColumn<double> totalVolumeKg = GeneratedColumn<double>(
    'total_volume_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestWeightKgMeta = const VerificationMeta(
    'bestWeightKg',
  );
  @override
  late final GeneratedColumn<double> bestWeightKg = GeneratedColumn<double>(
    'best_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bestEstimatedOneRepMaxKgMeta =
      const VerificationMeta('bestEstimatedOneRepMaxKg');
  @override
  late final GeneratedColumn<double> bestEstimatedOneRepMaxKg =
      GeneratedColumn<double>(
        'best_estimated_one_rep_max_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sessionId,
    sourceActiveExerciseId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    trackingType,
    weightRelevant,
    repetitionsRelevant,
    distanceRelevant,
    durationRelevant,
    bodyweightRelevant,
    notes,
    sortOrder,
    completedSetCount,
    workingSetCount,
    totalRepetitions,
    totalVolumeKg,
    bestWeightKg,
    bestEstimatedOneRepMaxKg,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletedWorkoutExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('source_active_exercise_id')) {
      context.handle(
        _sourceActiveExerciseIdMeta,
        sourceActiveExerciseId.isAcceptableOrUnknown(
          data['source_active_exercise_id']!,
          _sourceActiveExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_source')) {
      context.handle(
        _exerciseSourceMeta,
        exerciseSource.isAcceptableOrUnknown(
          data['exercise_source']!,
          _exerciseSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseSourceMeta);
    }
    if (data.containsKey('exercise_key')) {
      context.handle(
        _exerciseKeyMeta,
        exerciseKey.isAcceptableOrUnknown(
          data['exercise_key']!,
          _exerciseKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseKeyMeta);
    }
    if (data.containsKey('system_exercise_key')) {
      context.handle(
        _systemExerciseKeyMeta,
        systemExerciseKey.isAcceptableOrUnknown(
          data['system_exercise_key']!,
          _systemExerciseKeyMeta,
        ),
      );
    }
    if (data.containsKey('custom_exercise_id')) {
      context.handle(
        _customExerciseIdMeta,
        customExerciseId.isAcceptableOrUnknown(
          data['custom_exercise_id']!,
          _customExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('primary_muscle_group')) {
      context.handle(
        _primaryMuscleGroupMeta,
        primaryMuscleGroup.isAcceptableOrUnknown(
          data['primary_muscle_group']!,
          _primaryMuscleGroupMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryMuscleGroupMeta);
    }
    if (data.containsKey('secondary_muscle_groups_json')) {
      context.handle(
        _secondaryMuscleGroupsJsonMeta,
        secondaryMuscleGroupsJson.isAcceptableOrUnknown(
          data['secondary_muscle_groups_json']!,
          _secondaryMuscleGroupsJsonMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    } else if (isInserting) {
      context.missing(_equipmentMeta);
    }
    if (data.containsKey('tracking_type')) {
      context.handle(
        _trackingTypeMeta,
        trackingType.isAcceptableOrUnknown(
          data['tracking_type']!,
          _trackingTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackingTypeMeta);
    }
    if (data.containsKey('weight_relevant')) {
      context.handle(
        _weightRelevantMeta,
        weightRelevant.isAcceptableOrUnknown(
          data['weight_relevant']!,
          _weightRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightRelevantMeta);
    }
    if (data.containsKey('repetitions_relevant')) {
      context.handle(
        _repetitionsRelevantMeta,
        repetitionsRelevant.isAcceptableOrUnknown(
          data['repetitions_relevant']!,
          _repetitionsRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repetitionsRelevantMeta);
    }
    if (data.containsKey('distance_relevant')) {
      context.handle(
        _distanceRelevantMeta,
        distanceRelevant.isAcceptableOrUnknown(
          data['distance_relevant']!,
          _distanceRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceRelevantMeta);
    }
    if (data.containsKey('duration_relevant')) {
      context.handle(
        _durationRelevantMeta,
        durationRelevant.isAcceptableOrUnknown(
          data['duration_relevant']!,
          _durationRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationRelevantMeta);
    }
    if (data.containsKey('bodyweight_relevant')) {
      context.handle(
        _bodyweightRelevantMeta,
        bodyweightRelevant.isAcceptableOrUnknown(
          data['bodyweight_relevant']!,
          _bodyweightRelevantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyweightRelevantMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('completed_set_count')) {
      context.handle(
        _completedSetCountMeta,
        completedSetCount.isAcceptableOrUnknown(
          data['completed_set_count']!,
          _completedSetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedSetCountMeta);
    }
    if (data.containsKey('working_set_count')) {
      context.handle(
        _workingSetCountMeta,
        workingSetCount.isAcceptableOrUnknown(
          data['working_set_count']!,
          _workingSetCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workingSetCountMeta);
    }
    if (data.containsKey('total_repetitions')) {
      context.handle(
        _totalRepetitionsMeta,
        totalRepetitions.isAcceptableOrUnknown(
          data['total_repetitions']!,
          _totalRepetitionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalRepetitionsMeta);
    }
    if (data.containsKey('total_volume_kg')) {
      context.handle(
        _totalVolumeKgMeta,
        totalVolumeKg.isAcceptableOrUnknown(
          data['total_volume_kg']!,
          _totalVolumeKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalVolumeKgMeta);
    }
    if (data.containsKey('best_weight_kg')) {
      context.handle(
        _bestWeightKgMeta,
        bestWeightKg.isAcceptableOrUnknown(
          data['best_weight_kg']!,
          _bestWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('best_estimated_one_rep_max_kg')) {
      context.handle(
        _bestEstimatedOneRepMaxKgMeta,
        bestEstimatedOneRepMaxKg.isAcceptableOrUnknown(
          data['best_estimated_one_rep_max_kg']!,
          _bestEstimatedOneRepMaxKgMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletedWorkoutExerciseRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedWorkoutExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sourceActiveExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_active_exercise_id'],
      ),
      exerciseSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_source'],
      )!,
      exerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_key'],
      )!,
      systemExerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_exercise_key'],
      ),
      customExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_exercise_id'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      primaryMuscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscle_group'],
      )!,
      secondaryMuscleGroupsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_muscle_groups_json'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      trackingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_type'],
      )!,
      weightRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weight_relevant'],
      )!,
      repetitionsRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}repetitions_relevant'],
      )!,
      distanceRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}distance_relevant'],
      )!,
      durationRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}duration_relevant'],
      )!,
      bodyweightRelevant: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bodyweight_relevant'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      completedSetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_set_count'],
      )!,
      workingSetCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}working_set_count'],
      )!,
      totalRepetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_repetitions'],
      )!,
      totalVolumeKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_volume_kg'],
      )!,
      bestWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}best_weight_kg'],
      ),
      bestEstimatedOneRepMaxKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}best_estimated_one_rep_max_kg'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CompletedWorkoutExercisesTable createAlias(String alias) {
    return $CompletedWorkoutExercisesTable(attachedDatabase, alias);
  }
}

class CompletedWorkoutExerciseRow extends DataClass
    implements Insertable<CompletedWorkoutExerciseRow> {
  final String id;
  final String userId;
  final String sessionId;
  final String? sourceActiveExerciseId;
  final String exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final String primaryMuscleGroup;
  final String secondaryMuscleGroupsJson;
  final String equipment;
  final String trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;
  final String? notes;
  final int sortOrder;
  final int completedSetCount;
  final int workingSetCount;
  final int totalRepetitions;
  final double totalVolumeKg;
  final double? bestWeightKg;
  final double? bestEstimatedOneRepMaxKg;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const CompletedWorkoutExerciseRow({
    required this.id,
    required this.userId,
    required this.sessionId,
    this.sourceActiveExerciseId,
    required this.exerciseSource,
    required this.exerciseKey,
    this.systemExerciseKey,
    this.customExerciseId,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    required this.secondaryMuscleGroupsJson,
    required this.equipment,
    required this.trackingType,
    required this.weightRelevant,
    required this.repetitionsRelevant,
    required this.distanceRelevant,
    required this.durationRelevant,
    required this.bodyweightRelevant,
    this.notes,
    required this.sortOrder,
    required this.completedSetCount,
    required this.workingSetCount,
    required this.totalRepetitions,
    required this.totalVolumeKg,
    this.bestWeightKg,
    this.bestEstimatedOneRepMaxKg,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || sourceActiveExerciseId != null) {
      map['source_active_exercise_id'] = Variable<String>(
        sourceActiveExerciseId,
      );
    }
    map['exercise_source'] = Variable<String>(exerciseSource);
    map['exercise_key'] = Variable<String>(exerciseKey);
    if (!nullToAbsent || systemExerciseKey != null) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey);
    }
    if (!nullToAbsent || customExerciseId != null) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId);
    }
    map['exercise_name'] = Variable<String>(exerciseName);
    map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup);
    map['secondary_muscle_groups_json'] = Variable<String>(
      secondaryMuscleGroupsJson,
    );
    map['equipment'] = Variable<String>(equipment);
    map['tracking_type'] = Variable<String>(trackingType);
    map['weight_relevant'] = Variable<bool>(weightRelevant);
    map['repetitions_relevant'] = Variable<bool>(repetitionsRelevant);
    map['distance_relevant'] = Variable<bool>(distanceRelevant);
    map['duration_relevant'] = Variable<bool>(durationRelevant);
    map['bodyweight_relevant'] = Variable<bool>(bodyweightRelevant);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['completed_set_count'] = Variable<int>(completedSetCount);
    map['working_set_count'] = Variable<int>(workingSetCount);
    map['total_repetitions'] = Variable<int>(totalRepetitions);
    map['total_volume_kg'] = Variable<double>(totalVolumeKg);
    if (!nullToAbsent || bestWeightKg != null) {
      map['best_weight_kg'] = Variable<double>(bestWeightKg);
    }
    if (!nullToAbsent || bestEstimatedOneRepMaxKg != null) {
      map['best_estimated_one_rep_max_kg'] = Variable<double>(
        bestEstimatedOneRepMaxKg,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  CompletedWorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return CompletedWorkoutExercisesCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      sourceActiveExerciseId: sourceActiveExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceActiveExerciseId),
      exerciseSource: Value(exerciseSource),
      exerciseKey: Value(exerciseKey),
      systemExerciseKey: systemExerciseKey == null && nullToAbsent
          ? const Value.absent()
          : Value(systemExerciseKey),
      customExerciseId: customExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(customExerciseId),
      exerciseName: Value(exerciseName),
      primaryMuscleGroup: Value(primaryMuscleGroup),
      secondaryMuscleGroupsJson: Value(secondaryMuscleGroupsJson),
      equipment: Value(equipment),
      trackingType: Value(trackingType),
      weightRelevant: Value(weightRelevant),
      repetitionsRelevant: Value(repetitionsRelevant),
      distanceRelevant: Value(distanceRelevant),
      durationRelevant: Value(durationRelevant),
      bodyweightRelevant: Value(bodyweightRelevant),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      completedSetCount: Value(completedSetCount),
      workingSetCount: Value(workingSetCount),
      totalRepetitions: Value(totalRepetitions),
      totalVolumeKg: Value(totalVolumeKg),
      bestWeightKg: bestWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(bestWeightKg),
      bestEstimatedOneRepMaxKg: bestEstimatedOneRepMaxKg == null && nullToAbsent
          ? const Value.absent()
          : Value(bestEstimatedOneRepMaxKg),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory CompletedWorkoutExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedWorkoutExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sourceActiveExerciseId: serializer.fromJson<String?>(
        json['sourceActiveExerciseId'],
      ),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseKey: serializer.fromJson<String>(json['exerciseKey']),
      systemExerciseKey: serializer.fromJson<String?>(
        json['systemExerciseKey'],
      ),
      customExerciseId: serializer.fromJson<String?>(json['customExerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      primaryMuscleGroup: serializer.fromJson<String>(
        json['primaryMuscleGroup'],
      ),
      secondaryMuscleGroupsJson: serializer.fromJson<String>(
        json['secondaryMuscleGroupsJson'],
      ),
      equipment: serializer.fromJson<String>(json['equipment']),
      trackingType: serializer.fromJson<String>(json['trackingType']),
      weightRelevant: serializer.fromJson<bool>(json['weightRelevant']),
      repetitionsRelevant: serializer.fromJson<bool>(
        json['repetitionsRelevant'],
      ),
      distanceRelevant: serializer.fromJson<bool>(json['distanceRelevant']),
      durationRelevant: serializer.fromJson<bool>(json['durationRelevant']),
      bodyweightRelevant: serializer.fromJson<bool>(json['bodyweightRelevant']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      completedSetCount: serializer.fromJson<int>(json['completedSetCount']),
      workingSetCount: serializer.fromJson<int>(json['workingSetCount']),
      totalRepetitions: serializer.fromJson<int>(json['totalRepetitions']),
      totalVolumeKg: serializer.fromJson<double>(json['totalVolumeKg']),
      bestWeightKg: serializer.fromJson<double?>(json['bestWeightKg']),
      bestEstimatedOneRepMaxKg: serializer.fromJson<double?>(
        json['bestEstimatedOneRepMaxKg'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'sourceActiveExerciseId': serializer.toJson<String?>(
        sourceActiveExerciseId,
      ),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseKey': serializer.toJson<String>(exerciseKey),
      'systemExerciseKey': serializer.toJson<String?>(systemExerciseKey),
      'customExerciseId': serializer.toJson<String?>(customExerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'primaryMuscleGroup': serializer.toJson<String>(primaryMuscleGroup),
      'secondaryMuscleGroupsJson': serializer.toJson<String>(
        secondaryMuscleGroupsJson,
      ),
      'equipment': serializer.toJson<String>(equipment),
      'trackingType': serializer.toJson<String>(trackingType),
      'weightRelevant': serializer.toJson<bool>(weightRelevant),
      'repetitionsRelevant': serializer.toJson<bool>(repetitionsRelevant),
      'distanceRelevant': serializer.toJson<bool>(distanceRelevant),
      'durationRelevant': serializer.toJson<bool>(durationRelevant),
      'bodyweightRelevant': serializer.toJson<bool>(bodyweightRelevant),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'completedSetCount': serializer.toJson<int>(completedSetCount),
      'workingSetCount': serializer.toJson<int>(workingSetCount),
      'totalRepetitions': serializer.toJson<int>(totalRepetitions),
      'totalVolumeKg': serializer.toJson<double>(totalVolumeKg),
      'bestWeightKg': serializer.toJson<double?>(bestWeightKg),
      'bestEstimatedOneRepMaxKg': serializer.toJson<double?>(
        bestEstimatedOneRepMaxKg,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  CompletedWorkoutExerciseRow copyWith({
    String? id,
    String? userId,
    String? sessionId,
    Value<String?> sourceActiveExerciseId = const Value.absent(),
    String? exerciseSource,
    String? exerciseKey,
    Value<String?> systemExerciseKey = const Value.absent(),
    Value<String?> customExerciseId = const Value.absent(),
    String? exerciseName,
    String? primaryMuscleGroup,
    String? secondaryMuscleGroupsJson,
    String? equipment,
    String? trackingType,
    bool? weightRelevant,
    bool? repetitionsRelevant,
    bool? distanceRelevant,
    bool? durationRelevant,
    bool? bodyweightRelevant,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    int? completedSetCount,
    int? workingSetCount,
    int? totalRepetitions,
    double? totalVolumeKg,
    Value<double?> bestWeightKg = const Value.absent(),
    Value<double?> bestEstimatedOneRepMaxKg = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => CompletedWorkoutExerciseRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sessionId: sessionId ?? this.sessionId,
    sourceActiveExerciseId: sourceActiveExerciseId.present
        ? sourceActiveExerciseId.value
        : this.sourceActiveExerciseId,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseKey: exerciseKey ?? this.exerciseKey,
    systemExerciseKey: systemExerciseKey.present
        ? systemExerciseKey.value
        : this.systemExerciseKey,
    customExerciseId: customExerciseId.present
        ? customExerciseId.value
        : this.customExerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
    secondaryMuscleGroupsJson:
        secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
    equipment: equipment ?? this.equipment,
    trackingType: trackingType ?? this.trackingType,
    weightRelevant: weightRelevant ?? this.weightRelevant,
    repetitionsRelevant: repetitionsRelevant ?? this.repetitionsRelevant,
    distanceRelevant: distanceRelevant ?? this.distanceRelevant,
    durationRelevant: durationRelevant ?? this.durationRelevant,
    bodyweightRelevant: bodyweightRelevant ?? this.bodyweightRelevant,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    completedSetCount: completedSetCount ?? this.completedSetCount,
    workingSetCount: workingSetCount ?? this.workingSetCount,
    totalRepetitions: totalRepetitions ?? this.totalRepetitions,
    totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
    bestWeightKg: bestWeightKg.present ? bestWeightKg.value : this.bestWeightKg,
    bestEstimatedOneRepMaxKg: bestEstimatedOneRepMaxKg.present
        ? bestEstimatedOneRepMaxKg.value
        : this.bestEstimatedOneRepMaxKg,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  CompletedWorkoutExerciseRow copyWithCompanion(
    CompletedWorkoutExercisesCompanion data,
  ) {
    return CompletedWorkoutExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sourceActiveExerciseId: data.sourceActiveExerciseId.present
          ? data.sourceActiveExerciseId.value
          : this.sourceActiveExerciseId,
      exerciseSource: data.exerciseSource.present
          ? data.exerciseSource.value
          : this.exerciseSource,
      exerciseKey: data.exerciseKey.present
          ? data.exerciseKey.value
          : this.exerciseKey,
      systemExerciseKey: data.systemExerciseKey.present
          ? data.systemExerciseKey.value
          : this.systemExerciseKey,
      customExerciseId: data.customExerciseId.present
          ? data.customExerciseId.value
          : this.customExerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      primaryMuscleGroup: data.primaryMuscleGroup.present
          ? data.primaryMuscleGroup.value
          : this.primaryMuscleGroup,
      secondaryMuscleGroupsJson: data.secondaryMuscleGroupsJson.present
          ? data.secondaryMuscleGroupsJson.value
          : this.secondaryMuscleGroupsJson,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      trackingType: data.trackingType.present
          ? data.trackingType.value
          : this.trackingType,
      weightRelevant: data.weightRelevant.present
          ? data.weightRelevant.value
          : this.weightRelevant,
      repetitionsRelevant: data.repetitionsRelevant.present
          ? data.repetitionsRelevant.value
          : this.repetitionsRelevant,
      distanceRelevant: data.distanceRelevant.present
          ? data.distanceRelevant.value
          : this.distanceRelevant,
      durationRelevant: data.durationRelevant.present
          ? data.durationRelevant.value
          : this.durationRelevant,
      bodyweightRelevant: data.bodyweightRelevant.present
          ? data.bodyweightRelevant.value
          : this.bodyweightRelevant,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      completedSetCount: data.completedSetCount.present
          ? data.completedSetCount.value
          : this.completedSetCount,
      workingSetCount: data.workingSetCount.present
          ? data.workingSetCount.value
          : this.workingSetCount,
      totalRepetitions: data.totalRepetitions.present
          ? data.totalRepetitions.value
          : this.totalRepetitions,
      totalVolumeKg: data.totalVolumeKg.present
          ? data.totalVolumeKg.value
          : this.totalVolumeKg,
      bestWeightKg: data.bestWeightKg.present
          ? data.bestWeightKg.value
          : this.bestWeightKg,
      bestEstimatedOneRepMaxKg: data.bestEstimatedOneRepMaxKg.present
          ? data.bestEstimatedOneRepMaxKg.value
          : this.bestEstimatedOneRepMaxKg,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutExerciseRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sourceActiveExerciseId: $sourceActiveExerciseId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('trackingType: $trackingType, ')
          ..write('weightRelevant: $weightRelevant, ')
          ..write('repetitionsRelevant: $repetitionsRelevant, ')
          ..write('distanceRelevant: $distanceRelevant, ')
          ..write('durationRelevant: $durationRelevant, ')
          ..write('bodyweightRelevant: $bodyweightRelevant, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedSetCount: $completedSetCount, ')
          ..write('workingSetCount: $workingSetCount, ')
          ..write('totalRepetitions: $totalRepetitions, ')
          ..write('totalVolumeKg: $totalVolumeKg, ')
          ..write('bestWeightKg: $bestWeightKg, ')
          ..write('bestEstimatedOneRepMaxKg: $bestEstimatedOneRepMaxKg, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    sessionId,
    sourceActiveExerciseId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    primaryMuscleGroup,
    secondaryMuscleGroupsJson,
    equipment,
    trackingType,
    weightRelevant,
    repetitionsRelevant,
    distanceRelevant,
    durationRelevant,
    bodyweightRelevant,
    notes,
    sortOrder,
    completedSetCount,
    workingSetCount,
    totalRepetitions,
    totalVolumeKg,
    bestWeightKg,
    bestEstimatedOneRepMaxKg,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedWorkoutExerciseRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.sourceActiveExerciseId == this.sourceActiveExerciseId &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseKey == this.exerciseKey &&
          other.systemExerciseKey == this.systemExerciseKey &&
          other.customExerciseId == this.customExerciseId &&
          other.exerciseName == this.exerciseName &&
          other.primaryMuscleGroup == this.primaryMuscleGroup &&
          other.secondaryMuscleGroupsJson == this.secondaryMuscleGroupsJson &&
          other.equipment == this.equipment &&
          other.trackingType == this.trackingType &&
          other.weightRelevant == this.weightRelevant &&
          other.repetitionsRelevant == this.repetitionsRelevant &&
          other.distanceRelevant == this.distanceRelevant &&
          other.durationRelevant == this.durationRelevant &&
          other.bodyweightRelevant == this.bodyweightRelevant &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.completedSetCount == this.completedSetCount &&
          other.workingSetCount == this.workingSetCount &&
          other.totalRepetitions == this.totalRepetitions &&
          other.totalVolumeKg == this.totalVolumeKg &&
          other.bestWeightKg == this.bestWeightKg &&
          other.bestEstimatedOneRepMaxKg == this.bestEstimatedOneRepMaxKg &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class CompletedWorkoutExercisesCompanion
    extends UpdateCompanion<CompletedWorkoutExerciseRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<String?> sourceActiveExerciseId;
  final Value<String> exerciseSource;
  final Value<String> exerciseKey;
  final Value<String?> systemExerciseKey;
  final Value<String?> customExerciseId;
  final Value<String> exerciseName;
  final Value<String> primaryMuscleGroup;
  final Value<String> secondaryMuscleGroupsJson;
  final Value<String> equipment;
  final Value<String> trackingType;
  final Value<bool> weightRelevant;
  final Value<bool> repetitionsRelevant;
  final Value<bool> distanceRelevant;
  final Value<bool> durationRelevant;
  final Value<bool> bodyweightRelevant;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> completedSetCount;
  final Value<int> workingSetCount;
  final Value<int> totalRepetitions;
  final Value<double> totalVolumeKg;
  final Value<double?> bestWeightKg;
  final Value<double?> bestEstimatedOneRepMaxKg;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const CompletedWorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sourceActiveExerciseId = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseKey = const Value.absent(),
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.primaryMuscleGroup = const Value.absent(),
    this.secondaryMuscleGroupsJson = const Value.absent(),
    this.equipment = const Value.absent(),
    this.trackingType = const Value.absent(),
    this.weightRelevant = const Value.absent(),
    this.repetitionsRelevant = const Value.absent(),
    this.distanceRelevant = const Value.absent(),
    this.durationRelevant = const Value.absent(),
    this.bodyweightRelevant = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.completedSetCount = const Value.absent(),
    this.workingSetCount = const Value.absent(),
    this.totalRepetitions = const Value.absent(),
    this.totalVolumeKg = const Value.absent(),
    this.bestWeightKg = const Value.absent(),
    this.bestEstimatedOneRepMaxKg = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletedWorkoutExercisesCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    this.sourceActiveExerciseId = const Value.absent(),
    required String exerciseSource,
    required String exerciseKey,
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    required String exerciseName,
    required String primaryMuscleGroup,
    this.secondaryMuscleGroupsJson = const Value.absent(),
    required String equipment,
    required String trackingType,
    required bool weightRelevant,
    required bool repetitionsRelevant,
    required bool distanceRelevant,
    required bool durationRelevant,
    required bool bodyweightRelevant,
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required int completedSetCount,
    required int workingSetCount,
    required int totalRepetitions,
    required double totalVolumeKg,
    this.bestWeightKg = const Value.absent(),
    this.bestEstimatedOneRepMaxKg = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sessionId = Value(sessionId),
       exerciseSource = Value(exerciseSource),
       exerciseKey = Value(exerciseKey),
       exerciseName = Value(exerciseName),
       primaryMuscleGroup = Value(primaryMuscleGroup),
       equipment = Value(equipment),
       trackingType = Value(trackingType),
       weightRelevant = Value(weightRelevant),
       repetitionsRelevant = Value(repetitionsRelevant),
       distanceRelevant = Value(distanceRelevant),
       durationRelevant = Value(durationRelevant),
       bodyweightRelevant = Value(bodyweightRelevant),
       completedSetCount = Value(completedSetCount),
       workingSetCount = Value(workingSetCount),
       totalRepetitions = Value(totalRepetitions),
       totalVolumeKg = Value(totalVolumeKg),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CompletedWorkoutExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? sourceActiveExerciseId,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseKey,
    Expression<String>? systemExerciseKey,
    Expression<String>? customExerciseId,
    Expression<String>? exerciseName,
    Expression<String>? primaryMuscleGroup,
    Expression<String>? secondaryMuscleGroupsJson,
    Expression<String>? equipment,
    Expression<String>? trackingType,
    Expression<bool>? weightRelevant,
    Expression<bool>? repetitionsRelevant,
    Expression<bool>? distanceRelevant,
    Expression<bool>? durationRelevant,
    Expression<bool>? bodyweightRelevant,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? completedSetCount,
    Expression<int>? workingSetCount,
    Expression<int>? totalRepetitions,
    Expression<double>? totalVolumeKg,
    Expression<double>? bestWeightKg,
    Expression<double>? bestEstimatedOneRepMaxKg,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (sourceActiveExerciseId != null)
        'source_active_exercise_id': sourceActiveExerciseId,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseKey != null) 'exercise_key': exerciseKey,
      if (systemExerciseKey != null) 'system_exercise_key': systemExerciseKey,
      if (customExerciseId != null) 'custom_exercise_id': customExerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (primaryMuscleGroup != null)
        'primary_muscle_group': primaryMuscleGroup,
      if (secondaryMuscleGroupsJson != null)
        'secondary_muscle_groups_json': secondaryMuscleGroupsJson,
      if (equipment != null) 'equipment': equipment,
      if (trackingType != null) 'tracking_type': trackingType,
      if (weightRelevant != null) 'weight_relevant': weightRelevant,
      if (repetitionsRelevant != null)
        'repetitions_relevant': repetitionsRelevant,
      if (distanceRelevant != null) 'distance_relevant': distanceRelevant,
      if (durationRelevant != null) 'duration_relevant': durationRelevant,
      if (bodyweightRelevant != null) 'bodyweight_relevant': bodyweightRelevant,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (completedSetCount != null) 'completed_set_count': completedSetCount,
      if (workingSetCount != null) 'working_set_count': workingSetCount,
      if (totalRepetitions != null) 'total_repetitions': totalRepetitions,
      if (totalVolumeKg != null) 'total_volume_kg': totalVolumeKg,
      if (bestWeightKg != null) 'best_weight_kg': bestWeightKg,
      if (bestEstimatedOneRepMaxKg != null)
        'best_estimated_one_rep_max_kg': bestEstimatedOneRepMaxKg,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletedWorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sessionId,
    Value<String?>? sourceActiveExerciseId,
    Value<String>? exerciseSource,
    Value<String>? exerciseKey,
    Value<String?>? systemExerciseKey,
    Value<String?>? customExerciseId,
    Value<String>? exerciseName,
    Value<String>? primaryMuscleGroup,
    Value<String>? secondaryMuscleGroupsJson,
    Value<String>? equipment,
    Value<String>? trackingType,
    Value<bool>? weightRelevant,
    Value<bool>? repetitionsRelevant,
    Value<bool>? distanceRelevant,
    Value<bool>? durationRelevant,
    Value<bool>? bodyweightRelevant,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? completedSetCount,
    Value<int>? workingSetCount,
    Value<int>? totalRepetitions,
    Value<double>? totalVolumeKg,
    Value<double?>? bestWeightKg,
    Value<double?>? bestEstimatedOneRepMaxKg,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CompletedWorkoutExercisesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      sourceActiveExerciseId:
          sourceActiveExerciseId ?? this.sourceActiveExerciseId,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseKey: exerciseKey ?? this.exerciseKey,
      systemExerciseKey: systemExerciseKey ?? this.systemExerciseKey,
      customExerciseId: customExerciseId ?? this.customExerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      primaryMuscleGroup: primaryMuscleGroup ?? this.primaryMuscleGroup,
      secondaryMuscleGroupsJson:
          secondaryMuscleGroupsJson ?? this.secondaryMuscleGroupsJson,
      equipment: equipment ?? this.equipment,
      trackingType: trackingType ?? this.trackingType,
      weightRelevant: weightRelevant ?? this.weightRelevant,
      repetitionsRelevant: repetitionsRelevant ?? this.repetitionsRelevant,
      distanceRelevant: distanceRelevant ?? this.distanceRelevant,
      durationRelevant: durationRelevant ?? this.durationRelevant,
      bodyweightRelevant: bodyweightRelevant ?? this.bodyweightRelevant,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      completedSetCount: completedSetCount ?? this.completedSetCount,
      workingSetCount: workingSetCount ?? this.workingSetCount,
      totalRepetitions: totalRepetitions ?? this.totalRepetitions,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      bestWeightKg: bestWeightKg ?? this.bestWeightKg,
      bestEstimatedOneRepMaxKg:
          bestEstimatedOneRepMaxKg ?? this.bestEstimatedOneRepMaxKg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sourceActiveExerciseId.present) {
      map['source_active_exercise_id'] = Variable<String>(
        sourceActiveExerciseId.value,
      );
    }
    if (exerciseSource.present) {
      map['exercise_source'] = Variable<String>(exerciseSource.value);
    }
    if (exerciseKey.present) {
      map['exercise_key'] = Variable<String>(exerciseKey.value);
    }
    if (systemExerciseKey.present) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey.value);
    }
    if (customExerciseId.present) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (primaryMuscleGroup.present) {
      map['primary_muscle_group'] = Variable<String>(primaryMuscleGroup.value);
    }
    if (secondaryMuscleGroupsJson.present) {
      map['secondary_muscle_groups_json'] = Variable<String>(
        secondaryMuscleGroupsJson.value,
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (trackingType.present) {
      map['tracking_type'] = Variable<String>(trackingType.value);
    }
    if (weightRelevant.present) {
      map['weight_relevant'] = Variable<bool>(weightRelevant.value);
    }
    if (repetitionsRelevant.present) {
      map['repetitions_relevant'] = Variable<bool>(repetitionsRelevant.value);
    }
    if (distanceRelevant.present) {
      map['distance_relevant'] = Variable<bool>(distanceRelevant.value);
    }
    if (durationRelevant.present) {
      map['duration_relevant'] = Variable<bool>(durationRelevant.value);
    }
    if (bodyweightRelevant.present) {
      map['bodyweight_relevant'] = Variable<bool>(bodyweightRelevant.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (completedSetCount.present) {
      map['completed_set_count'] = Variable<int>(completedSetCount.value);
    }
    if (workingSetCount.present) {
      map['working_set_count'] = Variable<int>(workingSetCount.value);
    }
    if (totalRepetitions.present) {
      map['total_repetitions'] = Variable<int>(totalRepetitions.value);
    }
    if (totalVolumeKg.present) {
      map['total_volume_kg'] = Variable<double>(totalVolumeKg.value);
    }
    if (bestWeightKg.present) {
      map['best_weight_kg'] = Variable<double>(bestWeightKg.value);
    }
    if (bestEstimatedOneRepMaxKg.present) {
      map['best_estimated_one_rep_max_kg'] = Variable<double>(
        bestEstimatedOneRepMaxKg.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sourceActiveExerciseId: $sourceActiveExerciseId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('primaryMuscleGroup: $primaryMuscleGroup, ')
          ..write('secondaryMuscleGroupsJson: $secondaryMuscleGroupsJson, ')
          ..write('equipment: $equipment, ')
          ..write('trackingType: $trackingType, ')
          ..write('weightRelevant: $weightRelevant, ')
          ..write('repetitionsRelevant: $repetitionsRelevant, ')
          ..write('distanceRelevant: $distanceRelevant, ')
          ..write('durationRelevant: $durationRelevant, ')
          ..write('bodyweightRelevant: $bodyweightRelevant, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('completedSetCount: $completedSetCount, ')
          ..write('workingSetCount: $workingSetCount, ')
          ..write('totalRepetitions: $totalRepetitions, ')
          ..write('totalVolumeKg: $totalVolumeKg, ')
          ..write('bestWeightKg: $bestWeightKg, ')
          ..write('bestEstimatedOneRepMaxKg: $bestEstimatedOneRepMaxKg, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletedWorkoutSetsTable extends CompletedWorkoutSets
    with TableInfo<$CompletedWorkoutSetsTable, CompletedWorkoutSetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedWorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES completed_workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<String> sessionExerciseId =
      GeneratedColumn<String>(
        'session_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES completed_workout_exercises (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _sourceActiveSetIdMeta = const VerificationMeta(
    'sourceActiveSetId',
  );
  @override
  late final GeneratedColumn<String> sourceActiveSetId =
      GeneratedColumn<String>(
        'source_active_set_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<double> rir = GeneratedColumn<double>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _setVolumeKgMeta = const VerificationMeta(
    'setVolumeKg',
  );
  @override
  late final GeneratedColumn<double> setVolumeKg = GeneratedColumn<double>(
    'set_volume_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedOneRepMaxKgMeta =
      const VerificationMeta('estimatedOneRepMaxKg');
  @override
  late final GeneratedColumn<double> estimatedOneRepMaxKg =
      GeneratedColumn<double>(
        'estimated_one_rep_max_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isPersonalRecordMeta = const VerificationMeta(
    'isPersonalRecord',
  );
  @override
  late final GeneratedColumn<bool> isPersonalRecord = GeneratedColumn<bool>(
    'is_personal_record',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_personal_record" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    sessionId,
    sessionExerciseId,
    sourceActiveSetId,
    setType,
    weightKg,
    repetitions,
    durationSeconds,
    distanceMeters,
    rpe,
    rir,
    notes,
    sortOrder,
    setVolumeKg,
    estimatedOneRepMaxKg,
    isPersonalRecord,
    completedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletedWorkoutSetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('source_active_set_id')) {
      context.handle(
        _sourceActiveSetIdMeta,
        sourceActiveSetId.isAcceptableOrUnknown(
          data['source_active_set_id']!,
          _sourceActiveSetIdMeta,
        ),
      );
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('set_volume_kg')) {
      context.handle(
        _setVolumeKgMeta,
        setVolumeKg.isAcceptableOrUnknown(
          data['set_volume_kg']!,
          _setVolumeKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_setVolumeKgMeta);
    }
    if (data.containsKey('estimated_one_rep_max_kg')) {
      context.handle(
        _estimatedOneRepMaxKgMeta,
        estimatedOneRepMaxKg.isAcceptableOrUnknown(
          data['estimated_one_rep_max_kg']!,
          _estimatedOneRepMaxKgMeta,
        ),
      );
    }
    if (data.containsKey('is_personal_record')) {
      context.handle(
        _isPersonalRecordMeta,
        isPersonalRecord.isAcceptableOrUnknown(
          data['is_personal_record']!,
          _isPersonalRecordMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletedWorkoutSetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedWorkoutSetRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      sourceActiveSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_active_set_id'],
      ),
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rir'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      setVolumeKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}set_volume_kg'],
      )!,
      estimatedOneRepMaxKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_one_rep_max_kg'],
      ),
      isPersonalRecord: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_personal_record'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $CompletedWorkoutSetsTable createAlias(String alias) {
    return $CompletedWorkoutSetsTable(attachedDatabase, alias);
  }
}

class CompletedWorkoutSetRow extends DataClass
    implements Insertable<CompletedWorkoutSetRow> {
  final String id;
  final String userId;
  final String sessionId;
  final String sessionExerciseId;
  final String? sourceActiveSetId;
  final String setType;
  final double? weightKg;
  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? rpe;
  final double? rir;
  final String? notes;
  final int sortOrder;
  final double setVolumeKg;
  final double? estimatedOneRepMaxKg;
  final bool isPersonalRecord;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const CompletedWorkoutSetRow({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.sessionExerciseId,
    this.sourceActiveSetId,
    required this.setType,
    this.weightKg,
    this.repetitions,
    this.durationSeconds,
    this.distanceMeters,
    this.rpe,
    this.rir,
    this.notes,
    required this.sortOrder,
    required this.setVolumeKg,
    this.estimatedOneRepMaxKg,
    required this.isPersonalRecord,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['session_id'] = Variable<String>(sessionId);
    map['session_exercise_id'] = Variable<String>(sessionExerciseId);
    if (!nullToAbsent || sourceActiveSetId != null) {
      map['source_active_set_id'] = Variable<String>(sourceActiveSetId);
    }
    map['set_type'] = Variable<String>(setType);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<double>(rir);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['set_volume_kg'] = Variable<double>(setVolumeKg);
    if (!nullToAbsent || estimatedOneRepMaxKg != null) {
      map['estimated_one_rep_max_kg'] = Variable<double>(estimatedOneRepMaxKg);
    }
    map['is_personal_record'] = Variable<bool>(isPersonalRecord);
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  CompletedWorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return CompletedWorkoutSetsCompanion(
      id: Value(id),
      userId: Value(userId),
      sessionId: Value(sessionId),
      sessionExerciseId: Value(sessionExerciseId),
      sourceActiveSetId: sourceActiveSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceActiveSetId),
      setType: Value(setType),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      setVolumeKg: Value(setVolumeKg),
      estimatedOneRepMaxKg: estimatedOneRepMaxKg == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedOneRepMaxKg),
      isPersonalRecord: Value(isPersonalRecord),
      completedAt: Value(completedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory CompletedWorkoutSetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedWorkoutSetRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sessionExerciseId: serializer.fromJson<String>(json['sessionExerciseId']),
      sourceActiveSetId: serializer.fromJson<String?>(
        json['sourceActiveSetId'],
      ),
      setType: serializer.fromJson<String>(json['setType']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      rir: serializer.fromJson<double?>(json['rir']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      setVolumeKg: serializer.fromJson<double>(json['setVolumeKg']),
      estimatedOneRepMaxKg: serializer.fromJson<double?>(
        json['estimatedOneRepMaxKg'],
      ),
      isPersonalRecord: serializer.fromJson<bool>(json['isPersonalRecord']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'sessionId': serializer.toJson<String>(sessionId),
      'sessionExerciseId': serializer.toJson<String>(sessionExerciseId),
      'sourceActiveSetId': serializer.toJson<String?>(sourceActiveSetId),
      'setType': serializer.toJson<String>(setType),
      'weightKg': serializer.toJson<double?>(weightKg),
      'repetitions': serializer.toJson<int?>(repetitions),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
      'rpe': serializer.toJson<double?>(rpe),
      'rir': serializer.toJson<double?>(rir),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'setVolumeKg': serializer.toJson<double>(setVolumeKg),
      'estimatedOneRepMaxKg': serializer.toJson<double?>(estimatedOneRepMaxKg),
      'isPersonalRecord': serializer.toJson<bool>(isPersonalRecord),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  CompletedWorkoutSetRow copyWith({
    String? id,
    String? userId,
    String? sessionId,
    String? sessionExerciseId,
    Value<String?> sourceActiveSetId = const Value.absent(),
    String? setType,
    Value<double?> weightKg = const Value.absent(),
    Value<int?> repetitions = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    Value<double?> rir = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    double? setVolumeKg,
    Value<double?> estimatedOneRepMaxKg = const Value.absent(),
    bool? isPersonalRecord,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => CompletedWorkoutSetRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    sessionId: sessionId ?? this.sessionId,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    sourceActiveSetId: sourceActiveSetId.present
        ? sourceActiveSetId.value
        : this.sourceActiveSetId,
    setType: setType ?? this.setType,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
    rpe: rpe.present ? rpe.value : this.rpe,
    rir: rir.present ? rir.value : this.rir,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    setVolumeKg: setVolumeKg ?? this.setVolumeKg,
    estimatedOneRepMaxKg: estimatedOneRepMaxKg.present
        ? estimatedOneRepMaxKg.value
        : this.estimatedOneRepMaxKg,
    isPersonalRecord: isPersonalRecord ?? this.isPersonalRecord,
    completedAt: completedAt ?? this.completedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  CompletedWorkoutSetRow copyWithCompanion(CompletedWorkoutSetsCompanion data) {
    return CompletedWorkoutSetRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      sourceActiveSetId: data.sourceActiveSetId.present
          ? data.sourceActiveSetId.value
          : this.sourceActiveSetId,
      setType: data.setType.present ? data.setType.value : this.setType,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      rir: data.rir.present ? data.rir.value : this.rir,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      setVolumeKg: data.setVolumeKg.present
          ? data.setVolumeKg.value
          : this.setVolumeKg,
      estimatedOneRepMaxKg: data.estimatedOneRepMaxKg.present
          ? data.estimatedOneRepMaxKg.value
          : this.estimatedOneRepMaxKg,
      isPersonalRecord: data.isPersonalRecord.present
          ? data.isPersonalRecord.value
          : this.isPersonalRecord,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutSetRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('sourceActiveSetId: $sourceActiveSetId, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setVolumeKg: $setVolumeKg, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('isPersonalRecord: $isPersonalRecord, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    sessionId,
    sessionExerciseId,
    sourceActiveSetId,
    setType,
    weightKg,
    repetitions,
    durationSeconds,
    distanceMeters,
    rpe,
    rir,
    notes,
    sortOrder,
    setVolumeKg,
    estimatedOneRepMaxKg,
    isPersonalRecord,
    completedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedWorkoutSetRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.sessionId == this.sessionId &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.sourceActiveSetId == this.sourceActiveSetId &&
          other.setType == this.setType &&
          other.weightKg == this.weightKg &&
          other.repetitions == this.repetitions &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.rpe == this.rpe &&
          other.rir == this.rir &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.setVolumeKg == this.setVolumeKg &&
          other.estimatedOneRepMaxKg == this.estimatedOneRepMaxKg &&
          other.isPersonalRecord == this.isPersonalRecord &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class CompletedWorkoutSetsCompanion
    extends UpdateCompanion<CompletedWorkoutSetRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> sessionId;
  final Value<String> sessionExerciseId;
  final Value<String?> sourceActiveSetId;
  final Value<String> setType;
  final Value<double?> weightKg;
  final Value<int?> repetitions;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<double?> rpe;
  final Value<double?> rir;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<double> setVolumeKg;
  final Value<double?> estimatedOneRepMaxKg;
  final Value<bool> isPersonalRecord;
  final Value<DateTime> completedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const CompletedWorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.sourceActiveSetId = const Value.absent(),
    this.setType = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rpe = const Value.absent(),
    this.rir = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.setVolumeKg = const Value.absent(),
    this.estimatedOneRepMaxKg = const Value.absent(),
    this.isPersonalRecord = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletedWorkoutSetsCompanion.insert({
    required String id,
    required String userId,
    required String sessionId,
    required String sessionExerciseId,
    this.sourceActiveSetId = const Value.absent(),
    required String setType,
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rpe = const Value.absent(),
    this.rir = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required double setVolumeKg,
    this.estimatedOneRepMaxKg = const Value.absent(),
    this.isPersonalRecord = const Value.absent(),
    required DateTime completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       sessionId = Value(sessionId),
       sessionExerciseId = Value(sessionExerciseId),
       setType = Value(setType),
       setVolumeKg = Value(setVolumeKg),
       completedAt = Value(completedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CompletedWorkoutSetRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? sessionId,
    Expression<String>? sessionExerciseId,
    Expression<String>? sourceActiveSetId,
    Expression<String>? setType,
    Expression<double>? weightKg,
    Expression<int>? repetitions,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<double>? rpe,
    Expression<double>? rir,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<double>? setVolumeKg,
    Expression<double>? estimatedOneRepMaxKg,
    Expression<bool>? isPersonalRecord,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (sessionId != null) 'session_id': sessionId,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (sourceActiveSetId != null) 'source_active_set_id': sourceActiveSetId,
      if (setType != null) 'set_type': setType,
      if (weightKg != null) 'weight_kg': weightKg,
      if (repetitions != null) 'repetitions': repetitions,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (rpe != null) 'rpe': rpe,
      if (rir != null) 'rir': rir,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (setVolumeKg != null) 'set_volume_kg': setVolumeKg,
      if (estimatedOneRepMaxKg != null)
        'estimated_one_rep_max_kg': estimatedOneRepMaxKg,
      if (isPersonalRecord != null) 'is_personal_record': isPersonalRecord,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletedWorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? sessionId,
    Value<String>? sessionExerciseId,
    Value<String?>? sourceActiveSetId,
    Value<String>? setType,
    Value<double?>? weightKg,
    Value<int?>? repetitions,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<double?>? rpe,
    Value<double?>? rir,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<double>? setVolumeKg,
    Value<double?>? estimatedOneRepMaxKg,
    Value<bool>? isPersonalRecord,
    Value<DateTime>? completedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return CompletedWorkoutSetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      sourceActiveSetId: sourceActiveSetId ?? this.sourceActiveSetId,
      setType: setType ?? this.setType,
      weightKg: weightKg ?? this.weightKg,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      rpe: rpe ?? this.rpe,
      rir: rir ?? this.rir,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      setVolumeKg: setVolumeKg ?? this.setVolumeKg,
      estimatedOneRepMaxKg: estimatedOneRepMaxKg ?? this.estimatedOneRepMaxKg,
      isPersonalRecord: isPersonalRecord ?? this.isPersonalRecord,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<String>(sessionExerciseId.value);
    }
    if (sourceActiveSetId.present) {
      map['source_active_set_id'] = Variable<String>(sourceActiveSetId.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (rir.present) {
      map['rir'] = Variable<double>(rir.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (setVolumeKg.present) {
      map['set_volume_kg'] = Variable<double>(setVolumeKg.value);
    }
    if (estimatedOneRepMaxKg.present) {
      map['estimated_one_rep_max_kg'] = Variable<double>(
        estimatedOneRepMaxKg.value,
      );
    }
    if (isPersonalRecord.present) {
      map['is_personal_record'] = Variable<bool>(isPersonalRecord.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedWorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('sessionId: $sessionId, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('sourceActiveSetId: $sourceActiveSetId, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rpe: $rpe, ')
          ..write('rir: $rir, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setVolumeKg: $setVolumeKg, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('isPersonalRecord: $isPersonalRecord, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseSourceMeta = const VerificationMeta(
    'exerciseSource',
  );
  @override
  late final GeneratedColumn<String> exerciseSource = GeneratedColumn<String>(
    'exercise_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseKeyMeta = const VerificationMeta(
    'exerciseKey',
  );
  @override
  late final GeneratedColumn<String> exerciseKey = GeneratedColumn<String>(
    'exercise_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _systemExerciseKeyMeta = const VerificationMeta(
    'systemExerciseKey',
  );
  @override
  late final GeneratedColumn<String> systemExerciseKey =
      GeneratedColumn<String>(
        'system_exercise_key',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customExerciseIdMeta = const VerificationMeta(
    'customExerciseId',
  );
  @override
  late final GeneratedColumn<String> customExerciseId = GeneratedColumn<String>(
    'custom_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordKindMeta = const VerificationMeta(
    'recordKind',
  );
  @override
  late final GeneratedColumn<String> recordKind = GeneratedColumn<String>(
    'record_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordScopeMeta = const VerificationMeta(
    'recordScope',
  );
  @override
  late final GeneratedColumn<String> recordScope = GeneratedColumn<String>(
    'record_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('overall'),
  );
  static const VerificationMeta _recordValueMeta = const VerificationMeta(
    'recordValue',
  );
  @override
  late final GeneratedColumn<double> recordValue = GeneratedColumn<double>(
    'record_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedOneRepMaxKgMeta =
      const VerificationMeta('estimatedOneRepMaxKg');
  @override
  late final GeneratedColumn<double> estimatedOneRepMaxKg =
      GeneratedColumn<double>(
        'estimated_one_rep_max_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedSessionIdMeta =
      const VerificationMeta('completedSessionId');
  @override
  late final GeneratedColumn<String> completedSessionId =
      GeneratedColumn<String>(
        'completed_session_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedExerciseIdMeta =
      const VerificationMeta('completedExerciseId');
  @override
  late final GeneratedColumn<String> completedExerciseId =
      GeneratedColumn<String>(
        'completed_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedSetIdMeta = const VerificationMeta(
    'completedSetId',
  );
  @override
  late final GeneratedColumn<String> completedSetId = GeneratedColumn<String>(
    'completed_set_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    recordKind,
    recordScope,
    recordValue,
    weightKg,
    repetitions,
    estimatedOneRepMaxKg,
    completedSessionId,
    completedExerciseId,
    completedSetId,
    achievedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('exercise_source')) {
      context.handle(
        _exerciseSourceMeta,
        exerciseSource.isAcceptableOrUnknown(
          data['exercise_source']!,
          _exerciseSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseSourceMeta);
    }
    if (data.containsKey('exercise_key')) {
      context.handle(
        _exerciseKeyMeta,
        exerciseKey.isAcceptableOrUnknown(
          data['exercise_key']!,
          _exerciseKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseKeyMeta);
    }
    if (data.containsKey('system_exercise_key')) {
      context.handle(
        _systemExerciseKeyMeta,
        systemExerciseKey.isAcceptableOrUnknown(
          data['system_exercise_key']!,
          _systemExerciseKeyMeta,
        ),
      );
    }
    if (data.containsKey('custom_exercise_id')) {
      context.handle(
        _customExerciseIdMeta,
        customExerciseId.isAcceptableOrUnknown(
          data['custom_exercise_id']!,
          _customExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('record_kind')) {
      context.handle(
        _recordKindMeta,
        recordKind.isAcceptableOrUnknown(data['record_kind']!, _recordKindMeta),
      );
    } else if (isInserting) {
      context.missing(_recordKindMeta);
    }
    if (data.containsKey('record_scope')) {
      context.handle(
        _recordScopeMeta,
        recordScope.isAcceptableOrUnknown(
          data['record_scope']!,
          _recordScopeMeta,
        ),
      );
    }
    if (data.containsKey('record_value')) {
      context.handle(
        _recordValueMeta,
        recordValue.isAcceptableOrUnknown(
          data['record_value']!,
          _recordValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordValueMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('estimated_one_rep_max_kg')) {
      context.handle(
        _estimatedOneRepMaxKgMeta,
        estimatedOneRepMaxKg.isAcceptableOrUnknown(
          data['estimated_one_rep_max_kg']!,
          _estimatedOneRepMaxKgMeta,
        ),
      );
    }
    if (data.containsKey('completed_session_id')) {
      context.handle(
        _completedSessionIdMeta,
        completedSessionId.isAcceptableOrUnknown(
          data['completed_session_id']!,
          _completedSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedSessionIdMeta);
    }
    if (data.containsKey('completed_exercise_id')) {
      context.handle(
        _completedExerciseIdMeta,
        completedExerciseId.isAcceptableOrUnknown(
          data['completed_exercise_id']!,
          _completedExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedExerciseIdMeta);
    }
    if (data.containsKey('completed_set_id')) {
      context.handle(
        _completedSetIdMeta,
        completedSetId.isAcceptableOrUnknown(
          data['completed_set_id']!,
          _completedSetIdMeta,
        ),
      );
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, exerciseKey, recordKind, recordScope},
  ];
  @override
  PersonalRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      exerciseSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_source'],
      )!,
      exerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_key'],
      )!,
      systemExerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_exercise_key'],
      ),
      customExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_exercise_id'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      recordKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_kind'],
      )!,
      recordScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_scope'],
      )!,
      recordValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}record_value'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      estimatedOneRepMaxKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_one_rep_max_kg'],
      ),
      completedSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_session_id'],
      )!,
      completedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_exercise_id'],
      )!,
      completedSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_set_id'],
      ),
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecordRow extends DataClass
    implements Insertable<PersonalRecordRow> {
  final String id;
  final String userId;
  final String exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final String recordKind;
  final String recordScope;
  final double recordValue;
  final double? weightKg;
  final int? repetitions;
  final double? estimatedOneRepMaxKg;
  final String completedSessionId;
  final String completedExerciseId;
  final String? completedSetId;
  final DateTime achievedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const PersonalRecordRow({
    required this.id,
    required this.userId,
    required this.exerciseSource,
    required this.exerciseKey,
    this.systemExerciseKey,
    this.customExerciseId,
    required this.exerciseName,
    required this.recordKind,
    required this.recordScope,
    required this.recordValue,
    this.weightKg,
    this.repetitions,
    this.estimatedOneRepMaxKg,
    required this.completedSessionId,
    required this.completedExerciseId,
    this.completedSetId,
    required this.achievedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['exercise_source'] = Variable<String>(exerciseSource);
    map['exercise_key'] = Variable<String>(exerciseKey);
    if (!nullToAbsent || systemExerciseKey != null) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey);
    }
    if (!nullToAbsent || customExerciseId != null) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId);
    }
    map['exercise_name'] = Variable<String>(exerciseName);
    map['record_kind'] = Variable<String>(recordKind);
    map['record_scope'] = Variable<String>(recordScope);
    map['record_value'] = Variable<double>(recordValue);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || estimatedOneRepMaxKg != null) {
      map['estimated_one_rep_max_kg'] = Variable<double>(estimatedOneRepMaxKg);
    }
    map['completed_session_id'] = Variable<String>(completedSessionId);
    map['completed_exercise_id'] = Variable<String>(completedExerciseId);
    if (!nullToAbsent || completedSetId != null) {
      map['completed_set_id'] = Variable<String>(completedSetId);
    }
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      exerciseSource: Value(exerciseSource),
      exerciseKey: Value(exerciseKey),
      systemExerciseKey: systemExerciseKey == null && nullToAbsent
          ? const Value.absent()
          : Value(systemExerciseKey),
      customExerciseId: customExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(customExerciseId),
      exerciseName: Value(exerciseName),
      recordKind: Value(recordKind),
      recordScope: Value(recordScope),
      recordValue: Value(recordValue),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      estimatedOneRepMaxKg: estimatedOneRepMaxKg == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedOneRepMaxKg),
      completedSessionId: Value(completedSessionId),
      completedExerciseId: Value(completedExerciseId),
      completedSetId: completedSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedSetId),
      achievedAt: Value(achievedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory PersonalRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecordRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseKey: serializer.fromJson<String>(json['exerciseKey']),
      systemExerciseKey: serializer.fromJson<String?>(
        json['systemExerciseKey'],
      ),
      customExerciseId: serializer.fromJson<String?>(json['customExerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      recordKind: serializer.fromJson<String>(json['recordKind']),
      recordScope: serializer.fromJson<String>(json['recordScope']),
      recordValue: serializer.fromJson<double>(json['recordValue']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      estimatedOneRepMaxKg: serializer.fromJson<double?>(
        json['estimatedOneRepMaxKg'],
      ),
      completedSessionId: serializer.fromJson<String>(
        json['completedSessionId'],
      ),
      completedExerciseId: serializer.fromJson<String>(
        json['completedExerciseId'],
      ),
      completedSetId: serializer.fromJson<String?>(json['completedSetId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseKey': serializer.toJson<String>(exerciseKey),
      'systemExerciseKey': serializer.toJson<String?>(systemExerciseKey),
      'customExerciseId': serializer.toJson<String?>(customExerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'recordKind': serializer.toJson<String>(recordKind),
      'recordScope': serializer.toJson<String>(recordScope),
      'recordValue': serializer.toJson<double>(recordValue),
      'weightKg': serializer.toJson<double?>(weightKg),
      'repetitions': serializer.toJson<int?>(repetitions),
      'estimatedOneRepMaxKg': serializer.toJson<double?>(estimatedOneRepMaxKg),
      'completedSessionId': serializer.toJson<String>(completedSessionId),
      'completedExerciseId': serializer.toJson<String>(completedExerciseId),
      'completedSetId': serializer.toJson<String?>(completedSetId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  PersonalRecordRow copyWith({
    String? id,
    String? userId,
    String? exerciseSource,
    String? exerciseKey,
    Value<String?> systemExerciseKey = const Value.absent(),
    Value<String?> customExerciseId = const Value.absent(),
    String? exerciseName,
    String? recordKind,
    String? recordScope,
    double? recordValue,
    Value<double?> weightKg = const Value.absent(),
    Value<int?> repetitions = const Value.absent(),
    Value<double?> estimatedOneRepMaxKg = const Value.absent(),
    String? completedSessionId,
    String? completedExerciseId,
    Value<String?> completedSetId = const Value.absent(),
    DateTime? achievedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => PersonalRecordRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseKey: exerciseKey ?? this.exerciseKey,
    systemExerciseKey: systemExerciseKey.present
        ? systemExerciseKey.value
        : this.systemExerciseKey,
    customExerciseId: customExerciseId.present
        ? customExerciseId.value
        : this.customExerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    recordKind: recordKind ?? this.recordKind,
    recordScope: recordScope ?? this.recordScope,
    recordValue: recordValue ?? this.recordValue,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    estimatedOneRepMaxKg: estimatedOneRepMaxKg.present
        ? estimatedOneRepMaxKg.value
        : this.estimatedOneRepMaxKg,
    completedSessionId: completedSessionId ?? this.completedSessionId,
    completedExerciseId: completedExerciseId ?? this.completedExerciseId,
    completedSetId: completedSetId.present
        ? completedSetId.value
        : this.completedSetId,
    achievedAt: achievedAt ?? this.achievedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  PersonalRecordRow copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecordRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      exerciseSource: data.exerciseSource.present
          ? data.exerciseSource.value
          : this.exerciseSource,
      exerciseKey: data.exerciseKey.present
          ? data.exerciseKey.value
          : this.exerciseKey,
      systemExerciseKey: data.systemExerciseKey.present
          ? data.systemExerciseKey.value
          : this.systemExerciseKey,
      customExerciseId: data.customExerciseId.present
          ? data.customExerciseId.value
          : this.customExerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      recordKind: data.recordKind.present
          ? data.recordKind.value
          : this.recordKind,
      recordScope: data.recordScope.present
          ? data.recordScope.value
          : this.recordScope,
      recordValue: data.recordValue.present
          ? data.recordValue.value
          : this.recordValue,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      estimatedOneRepMaxKg: data.estimatedOneRepMaxKg.present
          ? data.estimatedOneRepMaxKg.value
          : this.estimatedOneRepMaxKg,
      completedSessionId: data.completedSessionId.present
          ? data.completedSessionId.value
          : this.completedSessionId,
      completedExerciseId: data.completedExerciseId.present
          ? data.completedExerciseId.value
          : this.completedExerciseId,
      completedSetId: data.completedSetId.present
          ? data.completedSetId.value
          : this.completedSetId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('recordKind: $recordKind, ')
          ..write('recordScope: $recordScope, ')
          ..write('recordValue: $recordValue, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('completedExerciseId: $completedExerciseId, ')
          ..write('completedSetId: $completedSetId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    exerciseSource,
    exerciseKey,
    systemExerciseKey,
    customExerciseId,
    exerciseName,
    recordKind,
    recordScope,
    recordValue,
    weightKg,
    repetitions,
    estimatedOneRepMaxKg,
    completedSessionId,
    completedExerciseId,
    completedSetId,
    achievedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecordRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseKey == this.exerciseKey &&
          other.systemExerciseKey == this.systemExerciseKey &&
          other.customExerciseId == this.customExerciseId &&
          other.exerciseName == this.exerciseName &&
          other.recordKind == this.recordKind &&
          other.recordScope == this.recordScope &&
          other.recordValue == this.recordValue &&
          other.weightKg == this.weightKg &&
          other.repetitions == this.repetitions &&
          other.estimatedOneRepMaxKg == this.estimatedOneRepMaxKg &&
          other.completedSessionId == this.completedSessionId &&
          other.completedExerciseId == this.completedExerciseId &&
          other.completedSetId == this.completedSetId &&
          other.achievedAt == this.achievedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecordRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> exerciseSource;
  final Value<String> exerciseKey;
  final Value<String?> systemExerciseKey;
  final Value<String?> customExerciseId;
  final Value<String> exerciseName;
  final Value<String> recordKind;
  final Value<String> recordScope;
  final Value<double> recordValue;
  final Value<double?> weightKg;
  final Value<int?> repetitions;
  final Value<double?> estimatedOneRepMaxKg;
  final Value<String> completedSessionId;
  final Value<String> completedExerciseId;
  final Value<String?> completedSetId;
  final Value<DateTime> achievedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseKey = const Value.absent(),
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.recordKind = const Value.absent(),
    this.recordScope = const Value.absent(),
    this.recordValue = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.estimatedOneRepMaxKg = const Value.absent(),
    this.completedSessionId = const Value.absent(),
    this.completedExerciseId = const Value.absent(),
    this.completedSetId = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    required String id,
    required String userId,
    required String exerciseSource,
    required String exerciseKey,
    this.systemExerciseKey = const Value.absent(),
    this.customExerciseId = const Value.absent(),
    required String exerciseName,
    required String recordKind,
    this.recordScope = const Value.absent(),
    required double recordValue,
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.estimatedOneRepMaxKg = const Value.absent(),
    required String completedSessionId,
    required String completedExerciseId,
    this.completedSetId = const Value.absent(),
    required DateTime achievedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       exerciseSource = Value(exerciseSource),
       exerciseKey = Value(exerciseKey),
       exerciseName = Value(exerciseName),
       recordKind = Value(recordKind),
       recordValue = Value(recordValue),
       completedSessionId = Value(completedSessionId),
       completedExerciseId = Value(completedExerciseId),
       achievedAt = Value(achievedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PersonalRecordRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseKey,
    Expression<String>? systemExerciseKey,
    Expression<String>? customExerciseId,
    Expression<String>? exerciseName,
    Expression<String>? recordKind,
    Expression<String>? recordScope,
    Expression<double>? recordValue,
    Expression<double>? weightKg,
    Expression<int>? repetitions,
    Expression<double>? estimatedOneRepMaxKg,
    Expression<String>? completedSessionId,
    Expression<String>? completedExerciseId,
    Expression<String>? completedSetId,
    Expression<DateTime>? achievedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseKey != null) 'exercise_key': exerciseKey,
      if (systemExerciseKey != null) 'system_exercise_key': systemExerciseKey,
      if (customExerciseId != null) 'custom_exercise_id': customExerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (recordKind != null) 'record_kind': recordKind,
      if (recordScope != null) 'record_scope': recordScope,
      if (recordValue != null) 'record_value': recordValue,
      if (weightKg != null) 'weight_kg': weightKg,
      if (repetitions != null) 'repetitions': repetitions,
      if (estimatedOneRepMaxKg != null)
        'estimated_one_rep_max_kg': estimatedOneRepMaxKg,
      if (completedSessionId != null)
        'completed_session_id': completedSessionId,
      if (completedExerciseId != null)
        'completed_exercise_id': completedExerciseId,
      if (completedSetId != null) 'completed_set_id': completedSetId,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? exerciseSource,
    Value<String>? exerciseKey,
    Value<String?>? systemExerciseKey,
    Value<String?>? customExerciseId,
    Value<String>? exerciseName,
    Value<String>? recordKind,
    Value<String>? recordScope,
    Value<double>? recordValue,
    Value<double?>? weightKg,
    Value<int?>? repetitions,
    Value<double?>? estimatedOneRepMaxKg,
    Value<String>? completedSessionId,
    Value<String>? completedExerciseId,
    Value<String?>? completedSetId,
    Value<DateTime>? achievedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseKey: exerciseKey ?? this.exerciseKey,
      systemExerciseKey: systemExerciseKey ?? this.systemExerciseKey,
      customExerciseId: customExerciseId ?? this.customExerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      recordKind: recordKind ?? this.recordKind,
      recordScope: recordScope ?? this.recordScope,
      recordValue: recordValue ?? this.recordValue,
      weightKg: weightKg ?? this.weightKg,
      repetitions: repetitions ?? this.repetitions,
      estimatedOneRepMaxKg: estimatedOneRepMaxKg ?? this.estimatedOneRepMaxKg,
      completedSessionId: completedSessionId ?? this.completedSessionId,
      completedExerciseId: completedExerciseId ?? this.completedExerciseId,
      completedSetId: completedSetId ?? this.completedSetId,
      achievedAt: achievedAt ?? this.achievedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (exerciseSource.present) {
      map['exercise_source'] = Variable<String>(exerciseSource.value);
    }
    if (exerciseKey.present) {
      map['exercise_key'] = Variable<String>(exerciseKey.value);
    }
    if (systemExerciseKey.present) {
      map['system_exercise_key'] = Variable<String>(systemExerciseKey.value);
    }
    if (customExerciseId.present) {
      map['custom_exercise_id'] = Variable<String>(customExerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (recordKind.present) {
      map['record_kind'] = Variable<String>(recordKind.value);
    }
    if (recordScope.present) {
      map['record_scope'] = Variable<String>(recordScope.value);
    }
    if (recordValue.present) {
      map['record_value'] = Variable<double>(recordValue.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (estimatedOneRepMaxKg.present) {
      map['estimated_one_rep_max_kg'] = Variable<double>(
        estimatedOneRepMaxKg.value,
      );
    }
    if (completedSessionId.present) {
      map['completed_session_id'] = Variable<String>(completedSessionId.value);
    }
    if (completedExerciseId.present) {
      map['completed_exercise_id'] = Variable<String>(
        completedExerciseId.value,
      );
    }
    if (completedSetId.present) {
      map['completed_set_id'] = Variable<String>(completedSetId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('systemExerciseKey: $systemExerciseKey, ')
          ..write('customExerciseId: $customExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('recordKind: $recordKind, ')
          ..write('recordScope: $recordScope, ')
          ..write('recordValue: $recordValue, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('completedExerciseId: $completedExerciseId, ')
          ..write('completedSetId: $completedSetId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordEventsTable extends PersonalRecordEvents
    with TableInfo<$PersonalRecordEventsTable, PersonalRecordEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personalRecordIdMeta = const VerificationMeta(
    'personalRecordId',
  );
  @override
  late final GeneratedColumn<String> personalRecordId = GeneratedColumn<String>(
    'personal_record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventKeyMeta = const VerificationMeta(
    'eventKey',
  );
  @override
  late final GeneratedColumn<String> eventKey = GeneratedColumn<String>(
    'event_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseSourceMeta = const VerificationMeta(
    'exerciseSource',
  );
  @override
  late final GeneratedColumn<String> exerciseSource = GeneratedColumn<String>(
    'exercise_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseKeyMeta = const VerificationMeta(
    'exerciseKey',
  );
  @override
  late final GeneratedColumn<String> exerciseKey = GeneratedColumn<String>(
    'exercise_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordKindMeta = const VerificationMeta(
    'recordKind',
  );
  @override
  late final GeneratedColumn<String> recordKind = GeneratedColumn<String>(
    'record_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordScopeMeta = const VerificationMeta(
    'recordScope',
  );
  @override
  late final GeneratedColumn<String> recordScope = GeneratedColumn<String>(
    'record_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('overall'),
  );
  static const VerificationMeta _previousRecordValueMeta =
      const VerificationMeta('previousRecordValue');
  @override
  late final GeneratedColumn<double> previousRecordValue =
      GeneratedColumn<double>(
        'previous_record_value',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recordValueMeta = const VerificationMeta(
    'recordValue',
  );
  @override
  late final GeneratedColumn<double> recordValue = GeneratedColumn<double>(
    'record_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedOneRepMaxKgMeta =
      const VerificationMeta('estimatedOneRepMaxKg');
  @override
  late final GeneratedColumn<double> estimatedOneRepMaxKg =
      GeneratedColumn<double>(
        'estimated_one_rep_max_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedSessionIdMeta =
      const VerificationMeta('completedSessionId');
  @override
  late final GeneratedColumn<String> completedSessionId =
      GeneratedColumn<String>(
        'completed_session_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedExerciseIdMeta =
      const VerificationMeta('completedExerciseId');
  @override
  late final GeneratedColumn<String> completedExerciseId =
      GeneratedColumn<String>(
        'completed_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _completedSetIdMeta = const VerificationMeta(
    'completedSetId',
  );
  @override
  late final GeneratedColumn<String> completedSetId = GeneratedColumn<String>(
    'completed_set_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    personalRecordId,
    eventKey,
    exerciseSource,
    exerciseKey,
    exerciseName,
    recordKind,
    recordScope,
    previousRecordValue,
    recordValue,
    weightKg,
    repetitions,
    estimatedOneRepMaxKg,
    completedSessionId,
    completedExerciseId,
    completedSetId,
    achievedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_record_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecordEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('personal_record_id')) {
      context.handle(
        _personalRecordIdMeta,
        personalRecordId.isAcceptableOrUnknown(
          data['personal_record_id']!,
          _personalRecordIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personalRecordIdMeta);
    }
    if (data.containsKey('event_key')) {
      context.handle(
        _eventKeyMeta,
        eventKey.isAcceptableOrUnknown(data['event_key']!, _eventKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_eventKeyMeta);
    }
    if (data.containsKey('exercise_source')) {
      context.handle(
        _exerciseSourceMeta,
        exerciseSource.isAcceptableOrUnknown(
          data['exercise_source']!,
          _exerciseSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseSourceMeta);
    }
    if (data.containsKey('exercise_key')) {
      context.handle(
        _exerciseKeyMeta,
        exerciseKey.isAcceptableOrUnknown(
          data['exercise_key']!,
          _exerciseKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseKeyMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('record_kind')) {
      context.handle(
        _recordKindMeta,
        recordKind.isAcceptableOrUnknown(data['record_kind']!, _recordKindMeta),
      );
    } else if (isInserting) {
      context.missing(_recordKindMeta);
    }
    if (data.containsKey('record_scope')) {
      context.handle(
        _recordScopeMeta,
        recordScope.isAcceptableOrUnknown(
          data['record_scope']!,
          _recordScopeMeta,
        ),
      );
    }
    if (data.containsKey('previous_record_value')) {
      context.handle(
        _previousRecordValueMeta,
        previousRecordValue.isAcceptableOrUnknown(
          data['previous_record_value']!,
          _previousRecordValueMeta,
        ),
      );
    }
    if (data.containsKey('record_value')) {
      context.handle(
        _recordValueMeta,
        recordValue.isAcceptableOrUnknown(
          data['record_value']!,
          _recordValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordValueMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('estimated_one_rep_max_kg')) {
      context.handle(
        _estimatedOneRepMaxKgMeta,
        estimatedOneRepMaxKg.isAcceptableOrUnknown(
          data['estimated_one_rep_max_kg']!,
          _estimatedOneRepMaxKgMeta,
        ),
      );
    }
    if (data.containsKey('completed_session_id')) {
      context.handle(
        _completedSessionIdMeta,
        completedSessionId.isAcceptableOrUnknown(
          data['completed_session_id']!,
          _completedSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedSessionIdMeta);
    }
    if (data.containsKey('completed_exercise_id')) {
      context.handle(
        _completedExerciseIdMeta,
        completedExerciseId.isAcceptableOrUnknown(
          data['completed_exercise_id']!,
          _completedExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedExerciseIdMeta);
    }
    if (data.containsKey('completed_set_id')) {
      context.handle(
        _completedSetIdMeta,
        completedSetId.isAcceptableOrUnknown(
          data['completed_set_id']!,
          _completedSetIdMeta,
        ),
      );
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {eventKey},
  ];
  @override
  PersonalRecordEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecordEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      personalRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_record_id'],
      )!,
      eventKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_key'],
      )!,
      exerciseSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_source'],
      )!,
      exerciseKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_key'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      recordKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_kind'],
      )!,
      recordScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_scope'],
      )!,
      previousRecordValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_record_value'],
      ),
      recordValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}record_value'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      ),
      estimatedOneRepMaxKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_one_rep_max_kg'],
      ),
      completedSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_session_id'],
      )!,
      completedExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_exercise_id'],
      )!,
      completedSetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_set_id'],
      ),
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $PersonalRecordEventsTable createAlias(String alias) {
    return $PersonalRecordEventsTable(attachedDatabase, alias);
  }
}

class PersonalRecordEventRow extends DataClass
    implements Insertable<PersonalRecordEventRow> {
  final String id;
  final String userId;
  final String personalRecordId;
  final String eventKey;
  final String exerciseSource;
  final String exerciseKey;
  final String exerciseName;
  final String recordKind;
  final String recordScope;
  final double? previousRecordValue;
  final double recordValue;
  final double? weightKg;
  final int? repetitions;
  final double? estimatedOneRepMaxKg;
  final String completedSessionId;
  final String completedExerciseId;
  final String? completedSetId;
  final DateTime achievedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;
  const PersonalRecordEventRow({
    required this.id,
    required this.userId,
    required this.personalRecordId,
    required this.eventKey,
    required this.exerciseSource,
    required this.exerciseKey,
    required this.exerciseName,
    required this.recordKind,
    required this.recordScope,
    this.previousRecordValue,
    required this.recordValue,
    this.weightKg,
    this.repetitions,
    this.estimatedOneRepMaxKg,
    required this.completedSessionId,
    required this.completedExerciseId,
    this.completedSetId,
    required this.achievedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['personal_record_id'] = Variable<String>(personalRecordId);
    map['event_key'] = Variable<String>(eventKey);
    map['exercise_source'] = Variable<String>(exerciseSource);
    map['exercise_key'] = Variable<String>(exerciseKey);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['record_kind'] = Variable<String>(recordKind);
    map['record_scope'] = Variable<String>(recordScope);
    if (!nullToAbsent || previousRecordValue != null) {
      map['previous_record_value'] = Variable<double>(previousRecordValue);
    }
    map['record_value'] = Variable<double>(recordValue);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || repetitions != null) {
      map['repetitions'] = Variable<int>(repetitions);
    }
    if (!nullToAbsent || estimatedOneRepMaxKg != null) {
      map['estimated_one_rep_max_kg'] = Variable<double>(estimatedOneRepMaxKg);
    }
    map['completed_session_id'] = Variable<String>(completedSessionId);
    map['completed_exercise_id'] = Variable<String>(completedExerciseId);
    if (!nullToAbsent || completedSetId != null) {
      map['completed_set_id'] = Variable<String>(completedSetId);
    }
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  PersonalRecordEventsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordEventsCompanion(
      id: Value(id),
      userId: Value(userId),
      personalRecordId: Value(personalRecordId),
      eventKey: Value(eventKey),
      exerciseSource: Value(exerciseSource),
      exerciseKey: Value(exerciseKey),
      exerciseName: Value(exerciseName),
      recordKind: Value(recordKind),
      recordScope: Value(recordScope),
      previousRecordValue: previousRecordValue == null && nullToAbsent
          ? const Value.absent()
          : Value(previousRecordValue),
      recordValue: Value(recordValue),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      repetitions: repetitions == null && nullToAbsent
          ? const Value.absent()
          : Value(repetitions),
      estimatedOneRepMaxKg: estimatedOneRepMaxKg == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedOneRepMaxKg),
      completedSessionId: Value(completedSessionId),
      completedExerciseId: Value(completedExerciseId),
      completedSetId: completedSetId == null && nullToAbsent
          ? const Value.absent()
          : Value(completedSetId),
      achievedAt: Value(achievedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      version: Value(version),
    );
  }

  factory PersonalRecordEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecordEventRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      personalRecordId: serializer.fromJson<String>(json['personalRecordId']),
      eventKey: serializer.fromJson<String>(json['eventKey']),
      exerciseSource: serializer.fromJson<String>(json['exerciseSource']),
      exerciseKey: serializer.fromJson<String>(json['exerciseKey']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      recordKind: serializer.fromJson<String>(json['recordKind']),
      recordScope: serializer.fromJson<String>(json['recordScope']),
      previousRecordValue: serializer.fromJson<double?>(
        json['previousRecordValue'],
      ),
      recordValue: serializer.fromJson<double>(json['recordValue']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      repetitions: serializer.fromJson<int?>(json['repetitions']),
      estimatedOneRepMaxKg: serializer.fromJson<double?>(
        json['estimatedOneRepMaxKg'],
      ),
      completedSessionId: serializer.fromJson<String>(
        json['completedSessionId'],
      ),
      completedExerciseId: serializer.fromJson<String>(
        json['completedExerciseId'],
      ),
      completedSetId: serializer.fromJson<String?>(json['completedSetId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'personalRecordId': serializer.toJson<String>(personalRecordId),
      'eventKey': serializer.toJson<String>(eventKey),
      'exerciseSource': serializer.toJson<String>(exerciseSource),
      'exerciseKey': serializer.toJson<String>(exerciseKey),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'recordKind': serializer.toJson<String>(recordKind),
      'recordScope': serializer.toJson<String>(recordScope),
      'previousRecordValue': serializer.toJson<double?>(previousRecordValue),
      'recordValue': serializer.toJson<double>(recordValue),
      'weightKg': serializer.toJson<double?>(weightKg),
      'repetitions': serializer.toJson<int?>(repetitions),
      'estimatedOneRepMaxKg': serializer.toJson<double?>(estimatedOneRepMaxKg),
      'completedSessionId': serializer.toJson<String>(completedSessionId),
      'completedExerciseId': serializer.toJson<String>(completedExerciseId),
      'completedSetId': serializer.toJson<String?>(completedSetId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  PersonalRecordEventRow copyWith({
    String? id,
    String? userId,
    String? personalRecordId,
    String? eventKey,
    String? exerciseSource,
    String? exerciseKey,
    String? exerciseName,
    String? recordKind,
    String? recordScope,
    Value<double?> previousRecordValue = const Value.absent(),
    double? recordValue,
    Value<double?> weightKg = const Value.absent(),
    Value<int?> repetitions = const Value.absent(),
    Value<double?> estimatedOneRepMaxKg = const Value.absent(),
    String? completedSessionId,
    String? completedExerciseId,
    Value<String?> completedSetId = const Value.absent(),
    DateTime? achievedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    int? version,
  }) => PersonalRecordEventRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    personalRecordId: personalRecordId ?? this.personalRecordId,
    eventKey: eventKey ?? this.eventKey,
    exerciseSource: exerciseSource ?? this.exerciseSource,
    exerciseKey: exerciseKey ?? this.exerciseKey,
    exerciseName: exerciseName ?? this.exerciseName,
    recordKind: recordKind ?? this.recordKind,
    recordScope: recordScope ?? this.recordScope,
    previousRecordValue: previousRecordValue.present
        ? previousRecordValue.value
        : this.previousRecordValue,
    recordValue: recordValue ?? this.recordValue,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    repetitions: repetitions.present ? repetitions.value : this.repetitions,
    estimatedOneRepMaxKg: estimatedOneRepMaxKg.present
        ? estimatedOneRepMaxKg.value
        : this.estimatedOneRepMaxKg,
    completedSessionId: completedSessionId ?? this.completedSessionId,
    completedExerciseId: completedExerciseId ?? this.completedExerciseId,
    completedSetId: completedSetId.present
        ? completedSetId.value
        : this.completedSetId,
    achievedAt: achievedAt ?? this.achievedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    version: version ?? this.version,
  );
  PersonalRecordEventRow copyWithCompanion(PersonalRecordEventsCompanion data) {
    return PersonalRecordEventRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      personalRecordId: data.personalRecordId.present
          ? data.personalRecordId.value
          : this.personalRecordId,
      eventKey: data.eventKey.present ? data.eventKey.value : this.eventKey,
      exerciseSource: data.exerciseSource.present
          ? data.exerciseSource.value
          : this.exerciseSource,
      exerciseKey: data.exerciseKey.present
          ? data.exerciseKey.value
          : this.exerciseKey,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      recordKind: data.recordKind.present
          ? data.recordKind.value
          : this.recordKind,
      recordScope: data.recordScope.present
          ? data.recordScope.value
          : this.recordScope,
      previousRecordValue: data.previousRecordValue.present
          ? data.previousRecordValue.value
          : this.previousRecordValue,
      recordValue: data.recordValue.present
          ? data.recordValue.value
          : this.recordValue,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      estimatedOneRepMaxKg: data.estimatedOneRepMaxKg.present
          ? data.estimatedOneRepMaxKg.value
          : this.estimatedOneRepMaxKg,
      completedSessionId: data.completedSessionId.present
          ? data.completedSessionId.value
          : this.completedSessionId,
      completedExerciseId: data.completedExerciseId.present
          ? data.completedExerciseId.value
          : this.completedExerciseId,
      completedSetId: data.completedSetId.present
          ? data.completedSetId.value
          : this.completedSetId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordEventRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('personalRecordId: $personalRecordId, ')
          ..write('eventKey: $eventKey, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('recordKind: $recordKind, ')
          ..write('recordScope: $recordScope, ')
          ..write('previousRecordValue: $previousRecordValue, ')
          ..write('recordValue: $recordValue, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('completedExerciseId: $completedExerciseId, ')
          ..write('completedSetId: $completedSetId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    personalRecordId,
    eventKey,
    exerciseSource,
    exerciseKey,
    exerciseName,
    recordKind,
    recordScope,
    previousRecordValue,
    recordValue,
    weightKg,
    repetitions,
    estimatedOneRepMaxKg,
    completedSessionId,
    completedExerciseId,
    completedSetId,
    achievedAt,
    createdAt,
    updatedAt,
    deletedAt,
    version,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecordEventRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.personalRecordId == this.personalRecordId &&
          other.eventKey == this.eventKey &&
          other.exerciseSource == this.exerciseSource &&
          other.exerciseKey == this.exerciseKey &&
          other.exerciseName == this.exerciseName &&
          other.recordKind == this.recordKind &&
          other.recordScope == this.recordScope &&
          other.previousRecordValue == this.previousRecordValue &&
          other.recordValue == this.recordValue &&
          other.weightKg == this.weightKg &&
          other.repetitions == this.repetitions &&
          other.estimatedOneRepMaxKg == this.estimatedOneRepMaxKg &&
          other.completedSessionId == this.completedSessionId &&
          other.completedExerciseId == this.completedExerciseId &&
          other.completedSetId == this.completedSetId &&
          other.achievedAt == this.achievedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.version == this.version);
}

class PersonalRecordEventsCompanion
    extends UpdateCompanion<PersonalRecordEventRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> personalRecordId;
  final Value<String> eventKey;
  final Value<String> exerciseSource;
  final Value<String> exerciseKey;
  final Value<String> exerciseName;
  final Value<String> recordKind;
  final Value<String> recordScope;
  final Value<double?> previousRecordValue;
  final Value<double> recordValue;
  final Value<double?> weightKg;
  final Value<int?> repetitions;
  final Value<double?> estimatedOneRepMaxKg;
  final Value<String> completedSessionId;
  final Value<String> completedExerciseId;
  final Value<String?> completedSetId;
  final Value<DateTime> achievedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> version;
  final Value<int> rowid;
  const PersonalRecordEventsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.personalRecordId = const Value.absent(),
    this.eventKey = const Value.absent(),
    this.exerciseSource = const Value.absent(),
    this.exerciseKey = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.recordKind = const Value.absent(),
    this.recordScope = const Value.absent(),
    this.previousRecordValue = const Value.absent(),
    this.recordValue = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.estimatedOneRepMaxKg = const Value.absent(),
    this.completedSessionId = const Value.absent(),
    this.completedExerciseId = const Value.absent(),
    this.completedSetId = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordEventsCompanion.insert({
    required String id,
    required String userId,
    required String personalRecordId,
    required String eventKey,
    required String exerciseSource,
    required String exerciseKey,
    required String exerciseName,
    required String recordKind,
    this.recordScope = const Value.absent(),
    this.previousRecordValue = const Value.absent(),
    required double recordValue,
    this.weightKg = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.estimatedOneRepMaxKg = const Value.absent(),
    required String completedSessionId,
    required String completedExerciseId,
    this.completedSetId = const Value.absent(),
    required DateTime achievedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       personalRecordId = Value(personalRecordId),
       eventKey = Value(eventKey),
       exerciseSource = Value(exerciseSource),
       exerciseKey = Value(exerciseKey),
       exerciseName = Value(exerciseName),
       recordKind = Value(recordKind),
       recordValue = Value(recordValue),
       completedSessionId = Value(completedSessionId),
       completedExerciseId = Value(completedExerciseId),
       achievedAt = Value(achievedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PersonalRecordEventRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? personalRecordId,
    Expression<String>? eventKey,
    Expression<String>? exerciseSource,
    Expression<String>? exerciseKey,
    Expression<String>? exerciseName,
    Expression<String>? recordKind,
    Expression<String>? recordScope,
    Expression<double>? previousRecordValue,
    Expression<double>? recordValue,
    Expression<double>? weightKg,
    Expression<int>? repetitions,
    Expression<double>? estimatedOneRepMaxKg,
    Expression<String>? completedSessionId,
    Expression<String>? completedExerciseId,
    Expression<String>? completedSetId,
    Expression<DateTime>? achievedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (personalRecordId != null) 'personal_record_id': personalRecordId,
      if (eventKey != null) 'event_key': eventKey,
      if (exerciseSource != null) 'exercise_source': exerciseSource,
      if (exerciseKey != null) 'exercise_key': exerciseKey,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (recordKind != null) 'record_kind': recordKind,
      if (recordScope != null) 'record_scope': recordScope,
      if (previousRecordValue != null)
        'previous_record_value': previousRecordValue,
      if (recordValue != null) 'record_value': recordValue,
      if (weightKg != null) 'weight_kg': weightKg,
      if (repetitions != null) 'repetitions': repetitions,
      if (estimatedOneRepMaxKg != null)
        'estimated_one_rep_max_kg': estimatedOneRepMaxKg,
      if (completedSessionId != null)
        'completed_session_id': completedSessionId,
      if (completedExerciseId != null)
        'completed_exercise_id': completedExerciseId,
      if (completedSetId != null) 'completed_set_id': completedSetId,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? personalRecordId,
    Value<String>? eventKey,
    Value<String>? exerciseSource,
    Value<String>? exerciseKey,
    Value<String>? exerciseName,
    Value<String>? recordKind,
    Value<String>? recordScope,
    Value<double?>? previousRecordValue,
    Value<double>? recordValue,
    Value<double?>? weightKg,
    Value<int?>? repetitions,
    Value<double?>? estimatedOneRepMaxKg,
    Value<String>? completedSessionId,
    Value<String>? completedExerciseId,
    Value<String?>? completedSetId,
    Value<DateTime>? achievedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? version,
    Value<int>? rowid,
  }) {
    return PersonalRecordEventsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      personalRecordId: personalRecordId ?? this.personalRecordId,
      eventKey: eventKey ?? this.eventKey,
      exerciseSource: exerciseSource ?? this.exerciseSource,
      exerciseKey: exerciseKey ?? this.exerciseKey,
      exerciseName: exerciseName ?? this.exerciseName,
      recordKind: recordKind ?? this.recordKind,
      recordScope: recordScope ?? this.recordScope,
      previousRecordValue: previousRecordValue ?? this.previousRecordValue,
      recordValue: recordValue ?? this.recordValue,
      weightKg: weightKg ?? this.weightKg,
      repetitions: repetitions ?? this.repetitions,
      estimatedOneRepMaxKg: estimatedOneRepMaxKg ?? this.estimatedOneRepMaxKg,
      completedSessionId: completedSessionId ?? this.completedSessionId,
      completedExerciseId: completedExerciseId ?? this.completedExerciseId,
      completedSetId: completedSetId ?? this.completedSetId,
      achievedAt: achievedAt ?? this.achievedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (personalRecordId.present) {
      map['personal_record_id'] = Variable<String>(personalRecordId.value);
    }
    if (eventKey.present) {
      map['event_key'] = Variable<String>(eventKey.value);
    }
    if (exerciseSource.present) {
      map['exercise_source'] = Variable<String>(exerciseSource.value);
    }
    if (exerciseKey.present) {
      map['exercise_key'] = Variable<String>(exerciseKey.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (recordKind.present) {
      map['record_kind'] = Variable<String>(recordKind.value);
    }
    if (recordScope.present) {
      map['record_scope'] = Variable<String>(recordScope.value);
    }
    if (previousRecordValue.present) {
      map['previous_record_value'] = Variable<double>(
        previousRecordValue.value,
      );
    }
    if (recordValue.present) {
      map['record_value'] = Variable<double>(recordValue.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (estimatedOneRepMaxKg.present) {
      map['estimated_one_rep_max_kg'] = Variable<double>(
        estimatedOneRepMaxKg.value,
      );
    }
    if (completedSessionId.present) {
      map['completed_session_id'] = Variable<String>(completedSessionId.value);
    }
    if (completedExerciseId.present) {
      map['completed_exercise_id'] = Variable<String>(
        completedExerciseId.value,
      );
    }
    if (completedSetId.present) {
      map['completed_set_id'] = Variable<String>(completedSetId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordEventsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('personalRecordId: $personalRecordId, ')
          ..write('eventKey: $eventKey, ')
          ..write('exerciseSource: $exerciseSource, ')
          ..write('exerciseKey: $exerciseKey, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('recordKind: $recordKind, ')
          ..write('recordScope: $recordScope, ')
          ..write('previousRecordValue: $previousRecordValue, ')
          ..write('recordValue: $recordValue, ')
          ..write('weightKg: $weightKg, ')
          ..write('repetitions: $repetitions, ')
          ..write('estimatedOneRepMaxKg: $estimatedOneRepMaxKg, ')
          ..write('completedSessionId: $completedSessionId, ')
          ..write('completedExerciseId: $completedExerciseId, ')
          ..write('completedSetId: $completedSetId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionSyncQueueTable extends SessionSyncQueue
    with TableInfo<$SessionSyncQueueTable, SessionSyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionSyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityVersionMeta = const VerificationMeta(
    'entityVersion',
  );
  @override
  late final GeneratedColumn<int> entityVersion = GeneratedColumn<int>(
    'entity_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    entityType,
    entityId,
    entityVersion,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionSyncQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('entity_version')) {
      context.handle(
        _entityVersionMeta,
        entityVersion.isAcceptableOrUnknown(
          data['entity_version']!,
          _entityVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityVersionMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, entityType, entityId},
  ];
  @override
  SessionSyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionSyncQueueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      entityVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_version'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionSyncQueueTable createAlias(String alias) {
    return $SessionSyncQueueTable(attachedDatabase, alias);
  }
}

class SessionSyncQueueRow extends DataClass
    implements Insertable<SessionSyncQueueRow> {
  final String id;
  final String userId;
  final String entityType;
  final String entityId;
  final int entityVersion;
  final int attemptCount;
  final String? lastError;
  final DateTime? lastAttemptAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SessionSyncQueueRow({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.entityVersion,
    required this.attemptCount,
    this.lastError,
    this.lastAttemptAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['entity_version'] = Variable<int>(entityVersion);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SessionSyncQueueCompanion(
      id: Value(id),
      userId: Value(userId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      entityVersion: Value(entityVersion),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionSyncQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionSyncQueueRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      entityVersion: serializer.fromJson<int>(json['entityVersion']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'entityVersion': serializer.toJson<int>(entityVersion),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionSyncQueueRow copyWith({
    String? id,
    String? userId,
    String? entityType,
    String? entityId,
    int? entityVersion,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SessionSyncQueueRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    entityVersion: entityVersion ?? this.entityVersion,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionSyncQueueRow copyWithCompanion(SessionSyncQueueCompanion data) {
    return SessionSyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      entityVersion: data.entityVersion.present
          ? data.entityVersion.value
          : this.entityVersion,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionSyncQueueRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityVersion: $entityVersion, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    entityType,
    entityId,
    entityVersion,
    attemptCount,
    lastError,
    lastAttemptAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionSyncQueueRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.entityVersion == this.entityVersion &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionSyncQueueCompanion extends UpdateCompanion<SessionSyncQueueRow> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<int> entityVersion;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime?> lastAttemptAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionSyncQueueCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.entityVersion = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionSyncQueueCompanion.insert({
    required String id,
    required String userId,
    required String entityType,
    required String entityId,
    required int entityVersion,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       entityType = Value(entityType),
       entityId = Value(entityId),
       entityVersion = Value(entityVersion),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SessionSyncQueueRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<int>? entityVersion,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? lastAttemptAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (entityVersion != null) 'entity_version': entityVersion,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionSyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<int>? entityVersion,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime?>? lastAttemptAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionSyncQueueCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      entityVersion: entityVersion ?? this.entityVersion,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (entityVersion.present) {
      map['entity_version'] = Variable<int>(entityVersion.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('entityVersion: $entityVersion, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $WorkoutSplitsTable workoutSplits = $WorkoutSplitsTable(this);
  late final $CustomExercisesTable customExercises = $CustomExercisesTable(
    this,
  );
  late final $WorkoutTemplatesTable workoutTemplates = $WorkoutTemplatesTable(
    this,
  );
  late final $TemplateExercisesTable templateExercises =
      $TemplateExercisesTable(this);
  late final $PlannerSyncQueueTable plannerSyncQueue = $PlannerSyncQueueTable(
    this,
  );
  late final $ActiveWorkoutSessionsTable activeWorkoutSessions =
      $ActiveWorkoutSessionsTable(this);
  late final $ActiveWorkoutExercisesTable activeWorkoutExercises =
      $ActiveWorkoutExercisesTable(this);
  late final $ActiveWorkoutSetsTable activeWorkoutSets =
      $ActiveWorkoutSetsTable(this);
  late final $CompletedWorkoutSessionsTable completedWorkoutSessions =
      $CompletedWorkoutSessionsTable(this);
  late final $CompletedWorkoutExercisesTable completedWorkoutExercises =
      $CompletedWorkoutExercisesTable(this);
  late final $CompletedWorkoutSetsTable completedWorkoutSets =
      $CompletedWorkoutSetsTable(this);
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $PersonalRecordEventsTable personalRecordEvents =
      $PersonalRecordEventsTable(this);
  late final $SessionSyncQueueTable sessionSyncQueue = $SessionSyncQueueTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workouts,
    workoutSets,
    syncQueue,
    workoutSplits,
    customExercises,
    workoutTemplates,
    templateExercises,
    plannerSyncQueue,
    activeWorkoutSessions,
    activeWorkoutExercises,
    activeWorkoutSets,
    completedWorkoutSessions,
    completedWorkoutExercises,
    completedWorkoutSets,
    personalRecords,
    personalRecordEvents,
    sessionSyncQueue,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sync_queue', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('template_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'active_workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('active_workout_exercises', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'active_workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('active_workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'active_workout_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('active_workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'completed_workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('completed_workout_exercises', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'completed_workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('completed_workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'completed_workout_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('completed_workout_sets', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      required String id,
      required String userId,
      required String exerciseName,
      required DateTime performedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> exerciseName,
      Value<DateTime> performedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, WorkoutRow> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSetRow>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workouts__id__workout_sets__workout_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SyncQueueTable, List<SyncQueueRow>>
  _syncQueueRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncQueue,
    aliasName: 'workouts__id__sync_queue__workout_id',
  );

  $$SyncQueueTableProcessedTableManager get syncQueueRefs {
    final manager = $$SyncQueueTableTableManager(
      $_db,
      $_db.syncQueue,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_syncQueueRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> syncQueueRefs(
    Expression<bool> Function($$SyncQueueTableFilterComposer f) f,
  ) {
    final $$SyncQueueTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableFilterComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
    column: $table.performedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> syncQueueRefs<T extends Object>(
    Expression<T> Function($$SyncQueueTableAnnotationComposer a) f,
  ) {
    final $$SyncQueueTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncQueue,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncQueueTableAnnotationComposer(
            $db: $db,
            $table: $db.syncQueue,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          WorkoutRow,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (WorkoutRow, $$WorkoutsTableReferences),
          WorkoutRow,
          PrefetchHooks Function({bool workoutSetsRefs, bool syncQueueRefs})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<DateTime> performedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                userId: userId,
                exerciseName: exerciseName,
                performedAt: performedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String exerciseName,
                required DateTime performedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                userId: userId,
                exerciseName: exerciseName,
                performedAt: performedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({workoutSetsRefs = false, syncQueueRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                    if (syncQueueRefs) db.syncQueue,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutRow,
                          $WorkoutsTable,
                          WorkoutSetRow
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (syncQueueRefs)
                        await $_getPrefetchedData<
                          WorkoutRow,
                          $WorkoutsTable,
                          SyncQueueRow
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutsTableReferences
                              ._syncQueueRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutsTableReferences(
                                db,
                                table,
                                p0,
                              ).syncQueueRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      WorkoutRow,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (WorkoutRow, $$WorkoutsTableReferences),
      WorkoutRow,
      PrefetchHooks Function({bool workoutSetsRefs, bool syncQueueRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String id,
      required String workoutId,
      required String userId,
      required double weight,
      required int reps,
      Value<int> setOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> userId,
      Value<double> weight,
      Value<int> reps,
      Value<int> setOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSetRow> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_sets__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get setOrder =>
      $composableBuilder(column: $table.setOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSetRow,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSetRow, $$WorkoutSetsTableReferences),
          WorkoutSetRow,
          PrefetchHooks Function({bool workoutId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> setOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                workoutId: workoutId,
                userId: userId,
                weight: weight,
                reps: reps,
                setOrder: setOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String userId,
                required double weight,
                required int reps,
                Value<int> setOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                workoutId: workoutId,
                userId: userId,
                weight: weight,
                reps: reps,
                setOrder: setOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutId,
                                referencedTable: $$WorkoutSetsTableReferences
                                    ._workoutIdTable(db),
                                referencedColumn: $$WorkoutSetsTableReferences
                                    ._workoutIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSetRow,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSetRow, $$WorkoutSetsTableReferences),
      WorkoutSetRow,
      PrefetchHooks Function({bool workoutId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String workoutId,
      required String userId,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> userId,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SyncQueueTableReferences
    extends BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRow> {
  $$SyncQueueTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('sync_queue__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueRow,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (SyncQueueRow, $$SyncQueueTableReferences),
          SyncQueueRow,
          PrefetchHooks Function({bool workoutId})
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                workoutId: workoutId,
                userId: userId,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String userId,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                workoutId: workoutId,
                userId: userId,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SyncQueueTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutId,
                                referencedTable: $$SyncQueueTableReferences
                                    ._workoutIdTable(db),
                                referencedColumn: $$SyncQueueTableReferences
                                    ._workoutIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueRow,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (SyncQueueRow, $$SyncQueueTableReferences),
      SyncQueueRow,
      PrefetchHooks Function({bool workoutId})
    >;
typedef $$WorkoutSplitsTableCreateCompanionBuilder =
    WorkoutSplitsCompanion Function({
      required String id,
      required String userId,
      required String name,
      Value<String?> description,
      required String icon,
      required int colorValue,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$WorkoutSplitsTableUpdateCompanionBuilder =
    WorkoutSplitsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String?> description,
      Value<String> icon,
      Value<int> colorValue,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$WorkoutSplitsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSplitsTable, WorkoutSplitRow> {
  $$WorkoutSplitsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutTemplatesTable, List<WorkoutTemplateRow>>
  _workoutTemplatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutTemplates,
    aliasName: 'workout_splits__id__workout_templates__split_id',
  );

  $$WorkoutTemplatesTableProcessedTableManager get workoutTemplatesRefs {
    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.splitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSplitsTable> {
  $$WorkoutSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutTemplatesRefs(
    Expression<bool> Function($$WorkoutTemplatesTableFilterComposer f) f,
  ) {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.splitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSplitsTable> {
  $$WorkoutSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSplitsTable> {
  $$WorkoutSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> workoutTemplatesRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplatesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.splitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSplitsTable,
          WorkoutSplitRow,
          $$WorkoutSplitsTableFilterComposer,
          $$WorkoutSplitsTableOrderingComposer,
          $$WorkoutSplitsTableAnnotationComposer,
          $$WorkoutSplitsTableCreateCompanionBuilder,
          $$WorkoutSplitsTableUpdateCompanionBuilder,
          (WorkoutSplitRow, $$WorkoutSplitsTableReferences),
          WorkoutSplitRow,
          PrefetchHooks Function({bool workoutTemplatesRefs})
        > {
  $$WorkoutSplitsTableTableManager(_$AppDatabase db, $WorkoutSplitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSplitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSplitsCompanion(
                id: id,
                userId: userId,
                name: name,
                description: description,
                icon: icon,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                Value<String?> description = const Value.absent(),
                required String icon,
                required int colorValue,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSplitsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                description: description,
                icon: icon,
                colorValue: colorValue,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSplitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutTemplatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutTemplatesRefs) db.workoutTemplates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutTemplatesRefs)
                    await $_getPrefetchedData<
                      WorkoutSplitRow,
                      $WorkoutSplitsTable,
                      WorkoutTemplateRow
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSplitsTableReferences
                          ._workoutTemplatesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSplitsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutTemplatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.splitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSplitsTable,
      WorkoutSplitRow,
      $$WorkoutSplitsTableFilterComposer,
      $$WorkoutSplitsTableOrderingComposer,
      $$WorkoutSplitsTableAnnotationComposer,
      $$WorkoutSplitsTableCreateCompanionBuilder,
      $$WorkoutSplitsTableUpdateCompanionBuilder,
      (WorkoutSplitRow, $$WorkoutSplitsTableReferences),
      WorkoutSplitRow,
      PrefetchHooks Function({bool workoutTemplatesRefs})
    >;
typedef $$CustomExercisesTableCreateCompanionBuilder =
    CustomExercisesCompanion Function({
      required String id,
      required String userId,
      required String name,
      required String primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      required String equipment,
      Value<String?> instructions,
      Value<String?> personalNotes,
      Value<String> aliasesJson,
      Value<String> searchKeywordsJson,
      Value<bool> isFavourite,
      Value<DateTime?> lastUsedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CustomExercisesTableUpdateCompanionBuilder =
    CustomExercisesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String> primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      Value<String> equipment,
      Value<String?> instructions,
      Value<String?> personalNotes,
      Value<String> aliasesJson,
      Value<String> searchKeywordsJson,
      Value<bool> isFavourite,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CustomExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomExercisesTable,
          CustomExerciseRow
        > {
  $$CustomExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExerciseRow>>
  _templateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.templateExercises,
        aliasName:
            'custom_exercises__id__template_exercises__custom_exercise_id',
      );

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager =
        $$TemplateExercisesTableTableManager(
          $_db,
          $_db.templateExercises,
        ).filter(
          (f) => f.customExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _templateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalNotes => $composableBuilder(
    column: $table.personalNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aliasesJson => $composableBuilder(
    column: $table.aliasesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchKeywordsJson => $composableBuilder(
    column: $table.searchKeywordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> templateExercisesRefs(
    Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f,
  ) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateExercises,
      getReferencedColumn: (t) => t.customExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateExercisesTableFilterComposer(
            $db: $db,
            $table: $db.templateExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalNotes => $composableBuilder(
    column: $table.personalNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliasesJson => $composableBuilder(
    column: $table.aliasesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchKeywordsJson => $composableBuilder(
    column: $table.searchKeywordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomExercisesTable> {
  $$CustomExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
    column: $table.instructions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalNotes => $composableBuilder(
    column: $table.personalNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aliasesJson => $composableBuilder(
    column: $table.aliasesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get searchKeywordsJson => $composableBuilder(
    column: $table.searchKeywordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> templateExercisesRefs<T extends Object>(
    Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f,
  ) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.templateExercises,
          getReferencedColumn: (t) => t.customExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.templateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CustomExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomExercisesTable,
          CustomExerciseRow,
          $$CustomExercisesTableFilterComposer,
          $$CustomExercisesTableOrderingComposer,
          $$CustomExercisesTableAnnotationComposer,
          $$CustomExercisesTableCreateCompanionBuilder,
          $$CustomExercisesTableUpdateCompanionBuilder,
          (CustomExerciseRow, $$CustomExercisesTableReferences),
          CustomExerciseRow,
          PrefetchHooks Function({bool templateExercisesRefs})
        > {
  $$CustomExercisesTableTableManager(
    _$AppDatabase db,
    $CustomExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> primaryMuscleGroup = const Value.absent(),
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String?> instructions = const Value.absent(),
                Value<String?> personalNotes = const Value.absent(),
                Value<String> aliasesJson = const Value.absent(),
                Value<String> searchKeywordsJson = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion(
                id: id,
                userId: userId,
                name: name,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                instructions: instructions,
                personalNotes: personalNotes,
                aliasesJson: aliasesJson,
                searchKeywordsJson: searchKeywordsJson,
                isFavourite: isFavourite,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String primaryMuscleGroup,
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                required String equipment,
                Value<String?> instructions = const Value.absent(),
                Value<String?> personalNotes = const Value.absent(),
                Value<String> aliasesJson = const Value.absent(),
                Value<String> searchKeywordsJson = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomExercisesCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                instructions: instructions,
                personalNotes: personalNotes,
                aliasesJson: aliasesJson,
                searchKeywordsJson: searchKeywordsJson,
                isFavourite: isFavourite,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateExercisesRefs) db.templateExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateExercisesRefs)
                    await $_getPrefetchedData<
                      CustomExerciseRow,
                      $CustomExercisesTable,
                      TemplateExerciseRow
                    >(
                      currentTable: table,
                      referencedTable: $$CustomExercisesTableReferences
                          ._templateExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).templateExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.customExerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomExercisesTable,
      CustomExerciseRow,
      $$CustomExercisesTableFilterComposer,
      $$CustomExercisesTableOrderingComposer,
      $$CustomExercisesTableAnnotationComposer,
      $$CustomExercisesTableCreateCompanionBuilder,
      $$CustomExercisesTableUpdateCompanionBuilder,
      (CustomExerciseRow, $$CustomExercisesTableReferences),
      CustomExerciseRow,
      PrefetchHooks Function({bool templateExercisesRefs})
    >;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      required String id,
      required String userId,
      Value<String?> splitId,
      required String name,
      required String icon,
      required int colorValue,
      Value<String?> notes,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> splitId,
      Value<String> name,
      Value<String> icon,
      Value<int> colorValue,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$WorkoutTemplatesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutTemplatesTable,
          WorkoutTemplateRow
        > {
  $$WorkoutTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSplitsTable _splitIdTable(_$AppDatabase db) => db.workoutSplits
      .createAlias('workout_templates__split_id__workout_splits__id');

  $$WorkoutSplitsTableProcessedTableManager? get splitId {
    final $_column = $_itemColumn<String>('split_id');
    if ($_column == null) return null;
    final manager = $$WorkoutSplitsTableTableManager(
      $_db,
      $_db.workoutSplits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_splitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TemplateExercisesTable, List<TemplateExerciseRow>>
  _templateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.templateExercises,
        aliasName: 'workout_templates__id__template_exercises__template_id',
      );

  $$TemplateExercisesTableProcessedTableManager get templateExercisesRefs {
    final manager = $$TemplateExercisesTableTableManager(
      $_db,
      $_db.templateExercises,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _templateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSplitsTableFilterComposer get splitId {
    final $$WorkoutSplitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.workoutSplits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSplitsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> templateExercisesRefs(
    Expression<bool> Function($$TemplateExercisesTableFilterComposer f) f,
  ) {
    final $$TemplateExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateExercises,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateExercisesTableFilterComposer(
            $db: $db,
            $table: $db.templateExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSplitsTableOrderingComposer get splitId {
    final $$WorkoutSplitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.workoutSplits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSplitsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$WorkoutSplitsTableAnnotationComposer get splitId {
    final $$WorkoutSplitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.splitId,
      referencedTable: $db.workoutSplits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSplitsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSplits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> templateExercisesRefs<T extends Object>(
    Expression<T> Function($$TemplateExercisesTableAnnotationComposer a) f,
  ) {
    final $$TemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.templateExercises,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.templateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplatesTable,
          WorkoutTemplateRow,
          $$WorkoutTemplatesTableFilterComposer,
          $$WorkoutTemplatesTableOrderingComposer,
          $$WorkoutTemplatesTableAnnotationComposer,
          $$WorkoutTemplatesTableCreateCompanionBuilder,
          $$WorkoutTemplatesTableUpdateCompanionBuilder,
          (WorkoutTemplateRow, $$WorkoutTemplatesTableReferences),
          WorkoutTemplateRow,
          PrefetchHooks Function({bool splitId, bool templateExercisesRefs})
        > {
  $$WorkoutTemplatesTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> splitId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion(
                id: id,
                userId: userId,
                splitId: splitId,
                name: name,
                icon: icon,
                colorValue: colorValue,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> splitId = const Value.absent(),
                required String name,
                required String icon,
                required int colorValue,
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion.insert(
                id: id,
                userId: userId,
                splitId: splitId,
                name: name,
                icon: icon,
                colorValue: colorValue,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({splitId = false, templateExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (templateExercisesRefs) db.templateExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (splitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.splitId,
                                    referencedTable:
                                        $$WorkoutTemplatesTableReferences
                                            ._splitIdTable(db),
                                    referencedColumn:
                                        $$WorkoutTemplatesTableReferences
                                            ._splitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (templateExercisesRefs)
                        await $_getPrefetchedData<
                          WorkoutTemplateRow,
                          $WorkoutTemplatesTable,
                          TemplateExerciseRow
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutTemplatesTableReferences
                              ._templateExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutTemplatesTableReferences(
                                db,
                                table,
                                p0,
                              ).templateExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.templateId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplatesTable,
      WorkoutTemplateRow,
      $$WorkoutTemplatesTableFilterComposer,
      $$WorkoutTemplatesTableOrderingComposer,
      $$WorkoutTemplatesTableAnnotationComposer,
      $$WorkoutTemplatesTableCreateCompanionBuilder,
      $$WorkoutTemplatesTableUpdateCompanionBuilder,
      (WorkoutTemplateRow, $$WorkoutTemplatesTableReferences),
      WorkoutTemplateRow,
      PrefetchHooks Function({bool splitId, bool templateExercisesRefs})
    >;
typedef $$TemplateExercisesTableCreateCompanionBuilder =
    TemplateExercisesCompanion Function({
      required String id,
      required String userId,
      required String templateId,
      Value<String?> customExerciseId,
      Value<String?> systemExerciseKey,
      required String exerciseName,
      required String primaryMuscleGroup,
      required String equipment,
      Value<int> workingSets,
      Value<int> warmupSets,
      Value<int> targetRepsMin,
      Value<int> targetRepsMax,
      Value<double?> targetWeight,
      Value<int> restSeconds,
      Value<double?> rpeTarget,
      Value<double?> rirTarget,
      Value<String?> notes,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$TemplateExercisesTableUpdateCompanionBuilder =
    TemplateExercisesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> templateId,
      Value<String?> customExerciseId,
      Value<String?> systemExerciseKey,
      Value<String> exerciseName,
      Value<String> primaryMuscleGroup,
      Value<String> equipment,
      Value<int> workingSets,
      Value<int> warmupSets,
      Value<int> targetRepsMin,
      Value<int> targetRepsMax,
      Value<double?> targetWeight,
      Value<int> restSeconds,
      Value<double?> rpeTarget,
      Value<double?> rirTarget,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$TemplateExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExerciseRow
        > {
  $$TemplateExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .workoutTemplates
      .createAlias('template_exercises__template_id__workout_templates__id');

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomExercisesTable _customExerciseIdTable(_$AppDatabase db) =>
      db.customExercises.createAlias(
        'template_exercises__custom_exercise_id__custom_exercises__id',
      );

  $$CustomExercisesTableProcessedTableManager? get customExerciseId {
    final $_column = $_itemColumn<String>('custom_exercise_id');
    if ($_column == null) return null;
    final manager = $$CustomExercisesTableTableManager(
      $_db,
      $_db.customExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplateExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workingSets => $composableBuilder(
    column: $table.workingSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpeTarget => $composableBuilder(
    column: $table.rpeTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rirTarget => $composableBuilder(
    column: $table.rirTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomExercisesTableFilterComposer get customExerciseId {
    final $$CustomExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customExerciseId,
      referencedTable: $db.customExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomExercisesTableFilterComposer(
            $db: $db,
            $table: $db.customExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workingSets => $composableBuilder(
    column: $table.workingSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpeTarget => $composableBuilder(
    column: $table.rpeTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rirTarget => $composableBuilder(
    column: $table.rirTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomExercisesTableOrderingComposer get customExerciseId {
    final $$CustomExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customExerciseId,
      referencedTable: $db.customExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.customExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateExercisesTable> {
  $$TemplateExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<int> get workingSets => $composableBuilder(
    column: $table.workingSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsMin => $composableBuilder(
    column: $table.targetRepsMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetRepsMax => $composableBuilder(
    column: $table.targetRepsMax,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeight => $composableBuilder(
    column: $table.targetWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpeTarget =>
      $composableBuilder(column: $table.rpeTarget, builder: (column) => column);

  GeneratedColumn<double> get rirTarget =>
      $composableBuilder(column: $table.rirTarget, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomExercisesTableAnnotationComposer get customExerciseId {
    final $$CustomExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customExerciseId,
      referencedTable: $db.customExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.customExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateExercisesTable,
          TemplateExerciseRow,
          $$TemplateExercisesTableFilterComposer,
          $$TemplateExercisesTableOrderingComposer,
          $$TemplateExercisesTableAnnotationComposer,
          $$TemplateExercisesTableCreateCompanionBuilder,
          $$TemplateExercisesTableUpdateCompanionBuilder,
          (TemplateExerciseRow, $$TemplateExercisesTableReferences),
          TemplateExerciseRow,
          PrefetchHooks Function({bool templateId, bool customExerciseId})
        > {
  $$TemplateExercisesTableTableManager(
    _$AppDatabase db,
    $TemplateExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> primaryMuscleGroup = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<int> workingSets = const Value.absent(),
                Value<int> warmupSets = const Value.absent(),
                Value<int> targetRepsMin = const Value.absent(),
                Value<int> targetRepsMax = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double?> rpeTarget = const Value.absent(),
                Value<double?> rirTarget = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateExercisesCompanion(
                id: id,
                userId: userId,
                templateId: templateId,
                customExerciseId: customExerciseId,
                systemExerciseKey: systemExerciseKey,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                equipment: equipment,
                workingSets: workingSets,
                warmupSets: warmupSets,
                targetRepsMin: targetRepsMin,
                targetRepsMax: targetRepsMax,
                targetWeight: targetWeight,
                restSeconds: restSeconds,
                rpeTarget: rpeTarget,
                rirTarget: rirTarget,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String templateId,
                Value<String?> customExerciseId = const Value.absent(),
                Value<String?> systemExerciseKey = const Value.absent(),
                required String exerciseName,
                required String primaryMuscleGroup,
                required String equipment,
                Value<int> workingSets = const Value.absent(),
                Value<int> warmupSets = const Value.absent(),
                Value<int> targetRepsMin = const Value.absent(),
                Value<int> targetRepsMax = const Value.absent(),
                Value<double?> targetWeight = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double?> rpeTarget = const Value.absent(),
                Value<double?> rirTarget = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TemplateExercisesCompanion.insert(
                id: id,
                userId: userId,
                templateId: templateId,
                customExerciseId: customExerciseId,
                systemExerciseKey: systemExerciseKey,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                equipment: equipment,
                workingSets: workingSets,
                warmupSets: warmupSets,
                targetRepsMin: targetRepsMin,
                targetRepsMax: targetRepsMax,
                targetWeight: targetWeight,
                restSeconds: restSeconds,
                rpeTarget: rpeTarget,
                rirTarget: rirTarget,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplateExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({templateId = false, customExerciseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (templateId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.templateId,
                                    referencedTable:
                                        $$TemplateExercisesTableReferences
                                            ._templateIdTable(db),
                                    referencedColumn:
                                        $$TemplateExercisesTableReferences
                                            ._templateIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (customExerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customExerciseId,
                                    referencedTable:
                                        $$TemplateExercisesTableReferences
                                            ._customExerciseIdTable(db),
                                    referencedColumn:
                                        $$TemplateExercisesTableReferences
                                            ._customExerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TemplateExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateExercisesTable,
      TemplateExerciseRow,
      $$TemplateExercisesTableFilterComposer,
      $$TemplateExercisesTableOrderingComposer,
      $$TemplateExercisesTableAnnotationComposer,
      $$TemplateExercisesTableCreateCompanionBuilder,
      $$TemplateExercisesTableUpdateCompanionBuilder,
      (TemplateExerciseRow, $$TemplateExercisesTableReferences),
      TemplateExerciseRow,
      PrefetchHooks Function({bool templateId, bool customExerciseId})
    >;
typedef $$PlannerSyncQueueTableCreateCompanionBuilder =
    PlannerSyncQueueCompanion Function({
      required String id,
      required String userId,
      required String entityType,
      required String entityId,
      required int entityVersion,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlannerSyncQueueTableUpdateCompanionBuilder =
    PlannerSyncQueueCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> entityType,
      Value<String> entityId,
      Value<int> entityVersion,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PlannerSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $PlannerSyncQueueTable> {
  $$PlannerSyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlannerSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $PlannerSyncQueueTable> {
  $$PlannerSyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlannerSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlannerSyncQueueTable> {
  $$PlannerSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlannerSyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlannerSyncQueueTable,
          PlannerSyncQueueRow,
          $$PlannerSyncQueueTableFilterComposer,
          $$PlannerSyncQueueTableOrderingComposer,
          $$PlannerSyncQueueTableAnnotationComposer,
          $$PlannerSyncQueueTableCreateCompanionBuilder,
          $$PlannerSyncQueueTableUpdateCompanionBuilder,
          (
            PlannerSyncQueueRow,
            BaseReferences<
              _$AppDatabase,
              $PlannerSyncQueueTable,
              PlannerSyncQueueRow
            >,
          ),
          PlannerSyncQueueRow,
          PrefetchHooks Function()
        > {
  $$PlannerSyncQueueTableTableManager(
    _$AppDatabase db,
    $PlannerSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlannerSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlannerSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlannerSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> entityVersion = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannerSyncQueueCompanion(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                entityVersion: entityVersion,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String entityType,
                required String entityId,
                required int entityVersion,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlannerSyncQueueCompanion.insert(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                entityVersion: entityVersion,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlannerSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlannerSyncQueueTable,
      PlannerSyncQueueRow,
      $$PlannerSyncQueueTableFilterComposer,
      $$PlannerSyncQueueTableOrderingComposer,
      $$PlannerSyncQueueTableAnnotationComposer,
      $$PlannerSyncQueueTableCreateCompanionBuilder,
      $$PlannerSyncQueueTableUpdateCompanionBuilder,
      (
        PlannerSyncQueueRow,
        BaseReferences<
          _$AppDatabase,
          $PlannerSyncQueueTable,
          PlannerSyncQueueRow
        >,
      ),
      PlannerSyncQueueRow,
      PrefetchHooks Function()
    >;
typedef $$ActiveWorkoutSessionsTableCreateCompanionBuilder =
    ActiveWorkoutSessionsCompanion Function({
      required String id,
      required String userId,
      required String name,
      Value<String?> sourceTemplateId,
      required DateTime startedAt,
      Value<String?> notes,
      Value<String> weightUnit,
      Value<String> restTimerState,
      Value<int> restTimerDurationSeconds,
      Value<DateTime?> restTimerTargetEndAt,
      Value<int> restTimerRemainingSeconds,
      Value<bool> autoStartRestTimer,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$ActiveWorkoutSessionsTableUpdateCompanionBuilder =
    ActiveWorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<String?> sourceTemplateId,
      Value<DateTime> startedAt,
      Value<String?> notes,
      Value<String> weightUnit,
      Value<String> restTimerState,
      Value<int> restTimerDurationSeconds,
      Value<DateTime?> restTimerTargetEndAt,
      Value<int> restTimerRemainingSeconds,
      Value<bool> autoStartRestTimer,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$ActiveWorkoutSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActiveWorkoutSessionsTable,
          ActiveWorkoutSessionRow
        > {
  $$ActiveWorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $ActiveWorkoutExercisesTable,
    List<ActiveWorkoutExerciseRow>
  >
  _activeWorkoutExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activeWorkoutExercises,
        aliasName:
            'active_workout_sessions__id__active_workout_exercises__session_id',
      );

  $$ActiveWorkoutExercisesTableProcessedTableManager
  get activeWorkoutExercisesRefs {
    final manager = $$ActiveWorkoutExercisesTableTableManager(
      $_db,
      $_db.activeWorkoutExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activeWorkoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActiveWorkoutSetsTable, List<ActiveWorkoutSetRow>>
  _activeWorkoutSetsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activeWorkoutSets,
        aliasName:
            'active_workout_sessions__id__active_workout_sets__session_id',
      );

  $$ActiveWorkoutSetsTableProcessedTableManager get activeWorkoutSetsRefs {
    final manager = $$ActiveWorkoutSetsTableTableManager(
      $_db,
      $_db.activeWorkoutSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activeWorkoutSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActiveWorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSessionsTable> {
  $$ActiveWorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get restTimerState => $composableBuilder(
    column: $table.restTimerState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restTimerDurationSeconds => $composableBuilder(
    column: $table.restTimerDurationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restTimerTargetEndAt => $composableBuilder(
    column: $table.restTimerTargetEndAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restTimerRemainingSeconds => $composableBuilder(
    column: $table.restTimerRemainingSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoStartRestTimer => $composableBuilder(
    column: $table.autoStartRestTimer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> activeWorkoutExercisesRefs(
    Expression<bool> Function($$ActiveWorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$ActiveWorkoutExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activeWorkoutExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutExercisesTableFilterComposer(
                $db: $db,
                $table: $db.activeWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> activeWorkoutSetsRefs(
    Expression<bool> Function($$ActiveWorkoutSetsTableFilterComposer f) f,
  ) {
    final $$ActiveWorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeWorkoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveWorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.activeWorkoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActiveWorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSessionsTable> {
  $$ActiveWorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get restTimerState => $composableBuilder(
    column: $table.restTimerState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restTimerDurationSeconds => $composableBuilder(
    column: $table.restTimerDurationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restTimerTargetEndAt => $composableBuilder(
    column: $table.restTimerTargetEndAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restTimerRemainingSeconds => $composableBuilder(
    column: $table.restTimerRemainingSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoStartRestTimer => $composableBuilder(
    column: $table.autoStartRestTimer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActiveWorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSessionsTable> {
  $$ActiveWorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get restTimerState => $composableBuilder(
    column: $table.restTimerState,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restTimerDurationSeconds => $composableBuilder(
    column: $table.restTimerDurationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get restTimerTargetEndAt => $composableBuilder(
    column: $table.restTimerTargetEndAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restTimerRemainingSeconds => $composableBuilder(
    column: $table.restTimerRemainingSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoStartRestTimer => $composableBuilder(
    column: $table.autoStartRestTimer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> activeWorkoutExercisesRefs<T extends Object>(
    Expression<T> Function($$ActiveWorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$ActiveWorkoutExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activeWorkoutExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> activeWorkoutSetsRefs<T extends Object>(
    Expression<T> Function($$ActiveWorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$ActiveWorkoutSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activeWorkoutSets,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActiveWorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveWorkoutSessionsTable,
          ActiveWorkoutSessionRow,
          $$ActiveWorkoutSessionsTableFilterComposer,
          $$ActiveWorkoutSessionsTableOrderingComposer,
          $$ActiveWorkoutSessionsTableAnnotationComposer,
          $$ActiveWorkoutSessionsTableCreateCompanionBuilder,
          $$ActiveWorkoutSessionsTableUpdateCompanionBuilder,
          (ActiveWorkoutSessionRow, $$ActiveWorkoutSessionsTableReferences),
          ActiveWorkoutSessionRow,
          PrefetchHooks Function({
            bool activeWorkoutExercisesRefs,
            bool activeWorkoutSetsRefs,
          })
        > {
  $$ActiveWorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $ActiveWorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveWorkoutSessionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveWorkoutSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveWorkoutSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> sourceTemplateId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<String> restTimerState = const Value.absent(),
                Value<int> restTimerDurationSeconds = const Value.absent(),
                Value<DateTime?> restTimerTargetEndAt = const Value.absent(),
                Value<int> restTimerRemainingSeconds = const Value.absent(),
                Value<bool> autoStartRestTimer = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSessionsCompanion(
                id: id,
                userId: userId,
                name: name,
                sourceTemplateId: sourceTemplateId,
                startedAt: startedAt,
                notes: notes,
                weightUnit: weightUnit,
                restTimerState: restTimerState,
                restTimerDurationSeconds: restTimerDurationSeconds,
                restTimerTargetEndAt: restTimerTargetEndAt,
                restTimerRemainingSeconds: restTimerRemainingSeconds,
                autoStartRestTimer: autoStartRestTimer,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                Value<String?> sourceTemplateId = const Value.absent(),
                required DateTime startedAt,
                Value<String?> notes = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<String> restTimerState = const Value.absent(),
                Value<int> restTimerDurationSeconds = const Value.absent(),
                Value<DateTime?> restTimerTargetEndAt = const Value.absent(),
                Value<int> restTimerRemainingSeconds = const Value.absent(),
                Value<bool> autoStartRestTimer = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSessionsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                sourceTemplateId: sourceTemplateId,
                startedAt: startedAt,
                notes: notes,
                weightUnit: weightUnit,
                restTimerState: restTimerState,
                restTimerDurationSeconds: restTimerDurationSeconds,
                restTimerTargetEndAt: restTimerTargetEndAt,
                restTimerRemainingSeconds: restTimerRemainingSeconds,
                autoStartRestTimer: autoStartRestTimer,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveWorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activeWorkoutExercisesRefs = false,
                activeWorkoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activeWorkoutExercisesRefs) db.activeWorkoutExercises,
                    if (activeWorkoutSetsRefs) db.activeWorkoutSets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activeWorkoutExercisesRefs)
                        await $_getPrefetchedData<
                          ActiveWorkoutSessionRow,
                          $ActiveWorkoutSessionsTable,
                          ActiveWorkoutExerciseRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ActiveWorkoutSessionsTableReferences
                                  ._activeWorkoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActiveWorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).activeWorkoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activeWorkoutSetsRefs)
                        await $_getPrefetchedData<
                          ActiveWorkoutSessionRow,
                          $ActiveWorkoutSessionsTable,
                          ActiveWorkoutSetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ActiveWorkoutSessionsTableReferences
                                  ._activeWorkoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActiveWorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).activeWorkoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActiveWorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveWorkoutSessionsTable,
      ActiveWorkoutSessionRow,
      $$ActiveWorkoutSessionsTableFilterComposer,
      $$ActiveWorkoutSessionsTableOrderingComposer,
      $$ActiveWorkoutSessionsTableAnnotationComposer,
      $$ActiveWorkoutSessionsTableCreateCompanionBuilder,
      $$ActiveWorkoutSessionsTableUpdateCompanionBuilder,
      (ActiveWorkoutSessionRow, $$ActiveWorkoutSessionsTableReferences),
      ActiveWorkoutSessionRow,
      PrefetchHooks Function({
        bool activeWorkoutExercisesRefs,
        bool activeWorkoutSetsRefs,
      })
    >;
typedef $$ActiveWorkoutExercisesTableCreateCompanionBuilder =
    ActiveWorkoutExercisesCompanion Function({
      required String id,
      required String userId,
      required String sessionId,
      required String exerciseSource,
      required String exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      required String exerciseName,
      required String primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      required String equipment,
      required String trackingType,
      required bool weightRelevant,
      required bool repetitionsRelevant,
      required bool distanceRelevant,
      required bool durationRelevant,
      required bool bodyweightRelevant,
      required int plannedWorkingSets,
      required int plannedWarmupSets,
      required int minTargetReps,
      required int maxTargetReps,
      Value<double?> targetWeightKg,
      required int restSeconds,
      Value<double?> rpeTarget,
      Value<double?> rirTarget,
      Value<String?> notes,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$ActiveWorkoutExercisesTableUpdateCompanionBuilder =
    ActiveWorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sessionId,
      Value<String> exerciseSource,
      Value<String> exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      Value<String> exerciseName,
      Value<String> primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      Value<String> equipment,
      Value<String> trackingType,
      Value<bool> weightRelevant,
      Value<bool> repetitionsRelevant,
      Value<bool> distanceRelevant,
      Value<bool> durationRelevant,
      Value<bool> bodyweightRelevant,
      Value<int> plannedWorkingSets,
      Value<int> plannedWarmupSets,
      Value<int> minTargetReps,
      Value<int> maxTargetReps,
      Value<double?> targetWeightKg,
      Value<int> restSeconds,
      Value<double?> rpeTarget,
      Value<double?> rirTarget,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$ActiveWorkoutExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActiveWorkoutExercisesTable,
          ActiveWorkoutExerciseRow
        > {
  $$ActiveWorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActiveWorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.activeWorkoutSessions.createAlias(
        'active_workout_exercises__session_id__active_workout_sessions__id',
      );

  $$ActiveWorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$ActiveWorkoutSessionsTableTableManager(
      $_db,
      $_db.activeWorkoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ActiveWorkoutSetsTable, List<ActiveWorkoutSetRow>>
  _activeWorkoutSetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.activeWorkoutSets,
    aliasName:
        'active_workout_exercises__id__active_workout_sets__session_exercise_id',
  );

  $$ActiveWorkoutSetsTableProcessedTableManager get activeWorkoutSetsRefs {
    final manager =
        $$ActiveWorkoutSetsTableTableManager(
          $_db,
          $_db.activeWorkoutSets,
        ).filter(
          (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _activeWorkoutSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActiveWorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutExercisesTable> {
  $$ActiveWorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedWorkingSets => $composableBuilder(
    column: $table.plannedWorkingSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedWarmupSets => $composableBuilder(
    column: $table.plannedWarmupSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minTargetReps => $composableBuilder(
    column: $table.minTargetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxTargetReps => $composableBuilder(
    column: $table.maxTargetReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpeTarget => $composableBuilder(
    column: $table.rpeTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rirTarget => $composableBuilder(
    column: $table.rirTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$ActiveWorkoutSessionsTableFilterComposer get sessionId {
    final $$ActiveWorkoutSessionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableFilterComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> activeWorkoutSetsRefs(
    Expression<bool> Function($$ActiveWorkoutSetsTableFilterComposer f) f,
  ) {
    final $$ActiveWorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activeWorkoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActiveWorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.activeWorkoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActiveWorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutExercisesTable> {
  $$ActiveWorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedWorkingSets => $composableBuilder(
    column: $table.plannedWorkingSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedWarmupSets => $composableBuilder(
    column: $table.plannedWarmupSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minTargetReps => $composableBuilder(
    column: $table.minTargetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxTargetReps => $composableBuilder(
    column: $table.maxTargetReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpeTarget => $composableBuilder(
    column: $table.rpeTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rirTarget => $composableBuilder(
    column: $table.rirTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActiveWorkoutSessionsTableOrderingComposer get sessionId {
    final $$ActiveWorkoutSessionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableOrderingComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ActiveWorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutExercisesTable> {
  $$ActiveWorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedWorkingSets => $composableBuilder(
    column: $table.plannedWorkingSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedWarmupSets => $composableBuilder(
    column: $table.plannedWarmupSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minTargetReps => $composableBuilder(
    column: $table.minTargetReps,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxTargetReps => $composableBuilder(
    column: $table.maxTargetReps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpeTarget =>
      $composableBuilder(column: $table.rpeTarget, builder: (column) => column);

  GeneratedColumn<double> get rirTarget =>
      $composableBuilder(column: $table.rirTarget, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$ActiveWorkoutSessionsTableAnnotationComposer get sessionId {
    final $$ActiveWorkoutSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> activeWorkoutSetsRefs<T extends Object>(
    Expression<T> Function($$ActiveWorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$ActiveWorkoutSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activeWorkoutSets,
          getReferencedColumn: (t) => t.sessionExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActiveWorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveWorkoutExercisesTable,
          ActiveWorkoutExerciseRow,
          $$ActiveWorkoutExercisesTableFilterComposer,
          $$ActiveWorkoutExercisesTableOrderingComposer,
          $$ActiveWorkoutExercisesTableAnnotationComposer,
          $$ActiveWorkoutExercisesTableCreateCompanionBuilder,
          $$ActiveWorkoutExercisesTableUpdateCompanionBuilder,
          (ActiveWorkoutExerciseRow, $$ActiveWorkoutExercisesTableReferences),
          ActiveWorkoutExerciseRow,
          PrefetchHooks Function({bool sessionId, bool activeWorkoutSetsRefs})
        > {
  $$ActiveWorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $ActiveWorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveWorkoutExercisesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActiveWorkoutExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActiveWorkoutExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseKey = const Value.absent(),
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> primaryMuscleGroup = const Value.absent(),
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> trackingType = const Value.absent(),
                Value<bool> weightRelevant = const Value.absent(),
                Value<bool> repetitionsRelevant = const Value.absent(),
                Value<bool> distanceRelevant = const Value.absent(),
                Value<bool> durationRelevant = const Value.absent(),
                Value<bool> bodyweightRelevant = const Value.absent(),
                Value<int> plannedWorkingSets = const Value.absent(),
                Value<int> plannedWarmupSets = const Value.absent(),
                Value<int> minTargetReps = const Value.absent(),
                Value<int> maxTargetReps = const Value.absent(),
                Value<double?> targetWeightKg = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double?> rpeTarget = const Value.absent(),
                Value<double?> rirTarget = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutExercisesCompanion(
                id: id,
                userId: userId,
                sessionId: sessionId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                trackingType: trackingType,
                weightRelevant: weightRelevant,
                repetitionsRelevant: repetitionsRelevant,
                distanceRelevant: distanceRelevant,
                durationRelevant: durationRelevant,
                bodyweightRelevant: bodyweightRelevant,
                plannedWorkingSets: plannedWorkingSets,
                plannedWarmupSets: plannedWarmupSets,
                minTargetReps: minTargetReps,
                maxTargetReps: maxTargetReps,
                targetWeightKg: targetWeightKg,
                restSeconds: restSeconds,
                rpeTarget: rpeTarget,
                rirTarget: rirTarget,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sessionId,
                required String exerciseSource,
                required String exerciseKey,
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                required String exerciseName,
                required String primaryMuscleGroup,
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                required String equipment,
                required String trackingType,
                required bool weightRelevant,
                required bool repetitionsRelevant,
                required bool distanceRelevant,
                required bool durationRelevant,
                required bool bodyweightRelevant,
                required int plannedWorkingSets,
                required int plannedWarmupSets,
                required int minTargetReps,
                required int maxTargetReps,
                Value<double?> targetWeightKg = const Value.absent(),
                required int restSeconds,
                Value<double?> rpeTarget = const Value.absent(),
                Value<double?> rirTarget = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutExercisesCompanion.insert(
                id: id,
                userId: userId,
                sessionId: sessionId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                trackingType: trackingType,
                weightRelevant: weightRelevant,
                repetitionsRelevant: repetitionsRelevant,
                distanceRelevant: distanceRelevant,
                durationRelevant: durationRelevant,
                bodyweightRelevant: bodyweightRelevant,
                plannedWorkingSets: plannedWorkingSets,
                plannedWarmupSets: plannedWarmupSets,
                minTargetReps: minTargetReps,
                maxTargetReps: maxTargetReps,
                targetWeightKg: targetWeightKg,
                restSeconds: restSeconds,
                rpeTarget: rpeTarget,
                rirTarget: rirTarget,
                notes: notes,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveWorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, activeWorkoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activeWorkoutSetsRefs) db.activeWorkoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$ActiveWorkoutExercisesTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$ActiveWorkoutExercisesTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activeWorkoutSetsRefs)
                        await $_getPrefetchedData<
                          ActiveWorkoutExerciseRow,
                          $ActiveWorkoutExercisesTable,
                          ActiveWorkoutSetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$ActiveWorkoutExercisesTableReferences
                                  ._activeWorkoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActiveWorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).activeWorkoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActiveWorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveWorkoutExercisesTable,
      ActiveWorkoutExerciseRow,
      $$ActiveWorkoutExercisesTableFilterComposer,
      $$ActiveWorkoutExercisesTableOrderingComposer,
      $$ActiveWorkoutExercisesTableAnnotationComposer,
      $$ActiveWorkoutExercisesTableCreateCompanionBuilder,
      $$ActiveWorkoutExercisesTableUpdateCompanionBuilder,
      (ActiveWorkoutExerciseRow, $$ActiveWorkoutExercisesTableReferences),
      ActiveWorkoutExerciseRow,
      PrefetchHooks Function({bool sessionId, bool activeWorkoutSetsRefs})
    >;
typedef $$ActiveWorkoutSetsTableCreateCompanionBuilder =
    ActiveWorkoutSetsCompanion Function({
      required String id,
      required String userId,
      required String sessionId,
      required String sessionExerciseId,
      required String setType,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<double?> rpe,
      Value<double?> rir,
      Value<bool> isCompleted,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$ActiveWorkoutSetsTableUpdateCompanionBuilder =
    ActiveWorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sessionId,
      Value<String> sessionExerciseId,
      Value<String> setType,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<double?> rpe,
      Value<double?> rir,
      Value<bool> isCompleted,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$ActiveWorkoutSetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActiveWorkoutSetsTable,
          ActiveWorkoutSetRow
        > {
  $$ActiveWorkoutSetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActiveWorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.activeWorkoutSessions.createAlias(
        'active_workout_sets__session_id__active_workout_sessions__id',
      );

  $$ActiveWorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$ActiveWorkoutSessionsTableTableManager(
      $_db,
      $_db.activeWorkoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActiveWorkoutExercisesTable _sessionExerciseIdTable(
    _$AppDatabase db,
  ) => db.activeWorkoutExercises.createAlias(
    'active_workout_sets__session_exercise_id__active_workout_exercises__id',
  );

  $$ActiveWorkoutExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<String>('session_exercise_id')!;

    final manager = $$ActiveWorkoutExercisesTableTableManager(
      $_db,
      $_db.activeWorkoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActiveWorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSetsTable> {
  $$ActiveWorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$ActiveWorkoutSessionsTableFilterComposer get sessionId {
    final $$ActiveWorkoutSessionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableFilterComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ActiveWorkoutExercisesTableFilterComposer get sessionExerciseId {
    final $$ActiveWorkoutExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.activeWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutExercisesTableFilterComposer(
                $db: $db,
                $table: $db.activeWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ActiveWorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSetsTable> {
  $$ActiveWorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActiveWorkoutSessionsTableOrderingComposer get sessionId {
    final $$ActiveWorkoutSessionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableOrderingComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ActiveWorkoutExercisesTableOrderingComposer get sessionExerciseId {
    final $$ActiveWorkoutExercisesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.activeWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutExercisesTableOrderingComposer(
                $db: $db,
                $table: $db.activeWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ActiveWorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActiveWorkoutSetsTable> {
  $$ActiveWorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<double> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$ActiveWorkoutSessionsTableAnnotationComposer get sessionId {
    final $$ActiveWorkoutSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.activeWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$ActiveWorkoutExercisesTableAnnotationComposer get sessionExerciseId {
    final $$ActiveWorkoutExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.activeWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActiveWorkoutExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.activeWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ActiveWorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActiveWorkoutSetsTable,
          ActiveWorkoutSetRow,
          $$ActiveWorkoutSetsTableFilterComposer,
          $$ActiveWorkoutSetsTableOrderingComposer,
          $$ActiveWorkoutSetsTableAnnotationComposer,
          $$ActiveWorkoutSetsTableCreateCompanionBuilder,
          $$ActiveWorkoutSetsTableUpdateCompanionBuilder,
          (ActiveWorkoutSetRow, $$ActiveWorkoutSetsTableReferences),
          ActiveWorkoutSetRow,
          PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
        > {
  $$ActiveWorkoutSetsTableTableManager(
    _$AppDatabase db,
    $ActiveWorkoutSetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActiveWorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActiveWorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActiveWorkoutSetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> sessionExerciseId = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSetsCompanion(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                setType: setType,
                weightKg: weightKg,
                repetitions: repetitions,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rpe: rpe,
                rir: rir,
                isCompleted: isCompleted,
                notes: notes,
                sortOrder: sortOrder,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sessionId,
                required String sessionExerciseId,
                required String setType,
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActiveWorkoutSetsCompanion.insert(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                setType: setType,
                weightKg: weightKg,
                repetitions: repetitions,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rpe: rpe,
                rir: rir,
                isCompleted: isCompleted,
                notes: notes,
                sortOrder: sortOrder,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActiveWorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, sessionExerciseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$ActiveWorkoutSetsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$ActiveWorkoutSetsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sessionExerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionExerciseId,
                                    referencedTable:
                                        $$ActiveWorkoutSetsTableReferences
                                            ._sessionExerciseIdTable(db),
                                    referencedColumn:
                                        $$ActiveWorkoutSetsTableReferences
                                            ._sessionExerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ActiveWorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActiveWorkoutSetsTable,
      ActiveWorkoutSetRow,
      $$ActiveWorkoutSetsTableFilterComposer,
      $$ActiveWorkoutSetsTableOrderingComposer,
      $$ActiveWorkoutSetsTableAnnotationComposer,
      $$ActiveWorkoutSetsTableCreateCompanionBuilder,
      $$ActiveWorkoutSetsTableUpdateCompanionBuilder,
      (ActiveWorkoutSetRow, $$ActiveWorkoutSetsTableReferences),
      ActiveWorkoutSetRow,
      PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
    >;
typedef $$CompletedWorkoutSessionsTableCreateCompanionBuilder =
    CompletedWorkoutSessionsCompanion Function({
      required String id,
      required String userId,
      Value<String?> sourceActiveSessionId,
      Value<String?> sourceTemplateId,
      required String name,
      Value<String?> notes,
      Value<String> weightUnit,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationSeconds,
      required int exerciseCount,
      required int workingSetCount,
      required int totalCompletedSets,
      required int totalRepetitions,
      required double totalVolumeKg,
      Value<int> personalRecordCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CompletedWorkoutSessionsTableUpdateCompanionBuilder =
    CompletedWorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String?> sourceActiveSessionId,
      Value<String?> sourceTemplateId,
      Value<String> name,
      Value<String?> notes,
      Value<String> weightUnit,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationSeconds,
      Value<int> exerciseCount,
      Value<int> workingSetCount,
      Value<int> totalCompletedSets,
      Value<int> totalRepetitions,
      Value<double> totalVolumeKg,
      Value<int> personalRecordCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CompletedWorkoutSessionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompletedWorkoutSessionsTable,
          CompletedWorkoutSessionRow
        > {
  $$CompletedWorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CompletedWorkoutExercisesTable,
    List<CompletedWorkoutExerciseRow>
  >
  _completedWorkoutExercisesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.completedWorkoutExercises,
    aliasName:
        'completed_workout_sessions__id__completed_workout_exercises__session_id',
  );

  $$CompletedWorkoutExercisesTableProcessedTableManager
  get completedWorkoutExercisesRefs {
    final manager = $$CompletedWorkoutExercisesTableTableManager(
      $_db,
      $_db.completedWorkoutExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _completedWorkoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CompletedWorkoutSetsTable,
    List<CompletedWorkoutSetRow>
  >
  _completedWorkoutSetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.completedWorkoutSets,
    aliasName:
        'completed_workout_sessions__id__completed_workout_sets__session_id',
  );

  $$CompletedWorkoutSetsTableProcessedTableManager
  get completedWorkoutSetsRefs {
    final manager = $$CompletedWorkoutSetsTableTableManager(
      $_db,
      $_db.completedWorkoutSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _completedWorkoutSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompletedWorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSessionsTable> {
  $$CompletedWorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceActiveSessionId => $composableBuilder(
    column: $table.sourceActiveSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCompletedSets => $composableBuilder(
    column: $table.totalCompletedSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get personalRecordCount => $composableBuilder(
    column: $table.personalRecordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> completedWorkoutExercisesRefs(
    Expression<bool> Function($$CompletedWorkoutExercisesTableFilterComposer f)
    f,
  ) {
    final $$CompletedWorkoutExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.completedWorkoutExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutExercisesTableFilterComposer(
                $db: $db,
                $table: $db.completedWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> completedWorkoutSetsRefs(
    Expression<bool> Function($$CompletedWorkoutSetsTableFilterComposer f) f,
  ) {
    final $$CompletedWorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completedWorkoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletedWorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.completedWorkoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompletedWorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSessionsTable> {
  $$CompletedWorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceActiveSessionId => $composableBuilder(
    column: $table.sourceActiveSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCompletedSets => $composableBuilder(
    column: $table.totalCompletedSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get personalRecordCount => $composableBuilder(
    column: $table.personalRecordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompletedWorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSessionsTable> {
  $$CompletedWorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceActiveSessionId => $composableBuilder(
    column: $table.sourceActiveSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceTemplateId => $composableBuilder(
    column: $table.sourceTemplateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseCount => $composableBuilder(
    column: $table.exerciseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCompletedSets => $composableBuilder(
    column: $table.totalCompletedSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get personalRecordCount => $composableBuilder(
    column: $table.personalRecordCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> completedWorkoutExercisesRefs<T extends Object>(
    Expression<T> Function($$CompletedWorkoutExercisesTableAnnotationComposer a)
    f,
  ) {
    final $$CompletedWorkoutExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.completedWorkoutExercises,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> completedWorkoutSetsRefs<T extends Object>(
    Expression<T> Function($$CompletedWorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$CompletedWorkoutSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.completedWorkoutSets,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CompletedWorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletedWorkoutSessionsTable,
          CompletedWorkoutSessionRow,
          $$CompletedWorkoutSessionsTableFilterComposer,
          $$CompletedWorkoutSessionsTableOrderingComposer,
          $$CompletedWorkoutSessionsTableAnnotationComposer,
          $$CompletedWorkoutSessionsTableCreateCompanionBuilder,
          $$CompletedWorkoutSessionsTableUpdateCompanionBuilder,
          (
            CompletedWorkoutSessionRow,
            $$CompletedWorkoutSessionsTableReferences,
          ),
          CompletedWorkoutSessionRow,
          PrefetchHooks Function({
            bool completedWorkoutExercisesRefs,
            bool completedWorkoutSetsRefs,
          })
        > {
  $$CompletedWorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $CompletedWorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedWorkoutSessionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompletedWorkoutSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompletedWorkoutSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> sourceActiveSessionId = const Value.absent(),
                Value<String?> sourceTemplateId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int> exerciseCount = const Value.absent(),
                Value<int> workingSetCount = const Value.absent(),
                Value<int> totalCompletedSets = const Value.absent(),
                Value<int> totalRepetitions = const Value.absent(),
                Value<double> totalVolumeKg = const Value.absent(),
                Value<int> personalRecordCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutSessionsCompanion(
                id: id,
                userId: userId,
                sourceActiveSessionId: sourceActiveSessionId,
                sourceTemplateId: sourceTemplateId,
                name: name,
                notes: notes,
                weightUnit: weightUnit,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                exerciseCount: exerciseCount,
                workingSetCount: workingSetCount,
                totalCompletedSets: totalCompletedSets,
                totalRepetitions: totalRepetitions,
                totalVolumeKg: totalVolumeKg,
                personalRecordCount: personalRecordCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String?> sourceActiveSessionId = const Value.absent(),
                Value<String?> sourceTemplateId = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationSeconds,
                required int exerciseCount,
                required int workingSetCount,
                required int totalCompletedSets,
                required int totalRepetitions,
                required double totalVolumeKg,
                Value<int> personalRecordCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutSessionsCompanion.insert(
                id: id,
                userId: userId,
                sourceActiveSessionId: sourceActiveSessionId,
                sourceTemplateId: sourceTemplateId,
                name: name,
                notes: notes,
                weightUnit: weightUnit,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                exerciseCount: exerciseCount,
                workingSetCount: workingSetCount,
                totalCompletedSets: totalCompletedSets,
                totalRepetitions: totalRepetitions,
                totalVolumeKg: totalVolumeKg,
                personalRecordCount: personalRecordCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompletedWorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                completedWorkoutExercisesRefs = false,
                completedWorkoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (completedWorkoutExercisesRefs)
                      db.completedWorkoutExercises,
                    if (completedWorkoutSetsRefs) db.completedWorkoutSets,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (completedWorkoutExercisesRefs)
                        await $_getPrefetchedData<
                          CompletedWorkoutSessionRow,
                          $CompletedWorkoutSessionsTable,
                          CompletedWorkoutExerciseRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$CompletedWorkoutSessionsTableReferences
                                  ._completedWorkoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompletedWorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).completedWorkoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (completedWorkoutSetsRefs)
                        await $_getPrefetchedData<
                          CompletedWorkoutSessionRow,
                          $CompletedWorkoutSessionsTable,
                          CompletedWorkoutSetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$CompletedWorkoutSessionsTableReferences
                                  ._completedWorkoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompletedWorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).completedWorkoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompletedWorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletedWorkoutSessionsTable,
      CompletedWorkoutSessionRow,
      $$CompletedWorkoutSessionsTableFilterComposer,
      $$CompletedWorkoutSessionsTableOrderingComposer,
      $$CompletedWorkoutSessionsTableAnnotationComposer,
      $$CompletedWorkoutSessionsTableCreateCompanionBuilder,
      $$CompletedWorkoutSessionsTableUpdateCompanionBuilder,
      (CompletedWorkoutSessionRow, $$CompletedWorkoutSessionsTableReferences),
      CompletedWorkoutSessionRow,
      PrefetchHooks Function({
        bool completedWorkoutExercisesRefs,
        bool completedWorkoutSetsRefs,
      })
    >;
typedef $$CompletedWorkoutExercisesTableCreateCompanionBuilder =
    CompletedWorkoutExercisesCompanion Function({
      required String id,
      required String userId,
      required String sessionId,
      Value<String?> sourceActiveExerciseId,
      required String exerciseSource,
      required String exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      required String exerciseName,
      required String primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      required String equipment,
      required String trackingType,
      required bool weightRelevant,
      required bool repetitionsRelevant,
      required bool distanceRelevant,
      required bool durationRelevant,
      required bool bodyweightRelevant,
      Value<String?> notes,
      Value<int> sortOrder,
      required int completedSetCount,
      required int workingSetCount,
      required int totalRepetitions,
      required double totalVolumeKg,
      Value<double?> bestWeightKg,
      Value<double?> bestEstimatedOneRepMaxKg,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CompletedWorkoutExercisesTableUpdateCompanionBuilder =
    CompletedWorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sessionId,
      Value<String?> sourceActiveExerciseId,
      Value<String> exerciseSource,
      Value<String> exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      Value<String> exerciseName,
      Value<String> primaryMuscleGroup,
      Value<String> secondaryMuscleGroupsJson,
      Value<String> equipment,
      Value<String> trackingType,
      Value<bool> weightRelevant,
      Value<bool> repetitionsRelevant,
      Value<bool> distanceRelevant,
      Value<bool> durationRelevant,
      Value<bool> bodyweightRelevant,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> completedSetCount,
      Value<int> workingSetCount,
      Value<int> totalRepetitions,
      Value<double> totalVolumeKg,
      Value<double?> bestWeightKg,
      Value<double?> bestEstimatedOneRepMaxKg,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CompletedWorkoutExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompletedWorkoutExercisesTable,
          CompletedWorkoutExerciseRow
        > {
  $$CompletedWorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompletedWorkoutSessionsTable _sessionIdTable(
    _$AppDatabase db,
  ) => db.completedWorkoutSessions.createAlias(
    'completed_workout_exercises__session_id__completed_workout_sessions__id',
  );

  $$CompletedWorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$CompletedWorkoutSessionsTableTableManager(
      $_db,
      $_db.completedWorkoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $CompletedWorkoutSetsTable,
    List<CompletedWorkoutSetRow>
  >
  _completedWorkoutSetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.completedWorkoutSets,
    aliasName:
        'completed_workout_exercises__id__completed_workout_sets__session_exercise_id',
  );

  $$CompletedWorkoutSetsTableProcessedTableManager
  get completedWorkoutSetsRefs {
    final manager =
        $$CompletedWorkoutSetsTableTableManager(
          $_db,
          $_db.completedWorkoutSets,
        ).filter(
          (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _completedWorkoutSetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompletedWorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutExercisesTable> {
  $$CompletedWorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceActiveExerciseId => $composableBuilder(
    column: $table.sourceActiveExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedSetCount => $composableBuilder(
    column: $table.completedSetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bestWeightKg => $composableBuilder(
    column: $table.bestWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bestEstimatedOneRepMaxKg => $composableBuilder(
    column: $table.bestEstimatedOneRepMaxKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$CompletedWorkoutSessionsTableFilterComposer get sessionId {
    final $$CompletedWorkoutSessionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableFilterComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> completedWorkoutSetsRefs(
    Expression<bool> Function($$CompletedWorkoutSetsTableFilterComposer f) f,
  ) {
    final $$CompletedWorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completedWorkoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletedWorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.completedWorkoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompletedWorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutExercisesTable> {
  $$CompletedWorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceActiveExerciseId => $composableBuilder(
    column: $table.sourceActiveExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedSetCount => $composableBuilder(
    column: $table.completedSetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bestWeightKg => $composableBuilder(
    column: $table.bestWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bestEstimatedOneRepMaxKg => $composableBuilder(
    column: $table.bestEstimatedOneRepMaxKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompletedWorkoutSessionsTableOrderingComposer get sessionId {
    final $$CompletedWorkoutSessionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableOrderingComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompletedWorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutExercisesTable> {
  $$CompletedWorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceActiveExerciseId => $composableBuilder(
    column: $table.sourceActiveExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get primaryMuscleGroup => $composableBuilder(
    column: $table.primaryMuscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryMuscleGroupsJson => $composableBuilder(
    column: $table.secondaryMuscleGroupsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get trackingType => $composableBuilder(
    column: $table.trackingType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weightRelevant => $composableBuilder(
    column: $table.weightRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get repetitionsRelevant => $composableBuilder(
    column: $table.repetitionsRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get distanceRelevant => $composableBuilder(
    column: $table.distanceRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get durationRelevant => $composableBuilder(
    column: $table.durationRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bodyweightRelevant => $composableBuilder(
    column: $table.bodyweightRelevant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get completedSetCount => $composableBuilder(
    column: $table.completedSetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workingSetCount => $composableBuilder(
    column: $table.workingSetCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalRepetitions => $composableBuilder(
    column: $table.totalRepetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalVolumeKg => $composableBuilder(
    column: $table.totalVolumeKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bestWeightKg => $composableBuilder(
    column: $table.bestWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get bestEstimatedOneRepMaxKg => $composableBuilder(
    column: $table.bestEstimatedOneRepMaxKg,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$CompletedWorkoutSessionsTableAnnotationComposer get sessionId {
    final $$CompletedWorkoutSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> completedWorkoutSetsRefs<T extends Object>(
    Expression<T> Function($$CompletedWorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$CompletedWorkoutSetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.completedWorkoutSets,
          getReferencedColumn: (t) => t.sessionExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSetsTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutSets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CompletedWorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletedWorkoutExercisesTable,
          CompletedWorkoutExerciseRow,
          $$CompletedWorkoutExercisesTableFilterComposer,
          $$CompletedWorkoutExercisesTableOrderingComposer,
          $$CompletedWorkoutExercisesTableAnnotationComposer,
          $$CompletedWorkoutExercisesTableCreateCompanionBuilder,
          $$CompletedWorkoutExercisesTableUpdateCompanionBuilder,
          (
            CompletedWorkoutExerciseRow,
            $$CompletedWorkoutExercisesTableReferences,
          ),
          CompletedWorkoutExerciseRow,
          PrefetchHooks Function({
            bool sessionId,
            bool completedWorkoutSetsRefs,
          })
        > {
  $$CompletedWorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $CompletedWorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedWorkoutExercisesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompletedWorkoutExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompletedWorkoutExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> sourceActiveExerciseId = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseKey = const Value.absent(),
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> primaryMuscleGroup = const Value.absent(),
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> trackingType = const Value.absent(),
                Value<bool> weightRelevant = const Value.absent(),
                Value<bool> repetitionsRelevant = const Value.absent(),
                Value<bool> distanceRelevant = const Value.absent(),
                Value<bool> durationRelevant = const Value.absent(),
                Value<bool> bodyweightRelevant = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> completedSetCount = const Value.absent(),
                Value<int> workingSetCount = const Value.absent(),
                Value<int> totalRepetitions = const Value.absent(),
                Value<double> totalVolumeKg = const Value.absent(),
                Value<double?> bestWeightKg = const Value.absent(),
                Value<double?> bestEstimatedOneRepMaxKg = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutExercisesCompanion(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sourceActiveExerciseId: sourceActiveExerciseId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                trackingType: trackingType,
                weightRelevant: weightRelevant,
                repetitionsRelevant: repetitionsRelevant,
                distanceRelevant: distanceRelevant,
                durationRelevant: durationRelevant,
                bodyweightRelevant: bodyweightRelevant,
                notes: notes,
                sortOrder: sortOrder,
                completedSetCount: completedSetCount,
                workingSetCount: workingSetCount,
                totalRepetitions: totalRepetitions,
                totalVolumeKg: totalVolumeKg,
                bestWeightKg: bestWeightKg,
                bestEstimatedOneRepMaxKg: bestEstimatedOneRepMaxKg,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sessionId,
                Value<String?> sourceActiveExerciseId = const Value.absent(),
                required String exerciseSource,
                required String exerciseKey,
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                required String exerciseName,
                required String primaryMuscleGroup,
                Value<String> secondaryMuscleGroupsJson = const Value.absent(),
                required String equipment,
                required String trackingType,
                required bool weightRelevant,
                required bool repetitionsRelevant,
                required bool distanceRelevant,
                required bool durationRelevant,
                required bool bodyweightRelevant,
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required int completedSetCount,
                required int workingSetCount,
                required int totalRepetitions,
                required double totalVolumeKg,
                Value<double?> bestWeightKg = const Value.absent(),
                Value<double?> bestEstimatedOneRepMaxKg = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutExercisesCompanion.insert(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sourceActiveExerciseId: sourceActiveExerciseId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                primaryMuscleGroup: primaryMuscleGroup,
                secondaryMuscleGroupsJson: secondaryMuscleGroupsJson,
                equipment: equipment,
                trackingType: trackingType,
                weightRelevant: weightRelevant,
                repetitionsRelevant: repetitionsRelevant,
                distanceRelevant: distanceRelevant,
                durationRelevant: durationRelevant,
                bodyweightRelevant: bodyweightRelevant,
                notes: notes,
                sortOrder: sortOrder,
                completedSetCount: completedSetCount,
                workingSetCount: workingSetCount,
                totalRepetitions: totalRepetitions,
                totalVolumeKg: totalVolumeKg,
                bestWeightKg: bestWeightKg,
                bestEstimatedOneRepMaxKg: bestEstimatedOneRepMaxKg,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompletedWorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, completedWorkoutSetsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (completedWorkoutSetsRefs) db.completedWorkoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$CompletedWorkoutExercisesTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$CompletedWorkoutExercisesTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (completedWorkoutSetsRefs)
                        await $_getPrefetchedData<
                          CompletedWorkoutExerciseRow,
                          $CompletedWorkoutExercisesTable,
                          CompletedWorkoutSetRow
                        >(
                          currentTable: table,
                          referencedTable:
                              $$CompletedWorkoutExercisesTableReferences
                                  ._completedWorkoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompletedWorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).completedWorkoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompletedWorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletedWorkoutExercisesTable,
      CompletedWorkoutExerciseRow,
      $$CompletedWorkoutExercisesTableFilterComposer,
      $$CompletedWorkoutExercisesTableOrderingComposer,
      $$CompletedWorkoutExercisesTableAnnotationComposer,
      $$CompletedWorkoutExercisesTableCreateCompanionBuilder,
      $$CompletedWorkoutExercisesTableUpdateCompanionBuilder,
      (CompletedWorkoutExerciseRow, $$CompletedWorkoutExercisesTableReferences),
      CompletedWorkoutExerciseRow,
      PrefetchHooks Function({bool sessionId, bool completedWorkoutSetsRefs})
    >;
typedef $$CompletedWorkoutSetsTableCreateCompanionBuilder =
    CompletedWorkoutSetsCompanion Function({
      required String id,
      required String userId,
      required String sessionId,
      required String sessionExerciseId,
      Value<String?> sourceActiveSetId,
      required String setType,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<double?> rpe,
      Value<double?> rir,
      Value<String?> notes,
      Value<int> sortOrder,
      required double setVolumeKg,
      Value<double?> estimatedOneRepMaxKg,
      Value<bool> isPersonalRecord,
      required DateTime completedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$CompletedWorkoutSetsTableUpdateCompanionBuilder =
    CompletedWorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> sessionId,
      Value<String> sessionExerciseId,
      Value<String?> sourceActiveSetId,
      Value<String> setType,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<double?> rpe,
      Value<double?> rir,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<double> setVolumeKg,
      Value<double?> estimatedOneRepMaxKg,
      Value<bool> isPersonalRecord,
      Value<DateTime> completedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

final class $$CompletedWorkoutSetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompletedWorkoutSetsTable,
          CompletedWorkoutSetRow
        > {
  $$CompletedWorkoutSetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompletedWorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.completedWorkoutSessions.createAlias(
        'completed_workout_sets__session_id__completed_workout_sessions__id',
      );

  $$CompletedWorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$CompletedWorkoutSessionsTableTableManager(
      $_db,
      $_db.completedWorkoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CompletedWorkoutExercisesTable _sessionExerciseIdTable(
    _$AppDatabase db,
  ) => db.completedWorkoutExercises.createAlias(
    'completed_workout_sets__session_exercise_id__completed_workout_exercises__id',
  );

  $$CompletedWorkoutExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<String>('session_exercise_id')!;

    final manager = $$CompletedWorkoutExercisesTableTableManager(
      $_db,
      $_db.completedWorkoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletedWorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSetsTable> {
  $$CompletedWorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceActiveSetId => $composableBuilder(
    column: $table.sourceActiveSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get setVolumeKg => $composableBuilder(
    column: $table.setVolumeKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$CompletedWorkoutSessionsTableFilterComposer get sessionId {
    final $$CompletedWorkoutSessionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableFilterComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CompletedWorkoutExercisesTableFilterComposer get sessionExerciseId {
    final $$CompletedWorkoutExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.completedWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutExercisesTableFilterComposer(
                $db: $db,
                $table: $db.completedWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompletedWorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSetsTable> {
  $$CompletedWorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceActiveSetId => $composableBuilder(
    column: $table.sourceActiveSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get setVolumeKg => $composableBuilder(
    column: $table.setVolumeKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompletedWorkoutSessionsTableOrderingComposer get sessionId {
    final $$CompletedWorkoutSessionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableOrderingComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CompletedWorkoutExercisesTableOrderingComposer get sessionExerciseId {
    final $$CompletedWorkoutExercisesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.completedWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutExercisesTableOrderingComposer(
                $db: $db,
                $table: $db.completedWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompletedWorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletedWorkoutSetsTable> {
  $$CompletedWorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceActiveSetId => $composableBuilder(
    column: $table.sourceActiveSetId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<double> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<double> get setVolumeKg => $composableBuilder(
    column: $table.setVolumeKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$CompletedWorkoutSessionsTableAnnotationComposer get sessionId {
    final $$CompletedWorkoutSessionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.completedWorkoutSessions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutSessionsTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutSessions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CompletedWorkoutExercisesTableAnnotationComposer get sessionExerciseId {
    final $$CompletedWorkoutExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionExerciseId,
          referencedTable: $db.completedWorkoutExercises,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompletedWorkoutExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.completedWorkoutExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompletedWorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletedWorkoutSetsTable,
          CompletedWorkoutSetRow,
          $$CompletedWorkoutSetsTableFilterComposer,
          $$CompletedWorkoutSetsTableOrderingComposer,
          $$CompletedWorkoutSetsTableAnnotationComposer,
          $$CompletedWorkoutSetsTableCreateCompanionBuilder,
          $$CompletedWorkoutSetsTableUpdateCompanionBuilder,
          (CompletedWorkoutSetRow, $$CompletedWorkoutSetsTableReferences),
          CompletedWorkoutSetRow,
          PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
        > {
  $$CompletedWorkoutSetsTableTableManager(
    _$AppDatabase db,
    $CompletedWorkoutSetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedWorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletedWorkoutSetsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompletedWorkoutSetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> sessionExerciseId = const Value.absent(),
                Value<String?> sourceActiveSetId = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<double> setVolumeKg = const Value.absent(),
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                Value<bool> isPersonalRecord = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutSetsCompanion(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                sourceActiveSetId: sourceActiveSetId,
                setType: setType,
                weightKg: weightKg,
                repetitions: repetitions,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rpe: rpe,
                rir: rir,
                notes: notes,
                sortOrder: sortOrder,
                setVolumeKg: setVolumeKg,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                isPersonalRecord: isPersonalRecord,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String sessionId,
                required String sessionExerciseId,
                Value<String?> sourceActiveSetId = const Value.absent(),
                required String setType,
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required double setVolumeKg,
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                Value<bool> isPersonalRecord = const Value.absent(),
                required DateTime completedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedWorkoutSetsCompanion.insert(
                id: id,
                userId: userId,
                sessionId: sessionId,
                sessionExerciseId: sessionExerciseId,
                sourceActiveSetId: sourceActiveSetId,
                setType: setType,
                weightKg: weightKg,
                repetitions: repetitions,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rpe: rpe,
                rir: rir,
                notes: notes,
                sortOrder: sortOrder,
                setVolumeKg: setVolumeKg,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                isPersonalRecord: isPersonalRecord,
                completedAt: completedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompletedWorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, sessionExerciseId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$CompletedWorkoutSetsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$CompletedWorkoutSetsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sessionExerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionExerciseId,
                                    referencedTable:
                                        $$CompletedWorkoutSetsTableReferences
                                            ._sessionExerciseIdTable(db),
                                    referencedColumn:
                                        $$CompletedWorkoutSetsTableReferences
                                            ._sessionExerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$CompletedWorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletedWorkoutSetsTable,
      CompletedWorkoutSetRow,
      $$CompletedWorkoutSetsTableFilterComposer,
      $$CompletedWorkoutSetsTableOrderingComposer,
      $$CompletedWorkoutSetsTableAnnotationComposer,
      $$CompletedWorkoutSetsTableCreateCompanionBuilder,
      $$CompletedWorkoutSetsTableUpdateCompanionBuilder,
      (CompletedWorkoutSetRow, $$CompletedWorkoutSetsTableReferences),
      CompletedWorkoutSetRow,
      PrefetchHooks Function({bool sessionId, bool sessionExerciseId})
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      required String id,
      required String userId,
      required String exerciseSource,
      required String exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      required String exerciseName,
      required String recordKind,
      Value<String> recordScope,
      required double recordValue,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<double?> estimatedOneRepMaxKg,
      required String completedSessionId,
      required String completedExerciseId,
      Value<String?> completedSetId,
      required DateTime achievedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> exerciseSource,
      Value<String> exerciseKey,
      Value<String?> systemExerciseKey,
      Value<String?> customExerciseId,
      Value<String> exerciseName,
      Value<String> recordKind,
      Value<String> recordScope,
      Value<double> recordValue,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<double?> estimatedOneRepMaxKg,
      Value<String> completedSessionId,
      Value<String> completedExerciseId,
      Value<String?> completedSetId,
      Value<DateTime> achievedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get systemExerciseKey => $composableBuilder(
    column: $table.systemExerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customExerciseId => $composableBuilder(
    column: $table.customExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecordRow,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (
            PersonalRecordRow,
            BaseReferences<
              _$AppDatabase,
              $PersonalRecordsTable,
              PersonalRecordRow
            >,
          ),
          PersonalRecordRow,
          PrefetchHooks Function()
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseKey = const Value.absent(),
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> recordKind = const Value.absent(),
                Value<String> recordScope = const Value.absent(),
                Value<double> recordValue = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                Value<String> completedSessionId = const Value.absent(),
                Value<String> completedExerciseId = const Value.absent(),
                Value<String?> completedSetId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                userId: userId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                recordKind: recordKind,
                recordScope: recordScope,
                recordValue: recordValue,
                weightKg: weightKg,
                repetitions: repetitions,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                completedSessionId: completedSessionId,
                completedExerciseId: completedExerciseId,
                completedSetId: completedSetId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String exerciseSource,
                required String exerciseKey,
                Value<String?> systemExerciseKey = const Value.absent(),
                Value<String?> customExerciseId = const Value.absent(),
                required String exerciseName,
                required String recordKind,
                Value<String> recordScope = const Value.absent(),
                required double recordValue,
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                required String completedSessionId,
                required String completedExerciseId,
                Value<String?> completedSetId = const Value.absent(),
                required DateTime achievedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                id: id,
                userId: userId,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                systemExerciseKey: systemExerciseKey,
                customExerciseId: customExerciseId,
                exerciseName: exerciseName,
                recordKind: recordKind,
                recordScope: recordScope,
                recordValue: recordValue,
                weightKg: weightKg,
                repetitions: repetitions,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                completedSessionId: completedSessionId,
                completedExerciseId: completedExerciseId,
                completedSetId: completedSetId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecordRow,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (
        PersonalRecordRow,
        BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecordRow>,
      ),
      PersonalRecordRow,
      PrefetchHooks Function()
    >;
typedef $$PersonalRecordEventsTableCreateCompanionBuilder =
    PersonalRecordEventsCompanion Function({
      required String id,
      required String userId,
      required String personalRecordId,
      required String eventKey,
      required String exerciseSource,
      required String exerciseKey,
      required String exerciseName,
      required String recordKind,
      Value<String> recordScope,
      Value<double?> previousRecordValue,
      required double recordValue,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<double?> estimatedOneRepMaxKg,
      required String completedSessionId,
      required String completedExerciseId,
      Value<String?> completedSetId,
      required DateTime achievedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });
typedef $$PersonalRecordEventsTableUpdateCompanionBuilder =
    PersonalRecordEventsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> personalRecordId,
      Value<String> eventKey,
      Value<String> exerciseSource,
      Value<String> exerciseKey,
      Value<String> exerciseName,
      Value<String> recordKind,
      Value<String> recordScope,
      Value<double?> previousRecordValue,
      Value<double> recordValue,
      Value<double?> weightKg,
      Value<int?> repetitions,
      Value<double?> estimatedOneRepMaxKg,
      Value<String> completedSessionId,
      Value<String> completedExerciseId,
      Value<String?> completedSetId,
      Value<DateTime> achievedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> version,
      Value<int> rowid,
    });

class $$PersonalRecordEventsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordEventsTable> {
  $$PersonalRecordEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalRecordId => $composableBuilder(
    column: $table.personalRecordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousRecordValue => $composableBuilder(
    column: $table.previousRecordValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalRecordEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordEventsTable> {
  $$PersonalRecordEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalRecordId => $composableBuilder(
    column: $table.personalRecordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousRecordValue => $composableBuilder(
    column: $table.previousRecordValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalRecordEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordEventsTable> {
  $$PersonalRecordEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get personalRecordId => $composableBuilder(
    column: $table.personalRecordId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventKey =>
      $composableBuilder(column: $table.eventKey, builder: (column) => column);

  GeneratedColumn<String> get exerciseSource => $composableBuilder(
    column: $table.exerciseSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseKey => $composableBuilder(
    column: $table.exerciseKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordKind => $composableBuilder(
    column: $table.recordKind,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordScope => $composableBuilder(
    column: $table.recordScope,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousRecordValue => $composableBuilder(
    column: $table.previousRecordValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recordValue => $composableBuilder(
    column: $table.recordValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedOneRepMaxKg => $composableBuilder(
    column: $table.estimatedOneRepMaxKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedSessionId => $composableBuilder(
    column: $table.completedSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedExerciseId => $composableBuilder(
    column: $table.completedExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedSetId => $composableBuilder(
    column: $table.completedSetId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$PersonalRecordEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordEventsTable,
          PersonalRecordEventRow,
          $$PersonalRecordEventsTableFilterComposer,
          $$PersonalRecordEventsTableOrderingComposer,
          $$PersonalRecordEventsTableAnnotationComposer,
          $$PersonalRecordEventsTableCreateCompanionBuilder,
          $$PersonalRecordEventsTableUpdateCompanionBuilder,
          (
            PersonalRecordEventRow,
            BaseReferences<
              _$AppDatabase,
              $PersonalRecordEventsTable,
              PersonalRecordEventRow
            >,
          ),
          PersonalRecordEventRow,
          PrefetchHooks Function()
        > {
  $$PersonalRecordEventsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PersonalRecordEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> personalRecordId = const Value.absent(),
                Value<String> eventKey = const Value.absent(),
                Value<String> exerciseSource = const Value.absent(),
                Value<String> exerciseKey = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String> recordKind = const Value.absent(),
                Value<String> recordScope = const Value.absent(),
                Value<double?> previousRecordValue = const Value.absent(),
                Value<double> recordValue = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                Value<String> completedSessionId = const Value.absent(),
                Value<String> completedExerciseId = const Value.absent(),
                Value<String?> completedSetId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordEventsCompanion(
                id: id,
                userId: userId,
                personalRecordId: personalRecordId,
                eventKey: eventKey,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                exerciseName: exerciseName,
                recordKind: recordKind,
                recordScope: recordScope,
                previousRecordValue: previousRecordValue,
                recordValue: recordValue,
                weightKg: weightKg,
                repetitions: repetitions,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                completedSessionId: completedSessionId,
                completedExerciseId: completedExerciseId,
                completedSetId: completedSetId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String personalRecordId,
                required String eventKey,
                required String exerciseSource,
                required String exerciseKey,
                required String exerciseName,
                required String recordKind,
                Value<String> recordScope = const Value.absent(),
                Value<double?> previousRecordValue = const Value.absent(),
                required double recordValue,
                Value<double?> weightKg = const Value.absent(),
                Value<int?> repetitions = const Value.absent(),
                Value<double?> estimatedOneRepMaxKg = const Value.absent(),
                required String completedSessionId,
                required String completedExerciseId,
                Value<String?> completedSetId = const Value.absent(),
                required DateTime achievedAt,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordEventsCompanion.insert(
                id: id,
                userId: userId,
                personalRecordId: personalRecordId,
                eventKey: eventKey,
                exerciseSource: exerciseSource,
                exerciseKey: exerciseKey,
                exerciseName: exerciseName,
                recordKind: recordKind,
                recordScope: recordScope,
                previousRecordValue: previousRecordValue,
                recordValue: recordValue,
                weightKg: weightKg,
                repetitions: repetitions,
                estimatedOneRepMaxKg: estimatedOneRepMaxKg,
                completedSessionId: completedSessionId,
                completedExerciseId: completedExerciseId,
                completedSetId: completedSetId,
                achievedAt: achievedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                version: version,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalRecordEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordEventsTable,
      PersonalRecordEventRow,
      $$PersonalRecordEventsTableFilterComposer,
      $$PersonalRecordEventsTableOrderingComposer,
      $$PersonalRecordEventsTableAnnotationComposer,
      $$PersonalRecordEventsTableCreateCompanionBuilder,
      $$PersonalRecordEventsTableUpdateCompanionBuilder,
      (
        PersonalRecordEventRow,
        BaseReferences<
          _$AppDatabase,
          $PersonalRecordEventsTable,
          PersonalRecordEventRow
        >,
      ),
      PersonalRecordEventRow,
      PrefetchHooks Function()
    >;
typedef $$SessionSyncQueueTableCreateCompanionBuilder =
    SessionSyncQueueCompanion Function({
      required String id,
      required String userId,
      required String entityType,
      required String entityId,
      required int entityVersion,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SessionSyncQueueTableUpdateCompanionBuilder =
    SessionSyncQueueCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> entityType,
      Value<String> entityId,
      Value<int> entityVersion,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime?> lastAttemptAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SessionSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SessionSyncQueueTable> {
  $$SessionSyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionSyncQueueTable> {
  $$SessionSyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionSyncQueueTable> {
  $$SessionSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get entityVersion => $composableBuilder(
    column: $table.entityVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SessionSyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionSyncQueueTable,
          SessionSyncQueueRow,
          $$SessionSyncQueueTableFilterComposer,
          $$SessionSyncQueueTableOrderingComposer,
          $$SessionSyncQueueTableAnnotationComposer,
          $$SessionSyncQueueTableCreateCompanionBuilder,
          $$SessionSyncQueueTableUpdateCompanionBuilder,
          (
            SessionSyncQueueRow,
            BaseReferences<
              _$AppDatabase,
              $SessionSyncQueueTable,
              SessionSyncQueueRow
            >,
          ),
          SessionSyncQueueRow,
          PrefetchHooks Function()
        > {
  $$SessionSyncQueueTableTableManager(
    _$AppDatabase db,
    $SessionSyncQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<int> entityVersion = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionSyncQueueCompanion(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                entityVersion: entityVersion,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String entityType,
                required String entityId,
                required int entityVersion,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionSyncQueueCompanion.insert(
                id: id,
                userId: userId,
                entityType: entityType,
                entityId: entityId,
                entityVersion: entityVersion,
                attemptCount: attemptCount,
                lastError: lastError,
                lastAttemptAt: lastAttemptAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionSyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionSyncQueueTable,
      SessionSyncQueueRow,
      $$SessionSyncQueueTableFilterComposer,
      $$SessionSyncQueueTableOrderingComposer,
      $$SessionSyncQueueTableAnnotationComposer,
      $$SessionSyncQueueTableCreateCompanionBuilder,
      $$SessionSyncQueueTableUpdateCompanionBuilder,
      (
        SessionSyncQueueRow,
        BaseReferences<
          _$AppDatabase,
          $SessionSyncQueueTable,
          SessionSyncQueueRow
        >,
      ),
      SessionSyncQueueRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$WorkoutSplitsTableTableManager get workoutSplits =>
      $$WorkoutSplitsTableTableManager(_db, _db.workoutSplits);
  $$CustomExercisesTableTableManager get customExercises =>
      $$CustomExercisesTableTableManager(_db, _db.customExercises);
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$TemplateExercisesTableTableManager get templateExercises =>
      $$TemplateExercisesTableTableManager(_db, _db.templateExercises);
  $$PlannerSyncQueueTableTableManager get plannerSyncQueue =>
      $$PlannerSyncQueueTableTableManager(_db, _db.plannerSyncQueue);
  $$ActiveWorkoutSessionsTableTableManager get activeWorkoutSessions =>
      $$ActiveWorkoutSessionsTableTableManager(_db, _db.activeWorkoutSessions);
  $$ActiveWorkoutExercisesTableTableManager get activeWorkoutExercises =>
      $$ActiveWorkoutExercisesTableTableManager(
        _db,
        _db.activeWorkoutExercises,
      );
  $$ActiveWorkoutSetsTableTableManager get activeWorkoutSets =>
      $$ActiveWorkoutSetsTableTableManager(_db, _db.activeWorkoutSets);
  $$CompletedWorkoutSessionsTableTableManager get completedWorkoutSessions =>
      $$CompletedWorkoutSessionsTableTableManager(
        _db,
        _db.completedWorkoutSessions,
      );
  $$CompletedWorkoutExercisesTableTableManager get completedWorkoutExercises =>
      $$CompletedWorkoutExercisesTableTableManager(
        _db,
        _db.completedWorkoutExercises,
      );
  $$CompletedWorkoutSetsTableTableManager get completedWorkoutSets =>
      $$CompletedWorkoutSetsTableTableManager(_db, _db.completedWorkoutSets);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$PersonalRecordEventsTableTableManager get personalRecordEvents =>
      $$PersonalRecordEventsTableTableManager(_db, _db.personalRecordEvents);
  $$SessionSyncQueueTableTableManager get sessionSyncQueue =>
      $$SessionSyncQueueTableTableManager(_db, _db.sessionSyncQueue);
}
