# DDR React SaaS

DDR React SaaS is a modernized React and SQLite version of the original DDR2 donation management application. It keeps the legacy ColdFusion source in the repository for reference while providing a functional local SaaS-style workspace for donors, donations, accounts, receipts, reports, organization settings, support, and subscription requests.

## Features

- React/Vite dashboard for DDR operations.
- SQLite-backed API for donors, gifts, accounts, receipts, reports, organization profile, and subscription requests.
- Secure local login seeded for development.
- Receipt batch generation with email/print status tracking.
- CSV exports for donors and reports.
- Organization profile/settings screen based on the original DDR profile flow.
- Support/tutorial shortcuts mapped to the original DDR workflows.

## Tech Stack

- React 18
- Vite
- Node.js HTTP server
- SQLite via `node:sqlite`
- Plain CSS
- Legacy ColdFusion files retained for reference

## Getting Started

Install dependencies:

```bash
npm install
```

Start the local development app:

```bash
npm run dev -- --host 127.0.0.1
```

Open:

```text
http://127.0.0.1:5173/
```

The API runs on:

```text
http://127.0.0.1:5174/
```

Vite proxies `/api/*` requests from port `5173` to the API server.

## Development Login

The seeded local account is:

```text
Email: admin@ddr.local
Password: password
```

## Scripts

```bash
npm run dev        # Start API + Vite dev server
npm run build      # Build React app for production
npm run start      # Serve API and built dist assets
npm run dev:api    # Start API only
npm run dev:client # Start Vite only
```

## Database

The app creates and seeds a local SQLite database at:

```text
data/ddr.sqlite
```

This file is ignored by Git so each developer can keep local test data. Override the path with:

```bash
DDR_DATABASE_PATH=/path/to/ddr.sqlite npm run dev
```

## API Overview

Core endpoints include:

- `POST /api/auth/login`
- `POST /api/auth/forgot-password`
- `GET /api/bootstrap`
- `GET /api/dashboard`
- `GET /api/organization`
- `PUT /api/organization`
- `GET /api/donors`
- `POST /api/donors`
- `GET /api/accounts`
- `POST /api/accounts`
- `GET /api/donations`
- `POST /api/donations`
- `GET /api/receipts`
- `POST /api/receipts/generate`
- `GET /api/reports`
- `POST /api/subscription-requests`

## Project Layout

```text
src/        React app and styles
server/     Node API and SQLite store
scripts/    Development server runner
data/       Local SQLite database location
images/     Legacy DDR image assets used by React
cfc/        Original ColdFusion components
_utilisateurs/ Original protected ColdFusion screens
```

## Validation

Run the production build before pushing changes:

```bash
npm run build
```

The current React/SQLite flows have been checked for login, dashboard navigation, support/settings, profile updates, search, reports, receipt generation, and browser console errors.

## Notes

- This project is intended as a local functional modernization of the original DDR codebase.
- The legacy ColdFusion files remain useful for feature mapping and parity checks.
- Do not commit local database files or secrets.
