-- ForgeFit Stage 2 workout-planning schema.
-- Apply after 0001_initial_schema.sql. Splits are optional organisational
-- folders only; templates may always use a null split_id.

create table if not exists public.workout_splits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null
    check (char_length(btrim(name)) between 1 and 100),
  description text
    check (description is null or char_length(description) <= 1000),
  icon text not null default '📁'
    check (char_length(btrim(icon)) between 1 and 16),
  color_value bigint not null default 4279667711
    check (color_value between 0 and 4294967295),
  sort_order integer not null default 0
    check (sort_order >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint workout_splits_id_user_id_key unique (id, user_id)
);

create table if not exists public.workout_templates (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  split_id uuid,
  name text not null
    check (char_length(btrim(name)) between 1 and 100),
  icon text not null default '🏋️'
    check (char_length(btrim(icon)) between 1 and 16),
  color_value bigint not null default 4279667711
    check (color_value between 0 and 4294967295),
  notes text
    check (notes is null or char_length(notes) <= 4000),
  sort_order integer not null default 0
    check (sort_order >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint workout_templates_id_user_id_key unique (id, user_id),
  constraint workout_templates_split_owner_fkey
    foreign key (split_id, user_id)
    references public.workout_splits (id, user_id)
    on delete no action
    deferrable initially deferred
);

create table if not exists public.custom_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  name text not null
    check (char_length(btrim(name)) between 1 and 120),
  primary_muscle_group text not null
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
        'other'
      )
    ),
  secondary_muscle_groups text[] not null default '{}'::text[]
    check (
      cardinality(secondary_muscle_groups) <= 14
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
        'other'
      ]::text[]
    ),
  equipment text not null
    check (
      equipment in (
        'barbell',
        'dumbbell',
        'cable',
        'machine',
        'smith_machine',
        'bodyweight',
        'resistance_band',
        'cardio_equipment',
        'other'
      )
    ),
  instructions text
    check (instructions is null or char_length(instructions) <= 8000),
  personal_notes text
    check (personal_notes is null or char_length(personal_notes) <= 4000),
  is_favourite boolean not null default false,
  last_used_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint custom_exercises_id_user_id_key unique (id, user_id)
);

create table if not exists public.template_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  template_id uuid not null,
  exercise_source text not null
    check (exercise_source in ('system', 'custom')),
  system_exercise_key text
    check (
      system_exercise_key is null
      or char_length(btrim(system_exercise_key)) between 1 and 160
    ),
  custom_exercise_id uuid,
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  primary_muscle_group text not null
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
        'other'
      )
    ),
  equipment text not null
    check (
      equipment in (
        'barbell',
        'dumbbell',
        'cable',
        'machine',
        'smith_machine',
        'bodyweight',
        'resistance_band',
        'cardio_equipment',
        'other'
      )
    ),
  working_sets integer not null default 3
    check (working_sets between 1 and 100),
  warm_up_sets integer not null default 0
    check (warm_up_sets between 0 and 100),
  min_target_reps integer not null default 8
    check (min_target_reps between 1 and 1000),
  max_target_reps integer not null default 12,
  target_weight numeric(10, 3)
    check (
      target_weight is null
      or target_weight between 0 and 9999999.999
    ),
  rest_seconds integer not null default 90
    check (rest_seconds between 0 and 7200),
  rpe_target numeric(3, 1)
    check (rpe_target is null or rpe_target between 1 and 10),
  rir_target numeric(3, 1)
    check (rir_target is null or rir_target between 0 and 10),
  notes text
    check (notes is null or char_length(notes) <= 4000),
  sort_order integer not null default 0
    check (sort_order >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 1
    check (version > 0),
  constraint template_exercises_id_user_id_key unique (id, user_id),
  constraint template_exercises_rep_range_check
    check (
      max_target_reps between min_target_reps and 1000
    ),
  constraint template_exercises_exactly_one_source_check
    check (
      (
        exercise_source = 'system'
        and system_exercise_key is not null
        and custom_exercise_id is null
      )
      or
      (
        exercise_source = 'custom'
        and system_exercise_key is null
        and custom_exercise_id is not null
      )
    ),
  constraint template_exercises_template_owner_fkey
    foreign key (template_id, user_id)
    references public.workout_templates (id, user_id)
    on delete cascade,
  constraint template_exercises_custom_exercise_owner_fkey
    foreign key (custom_exercise_id, user_id)
    references public.custom_exercises (id, user_id)
    on delete no action
    deferrable initially deferred
);

-- Device-generated versions are the conflict boundary. A stale or duplicate
-- retry is ignored atomically; the client then reads and adopts the cloud
-- winner returned by the same RLS-protected table.
create or replace function public.guard_planning_version()
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

drop trigger if exists a_workout_splits_guard_version
  on public.workout_splits;
create trigger a_workout_splits_guard_version
before update on public.workout_splits
for each row execute function public.guard_planning_version();

drop trigger if exists a_workout_templates_guard_version
  on public.workout_templates;
create trigger a_workout_templates_guard_version
before update on public.workout_templates
for each row execute function public.guard_planning_version();

drop trigger if exists a_custom_exercises_guard_version
  on public.custom_exercises;
create trigger a_custom_exercises_guard_version
before update on public.custom_exercises
for each row execute function public.guard_planning_version();

drop trigger if exists a_template_exercises_guard_version
  on public.template_exercises;
create trigger a_template_exercises_guard_version
before update on public.template_exercises
for each row execute function public.guard_planning_version();

create index if not exists workout_splits_active_order_idx
  on public.workout_splits (user_id, sort_order, id)
  where deleted_at is null;

create index if not exists workout_splits_user_updated_idx
  on public.workout_splits (user_id, updated_at);

create index if not exists workout_templates_active_split_order_idx
  on public.workout_templates (user_id, split_id, sort_order, id)
  where deleted_at is null;

create index if not exists workout_templates_user_updated_idx
  on public.workout_templates (user_id, updated_at);

create index if not exists custom_exercises_active_name_idx
  on public.custom_exercises (user_id, lower(name))
  where deleted_at is null;

create index if not exists custom_exercises_active_filters_idx
  on public.custom_exercises (user_id, primary_muscle_group, equipment)
  where deleted_at is null;

create index if not exists custom_exercises_user_updated_idx
  on public.custom_exercises (user_id, updated_at);

create index if not exists template_exercises_active_order_idx
  on public.template_exercises (user_id, template_id, sort_order, id)
  where deleted_at is null;

create index if not exists template_exercises_user_updated_idx
  on public.template_exercises (user_id, updated_at);

drop trigger if exists workout_splits_set_updated_at
  on public.workout_splits;
create trigger workout_splits_set_updated_at
before update on public.workout_splits
for each row execute function public.set_updated_at();

drop trigger if exists workout_templates_set_updated_at
  on public.workout_templates;
create trigger workout_templates_set_updated_at
before update on public.workout_templates
for each row execute function public.set_updated_at();

drop trigger if exists custom_exercises_set_updated_at
  on public.custom_exercises;
create trigger custom_exercises_set_updated_at
before update on public.custom_exercises
for each row execute function public.set_updated_at();

drop trigger if exists template_exercises_set_updated_at
  on public.template_exercises;
create trigger template_exercises_set_updated_at
before update on public.template_exercises
for each row execute function public.set_updated_at();

alter table public.workout_splits enable row level security;
alter table public.workout_splits force row level security;
alter table public.workout_templates enable row level security;
alter table public.workout_templates force row level security;
alter table public.custom_exercises enable row level security;
alter table public.custom_exercises force row level security;
alter table public.template_exercises enable row level security;
alter table public.template_exercises force row level security;

drop policy if exists "workout_splits_select_own"
  on public.workout_splits;
create policy "workout_splits_select_own"
on public.workout_splits for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workout_splits_insert_own"
  on public.workout_splits;
create policy "workout_splits_insert_own"
on public.workout_splits for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_splits_update_own"
  on public.workout_splits;
create policy "workout_splits_update_own"
on public.workout_splits for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_splits_delete_own"
  on public.workout_splits;
create policy "workout_splits_delete_own"
on public.workout_splits for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workout_templates_select_own"
  on public.workout_templates;
create policy "workout_templates_select_own"
on public.workout_templates for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workout_templates_insert_own"
  on public.workout_templates;
create policy "workout_templates_insert_own"
on public.workout_templates for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_templates_update_own"
  on public.workout_templates;
create policy "workout_templates_update_own"
on public.workout_templates for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_templates_delete_own"
  on public.workout_templates;
create policy "workout_templates_delete_own"
on public.workout_templates for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "custom_exercises_select_own"
  on public.custom_exercises;
create policy "custom_exercises_select_own"
on public.custom_exercises for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "custom_exercises_insert_own"
  on public.custom_exercises;
create policy "custom_exercises_insert_own"
on public.custom_exercises for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "custom_exercises_update_own"
  on public.custom_exercises;
create policy "custom_exercises_update_own"
on public.custom_exercises for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "custom_exercises_delete_own"
  on public.custom_exercises;
create policy "custom_exercises_delete_own"
on public.custom_exercises for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "template_exercises_select_own"
  on public.template_exercises;
create policy "template_exercises_select_own"
on public.template_exercises for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "template_exercises_insert_own"
  on public.template_exercises;
create policy "template_exercises_insert_own"
on public.template_exercises for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "template_exercises_update_own"
  on public.template_exercises;
create policy "template_exercises_update_own"
on public.template_exercises for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "template_exercises_delete_own"
  on public.template_exercises;
create policy "template_exercises_delete_own"
on public.template_exercises for delete
to authenticated
using ((select auth.uid()) = user_id);

revoke all on table public.workout_splits from public, anon;
revoke all on table public.workout_templates from public, anon;
revoke all on table public.custom_exercises from public, anon;
revoke all on table public.template_exercises from public, anon;

grant select, insert, update, delete
  on table public.workout_splits to authenticated;
grant select, insert, update, delete
  on table public.workout_templates to authenticated;
grant select, insert, update, delete
  on table public.custom_exercises to authenticated;
grant select, insert, update, delete
  on table public.template_exercises to authenticated;
