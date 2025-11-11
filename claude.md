# Claude Project Documentation

## Project Overview

**Project Name:** Simple To-Do List Application
**Created:** November 11, 2025
**Repository:** https://github.com/brockmearian/MurphBootcamp.git
**Type:** Static web application → Supabase-backed multi-user application (planned)
**Purpose:** A lightweight task management tool with cloud sync and multi-user support

This project started as a single-page web application using localStorage for data persistence. It is being migrated to Supabase to enable multi-user support, cloud synchronization, categories, and due dates.

---

## Project History

### Phase 1: Initial Development (Completed)

1. **Requirements Gathering** - Created a comprehensive PRD (Product Requirements Document)
2. **Approval** - User reviewed and approved the PRD specifications
3. **Development** - Built the application as a single HTML file with embedded CSS and JavaScript
4. **Deployment Preparation** - Prepared files for Vercel deployment via GitHub
5. **Version Control** - Initialized git repository and pushed to GitHub
6. **Documentation** - Created comprehensive project documentation

### Phase 2: Supabase Migration (In Progress)

1. **Requirements Gathering** - Defined multi-user requirements with categories and due dates
2. **Database Design** - Created Supabase schema with tables, indexes, and RLS policies
3. **Documentation** - Created migration guide and SQL schema
4. **Next Steps** - Implement authentication UI and Supabase client integration

### Key Decisions

**Phase 1:**
- **Single File Architecture**: Embedded CSS/JS in HTML for zero dependencies
- **localStorage**: Used browser localStorage API for simplicity
- **No Framework**: Vanilla JavaScript for performance
- **Vercel Deployment**: Static site hosting with GitHub integration

**Phase 2 (Supabase Migration):**
- **Multi-User Support**: Add Supabase Auth for user accounts
- **Cloud Storage**: Replace localStorage with PostgreSQL database
- **Categories**: Allow users to organize tasks into categories
- **Due Dates**: Enable task scheduling with optional due dates
- **Row Level Security**: Ensure users can only access their own data

---

## File Structure

### Current Files

```
To Do List/
├── index.html              # Main application file (7,251 bytes) - localStorage version
├── todo-list-prd.md       # Product Requirements Document (original)
├── README.md              # GitHub-facing project documentation
├── claude.md              # This file - comprehensive project documentation
├── .gitignore             # Git ignore rules
├── supabase-schema.sql    # Supabase database migration SQL
└── SUPABASE_SETUP.md      # Step-by-step Supabase integration guide
```

### Planned Files (After Supabase Migration)

```
To Do List/
├── index.html              # Updated with Supabase client and auth UI
├── supabase-client.js      # Supabase initialization and API functions (optional)
├── auth.js                 # Authentication logic (optional)
├── .env                    # Environment variables (not committed)
└── ... (existing files)
```

---

## Features & Functionality

### Phase 1 Features (Implemented)

✅ **Add Tasks** - Text input with validation
✅ **View Tasks** - Chronological list display
✅ **Complete Tasks** - Checkbox toggle with visual feedback
✅ **Delete Tasks** - Permanent removal
✅ **Task Statistics** - Total and completed count
✅ **Data Persistence** - localStorage API
✅ **Responsive Design** - Mobile and desktop support

### Phase 2 Features (Planned - Supabase)

🔄 **User Authentication** - Email/password or OAuth
🔄 **Cloud Sync** - Tasks stored in Supabase PostgreSQL
🔄 **Multi-User Support** - Each user has their own tasks
🔄 **Categories** - Organize tasks (Personal, Work, Shopping, etc.)
🔄 **Due Dates** - Optional deadlines for tasks
🔄 **Category Colors** - Visual color coding
🔄 **Overdue Indicators** - Highlight tasks past due date
🔄 **Data Migration** - Import from localStorage

### Future Enhancements (Phase 3+)

❌ Task editing (inline edit text)
❌ Priority levels (high, medium, low)
❌ Subtasks and checklists
❌ Recurring tasks
❌ Search and filter
❌ Drag-and-drop reordering
❌ Task sharing between users
❌ Mobile app versions

---

## Database Schema (Supabase)

### Tables

#### 1. **tasks** table
```sql
- id              UUID (primary key)
- user_id         UUID (foreign key → auth.users)
- title           TEXT (not null)
- completed       BOOLEAN (default: false)
- due_date        DATE (nullable)
- category_id     UUID (foreign key → categories, nullable)
- created_at      TIMESTAMPTZ (default: now())
- updated_at      TIMESTAMPTZ (auto-updated on change)
```

**Indexes:**
- `user_id` - Fast user task lookups
- `category_id` - Filter by category
- `due_date` - Query upcoming/overdue tasks
- `completed` - Separate active/completed tasks

#### 2. **categories** table
```sql
- id              UUID (primary key)
- user_id         UUID (foreign key → auth.users)
- name            TEXT (not null, unique per user)
- color           TEXT (nullable, hex color code)
- created_at      TIMESTAMPTZ (default: now())
```

**Indexes:**
- `user_id` - Fast user category lookups

#### 3. **auth.users** (Supabase built-in)
- Managed by Supabase Auth
- Stores user credentials and metadata

### Relationships

```
auth.users (1) ──< (many) tasks
auth.users (1) ──< (many) categories
categories (1) ──< (many) tasks
```

### Row Level Security (RLS)

All tables have RLS enabled with policies ensuring:
- Users can only SELECT their own data
- Users can only INSERT data for themselves
- Users can only UPDATE their own data
- Users can only DELETE their own data

---

## Technical Stack

### Current Stack (Phase 1)

- **HTML5** - Document structure
- **CSS3** - Styling with Flexbox and responsive design
- **JavaScript (ES6+)** - Application logic
- **localStorage API** - Data persistence
- **No dependencies** - Pure vanilla implementation

### Updated Stack (Phase 2)

- **HTML5** - Document structure
- **CSS3** - Enhanced with category colors and due date indicators
- **JavaScript (ES6+)** - Application logic
- **Supabase Client Library** - Database and authentication
- **Supabase PostgreSQL** - Cloud database
- **Supabase Auth** - User authentication
- **Row Level Security** - Data isolation

### Browser Requirements

- Modern browsers supporting:
  - ES6 JavaScript features
  - Fetch API
  - Async/await
  - CSS Flexbox
  - CSS transitions
- Compatible with:
  - Chrome/Edge (latest)
  - Firefox (latest)
  - Safari (latest)
  - Mobile browsers

---

## Deployment Information

### GitHub Repository

**URL:** https://github.com/brockmearian/MurphBootcamp.git
**Branch:** main
**Root Directory:** `To Do List/`

### Vercel Deployment

**Current Status:** Deployed (localStorage version)
**Configuration:**
- Root Directory: `To Do List`
- Framework: Other (static site)
- Build Command: (none)
- Output Directory: (none)

**After Supabase Migration:**
- Add environment variables:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`
- Redeploy after updating code

---

## Supabase Migration Plan

### Overview

Migrate from a single-user localStorage app to a multi-user Supabase-backed application with authentication, categories, and due dates.

### Migration Steps

1. **Setup Supabase Project**
   - Create project at supabase.com
   - Get API keys (URL and anon key)

2. **Run Database Migration**
   - Execute `supabase-schema.sql` in SQL Editor
   - Verify tables and RLS policies

3. **Enable Authentication**
   - Configure email/password auth
   - Optional: Enable OAuth providers (Google, GitHub)

4. **Update Application Code**
   - Install Supabase client library
   - Add authentication UI (login, signup, logout)
   - Replace localStorage functions with Supabase queries
   - Add category management UI
   - Add due date picker
   - Implement data migration from localStorage

5. **Test Thoroughly**
   - Test user registration and login
   - Test task CRUD operations
   - Test category management
   - Test RLS (create multiple test users)
   - Test responsive design

6. **Deploy to Vercel**
   - Add environment variables
   - Push updated code to GitHub
   - Verify automatic deployment

### API Patterns

**Authentication:**
```javascript
// Sign up
await supabase.auth.signUp({ email, password })

// Sign in
await supabase.auth.signInWithPassword({ email, password })

// Sign out
await supabase.auth.signOut()

// Check session
supabase.auth.onAuthStateChange((event, session) => { ... })
```

**Tasks:**
```javascript
// Create
await supabase.from('tasks').insert([{ title, due_date, category_id }])

// Read
await supabase.from('tasks').select('*, category:categories(*)').order('created_at')

// Update
await supabase.from('tasks').update({ completed }).eq('id', taskId)

// Delete
await supabase.from('tasks').delete().eq('id', taskId)
```

**Categories:**
```javascript
// Create
await supabase.from('categories').insert([{ name, color }])

// Read
await supabase.from('categories').select('*').order('name')

// Delete
await supabase.from('categories').delete().eq('id', categoryId)
```

---

## Development Workflow

### Local Development

**Current (localStorage version):**
```bash
# Open in browser
open index.html
```

**After Supabase Migration:**
```bash
# Install dependencies (if using npm)
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your Supabase credentials

# Open in browser or use a dev server
npx vite  # or your preferred dev server
```

### Making Changes

```bash
cd "/Users/brockmearian/Library/CloudStorage/OneDrive-BrighamYoungUniversity/MurphBootcamp/To Do List"

# Make your changes
# Test locally

# Commit and push
git add .
git commit -m "Description of changes"
git push
```

### Testing Checklist

**Authentication:**
- [ ] User can sign up with email/password
- [ ] User receives confirmation email (if enabled)
- [ ] User can sign in
- [ ] User can sign out
- [ ] Session persists across page reloads
- [ ] User can't access app without authentication

**Categories:**
- [ ] User can create categories
- [ ] User can view all their categories
- [ ] User can assign colors to categories
- [ ] User can delete categories (tasks become uncategorized)
- [ ] User can't see other users' categories

**Tasks:**
- [ ] User can create tasks
- [ ] User can create tasks with categories
- [ ] User can create tasks with due dates
- [ ] User can toggle task completion
- [ ] User can delete tasks
- [ ] User can view task statistics
- [ ] Overdue tasks are highlighted
- [ ] User can't see other users' tasks

**Data Migration:**
- [ ] localStorage tasks can be migrated to Supabase
- [ ] Migration preserves task text and completion status
- [ ] Migration is optional (user can start fresh)

---

## Security Considerations

### Current (localStorage)

✅ **XSS Prevention** - `escapeHtml()` function sanitizes task text
✅ **No Backend** - No server-side vulnerabilities
✅ **Privacy** - Data never leaves user's browser

### After Supabase Migration

✅ **Row Level Security** - Users isolated via PostgreSQL RLS policies
✅ **Authentication** - Supabase Auth handles secure password storage
✅ **API Key Security** - Anon key is safe to expose (RLS protects data)
⚠️ **HTTPS Only** - Vercel provides HTTPS automatically
⚠️ **Email Verification** - Recommended for production
⚠️ **Rate Limiting** - Consider Supabase rate limits for free tier

### Best Practices

1. **Never commit `.env` files** - Use `.gitignore`
2. **Use environment variables** - Keep credentials out of code
3. **Enable email confirmation** - Prevent fake accounts
4. **Implement input validation** - Both client and server side
5. **Monitor Supabase usage** - Stay within free tier limits

---

## Performance

### Current (localStorage)

- **Load Time:** Instant (~7KB single file)
- **Runtime:** Fast for <1000 tasks
- **Scalability:** Limited by localStorage (5-10MB)

### After Supabase Migration

- **Load Time:** +~100ms for Supabase client library
- **Initial Query:** ~100-200ms for task list
- **Subsequent Queries:** Fast with Supabase connection pooling
- **Scalability:** Effectively unlimited (PostgreSQL)

### Optimization Strategies

1. **Implement pagination** - Load 50 tasks at a time
2. **Cache category list** - Rarely changes
3. **Optimistic UI updates** - Update UI before API response
4. **Debounce search/filter** - Reduce query frequency
5. **Use indexes** - Already implemented in schema
6. **Enable connection pooling** - Supabase default

---

## Troubleshooting

### Common Issues

**Issue:** Tasks not loading after Supabase migration
**Solution:** Check RLS policies, verify user authentication, check browser console

**Issue:** Can see other users' data
**Solution:** RLS policies not applied correctly, re-run migration SQL

**Issue:** "Invalid API key" error
**Solution:** Verify `.env` file has correct Supabase URL and anon key

**Issue:** Email confirmation not working
**Solution:** Check spam folder, disable confirmation for testing

**Issue:** Tasks disappear after page reload
**Solution:** Check if Supabase queries are using correct user_id

---

## Resources

### Documentation

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase JavaScript Client](https://supabase.com/docs/reference/javascript/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Auth](https://supabase.com/docs/guides/auth)

### Project Files

- `SUPABASE_SETUP.md` - Detailed migration guide
- `supabase-schema.sql` - Database schema and RLS policies
- `todo-list-prd.md` - Original product requirements

---

## Contact & Maintenance

**Project Owner:** Brock Mearian
**Email:** brockmearian@byu.edu
**Created with:** Claude Code (Anthropic)
**Last Updated:** November 11, 2025

### Maintenance Schedule

**Regular:**
- Monitor Supabase usage metrics
- Check for Supabase client library updates
- Review user feedback and feature requests

**As Needed:**
- Update RLS policies if data model changes
- Migrate to paid Supabase plan if exceeding free tier
- Implement additional features from Phase 3 roadmap

---

## Version History

### v1.0 (November 11, 2025)
- ✅ Initial release with localStorage
- ✅ Add, complete, delete tasks
- ✅ Task statistics
- ✅ Responsive design
- ✅ Deployed to Vercel via GitHub

### v2.0 (Planned)
- 🔄 Supabase integration
- 🔄 User authentication
- 🔄 Multi-user support
- 🔄 Categories
- 🔄 Due dates
- 🔄 Data migration tool

### v3.0 (Future)
- ❌ Task editing
- ❌ Priority levels
- ❌ Advanced filtering
- ❌ Task sharing

---

**This document captures all context and decisions for the To-Do List project. Update this file when making significant changes or adding new features.**
