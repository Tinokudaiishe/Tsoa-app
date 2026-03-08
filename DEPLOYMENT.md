# TSOA Packaging System — Deployment Guide
## From file to live website in ~45 minutes

---

## What you're deploying
- A React web app (works on all browsers, phones, tablets, laptops)
- Hosted for **free** on Vercel (tsoa-packaging.vercel.app or your own domain)
- Database on **free** Supabase (data shared across all devices, never lost)
- Installable on phones like a real app (PWA)

---

## STEP 1 — Set up Supabase (the database)

**Time: ~10 minutes**

1. Go to **https://supabase.com** and click **Start your project**
2. Sign up with Google or GitHub
3. Click **New Project**
   - Name: `tsoa-packaging`
   - Database Password: choose something strong, **save it**
   - Region: choose closest to Zambia/Eswatini — `East US` or `Europe West`
4. Wait ~2 minutes for the project to spin up
5. In the left sidebar, click **SQL Editor**
6. Click **New Query**
7. Open the file `supabase-schema.sql` from this folder
8. Copy everything and paste it into the SQL editor
9. Click **Run** (green button)
10. You should see "Success. No rows returned"

**Get your credentials:**
1. Left sidebar → **Settings** (gear icon) → **API**
2. Copy `Project URL` → looks like `https://abcxyz.supabase.co`
3. Copy `anon public` key → long string starting with `eyJ...`
4. Keep these, you'll need them in Step 3

---

## STEP 2 — Put the code on GitHub

**Time: ~10 minutes**

You need a free GitHub account to deploy to Vercel.

1. Go to **https://github.com** and sign up / log in
2. Click **+** (top right) → **New repository**
   - Name: `tsoa-packaging-system`
   - Set to **Private**
   - Click **Create repository**
3. On your computer, open a terminal / command prompt
4. Navigate to this project folder:
   ```
   cd path/to/tsoa-project
   ```
5. Run these commands one by one:
   ```
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/tsoa-packaging-system.git
   git push -u origin main
   ```
   *(Replace YOUR_USERNAME with your GitHub username)*

---

## STEP 3 — Deploy to Vercel

**Time: ~5 minutes**

1. Go to **https://vercel.com** and sign up with your GitHub account
2. Click **Add New Project**
3. Find `tsoa-packaging-system` in the list → click **Import**
4. Framework: Vite will be auto-detected
5. Before clicking Deploy, expand **Environment Variables** and add:

   | Name | Value |
   |------|-------|
   | `VITE_SUPABASE_URL` | your Supabase Project URL |
   | `VITE_SUPABASE_ANON_KEY` | your Supabase anon key |

6. Click **Deploy**
7. Wait ~2 minutes
8. You'll get a live URL like: `tsoa-packaging-system.vercel.app` 🎉

---

## STEP 4 — Test it

1. Open the URL Vercel gave you
2. Log in as Admin: **Admin / Admin@0000**
3. Go to Admin Console → Login Monitor (should be empty — that's correct)
4. Log out, log in as James Mutua: **James Mutua / Tsoa@1234**
5. Go to Sign In / Out and sign in
6. Log back in as Admin — you should see James's record in Login Monitor

If data shows up across different browsers/devices, **it's working**.

---

## STEP 5 — Custom domain (optional)

**If you want `tsoa.roynexdigital.com` instead of the vercel.app URL:**

1. Buy a domain at Namecheap (~$12/year) or use one you already own
2. In Vercel → Your Project → Settings → Domains
3. Add your domain and follow the DNS instructions

---

## STEP 6 — Install on phones (PWA)

The app is a **Progressive Web App** — users can install it like a real app:

**iPhone:**
1. Open Safari → go to the app URL
2. Tap the Share button (box with arrow)
3. Tap **Add to Home Screen**
4. The app appears on the home screen with an icon

**Android:**
1. Open Chrome → go to the app URL
2. Tap the 3-dot menu → **Add to Home Screen** or **Install App**

---

## STEP 7 — Share with your team

Send your team this message:
```
Hi team,

Our new TSOA Packaging Management System is now live.

Website: https://tsoa-packaging-system.vercel.app
(or install it on your phone — iPhone: Safari > Share > Add to Home Screen)

Your login details:
- James Mutua:    password Tsoa@1234
- Sarah Wanjiru:  password Tsoa@2345
- David Ochieng:  password Tsoa@3456
- Grace Akinyi:   password Tsoa@4567

Please sign in and out daily using the Sign In / Out section.
GPS location is recorded automatically.

Questions? Contact Admin.
```

---

## Updating the app later

Any time you want to make changes:
1. Edit files in the `tsoa-project` folder
2. Run `git add . && git commit -m "describe your change" && git push`
3. Vercel automatically redeploys within ~2 minutes

---

## Costs summary

| Service | Cost |
|---------|------|
| Supabase (database) | **Free** up to 500MB, 50k requests/day |
| Vercel (hosting) | **Free** for all features you need |
| Domain (optional) | ~$12/year |
| **Total** | **$0 — $12/year** |

Your team size and usage is well within free tier limits indefinitely.

---

## Troubleshooting

**"No data showing up in Admin"**
→ Check that VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY are set in Vercel environment variables

**"GPS not working"**
→ The app must be served over HTTPS (Vercel does this automatically). GPS won't work on localhost.

**"Sign in screen shows but login fails"**
→ Passwords are case-sensitive. Try exactly: `Tsoa@1234`

**Need to reset a password?**
→ Open src/App.jsx, find the USERS array at the top, change the password field, push to GitHub.

---

*Built by Roynex Digital · TSOA Technologies Packaging Management System*
