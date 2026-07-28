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
- Donor self-serve giving portal at `/give` with donor-number lookup, NFC/QR-ready links, gateway-ready checkout, and confirmation numbers.
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

Additional seeded role-based accounts all use the password `password`:

| Email | Role | Scope |
| --- | --- | --- |
| `saas.admin@ddr.local` | SaaS Admin | All tenants |
| `admin@ddr.local` | Organization Admin | Current organization |
| `editor@ddr.local` | Editor | Current organization |
| `auditor@ddr.local` | Auditor | Current organization |
| `viewer@ddr.local` | Viewer | Current organization |

Role model:

- **SaaS Admin** sees the platform tenant overview and can administer SaaS controls across the platform.
- **Organization Admin** manages one organization workspace, including users, billing, settings, and SaaS controls.
- **Editor** can maintain operational records such as donors, donations, receipts, reports, accounts, and templates.
- **Auditor** has read-only access for reports, receipts, billing history, and audit review.
- **Viewer** has read-only workspace access.

Current subscription model:

- Every tenant is assigned the **Base** subscription model by default.
- Additional plan declinations can be added later without changing the tenant administration flow.

New organizations can also be created from the login screen with **Create organization workspace**. Each new organization receives its own isolated accounts, users, donors, donations, receipts, and reports.

## Collaborator Guide

This project is now structured as a working SaaS prototype:

1. A **SaaS Admin** can see all tenants from the Tenants page.
2. An **Organization Admin** manages one tenant workspace.
3. Editors, auditors, and viewers have different access levels inside the same tenant.
4. Each tenant has isolated donors, accounts, donations, receipts, users, billing records, gateway settings, and audit events.
5. Every tenant currently uses the **Base** subscription model by default; future paid plan variations can be added through the SaaS plan catalog.

### Self-Serve Giving Flow

The new self-serve giving feature lets a donor donate from their phone:

1. An organization admin opens **Donations** and uses the wallet/self-serve side tab.
2. The admin chooses a donor number and copies the generated tap/QR donation link.
3. That link can be placed behind an NFC tag, QR code, email button, or kiosk.
4. The donor opens the public `/give` page without logging in.
5. The donor enters or confirms their donor number.
6. The donor chooses a donation fund/account and amount.
7. The payment gateway approves the gift.
8. WeSERVE records the donation, stores the gateway confirmation metadata, and shows the donor a confirmation number.

Local example:

```text
http://127.0.0.1:5173/give?org=1&donor=1
```

The current gateway is a safe `test_gateway` implementation. It records approval and confirmation metadata for product testing. Real production card details should be handled only by a payment provider such as Stripe, Moneris, Square, or another PCI-compliant gateway. WeSERVE should store references, confirmation numbers, status, amount, donor number, and receipt state, not raw card numbers.

### Production Readiness Checklist

Before integrating a branch to `main` or using it as production-ready:

1. Run the full quality gate with `npm run test:ci`.
2. Confirm the pass rate is at least **80%**.
3. Review the generated HTML test report in `reports/test-report.html`.
4. Confirm GitHub Actions passes on the branch.
5. Open a pull request into `main` after the branch quality gate passes.

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
- `GET /api/platform/tenants`
- `PATCH /api/subscription`
- `POST /api/payment-methods`
- `DELETE /api/payment-methods/:id`
- `PATCH /api/payment-gateway`
- `GET /api/public/donation-portal`
- `POST /api/public/donation-portal/checkout`
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

All endpoints except health, login, register, forgot password, subscription requests, and public donation portal requests require:

```text
Authorization: Bearer <session-token>
```

The server derives tenant scope from the session token, so organization IDs are not trusted from client request bodies.

Public self-serve giving requests use the public organization identifier plus a donor number, then store only payment confirmation metadata. Card details should stay inside the external gateway such as Stripe, Moneris, Square, or another provider.

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

Run the full CI-quality test suite before integration:

```bash
npm run test:ci
```

The current React/SQLite flows have been checked for login, dashboard navigation, support/settings, profile updates, search, reports, receipt generation, SaaS roles, tenant visibility, self-serve giving, payment confirmation, and browser console errors.

## Notes

- This project is intended as a local functional modernization of the donation management codebase.
- The legacy ColdFusion files remain useful for feature mapping and parity checks.
- Do not commit local database files or secrets.
