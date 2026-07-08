-- HueTone Database Schema
-- Run via: supabase migration up

-- 1. PROFILES (syncs with auth.users via trigger)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text,
  display_name text,
  created_at timestamptz default now(),
  subscription_tier text not null default 'free' check (subscription_tier in ('free', 'premium')),
  onboarding_completed boolean default false
);

alter table public.profiles enable row level security;

create policy "users_view_own_profile" on public.profiles
  for select using (auth.uid() = id);

create policy "users_update_own_profile" on public.profiles
  for update using (auth.uid() = id);

-- auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 2. RESULTS
create table if not exists public.results (
  id uuid primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  season text not null,
  confidence double precision not null,
  classification_method text not null,
  secondary_season text,
  created_at timestamptz default now(),
  color_metrics jsonb
);

create index if not exists idx_results_user_id on public.results(user_id);
create index if not exists idx_results_created_at on public.results(created_at desc);

alter table public.results enable row level security;

create policy "users_own_results" on public.results
  for all using (auth.uid() = user_id);

-- 3. COLOR WALLET
create table if not exists public.color_wallet (
  id uuid primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  season text not null,
  category text not null,
  hex_value text not null,
  color_name text default '',
  harmony_score double precision default 1.0,
  lab_l double precision default 0,
  lab_a double precision default 0,
  lab_b double precision default 0,
  created_at timestamptz default now()
);

create index if not exists idx_color_wallet_user_id on public.color_wallet(user_id);

alter table public.color_wallet enable row level security;

create policy "users_own_wallet" on public.color_wallet
  for all using (auth.uid() = user_id);

-- 4. SUBSCRIPTIONS (validated server-side via receipt)
create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  product_id text not null,
  original_transaction_id text unique not null,
  expires_at timestamptz not null,
  is_active boolean default true,
  created_at timestamptz default now()
);

create index if not exists idx_subscriptions_user_id on public.subscriptions(user_id);

alter table public.subscriptions enable row level security;

create policy "users_view_own_subscriptions" on public.subscriptions
  for select using (auth.uid() = user_id);
