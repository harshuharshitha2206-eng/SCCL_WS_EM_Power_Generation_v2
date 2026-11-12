-- SCCL WSs&EM: multi-plant daily generation reporting
create extension if not exists pgcrypto;
create table if not exists public.plants (
 id uuid primary key default gen_random_uuid(),
 name text not null unique,
 capacity_kw numeric(10,2),
 sync_date date,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.generation_reports (
 id uuid primary key default gen_random_uuid(),
 plant_id uuid not null references public.plants(id) on delete restrict,
 report_date date not null,
 generation numeric(14,2) not null check (generation >= 0),
 unit text not null default 'Units',
 remarks text,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(plant_id, report_date)
);
alter table public.plants enable row level security;
alter table public.generation_reports enable row level security;
-- Initial policy set: any authenticated team member can view and enter/edit plant reports.
create policy "Authenticated users can view plants" on public.plants for select to authenticated using (true);
create policy "Authenticated users can add plants" on public.plants for insert to authenticated with check (true);
create policy "Authenticated users can update plants" on public.plants for update to authenticated using (true) with check (true);
create policy "Authenticated users can view generation reports" on public.generation_reports for select to authenticated using (true);
create policy "Authenticated users can add generation reports" on public.generation_reports for insert to authenticated with check (true);
create policy "Authenticated users can update generation reports" on public.generation_reports for update to authenticated using (true) with check (true);
create policy "Authenticated users can delete generation reports" on public.generation_reports for delete to authenticated using (true);
create index if not exists generation_reports_date_idx on public.generation_reports(report_date);
create index if not exists generation_reports_plant_date_idx on public.generation_reports(plant_id,report_date);
-- Seed the locations visible in the supplied workbook. Only Singareni Bhavan is confirmed as 60 kW.
insert into public.plants(name,capacity_kw) values
 ('Singareni Bhavan',60),('TKLP',null),('SC Polytechnic CCC Naspur',null)
on conflict(name) do nothing;
