# Quick Start Guide - Add Your Supabase Credentials

Your app has been updated with Supabase integration! Follow these steps to get it running.

---

## Step 1: Get Your Supabase Credentials

1. Go to your Supabase project dashboard at https://supabase.com/dashboard
2. Click on your project
3. In the left sidebar, click **"Project Settings"** (gear icon)
4. Click **"API"**
5. Copy these two values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (the long string starting with `eyJ...`)

---

## Step 2: Update index.html with Your Credentials

Open `index.html` and find lines **616-617**:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL'; // Replace with your Supabase URL
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'; // Replace with your Supabase anon key
```

Replace with your actual credentials:

```javascript
const SUPABASE_URL = 'https://xxxxxxxxxxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOi...';
```

**Save the file.**

---

## Step 3: Test Locally

1. Open `index.html` in your browser
2. You should see the sign-in page
3. Click "Sign up" and create a test account
4. You should automatically be signed in and see the app

---

## Step 4: Verify It Works

Test these features:

✅ **Authentication:**
- Sign up with an email/password
- Sign out
- Sign back in

✅ **Categories:**
- Create 2-3 categories (Work, Personal, Shopping)
- Assign colors to them
- Delete one

✅ **Tasks:**
- Create a task without category/date
- Create a task with a category
- Create a task with a due date
- Toggle completion
- Delete a task
- Refresh the page - tasks should persist

---

## Step 5: Deploy to Vercel

Once everything works locally, deploy:

1. **Add environment variables to Vercel:**
   - Go to https://vercel.com/dashboard
   - Click your project → Settings → Environment Variables
   - Add:
     - `VITE_SUPABASE_URL` = your Supabase URL
     - `VITE_SUPABASE_ANON_KEY` = your anon key

2. **Commit and push:**
```bash
cd "/Users/brockmearian/Library/CloudStorage/OneDrive-BrighamYoungUniversity/MurphBootcamp/To Do List"
git add .
git commit -m "Add Supabase integration with auth, categories, and due dates"
git push
```

3. Vercel will automatically deploy
4. Test your live site!

---

## What's New in Your App

✨ **User Authentication**
- Sign up / Sign in / Sign out
- Each user has their own private tasks

✨ **Categories**
- Create custom categories with colors
- Assign tasks to categories
- Delete categories (tasks stay, just uncategorized)

✨ **Due Dates**
- Optional due dates for tasks
- Overdue tasks highlighted in red
- Smart date display (Today, Tomorrow, or actual date)

✨ **Cloud Sync**
- All data stored in Supabase PostgreSQL
- Access from any device with same account
- Automatic backups

✨ **Data Migration**
- If you had tasks in localStorage, you'll see a banner
- Click "Import Tasks" to migrate them

---

## Troubleshooting

**Problem:** "Invalid API key" error
**Solution:** Double-check your credentials in lines 616-617, make sure no extra spaces

**Problem:** Can't sign up
**Solution:** Check Supabase Auth settings, make sure Email provider is enabled

**Problem:** Tasks not loading
**Solution:** Check browser console (F12), verify RLS policies in Supabase

**Problem:** Can see other users' data
**Solution:** Re-run the SQL migration in Supabase SQL Editor

---

## Need More Help?

- Full setup guide: `SETUP_CHECKLIST.md`
- Detailed docs: `SUPABASE_SETUP.md`
- Database schema: `supabase-schema.sql`

---

**You're all set! Enjoy your new multi-user to-do list app!** 🎉
