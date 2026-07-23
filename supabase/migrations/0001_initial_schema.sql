-- ForgeFit initial Supabase schema.
-- Apply with `supabase db push` from the project root, or run this entire file
-- in the Supabase SQL editor. The mobile app must use a publishable/anon key,
-- never the service_role key.

create extension if not exists pgcrypto with schema extensions;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.profiles (
  id uuid primary key default auth.uid(),
  user_id uuid not null unique default auth.uid()
    references auth.users (id) on delete cascade,
  display_name text not null
    check (char_length(btrim(display_name)) between 1 and 80),
  preferred_weight_unit text not null default 'kg'
    check (preferred_weight_unit in ('kg', 'lb')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint profiles_id_matches_user_id check (id = user_id)
);

create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  exercise_name text not null
    check (char_length(btrim(exercise_name)) between 1 and 120),
  performed_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint workouts_id_user_id_key unique (id, user_id)
);

create table if not exists public.workout_sets (
  id uuid primary key default gen_random_uuid(),
  workout_id uuid not null,
  user_id uuid not null references auth.users (id) on delete cascade,
  weight numeric(10, 3) not null check (weight >= 0),
  reps integer not null check (reps > 0),
  set_order integer not null default 1 check (set_order > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint workout_sets_workout_owner_fkey
    foreign key (workout_id, user_id)
    references public.workouts (id, user_id)
    on delete cascade,
  constraint workout_sets_workout_order_key unique (workout_id, set_order)
);

-- Registration can complete before the client receives a session when email
-- confirmation is enabled. Create the profile from trusted auth metadata so
-- the onboarding name and unit are present as soon as that user first logs in.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  requested_unit text;
  requested_name text;
begin
  requested_unit := case
    when new.raw_user_meta_data ->> 'preferred_weight_unit' = 'lb' then 'lb'
    else 'kg'
  end;
  requested_name := coalesce(
    nullif(btrim(new.raw_user_meta_data ->> 'display_name'), ''),
    nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
    'ForgeFit athlete'
  );

  insert into public.profiles (
    id,
    user_id,
    display_name,
    preferred_weight_unit
  ) values (
    new.id,
    new.id,
    left(requested_name, 80),
    requested_unit
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create index if not exists workouts_user_performed_at_idx
  on public.workouts (user_id, performed_at desc);

create index if not exists workout_sets_user_workout_idx
  on public.workout_sets (user_id, workout_id);

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists workouts_set_updated_at on public.workouts;
create trigger workouts_set_updated_at
before update on public.workouts
for each row execute function public.set_updated_at();

drop trigger if exists workout_sets_set_updated_at on public.workout_sets;
create trigger workout_sets_set_updated_at
before update on public.workout_sets
for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.profiles force row level security;
alter table public.workouts enable row level security;
alter table public.workouts force row level security;
alter table public.workout_sets enable row level security;
alter table public.workout_sets force row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own"
on public.profiles for insert
to authenticated
with check ((select auth.uid()) = user_id and id = user_id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id and id = user_id);

drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_delete_own"
on public.profiles for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workouts_select_own" on public.workouts;
create policy "workouts_select_own"
on public.workouts for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workouts_insert_own" on public.workouts;
create policy "workouts_insert_own"
on public.workouts for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "workouts_update_own" on public.workouts;
create policy "workouts_update_own"
on public.workouts for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "workouts_delete_own" on public.workouts;
create policy "workouts_delete_own"
on public.workouts for delete
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workout_sets_select_own" on public.workout_sets;
create policy "workout_sets_select_own"
on public.workout_sets for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "workout_sets_insert_own" on public.workout_sets;
create policy "workout_sets_insert_own"
on public.workout_sets for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_sets_update_own" on public.workout_sets;
create policy "workout_sets_update_own"
on public.workout_sets for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "workout_sets_delete_own" on public.workout_sets;
create policy "workout_sets_delete_own"
on public.workout_sets for delete
to authenticated
using ((select auth.uid()) = user_id);

revoke all on table public.profiles from public, anon;
revoke all on table public.workouts from public, anon;
revoke all on table public.workout_sets from public, anon;

grant select, insert, update, delete on table public.profiles to authenticated;
grant select, insert, update, delete on table public.workouts to authenticated;
grant select, insert, update, delete on table public.workout_sets to authenticated;
