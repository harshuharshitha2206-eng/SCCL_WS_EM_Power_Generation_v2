# SCCL WSs&EM — Power Generation Reports

This starter app is based on the supplied Excel format. It treats each worksheet/location as a separate plant and removes attendance completely.

## Included
- Dashboard with today's and month-to-date generation
- Daily entry: one value per plant per date, with remarks
- Plant management (name, capacity, date synchronized to grid)
- Date-wise reports (exact date filter) and plant filter
- CSV export of the currently filtered date report
- Local demo mode (browser storage) or Supabase cloud database

## Run locally
1. Install Node.js 20 or newer.
2. Extract the ZIP and run `npm install`.
3. Run `npm run dev`.
4. Open the local URL printed by Vite.

## Cloud setup
1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. Copy Project URL and anon/public key into `.env` using `.env.example`.
4. Run `npm install`, then `npm run dev`.

Important: the included Supabase policies are a simple authenticated-team starter policy. Before production deployment, add user invitations, role-based permissions, audit logging, backups and admin-only plant management. Never expose a service-role key in the browser.

## Data interpretation
- The sample report's Generation column is stored as a decimal value.
- Unit is recorded as the literal label `Units`, matching the sample. Confirm the exact engineering meaning/scale before changing this label.
- The app does not assume generation for missing dates is zero; a missing entry remains blank/not reported.
- Monthly and daily totals sum the entered values. Only compare totals across plants if their units and reporting basis are the same.
- `sync_date` is the plant's date synchronized to grid, separate from daily report dates.
