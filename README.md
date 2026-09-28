# Hybrid Reef

A pixel aquarium where you breed fish and race your family to discover new species.
About 1.9 million named species are possible.

Everything runs in the browser. Each player's reef saves on their own device.
The optional family board (first discoveries, leaderboard, live "Mom just discovered…" alerts) uses a free Supabase database.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole game |
| `config.js` | Your Supabase URL and public key (blank = solo mode) |
| `supabase-setup.sql` | Creates the family board table; run once in Supabase |
| `manifest.webmanifest`, `sw.js`, `icons/` | Make it installable and playable offline |

## 1. Put it on GitHub Pages

1. On github.com, click **New repository**, name it `hybrid-reef`, keep it **Public**, and create it.
2. Upload these files (drag the whole folder contents onto **Add file → Upload files**), or push with git:
   ```bash
   git init
   git add .
   git commit -m "Hybrid Reef"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/hybrid-reef.git
   git push -u origin main
   ```
3. In the repo, go to **Settings → Pages**, set **Source** to *Deploy from a branch*, pick `main` and `/ (root)`, and save.
4. After a minute the game is live at `https://YOUR-USERNAME.github.io/hybrid-reef/`.

## 2. Turn on the family board (optional)

1. Go to supabase.com, choose **Sign in with GitHub**, and create a new project (free plan).
2. Open **SQL Editor**, paste all of `supabase-setup.sql`, and click **Run**.
3. Open **Project Settings → API** (or **API Keys**). Copy the **Project URL** and the **anon / publishable** key.
   Never use the `service_role` / secret key.
4. Paste both into `config.js`, then commit and push (or re-upload `config.js`).

## 3. Install it like an app

- **iPhone / iPad (Safari):** open the link → Share → **Add to Home Screen**.
- **Android (Chrome):** open the link → ⋮ menu → **Install app** / **Add to Home screen**.
- **Computer (Chrome / Edge):** click the install icon in the address bar.

## Notes

- Anyone with the link can play and add discoveries to the board. That's fine for family, but don't post the link publicly.
- Discoveries made while offline sync the next time the game connects.
- To update the game, edit the files and push again. Players get the new version the next time they open it online.
