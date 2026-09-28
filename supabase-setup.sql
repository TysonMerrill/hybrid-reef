-- Hybrid Reef family board. Paste this whole file into the Supabase SQL Editor and click Run.

create table if not exists public.discoveries (
  key           text primary key check (char_length(key) <= 120),
  name          text not null check (char_length(name) <= 120),
  latin         text not null check (char_length(latin) <= 120),
  tier          text not null check (tier in ('Common', 'Uncommon', 'Rare', 'Epic', 'Mythic')),
  score         int  not null default 0,
  gen           int  not null default 0,
  genome        jsonb not null check (pg_column_size(genome) < 4000),
  discoverer    text not null check (char_length(discoverer) between 1 and 20),
  discovered_at timestamptz not null default now()
);

create index if not exists discoveries_recent on public.discoveries (discovered_at desc);

-- Anyone with the game can read the board and add a new discovery.
-- Nobody can edit or delete someone else's discovery (no update/delete policies).
alter table public.discoveries enable row level security;

drop policy if exists "read discoveries" on public.discoveries;
create policy "read discoveries" on public.discoveries
  for select to anon, authenticated using (true);

drop policy if exists "add discoveries" on public.discoveries;
create policy "add discoveries" on public.discoveries
  for insert to anon, authenticated
  with check (discovered_at > now() - interval '5 minutes' and discovered_at < now() + interval '5 minutes');

create or replace view public.leaderboard with (security_invoker = true) as
  select discoverer, count(*)::int as found, max(discovered_at) as last_found
  from public.discoveries
  group by discoverer;

grant select on public.discoveries to anon, authenticated;
grant insert on public.discoveries to anon, authenticated;
grant select on public.leaderboard to anon, authenticated;

-- Live "Mom just discovered…" notifications.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'discoveries'
  ) then
    alter publication supabase_realtime add table public.discoveries;
  end if;
end $$;
