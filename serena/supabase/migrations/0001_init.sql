-- ============================================================
-- Serena / Floréa — Migrasi Awal Supabase (PostgreSQL)
-- Jalankan via SQL Editor (New query) atau `supabase db push`.
-- Wellness/Kesehatan dihapus (mood_logs, sleep_logs, habits, habit_logs).
-- ============================================================

-- 0. Setup -----------------------------------------------------
create extension if not exists "pgcrypto";

create type task_priority as enum ('low','medium','high','urgent');
create type task_status as enum ('pending','in_progress','completed','cancelled');
create type focus_mode as enum ('pomodoro','deep_focus','exam_mode');
create type focus_status as enum ('active','paused','completed','cancelled');
create type notification_type as enum ('task','deadline','focus_break');

create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

-- 1. profiles ---------------------------------------------------
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  avatar_url text,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists trg_profiles_updated on profiles;
create trigger trg_profiles_updated before update on profiles
  for each row execute function set_updated_at();

alter table profiles enable row level security;
create policy "profiles_owner" on profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

-- 1a. Auto-create profile saat user mendaftar (via Auth trigger).
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 2. user_goals -------------------------------------------------
create table user_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  target_date date,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_user_goals_user on user_goals(user_id);
alter table user_goals enable row level security;
create policy "user_goals_owner" on user_goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 3. task_categories --------------------------------------------
create table task_categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text,
  icon text,
  created_at timestamptz not null default now()
);
create index idx_task_categories_user on task_categories(user_id);
alter table task_categories enable row level security;
create policy "task_categories_owner" on task_categories
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 4. tasks ------------------------------------------------------
create table tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid references task_categories(id) on delete set null,
  title text not null,
  description text,
  deadline timestamptz,
  priority task_priority not null default 'medium',
  status task_status not null default 'pending',
  progress int not null default 0 check (progress between 0 and 100),
  reminder_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_tasks_user_deadline on tasks(user_id, deadline);
create index idx_tasks_user_status on tasks(user_id, status);
alter table tasks enable row level security;
create policy "tasks_owner" on tasks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 5. focus_sessions ---------------------------------------------
create table focus_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode focus_mode not null default 'pomodoro',
  planned_minutes int not null check (planned_minutes > 0),
  actual_minutes int,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  status focus_status not null default 'active',
  note text
);
create index idx_focus_user_time on focus_sessions(user_id, started_at desc);
alter table focus_sessions enable row level security;
create policy "focus_owner" on focus_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 6. notifications ----------------------------------------------
create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type notification_type not null,
  title text not null,
  body text,
  scheduled_for timestamptz,
  is_read boolean not null default false,
  related_id uuid,
  created_at timestamptz not null default now()
);
create index idx_notifications_user_sched on notifications(user_id, scheduled_for);
alter table notifications enable row level security;
create policy "notifications_owner" on notifications
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 7. achievements ----------------------------------------------
create table achievements (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text,
  icon text,
  criteria jsonb not null default '{}'
);

create table user_achievements (
  user_id uuid not null references auth.users(id) on delete cascade,
  achievement_id uuid not null references achievements(id) on delete cascade,
  progress int not null default 0,
  unlocked_at timestamptz,
  primary key (user_id, achievement_id)
);

alter table user_achievements enable row level security;
create policy "user_achievements_owner" on user_achievements
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter table achievements enable row level security;
create policy "achievements_read" on achievements for select using (true);

-- 8. Seed awal -------------------------------------------------
insert into achievements (code, title, description) values
  ('first_task','Langkah Pertama','Selesaikan 1 task pertama'),
  ('focus_3','Fokus 3x','Selesaikan 3 focus session'),
  ('task_10','Produktif!','Selesaikan 10 task')
on conflict (code) do nothing;
