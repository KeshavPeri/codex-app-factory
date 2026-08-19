# First app context — provisional

This is context for the separate product-design workshop. It is not the feature specification.

## Outcome

A lightweight, gamified football-season prediction competition for three friends, ready before Friday, 21 August 2026.

## Core idea

Each participant records preseason predictions against agreed categories, likely including:

- all 20 league finishing positions;
- cup winners;
- Golden Boot;
- most assists;
- player of the season;
- young player of the season;
- other workshop-approved categories.

At the end of the season, an administrator manually enters actual results. Transparent scoring rules compare predictions with results and produce a final leaderboard.

## Current constraints

- Keep the product deliberately small.
- Exactly three known participants initially.
- No football APIs.
- No Supabase or other backend service.
- No Vercel.
- Prefer a static GitHub Pages application.
- Predictions and actual results need a simple storage/import/export approach still to be chosen.
- An administrator may enter real-world outcomes manually.

## Decisions for the workshop

- Whether each friend uses the same browser/device or needs independent entry from separate devices.
- Whether predictions must be hidden from one another until a lock time.
- How predictions are transferred between devices without a backend.
- Exact prediction categories and scoring weights.
- Whether entries can change before the deadline and who can lock them.
- What happens when a category is tied or an award is shared.

Those decisions materially affect storage and privacy. The factory should not infer them.
