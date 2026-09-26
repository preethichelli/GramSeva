# GramSeva Admin Dashboard

Plain-JavaScript React + Vite admin dashboard for GramSeva, a cooperative-owned
gig services platform (SIH26089). Talks directly to the FastAPI backend in
`gram-seva-backend/`.

## Setup

```bash
npm install
cp .env.example .env   # edit VITE_API_BASE_URL if your backend isn't on :8000
npm run dev
```

Make sure the backend is running first:

```bash
cd gram-seva-backend
uvicorn app.main:app --reload
```

The dashboard defaults to `http://localhost:8000` if `VITE_API_BASE_URL` isn't set.

## What's here

- **Overview** — stat cards (pending worker/society verification, active
  workers, total bookings) plus two bar-list widgets: workers by skill and
  bookings by status.
- **Workers** — table of all workers with All/Pending/Verified filter tabs,
  society lookup, skill chips, and a Verify action (`PATCH /workers/{id}/verify`).
- **Societies** — table of cooperative societies with a Verify action
  (`PATCH /societies/{id}/verify`) and a "seed sample societies" helper for
  an empty database (`POST /societies/seed`).
- **Bookings** — the backend only exposes per-worker/per-customer booking
  lookups, so this page fetches every worker then fans out one request per
  worker (`GET /bookings/worker/{worker_id}`) and merges the results
  client-side into one table, with status-progression actions
  (`PATCH /bookings/{id}/status`).
- **Services** — read-only grid of service categories (`GET /services/`),
  with a "seed default services" helper for an empty database.

Every page loads and errors independently, so if the backend is down (or a
single request fails) only that page/widget shows the error — the rest of
the dashboard keeps working.

## Notes

- No UI framework or icon library — icons are small hand-rolled inline SVGs
  in `src/components/Icons.jsx`.
- Colors/spacing follow the brand palette (deep teal, saffron, ivory, ink,
  slate, mist) defined as CSS variables at the top of `src/index.css`.
