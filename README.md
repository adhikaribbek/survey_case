# Case Register — Insurance Surveyor (shared database version)

A single-page case register for insurance surveyors, backed by a real shared database (Supabase) so your data isn't stuck in one browser. Log cases and, per case, track:

1. **Case details** — case ID, company/client, date of accident, depute date
2. **Insurance details** — insurer, insurance type, claim date, policy no, claim no
3. **Insured details** — insured bank name, insured person name
4. **Visit details** — visit no, visit date, visited by
5. **Status details** — status, date, remarks
6. **Payment details** — incurred fee, payment status, date, remarks

Every date field also shows the equivalent **Bikram Sambat (B.S.) date** automatically, and each section can be collapsed. The frontend is a single static HTML file (no build step); the data lives in a free Supabase project.

## How this is set up

- **Frontend**: `index.html` — a static page you host on GitHub Pages.
- **Database**: [Supabase](https://supabase.com) — a free hosted Postgres database. `schema.sql` creates your six tables there.
- **Connection**: `config.js` holds two values (your Supabase project URL and its public "anon" key) that tell the page which database to talk to.

Because you chose a shared link with **no login**, anyone who has your site's URL can read and write every case — there's no per-user access control. That's fine for a single surveyor or a small trusted team who won't share the link further, but it's worth understanding clearly:

- The "anon" key is visible to anyone who views your page's source — that's normal for this kind of setup, and by itself it isn't a secret. What actually controls access is the Row Level Security (RLS) policy in `schema.sql`, and right now that policy is set to fully open (`using (true)`) so the app works without logins.
- Don't post the site link somewhere public (e.g. an open forum) unless you're fine with strangers editing your case data.
- If you later want real per-user logins and access control, Supabase supports that (email/password, magic links, etc.) — it's a bigger change than what's set up here, so just flag it if you want that added.

## Step 1 — Create your Supabase project

1. Go to [supabase.com](https://supabase.com) and sign up (free tier is enough for this).
2. Click **New project**. Pick a name, a database password (save it somewhere — you likely won't need it day-to-day, but keep it), and a region close to you.
3. Wait about a minute for the project to finish provisioning.

## Step 2 — Create the tables

1. In your new project, open the **SQL Editor** (left sidebar).
2. Click **New query**, paste in the entire contents of `schema.sql` from this folder, and click **Run**.
3. You should see six new tables under **Table Editor**: `case_table`, `insurance_details`, `insured_details`, `visit_details`, `status_details`, `payment_details`.

## Step 3 — Get your connection details

1. In your Supabase project, go to **Settings → API**.
2. Copy the **Project URL** (looks like `https://abcdefgh.supabase.co`).
3. Copy the **anon public** key (a long string). Do **not** use the "service_role" key — that one must never be exposed in a browser.
4. Open `config.js` in this folder and paste both values in:
   ```js
   const SUPABASE_URL = "https://abcdefgh.supabase.co";
   const SUPABASE_ANON_KEY = "eyJhbGciOi...";
   ```
5. Save the file.

If you ever open `index.html` before doing this, you'll see a short "connect your database" message instead of the app — that's expected, and it'll go away once `config.js` has your real values.

## Step 4 — Deploy to GitHub Pages

1. **Create a new repository on GitHub** (e.g. `case-register`).
2. **Add these files** to the repo root:
   - `index.html`
   - `config.js` (with your real values filled in — see note below)
   - `schema.sql`
   - `README.md`
   - `LICENSE`
   - `.gitignore`
3. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit: case register app"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<your-repo>.git
   git push -u origin main
   ```
   (Or drag-and-drop the files into the repo via **Add file → Upload files** on the GitHub website.)
4. **Turn on GitHub Pages:**
   - Repo → **Settings → Pages**.
   - Under **Source**, choose **Deploy from a branch**.
   - Under **Branch**, choose `main` and folder `/ (root)`.
   - Click **Save**.
5. Wait a minute or two — GitHub will show your live URL, something like `https://<your-username>.github.io/<your-repo>/`.

> **About committing `config.js`:** the anon key is designed to be public (see the security note above), so it's fine to commit it — that's the standard way Supabase apps are deployed as static sites. If your repo is public and you'd rather not have the key visible in a public repo's history, you have two options: (a) make the GitHub repo **private** (note: private repos need a paid GitHub plan to use Pages), or (b) keep `config.js` out of git (it's already listed in `.gitignore` — but then you'll need to re-create it manually on any machine you deploy from, and GitHub Pages won't have it either unless you add it back before pushing). For a single-surveyor internal tool, committing it as-is is the simplest path and is what most small Supabase + GitHub Pages projects do.

Any time you push a change to `index.html` on `main`, GitHub Pages redeploys automatically within a minute or so.

## Backups

Even with a real database, it's worth keeping your own copies:

- **In the app**: the **Download backup** button in the sidebar exports every case as a `.json` file. **Restore backup** re-imports one, skipping any case ID that already exists.
- **In Supabase**: your project's data already lives in a managed Postgres database with Supabase's own infrastructure behind it. On paid plans, Supabase also offers automatic daily backups and point-in-time recovery (Project → Settings → Database → Backups) if you want a second, database-level safety net beyond the in-app export.

## Local testing before you deploy

Just double-click `index.html` to open it in your browser directly — no server needed. As long as `config.js` has your real Supabase values, it'll connect the same way it will once deployed.

## Editing the app

The interface and logic live in `index.html`. The database structure lives in `schema.sql` (re-run only the parts you change, or use Supabase's Table Editor for quick tweaks). There's no build tool or dependency to install.
