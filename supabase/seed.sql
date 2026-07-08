-- HueTone Seed Data
-- Loads a demo palette for each season so new users see content immediately.

-- Helper to insert swatches for a given season
do $$
declare
  season_record record;
begin
  for season_record in
    select unnest(array[
      'Light Spring', 'True Spring', 'Bright Spring',
      'Light Summer', 'True Summer', 'Soft Summer',
      'Soft Autumn', 'True Autumn', 'Deep Autumn',
      'Bright Winter', 'True Winter', 'Deep Winter'
    ]) as season_name
  loop
    -- Metal swatches
    insert into public.color_wallet (id, user_id, season, category, hex_value, color_name, harmony_score, lab_l, lab_a, lab_b)
    values
      (gen_random_uuid(), '00000000-0000-0000-0000-000000000000', season_record.season_name, 'metal', '#C8A86E', 'Warm Gold', 0.95, 70, 5, 30),
      (gen_random_uuid(), '00000000-0000-0000-0000-000000000000', season_record.season_name, 'metal', '#E8D5A3', 'Champagne', 0.90, 85, 2, 20);
  end loop;
end $$;
