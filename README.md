# GramSeva

**Smart Rural Service & Employment Platform** — a cooperative-owned gig services platform connecting verified workers with households and communities, built for **Smart India Hackathon 2026**.

> Problem Statement **SIH26089** · Cooperative Gig Services Platform for Household & Community Services
> Theme: Agriculture, FoodTech & Rural Development · Category: Software
> Team ID **142338** · **Team Seva SIX**

---

## What is GramSeva?

Skilled cooperative workers — electricians, plumbers, carpenters, painters, domestic help, caregivers, drivers, gardeners, cleaners, technicians, cooks, and nannies — struggle to reach customers beyond their personal networks, leaving verified labour underutilised. Households, in turn, fall back on unverified word-of-mouth or expensive commercial aggregators.

GramSeva connects the two — but unlike investor-owned gig platforms, **verification and governance stay with the worker's own registered labour cooperative society**. Workers register through their cooperative, cooperatives verify their own members, and the platform layers AI-based demand matching, booking, and payments on top — without taking ownership away from the people doing the work.

## Repository structure

This is a monorepo with three parts:

```
.
├── gram_seva_app/       Flutter mobile app — household & worker-facing
├── gram-seva-backend/   FastAPI + MongoDB Atlas backend
└── gramseva-admin/      React + Vite admin dashboard (cooperative admins)
```

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter |
| Admin dashboard | React.js (Vite, plain JS) |
| Backend API | FastAPI (Python) |
| Database | MongoDB Atlas |
| Geolocation | Google Maps API |
| AI / ML | Python (scikit-learn) — demand forecasting & workforce allocation |
| Auth | Firebase Authentication (phone number) |

## Features

- **Worker onboarding** — join a registered cooperative society, select skills, upload verification documents
- **Cooperative-led verification** — workers and societies stay unverified until their cooperative confirms them
- **Service discovery & booking** — browse skill categories, book nearby verified workers
- **Admin dashboard** — cooperative admins verify workers/societies, monitor bookings, and view demand by skill/status
- **AI-assisted matching** *(planned)* — demand forecasting and workforce allocation

## Getting started

Each part has its own setup — run the backend first, then either the mobile app or the admin dashboard.

### 1. Backend (`gram-seva-backend/`)

```bash
cd gram-seva-backend
pip install -r requirements.txt
cp .env.example .env   # add your MongoDB Atlas URI
uvicorn app.main:app --reload
```
API docs available at `http://localhost:8000/docs`.

Seed sample data:
```bash
curl -X POST http://localhost:8000/services/seed
curl -X POST http://localhost:8000/societies/seed
```

### 2. Mobile app (`gram_seva_app/`)

```bash
cd gram_seva_app
flutter pub get
flutter run
```
Set the backend URL in `lib/services/api_service.dart` (`10.0.2.2:8000` for the Android emulator, `localhost:8000` for desktop/web, or your machine's LAN IP for a physical device).

### 3. Admin dashboard (`gramseva-admin/`)

```bash
cd gramseva-admin
npm install
cp .env.example .env
npm run dev
```
Open the printed local URL (usually `http://localhost:5173`).

## API overview

| Endpoint | Description |
|---|---|
| `GET /services/` | List service/skill categories |
| `GET /societies/` | List cooperative societies |
| `PATCH /societies/{id}/verify` | Verify a society |
| `POST /workers/` | Register a worker |
| `GET /workers/` | List workers (filter by skill, society, verified status) |
| `PATCH /workers/{id}/verify` | Verify a worker |
| `POST /bookings/` | Create a booking |
| `PATCH /bookings/{id}/status` | Update booking status |
| `PATCH /bookings/{id}/rate` | Rate a completed booking |

Full request/response shapes: see `gram-seva-backend/app/models/` and `app/routers/`, or the live Swagger UI at `/docs`.

## Team

**Team Seva SIX** — Smart India Hackathon 2026, Problem Statement SIH26089.
