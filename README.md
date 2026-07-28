# WeSERVE SaaS

WeSERVE SaaS is a modernized React and SQLite donation management application. It keeps legacy ColdFusion source in the repository for reference while providing a functional SaaS workspace for multiple charities with isolated donors, donations, accounts, receipts, reports, organization settings, support, subscription management, billing artifacts, security controls, API access, webhook configuration, onboarding, and audit visibility.

## Features

- React/Vite dashboard for donation management operations.
- SQLite-backed API for tenant-scoped donors, gifts, accounts, receipts, reports, organization profile, and subscription requests.
- Bearer-token sessions for authenticated API access.
- Self-service organization registration from the login screen.
- Per-organization workspace isolation.
- Admin user management for adding and deactivating workspace users.
- SaaS plan catalog with per-plan seat, donor, donation, and receipt limits.
- Subscription lifecycle controls with monthly/annual billing cycle updates.
- Billing center with payment-method metadata and invoice history.
- Tenant security settings for MFA requirement, password minimum, session timeout, and allowed domains.
- API key and webhook administration for integration-ready SaaS workflows.
- Onboarding checklist and audit log for operational readiness.
- Secure local login seeded for development.
- Receipt batch generation with email/print status tracking.
- CSV exports for donors and reports.
- Organization profile/settings screen for receipt and account administration.
- Support/tutorial shortcuts mapped to the working WeSERVE screens.

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

New organizations can also be created from the login screen with **Create organization workspace**. Each new organization receives its own isolated accounts, users, donors, donations, receipts, and reports.

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
data/weserve.sqlite
```

This file is ignored by Git so each developer can keep local test data. Override the path with:

```bash
WESERVE_DATABASE_PATH=/path/to/weserve.sqlite npm run dev
```

## API Overview

Core endpoints include:

- `POST /api/auth/login`
- `POST /api/auth/register`
- `POST /api/auth/logout`
- `POST /api/auth/forgot-password`
- `GET /api/bootstrap`
- `GET /api/dashboard`
- `GET /api/saas`
- `PATCH /api/subscription`
- `POST /api/payment-methods`
- `DELETE /api/payment-methods/:id`
- `PATCH /api/security-settings`
- `POST /api/api-keys`
- `DELETE /api/api-keys/:id`
- `POST /api/webhooks`
- `POST /api/webhooks/:id/test`
- `DELETE /api/webhooks/:id`
- `PATCH /api/onboarding/:taskKey`
- `GET /api/audit-events`
- `GET /api/organization`
- `PUT /api/organization`
- `GET /api/users`
- `POST /api/users`
- `PATCH /api/users/:id/status`
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

All endpoints except health, login, register, forgot password, and subscription requests require:

```text
Authorization: Bearer <session-token>
```

The server derives tenant scope from the session token, so organization IDs are not trusted from client request bodies.

## Project Layout

```text
src/        React app and styles
server/     Node API and SQLite store
scripts/    Development server runner
data/       Local SQLite database location
images/     Legacy image assets retained for reference
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

- This project is intended as a local functional modernization of the donation management codebase.
- The legacy ColdFusion files remain useful for feature mapping and parity checks.
- Do not commit local database files or secrets.
