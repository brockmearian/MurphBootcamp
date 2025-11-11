# Supabase Setup Guide

This guide walks you through migrating the Simple To-Do List from localStorage to Supabase, adding multi-user authentication, categories, and due dates.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Supabase Project Setup](#supabase-project-setup)
3. [Database Schema Migration](#database-schema-migration)
4. [Authentication Setup](#authentication-setup)
5. [Client Integration](#client-integration)
6. [API Usage Examples](#api-usage-examples)
7. [Testing](#testing)
8. [Data Migration from localStorage](#data-migration-from-localstorage)

---

## Prerequisites

- Supabase account (sign up at https://supabase.com)
- Node.js and npm (if using a build process)
- Git (for version control)
- Your existing To-Do List application

---

## Supabase Project Setup

### Step 1: Create a New Supabase Project

1. Go to https://supabase.com/dashboard
2. Click **"New Project"**
3. Fill in the details:
   - **Name:** `todo-list-app` (or your preferred name)
   - **Database Password:** Create a strong password (save this!)
   - **Region:** Choose closest to your users
   - **Pricing Plan:** Free tier is sufficient for this project
4. Click **"Create new project"**
5. Wait 2-3 minutes for the project to be provisioned

### Step 2: Get Your API Keys

1. In your Supabase project dashboard, go to **Settings** → **API**
2. You'll need two keys:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)
3. Save these for later use in your application

---

## Database Schema Migration

### Step 1: Run the SQL Migration

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **"New query"**
3. Copy the entire contents of `supabase-schema.sql` from this project
4. Paste it into the SQL editor
5. Click **"Run"** (or press Cmd/Ctrl + Enter)
6. Verify success: You should see "Success. No rows returned"

### Step 2: Verify Tables Were Created

1. Go to **Table Editor** in the dashboard
2. You should see two tables:
   - `categories` - with columns: id, user_id, name, color, created_at
   - `tasks` - with columns: id, user_id, title, completed, due_date, category_id, created_at, updated_at
3. Both tables should have RLS (Row Level Security) enabled (green shield icon)

### Database Schema Overview

```
┌─────────────┐         ┌──────────────┐
│   auth.users│◄────┐   │  categories  │
└─────────────┘     │   ├──────────────┤
                    ├───┤ id (PK)      │
                    │   │ user_id (FK) │
                    │   │ name         │
                    │   │ color        │
                    │   │ created_at   │
                    │   └──────────────┘
                    │          ▲
                    │          │
                    │   ┌──────┴───────┐
                    │   │    tasks     │
                    │   ├──────────────┤
                    │   │ id (PK)      │
                    └───┤ user_id (FK) │
                        │ title        │
                        │ completed    │
                        │ due_date     │
                        │ category_id  │
                        │ created_at   │
                        │ updated_at   │
                        └──────────────┘
```

---

## Authentication Setup

### Step 1: Enable Email Authentication

1. In Supabase dashboard, go to **Authentication** → **Providers**
2. **Email** should be enabled by default
3. Configure settings:
   - **Enable email confirmations:** Toggle based on preference
   - **Secure email change:** Recommended to enable
4. Save changes

### Step 2: Configure Email Templates (Optional)

1. Go to **Authentication** → **Email Templates**
2. Customize the sign-up confirmation email if desired
3. Update the app URL to your Vercel deployment URL

### Step 3: (Optional) Enable OAuth Providers

For social login (Google, GitHub, etc.):

1. Go to **Authentication** → **Providers**
2. Enable desired providers (e.g., Google, GitHub)
3. Follow the provider-specific setup instructions
4. Add OAuth credentials (Client ID, Client Secret)

---

## Client Integration

### Step 1: Install Supabase Client Library

**Option A: Using npm (recommended for build process)**
```bash
npm install @supabase/supabase-js
```

**Option B: Using CDN (for simple HTML file)**
Add to your HTML `<head>`:
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
```

### Step 2: Initialize Supabase Client

Add this JavaScript code to your application:

```javascript
// Replace with your actual Supabase credentials
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJxxx...';

const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
```

### Step 3: Add Authentication UI

Create login/signup forms:

```html
<!-- Login Form -->
<div id="authContainer">
  <h2>Sign In</h2>
  <input type="email" id="email" placeholder="Email" />
  <input type="password" id="password" placeholder="Password" />
  <button id="signInBtn">Sign In</button>
  <button id="signUpBtn">Sign Up</button>
</div>

<!-- Main App (hidden until authenticated) -->
<div id="appContainer" style="display: none;">
  <!-- Your existing to-do list UI -->
</div>
```

### Step 4: Implement Authentication Logic

```javascript
// Sign Up
async function signUp(email, password) {
  const { data, error } = await supabase.auth.signUp({
    email: email,
    password: password
  });

  if (error) {
    console.error('Sign up error:', error);
    alert(error.message);
  } else {
    alert('Check your email for confirmation link!');
  }
}

// Sign In
async function signIn(email, password) {
  const { data, error } = await supabase.auth.signInWithPassword({
    email: email,
    password: password
  });

  if (error) {
    console.error('Sign in error:', error);
    alert(error.message);
  } else {
    // User is signed in, show the app
    showApp();
    loadTasks();
  }
}

// Sign Out
async function signOut() {
  const { error } = await supabase.auth.signOut();
  if (error) {
    console.error('Sign out error:', error);
  } else {
    hideApp();
  }
}

// Check if user is already signed in
supabase.auth.onAuthStateChange((event, session) => {
  if (session) {
    showApp();
    loadTasks();
  } else {
    hideApp();
  }
});

function showApp() {
  document.getElementById('authContainer').style.display = 'none';
  document.getElementById('appContainer').style.display = 'block';
}

function hideApp() {
  document.getElementById('authContainer').style.display = 'block';
  document.getElementById('appContainer').style.display = 'none';
}
```

---

## API Usage Examples

### Categories

**Create a Category:**
```javascript
async function createCategory(name, color) {
  const { data, error } = await supabase
    .from('categories')
    .insert([
      { name: name, color: color }
    ])
    .select();

  if (error) console.error('Error creating category:', error);
  return data;
}
```

**Get All User's Categories:**
```javascript
async function getCategories() {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .order('name', { ascending: true });

  if (error) console.error('Error fetching categories:', error);
  return data || [];
}
```

**Delete a Category:**
```javascript
async function deleteCategory(categoryId) {
  const { error } = await supabase
    .from('categories')
    .delete()
    .eq('id', categoryId);

  if (error) console.error('Error deleting category:', error);
}
```

### Tasks

**Create a Task:**
```javascript
async function createTask(title, dueDate = null, categoryId = null) {
  const { data, error } = await supabase
    .from('tasks')
    .insert([
      {
        title: title,
        due_date: dueDate,
        category_id: categoryId,
        completed: false
      }
    ])
    .select();

  if (error) console.error('Error creating task:', error);
  return data;
}
```

**Get All User's Tasks:**
```javascript
async function getTasks() {
  const { data, error } = await supabase
    .from('tasks')
    .select(`
      *,
      category:categories(id, name, color)
    `)
    .order('created_at', { ascending: false });

  if (error) console.error('Error fetching tasks:', error);
  return data || [];
}
```

**Update Task (Toggle Completion):**
```javascript
async function toggleTaskCompletion(taskId, completed) {
  const { error } = await supabase
    .from('tasks')
    .update({ completed: completed })
    .eq('id', taskId);

  if (error) console.error('Error updating task:', error);
}
```

**Update Task (Change Due Date):**
```javascript
async function updateTaskDueDate(taskId, dueDate) {
  const { error } = await supabase
    .from('tasks')
    .update({ due_date: dueDate })
    .eq('id', taskId);

  if (error) console.error('Error updating due date:', error);
}
```

**Delete a Task:**
```javascript
async function deleteTask(taskId) {
  const { error } = await supabase
    .from('tasks')
    .delete()
    .eq('id', taskId);

  if (error) console.error('Error deleting task:', error);
}
```

**Get Tasks by Category:**
```javascript
async function getTasksByCategory(categoryId) {
  const { data, error } = await supabase
    .from('tasks')
    .select('*')
    .eq('category_id', categoryId)
    .order('created_at', { ascending: false });

  if (error) console.error('Error fetching tasks:', error);
  return data || [];
}
```

**Get Overdue Tasks:**
```javascript
async function getOverdueTasks() {
  const today = new Date().toISOString().split('T')[0];

  const { data, error } = await supabase
    .from('tasks')
    .select('*')
    .eq('completed', false)
    .not('due_date', 'is', null)
    .lt('due_date', today);

  if (error) console.error('Error fetching overdue tasks:', error);
  return data || [];
}
```

---

## Testing

### Test Authentication

1. Sign up with a test email
2. Check your email for confirmation (if enabled)
3. Sign in with the credentials
4. Verify you can see the app interface

### Test Categories

1. Create a few categories:
   - Personal (color: #667eea)
   - Work (color: #4caf50)
   - Shopping (color: #ff9800)
2. Verify they appear in the UI
3. Try deleting a category

### Test Tasks

1. Create tasks with different properties:
   - Task with no category or due date
   - Task with a category
   - Task with a due date
   - Task with both category and due date
2. Toggle task completion
3. Update task properties
4. Delete tasks
5. Verify changes persist after page reload

### Test Row Level Security

1. Create a second user account
2. Sign in with the second account
3. Verify you can't see the first user's tasks or categories
4. Create tasks for the second user
5. Sign back in as the first user and verify their data is unchanged

---

## Data Migration from localStorage

If you want to migrate existing tasks from localStorage to Supabase:

```javascript
async function migrateLocalStorageData() {
  // Get existing tasks from localStorage
  const localTasks = JSON.parse(localStorage.getItem('tasks') || '[]');

  if (localTasks.length === 0) {
    console.log('No tasks to migrate');
    return;
  }

  // Confirm with user
  if (!confirm(`Found ${localTasks.length} tasks in localStorage. Migrate to Supabase?`)) {
    return;
  }

  // Create default category for migrated tasks
  const { data: category } = await supabase
    .from('categories')
    .insert([{ name: 'Imported', color: '#9e9e9e' }])
    .select()
    .single();

  // Migrate each task
  const migratedTasks = localTasks.map(task => ({
    title: task.text,
    completed: task.completed,
    category_id: category?.id || null
  }));

  const { data, error } = await supabase
    .from('tasks')
    .insert(migratedTasks);

  if (error) {
    console.error('Migration error:', error);
    alert('Error migrating tasks. Please try again.');
  } else {
    console.log('Migration successful!');
    // Clear localStorage after successful migration
    if (confirm('Migration successful! Clear localStorage?')) {
      localStorage.removeItem('tasks');
    }
    // Reload tasks
    loadTasks();
  }
}
```

Call this function after a user first signs in to migrate their data.

---

## Environment Variables (Production)

For security, store your Supabase credentials as environment variables:

**Create `.env` file (don't commit to git!):**
```
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJxxx...
```

**Update `.gitignore`:**
```
.env
.env.local
```

**Access in code:**
```javascript
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL;
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY;
```

**Configure in Vercel:**
1. Go to your project settings in Vercel
2. Navigate to **Environment Variables**
3. Add:
   - `VITE_SUPABASE_URL` = your Supabase URL
   - `VITE_SUPABASE_ANON_KEY` = your anon key

---

## Troubleshooting

### "Row Level Security" Error

**Problem:** Cannot insert/update/delete data
**Solution:** Make sure RLS policies are created (run the SQL migration again)

### "Invalid API Key" Error

**Problem:** Authentication fails
**Solution:** Double-check your API key and URL from Supabase dashboard

### Tasks Don't Load

**Problem:** No data appears after signing in
**Solution:**
1. Check browser console for errors
2. Verify user is authenticated: `const { data } = await supabase.auth.getSession()`
3. Check RLS policies are correct

### Email Confirmation Issues

**Problem:** Not receiving confirmation emails
**Solution:**
1. Check spam folder
2. Disable email confirmation in Supabase Auth settings for testing
3. Verify email templates are configured correctly

---

## Next Steps

After completing this setup:

1. ✅ Update the UI to include category selection dropdown
2. ✅ Add a date picker for due dates
3. ✅ Implement filtering by category
4. ✅ Add visual indicators for overdue tasks
5. ✅ Implement task editing (currently can't edit after creation)
6. ✅ Add user profile page (change email, password)
7. ✅ Deploy updated application to Vercel

---

## Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Auth](https://supabase.com/docs/guides/auth)

---

**Migration Complete!** Your to-do list is now a multi-user application with cloud sync, categories, and due dates.
