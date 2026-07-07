import { createReadStream, existsSync, statSync } from "node:fs";
import { extname, join, resolve } from "node:path";
import { createServer } from "node:http";
import { fileURLToPath } from "node:url";
import { dirname } from "node:path";
import { store } from "./db.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const rootDir = resolve(__dirname, "..");
const distDir = join(rootDir, "dist");
const port = Number(process.env.PORT || 5174);

const mimeTypes = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
};

function sendJSON(response, status, data) {
  response.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,POST,PUT,PATCH,DELETE,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });
  response.end(JSON.stringify(data));
}

function sendError(response, error) {
  sendJSON(response, error.status || 500, {
    error: error.message || "Unexpected server error",
  });
}

async function readJSON(request) {
  const chunks = [];
  for await (const chunk of request) {
    chunks.push(chunk);
  }

  if (!chunks.length) {
    return {};
  }

  return JSON.parse(Buffer.concat(chunks).toString("utf8"));
}

function getQuery(request) {
  return Object.fromEntries(new URL(request.url, `http://${request.headers.host}`).searchParams.entries());
}

function getBearerToken(request) {
  const header = request.headers.authorization || "";
  const [scheme, token] = header.split(" ");
  return scheme?.toLowerCase() === "bearer" ? token : "";
}

function requireAdmin(user) {
  if (!user?.admin) {
    const error = new Error("Admin access required");
    error.status = 403;
    throw error;
  }
}

function route(method, pathname, pattern) {
  if (!pathname.startsWith(pattern.replace(/:\w+/g, ""))) {
    return null;
  }

  const routeParts = pattern.split("/").filter(Boolean);
  const pathParts = pathname.split("/").filter(Boolean);

  if (routeParts.length !== pathParts.length) {
    return null;
  }

  const params = {};
  for (let index = 0; index < routeParts.length; index += 1) {
    if (routeParts[index].startsWith(":")) {
      params[routeParts[index].slice(1)] = pathParts[index];
    } else if (routeParts[index] !== pathParts[index]) {
      return null;
    }
  }

  return params;
}

function serveStatic(request, response) {
  if (!existsSync(distDir)) {
    sendJSON(response, 404, { error: "Build the React app with npm run build before using the production server." });
    return;
  }

  const requestPath = new URL(request.url, `http://${request.headers.host}`).pathname;
  const safePath = requestPath === "/" ? "index.html" : requestPath.replace(/^\/+/, "");
  const filePath = resolve(distDir, safePath);
  const fallbackPath = join(distDir, "index.html");

  if (!filePath.startsWith(distDir)) {
    response.writeHead(403);
    response.end("Forbidden");
    return;
  }

  const target = existsSync(filePath) && statSync(filePath).isFile() ? filePath : fallbackPath;
  response.writeHead(200, { "Content-Type": mimeTypes[extname(target)] || "application/octet-stream" });
  createReadStream(target).pipe(response);
}

async function handleAPI(request, response, pathname) {
  const method = request.method;

  if (method === "OPTIONS") {
    sendJSON(response, 204, {});
    return;
  }

  if (method === "GET" && pathname === "/api/health") {
    sendJSON(response, 200, { ok: true, databasePath: store.databasePath });
    return;
  }

  if (method === "POST" && pathname === "/api/auth/login") {
    const body = await readJSON(request);
    const user = store.login(body.courriel || body.email, body.password || body.mdp);
    if (!user) {
      sendJSON(response, 401, { error: "Invalid email or password" });
      return;
    }
    const session = store.createSession(user.utilisateurID);
    sendJSON(response, 200, { user, ...session });
    return;
  }

  if (method === "POST" && pathname === "/api/auth/register") {
    const user = store.registerOrganization(await readJSON(request));
    const session = store.createSession(user.utilisateurID);
    sendJSON(response, 201, { user, ...session });
    return;
  }

  if (method === "POST" && pathname === "/api/auth/logout") {
    sendJSON(response, 200, store.deleteSession(getBearerToken(request)));
    return;
  }

  if (method === "POST" && pathname === "/api/auth/forgot-password") {
    const body = await readJSON(request);
    sendJSON(response, 200, store.requestPasswordReset(body.courriel || body.email));
    return;
  }

  if (method === "POST" && pathname === "/api/subscription-requests") {
    sendJSON(response, 201, store.createSubscriptionRequest(await readJSON(request)));
    return;
  }

  const auth = store.authenticate(getBearerToken(request));
  if (!auth) {
    sendJSON(response, 401, { error: "Authentication required" });
    return;
  }

  if (method === "GET" && pathname === "/api/bootstrap") {
    sendJSON(response, 200, store.getBootstrap(auth));
    return;
  }

  if (method === "GET" && pathname === "/api/organization") {
    sendJSON(response, 200, store.getOrganization(auth));
    return;
  }

  if (method === "PUT" && pathname === "/api/organization") {
    requireAdmin(auth);
    sendJSON(response, 200, store.updateOrganization(await readJSON(request), auth));
    return;
  }

  if (method === "GET" && pathname === "/api/dashboard") {
    sendJSON(response, 200, store.getDashboard(auth));
    return;
  }

  if (method === "GET" && pathname === "/api/users") {
    requireAdmin(auth);
    sendJSON(response, 200, store.listUsers(auth));
    return;
  }

  if (method === "POST" && pathname === "/api/users") {
    requireAdmin(auth);
    sendJSON(response, 201, store.createUser(await readJSON(request), auth));
    return;
  }

  let params = route(method, pathname, "/api/users/:id/status");
  if (params && method === "PATCH") {
    requireAdmin(auth);
    sendJSON(response, 200, store.updateUserStatus(params.id, await readJSON(request), auth));
    return;
  }

  if (method === "GET" && pathname === "/api/donors") {
    sendJSON(response, 200, store.listDonors(getQuery(request), auth));
    return;
  }

  if (method === "GET" && pathname === "/api/donors/next-number") {
    sendJSON(response, 200, { numero: store.nextDonorNumber(auth) });
    return;
  }

  if (method === "POST" && pathname === "/api/donors") {
    sendJSON(response, 201, store.createDonor(await readJSON(request), auth));
    return;
  }

  params = route(method, pathname, "/api/donors/:id");
  if (params && method === "PUT") {
    sendJSON(response, 200, store.updateDonor(params.id, await readJSON(request), auth));
    return;
  }

  params = route(method, pathname, "/api/donors/:id/archive");
  if (params && method === "PATCH") {
    const body = await readJSON(request);
    sendJSON(response, 200, store.archiveDonor(params.id, body.actif !== false, auth));
    return;
  }

  if (method === "GET" && pathname === "/api/accounts") {
    sendJSON(response, 200, store.listAccounts(auth));
    return;
  }

  if (method === "POST" && pathname === "/api/accounts") {
    requireAdmin(auth);
    sendJSON(response, 201, store.createAccount(await readJSON(request), auth));
    return;
  }

  params = route(method, pathname, "/api/accounts/:id");
  if (params && method === "PUT") {
    requireAdmin(auth);
    sendJSON(response, 200, store.updateAccount(params.id, await readJSON(request), auth));
    return;
  }
  if (params && method === "DELETE") {
    requireAdmin(auth);
    sendJSON(response, 200, store.deleteAccount(params.id, auth));
    return;
  }

  if (method === "GET" && pathname === "/api/donations") {
    sendJSON(response, 200, store.listDonations(getQuery(request), auth));
    return;
  }

  if (method === "POST" && pathname === "/api/donations") {
    sendJSON(response, 201, store.createDonation(await readJSON(request), auth));
    return;
  }

  params = route(method, pathname, "/api/donations/:id");
  if (params && method === "PUT") {
    sendJSON(response, 200, store.updateDonation(params.id, await readJSON(request), auth));
    return;
  }
  if (params && method === "DELETE") {
    sendJSON(response, 200, store.deleteDonation(params.id, auth));
    return;
  }

  if (method === "GET" && pathname === "/api/receipts") {
    sendJSON(response, 200, store.listReceipts(getQuery(request), auth));
    return;
  }

  if (method === "GET" && pathname === "/api/receipt-batches") {
    sendJSON(response, 200, store.listReceiptBatches(auth));
    return;
  }

  if (method === "POST" && pathname === "/api/receipts/generate") {
    sendJSON(response, 201, store.generateReceipts(await readJSON(request), auth));
    return;
  }

  params = route(method, pathname, "/api/envois/:id/status");
  if (params && method === "PATCH") {
    const body = await readJSON(request);
    sendJSON(response, 200, store.patchEnvoiStatus(params.id, body.statut || body.status, auth));
    return;
  }

  if (method === "GET" && pathname === "/api/reports") {
    const query = getQuery(request);
    sendJSON(response, 200, store.report(query.type || "donations", query, auth));
    return;
  }

  sendJSON(response, 404, { error: "API route not found" });
}

const server = createServer(async (request, response) => {
  const { pathname } = new URL(request.url, `http://${request.headers.host}`);

  try {
    if (pathname.startsWith("/api/")) {
      await handleAPI(request, response, pathname);
      return;
    }

    serveStatic(request, response);
  } catch (error) {
    sendError(response, error);
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`DDR API listening on http://127.0.0.1:${port}`);
});
