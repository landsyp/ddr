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

const planCatalog = [
  {
    planID: "base",
    name: "Base",
    description: "Current default SaaS model for every tenant while future plan declinations are prepared.",
    monthlyPrice: 29,
    annualPrice: 290,
    includedSeats: 2,
    donorLimit: 500,
    donationLimit: 2500,
    receiptLimit: 1000,
    supportLevel: "Standard email support",
    features: ["Donor management", "Donation tracking", "Manual receipt batches", "CSV exports"],
    recommended: false,
    sortOrder: 1,
  },
  {
    planID: "gold",
    name: "Gold",
    description: "Future declination for growing teams that need automation, more seats, bank connections, and priority help.",
    monthlyPrice: 59,
    annualPrice: 590,
    includedSeats: 5,
    donorLimit: 2500,
    donationLimit: 15000,
    receiptLimit: 6000,
    supportLevel: "Priority support",
    features: ["Everything in Base", "Bank and payment connections", "Receipt batches", "Report templates", "Audit log"],
    recommended: true,
    sortOrder: 2,
  },
  {
    planID: "premium",
    name: "Premium",
    description: "Future declination for advanced organizations with integrations, API access, webhooks, and custom workflows.",
    monthlyPrice: 99,
    annualPrice: 990,
    includedSeats: 15,
    donorLimit: 10000,
    donationLimit: 75000,
    receiptLimit: 25000,
    supportLevel: "Dedicated onboarding",
    features: ["Everything in Gold", "API keys", "Webhooks", "Advanced integrations", "Custom onboarding"],
    recommended: false,
    sortOrder: 3,
  },
];

const onboardingTemplates = [
  ["profile", "Complete organization receipt profile"],
  ["users", "Invite finance and admin users"],
  ["accounts", "Review receiptable account chart"],
  ["payments", "Add a billing payment method"],
  ["receipts", "Generate first receipt batch"],
  ["security", "Review security settings"],
];

const roleDefinitions = {
  saas_admin: {
    label: "SaaS Admin",
    description: "Platform administrator with access to all tenants and SaaS controls.",
    scope: "platform",
  },
  org_admin: {
    label: "Organization Admin",
    description: "Tenant administrator for users, settings, billing, and all workspace data.",
    scope: "tenant",
  },
  editor: {
    label: "Editor",
    description: "Can create and update donor, donation, receipt, report, and integration records.",
    scope: "tenant",
  },
  auditor: {
    label: "Auditor",
    description: "Read-only access to records, reports, receipts, invoices, and audit history.",
    scope: "tenant",
  },
  viewer: {
    label: "Viewer",
    description: "Read-only workspace access for dashboards and operational records.",
    scope: "tenant",
  },
};

const tenantRoleOrder = ["org_admin", "editor", "auditor", "viewer"];
const platformRoleOrder = ["saas_admin", ...tenantRoleOrder];

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
      role TEXT NOT NULL DEFAULT 'viewer',
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

    CREATE TABLE IF NOT EXISTS accounting_integrations (
      integrationID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      provider TEXT NOT NULL,
      displayName TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'ready',
      scopes TEXT NOT NULL DEFAULT '[]',
      realmOrTenantId TEXT,
      syncMode TEXT NOT NULL DEFAULT 'donations',
      lastSyncAt TEXT,
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

    CREATE TABLE IF NOT EXISTS saas_plans (
      planID TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      monthlyPrice REAL NOT NULL,
      annualPrice REAL NOT NULL,
      includedSeats INTEGER NOT NULL,
      donorLimit INTEGER NOT NULL,
      donationLimit INTEGER NOT NULL,
      receiptLimit INTEGER NOT NULL,
      supportLevel TEXT NOT NULL,
      features TEXT NOT NULL DEFAULT '[]',
      recommended INTEGER NOT NULL DEFAULT 0,
      sortOrder INTEGER NOT NULL DEFAULT 1
    );

    CREATE TABLE IF NOT EXISTS subscriptions (
      subscriptionID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL UNIQUE REFERENCES organismes(organismeID) ON DELETE CASCADE,
      planID TEXT NOT NULL REFERENCES saas_plans(planID),
      status TEXT NOT NULL DEFAULT 'trialing',
      billingCycle TEXT NOT NULL DEFAULT 'monthly',
      trialEndsAt TEXT,
      currentPeriodStart TEXT NOT NULL,
      currentPeriodEnd TEXT NOT NULL,
      cancelAtPeriodEnd INTEGER NOT NULL DEFAULT 0,
      renewalAmount REAL NOT NULL DEFAULT 0,
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS payment_methods (
      paymentMethodID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      brand TEXT NOT NULL,
      last4 TEXT NOT NULL,
      expiryMonth TEXT NOT NULL,
      expiryYear TEXT NOT NULL,
      cardholder TEXT NOT NULL,
      isDefault INTEGER NOT NULL DEFAULT 0,
      status TEXT NOT NULL DEFAULT 'active',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS invoices (
      invoiceID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      invoiceNumber TEXT NOT NULL UNIQUE,
      issuedAt TEXT NOT NULL,
      dueAt TEXT NOT NULL,
      paidAt TEXT,
      amount REAL NOT NULL,
      currency TEXT NOT NULL DEFAULT 'CAD',
      status TEXT NOT NULL DEFAULT 'paid',
      description TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS audit_events (
      auditEventID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      utilisateurID INTEGER REFERENCES utilisateurs(utilisateurID) ON DELETE SET NULL,
      actorEmail TEXT,
      action TEXT NOT NULL,
      entityType TEXT NOT NULL,
      entityID TEXT,
      metadata TEXT NOT NULL DEFAULT '{}',
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS api_keys (
      apiKeyID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      label TEXT NOT NULL,
      keyPrefix TEXT NOT NULL,
      keyHash TEXT NOT NULL UNIQUE,
      scopes TEXT NOT NULL DEFAULT '[]',
      lastUsedAt TEXT,
      active INTEGER NOT NULL DEFAULT 1,
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS webhook_endpoints (
      webhookID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      url TEXT NOT NULL,
      events TEXT NOT NULL DEFAULT '[]',
      secretPrefix TEXT NOT NULL,
      secretHash TEXT NOT NULL,
      active INTEGER NOT NULL DEFAULT 1,
      lastDeliveryStatus TEXT,
      lastDeliveryAt TEXT,
      createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS onboarding_tasks (
      taskID INTEGER PRIMARY KEY AUTOINCREMENT,
      organismeID INTEGER NOT NULL REFERENCES organismes(organismeID) ON DELETE CASCADE,
      taskKey TEXT NOT NULL,
      title TEXT NOT NULL,
      completed INTEGER NOT NULL DEFAULT 0,
      completedAt TEXT,
      UNIQUE (organismeID, taskKey)
    );

    CREATE TABLE IF NOT EXISTS security_settings (
      organismeID INTEGER PRIMARY KEY REFERENCES organismes(organismeID) ON DELETE CASCADE,
      mfaRequired INTEGER NOT NULL DEFAULT 0,
      passwordMinLength INTEGER NOT NULL DEFAULT 8,
      sessionTimeoutDays INTEGER NOT NULL DEFAULT 30,
      allowedDomains TEXT NOT NULL DEFAULT '[]',
      updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );

    CREATE INDEX IF NOT EXISTS idx_dons_donateur ON dons(donateurID);
    CREATE INDEX IF NOT EXISTS idx_dons_date ON dons(dateDon);
    CREATE INDEX IF NOT EXISTS idx_incoming_transactions_org_status ON incoming_transactions(organismeID, status);
    CREATE INDEX IF NOT EXISTS idx_banking_connections_org ON banking_connections(organismeID);
    CREATE INDEX IF NOT EXISTS idx_report_templates_org ON report_templates(organismeID);
    CREATE INDEX IF NOT EXISTS idx_accounting_integrations_org ON accounting_integrations(organismeID);
    CREATE INDEX IF NOT EXISTS idx_recus_org_period ON recus(organismeID, dateDebut, dateFin);
    CREATE INDEX IF NOT EXISTS idx_envois_org_code ON envois(organismeID, envoiCode);
    CREATE INDEX IF NOT EXISTS idx_subscriptions_org ON subscriptions(organismeID);
    CREATE INDEX IF NOT EXISTS idx_payment_methods_org ON payment_methods(organismeID);
    CREATE INDEX IF NOT EXISTS idx_invoices_org ON invoices(organismeID, issuedAt);
    CREATE INDEX IF NOT EXISTS idx_audit_events_org_created ON audit_events(organismeID, createdAt);
    CREATE INDEX IF NOT EXISTS idx_api_keys_org ON api_keys(organismeID, active);
    CREATE INDEX IF NOT EXISTS idx_webhook_endpoints_org ON webhook_endpoints(organismeID, active);
    CREATE UNIQUE INDEX IF NOT EXISTS idx_utilisateurs_courriel_unique ON utilisateurs(courriel);
  `);
}

function hasColumn(table, column) {
  return db.prepare(`PRAGMA table_info(${table})`).all().some((row) => row.name === column);
}

function migrateSchema() {
  if (!hasColumn("utilisateurs", "role")) {
    db.exec("ALTER TABLE utilisateurs ADD COLUMN role TEXT NOT NULL DEFAULT 'viewer'");
  }

  db.exec("UPDATE utilisateurs SET role = 'org_admin' WHERE admin = 1 AND (role IS NULL OR role = '' OR role = 'viewer')");
  db.exec("UPDATE utilisateurs SET role = 'viewer' WHERE role IS NULL OR role = ''");
  db.exec("UPDATE utilisateurs SET admin = 1 WHERE role IN ('org_admin', 'saas_admin')");
  db.exec("UPDATE utilisateurs SET admin = 0 WHERE role NOT IN ('org_admin', 'saas_admin')");
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
      INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, role, utilisateurStatutID)
      VALUES (1, 1, 'admin@ddr.local', 'en', ?, 'Brouillet', 1, 'Francois', 'org_admin', 1)
    `).run(hashPassword("password"));
  }

  const seedUser = db.prepare(`
    INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, role, utilisateurStatutID)
    SELECT 1, ?, ?, 'en', ?, ?, 1, ?, ?, 1
    WHERE NOT EXISTS (SELECT 1 FROM utilisateurs WHERE lower(courriel) = lower(?))
  `);

  [
    ["editor@ddr.local", "Editor", "Emma", "editor"],
    ["auditor@ddr.local", "Auditor", "Andre", "auditor"],
    ["viewer@ddr.local", "Viewer", "Vera", "viewer"],
    ["saas.admin@ddr.local", "Platform", "Sasha", "saas_admin"],
  ].forEach(([email, nom, prenom, role]) => {
    seedUser.run(role === "saas_admin" || role === "org_admin" ? 1 : 0, email, hashPassword("password"), nom, prenom, role, email);
  });

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

  const accountingIntegrationCount = db.prepare("SELECT COUNT(*) AS count FROM accounting_integrations").get().count;
  if (!accountingIntegrationCount) {
    const insertAccountingIntegration = db.prepare(`
      INSERT INTO accounting_integrations (
        organismeID, provider, displayName, status, scopes, realmOrTenantId, syncMode
      ) VALUES (1, ?, ?, ?, ?, ?, ?)
    `);

    [
      [
        "quickbooks",
        "QuickBooks Online",
        "ready",
        JSON.stringify(["com.intuit.quickbooks.accounting"]),
        "",
        "donations",
      ],
      [
        "xero",
        "Xero Accounting",
        "ready",
        JSON.stringify(["offline_access", "accounting.invoices", "accounting.payments", "accounting.banktransactions", "accounting.manualjournals"]),
        "",
        "donations",
      ],
    ].forEach((row) => insertAccountingIntegration.run(...row));
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

  seedPlanCatalog();
  for (const organization of db.prepare("SELECT organismeID FROM organismes").all()) {
    ensureSaasDefaults(organization.organismeID);
  }
}

setupSchema();
migrateSchema();
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

  const role = user.role || (user.admin ? "org_admin" : "viewer");

  return {
    utilisateurID: user.utilisateurID,
    actif: Boolean(user.actif ?? true),
    admin: role === "org_admin" || role === "saas_admin" || Boolean(user.admin),
    courriel: user.courriel,
    langue: user.langue,
    nom: user.nom,
    prenom: user.prenom,
    role,
    roleLabel: roleDefinitions[role]?.label || roleDefinitions.viewer.label,
    roleScope: roleDefinitions[role]?.scope || "tenant",
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

function parseJSON(value, fallback) {
  try {
    return JSON.parse(value || "");
  } catch {
    return fallback;
  }
}

function normalizePlan(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    monthlyPrice: Number(row.monthlyPrice),
    annualPrice: Number(row.annualPrice),
    includedSeats: Number(row.includedSeats),
    donorLimit: Number(row.donorLimit),
    donationLimit: Number(row.donationLimit),
    receiptLimit: Number(row.receiptLimit),
    features: parseJSON(row.features, []),
    recommended: Boolean(row.recommended),
  };
}

function normalizeSubscription(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    cancelAtPeriodEnd: Boolean(row.cancelAtPeriodEnd),
    renewalAmount: Number(row.renewalAmount),
    plan: normalizePlan({
      planID: row.planID,
      name: row.planName,
      description: row.planDescription,
      monthlyPrice: row.monthlyPrice,
      annualPrice: row.annualPrice,
      includedSeats: row.includedSeats,
      donorLimit: row.donorLimit,
      donationLimit: row.donationLimit,
      receiptLimit: row.receiptLimit,
      supportLevel: row.supportLevel,
      features: row.features,
      recommended: row.recommended,
      sortOrder: row.sortOrder,
    }),
  };
}

function normalizePaymentMethod(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    isDefault: Boolean(row.isDefault),
  };
}

function normalizeInvoice(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    amount: Number(row.amount),
  };
}

function normalizeAuditEvent(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    metadata: parseJSON(row.metadata, {}),
  };
}

function normalizeApiKey(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    active: Boolean(row.active),
    scopes: parseJSON(row.scopes, []),
  };
}

function normalizeWebhook(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    active: Boolean(row.active),
    events: parseJSON(row.events, []),
  };
}

function normalizeOnboardingTask(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    completed: Boolean(row.completed),
  };
}

function normalizeSecuritySettings(row) {
  if (!row) {
    return row;
  }

  return {
    ...row,
    mfaRequired: Boolean(row.mfaRequired),
    allowedDomains: parseJSON(row.allowedDomains, []),
  };
}

function seedPlanCatalog() {
  const upsertPlan = db.prepare(`
    INSERT INTO saas_plans (
      planID, name, description, monthlyPrice, annualPrice, includedSeats,
      donorLimit, donationLimit, receiptLimit, supportLevel, features, recommended, sortOrder
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(planID) DO UPDATE SET
      name = excluded.name,
      description = excluded.description,
      monthlyPrice = excluded.monthlyPrice,
      annualPrice = excluded.annualPrice,
      includedSeats = excluded.includedSeats,
      donorLimit = excluded.donorLimit,
      donationLimit = excluded.donationLimit,
      receiptLimit = excluded.receiptLimit,
      supportLevel = excluded.supportLevel,
      features = excluded.features,
      recommended = excluded.recommended,
      sortOrder = excluded.sortOrder
  `);

  for (const plan of planCatalog) {
    upsertPlan.run(
      plan.planID,
      plan.name,
      plan.description,
      plan.monthlyPrice,
      plan.annualPrice,
      plan.includedSeats,
      plan.donorLimit,
      plan.donationLimit,
      plan.receiptLimit,
      plan.supportLevel,
      JSON.stringify(plan.features),
      bool(plan.recommended),
      plan.sortOrder,
    );
  }

  run("UPDATE subscriptions SET planID = 'base', status = 'active', renewalAmount = 29 WHERE planID = 'basic' OR (planID = 'base' AND status = 'trialing') OR (planID = 'gold' AND status = 'trialing')");
}

function periodEndISO(billingCycle = "monthly") {
  const date = new Date();
  if (billingCycle === "annual") {
    date.setFullYear(date.getFullYear() + 1);
  } else {
    date.setMonth(date.getMonth() + 1);
  }
  return date.toISOString().slice(0, 10);
}

function planRenewalAmount(plan, billingCycle = "monthly") {
  return billingCycle === "annual" ? Number(plan.annualPrice) : Number(plan.monthlyPrice);
}

function ensureSaasDefaults(orgID) {
  const numericOrgID = Number(orgID);
  seedPlanCatalog();

  const basePlan = normalizePlan(get("SELECT * FROM saas_plans WHERE planID = 'base'"));
  const subscriptionExists = get("SELECT subscriptionID FROM subscriptions WHERE organismeID = ?", [numericOrgID]);
  if (!subscriptionExists) {
    run(
      `INSERT INTO subscriptions (
        organismeID, planID, status, billingCycle, trialEndsAt, currentPeriodStart,
        currentPeriodEnd, renewalAmount
      ) VALUES (?, 'base', 'active', 'monthly', ?, ?, ?, ?)`,
      [numericOrgID, futureDateISO(14), todayISO(), periodEndISO("monthly"), planRenewalAmount(basePlan, "monthly")],
    );
  }

  const securityExists = get("SELECT organismeID FROM security_settings WHERE organismeID = ?", [numericOrgID]);
  if (!securityExists) {
    run("INSERT INTO security_settings (organismeID) VALUES (?)", [numericOrgID]);
  }

  for (const [taskKey, title] of onboardingTemplates) {
    run(
      "INSERT OR IGNORE INTO onboarding_tasks (organismeID, taskKey, title, completed) VALUES (?, ?, ?, ?)",
      [numericOrgID, taskKey, title, taskKey === "profile" ? 1 : 0],
    );
  }

  const paymentCount = Number(get("SELECT COUNT(*) AS count FROM payment_methods WHERE organismeID = ?", [numericOrgID])?.count || 0);
  if (numericOrgID === 1 && paymentCount === 0) {
    run(
      `INSERT INTO payment_methods (
        organismeID, brand, last4, expiryMonth, expiryYear, cardholder, isDefault, status
      ) VALUES (?, 'Visa', '4242', '04', '2029', 'Grace Community Church', 1, 'active')`,
      [numericOrgID],
    );
  }

  const invoiceCount = Number(get("SELECT COUNT(*) AS count FROM invoices WHERE organismeID = ?", [numericOrgID])?.count || 0);
  if (numericOrgID === 1 && invoiceCount === 0) {
    run(
      `INSERT INTO invoices (
        organismeID, invoiceNumber, issuedAt, dueAt, paidAt, amount, currency, status, description
      ) VALUES (?, ?, ?, ?, ?, ?, 'CAD', 'paid', ?)`,
      [numericOrgID, `WS-${new Date().getFullYear()}-0001`, todayISO(), futureDateISO(15), todayISO(), 59, "Gold monthly subscription"],
    );
  }

  const apiKeyCount = Number(get("SELECT COUNT(*) AS count FROM api_keys WHERE organismeID = ?", [numericOrgID])?.count || 0);
  if (numericOrgID === 1 && apiKeyCount === 0) {
    const secret = `ws_live_${randomBytes(24).toString("hex")}`;
    run(
      `INSERT INTO api_keys (organismeID, label, keyPrefix, keyHash, scopes)
       VALUES (?, 'Donation import automation', ?, ?, ?)`,
      [numericOrgID, secret.slice(0, 12), tokenHash(secret), JSON.stringify(["donations:write", "donors:read"])],
    );
  }

  const webhookCount = Number(get("SELECT COUNT(*) AS count FROM webhook_endpoints WHERE organismeID = ?", [numericOrgID])?.count || 0);
  if (numericOrgID === 1 && webhookCount === 0) {
    const secret = `whsec_${randomBytes(16).toString("hex")}`;
    run(
      `INSERT INTO webhook_endpoints (
        organismeID, url, events, secretPrefix, secretHash, active, lastDeliveryStatus, lastDeliveryAt
      ) VALUES (?, 'https://example.org/weserve/webhook', ?, ?, ?, 1, 'delivered', ?)`,
      [numericOrgID, JSON.stringify(["donation.created", "receipt.generated"]), secret.slice(0, 10), tokenHash(secret), new Date().toISOString()],
    );
  }

  const auditCount = Number(get("SELECT COUNT(*) AS count FROM audit_events WHERE organismeID = ?", [numericOrgID])?.count || 0);
  if (!auditCount) {
    audit({ organismeID: numericOrgID }, "workspace.provisioned", "organization", numericOrgID, { source: "system" });
  }
}

function audit(context, action, entityType, entityID = "", metadata = {}) {
  run(
    `INSERT INTO audit_events (
      organismeID, utilisateurID, actorEmail, action, entityType, entityID, metadata
    ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [
      organizationID(context),
      context?.utilisateurID || null,
      context?.courriel || "system",
      action,
      entityType,
      String(entityID || ""),
      JSON.stringify(metadata),
    ],
  );
}

function listSaasPlans() {
  seedPlanCatalog();
  return all("SELECT * FROM saas_plans ORDER BY sortOrder").map(normalizePlan);
}

function getSubscription(context = {}) {
  const orgID = organizationID(context);
  ensureSaasDefaults(orgID);
  return normalizeSubscription(get(
    `SELECT s.*, p.name AS planName, p.description AS planDescription, p.monthlyPrice, p.annualPrice,
      p.includedSeats, p.donorLimit, p.donationLimit, p.receiptLimit, p.supportLevel,
      p.features, p.recommended, p.sortOrder
     FROM subscriptions AS s
     INNER JOIN saas_plans AS p ON s.planID = p.planID
     WHERE s.organismeID = ?`,
    [orgID],
  ));
}

function updateSubscription(data, context = {}) {
  const orgID = organizationID(context);
  const plan = normalizePlan(get("SELECT * FROM saas_plans WHERE planID = ?", [String(data.planID || "").toLowerCase()]));
  if (!plan) {
    const error = new Error("Plan not found");
    error.status = 404;
    throw error;
  }

  const billingCycle = data.billingCycle === "annual" ? "annual" : "monthly";
  run(
    `UPDATE subscriptions
     SET planID = ?, status = 'active', billingCycle = ?, currentPeriodEnd = ?,
         cancelAtPeriodEnd = ?, renewalAmount = ?, updatedAt = CURRENT_TIMESTAMP
     WHERE organismeID = ?`,
    [
      plan.planID,
      billingCycle,
      periodEndISO(billingCycle),
      bool(data.cancelAtPeriodEnd),
      planRenewalAmount(plan, billingCycle),
      orgID,
    ],
  );
  audit(context, "subscription.updated", "subscription", orgID, { planID: plan.planID, billingCycle });
  return getSubscription(context);
}

function getUsage(context = {}) {
  const orgID = organizationID(context);
  const subscription = getSubscription(context);
  const plan = subscription?.plan || listSaasPlans()[0];
  const activeUsers = Number(get("SELECT COUNT(*) AS count FROM utilisateurs WHERE organismeID = ? AND actif = 1", [orgID])?.count || 0);
  const donors = Number(get("SELECT COUNT(*) AS count FROM donateurs WHERE organismeID = ?", [orgID])?.count || 0);
  const donations = Number(get(
    `SELECT COUNT(*) AS count
     FROM dons AS d
     INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
     WHERE dt.organismeID = ?`,
    [orgID],
  )?.count || 0);
  const receipts = Number(get("SELECT COUNT(*) AS count FROM recus WHERE organismeID = ?", [orgID])?.count || 0);

  const buildMetric = (label, used, limit) => ({
    label,
    used,
    limit,
    percent: limit ? Math.min(Math.round((used / limit) * 100), 999) : 0,
    remaining: Math.max(limit - used, 0),
  });

  return {
    activeUsers: buildMetric("Active seats", activeUsers, plan.includedSeats),
    donors: buildMetric("Donors", donors, plan.donorLimit),
    donations: buildMetric("Donations", donations, plan.donationLimit),
    receipts: buildMetric("Receipts", receipts, plan.receiptLimit),
  };
}

function listPlatformTenants(context = {}) {
  if (context.role !== "saas_admin") {
    const error = new Error("SaaS admin access required");
    error.status = 403;
    throw error;
  }

  return all(
    `SELECT
      o.organismeID,
      o.organisme,
      o.actif,
      o.responsable,
      o.responsable_courriel,
      o.date_fin_licence,
      o.devise,
      s.status AS subscriptionStatus,
      s.billingCycle,
      s.renewalAmount,
      p.name AS planName,
      (SELECT COUNT(*) FROM utilisateurs AS u WHERE u.organismeID = o.organismeID AND u.actif = 1) AS activeUsers,
      (SELECT COUNT(*) FROM donateurs AS d WHERE d.organismeID = o.organismeID) AS donors,
      (
        SELECT COUNT(*)
        FROM dons AS dn
        INNER JOIN donateurs AS dd ON dn.donateurID = dd.donateurID
        WHERE dd.organismeID = o.organismeID
      ) AS donations
     FROM organismes AS o
     LEFT JOIN subscriptions AS s ON s.organismeID = o.organismeID
     LEFT JOIN saas_plans AS p ON p.planID = s.planID
     ORDER BY o.organisme`,
  ).map((tenant) => ({
    ...tenant,
    actif: Boolean(tenant.actif),
    activeUsers: Number(tenant.activeUsers || 0),
    donors: Number(tenant.donors || 0),
    donations: Number(tenant.donations || 0),
    renewalAmount: Number(tenant.renewalAmount || 0),
  }));
}

function listPaymentMethods(context = {}) {
  return all(
    "SELECT * FROM payment_methods WHERE organismeID = ? ORDER BY isDefault DESC, createdAt DESC",
    [organizationID(context)],
  ).map(normalizePaymentMethod);
}

function detectCardBrand(cardNumber = "") {
  const digits = String(cardNumber).replace(/\D/g, "");
  if (digits.startsWith("4")) {
    return "Visa";
  }
  if (/^5[1-5]/.test(digits) || /^2[2-7]/.test(digits)) {
    return "Mastercard";
  }
  if (/^3[47]/.test(digits)) {
    return "American Express";
  }
  return "Card";
}

function createPaymentMethod(data, context = {}) {
  const cardNumber = String(data.cardNumber || data.number || "");
  const digits = cardNumber.replace(/\D/g, "");
  const last4 = String(data.last4 || digits.slice(-4)).padStart(4, "0").slice(-4);
  const expiry = String(data.expiryDate || data.expiry || "").replace(/\s/g, "");
  const [expiryMonth = data.expiryMonth || "", expiryYear = data.expiryYear || ""] = expiry.split(/[/-]/);
  const cardholder = String(data.cardholder || data.name || "").trim();

  if (!cardholder || last4.length !== 4 || !expiryMonth || !expiryYear) {
    const error = new Error("Cardholder, last four digits, and expiry are required");
    error.status = 400;
    throw error;
  }

  const orgID = organizationID(context);
  const shouldDefault = data.isDefault !== false || listPaymentMethods(context).length === 0;
  if (shouldDefault) {
    run("UPDATE payment_methods SET isDefault = 0 WHERE organismeID = ?", [orgID]);
  }

  const result = run(
    `INSERT INTO payment_methods (
      organismeID, brand, last4, expiryMonth, expiryYear, cardholder, isDefault, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, 'active')`,
    [orgID, data.brand || detectCardBrand(cardNumber), last4, expiryMonth, expiryYear, cardholder, bool(shouldDefault)],
  );
  audit(context, "payment_method.created", "payment_method", result.lastInsertRowid, { brand: data.brand || detectCardBrand(cardNumber), last4 });
  markOnboardingTask("payments", true, context);
  return listPaymentMethods(context).find((paymentMethod) => paymentMethod.paymentMethodID === result.lastInsertRowid);
}

function deletePaymentMethod(id, context = {}) {
  const orgID = organizationID(context);
  const paymentMethod = get("SELECT * FROM payment_methods WHERE paymentMethodID = ? AND organismeID = ?", [Number(id), orgID]);
  if (!paymentMethod) {
    const error = new Error("Payment method not found");
    error.status = 404;
    throw error;
  }
  if (paymentMethod.isDefault) {
    const error = new Error("Default payment method cannot be deleted");
    error.status = 409;
    throw error;
  }

  run("DELETE FROM payment_methods WHERE paymentMethodID = ? AND organismeID = ?", [Number(id), orgID]);
  audit(context, "payment_method.deleted", "payment_method", id, { last4: paymentMethod.last4 });
  return { deleted: true };
}

function listInvoices(context = {}) {
  return all(
    "SELECT * FROM invoices WHERE organismeID = ? ORDER BY issuedAt DESC, invoiceID DESC",
    [organizationID(context)],
  ).map(normalizeInvoice);
}

function listAuditEvents({ limit = 50 } = {}, context = {}) {
  return all(
    `SELECT *
     FROM audit_events
     WHERE organismeID = ?
     ORDER BY createdAt DESC, auditEventID DESC
     LIMIT ?`,
    [organizationID(context), Number(limit) || 50],
  ).map(normalizeAuditEvent);
}

function listApiKeys(context = {}) {
  return all(
    "SELECT apiKeyID, organismeID, label, keyPrefix, scopes, lastUsedAt, active, createdAt FROM api_keys WHERE organismeID = ? ORDER BY createdAt DESC",
    [organizationID(context)],
  ).map(normalizeApiKey);
}

function createApiKey(data, context = {}) {
  const label = String(data.label || "").trim();
  if (!label) {
    const error = new Error("API key label is required");
    error.status = 400;
    throw error;
  }

  const secret = `ws_live_${randomBytes(24).toString("hex")}`;
  const scopes = Array.isArray(data.scopes) && data.scopes.length ? data.scopes : ["donations:read", "donors:read"];
  const result = run(
    `INSERT INTO api_keys (organismeID, label, keyPrefix, keyHash, scopes)
     VALUES (?, ?, ?, ?, ?)`,
    [organizationID(context), label, secret.slice(0, 12), tokenHash(secret), JSON.stringify(scopes)],
  );
  audit(context, "api_key.created", "api_key", result.lastInsertRowid, { label, scopes });
  return {
    ...listApiKeys(context).find((apiKey) => apiKey.apiKeyID === result.lastInsertRowid),
    secret,
  };
}

function revokeApiKey(id, context = {}) {
  run("UPDATE api_keys SET active = 0 WHERE apiKeyID = ? AND organismeID = ?", [Number(id), organizationID(context)]);
  audit(context, "api_key.revoked", "api_key", id);
  return listApiKeys(context).find((apiKey) => apiKey.apiKeyID === Number(id));
}

function listWebhooks(context = {}) {
  return all(
    "SELECT * FROM webhook_endpoints WHERE organismeID = ? ORDER BY createdAt DESC",
    [organizationID(context)],
  ).map(normalizeWebhook);
}

function createWebhook(data, context = {}) {
  const url = String(data.url || "").trim();
  if (!/^https:\/\/.+/i.test(url)) {
    const error = new Error("Webhook URL must start with https://");
    error.status = 400;
    throw error;
  }

  const secret = `whsec_${randomBytes(16).toString("hex")}`;
  const events = Array.isArray(data.events) && data.events.length ? data.events : ["donation.created", "receipt.generated"];
  const result = run(
    `INSERT INTO webhook_endpoints (organismeID, url, events, secretPrefix, secretHash, active)
     VALUES (?, ?, ?, ?, ?, 1)`,
    [organizationID(context), url, JSON.stringify(events), secret.slice(0, 10), tokenHash(secret)],
  );
  audit(context, "webhook.created", "webhook", result.lastInsertRowid, { url, events });
  return {
    ...listWebhooks(context).find((webhook) => webhook.webhookID === result.lastInsertRowid),
    secret,
  };
}

function deleteWebhook(id, context = {}) {
  run("DELETE FROM webhook_endpoints WHERE webhookID = ? AND organismeID = ?", [Number(id), organizationID(context)]);
  audit(context, "webhook.deleted", "webhook", id);
  return { deleted: true };
}

function testWebhook(id, context = {}) {
  const timestamp = new Date().toISOString();
  run(
    "UPDATE webhook_endpoints SET lastDeliveryStatus = 'test delivered', lastDeliveryAt = ? WHERE webhookID = ? AND organismeID = ?",
    [timestamp, Number(id), organizationID(context)],
  );
  audit(context, "webhook.tested", "webhook", id, { deliveredAt: timestamp });
  return listWebhooks(context).find((webhook) => webhook.webhookID === Number(id));
}

function listOnboardingTasks(context = {}) {
  ensureSaasDefaults(organizationID(context));
  return all(
    "SELECT * FROM onboarding_tasks WHERE organismeID = ? ORDER BY taskID",
    [organizationID(context)],
  ).map(normalizeOnboardingTask);
}

function markOnboardingTask(taskKey, completed = true, context = {}) {
  run(
    `UPDATE onboarding_tasks
     SET completed = ?, completedAt = CASE WHEN ? = 1 THEN CURRENT_TIMESTAMP ELSE NULL END
     WHERE organismeID = ? AND taskKey = ?`,
    [bool(completed), bool(completed), organizationID(context), String(taskKey)],
  );
  return listOnboardingTasks(context).find((task) => task.taskKey === String(taskKey));
}

function getSecuritySettings(context = {}) {
  ensureSaasDefaults(organizationID(context));
  return normalizeSecuritySettings(get("SELECT * FROM security_settings WHERE organismeID = ?", [organizationID(context)]));
}

function updateSecuritySettings(data, context = {}) {
  const domains = Array.isArray(data.allowedDomains)
    ? data.allowedDomains
    : String(data.allowedDomains || "").split(",").map((domain) => domain.trim()).filter(Boolean);
  const passwordMinLength = Math.min(Math.max(Number(data.passwordMinLength) || 8, 8), 64);
  const sessionTimeoutDays = Math.min(Math.max(Number(data.sessionTimeoutDays) || 30, 1), 90);

  run(
    `UPDATE security_settings
     SET mfaRequired = ?, passwordMinLength = ?, sessionTimeoutDays = ?, allowedDomains = ?, updatedAt = CURRENT_TIMESTAMP
     WHERE organismeID = ?`,
    [bool(data.mfaRequired), passwordMinLength, sessionTimeoutDays, JSON.stringify(domains), organizationID(context)],
  );
  audit(context, "security_settings.updated", "security_settings", organizationID(context), {
    mfaRequired: Boolean(data.mfaRequired),
    passwordMinLength,
    sessionTimeoutDays,
  });
  markOnboardingTask("security", true, context);
  return getSecuritySettings(context);
}

function getSaasOverview(context = {}) {
  ensureSaasDefaults(organizationID(context));
  return {
    plans: listSaasPlans(),
    subscription: getSubscription(context),
    usage: getUsage(context),
    paymentMethods: listPaymentMethods(context),
    invoices: listInvoices(context),
    auditEvents: listAuditEvents({ limit: 20 }, context),
    apiKeys: listApiKeys(context),
    webhooks: listWebhooks(context),
    onboardingTasks: listOnboardingTasks(context),
    security: getSecuritySettings(context),
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
    ensureSaasDefaults(orgID);
    const userResult = run(
      `INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, role, utilisateurStatutID)
       VALUES (1, 1, ?, ?, ?, ?, ?, ?, 'org_admin', 1)`,
      [
        email,
        data.langue || "en",
        hashPassword(password),
        String(data.nom || "Admin").trim(),
        orgID,
        String(data.prenom || "SaaS").trim(),
      ],
    );
    audit({ organismeID: orgID, utilisateurID: userResult.lastInsertRowid, courriel: email }, "workspace.registered", "organization", orgID);

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
    `SELECT utilisateurID, actif, admin, courriel, langue, nom, organismeID, prenom, role, utilisateurStatutID
     FROM utilisateurs
     WHERE organismeID = ?
     ORDER BY CASE role
       WHEN 'saas_admin' THEN 0
       WHEN 'org_admin' THEN 1
       WHEN 'editor' THEN 2
       WHEN 'auditor' THEN 3
       ELSE 4
     END, nom, prenom`,
    [organizationID(context)],
  ).map((user) => ({
    ...user,
    actif: Boolean(user.actif),
    role: user.role || (user.admin ? "org_admin" : "viewer"),
    admin: Boolean(user.admin),
    roleLabel: roleDefinitions[user.role || (user.admin ? "org_admin" : "viewer")]?.label || roleDefinitions.viewer.label,
  }));
}

function normalizeUserRole(role, context = {}) {
  const requestedRole = String(role || "").trim() || (bool(context.admin) ? "org_admin" : "viewer");
  if (!roleDefinitions[requestedRole]) {
    const error = new Error("Unknown user role");
    error.status = 400;
    throw error;
  }

  if (requestedRole === "saas_admin" && context.role !== "saas_admin") {
    const error = new Error("Only a SaaS admin can assign the SaaS admin role");
    error.status = 403;
    throw error;
  }

  return requestedRole;
}

function createUser(data, context = {}) {
  const email = String(data.courriel || data.email || "").trim().toLowerCase();
  const password = String(data.password || data.mdp || "");
  const role = normalizeUserRole(data.role || (data.admin ? "org_admin" : "viewer"), context);
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
    `INSERT INTO utilisateurs (actif, admin, courriel, langue, mot_de_passe, nom, organismeID, prenom, role, utilisateurStatutID)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)`,
    [
      data.actif === false ? 0 : 1,
      role === "org_admin" || role === "saas_admin" ? 1 : 0,
      email,
      data.langue || "en",
      hashPassword(password),
      String(data.nom || "").trim(),
      organizationID(context),
      String(data.prenom || "").trim(),
      role,
    ],
  );

  audit(context, "user.created", "user", result.lastInsertRowid, { email, role });
  markOnboardingTask("users", true, context);
  return listUsers(context).find((user) => user.utilisateurID === result.lastInsertRowid);
}

function updateUser(id, data, context = {}) {
  const email = String(data.courriel || data.email || "").trim().toLowerCase();
  const userId = Number(id);
  const role = normalizeUserRole(data.role || (data.admin ? "org_admin" : "viewer"), context);

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
     SET admin = ?, courriel = ?, langue = ?, nom = ?, prenom = ?, role = ?
     WHERE utilisateurID = ? AND organismeID = ?`,
    [
      role === "org_admin" || role === "saas_admin" ? 1 : 0,
      email,
      data.langue || "en",
      String(data.nom || "").trim(),
      String(data.prenom || "").trim(),
      role,
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
  audit(context, "user.updated", "user", userId, { email, role });
  return updatedUser;
}

function updateUserStatus(id, data, context = {}) {
  const existingUser = listUsers(context).find((user) => user.utilisateurID === Number(id));
  const role = normalizeUserRole(data.role || existingUser?.role || (data.admin ? "org_admin" : "viewer"), context);
  run(
    "UPDATE utilisateurs SET actif = ?, admin = ?, role = ? WHERE utilisateurID = ? AND organismeID = ?",
    [data.actif === false ? 0 : 1, role === "org_admin" || role === "saas_admin" ? 1 : 0, role, Number(id), organizationID(context)],
  );
  audit(context, data.actif === false ? "user.deactivated" : "user.activated", "user", id);
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

  audit(context, "organization.updated", "organization", organizationID(context));
  markOnboardingTask("profile", true, context);
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

  audit(context, "banking_connection.created", "banking_connection", result.lastInsertRowid, {
    institution: data.institution,
    category: data.category || "bank",
  });
  return listBankingConnections(context).find((connection) => connection.connectionID === result.lastInsertRowid);
}

function deleteBankingConnection(id, context = {}) {
  run(
    "DELETE FROM banking_connections WHERE connectionID = ? AND organismeID = ?",
    [Number(id), organizationID(context)],
  );
  audit(context, "banking_connection.deleted", "banking_connection", id);
  return { ok: true };
}

const accountingProviderDefaults = {
  quickbooks: {
    displayName: "QuickBooks Online",
    scopes: ["com.intuit.quickbooks.accounting"],
  },
  xero: {
    displayName: "Xero Accounting",
    scopes: ["offline_access", "accounting.invoices", "accounting.payments", "accounting.banktransactions", "accounting.manualjournals"],
  },
};

function normalizeAccountingIntegration(row) {
  return {
    id: `accounting-${row.integrationID}`,
    integrationID: row.integrationID,
    provider: row.provider,
    displayName: row.displayName,
    status: row.status || "ready",
    scopes: JSON.parse(row.scopes || "[]"),
    realmOrTenantId: row.realmOrTenantId || "",
    syncMode: row.syncMode || "donations",
    lastSyncAt: row.lastSyncAt || "",
  };
}

function listAccountingIntegrations(context = {}) {
  return all(
    `SELECT integrationID, provider, displayName, status, scopes, realmOrTenantId, syncMode, lastSyncAt
     FROM accounting_integrations
     WHERE organismeID = ?
     ORDER BY integrationID`,
    [organizationID(context)],
  ).map(normalizeAccountingIntegration);
}

function createAccountingIntegration(data, context = {}) {
  const provider = String(data.provider || "").trim().toLowerCase();
  const defaults = accountingProviderDefaults[provider];
  if (!defaults) {
    const error = new Error("Unsupported accounting provider");
    error.status = 400;
    throw error;
  }

  const scopes = Array.isArray(data.scopes) && data.scopes.length ? data.scopes : defaults.scopes;
  const result = run(
    `INSERT INTO accounting_integrations (
      organismeID, provider, displayName, status, scopes, realmOrTenantId, syncMode
    ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [
      organizationID(context),
      provider,
      String(data.displayName || defaults.displayName).trim(),
      data.status || "ready",
      JSON.stringify(scopes),
      data.realmOrTenantId || "",
      data.syncMode || "donations",
    ],
  );

  audit(context, "accounting_integration.created", "accounting_integration", result.lastInsertRowid, { provider });
  return listAccountingIntegrations(context).find((integration) => integration.integrationID === result.lastInsertRowid);
}

function deleteAccountingIntegration(id, context = {}) {
  run(
    "DELETE FROM accounting_integrations WHERE integrationID = ? AND organismeID = ?",
    [Number(id), organizationID(context)],
  );
  audit(context, "accounting_integration.deleted", "accounting_integration", id);
  return { ok: true };
}

function syncAccountingIntegration(id, context = {}) {
  const integration = get(
    `SELECT integrationID, provider, displayName, status, scopes, realmOrTenantId, syncMode, lastSyncAt
     FROM accounting_integrations
     WHERE integrationID = ? AND organismeID = ?`,
    [Number(id), organizationID(context)],
  );

  if (!integration) {
    const error = new Error("Accounting integration not found");
    error.status = 404;
    throw error;
  }

  const donations = listDonations({ limit: 1000 }, context);
  const payload = donations.map((donation) => ({
    donationID: donation.donID,
    date: donation.dateDon,
    donor: donation.donorName,
    account: `${donation.noCompte} - ${donation.libelleCompte}`,
    amount: donation.montant,
    description: donation.description || "",
    method: donation.methode_en || donation.methode_fr || "",
  }));
  const lastSyncAt = new Date().toISOString();

  run(
    "UPDATE accounting_integrations SET status = 'synced', lastSyncAt = ? WHERE integrationID = ? AND organismeID = ?",
    [lastSyncAt, Number(id), organizationID(context)],
  );

  audit(context, "accounting_integration.synced", "accounting_integration", id, { syncedAt: lastSyncAt });
  return {
    integration: normalizeAccountingIntegration({ ...integration, status: "synced", lastSyncAt }),
    syncedCount: payload.length,
    total: payload.reduce((sum, donation) => sum + Number(donation.amount || 0), 0),
    payloadType: integration.provider === "quickbooks" ? "quickbooks-donation-export" : "xero-donation-export",
    payload,
  };
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

  audit(context, "report_template.created", "report_template", result.lastInsertRowid, { title });
  return listReportTemplates(context).find((template) => template.templateID === result.lastInsertRowid);
}

function deleteReportTemplate(id, context = {}) {
  run(
    "DELETE FROM report_templates WHERE templateID = ? AND organismeID = ?",
    [Number(id), organizationID(context)],
  );
  audit(context, "report_template.deleted", "report_template", id);
  return { ok: true };
}

function getBootstrap(context = {}) {
  ensureSaasDefaults(organizationID(context));
  const organisme = getOrganization(context);
  const user = get("SELECT utilisateurID, admin, courriel, langue, nom, prenom, role, organismeID FROM utilisateurs WHERE utilisateurID = ?", [context.utilisateurID]);
  const provinces = all("SELECT provinceID, pays_en, pays_fr, provinceEtat_en, provinceEtat_fr, abreviation FROM provinces ORDER BY ordre, provinceEtat_en");
  const methods = all("SELECT methodeDonID, methode_fr, methode_en, methode_intuit, ordre FROM methodesDon ORDER BY ordre");

  return {
    organisme,
    user: sanitizeUser({ ...user, organisme: context.organisme, devise: context.devise }),
    users: listUsers(context),
    roleDefinitions,
    roleOptions: context.role === "saas_admin" ? platformRoleOrder : tenantRoleOrder,
    provinces,
    methods,
    bankingConnections: listBankingConnections(context),
    accountingIntegrations: listAccountingIntegrations(context),
    reportTemplates: listReportTemplates(context),
    saas: getSaasOverview(context),
    platformTenants: context.role === "saas_admin" ? listPlatformTenants(context) : [],
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

  audit(context, "donor.created", "donor", result.lastInsertRowid, { numero });
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

  audit(context, "donor.updated", "donor", id, { numero: data.numero });
  return getDonor(id, context);
}

function archiveDonor(id, actif, context = {}) {
  run("UPDATE donateurs SET actif = ? WHERE donateurID = ? AND organismeID = ?", [bool(actif), Number(id), organizationID(context)]);
  audit(context, actif ? "donor.reactivated" : "donor.archived", "donor", id);
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
  audit(context, "donor.deleted", "donor", donorID, { numero: donor.numero });
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
  audit(context, "account.created", "account", result.lastInsertRowid, { noCompte, nom });
  markOnboardingTask("accounts", true, context);
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
  audit(context, "account.updated", "account", id, { noCompte, nom });
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
  audit(context, "account.deleted", "account", id);
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

  audit(context, "donation.created", "donation", result.lastInsertRowid, { amount: Number(data.montant) });
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

  audit(context, "donation.updated", "donation", id, { amount: Number(data.montant) });
  return listDonations({ limit: 500 }, context).find((donation) => donation.donID === Number(id));
}

function deleteDonation(id, context = {}) {
  run(
    `DELETE FROM dons
     WHERE donID = ?
       AND donateurID IN (SELECT donateurID FROM donateurs WHERE organismeID = ?)`,
    [Number(id), organizationID(context)],
  );
  audit(context, "donation.deleted", "donation", id);
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

    audit(context, "receipts.generated", "receipt_batch", code, { dateDebut, dateFin, count: created.length, mode });
    if (created.length) {
      markOnboardingTask("receipts", true, context);
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
  roleDefinitions,
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
  listAccountingIntegrations,
  createAccountingIntegration,
  deleteAccountingIntegration,
  syncAccountingIntegration,
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
  listSaasPlans,
  listPlatformTenants,
  getSubscription,
  updateSubscription,
  getUsage,
  getSaasOverview,
  listPaymentMethods,
  createPaymentMethod,
  deletePaymentMethod,
  listInvoices,
  listAuditEvents,
  listApiKeys,
  createApiKey,
  revokeApiKey,
  listWebhooks,
  createWebhook,
  deleteWebhook,
  testWebhook,
  listOnboardingTasks,
  markOnboardingTask,
  getSecuritySettings,
  updateSecuritySettings,
};
