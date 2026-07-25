-- ForgeFit template exercise catalogue compatibility.
--
-- Stage 3 expanded custom_exercises, but template_exercises retained the
-- older Stage 2 category checks. Keep the detailed catalogue categories
-- rather than flattening them to machine/other.

alter table public.template_exercises
  drop constraint if exists template_exercises_primary_muscle_group_check;
alter table public.template_exercises
  add constraint template_exercises_primary_muscle_group_check
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

alter table public.template_exercises
  drop constraint if exists template_exercises_equipment_check;
alter table public.template_exercises
  add constraint template_exercises_equipment_check
  check (
    equipment in (
      'barbell',
      'dumbbell',
      'cable',
      'machine',
      'plate_loaded_machine',
      'selectorised_machine',
      'smith_machine',
      'bodyweight',
      'resistance_band',
      'kettlebell',
      'medicine_ball',
      'cardio_equipment',
      'other'
    )
  );
