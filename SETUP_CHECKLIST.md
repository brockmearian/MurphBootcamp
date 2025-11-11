# Supabase Setup Checklist

Follow these steps in order to integrate Supabase with your To-Do List application.

---

## ☐ Step 1: Create Supabase Project (5 minutes)

1. Go to **https://supabase.com**
2. Click **"Start your project"** or **"Sign In"** if you have an account
3. Sign up/sign in (use GitHub for fastest setup)
4. Click **"New Project"**
5. Fill in the project details:
   - **Organization:** Create new or select existing
   - **Name:** `todo-list-app` (or your preferred name)
   - **Database Password:** Create a strong password
     - ⚠️ **SAVE THIS PASSWORD!** You'll need it for database access
   - **Region:** Choose closest to you (e.g., `US West` if you're in the US)
   - **Pricing Plan:** Select **Free** tier
6. Click **"Create new project"**
7. ⏳ Wait 2-3 minutes for provisioning (you'll see a progress indicator)

---

## ☐ Step 2: Run Database Migration (3 minutes)

1. In your Supabase dashboard, find the left sidebar
2. Click **"SQL Editor"** (looks like a database icon)
3. Click **"New query"** button (top left)
4. Open your local file `supabase-schema.sql`
5. **Copy the entire contents** of the file (Cmd+A, Cmd+C)
6. **Paste** into the Supabase SQL Editor
7. Click **"Run"** button (or press Cmd/Ctrl + Enter)
8. ✅ You should see: **"Success. No rows returned"**

**Verify it worked:**
- Click **"Table Editor"** in the left sidebar
- You should see two tables: `categories` and `tasks`
- Both should have a green shield icon (🛡️) indicating RLS is enabled

---

## ☐ Step 3: Configure Authentication (2 minutes)

1. In the left sidebar, click **"Authentication"**
2. Click **"Providers"**
3. Verify **"Email"** is enabled (it should be by default)
4. Configure Email settings:
   - **Confirm email:** Toggle OFF for testing (you can enable later)
   - **Secure email change:** Keep ON (recommended)
5. Click **"Save"** if you made changes

**Optional - Enable Social Login:**
- To add Google/GitHub login, click on those providers and follow setup
- For now, email/password is sufficient

---

## ☐ Step 4: Get Your API Keys (2 minutes)

1. In the left sidebar, click **"Project Settings"** (gear icon at bottom)
2. Click **"API"** in the settings menu
3. You'll see your API credentials:

**Copy these two values (you'll need them):**

```
Project URL:
https://xxxxxxxxxxxxx.supabase.co

anon/public key:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSI...
```

⚠️ **Keep these safe!** You'll add them to your app next.

---

## ☐ Step 5: Create Environment File (2 minutes)

1. In your project folder, create a new file called `.env`

**On Mac/Linux:**
```bash
cd "/Users/brockmearian/Library/CloudStorage/OneDrive-BrighamYoungUniversity/MurphBootcamp/To Do List"
touch .env
```

2. Open `.env` in your text editor
3. Add your Supabase credentials:

```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3M...
```

Replace the values with your actual URL and key from Step 4.

4. **Save the file**

⚠️ **Important:** The `.env` file is already in `.gitignore`, so it won't be committed to GitHub (this is good for security!)

---

## ☐ Step 6: Test Your Supabase Setup (5 minutes)

Let's verify everything works before updating your app.

### Test 1: Create a Test User

1. Go back to Supabase dashboard
2. Click **"Authentication"** → **"Users"**
3. Click **"Add user"** → **"Create new user"**
4. Enter:
   - **Email:** your-test-email@example.com
   - **Password:** Test123456!
5. Click **"Create user"**
6. ✅ You should see the user in the list

### Test 2: Insert Test Data

1. Go to **"Table Editor"**
2. Click on the **`categories`** table
3. Click **"Insert"** → **"Insert row"**
4. Fill in:
   - **user_id:** Copy the UUID from the user you just created
     - (Go to Authentication → Users, click on your user, copy the ID)
   - **name:** "Work"
   - **color:** "#667eea"
5. Click **"Save"**
6. ✅ You should see the category appear in the table

### Test 3: Verify Row Level Security

1. Try to view the category you just created
2. It should be visible in Table Editor
3. Later, when you create a second user, they should NOT see this category

---

## ☐ Step 7: Update Your Application Code (60-90 minutes)

Now you need to update `index.html` to use Supabase instead of localStorage.

This is the most complex step. You have two options:

### Option A: I can help you code this (Recommended)
- Tell me when you're ready, and I'll update `index.html` with:
  - Supabase client initialization
  - Authentication UI (login, signup, logout)
  - Replace localStorage with Supabase database calls
  - Add category selection
  - Add due date picker
  - Migration tool for existing localStorage data

### Option B: Follow SUPABASE_SETUP.md manually
- Open `SUPABASE_SETUP.md`
- Follow the "Client Integration" section
- Implement the code examples provided

**Which option would you prefer?**

---

## ☐ Step 8: Test Locally (15 minutes)

Once your code is updated:

1. Open `index.html` in your browser
2. Test the following:

### Authentication Tests:
- [ ] Sign up with a new email/password
- [ ] Sign out
- [ ] Sign back in with same credentials
- [ ] Verify you can't see the app without being logged in

### Category Tests:
- [ ] Create 2-3 categories (Work, Personal, Shopping)
- [ ] Assign colors to categories
- [ ] Delete a category

### Task Tests:
- [ ] Create a task without category or due date
- [ ] Create a task with a category
- [ ] Create a task with a due date
- [ ] Create a task with both category and due date
- [ ] Toggle task completion
- [ ] Delete a task
- [ ] Refresh the page - all tasks should persist

### Multi-User Test:
- [ ] Sign out
- [ ] Create a second user account
- [ ] Verify you can't see the first user's tasks
- [ ] Create some tasks for the second user
- [ ] Sign back in as first user - verify data is separate

---

## ☐ Step 9: Configure Vercel Environment Variables (3 minutes)

1. Go to **https://vercel.com/dashboard**
2. Find your **MurphBootcamp** project
3. Click on the project name
4. Click **"Settings"** tab
5. Click **"Environment Variables"** in the left sidebar
6. Add two variables:

**Variable 1:**
- **Key:** `VITE_SUPABASE_URL`
- **Value:** (paste your Supabase URL)
- **Environment:** Production, Preview, Development (select all)

**Variable 2:**
- **Key:** `VITE_SUPABASE_ANON_KEY`
- **Value:** (paste your Supabase anon key)
- **Environment:** Production, Preview, Development (select all)

7. Click **"Save"** for each

---

## ☐ Step 10: Deploy Updated App (5 minutes)

1. Make sure all your changes are saved
2. Commit and push to GitHub:

```bash
cd "/Users/brockmearian/Library/CloudStorage/OneDrive-BrighamYoungUniversity/MurphBootcamp/To Do List"

git add .
git commit -m "Add Supabase integration with auth, categories, and due dates"
git push
```

3. Vercel will automatically deploy your changes
4. Wait 1-2 minutes for deployment to complete
5. Visit your live URL (e.g., `https://murphbootcamp.vercel.app`)

---

## ☐ Step 11: Test Production Deployment (10 minutes)

1. Open your live Vercel URL
2. Run through all the tests from Step 8 again
3. Create a real user account
4. Add some real tasks
5. Close the browser and come back later - verify tasks persist

---

## 🎉 Success Criteria

You're done when:
- ✅ You can sign up and sign in to your app
- ✅ Tasks are stored in Supabase (not localStorage)
- ✅ You can create and use categories
- ✅ You can add due dates to tasks
- ✅ Multiple users have separate data
- ✅ App works on both local and production (Vercel)

---

## 🆘 Troubleshooting

### "Invalid API key" error
- Check that `.env` file has correct values
- Verify no extra spaces or quotes in `.env`
- Make sure Vercel environment variables match

### Can't see any data after signing in
- Check browser console for errors (F12 → Console)
- Verify RLS policies exist (go to SQL Editor, run: `SELECT * FROM pg_policies;`)
- Make sure you're signed in (check session: `supabase.auth.getSession()` in console)

### Email confirmation emails not arriving
- Check spam folder
- Go to Supabase Auth settings and disable "Confirm email"

### Tasks showing for wrong user
- RLS policies not working - re-run `supabase-schema.sql`
- Check that user_id is being set correctly when creating tasks

---

## 📋 Quick Reference

**Supabase Dashboard:** https://supabase.com/dashboard
**Your Project Docs:** `SUPABASE_SETUP.md` (detailed guide)
**Your Schema:** `supabase-schema.sql` (run this in SQL Editor)
**Your App:** `/Users/brockmearian/Library/CloudStorage/OneDrive-BrighamYoungUniversity/MurphBootcamp/To Do List`

---

## ⏭️ Next Steps After Setup

Once everything is working:
- [ ] Update `README.md` with new features
- [ ] Update `claude.md` with implementation notes
- [ ] Add more categories
- [ ] Invite friends to test multi-user functionality
- [ ] Consider Phase 3 features (task editing, priority levels, etc.)

---

**Ready to start?** Begin with Step 1 and check off each step as you complete it!
