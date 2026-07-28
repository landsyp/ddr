import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test, { after, before } from "node:test";

const databasePath = join(tmpdir(), `weserve-rbac-${process.pid}-${Date.now()}.sqlite`);
const port = 6200 + (process.pid % 900);
const baseURL = `http://127.0.0.1:${port}`;
const credentials = {
  saasAdmin: { email: "saas.admin@ddr.local", role: "saas_admin" },
  orgAdmin: { email: "admin@ddr.local", role: "org_admin" },
  editor: { email: "editor@ddr.local", role: "editor" },
  auditor: { email: "auditor@ddr.local", role: "auditor" },
  viewer: { email: "viewer@ddr.local", role: "viewer" },
};

let serverProcess;
let serverOutput = "";
const sessions = new Map();

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
  for (const [key, expected] of Object.entries(credentials)) {
    sessions.set(key, await login(expected.email));
  }
});

after(() => {
  serverProcess?.kill();
  rmSync(databasePath, { force: true });
  rmSync(`${databasePath}-shm`, { force: true });
  rmSync(`${databasePath}-wal`, { force: true });
});

test("seeded users expose distinct SaaS and tenant roles", async () => {
  for (const [key, expected] of Object.entries(credentials)) {
    const session = sessions.get(key);
    assert.equal(session.user.role, expected.role);
    assert.equal(session.user.admin, expected.role === "saas_admin" || expected.role === "org_admin");
  }
});

test("SaaS admin can see all tenants and tenant users cannot", async () => {
  const saasResponse = await api("/api/platform/tenants", { token: sessions.get("saasAdmin").token });
  assert.equal(saasResponse.status, 200);
  assert.ok(Array.isArray(saasResponse.body));
  assert.ok(saasResponse.body.length >= 1);
  assert.ok(saasResponse.body[0].planName);

  for (const role of ["orgAdmin", "editor", "auditor", "viewer"]) {
    const response = await api("/api/platform/tenants", { token: sessions.get(role).token });
    assert.equal(response.status, 403);
  }
});

test("bootstrap returns role definitions and SaaS admins get platform tenants", async () => {
  const saasBootstrap = await api("/api/bootstrap", { token: sessions.get("saasAdmin").token });
  assert.equal(saasBootstrap.status, 200);
  assert.ok(saasBootstrap.body.roleDefinitions.saas_admin);
  assert.ok(saasBootstrap.body.roleOptions.includes("saas_admin"));
  assert.ok(saasBootstrap.body.platformTenants.length >= 1);

  const tenantBootstrap = await api("/api/bootstrap", { token: sessions.get("orgAdmin").token });
  assert.equal(tenantBootstrap.status, 200);
  assert.ok(!tenantBootstrap.body.roleOptions.includes("saas_admin"));
  assert.equal(tenantBootstrap.body.platformTenants.length, 0);
});

test("organization admins can assign tenant roles but not SaaS admin", async () => {
  const created = await api("/api/users", {
    method: "POST",
    token: sessions.get("orgAdmin").token,
    body: {
      prenom: "Role",
      nom: "Tester",
      email: `role-${Date.now()}@example.org`,
      password: "password123",
      role: "auditor",
      langue: "en",
    },
  });
  assert.equal(created.status, 201);
  assert.equal(created.body.role, "auditor");
  assert.equal(created.body.admin, false);

  const denied = await api("/api/users", {
    method: "POST",
    token: sessions.get("orgAdmin").token,
    body: {
      prenom: "Platform",
      nom: "Denied",
      email: `platform-${Date.now()}@example.org`,
      password: "password123",
      role: "saas_admin",
      langue: "en",
    },
  });
  assert.equal(denied.status, 403);
});

test("editors can change operational data while auditors and viewers are read-only", async () => {
  const editorCreate = await api("/api/donors", {
    method: "POST",
    token: sessions.get("editor").token,
    body: {
      numero: `90${Date.now().toString().slice(-4)}`,
      prenom: "Editor",
      nom: "Allowed",
      courriel: "editor.allowed@example.org",
    },
  });
  assert.equal(editorCreate.status, 201);
  assert.equal(editorCreate.body.nom, "Allowed");

  for (const role of ["auditor", "viewer"]) {
    const response = await api("/api/donors", {
      method: "POST",
      token: sessions.get(role).token,
      body: {
        numero: `91${Date.now().toString().slice(-4)}`,
        prenom: role,
        nom: "Denied",
      },
    });
    assert.equal(response.status, 403);
  }
});

test("auditors can review audit events and viewers cannot", async () => {
  const auditorResponse = await api("/api/audit-events", { token: sessions.get("auditor").token });
  assert.equal(auditorResponse.status, 200);
  assert.ok(Array.isArray(auditorResponse.body));

  const viewerResponse = await api("/api/audit-events", { token: sessions.get("viewer").token });
  assert.equal(viewerResponse.status, 403);
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
