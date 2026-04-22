-- Script para criar slots de agendamento
-- Horário: 9:00 às 17:30 (intervalos de 30 min)
-- Dias: Terça a Sábado
-- Período: Próximos 15 dias
-- Timezone: UTC-3 (São Paulo)

WITH RECURSIVE date_series AS (
  -- Gera série de datas dos próximos 15 dias
  SELECT CURRENT_DATE AT TIME ZONE 'America/Sao_Paulo'::text as date
  UNION ALL
  SELECT date + INTERVAL '1 day'
  FROM date_series
  WHERE date < CURRENT_DATE AT TIME ZONE 'America/Sao_Paulo'::text + INTERVAL '14 days'
),
filtered_dates AS (
  -- Filtra apenas terça a sábado (1=segunda, 2=terça, 6=sábado, 7=domingo)
  SELECT date
  FROM date_series
  WHERE EXTRACT(DOW FROM date) BETWEEN 2 AND 6
),
time_slots AS (
  -- Gera horários de 9:00 às 17:30 em intervalos de 30 minutos
  SELECT
    (INTERVAL '30 minutes' * s)::time as slot_time
  FROM generate_series(0, 17) as s
),
slot_combinations AS (
  -- Combina datas, horários e serviços
  SELECT
    (d.date AT TIME ZONE 'UTC'::text) + t.slot_time at time zone 'UTC'::text as slot_datetime,
    sv.id as service_id
  FROM filtered_dates d
  CROSS JOIN time_slots t
  CROSS JOIN services sv
  WHERE sv.active = true
)
INSERT INTO available_slots (slot_datetime, service_id, is_booked, created_at)
SELECT
  slot_datetime,
  service_id,
  false,
  now()
FROM slot_combinations
ON CONFLICT DO NOTHING;

-- Verifica quantos slots foram criados
SELECT COUNT(*) as total_slots_created FROM available_slots;
