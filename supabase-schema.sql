-- ═══════════════════════════════════════════════════════════════
-- TSOA PACKAGING SYSTEM — SUPABASE DATABASE SCHEMA
-- Paste this entire file into:
-- Supabase Dashboard → SQL Editor → New Query → Run
-- ═══════════════════════════════════════════════════════════════


-- ── 1. ATTENDANCE TABLE ──────────────────────────────────────────
-- Stores every sign-in and sign-out record from all employees

CREATE TABLE IF NOT EXISTS attendance (
  id            BIGINT PRIMARY KEY DEFAULT extract(epoch from now())::bigint,
  user_id       INTEGER NOT NULL,
  user_name     TEXT NOT NULL,
  project_id    INTEGER,
  project_name  TEXT,
  type          TEXT NOT NULL CHECK (type IN ('in', 'out')),
  date          TEXT NOT NULL,        -- "2026-03-08"
  time          TEXT NOT NULL,        -- "08:45"
  sig           TEXT,                 -- base64 signature
  loc_status    TEXT DEFAULT 'idle',  -- idle | ok | denied | error
  location      JSONB DEFAULT '{}',   -- { lat, lng, accuracy, address }
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Allow anyone to read/write (employees sign in without login)
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON attendance FOR ALL USING (true) WITH CHECK (true);


-- ── 2. DOCUMENTS TABLE ───────────────────────────────────────────
-- Stores all uploaded/created documents (admin managed)

CREATE TABLE IF NOT EXISTS documents (
  id          BIGINT PRIMARY KEY DEFAULT extract(epoch from now())::bigint,
  title       TEXT NOT NULL,
  cat         TEXT DEFAULT 'SOP',     -- SOP | Technical | Quality | Maintenance | Template
  desc        TEXT DEFAULT '',
  tags        JSONB DEFAULT '[]',     -- ["CIP", "Filler"]
  pages       INTEGER DEFAULT 1,
  size        TEXT DEFAULT '—',
  date        TEXT,
  uploader    TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON documents FOR ALL USING (true) WITH CHECK (true);


-- ── 3. PROBLEMS TABLE ────────────────────────────────────────────
-- Stores all action tracker problems / issues

CREATE TABLE IF NOT EXISTS problems (
  id                  BIGINT PRIMARY KEY DEFAULT extract(epoch from now())::bigint,
  date                TEXT NOT NULL,
  plant               TEXT NOT NULL,
  machine             TEXT NOT NULL,
  found_by            TEXT NOT NULL,
  severity            TEXT NOT NULL,   -- Critical | Major | Minor | Observation
  status              TEXT NOT NULL,   -- Open | Investigating | Resolved | Closed
  title               TEXT NOT NULL,
  description         TEXT DEFAULT '',
  immediate_actions   TEXT DEFAULT '',
  root_cause          TEXT DEFAULT '',
  five_whys           JSONB DEFAULT '[]',
  corrective_actions  JSONB DEFAULT '[]',
  loop_closure        TEXT DEFAULT '',
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE problems ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all" ON problems FOR ALL USING (true) WITH CHECK (true);


-- ── 4. SEED SAMPLE DATA (OPTIONAL) ──────────────────────────────
-- Run this block to pre-populate some sample problems so the system
-- doesn't start completely empty. Comment out if not needed.

INSERT INTO problems (id, date, plant, machine, found_by, severity, status, title, description, immediate_actions)
VALUES
  (1001, '2026-02-20', 'Zambian Breweries — Lusaka',    'Filler',     'James Mutua',  'Critical', 'Closed',        'Fill level variance on valve 12',
   'Valve 12 consistently underfilling by 4–6ml across a 2-hour production run.',
   'Valve 12 isolated. Fill weight checks increased to every 15 minutes.'),

  (1002, '2026-02-24', 'Eswatini Beverages — Matsapha', 'Labeller',   'Grace Akinyi', 'Major',    'Investigating', 'Date code misalignment — Line 2',
   'Date code stamp misaligned by ~2mm on approximately 15% of labels on Line 2.',
   'Production rate reduced by 20%. Manual inspection every 30 minutes.'),

  (1003, '2026-03-01', 'Zambian Breweries — Lusaka',    'Pasteuriser','Sarah Wanjiru', 'Major',   'Resolved',      'Zone 3 PU consistently low — pasteuriser',
   'Zone 3 PU averaging 14.2 against a target of 15.0 over a 3-day period.',
   'Pasteuriser temperature setpoint in Zone 3 increased by 1.5°C.')
ON CONFLICT (id) DO NOTHING;


-- ── 5. REALTIME (OPTIONAL) ───────────────────────────────────────
-- Enable realtime updates so Admin Console refreshes live
-- Supabase Dashboard → Database → Replication → Select tables below

-- attendance  ← enable this
-- documents   ← enable this
-- problems    ← enable this


-- ═══════════════════════════════════════════════════════════════
-- DONE. Your database is ready.
-- Next step: copy your Project URL and anon key into .env.local
-- ═══════════════════════════════════════════════════════════════
