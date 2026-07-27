import { existsSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { createHash, randomBytes, scryptSync, timingSafeEqual } from "node:crypto";
import { DatabaseSync } from "node:sqlite";

const __dirname = dirname(fileURLToPath(import.meta.url));
const dataDir = join(__dirname, "..", "data");
const databasePath = process.env.WESERVE_DATABASE_PATH || process.env.DDR_DATABASE_PATH || join(dataDir, "weserve.sqlite");

if (!existsSync(dataDir)) {
  mkdirSync(dataDir, { recursive: true });
}

const db = new DatabaseSync(databasePath);
db.exec("PRAGMA foreign_keys = ON");
db.exec("PRAGMA journal_mode = WAL");

function hashPassword(password, salt = randomBytes(16).toString("hex")) {
  const hash = scryptSync(password, salt, 64).toString("hex");
  return `${salt}:${hash}`;
}

function verifyPassword(password, storedHash) {
  const [salt, hash] = String(storedHash || "").split(":");
  if (!salt || !hash) {
    return false;
  }

  const candidate = scryptSync(password, salt, 64);
  const saved = Buffer.from(hash, "hex");

  return saved.length === candidate.length && timingSafeEqual(saved, candidate);
}

function setupSchema() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS provinces (
      provinceID INTEGER PRIMARY KEY,
      pays_fr TEXT NOT NULL,
      pays_en TEXT NOT NULL,
      provinceEtat_fr TEXT NOT NULL,
      provinceEtat_en TEXT NOT NULL,
      abreviation TEXT NOT NULL,
      ordre INTEGER NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS organismes (
      organismeID INTEGER PRIMARY KEY AUTOINCREMENT,
      actif INTEGER NOT NULL DEFAULT 1,
      adresse TEXT,
      code_postal TEXT,
      date_fin_licence TEXT NOT NULL,
      devise TEXT NOT NULL DEFAULT 'CAD',
      enregistrement TEXT NOT NULL,
      folio TEXT,
      membre INTEGER NOT NULL DEFAULT 0,
      organisme TEXT NOT NULL,
      provinceID INTEGER REFERENCES provinces(provinceID),
      reponse_courriel TEXT,
      responsable TEXT NOT NULL,
      responsable_courriel TEXT,
      telephone TEXT,
      transit TEXT,
      ville TEXT
    );

    CREATE TABLE IF NOT EXISTS utilisateurs (
      utilisateurID INTEGER PRIMARY KEY AUTOINCREMENT,
      actif INTEGER NOT NULL DEFAULT 1,
      admin INTEGER NOT NULL DEFAULT 0,
      courriel TEXT NOT NULL,
      langue TEXT NOT NULL DEFAULT 'en',
      mot_de_passe TEXT NOT NULL,
      nom TEXT NOT NULL,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID),
      prenom TEXT NOT NULL,
      utilisateurStatutID INTEGER NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS sessions (
      sessionID INTEGER PRIMARY KEY AUTOINCREMENT,
      token_hash TEXT NOT NULL UNIQUE,
      utilisateurID INTEGER NOT NULL REFERENCES utilisateurs(utilisateurID) ON DELETE CASCADE,
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      expiresAt TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS comptes (
      compteID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      noCompte INTEGER NOT NULL,
      nom TEXT NOT NULL,
      recu INTEGER NOT NULL DEFAULT 1,
      UNIQUE (organismeID, noCompte)
    );

    CREATE TABLE IF NOT EXISTS donateurs (
      donateurID INTEGER PRIMARY KEY AUTOINCREMENT,
      actif INTEGER NOT NULL DEFAULT 1,
      adresse TEXT,
      code_postal TEXT,
      courriel TEXT,
      membre INTEGER NOT NULL DEFAULT 0,
      nom TEXT NOT NULL,
      notes TEXT,
      numero TEXT NOT NULL,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      prenom TEXT NOT NULL DEFAULT '',
      provinceID INTEGER REFERENCES provinces(provinceID),
      recu INTEGER NOT NULL DEFAULT 1,
      tel_bureau TEXT,
      tel_cellulaire TEXT,
      tel_residence TEXT,
      ville TEXT,
      UNIQUE (organismeID, numero)
    );

    CREATE TABLE IF NOT EXISTS methodesDon (
      methodeDonID INTEGER PRIMARY KEY,
      methode_fr TEXT NOT NULL,
      methode_en TEXT NOT NULL,
      methode_intuit TEXT,
      ordre INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS dons (
      donID INTEGER PRIMARY KEY AUTOINCREMENT,
      compteID INTEGER NOT NULL REFERENCES comptes(compteID),
      dateEntree TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      dateDon TEXT NOT NULL,
      description TEXT,
      donateurID INTEGER NOT NULL REFERENCES donateurs(donateurID),
      montant REAL NOT NULL,
      methodeDonID INTEGER REFERENCES methodesDon(methodeDonID),
      recuID INTEGER REFERENCES recus(recuID),
      verouille INTEGER NOT NULL DEFAULT 0
    );

    CREATE TABLE IF NOT EXISTS incoming_transactions (
      incomingTransactionID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      externalID TEXT NOT NULL,
      source TEXT NOT NULL,
      dateTransaction TEXT NOT NULL,
      amount REAL NOT NULL,
      donorNumber TEXT,
      methodeDonID INTEGER REFERENCES methodesDon(methodeDonID),
      methodLabel TEXT,
      note TEXT,
      status TEXT NOT NULL DEFAULT 'pending',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      UNIQUE (organismeID, externalID)
    );

    CREATE TABLE IF NOT EXISTS banking_connections (
      connectionID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      category TEXT NOT NULL DEFAULT 'bank',
      institution TEXT NOT NULL,
      accountNumber TEXT NOT NULL,
      transit TEXT,
      iban TEXT,
      scope TEXT NOT NULL DEFAULT 'all',
      accountIds TEXT NOT NULL DEFAULT '[]',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS report_templates (
      templateID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      title TEXT NOT NULL,
      description TEXT,
      reportType TEXT NOT NULL DEFAULT 'donations',
      groupBy TEXT NOT NULL DEFAULT 'date',
      automatic INTEGER NOT NULL DEFAULT 0,
      frequency TEXT NOT NULL DEFAULT 'weekly',
      day TEXT NOT NULL DEFAULT 'monday',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS recus (
      recuID INTEGER PRIMARY KEY AUTOINCREMENT,
      dateCreation TEXT NOT NULL,
      dateDebut TEXT NOT NULL,
      dateFin TEXT NOT NULL,
      donateurID INTEGER NOT NULL REFERENCES donateurs(donateurID),
      montant REAL NOT NULL,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID)
    );

    CREATE TABLE IF NOT EXISTS envois (
      envoiID INTEGER PRIMARY KEY AUTOINCREMENT,
      envoiIDOrigine INTEGER,
      dateDebut TEXT,
      dateFin TEXT,
      donateurID INTEGER NOT NULL REFERENCES donateurs(donateurID),
      envoiCode TEXT NOT NULL,
      montant REAL NOT NULL,
      noRecu INTEGER,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID),
      statut TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS abonnement_demandes (
      demandeID INTEGER PRIMARY KEY AUTOINCREMENT,
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      organisme TEXT NOT NULL,
      enregistrement TEXT NOT NULL,
      responsable TEXT NOT NULL,
      responsable_courriel TEXT NOT NULL,
      adresse TEXT,
      ville TEXT,
      province TEXT,
      code_postal TEXT,
      telephone TEXT,
      membre INTEGER NOT NULL DEFAULT 0,
      nomembre TEXT,
      langue TEXT NOT NULL DEFAULT 'en',
      statut TEXT NOT NULL DEFAULT 'new'
    );

    CREATE INDEX IF NOT EXISTS idx_dons_donateur ON dons(donateurID);
    CREATE INDEX IF NOT EXISTS idx_dons_date ON dons(dateDon);
    CREATE INDEX IF NOT EXISTS idx_incoming_transactions_org_status ON incoming_transactions(organismeID, status);
    CREATE INDEX IF NOT EXISTS idx_banking_connections_org ON banking_connections(organismeID);
    CREATE INDEX IF NOT EXISTS idx_report_templates_org ON report_templates(organismeID);
    CREATE INDEX IF NOT EXISTS idx_recus_org_period ON recus(organismeID, dateDebut, dateFin);
    CREATE INDEX IF NOT EXISTS idx_envois_org_code ON envois(organismeID, envoiCode);
    CREATE UNIQUE INDEX IF NOT EXISTS idx_utilisateurs_courriel_unique ON utilisateurs(courriel);
  `);
}

function seedDatabase() {
  const provinceCount = db.prepare("SELECT COUNT(*) AS count FROM provinces").get().count;
  if (!provinceCount) {
    const insertProvince = db.prepare(`
      INSERT INTO provinces (provinceID, pays_fr, pays_en, provinceEtat_fr, provinceEtat_en, abreviation, ordre)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `);

    [
      [1, "Canada", "Canada", "Quebec", "Quebec", "QC", 1],
      [2, "Canada", "Canada", "Ontario", "Ontario", "ON", 1],
      [3, "Canada", "Canada", "Nouveau-Brunswick", "New Brunswick", "NB", 1],
      [4, "Canada", "Canada", "Nouvelle-Ecosse", "Nova Scotia", "NS", 1],
      [5, "Canada", "Canada", "Manitoba", "Manitoba", "MB", 1],
      [6, "Canada", "Canada", "Alberta", "Alberta", "AB", 1],
      [7, "Etats-Unis", "United States", "New York", "New York", "NY", 2],
    ].forEach((row) => insertProvince.run(...row));
  }

  const methodCount = db.prepare("SELECT COUNT(*) AS count FROM methodesDon").get().count;
  if (!methodCount) {
    const insertMethod = db.prepare(`
      INSERT INTO methodesDon (methodeDonID, methode_fr, methode_en, methode_intuit, ordre)
      VALUES (?, ?, ?, ?, ?)
    `);

    [
      [1, "Cheque", "Cheque", "Check", 1],
      [2, "Comptant", "Cash", "Cash", 2],
      [3, "Virement", "Transfer", "Transfer", 3],
      [4, "Carte", "Card", "Card", 4],
      [5, "Prelevement", "Pre-authorized debit", "PAD", 5],
    ].forEach((row) => insertMethod.run(...row));
  }

  const orgCount = db.prepare("SELECT COUNT(*) AS count FROM organismes").get().count;
  if (!orgCount) {
    db.prepare(`
      INSERT INTO organismes (
        organismeID, actif, adresse, code_postal, date_fin_licence, devise, enregistrement,
        folio, membre, organisme, provinceID, reponse_courriel, responsable,
        responsable_courriel, telephone, transit, ville
      )
      VALUES (1, 1, ?, ?, ?, 'CAD', ?, ?, 1, ?, 1, ?, ?, ?, ?, ?, ?)
    `).run(
      "5425 Boulevard Laurier O, Suite 106",
      "J2S 3V6",
      "2027-12-31",
      "123456789RR0001",
      "FOL-2026",
      "Grace Community Church",
      "receipts@grace.example.org",
      "Francois Brouillet",
      "admin@ddr.local",
      "(450) 778-7177",
      "12345",
      "Saint-Hyacinthe",
    );
  }

  const userCount = db.prepare("SELECT COUNT(*) AS count FROM utilisateurs").get().count;
  if (!userCount) {
    db.prepare(`
      INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, utilisateurStatutID)
      VALUES (1, 1, 'admin@ddr.local', 'en', ?, 'Brouillet', 1, 'Francois', 1)
    `).run(hashPassword("password"));
  }

  const accountCount = db.prepare("SELECT COUNT(*) AS count FROM comptes").get().count;
  if (!accountCount) {
    const insertAccount = db.prepare("INSERT INTO comptes (organismeID, noCompte, nom, recu) VALUES (1, ?, ?, ?)");
    [
      [100, "General offerings", 1],
      [200, "Community aid", 1],
      [300, "Missions", 1],
      [400, "Building fund", 1],
      [900, "Administration fees", 0],
    ].forEach((row) => insertAccount.run(...row));
  }

  const connectionCount = db.prepare("SELECT COUNT(*) AS count FROM banking_connections").get().count;
  if (!connectionCount) {
    const accountRows = db.prepare("SELECT compteID FROM comptes WHERE organismeID = 1 ORDER BY noCompte LIMIT 2").all();
    const insertConnection = db.prepare(`
      INSERT INTO banking_connections (
        organismeID, category, institution, accountNumber, transit, iban, scope, accountIds
      ) VALUES (1, ?, ?, ?, ?, ?, ?, ?)
    `);

    [
      ["bank", "Banque Nationale", "**** 4921", "006", "CA-006-4921", "all", "[]"],
      ["processor", "PayPal Giving", "fi***@weserve.local", "PayPal", "**** 1842", "selected", JSON.stringify(accountRows.map((account) => account.compteID))],
    ].forEach((row) => insertConnection.run(...row));
  }

  const donorCount = db.prepare("SELECT COUNT(*) AS count FROM donateurs").get().count;
  if (!donorCount) {
    const insertDonor = db.prepare(`
      INSERT INTO donateurs (
        actif, adresse, code_postal, courriel, membre, nom, notes, numero,
        organismeID, prenom, provinceID, recu, tel_cellulaire, tel_residence, ville
      )
      VALUES (1, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, 1, ?, ?, ?)
    `);

    [
      ["120 Rue Principale", "J2S 1A1", "amelie.gagnon@example.org", 1, "Gagnon", "Monthly donor", "1", "Amelie", 1, "514-555-0101", "450-555-0101", "Saint-Hyacinthe"],
      ["84 Rue Saint-Paul", "J4K 2B2", "marc.tremblay@example.org", 0, "Tremblay", "", "2", "Marc", 1, "514-555-0102", "450-555-0102", "Longueuil"],
      ["900 Avenue du Parc", "H2V 4E5", "sophie.chen@example.org", 0, "Chen", "New family", "3", "Sophie", 1, "514-555-0103", "514-555-0104", "Montreal"],
      ["25 Rue Saint-Jean", "G1R 1R1", "noah.williams@example.org", 1, "Williams", "Major gifts", "4", "Noah", 1, "418-555-0104", "418-555-0105", "Quebec"],
    ].forEach((row) => insertDonor.run(...row));
  }

  const donationCount = db.prepare("SELECT COUNT(*) AS count FROM dons").get().count;
  if (!donationCount) {
    const donorByNumber = db.prepare("SELECT donateurID FROM donateurs WHERE organismeID = 1 AND numero = ?");
    const accountByNumber = db.prepare("SELECT compteID FROM comptes WHERE organismeID = 1 AND noCompte = ?");
    const insertDonation = db.prepare(`
      INSERT INTO dons (compteID, dateDon, description, donateurID, montant, methodeDonID, verouille)
      VALUES (?, ?, ?, ?, ?, ?, 0)
    `);

    [
      ["1", 100, "2026-01-14", "Opening gift", 250, 1],
      ["2", 200, "2026-02-07", "Community program", 120, 3],
      ["3", 300, "2026-03-17", "Mission support", 85, 4],
      ["4", 400, "2026-04-09", "Building campaign", 500, 2],
      ["1", 100, "2026-05-22", "Monthly offering", 250, 5],
      ["2", 900, "2026-06-24", "Administration reimbursement", 60, 3],
      ["1", 100, "2026-06-28", "Monthly offering", 250, 5],
      ["4", 400, "2026-07-02", "Capital gift", 775, 1],
    ].forEach(([donorNumber, accountNumber, dateDon, description, amount, methodID]) => {
      insertDonation.run(
        accountByNumber.get(accountNumber).compteID,
        dateDon,
        description,
        donorByNumber.get(donorNumber).donateurID,
        amount,
        methodID,
      );
    });
  }

  const incomingCount = db.prepare("SELECT COUNT(*) AS count FROM incoming_transactions").get().count;
  if (!incomingCount) {
    const insertIncoming = db.prepare(`
      INSERT INTO incoming_transactions (
        organismeID, externalID, source, dateTransaction, amount, donorNumber, methodeDonID, methodLabel, note, status
      )
      VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')
    `);

    [
      ["bank-001", "Stripe payout", "2026-07-16", 250, "1", 4, "Card", "Grace Family - online gift"],
      ["paypal-014", "PayPal", "2026-07-15", 75, "2", 4, "Card", "Monthly support"],
      ["desjardins-221", "Desjardins", "2026-07-14", 420, "3", 2, "Bank transfer", "Summer campaign transfer"],
      ["national-118", "Banque Nationale", "2026-07-13", 95, "4", 2, "Bank transfer", "Youth fund deposit"],
      ["paypal-029", "PayPal", "2026-07-12", 180, "5", 4, "Card", "Community meal support"],
      ["stripe-337", "Stripe payout", "2026-07-11", 60, "1", 4, "Card", "Weekly recurring gift"],
    ].forEach((row) => insertIncoming.run(...row));
  }

  db.exec(`
    DELETE FROM incoming_transactions
    WHERE status = 'pending'
      AND EXISTS (
        SELECT 1
        FROM dons AS d
        INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
        WHERE dt.organismeID = incoming_transactions.organismeID
          AND dt.numero = incoming_transactions.donorNumber
          AND d.dateDon = incoming_transactions.dateTransaction
          AND d.montant = incoming_transactions.amount
          AND COALESCE(d.description, '') = COALESCE(incoming_transactions.note, '')
      )
  `);
}

setupSchema();
seedDatabase();

function all(sql, params = []) {
  return db.prepare(sql).all(...params);
}

function get(sql, params = []) {
  return db.prepare(sql).get(...params);
}

function run(sql, params = []) {
  const result = db.prepare(sql).run(...params);
  return {
    changes: result.changes,
    lastInsertRowid: Number(result.lastInsertRowid),
  };
}

function transaction(callback) {
  db.exec("BEGIN");
  try {
    const result = callback();
    db.exec("COMMIT");
    return result;
  } catch (error) {
    db.exec("ROLLBACK");
    throw error;
  }
}

function bool(value) {
  return value ? 1 : 0;
}

function todayISO() {
  return new Date().toISOString().slice(0, 10);
}

function currentTimestampCode() {
  return new Date().toISOString().replace("T", "-").replaceAll(":", "-").slice(0, 19);
}

function futureDateISO(days) {
  const date = new Date();
  date.setDate(date.getDate() + days);
  return date.toISOString().slice(0, 10);
}

function sessionExpiryISO() {
  const date = new Date();
  date.setDate(date.getDate() + 30);
  return date.toISOString();
}

function tokenHash(token) {
  return createHash("sha256").update(String(token || "")).digest("hex");
}

function organizationID(context = {}) {
  return Number(context?.organismeID || context?.organizationID || 1);
}

function sanitizeUser(user) {
  if (!user) {
    return null;
  }

  return {
    utilisateurID: user.utilisateurID,
    actif: Boolean(user.actif ?? true),
    admin: Boolean(user.admin),
    courriel: user.courriel,
    langue: user.langue,
    nom: user.nom,
    prenom: user.prenom,
    organismeID: user.organismeID,
    organisme: user.organisme,
    devise: user.devise,
  };
}

function normalizeDonor(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    actif: Boolean(row.actif),
    membre: Boolean(row.membre),
    recu: Boolean(row.recu),
    fullName: `${row.prenom || ""} ${row.nom || ""}`.trim(),
  };
}

function normalizeAccount(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    recu: Boolean(row.recu),
  };
}

function normalizeOrganization(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    actif: Boolean(row.actif),
    membre: Boolean(row.membre),
  };
}

function normalizeDonation(row) {
  if (!row) {
    return row;
  }

  const receiptable = Boolean(row.compteRecu) && Boolean(row.donateurRecu);
  return {
    ...row,
    verouille: Boolean(row.verouille),
    compteRecu: Boolean(row.compteRecu),
    donateurRecu: Boolean(row.donateurRecu),
    donorName: `${row.prenom || ""} ${row.nom || ""}`.trim(),
    receiptStatus: row.recuID ? "Issued" : receiptable ? "Ready" : "No receipt",
  };
}

function normalizeIncomingTransaction(row) {
  if (!row) {
    return row;
  }

  return {
    id: row.externalID,
    incomingTransactionID: row.incomingTransactionID,
    source: row.source,
    date: row.dateTransaction,
    amount: row.amount,
    donorNumber: row.donorNumber,
    methodID: row.methodeDonID,
    methodLabel: row.methodLabel,
    note: row.note,
    status: row.status,
  };
}

function requestPasswordReset(courriel) {
  get(
    `SELECT utilisateurID
     FROM utilisateurs
     WHERE lower(courriel) = lower(?) AND actif = 1`,
    [courriel || ""],
  );

  return {
    ok: true,
    message: "If this email is active, reset instructions will be sent by the WeSERVE administrator.",
  };
}

function createSession(utilisateurID) {
  const token = randomBytes(32).toString("hex");
  const expiresAt = sessionExpiryISO();
  run(
    "INSERT INTO sessions (token_hash, utilisateurID, expiresAt) VALUES (?, ?, ?)",
    [tokenHash(token), Number(utilisateurID), expiresAt],
  );
  return { token, expiresAt };
}

function authenticate(token) {
  if (!token) {
    return null;
  }

  const user = get(
    `SELECT u.*, o.organisme, o.devise, o.date_fin_licence, o.actif AS organismeActif
     FROM sessions AS s
     INNER JOIN utilisateurs AS u ON s.utilisateurID = u.utilisateurID
     INNER JOIN organismes AS o ON u.organismeID = o.organismeID
     WHERE s.token_hash = ? AND s.expiresAt > ? AND u.actif = 1`,
    [tokenHash(token), new Date().toISOString()],
  );

  if (!user || !user.organismeActif || user.date_fin_licence < todayISO()) {
    return null;
  }

  return sanitizeUser(user);
}

function deleteSession(token) {
  if (!token) {
    return { deleted: false };
  }

  run("DELETE FROM sessions WHERE token_hash = ?", [tokenHash(token)]);
  return { deleted: true };
}

function login(courriel, password) {
  const user = get(
    `SELECT u.*, o.organisme, o.devise, o.date_fin_licence, o.actif AS organismeActif
     FROM utilisateurs AS u
     INNER JOIN organismes AS o ON u.organismeID = o.organismeID
     WHERE lower(u.courriel) = lower(?) AND u.actif = 1`,
    [courriel],
  );

  if (!user || !verifyPassword(password, user.mot_de_passe)) {
    return null;
  }

  if (!user.organismeActif || user.date_fin_licence < todayISO()) {
    const error = new Error("License expired or organization inactive");
    error.status = 403;
    throw error;
  }

  return sanitizeUser(user);
}

function addDefaultAccounts(orgID) {
  const insertAccount = db.prepare("INSERT INTO comptes (organismeID, noCompte, nom, recu) VALUES (?, ?, ?, ?)");
  [
    [100, "General offerings", 1],
    [200, "Community aid", 1],
    [300, "Missions", 1],
    [400, "Building fund", 1],
    [900, "Administration fees", 0],
  ].forEach((row) => insertAccount.run(orgID, ...row));
}

function registerOrganization(data) {
  const email = String(data.email || data.courriel || data.responsable_courriel || "").trim().toLowerCase();
  const password = String(data.password || data.mdp || "");
  if (!email || password.length < 8) {
    const error = new Error("A valid email and an 8 character password are required");
    error.status = 400;
    throw error;
  }

  const duplicate = get("SELECT utilisateurID FROM utilisateurs WHERE lower(courriel) = lower(?)", [email]);
  if (duplicate) {
    const error = new Error("An account already exists for this email");
    error.status = 409;
    throw error;
  }

  return transaction(() => {
    const orgResult = run(
      `INSERT INTO organismes (
        actif, adresse, code_postal, date_fin_licence, devise, enregistrement,
        folio, membre, organisme, provinceID, reponse_courriel, responsable,
        responsable_courriel, telephone, transit, ville
      ) VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        data.adresse || "",
        data.code_postal || "",
        futureDateISO(365),
        data.devise || "CAD",
        data.enregistrement || "",
        data.folio || "",
        bool(data.membre),
        String(data.organisme || "").trim(),
        Number(data.provinceID) || 1,
        data.reponse_courriel || email,
        String(data.responsable || `${data.prenom || ""} ${data.nom || ""}`.trim() || "Administrator").trim(),
        email,
        data.telephone || "",
        data.transit || "",
        data.ville || "",
      ],
    );

    const orgID = orgResult.lastInsertRowid;
    addDefaultAccounts(orgID);
    const userResult = run(
      `INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, utilisateurStatutID)
       VALUES (1, 1, ?, ?, ?, ?, ?, ?, 1)`,
      [
        email,
        data.langue || "en",
        hashPassword(password),
        String(data.nom || "Admin").trim(),
        orgID,
        String(data.prenom || "SaaS").trim(),
      ],
    );

    return sanitizeUser(get(
      `SELECT u.*, o.organisme, o.devise
       FROM utilisateurs AS u
       INNER JOIN organismes AS o ON u.organismeID = o.organismeID
       WHERE u.utilisateurID = ?`,
      [userResult.lastInsertRowid],
    ));
  });
}

function getOrganization(context = {}) {
  return normalizeOrganization(get(
    `SELECT o.*, p.abreviation AS province
     FROM organismes AS o
     LEFT JOIN provinces AS p ON o.provinceID = p.provinceID
     WHERE o.organismeID = ?`,
    [organizationID(context)],
  ));
}

function listUsers(context = {}) {
  return all(
    `SELECT utilisateurID, actif, admin, courriel, langue, nom, organismeID, prenom, utilisateurStatutID
     FROM utilisateurs
     WHERE organismeID = ?
     ORDER BY admin DESC, nom, prenom`,
    [organizationID(context)],
  ).map((user) => ({
    ...user,
    actif: Boolean(user.actif),
    admin: Boolean(user.admin),
  }));
}

function createUser(data, context = {}) {
  const email = String(data.courriel || data.email || "").trim().toLowerCase();
  const password = String(data.password || data.mdp || "");
  if (!email || password.length < 8) {
    const error = new Error("A valid email and an 8 character password are required");
    error.status = 400;
    throw error;
  }

  const duplicate = get("SELECT utilisateurID FROM utilisateurs WHERE lower(courriel) = lower(?)", [email]);
  if (duplicate) {
    const error = new Error("A user already exists for this email");
    error.status = 409;
    throw error;
  }

  const result = run(
    `INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, utilisateurStatutID)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)`,
    [
      data.actif === false ? 0 : 1,
      bool(data.admin),
      email,
      data.langue || "en",
      hashPassword(password),
      String(data.nom || "").trim(),
      organizationID(context),
      String(data.prenom || "").trim(),
    ],
  );

  return listUsers(context).find((user) => user.utilisateurID === result.lastInsertRowid);
}

function updateUser(id, data, context = {}) {
  const email = String(data.courriel || data.email || "").trim().toLowerCase();
  const userId = Number(id);

  if (!email) {
    const error = new Error("A valid email is required");
    error.status = 400;
    throw error;
  }

  const duplicate = get(
    "SELECT utilisateurID FROM utilisateurs WHERE lower(courriel) = lower(?) AND utilisateurID <> ?",
    [email, userId],
  );
  if (duplicate) {
    const error = new Error("A user already exists for this email");
    error.status = 409;
    throw error;
  }

  run(
    `UPDATE utilisateurs
     SET admin = ?, courriel = ?, langue = ?, nom = ?, prenom = ?
     WHERE utilisateurID = ? AND organismeID = ?`,
    [
      bool(data.admin),
      email,
      data.langue || "en",
      String(data.nom || "").trim(),
      String(data.prenom || "").trim(),
      userId,
      organizationID(context),
    ],
  );

  const updatedUser = listUsers(context).find((user) => user.utilisateurID === userId);
  if (!updatedUser) {
    const error = new Error("User not found");
    error.status = 404;
    throw error;
  }
  return updatedUser;
}

function updateUserStatus(id, data, context = {}) {
  run(
    "UPDATE utilisateurs SET actif = ?, admin = ? WHERE utilisateurID = ? AND organismeID = ?",
    [data.actif === false ? 0 : 1, bool(data.admin), Number(id), organizationID(context)],
  );
  return listUsers(context).find((user) => user.utilisateurID === Number(id));
}

function updateOrganization(data, context = {}) {
  run(
    `UPDATE organismes
     SET actif = ?, adresse = ?, code_postal = ?, devise = ?, enregistrement = ?,
         folio = ?, membre = ?, organisme = ?, provinceID = ?, reponse_courriel = ?,
         responsable = ?, responsable_courriel = ?, telephone = ?, transit = ?, ville = ?
     WHERE organismeID = ?`,
    [
      data.actif === false ? 0 : 1,
      data.adresse || "",
      data.code_postal || "",
      data.devise || "CAD",
      data.enregistrement || "",
      data.folio || "",
      bool(data.membre),
      String(data.organisme || "").trim(),
      Number(data.provinceID) || 1,
      data.reponse_courriel || "",
      String(data.responsable || "").trim(),
      data.responsable_courriel || "",
      data.telephone || "",
      data.transit || "",
      data.ville || "",
      organizationID(context),
    ],
  );

  return getOrganization(context);
}

function normalizeConnection(row) {
  return {
    id: `connection-${row.connectionID}`,
    connectionID: row.connectionID,
    category: row.category,
    institution: row.institution,
    accountNumber: row.accountNumber,
    transit: row.transit || "",
    iban: row.iban || "",
    scope: row.scope || "all",
    accountIds: JSON.parse(row.accountIds || "[]"),
  };
}

function listBankingConnections(context = {}) {
  return all(
    `SELECT connectionID, category, institution, accountNumber, transit, iban, scope, accountIds
     FROM banking_connections
     WHERE organismeID = ?
     ORDER BY connectionID`,
    [organizationID(context)],
  ).map(normalizeConnection);
}

function createBankingConnection(data, context = {}) {
  const accountIds = Array.isArray(data.accountIds) ? data.accountIds.map(Number).filter(Boolean) : [];
  const result = run(
    `INSERT INTO banking_connections (
      organismeID, category, institution, accountNumber, transit, iban, scope, accountIds
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      organizationID(context),
      data.category || "bank",
      String(data.institution || "").trim(),
      String(data.accountNumber || "").trim(),
      data.transit || "",
      data.iban || "",
      data.scope === "selected" ? "selected" : "all",
      JSON.stringify(data.scope === "selected" ? accountIds : []),
    ],
  );

  return listBankingConnections(context).find((connection) => connection.connectionID === result.lastInsertRowid);
}

function deleteBankingConnection(id, context = {}) {
  run(
    "DELETE FROM banking_connections WHERE connectionID = ? AND organismeID = ?",
    [Number(id), organizationID(context)],
  );
  return { ok: true };
}

function normalizeReportTemplate(row) {
  return {
    id: `custom-${row.templateID}`,
    templateID: row.templateID,
    title: row.title,
    description: row.description || "",
    type: row.reportType,
    groupBy: row.groupBy,
    custom: true,
    automatic: Boolean(row.automatic),
    frequency: row.frequency || "weekly",
    day: row.day || "monday",
  };
}

function listReportTemplates(context = {}) {
  return all(
    `SELECT templateID, title, description, reportType, groupBy, automatic, frequency, day
     FROM report_templates
     WHERE organismeID = ?
     ORDER BY templateID DESC`,
    [organizationID(context)],
  ).map(normalizeReportTemplate);
}

function createReportTemplate(data, context = {}) {
  const title = String(data.title || "").trim();
  if (!title) {
    const error = new Error("Template name is required");
    error.status = 400;
    throw error;
  }

  const result = run(
    `INSERT INTO report_templates (
      organismeID, title, description, reportType, groupBy, automatic, frequency, day
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      organizationID(context),
      title,
      String(data.description || "").trim(),
      data.type || data.reportType || "donations",
      data.groupBy || "date",
      bool(data.automatic),
      data.frequency || "weekly",
      data.day || "monday",
    ],
  );

  return listReportTemplates(context).find((template) => template.templateID === result.lastInsertRowid);
}

function deleteReportTemplate(id, context = {}) {
  run(
    "DELETE FROM report_templates WHERE templateID = ? AND organismeID = ?",
    [Number(id), organizationID(context)],
  );
  return { ok: true };
}

function getBootstrap(context = {}) {
  const organisme = getOrganization(context);
  const user = get("SELECT utilisateurID, admin, courriel, langue, nom, prenom, organismeID FROM utilisateurs WHERE organismeID = ? ORDER BY admin DESC LIMIT 1", [organizationID(context)]);
  const provinces = all("SELECT provinceID, pays_en, pays_fr, provinceEtat_en, provinceEtat_fr, abreviation FROM provinces ORDER BY ordre, provinceEtat_en");
  const methods = all("SELECT methodeDonID, methode_fr, methode_en, methode_intuit, ordre FROM methodesDon ORDER BY ordre");

  return {
    organisme,
    user: { ...user, admin: Boolean(user.admin) },
    users: listUsers(context),
    provinces,
    methods,
    bankingConnections: listBankingConnections(context),
    reportTemplates: listReportTemplates(context),
  };
}

function getDashboard(context = {}) {
  const orgID = organizationID(context);
  const year = new Date().getFullYear().toString();
  const totals = get(
    `SELECT
      COALESCE(SUM(CASE WHEN substr(d.dateDon, 1, 4) = ? THEN d.montant END), 0) AS ytdDonations,
      COUNT(DISTINCT CASE WHEN dt.actif = 1 THEN dt.donateurID END) AS activeDonors,
      COUNT(DISTINCT r.recuID) AS receiptCount,
      COALESCE(SUM(CASE WHEN c.recu = 1 THEN d.montant END), 0) AS receiptableTotal
     FROM donateurs AS dt
     LEFT JOIN dons AS d ON d.donateurID = dt.donateurID
     LEFT JOIN comptes AS c ON d.compteID = c.compteID
     LEFT JOIN recus AS r ON r.donateurID = dt.donateurID
     WHERE dt.organismeID = ?`,
    [year, orgID],
  );
  const pending = get(
    `SELECT COUNT(*) AS count
     FROM dons AS d
     INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
     INNER JOIN comptes AS c ON d.compteID = c.compteID
     WHERE dt.organismeID = ? AND c.recu = 1 AND dt.recu = 1 AND d.recuID IS NULL`,
    [orgID],
  ).count;
  const monthly = all(
    `SELECT substr(d.dateDon, 1, 7) AS month, COALESCE(SUM(d.montant), 0) AS amount
     FROM dons AS d
     INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
     WHERE dt.organismeID = ? AND substr(d.dateDon, 1, 4) = ?
     GROUP BY substr(d.dateDon, 1, 7)
     ORDER BY month`,
    [orgID, year],
  );
  const recentDonations = listDonations({ limit: 6 }, context);
  const accountMix = all(
    `SELECT c.compteID, c.noCompte, c.nom, c.recu, COALESCE(SUM(d.montant), 0) AS total
     FROM comptes AS c
     LEFT JOIN dons AS d ON c.compteID = d.compteID
     WHERE c.organismeID = ?
     GROUP BY c.compteID
     ORDER BY total DESC`,
    [orgID],
  ).map(normalizeAccount);

  return {
    totals: {
      ytdDonations: totals.ytdDonations || 0,
      receiptCount: totals.receiptCount || 0,
      activeDonors: totals.activeDonors || 0,
      pendingReceipts: pending || 0,
      receiptableTotal: totals.receiptableTotal || 0,
    },
    monthly,
    recentDonations,
    accountMix,
  };
}

function listDonors({ search = "", active = "active", limit = 100 } = {}, context = {}) {
  const params = [organizationID(context)];
  let where = "d.organismeID = ?";

  if (active === "active") {
    where += " AND d.actif = 1";
  } else if (active === "archived") {
    where += " AND d.actif = 0";
  }

  if (search) {
    where += " AND (d.numero LIKE ? OR d.nom LIKE ? OR d.prenom LIKE ? OR d.courriel LIKE ? OR d.ville LIKE ?)";
    const term = `%${search}%`;
    params.push(term, term, term, term, term);
  }

  params.push(Number(limit));

  return all(
    `SELECT d.*, p.abreviation AS province,
      COALESCE(SUM(ds.montant), 0) AS totalDonations,
      MAX(ds.dateDon) AS lastGift
     FROM donateurs AS d
     LEFT JOIN provinces AS p ON d.provinceID = p.provinceID
     LEFT JOIN dons AS ds ON ds.donateurID = d.donateurID
     WHERE ${where}
     GROUP BY d.donateurID
     ORDER BY CAST(d.numero AS INTEGER), d.nom, d.prenom
     LIMIT ?`,
    params,
  ).map(normalizeDonor);
}

function nextDonorNumber(context = {}) {
  const row = get(
    "SELECT MAX(CAST(numero AS INTEGER)) AS dernier FROM donateurs WHERE organismeID = ?",
    [organizationID(context)],
  );
  return String((Number(row?.dernier) || 0) + 1);
}

function createDonor(data, context = {}) {
  const orgID = organizationID(context);
  const numero = String(data.numero || nextDonorNumber(context)).trim();
  const duplicate = get("SELECT donateurID FROM donateurs WHERE organismeID = ? AND numero = ?", [orgID, numero]);
  if (duplicate) {
    const error = new Error("Donor number already exists");
    error.status = 409;
    throw error;
  }

  const result = run(
    `INSERT INTO donateurs (
      actif, adresse, code_postal, courriel, membre, nom, notes, numero,
      organismeID, prenom, provinceID, recu, tel_cellulaire, tel_residence, ville
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      data.actif === false ? 0 : 1,
      data.adresse || "",
      data.code_postal || "",
      data.courriel || "",
      bool(data.membre),
      String(data.nom || "").trim(),
      data.notes || "",
      numero,
      orgID,
      String(data.prenom || "").trim(),
      Number(data.provinceID) || 1,
      data.recu === false ? 0 : 1,
      data.tel_cellulaire || "",
      data.tel_residence || "",
      data.ville || "",
    ],
  );

  return getDonor(result.lastInsertRowid, context);
}

function updateDonor(id, data, context = {}) {
  run(
    `UPDATE donateurs
     SET actif = ?, adresse = ?, code_postal = ?, courriel = ?, membre = ?, nom = ?, notes = ?,
         numero = ?, prenom = ?, provinceID = ?, recu = ?, tel_cellulaire = ?, tel_residence = ?, ville = ?
     WHERE donateurID = ? AND organismeID = ?`,
    [
      data.actif === false ? 0 : 1,
      data.adresse || "",
      data.code_postal || "",
      data.courriel || "",
      bool(data.membre),
      String(data.nom || "").trim(),
      data.notes || "",
      String(data.numero || "").trim(),
      String(data.prenom || "").trim(),
      Number(data.provinceID) || 1,
      data.recu === false ? 0 : 1,
      data.tel_cellulaire || "",
      data.tel_residence || "",
      data.ville || "",
      Number(id),
      organizationID(context),
    ],
  );

  return getDonor(id, context);
}

function archiveDonor(id, actif, context = {}) {
  run("UPDATE donateurs SET actif = ? WHERE donateurID = ? AND organismeID = ?", [bool(actif), Number(id), organizationID(context)]);
  return getDonor(id, context);
}

function deleteDonor(id, context = {}) {
  const donorID = Number(id);
  const orgID = organizationID(context);
  const donor = getDonor(donorID, context);
  if (!donor) {
    throw new Error("Donor not found.");
  }

  const activityCount =
    Number(get("SELECT COUNT(*) AS count FROM dons WHERE donateurID = ?", [donorID])?.count || 0) +
    Number(get("SELECT COUNT(*) AS count FROM recus WHERE donateurID = ? AND organismeID = ?", [donorID, orgID])?.count || 0) +
    Number(get("SELECT COUNT(*) AS count FROM envois WHERE donateurID = ? AND organismeID = ?", [donorID, orgID])?.count || 0);

  if (activityCount > 0) {
    throw new Error("This donor has activity and cannot be deleted. Set the donor inactive instead.");
  }

  run("DELETE FROM donateurs WHERE donateurID = ? AND organismeID = ?", [donorID, orgID]);
  return donor;
}

function getDonor(id, context = {}) {
  return normalizeDonor(get(
    `SELECT d.*, p.abreviation AS province,
      COALESCE(SUM(ds.montant), 0) AS totalDonations,
      MAX(ds.dateDon) AS lastGift
     FROM donateurs AS d
     LEFT JOIN provinces AS p ON d.provinceID = p.provinceID
     LEFT JOIN dons AS ds ON ds.donateurID = d.donateurID
     WHERE d.donateurID = ? AND d.organismeID = ?
     GROUP BY d.donateurID`,
    [Number(id), organizationID(context)],
  ));
}

function listAccounts(context = {}) {
  return all(
    `SELECT c.*, COUNT(d.donID) AS donationCount, COALESCE(SUM(d.montant), 0) AS total
     FROM comptes AS c
     LEFT JOIN dons AS d ON c.compteID = d.compteID
     WHERE c.organismeID = ?
     GROUP BY c.compteID
     ORDER BY c.noCompte`,
    [organizationID(context)],
  ).map(normalizeAccount);
}

function createAccount(data, context = {}) {
  const orgID = organizationID(context);
  const noCompte = Number(data.noCompte);
  const nom = String(data.nom || "").trim();

  if (!Number.isFinite(noCompte) || !nom) {
    const error = new Error("Account number and name are required");
    error.status = 400;
    throw error;
  }

  const duplicate = get("SELECT compteID FROM comptes WHERE organismeID = ? AND noCompte = ?", [orgID, noCompte]);
  if (duplicate) {
    const error = new Error("An account with this number already exists");
    error.status = 409;
    throw error;
  }

  const result = run(
    "INSERT INTO comptes (organismeID, noCompte, nom, recu) VALUES (?, ?, ?, ?)",
    [orgID, noCompte, nom, data.recu === false ? 0 : 1],
  );
  return listAccounts(context).find((account) => account.compteID === result.lastInsertRowid);
}

function updateAccount(id, data, context = {}) {
  const orgID = organizationID(context);
  const noCompte = Number(data.noCompte);
  const nom = String(data.nom || "").trim();

  if (!Number.isFinite(noCompte) || !nom) {
    const error = new Error("Account number and name are required");
    error.status = 400;
    throw error;
  }

  const duplicate = get(
    "SELECT compteID FROM comptes WHERE organismeID = ? AND noCompte = ? AND compteID != ?",
    [orgID, noCompte, Number(id)],
  );
  if (duplicate) {
    const error = new Error("An account with this number already exists");
    error.status = 409;
    throw error;
  }

  run(
    "UPDATE comptes SET noCompte = ?, nom = ?, recu = ? WHERE compteID = ? AND organismeID = ?",
    [noCompte, nom, data.recu === false ? 0 : 1, Number(id), orgID],
  );
  return listAccounts(context).find((account) => account.compteID === Number(id));
}

function deleteAccount(id, context = {}) {
  const count = get(
    `SELECT COUNT(*) AS count
     FROM dons AS d
     INNER JOIN comptes AS c ON d.compteID = c.compteID
     WHERE d.compteID = ? AND c.organismeID = ?`,
    [Number(id), organizationID(context)],
  ).count;
  if (count) {
    const error = new Error("This account is linked to at least one donation");
    error.status = 409;
    throw error;
  }
  run("DELETE FROM comptes WHERE compteID = ? AND organismeID = ?", [Number(id), organizationID(context)]);
  return { deleted: true };
}

function listDonations({ search = "", dateDebut = "", dateFin = "", limit = 100 } = {}, context = {}) {
  const params = [organizationID(context)];
  let where = "dt.organismeID = ?";

  if (dateDebut) {
    where += " AND d.dateDon >= ?";
    params.push(dateDebut);
  }
  if (dateFin) {
    where += " AND d.dateDon <= ?";
    params.push(dateFin);
  }
  if (search) {
    where += " AND (dt.numero LIKE ? OR dt.nom LIKE ? OR dt.prenom LIKE ? OR c.nom LIKE ? OR d.description LIKE ?)";
    const term = `%${search}%`;
    params.push(term, term, term, term, term);
  }

  params.push(Number(limit));

  return all(
    `SELECT d.*, dt.numero, dt.nom, dt.prenom, dt.courriel, dt.recu AS donateurRecu,
      c.noCompte, c.nom AS libelleCompte, c.recu AS compteRecu,
      m.methode_fr, m.methode_en
     FROM dons AS d
     INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
     INNER JOIN comptes AS c ON d.compteID = c.compteID
     LEFT JOIN methodesDon AS m ON d.methodeDonID = m.methodeDonID
     WHERE ${where}
     ORDER BY d.dateDon DESC, d.donID DESC
     LIMIT ?`,
    params,
  ).map(normalizeDonation);
}

function createDonation(data, context = {}) {
  const orgID = organizationID(context);
  const donateurID = Number(data.donateurID || get("SELECT donateurID FROM donateurs WHERE organismeID = ? AND numero = ?", [orgID, data.numero])?.donateurID);
  const compteID = Number(data.compteID || get("SELECT compteID FROM comptes WHERE organismeID = ? AND noCompte = ?", [orgID, Number(data.noCompte)])?.compteID);
  const donorOwned = donateurID ? get("SELECT donateurID FROM donateurs WHERE donateurID = ? AND organismeID = ?", [donateurID, orgID]) : null;
  const accountOwned = compteID ? get("SELECT compteID FROM comptes WHERE compteID = ? AND organismeID = ?", [compteID, orgID]) : null;

  if (!donateurID || !compteID || !donorOwned || !accountOwned) {
    const error = new Error("The account number or donor number cannot be recognized");
    error.status = 400;
    throw error;
  }

  const result = run(
    `INSERT INTO dons (compteID, dateDon, description, donateurID, montant, methodeDonID)
     VALUES (?, ?, ?, ?, ?, ?)`,
    [
      compteID,
      data.dateDon || todayISO(),
      data.description || "",
      donateurID,
      Number(data.montant),
      Number(data.methodeDonID) || null,
    ],
  );

  return listDonations({ limit: 500 }, context).find((donation) => donation.donID === result.lastInsertRowid);
}

function updateDonation(id, data, context = {}) {
  const orgID = organizationID(context);
  const ownsDonation = get(
    `SELECT d.donID
     FROM dons AS d
     INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
     WHERE d.donID = ? AND dt.organismeID = ?`,
    [Number(id), orgID],
  );
  if (!ownsDonation) {
    const error = new Error("Donation not found");
    error.status = 404;
    throw error;
  }
  const donorOwned = get("SELECT donateurID FROM donateurs WHERE donateurID = ? AND organismeID = ?", [Number(data.donateurID), orgID]);
  const accountOwned = get("SELECT compteID FROM comptes WHERE compteID = ? AND organismeID = ?", [Number(data.compteID), orgID]);
  if (!donorOwned || !accountOwned) {
    const error = new Error("The account number or donor number cannot be recognized");
    error.status = 400;
    throw error;
  }

  run(
    `UPDATE dons
     SET compteID = ?, dateDon = ?, description = ?, donateurID = ?, montant = ?, methodeDonID = ?, recuID = NULL
     WHERE donID = ?`,
    [
      Number(data.compteID),
      data.dateDon,
      data.description || "",
      Number(data.donateurID),
      Number(data.montant),
      Number(data.methodeDonID) || null,
      Number(id),
    ],
  );

  return listDonations({ limit: 500 }, context).find((donation) => donation.donID === Number(id));
}

function deleteDonation(id, context = {}) {
  run(
    `DELETE FROM dons
     WHERE donID = ?
       AND donateurID IN (SELECT donateurID FROM donateurs WHERE organismeID = ?)`,
    [Number(id), organizationID(context)],
  );
  return { deleted: true };
}

function listPendingDonations(context = {}) {
  return all(
    `SELECT *
     FROM incoming_transactions
     WHERE organismeID = ? AND status = 'pending'
     ORDER BY dateTransaction DESC, incomingTransactionID DESC`,
    [organizationID(context)],
  ).map(normalizeIncomingTransaction);
}

function categorizePendingDonation(id, data, context = {}) {
  const orgID = organizationID(context);

  return transaction(() => {
    const pendingDonation = get(
      `SELECT *
       FROM incoming_transactions
       WHERE organismeID = ? AND externalID = ? AND status = 'pending'`,
      [orgID, String(id)],
    );

    if (!pendingDonation) {
      const error = new Error("Pending donation not found");
      error.status = 404;
      throw error;
    }

    const donation = createDonation({
      donateurID: data.donateurID,
      numero: data.numero || pendingDonation.donorNumber,
      compteID: data.compteID,
      montant: pendingDonation.amount,
      dateDon: pendingDonation.dateTransaction,
      methodeDonID: pendingDonation.methodeDonID,
      description: pendingDonation.note,
    }, context);

    run(
      `DELETE FROM incoming_transactions
       WHERE organismeID = ? AND externalID = ?`,
      [orgID, pendingDonation.externalID],
    );

    return { donation, pending: listPendingDonations(context) };
  });
}

function generateReceipts({ dateDebut, dateFin, mode = "email" }, context = {}) {
  const orgID = organizationID(context);
  const code = currentTimestampCode();
  const dateCreation = new Date().toISOString();

  return transaction(() => {
    const candidates = all(
      `SELECT dt.donateurID, dt.nom, dt.prenom, dt.numero, dt.courriel, COALESCE(SUM(d.montant), 0) AS montant
       FROM dons AS d
       INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
       INNER JOIN comptes AS c ON d.compteID = c.compteID
       WHERE dt.organismeID = ?
         AND dt.actif = 1
         AND dt.recu = 1
         AND c.recu = 1
         AND d.dateDon >= ?
         AND d.dateDon <= ?
       GROUP BY dt.donateurID
       HAVING montant > 0
       ORDER BY CAST(dt.numero AS INTEGER), dt.nom, dt.prenom`,
      [orgID, dateDebut, dateFin],
    );

    const created = [];
    for (const donor of candidates) {
      const existingReceipts = all(
        "SELECT recuID FROM recus WHERE organismeID = ? AND dateDebut = ? AND dateFin = ? AND donateurID = ?",
        [orgID, dateDebut, dateFin, donor.donateurID],
      );
      for (const receipt of existingReceipts) {
        run("UPDATE dons SET recuID = NULL WHERE recuID = ?", [receipt.recuID]);
      }
      run("DELETE FROM recus WHERE organismeID = ? AND dateDebut = ? AND dateFin = ? AND donateurID = ?", [orgID, dateDebut, dateFin, donor.donateurID]);
      const receipt = run(
        "INSERT INTO recus (dateCreation, dateDebut, dateFin, donateurID, montant, organismeID) VALUES (?, ?, ?, ?, ?, ?)",
        [dateCreation, dateDebut, dateFin, donor.donateurID, donor.montant, orgID],
      );
      run(
        `UPDATE dons
         SET recuID = ?, verouille = 1
         WHERE donateurID = ? AND dateDon >= ? AND dateDon <= ?
           AND compteID IN (SELECT compteID FROM comptes WHERE organismeID = ? AND recu = 1)`,
        [receipt.lastInsertRowid, donor.donateurID, dateDebut, dateFin, orgID],
      );

      const hasEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(donor.courriel || "");
      const status = mode === "print" ? "2-a-imprimer" : hasEmail ? "1-en-cours" : "0-courriel-non-valide";
      const envoi = run(
        "INSERT INTO envois (dateDebut, dateFin, donateurID, envoiCode, montant, organismeID, statut) VALUES (?, ?, ?, ?, ?, ?, ?)",
        [dateDebut, dateFin, donor.donateurID, code, donor.montant, orgID, status],
      );
      const noRecu = envoi.lastInsertRowid + 1000;
      run("UPDATE envois SET noRecu = ? WHERE envoiID = ?", [noRecu, envoi.lastInsertRowid]);
      created.push({ ...donor, recuID: receipt.lastInsertRowid, envoiID: envoi.lastInsertRowid, noRecu, statut: status });
    }

    return {
      envoiCode: code,
      dateDebut,
      dateFin,
      count: created.length,
      receipts: created,
    };
  });
}

function listReceipts({ dateDebut = "", dateFin = "" } = {}, context = {}) {
  const params = [organizationID(context)];
  let where = "r.organismeID = ?";
  if (dateDebut) {
    where += " AND r.dateDebut >= ?";
    params.push(dateDebut);
  }
  if (dateFin) {
    where += " AND r.dateFin <= ?";
    params.push(dateFin);
  }

  return all(
    `SELECT r.*, dt.nom, dt.prenom, dt.numero, dt.courriel,
      e.envoiID, e.envoiCode, e.noRecu, e.statut
     FROM recus AS r
     INNER JOIN donateurs AS dt ON r.donateurID = dt.donateurID
     LEFT JOIN envois AS e ON e.envoiID = (
      SELECT MAX(e2.envoiID)
      FROM envois AS e2
      WHERE e2.donateurID = r.donateurID
        AND e2.organismeID = r.organismeID
        AND e2.dateDebut = r.dateDebut
        AND e2.dateFin = r.dateFin
     )
     WHERE ${where}
     ORDER BY r.dateCreation DESC, CAST(dt.numero AS INTEGER)`,
    params,
  );
}

function listReceiptBatches(context = {}) {
  return all(
    `SELECT r.dateCreation, r.dateDebut, r.dateFin, COUNT(*) AS recusCount, COALESCE(SUM(r.montant), 0) AS total
     FROM recus AS r
     WHERE r.organismeID = ?
     GROUP BY r.dateCreation, r.dateDebut, r.dateFin
     ORDER BY r.dateCreation DESC`,
    [organizationID(context)],
  );
}

function patchEnvoiStatus(id, status, context = {}) {
  run("UPDATE envois SET statut = ? WHERE envoiID = ? AND organismeID = ?", [status, Number(id), organizationID(context)]);
  return get("SELECT * FROM envois WHERE envoiID = ? AND organismeID = ?", [Number(id), organizationID(context)]);
}

function report(type, params = {}, context = {}) {
  if (type === "donors") {
    return listDonors({ active: params.active || "all", limit: 1000 }, context);
  }

  if (type === "accounts") {
    return listAccounts(context);
  }

  if (type === "receipts") {
    return listReceipts(params, context);
  }

  const rows = listDonations({ dateDebut: params.dateDebut, dateFin: params.dateFin, limit: 1000 }, context);
  const groupBy = params.groupBy || "date";
  const grouped = new Map();

  for (const row of rows) {
    let key = row.dateDon;
    if (groupBy === "account") {
      key = `${row.noCompte} - ${row.libelleCompte}`;
    } else if (groupBy === "month") {
      key = row.dateDon.slice(0, 7);
    } else if (groupBy === "accountMonth") {
      key = `${row.dateDon.slice(0, 7)} - ${row.noCompte} - ${row.libelleCompte}`;
    } else if (groupBy === "donor") {
      key = row.donorName;
    } else if (groupBy === "method") {
      key = row.methode_en || "Unspecified";
    }
    const current = grouped.get(key) || { label: key, count: 0, total: 0 };
    current.count += 1;
    current.total += row.montant;
    grouped.set(key, current);
  }

  return {
    rows,
    summary: Array.from(grouped.values()),
  };
}

function createSubscriptionRequest(data) {
  const result = run(
    `INSERT INTO abonnement_demandes (
      organisme, enregistrement, responsable, responsable_courriel, adresse, ville,
      province, code_postal, telephone, membre, nomembre, langue
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      data.organisme,
      data.enregistrement,
      data.responsable,
      data.responsable_courriel,
      data.adresse || "",
      data.ville || "",
      data.province || "",
      data.code_postal || "",
      data.telephone || "",
      bool(data.membre),
      data.nomembre || "",
      data.langue || "en",
    ],
  );

  return get("SELECT * FROM abonnement_demandes WHERE demandeID = ?", [result.lastInsertRowid]);
}

export const store = {
  databasePath,
  login,
  authenticate,
  createSession,
  deleteSession,
  registerOrganization,
  requestPasswordReset,
  getBootstrap,
  getOrganization,
  updateOrganization,
  getDashboard,
  listUsers,
  createUser,
  updateUser,
  updateUserStatus,
  listBankingConnections,
  createBankingConnection,
  deleteBankingConnection,
  listReportTemplates,
  createReportTemplate,
  deleteReportTemplate,
  listDonors,
  nextDonorNumber,
  createDonor,
  updateDonor,
  archiveDonor,
  deleteDonor,
  listAccounts,
  createAccount,
  updateAccount,
  deleteAccount,
  listDonations,
  createDonation,
  updateDonation,
  deleteDonation,
  listPendingDonations,
  categorizePendingDonation,
  generateReceipts,
  listReceipts,
  listReceiptBatches,
  patchEnvoiStatus,
  report,
  createSubscriptionRequest,
};
