-- ============================================================
-- Berikan hak akses tabel/schema ke role `authenticated` & `anon`
-- agar RLS policies dapat bekerja tanpa error 42501 (permission denied).
-- ============================================================

grant usage on schema public to anon, authenticated, service_role;

grant select, insert, update, delete on table public.profiles to authenticated;
grant select, insert, update, delete on table public.user_goals to authenticated;
grant select, insert, update, delete on table public.task_categories to authenticated;
grant select, insert, update, delete on table public.tasks to authenticated;
grant select, insert, update, delete on table public.habits to authenticated;
grant select, insert, update, delete on table public.habit_logs to authenticated;
grant select, insert, update, delete on table public.mood_logs to authenticated;
grant select, insert, update, delete on table public.sleep_logs to authenticated;
grant select, insert, update, delete on table public.focus_sessions to authenticated;
grant select, insert, update, delete on table public.notifications to authenticated;
grant select, insert, update, delete on table public.user_achievements to authenticated;

grant select on table public.achievements to anon, authenticated;

grant usage, select on all sequences in schema public to authenticated;
grant all on all tables in schema public to service_role;
grant all on all sequences in schema public to service_role;
