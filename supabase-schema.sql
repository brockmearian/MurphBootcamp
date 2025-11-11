-- =====================================================
-- Supabase Schema Migration for To-Do List Application
-- =====================================================
-- This script creates the database schema for a multi-user
-- to-do list application with categories and due dates.
--
-- Run this in your Supabase SQL Editor after creating a project.
-- =====================================================

-- =====================================================
-- 1. CATEGORIES TABLE
-- =====================================================
-- Stores user-defined categories for organizing tasks

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    color TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT categories_name_not_empty CHECK (trim(name) <> ''),
    CONSTRAINT categories_unique_name_per_user UNIQUE (user_id, name)
);

-- Index for faster lookups by user
CREATE INDEX idx_categories_user_id ON categories(user_id);

-- =====================================================
-- 2. TASKS TABLE
-- =====================================================
-- Stores all tasks with completion status, due dates, and categories

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT false,
    due_date DATE,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT tasks_title_not_empty CHECK (trim(title) <> '')
);

-- Indexes for faster queries
CREATE INDEX idx_tasks_user_id ON tasks(user_id);
CREATE INDEX idx_tasks_category_id ON tasks(category_id);
CREATE INDEX idx_tasks_due_date ON tasks(due_date) WHERE due_date IS NOT NULL;
CREATE INDEX idx_tasks_completed ON tasks(completed);

-- =====================================================
-- 3. AUTOMATIC UPDATED_AT TRIGGER
-- =====================================================
-- Automatically update the updated_at timestamp on row changes

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 4. ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================
-- Ensure users can only access their own data

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- CATEGORIES RLS POLICIES
-- =====================================================

-- Allow users to view their own categories
CREATE POLICY "Users can view their own categories"
    ON categories
    FOR SELECT
    USING (auth.uid() = user_id);

-- Allow users to create categories for themselves
CREATE POLICY "Users can create their own categories"
    ON categories
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own categories
CREATE POLICY "Users can update their own categories"
    ON categories
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own categories
CREATE POLICY "Users can delete their own categories"
    ON categories
    FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- TASKS RLS POLICIES
-- =====================================================

-- Allow users to view their own tasks
CREATE POLICY "Users can view their own tasks"
    ON tasks
    FOR SELECT
    USING (auth.uid() = user_id);

-- Allow users to create tasks for themselves
CREATE POLICY "Users can create their own tasks"
    ON tasks
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own tasks
CREATE POLICY "Users can update their own tasks"
    ON tasks
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own tasks
CREATE POLICY "Users can delete their own tasks"
    ON tasks
    FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- 5. HELPER VIEWS (OPTIONAL)
-- =====================================================
-- Useful views for common queries

-- View: Tasks with category information
CREATE VIEW tasks_with_categories AS
SELECT
    t.id,
    t.user_id,
    t.title,
    t.completed,
    t.due_date,
    t.created_at,
    t.updated_at,
    c.id AS category_id,
    c.name AS category_name,
    c.color AS category_color
FROM tasks t
LEFT JOIN categories c ON t.category_id = c.id;

-- RLS for view (inherits from base tables)
ALTER VIEW tasks_with_categories OWNER TO postgres;

-- =====================================================
-- 6. SEED DATA (OPTIONAL)
-- =====================================================
-- Default categories for new users
-- Note: This would need to be created via a trigger or application logic
-- Here's a function you can call to create default categories for a user:

CREATE OR REPLACE FUNCTION create_default_categories(p_user_id UUID)
RETURNS void AS $$
BEGIN
    INSERT INTO categories (user_id, name, color) VALUES
        (p_user_id, 'Personal', '#667eea'),
        (p_user_id, 'Work', '#4caf50'),
        (p_user_id, 'Shopping', '#ff9800')
    ON CONFLICT (user_id, name) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 7. USEFUL QUERIES FOR TESTING
-- =====================================================

-- View all tables and their row counts
-- SELECT 'categories' as table_name, count(*) as row_count FROM categories
-- UNION ALL
-- SELECT 'tasks', count(*) FROM tasks;

-- View RLS policies
-- SELECT tablename, policyname, permissive, roles, cmd, qual
-- FROM pg_policies
-- WHERE schemaname = 'public'
-- ORDER BY tablename, policyname;

-- =====================================================
-- MIGRATION COMPLETE
-- =====================================================
-- Next steps:
-- 1. Set up Supabase Auth (Email/Password or OAuth)
-- 2. Get your API keys from Project Settings > API
-- 3. Install Supabase client: npm install @supabase/supabase-js
-- 4. Update your application code to use Supabase
-- =====================================================
