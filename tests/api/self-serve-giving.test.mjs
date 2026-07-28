import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test, { after, before } from "node:test";

const databasePath = join(tmpdir(), `weserve-self-serve-${process.pid}-${Date.now()}.sqlite`);
const port = 7100 + (process.pid % 700);
const baseURL = `http://127.0.0.1:${port}`;

let serverProcess;
let serverOutput = "";
let adminSession;
let portal;
let confirmation;

before(async () => {
  serverProcess = spawn(process.execPath, ["server/index.js"], {
    cwd: process.cwd(),
    env: {
      ...process.env,
      PORT: String(port),
      WESERVE_DATABASE_PATH: databasePath,
    },
    stdio: ["ignore", "pipe", "pipe"],
  });

  serverProcess.stdout.on("data", (chunk) => {
    serverOutput += chunk.toString();
  });
  serverProcess.stderr.on("data", (chunk) => {
    serverOutput += chunk.toString();
  });

  await waitForServer();
  adminSession = await login("admin@ddr.local");
});

after(() => {
  serverProcess?.kill();
  rmSync(databasePath, { force: true });
  rmSync(`${databasePath}-shm`, { force: true });
  rmSync(`${databasePath}-wal`, { force: true });
});

test("public giving portal resolves an active donor number without authentication", async () => {
  const response = await api("/api/public/donation-portal?org=1&donor=1");
  assert.equal(response.status, 200);
  assert.equal(response.body.organization.name, "Grace Community Church");
  assert.equal(response.body.donor.donorNumber, "1");
  assert.equal(response.body.donor.fullName, "Amelie Gagnon");
  assert.equal(response.body.gateway.status, "ready");
  assert.equal(response.body.gateway.tapToDonateEnabled, true);
  assert.ok(response.body.accounts.length >= 1);
  portal = response.body;
});

test("organization admin can configure the donor payment gateway metadata", async () => {
  const response = await api("/api/payment-gateway", {
    method: "PATCH",
    token: adminSession.token,
    body: {
      provider: "stripe",
      mode: "test",
      publicKey: "pk_test_demo",
      merchantAccount: "acct_test_grace",
      tapToDonateEnabled: true,
      confirmationEmailEnabled: true,
    },
  });
  assert.equal(response.status, 200);
  assert.equal(response.body.provider, "stripe");
  assert.equal(response.body.mode, "test");
  assert.equal(response.body.tapToDonateEnabled, true);

  const publicResponse = await api("/api/public/donation-portal?org=1&donor=1");
  assert.equal(publicResponse.status, 200);
  assert.equal(publicResponse.body.gateway.provider, "stripe");
});

test("self-serve checkout confirms payment and writes the donation register", async () => {
  const response = await api("/api/public/donation-portal/checkout", {
    method: "POST",
    body: {
      org: "1",
      donorNumber: "1",
      compteID: portal.accounts[0].compteID,
      amount: 64.25,
      donorEmail: "amelie.gagnon@example.org",
      note: "Phone tap gift",
    },
  });
  assert.equal(response.status, 201);
  assert.equal(response.body.confirmation.status, "approved");
  assert.equal(response.body.confirmation.amount, 64.25);
  assert.equal(response.body.confirmation.gatewayProvider, "stripe");
  assert.match(response.body.confirmation.confirmationNumber, /^WSG-\d{4}-[A-F0-9]{6}$/);
  confirmation = response.body.confirmation;

  const donations = await api("/api/donations?search=Self-serve&limit=500", { token: adminSession.token });
  assert.equal(donations.status, 200);
  const createdDonation = donations.body.find((donation) => donation.montant === 64.25 && donation.donorName === "Amelie Gagnon");
  assert.ok(createdDonation);
  assert.equal(createdDonation.methode_en, "Card");
  assert.equal(createdDonation.receiptStatus, "Ready");
});

test("bootstrap exposes recent self-serve confirmation history", async () => {
  const response = await api("/api/bootstrap", { token: adminSession.token });
  assert.equal(response.status, 200);
  const recentPayment = response.body.selfServeGiving.recentPayments.find((payment) => payment.confirmationNumber === confirmation.confirmationNumber);
  assert.ok(recentPayment);
  assert.equal(recentPayment.gatewayProvider, "stripe");
  assert.equal(recentPayment.donorName, "Amelie Gagnon");
});

test("self-serve checkout rejects unknown donors and invalid amounts", async () => {
  const unknownDonor = await api("/api/public/donation-portal/checkout", {
    method: "POST",
    body: {
      org: "1",
      donorNumber: "99999",
      compteID: portal.accounts[0].compteID,
      amount: 25,
    },
  });
  assert.equal(unknownDonor.status, 404);

  const invalidAmount = await api("/api/public/donation-portal/checkout", {
    method: "POST",
    body: {
      org: "1",
      donorNumber: "1",
      compteID: portal.accounts[0].compteID,
      amount: 0,
    },
  });
  assert.equal(invalidAmount.status, 400);
});

async function login(email) {
  const response = await api("/api/auth/login", {
    method: "POST",
    body: { email, password: "password" },
  });
  assert.equal(response.status, 200, `Login failed for ${email}: ${JSON.stringify(response.body)}`);
  return response.body;
}

async function api(path, { method = "GET", token = "", body } = {}) {
  const response = await fetch(`${baseURL}${path}`, {
    method,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await response.text();
  return {
    status: response.status,
    body: text ? JSON.parse(text) : null,
  };
}

async function waitForServer() {
  const startedAt = Date.now();
  while (Date.now() - startedAt < 6000) {
    if (serverProcess.exitCode !== null) {
      throw new Error(`Test API server exited early:\n${serverOutput}`);
    }

    try {
      const response = await fetch(`${baseURL}/api/health`);
      if (response.ok) {
        return;
      }
    } catch {
      await new Promise((resolve) => setTimeout(resolve, 120));
    }
  }

  throw new Error(`Timed out waiting for test API server:\n${serverOutput}`);
}
