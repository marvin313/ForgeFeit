-- ForgeFit Stage 3 active-workout, completed-history, and personal-record
-- schema. Apply after 0002_stage_2_workout_planning.sql.
--
-- Source template and custom-exercise identifiers below are deliberately
-- snapshot references rather than foreign keys. A later template edit or
-- exercise soft deletion must never change or invalidate recorded history.

-- Custom exercise aliases and keywords remain private because they live on
-- the existing owner-restricted custom_exercises table.
alter table public.custom_exercises
  add column if not exists aliases text[] not null default '{}'::text[],
  add column if not exists search_keywords text[] not null default '{}'::text[];

alter table public.custom_exercises
  drop constraint if exists custom_exercises_aliases_count_check;
alter table public.custom_exercises
  add constraint custom_exercises_aliases_count_check
  check (
    cardinality(aliases) <= 50
    and array_position(aliases, null) is null
  );

alter table public.custom_exercises
  drop constraint if exists custom_exercises_search_keywords_count_check;
alter table public.custom_exercises
  add constraint custom_exercises_search_keywords_count_check
  check (
    cardinality(search_keywords) <= 100
    and array_position(search_keywords, null) is null
  );

-- Stage 3 adds mobility and rehabilitation groups plus the expanded equipment
-- catalogue while retaining every Stage 2 value for backwards compatibility.
alter table public.custom_exercises
  drop constraint if exists custom_exercises_primary_muscle_group_check;
alter table public.custom_exercises
  add constraint custom_exercises_primary_muscle_group_check
  check (
    primary_muscle_group in (
      'chest',
      'back',
      'shoulders',
      'biceps',
      'triceps',
      'forearms',
      'quadriceps',
      'hamstrings',
      'glutes',
      'calves',
      'core',
      'full_body',
      'cardio',
      'mobility',
      'rehabilitation',
      'other'
    )
  );

alter table public.custom_exercises
  drop constraint if exists custom_exercises_secondary_muscle_groups_check;
alter table public.custom_exercises
  add constraint custom_exercises_secondary_muscle_groups_check
  check (
    cardinality(secondary_muscle_groups) <= 16
    and secondary_muscle_groups <@ array[
      'chest',
      'back',
      'shoulders',
      'biceps',
      'triceps',
      'forearms',
      'quadriceps',
      'hamstrings',
      'glutes',
      'calves',
      'core',
      'full_body',
      'cardio',
      'mobility',
      'rehabilitation',
      'other'
    ]::text[]
  );

alter table public.custom_exercises
  drop constraint if exists custom_exercises_equipment_check;
alter table public.custom_exercises
  add constraint custom_exercises_equipment_check
  check (
    equipment in (
      'barbell',
      'dumbbell',
      'cable',
      'machine',
      'plate_loaded_machine',
      'selectorised_machine',
      'selectorized_machine',
      'smith_machine',
      'bodyweight',
      'resistance_band',
      'kettlebell',
      'medicine_ball',
      'cardio_equipment',
      'other'
    )
  );

create index if not exists custom_exercises_aliases_gin_idx
  on public.custom_exercises using gin (aliases);

create index if not exists custom_exercises_search_keywords_gin_idx
  on public.custom_exercises using gin (search_keywords);

create table if not exists public.active_workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  source_template_id uuid,
  name text not null
    check (char_length(btrim(name)) between 1 and 120),
  notes text
    check (notes is null or char_length(notes) <= 8000),
  weight_unit text not null default 'kg'
    check (weight_unit in ('kg', 'lb')),
  started_at timestamptz not null,
  auto_start_rest_timer boolean not null default true,
  rest_timer_state text not null default 'idle'
    check (rest_timer_state in ('idle', 'running', 'paused', 'expired')),
  rest_timer_duration_seconds integer not null default 90
    check (rest_timer_duration_seconds between 0 and 86400),
  rest_timer_target_end_at timestamptz,
  rest_timer_remaining_seconds integer
    check (
      rest_timer_remaining_seconds is null
      or rest_timer_remaining_seconds between 0 and 86400
    ),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint active_workout_sessions_id_user_id_key unique (id, user_id),
  constraint active_workout_sessions_timer_state_check
    check (
      (
        rest_timer_state = 'running'
        and rest_timer_target_end_at is not null
        and rest_timer_remaining_seconds is null
      )
      or
      (
        rest_timer_state = 'paused'
        and rest_timer_target_end_at is null
        and rest_timer_remaining_seconds is not null
      )
      or
      (
        rest_timer_state in ('idle', 'expired')
        and rest_timer_target_end_at is null
        and rest_timer_remaining_seconds is null
      )
    )
);

create table if not exists public.active_workout_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  active_session_id uuid not null,
  exercise_source text not null
    check (exercise_source in ('system', 'custom')),
  system_exercise_key text
    check (
      system_exercise_key is null
      or char_length(btrim(system_exercise_key)) between 1 and 160
    ),
  custom_exercise_id uuid,
  exercise_key text not null
    check (char_length(btrim(exercise_key)) between 1 and 160),
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  primary_muscle_group text not null
    check (char_length(btrim(primary_muscle_group)) between 1 and 40),
  secondary_muscle_groups text[] not null default '{}'::text[]
    check (
      cardinality(secondary_muscle_groups) <= 16
      and array_position(secondary_muscle_groups, null) is null
    ),
  equipment text not null
    check (char_length(btrim(equipment)) between 1 and 40),
  tracking_type text not null default 'weight_and_repetitions'
    check (
      tracking_type in (
        'weight_and_repetitions',
        'repetitions',
        'duration',
        'distance_and_duration',
        'weight_and_distance',
        'weight_and_duration'
      )
    ),
  tracks_weight boolean not null default true,
  tracks_repetitions boolean not null default true,
  tracks_distance boolean not null default false,
  tracks_duration boolean not null default false,
  tracks_bodyweight boolean not null default false,
  planned_working_sets integer not null default 3
    check (planned_working_sets between 0 and 100),
  planned_warm_up_sets integer not null default 0
    check (planned_warm_up_sets between 0 and 100),
  min_target_reps integer
    check (min_target_reps is null or min_target_reps between 1 and 100000),
  max_target_reps integer
    check (max_target_reps is null or max_target_reps between 1 and 100000),
  target_weight_kg numeric(12, 3)
    check (
      target_weight_kg is null
      or target_weight_kg between 0 and 999999999.999
    ),
  rest_seconds integer not null default 90
    check (rest_seconds between 0 and 86400),
  rpe_target numeric(3, 1)
    check (rpe_target is null or rpe_target between 1 and 10),
  rir_target numeric(3, 1)
    check (rir_target is null or rir_target between 0 and 10),
  notes text
    check (notes is null or char_length(notes) <= 8000),
  sort_order integer not null default 0
    check (sort_order >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint active_workout_exercises_id_user_id_key unique (id, user_id),
  constraint active_workout_exercises_id_session_user_key
    unique (id, active_session_id, user_id),
  constraint active_workout_exercises_rep_range_check
    check (
      min_target_reps is null
      or max_target_reps is null
      or max_target_reps >= min_target_reps
    ),
  constraint active_workout_exercises_exactly_one_source_check
    check (
      (
        exercise_source = 'system'
        and system_exercise_key is not null
        and custom_exercise_id is null
        and exercise_key = system_exercise_key
      )
      or
      (
        exercise_source = 'custom'
        and system_exercise_key is null
        and custom_exercise_id is not null
        and exercise_key = custom_exercise_id::text
      )
    ),
  constraint active_workout_exercises_session_owner_fkey
    foreign key (active_session_id, user_id)
    references public.active_workout_sessions (id, user_id)
    on delete cascade
);

create table if not exists public.active_workout_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  active_exercise_id uuid not null,
  set_type text not null default 'working'
    check (set_type in ('warm_up', 'working', 'drop_set', 'failure_set')),
  weight_kg numeric(12, 3)
    check (weight_kg is null or weight_kg between 0 and 999999999.999),
  repetitions integer
    check (repetitions is null or repetitions between 0 and 100000),
  duration_seconds integer
    check (duration_seconds is null or duration_seconds between 0 and 604800),
  distance_meters numeric(14, 3)
    check (
      distance_meters is null
      or distance_meters between 0 and 99999999999.999
    ),
  rpe numeric(3, 1)
    check (rpe is null or rpe between 1 and 10),
  rir numeric(3, 1)
    check (rir is null or rir between 0 and 10),
  is_completed boolean not null default false,
  completed_at timestamptz,
  notes text
    check (notes is null or char_length(notes) <= 4000),
  set_order integer not null default 0
    check (set_order >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint active_workout_sets_id_user_id_key unique (id, user_id),
  constraint active_workout_sets_completion_check
    check (
      (is_completed and completed_at is not null)
      or (not is_completed and completed_at is null)
    ),
  constraint active_workout_sets_exercise_owner_fkey
    foreign key (active_exercise_id, user_id)
    references public.active_workout_exercises (id, user_id)
    on delete cascade
);

create table if not exists public.completed_workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  source_active_session_id uuid,
  source_template_id uuid,
  name text not null
    check (char_length(btrim(name)) between 1 and 120),
  notes text
    check (notes is null or char_length(notes) <= 8000),
  weight_unit text not null default 'kg'
    check (weight_unit in ('kg', 'lb')),
  started_at timestamptz not null,
  ended_at timestamptz not null,
  duration_seconds integer not null
    check (duration_seconds between 0 and 604800),
  exercise_count integer not null default 0
    check (exercise_count >= 0),
  working_set_count integer not null default 0
    check (working_set_count >= 0),
  completed_set_count integer not null default 0
    check (completed_set_count >= 0),
  total_repetitions bigint not null default 0
    check (total_repetitions >= 0),
  total_volume_kg numeric(18, 3) not null default 0
    check (total_volume_kg >= 0),
  personal_record_count integer not null default 0
    check (personal_record_count >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint completed_workout_sessions_id_user_id_key unique (id, user_id),
  constraint completed_workout_sessions_source_active_key
    unique (source_active_session_id, user_id),
  constraint completed_workout_sessions_time_check
    check (ended_at >= started_at),
  constraint completed_workout_sessions_set_totals_check
    check (working_set_count <= completed_set_count)
);

create table if not exists public.completed_workout_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  completed_session_id uuid not null,
  source_active_exercise_id uuid,
  exercise_source text not null
    check (exercise_source in ('system', 'custom')),
  system_exercise_key text
    check (
      system_exercise_key is null
      or char_length(btrim(system_exercise_key)) between 1 and 160
    ),
  custom_exercise_id uuid,
  exercise_key text not null
    check (char_length(btrim(exercise_key)) between 1 and 160),
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  primary_muscle_group text not null
    check (char_length(btrim(primary_muscle_group)) between 1 and 40),
  secondary_muscle_groups text[] not null default '{}'::text[]
    check (
      cardinality(secondary_muscle_groups) <= 16
      and array_position(secondary_muscle_groups, null) is null
    ),
  equipment text not null
    check (char_length(btrim(equipment)) between 1 and 40),
  tracking_type text not null default 'weight_and_repetitions'
    check (
      tracking_type in (
        'weight_and_repetitions',
        'repetitions',
        'duration',
        'distance_and_duration',
        'weight_and_distance',
        'weight_and_duration'
      )
    ),
  tracks_weight boolean not null default true,
  tracks_repetitions boolean not null default true,
  tracks_distance boolean not null default false,
  tracks_duration boolean not null default false,
  tracks_bodyweight boolean not null default false,
  notes text
    check (notes is null or char_length(notes) <= 8000),
  sort_order integer not null default 0
    check (sort_order >= 0),
  working_set_count integer not null default 0
    check (working_set_count >= 0),
  completed_set_count integer not null default 0
    check (completed_set_count >= 0),
  total_repetitions bigint not null default 0
    check (total_repetitions >= 0),
  total_volume_kg numeric(18, 3) not null default 0
    check (total_volume_kg >= 0),
  best_weight_kg numeric(12, 3)
    check (best_weight_kg is null or best_weight_kg >= 0),
  best_estimated_one_rep_max_kg numeric(18, 3)
    check (
      best_estimated_one_rep_max_kg is null
      or best_estimated_one_rep_max_kg >= 0
    ),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint completed_workout_exercises_id_user_id_key unique (id, user_id),
  constraint completed_workout_exercises_id_session_user_key
    unique (id, completed_session_id, user_id),
  constraint completed_workout_exercises_source_active_key
    unique (source_active_exercise_id, user_id),
  constraint completed_workout_exercises_set_totals_check
    check (working_set_count <= completed_set_count),
  constraint completed_workout_exercises_exactly_one_source_check
    check (
      (
        exercise_source = 'system'
        and system_exercise_key is not null
        and custom_exercise_id is null
        and exercise_key = system_exercise_key
      )
      or
      (
        exercise_source = 'custom'
        and system_exercise_key is null
        and custom_exercise_id is not null
        and exercise_key = custom_exercise_id::text
      )
    ),
  constraint completed_workout_exercises_session_owner_fkey
    foreign key (completed_session_id, user_id)
    references public.completed_workout_sessions (id, user_id)
    on delete cascade
);

create table if not exists public.completed_workout_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  completed_exercise_id uuid not null,
  source_active_set_id uuid,
  set_type text not null default 'working'
    check (set_type in ('warm_up', 'working', 'drop_set', 'failure_set')),
  weight_kg numeric(12, 3)
    check (weight_kg is null or weight_kg between 0 and 999999999.999),
  repetitions integer
    check (repetitions is null or repetitions between 0 and 100000),
  duration_seconds integer
    check (duration_seconds is null or duration_seconds between 0 and 604800),
  distance_meters numeric(14, 3)
    check (
      distance_meters is null
      or distance_meters between 0 and 99999999999.999
    ),
  rpe numeric(3, 1)
    check (rpe is null or rpe between 1 and 10),
  rir numeric(3, 1)
    check (rir is null or rir between 0 and 10),
  is_completed boolean not null default true,
  completed_at timestamptz,
  notes text
    check (notes is null or char_length(notes) <= 4000),
  set_order integer not null default 0
    check (set_order >= 0),
  set_volume_kg numeric(18, 3)
    check (
      set_volume_kg is null
      or (
        weight_kg is not null
        and repetitions is not null
        and set_volume_kg = round(weight_kg * repetitions, 3)
      )
    ),
  estimated_one_rep_max_kg numeric(18, 3)
    check (
      estimated_one_rep_max_kg is null
      or (
        weight_kg is not null
        and weight_kg > 0
        and repetitions is not null
        and repetitions > 0
        and estimated_one_rep_max_kg = round(
          weight_kg * (1 + repetitions::numeric / 30),
          3
        )
      )
    ),
  is_personal_record boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint completed_workout_sets_id_user_id_key unique (id, user_id),
  constraint completed_workout_sets_id_exercise_user_key
    unique (id, completed_exercise_id, user_id),
  constraint completed_workout_sets_source_active_key
    unique (source_active_set_id, user_id),
  constraint completed_workout_sets_completion_check
    check (
      (is_completed and completed_at is not null)
      or (not is_completed and completed_at is null)
    ),
  constraint completed_workout_sets_pr_eligibility_check
    check (
      not is_personal_record
      or (is_completed and set_type <> 'warm_up' and deleted_at is null)
    ),
  constraint completed_workout_sets_exercise_owner_fkey
    foreign key (completed_exercise_id, user_id)
    references public.completed_workout_exercises (id, user_id)
    on delete cascade
);

create table if not exists public.personal_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  exercise_source text not null
    check (exercise_source in ('system', 'custom')),
  system_exercise_key text
    check (
      system_exercise_key is null
      or char_length(btrim(system_exercise_key)) between 1 and 160
    ),
  custom_exercise_id uuid,
  exercise_key text not null
    check (char_length(btrim(exercise_key)) between 1 and 160),
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  record_kind text not null
    check (
      record_kind in (
        'heaviest_weight',
        'most_reps_at_weight',
        'estimated_1rm',
        'set_volume',
        'exercise_workout_volume'
      )
    ),
  record_scope text not null default 'overall'
    check (char_length(btrim(record_scope)) between 1 and 80),
  record_value numeric(18, 3) not null
    check (record_value > 0),
  weight_kg numeric(12, 3)
    check (weight_kg is null or weight_kg > 0),
  repetitions integer
    check (repetitions is null or repetitions > 0),
  estimated_one_rep_max_kg numeric(18, 3)
    check (
      estimated_one_rep_max_kg is null
      or estimated_one_rep_max_kg > 0
    ),
  set_volume_kg numeric(18, 3)
    check (set_volume_kg is null or set_volume_kg > 0),
  exercise_workout_volume_kg numeric(18, 3)
    check (
      exercise_workout_volume_kg is null
      or exercise_workout_volume_kg > 0
    ),
  calculation_formula text
    check (
      calculation_formula is null
      or char_length(calculation_formula) <= 160
    ),
  source_completed_session_id uuid not null,
  source_completed_exercise_id uuid not null,
  source_completed_set_id uuid,
  achieved_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint personal_records_id_user_id_key unique (id, user_id),
  constraint personal_records_current_identity_key
    unique (user_id, exercise_key, record_kind, record_scope),
  constraint personal_records_exactly_one_source_check
    check (
      (
        exercise_source = 'system'
        and system_exercise_key is not null
        and custom_exercise_id is null
        and exercise_key = system_exercise_key
      )
      or
      (
        exercise_source = 'custom'
        and system_exercise_key is null
        and custom_exercise_id is not null
        and exercise_key = custom_exercise_id::text
      )
    ),
  constraint personal_records_kind_values_check
    check (
      (
        record_kind = 'heaviest_weight'
        and weight_kg is not null
        and record_value = weight_kg
      )
      or
      (
        record_kind = 'most_reps_at_weight'
        and weight_kg is not null
        and repetitions is not null
        and record_value = repetitions
      )
      or
      (
        record_kind = 'estimated_1rm'
        and weight_kg is not null
        and repetitions is not null
        and estimated_one_rep_max_kg is not null
        and record_value = estimated_one_rep_max_kg
        and estimated_one_rep_max_kg = round(
          weight_kg * (1 + repetitions::numeric / 30),
          3
        )
        and calculation_formula = 'epley: weight_kg * (1 + repetitions / 30)'
      )
      or
      (
        record_kind = 'set_volume'
        and set_volume_kg is not null
        and record_value = set_volume_kg
      )
      or
      (
        record_kind = 'exercise_workout_volume'
        and exercise_workout_volume_kg is not null
        and record_value = exercise_workout_volume_kg
      )
    ),
  constraint personal_records_scope_check
    check (
      (
        record_kind = 'most_reps_at_weight'
        and weight_kg is not null
        and record_scope = 'weight_kg:' || weight_kg::text
      )
      or
      (
        record_kind <> 'most_reps_at_weight'
        and record_scope = 'overall'
      )
    ),
  constraint personal_records_set_source_check
    check (
      record_kind = 'exercise_workout_volume'
      or source_completed_set_id is not null
    ),
  constraint personal_records_completed_exercise_owner_fkey
    foreign key (
      source_completed_exercise_id,
      source_completed_session_id,
      user_id
    )
    references public.completed_workout_exercises (
      id,
      completed_session_id,
      user_id
    )
    on delete no action
    deferrable initially deferred,
  constraint personal_records_completed_set_owner_fkey
    foreign key (
      source_completed_set_id,
      source_completed_exercise_id,
      user_id
    )
    references public.completed_workout_sets (
      id,
      completed_exercise_id,
      user_id
    )
    on delete no action
    deferrable initially deferred
);

create table if not exists public.personal_record_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  personal_record_id uuid not null,
  -- The client derives event_key from the exercise key, record kind,
  -- record_scope, and completed source identifiers. Stable inputs make retry
  -- upserts deterministic while this owner-scoped unique key prevents dupes.
  event_key text not null
    check (char_length(btrim(event_key)) between 1 and 240),
  exercise_source text not null
    check (exercise_source in ('system', 'custom')),
  exercise_key text not null
    check (char_length(btrim(exercise_key)) between 1 and 160),
  system_exercise_key text,
  custom_exercise_id uuid,
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  record_kind text not null
    check (
      record_kind in (
        'heaviest_weight',
        'most_reps_at_weight',
        'estimated_1rm',
        'set_volume',
        'exercise_workout_volume'
      )
    ),
  record_scope text not null default 'overall'
    check (char_length(btrim(record_scope)) between 1 and 80),
  previous_record_value numeric(18, 3)
    check (previous_record_value is null or previous_record_value > 0),
  new_record_value numeric(18, 3) not null
    check (new_record_value > 0),
  weight_kg numeric(12, 3)
    check (weight_kg is null or weight_kg > 0),
  repetitions integer
    check (repetitions is null or repetitions > 0),
  estimated_one_rep_max_kg numeric(18, 3)
    check (
      estimated_one_rep_max_kg is null
      or estimated_one_rep_max_kg > 0
    ),
  set_volume_kg numeric(18, 3)
    check (set_volume_kg is null or set_volume_kg > 0),
  exercise_workout_volume_kg numeric(18, 3)
    check (
      exercise_workout_volume_kg is null
      or exercise_workout_volume_kg > 0
    ),
  calculation_formula text
    check (
      calculation_formula is null
      or char_length(calculation_formula) <= 160
    ),
  source_completed_session_id uuid not null,
  source_completed_exercise_id uuid not null,
  source_completed_set_id uuid,
  achieved_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint personal_record_events_id_user_id_key unique (id, user_id),
  constraint personal_record_events_dedupe_key unique (user_id, event_key),
  constraint personal_record_events_exactly_one_source_check
    check (
      (
        exercise_source = 'system'
        and system_exercise_key is not null
        and custom_exercise_id is null
        and exercise_key = system_exercise_key
      )
      or
      (
        exercise_source = 'custom'
        and system_exercise_key is null
        and custom_exercise_id is not null
        and exercise_key = custom_exercise_id::text
      )
    ),
  constraint personal_record_events_scope_check
    check (
      (
        record_kind = 'most_reps_at_weight'
        and weight_kg is not null
        and record_scope = 'weight_kg:' || weight_kg::text
      )
      or
      (
        record_kind <> 'most_reps_at_weight'
        and record_scope = 'overall'
      )
    ),
  constraint personal_record_events_record_owner_fkey
    foreign key (personal_record_id, user_id)
    references public.personal_records (id, user_id)
    on delete no action
    deferrable initially deferred,
  constraint personal_record_events_completed_exercise_owner_fkey
    foreign key (
      source_completed_exercise_id,
      source_completed_session_id,
      user_id
    )
    references public.completed_workout_exercises (
      id,
      completed_session_id,
      user_id
    )
    on delete no action
    deferrable initially deferred,
  constraint personal_record_events_completed_set_owner_fkey
    foreign key (
      source_completed_set_id,
      source_completed_exercise_id,
      user_id
    )
    references public.completed_workout_sets (
      id,
      completed_exercise_id,
      user_id
    )
    on delete no action
    deferrable initially deferred
);

-- Reject stale and duplicate device versions atomically. The accepted cloud
-- row is the conflict winner and keeps its original creation timestamp.
create or replace function public.guard_stage_3_version()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  if new.version <= old.version then
    return null;
  end if;
  new.created_at := old.created_at;
  return new;
end;
$$;

create unique index if not exists active_workout_sessions_one_open_idx
  on public.active_workout_sessions (user_id)
  where deleted_at is null;

create index if not exists active_workout_sessions_user_updated_idx
  on public.active_workout_sessions (user_id, updated_at, id);

create index if not exists active_workout_exercises_active_order_idx
  on public.active_workout_exercises (
    user_id,
    active_session_id,
    sort_order,
    id
  )
  where deleted_at is null;

create index if not exists active_workout_exercises_user_updated_idx
  on public.active_workout_exercises (user_id, updated_at, id);

create index if not exists active_workout_sets_active_order_idx
  on public.active_workout_sets (
    user_id,
    active_exercise_id,
    set_order,
    id
  )
  where deleted_at is null;

create index if not exists active_workout_sets_user_updated_idx
  on public.active_workout_sets (user_id, updated_at, id);

create index if not exists completed_workout_sessions_history_idx
  on public.completed_workout_sessions (user_id, ended_at desc, id)
  where deleted_at is null;

create index if not exists completed_workout_sessions_search_idx
  on public.completed_workout_sessions (user_id, lower(name), ended_at desc)
  where deleted_at is null;

create index if not exists completed_workout_sessions_user_updated_idx
  on public.completed_workout_sessions (user_id, updated_at, id);

create index if not exists completed_workout_exercises_session_order_idx
  on public.completed_workout_exercises (
    user_id,
    completed_session_id,
    sort_order,
    id
  )
  where deleted_at is null;

create index if not exists completed_workout_exercises_previous_idx
  on public.completed_workout_exercises (
    user_id,
    exercise_key,
    completed_session_id
  )
  where deleted_at is null;

create index if not exists completed_workout_exercises_user_updated_idx
  on public.completed_workout_exercises (user_id, updated_at, id);

create index if not exists completed_workout_sets_exercise_order_idx
  on public.completed_workout_sets (
    user_id,
    completed_exercise_id,
    set_order,
    id
  )
  where deleted_at is null;

create index if not exists completed_workout_sets_completed_idx
  on public.completed_workout_sets (
    user_id,
    completed_exercise_id,
    is_completed,
    completed_at desc
  )
  where deleted_at is null;

create index if not exists completed_workout_sets_user_updated_idx
  on public.completed_workout_sets (user_id, updated_at, id);

create index if not exists personal_records_current_idx
  on public.personal_records (
    user_id,
    exercise_key,
    record_kind,
    record_scope,
    achieved_at desc
  )
  where deleted_at is null;

create index if not exists personal_records_user_updated_idx
  on public.personal_records (user_id, updated_at, id);

create index if not exists personal_record_events_history_idx
  on public.personal_record_events (
    user_id,
    exercise_key,
    record_kind,
    record_scope,
    achieved_at desc,
    id
  )
  where deleted_at is null;

create index if not exists personal_record_events_user_updated_idx
  on public.personal_record_events (user_id, updated_at, id);

-- Version guards run first because PostgreSQL orders same-time triggers by
-- trigger name. Updated-at triggers run only for accepted newer versions.
drop trigger if exists a_active_workout_sessions_guard_version
  on public.active_workout_sessions;
create trigger a_active_workout_sessions_guard_version
before update on public.active_workout_sessions
for each row execute function public.guard_stage_3_version();

drop trigger if exists active_workout_sessions_set_updated_at
  on public.active_workout_sessions;
create trigger active_workout_sessions_set_updated_at
before update on public.active_workout_sessions
for each row execute function public.set_updated_at();

drop trigger if exists a_active_workout_exercises_guard_version
  on public.active_workout_exercises;
create trigger a_active_workout_exercises_guard_version
before update on public.active_workout_exercises
for each row execute function public.guard_stage_3_version();

drop trigger if exists active_workout_exercises_set_updated_at
  on public.active_workout_exercises;
create trigger active_workout_exercises_set_updated_at
before update on public.active_workout_exercises
for each row execute function public.set_updated_at();

drop trigger if exists a_active_workout_sets_guard_version
  on public.active_workout_sets;
create trigger a_active_workout_sets_guard_version
before update on public.active_workout_sets
for each row execute function public.guard_stage_3_version();

drop trigger if exists active_workout_sets_set_updated_at
  on public.active_workout_sets;
create trigger active_workout_sets_set_updated_at
before update on public.active_workout_sets
for each row execute function public.set_updated_at();

drop trigger if exists a_completed_workout_sessions_guard_version
  on public.completed_workout_sessions;
create trigger a_completed_workout_sessions_guard_version
before update on public.completed_workout_sessions
for each row execute function public.guard_stage_3_version();

drop trigger if exists completed_workout_sessions_set_updated_at
  on public.completed_workout_sessions;
create trigger completed_workout_sessions_set_updated_at
before update on public.completed_workout_sessions
for each row execute function public.set_updated_at();

drop trigger if exists a_completed_workout_exercises_guard_version
  on public.completed_workout_exercises;
create trigger a_completed_workout_exercises_guard_version
before update on public.completed_workout_exercises
for each row execute function public.guard_stage_3_version();

drop trigger if exists completed_workout_exercises_set_updated_at
  on public.completed_workout_exercises;
create trigger completed_workout_exercises_set_updated_at
before update on public.completed_workout_exercises
for each row execute function public.set_updated_at();

drop trigger if exists a_completed_workout_sets_guard_version
  on public.completed_workout_sets;
create trigger a_completed_workout_sets_guard_version
before update on public.completed_workout_sets
for each row execute function public.guard_stage_3_version();

drop trigger if exists completed_workout_sets_set_updated_at
  on public.completed_workout_sets;
create trigger completed_workout_sets_set_updated_at
before update on public.completed_workout_sets
for each row execute function public.set_updated_at();

drop trigger if exists a_personal_records_guard_version
  on public.personal_records;
create trigger a_personal_records_guard_version
before update on public.personal_records
for each row execute function public.guard_stage_3_version();

drop trigger if exists personal_records_set_updated_at
  on public.personal_records;
create trigger personal_records_set_updated_at
before update on public.personal_records
for each row execute function public.set_updated_at();

drop trigger if exists a_personal_record_events_guard_version
  on public.personal_record_events;
create trigger a_personal_record_events_guard_version
before update on public.personal_record_events
for each row execute function public.guard_stage_3_version();

drop trigger if exists personal_record_events_set_updated_at
  on public.personal_record_events;
create trigger personal_record_events_set_updated_at
before update on public.personal_record_events
for each row execute function public.set_updated_at();

alter table public.active_workout_sessions enable row level security;
alter table public.active_workout_sessions force row level security;
alter table public.active_workout_exercises enable row level security;
alter table public.active_workout_exercises force row level security;
alter table public.active_workout_sets enable row level security;
alter table public.active_workout_sets force row level security;
alter table public.completed_workout_sessions enable row level security;
alter table public.completed_workout_sessions force row level security;
alter table public.completed_workout_exercises enable row level security;
alter table public.completed_workout_exercises force row level security;
alter table public.completed_workout_sets enable row level security;
alter table public.completed_workout_sets force row level security;
alter table public.personal_records enable row level security;
alter table public.personal_records force row level security;
alter table public.personal_record_events enable row level security;
alter table public.personal_record_events force row level security;

drop policy if exists "active_workout_sessions_select_own"
  on public.active_workout_sessions;
create policy "active_workout_sessions_select_own"
on public.active_workout_sessions for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sessions_insert_own"
  on public.active_workout_sessions;
create policy "active_workout_sessions_insert_own"
on public.active_workout_sessions for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sessions_update_own"
  on public.active_workout_sessions;
create policy "active_workout_sessions_update_own"
on public.active_workout_sessions for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sessions_delete_own"
  on public.active_workout_sessions;
create policy "active_workout_sessions_delete_own"
on public.active_workout_sessions for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "active_workout_exercises_select_own"
  on public.active_workout_exercises;
create policy "active_workout_exercises_select_own"
on public.active_workout_exercises for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "active_workout_exercises_insert_own"
  on public.active_workout_exercises;
create policy "active_workout_exercises_insert_own"
on public.active_workout_exercises for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_exercises_update_own"
  on public.active_workout_exercises;
create policy "active_workout_exercises_update_own"
on public.active_workout_exercises for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_exercises_delete_own"
  on public.active_workout_exercises;
create policy "active_workout_exercises_delete_own"
on public.active_workout_exercises for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sets_select_own"
  on public.active_workout_sets;
create policy "active_workout_sets_select_own"
on public.active_workout_sets for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sets_insert_own"
  on public.active_workout_sets;
create policy "active_workout_sets_insert_own"
on public.active_workout_sets for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sets_update_own"
  on public.active_workout_sets;
create policy "active_workout_sets_update_own"
on public.active_workout_sets for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "active_workout_sets_delete_own"
  on public.active_workout_sets;
create policy "active_workout_sets_delete_own"
on public.active_workout_sets for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sessions_select_own"
  on public.completed_workout_sessions;
create policy "completed_workout_sessions_select_own"
on public.completed_workout_sessions for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sessions_insert_own"
  on public.completed_workout_sessions;
create policy "completed_workout_sessions_insert_own"
on public.completed_workout_sessions for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sessions_update_own"
  on public.completed_workout_sessions;
create policy "completed_workout_sessions_update_own"
on public.completed_workout_sessions for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sessions_delete_own"
  on public.completed_workout_sessions;
create policy "completed_workout_sessions_delete_own"
on public.completed_workout_sessions for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_exercises_select_own"
  on public.completed_workout_exercises;
create policy "completed_workout_exercises_select_own"
on public.completed_workout_exercises for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_exercises_insert_own"
  on public.completed_workout_exercises;
create policy "completed_workout_exercises_insert_own"
on public.completed_workout_exercises for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_exercises_update_own"
  on public.completed_workout_exercises;
create policy "completed_workout_exercises_update_own"
on public.completed_workout_exercises for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_exercises_delete_own"
  on public.completed_workout_exercises;
create policy "completed_workout_exercises_delete_own"
on public.completed_workout_exercises for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sets_select_own"
  on public.completed_workout_sets;
create policy "completed_workout_sets_select_own"
on public.completed_workout_sets for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sets_insert_own"
  on public.completed_workout_sets;
create policy "completed_workout_sets_insert_own"
on public.completed_workout_sets for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sets_update_own"
  on public.completed_workout_sets;
create policy "completed_workout_sets_update_own"
on public.completed_workout_sets for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "completed_workout_sets_delete_own"
  on public.completed_workout_sets;
create policy "completed_workout_sets_delete_own"
on public.completed_workout_sets for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "personal_records_select_own"
  on public.personal_records;
create policy "personal_records_select_own"
on public.personal_records for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "personal_records_insert_own"
  on public.personal_records;
create policy "personal_records_insert_own"
on public.personal_records for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "personal_records_update_own"
  on public.personal_records;
create policy "personal_records_update_own"
on public.personal_records for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "personal_records_delete_own"
  on public.personal_records;
create policy "personal_records_delete_own"
on public.personal_records for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "personal_record_events_select_own"
  on public.personal_record_events;
create policy "personal_record_events_select_own"
on public.personal_record_events for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "personal_record_events_insert_own"
  on public.personal_record_events;
create policy "personal_record_events_insert_own"
on public.personal_record_events for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "personal_record_events_update_own"
  on public.personal_record_events;
create policy "personal_record_events_update_own"
on public.personal_record_events for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "personal_record_events_delete_own"
  on public.personal_record_events;
create policy "personal_record_events_delete_own"
on public.personal_record_events for delete
to authenticated
using ((select auth.uid()) = user_id);

revoke all on table public.active_workout_sessions from public, anon;
revoke all on table public.active_workout_exercises from public, anon;
revoke all on table public.active_workout_sets from public, anon;
revoke all on table public.completed_workout_sessions from public, anon;
revoke all on table public.completed_workout_exercises from public, anon;
revoke all on table public.completed_workout_sets from public, anon;
revoke all on table public.personal_records from public, anon;
revoke all on table public.personal_record_events from public, anon;

grant select, insert, update, delete
  on table public.active_workout_sessions to authenticated;
grant select, insert, update, delete
  on table public.active_workout_exercises to authenticated;
grant select, insert, update, delete
  on table public.active_workout_sets to authenticated;
grant select, insert, update, delete
  on table public.completed_workout_sessions to authenticated;
grant select, insert, update, delete
  on table public.completed_workout_exercises to authenticated;
grant select, insert, update, delete
  on table public.completed_workout_sets to authenticated;
grant select, insert, update, delete
  on table public.personal_records to authenticated;
grant select, insert, update, delete
  on table public.personal_record_events to authenticated;
