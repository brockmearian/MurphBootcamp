-- =====================================================
-- UPDATE: Add Time Support to Tasks
-- =====================================================
-- This changes due_date from DATE to TIMESTAMPTZ
-- Run this in Supabase SQL Editor
-- =====================================================

-- Change due_date from DATE to TIMESTAMPTZ to support time
ALTER TABLE tasks
    ALTER COLUMN due_date TYPE TIMESTAMPTZ
    USING due_date::TIMESTAMPTZ;

-- Rename the column to be more clear (optional but recommended)
ALTER TABLE tasks
    RENAME COLUMN due_date TO due_datetime;

-- Update the index
DROP INDEX IF EXISTS idx_tasks_due_date;
CREATE INDEX idx_tasks_due_datetime ON tasks(due_datetime) WHERE due_datetime IS NOT NULL;

-- =====================================================
-- DONE! Now your tasks can have specific times
-- =====================================================
