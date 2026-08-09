-- Case Register — Supabase schema
-- Run this once in your Supabase project: Dashboard → SQL Editor → New query → paste → Run

create extension if not exists pgcrypto;

-- 1. CaseTable
create table if not exists case_table (
  case_id           text primary key,
  company_name      text default '',
  date_of_accident  date,
  depute_date       date,
  created_at        timestamptz default now()
);

-- 2. InsuranceDetails
create table if not exists insurance_details (
  id              uuid primary key default gen_random_uuid(),
  case_id         text references case_table(case_id) on update cascade on delete cascade,
  insurer         text default '',
  insurance_type  text default '',
  claim_date      date,
  policy_no       text default '',
  claim_no        text default ''
);

-- 3. InsuredDetails
create table if not exists insured_details (
  id            uuid primary key default gen_random_uuid(),
  case_id       text references case_table(case_id) on update cascade on delete cascade,
  bank_name     text default '',
  person_name   text default ''
);

-- 4. VisitDetails
create table if not exists visit_details (
  id            uuid primary key default gen_random_uuid(),
  case_id       text references case_table(case_id) on update cascade on delete cascade,
  visit_no      text default '',
  visit_date    date,
  visited_by    text default ''
);

-- 5. StatusDetails
create table if not exists status_details (
  id            uuid primary key default gen_random_uuid(),
  case_id       text references case_table(case_id) on update cascade on delete cascade,
  status        text default '',
  date          date,
  remarks       text default ''
);

-- 6. PaymentDetails
create table if not exists payment_details (
  id              uuid primary key default gen_random_uuid(),
  case_id         text references case_table(case_id) on update cascade on delete cascade,
  incurred_fee    numeric,
  payment         text default '',
  date            date,
  remarks         text default ''
);

-- Helpful indexes for looking up a case's related rows
create index if not exists idx_insurance_case   on insurance_details(case_id);
create index if not exists idx_insured_case     on insured_details(case_id);
create index if not exists idx_visit_case       on visit_details(case_id);
create index if not exists idx_status_case      on status_details(case_id);
create index if not exists idx_payment_case     on payment_details(case_id);

-- Row Level Security: enabled, with a fully open policy since this app uses
-- a single shared public key with no login. Anyone who has your site's URL
-- (and therefore the public anon key embedded in it) can read and write
-- every row in these tables. This is fine for a single-user or trusted-team
-- tool that you don't publicize, but keep that tradeoff in mind — see the
-- README for details and options to tighten this later.

alter table case_table        enable row level security;
alter table insurance_details  enable row level security;
alter table insured_details    enable row level security;
alter table visit_details      enable row level security;
alter table status_details     enable row level security;
alter table payment_details    enable row level security;

create policy "public full access" on case_table        for all using (true) with check (true);
create policy "public full access" on insurance_details  for all using (true) with check (true);
create policy "public full access" on insured_details    for all using (true) with check (true);
create policy "public full access" on visit_details      for all using (true) with check (true);
create policy "public full access" on status_details     for all using (true) with check (true);
create policy "public full access" on payment_details    for all using (true) with check (true);
