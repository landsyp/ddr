import { useEffect, useMemo, useState } from "react";
import {
  BarChart3,
  Bell,
  BookOpenCheck,
  Building2,
  Check,
  ChevronDown,
  CircleDollarSign,
  ClipboardList,
  Download,
  FileCheck2,
  FileText,
  HelpCircle,
  LayoutDashboard,
  LockKeyhole,
  Mail,
  Menu,
  Plus,
  Printer,
  ReceiptText,
  Search,
  Settings,
  Trash2,
  UserPlus,
  Users,
  X,
} from "lucide-react";
import brandLogo from "../images/CQOC-DDR2_vert.png";
import whiteLogo from "../images/DDR2_blanc.png";
import brochureImage from "../images/depliant.png";
import receiptImage from "../images/recu.png";

const copy = {
  en: {
    product: "DDR2",
    organization: "Quebec Council of Christian Charities",
    nav: {
      overview: "Overview",
      donations: "Donations",
      donors: "Donors",
      accounts: "Accounts",
      receipts: "Receipts",
      reports: "Reports",
      subscription: "Subscription",
    },
    overview: {
      eyebrow: "Operations dashboard",
      title: "Donation, donor, and receipt work in one secure workspace.",
      subtitle:
        "A local SQLite-backed DDR workspace for charities that need accurate giving records, CRA-ready receipts, and fast yearly reporting.",
      search: "Search donor, receipt, account, or gift",
      period: "Fiscal year 2026",
      quickActions: "Quick actions",
      recentDonations: "Recent donations",
      monthlyIncome: "Monthly income",
      receiptReadiness: "Receipt readiness",
      loginTitle: "Secure portal access",
      loginHelp: "Use your organization email to access the workspace.",
      forgot: "Forgot password",
    },
    actions: ["Add donation", "Add donor", "Generate receipts", "Export report"],
    metrics: ["YTD donations", "Receipts", "Active donors", "Pending receipts"],
    donorForm: {
      title: "Add donor",
      success: "Donor saved.",
    },
    donationForm: {
      title: "Record a donation",
      donor: "Donor",
      account: "Account",
      amount: "Amount",
      date: "Date",
      method: "Method",
      description: "Description",
      add: "Add donation",
      success: "Donation added to the register.",
    },
    accounts: {
      title: "Chart of accounts",
      subtitle: "Accounts control how donations are grouped and whether they are receipt eligible.",
      success: "Account saved.",
    },
    donorDirectory: "Donor directory",
    receipts: {
      title: "Receipt center",
      subtitle:
        "Generate official receipt batches from eligible donors and receiptable accounts for a selected period.",
      batch: "Current batch",
      review: "Review required",
      ready: "Ready to issue",
      print: "Print batch",
      email: "Email batch",
      generated: "Receipt batch generated.",
    },
    reports: {
      title: "Reports",
      subtitle: "Build donor, donation, receipt, and account reports from the SQLite database.",
      run: "Run report",
      export: "Export",
    },
    subscription: {
      title: "Subscription request",
      subtitle:
        "Request access for a charity and store the request in SQLite for CQOC follow-up.",
      pricing: "Annual plans",
      submit: "Submit request",
      success: "Subscription request saved.",
      securityError: "The security answer must be 70.",
    },
    settings: {
      title: "Organization settings",
      subtitle: "Update the charity profile fields used for receipts, replies, and deposit slips.",
      profile: "Charity profile",
      users: "Users",
      save: "Update profile",
      saved: "Organization profile updated.",
    },
    support: {
      title: "Support and tutorials",
      subtitle: "The original DDR tutorials are mapped to the working React screens.",
      setup: "How to set up DDR2",
      account: "Add an account",
      donor: "Add a donor",
      donation: "Add a gift",
      report: "Produce reports",
      receipt: "Produce receipts",
      helpText: "Need a hand? Use these shortcuts or contact CQOC for account support.",
    },
    alerts: {
      none: "No pending alerts. Receipt and donation data are current.",
      forgot: "If this email is active, reset instructions will be sent by the DDR administrator.",
    },
    footer: "Suite 106, 5425 Boulevard Laurier O, Saint-Hyacinthe, QC J2S 3V6",
  },
  fr: {
    product: "DDR2",
    organization: "Conseil Quebecois des Organismes Chretiens",
    nav: {
      overview: "Accueil",
      donations: "Dons",
      donors: "Donateurs",
      accounts: "Comptes",
      receipts: "Recus",
      reports: "Rapports",
      subscription: "Abonnement",
    },
    overview: {
      eyebrow: "Tableau de bord",
      title: "Dons, donateurs et recus dans un espace de travail securise.",
      subtitle:
        "Un espace DDR local avec SQLite pour garder des registres fiables, produire les recus et sortir les rapports rapidement.",
      search: "Rechercher donateur, recu, compte ou don",
      period: "Annee fiscale 2026",
      quickActions: "Actions rapides",
      recentDonations: "Dons recents",
      monthlyIncome: "Revenus mensuels",
      receiptReadiness: "Preparation des recus",
      loginTitle: "Acces securise",
      loginHelp: "Utilisez le courriel de votre organisme.",
      forgot: "Mot de passe oublie",
    },
    actions: ["Ajouter un don", "Ajouter un donateur", "Generer les recus", "Exporter un rapport"],
    metrics: ["Dons annuels", "Recus", "Donateurs actifs", "Recus en attente"],
    donorForm: {
      title: "Ajouter un donateur",
      success: "Donateur enregistre.",
    },
    donationForm: {
      title: "Enregistrer un don",
      donor: "Donateur",
      account: "Compte",
      amount: "Montant",
      date: "Date",
      method: "Methode",
      description: "Description",
      add: "Ajouter le don",
      success: "Le don a ete ajoute au registre.",
    },
    accounts: {
      title: "Plan comptable",
      subtitle: "Les comptes classent les dons et determinent s'ils sont admissibles aux recus.",
      success: "Compte enregistre.",
    },
    donorDirectory: "Repertoire des donateurs",
    receipts: {
      title: "Centre des recus",
      subtitle:
        "Generez les lots de recus officiels a partir des donateurs et comptes admissibles pour une periode.",
      batch: "Lot courant",
      review: "Revision requise",
      ready: "Pret a emettre",
      print: "Imprimer le lot",
      email: "Envoyer par courriel",
      generated: "Lot de recus genere.",
    },
    reports: {
      title: "Rapports",
      subtitle: "Produisez les rapports de dons, donateurs, recus et comptes depuis SQLite.",
      run: "Lancer",
      export: "Exporter",
    },
    subscription: {
      title: "Demande d'abonnement",
      subtitle:
        "Enregistrez une demande d'acces pour un organisme dans SQLite pour le suivi CQOC.",
      pricing: "Forfaits annuels",
      submit: "Envoyer la demande",
      success: "Demande d'abonnement enregistree.",
      securityError: "La reponse de securite doit etre 70.",
    },
    settings: {
      title: "Parametres de l'organisme",
      subtitle: "Mettez a jour les champs utilises pour les recus, les reponses et les depots.",
      profile: "Profil de l'organisme",
      users: "Utilisateurs",
      save: "Mettre a jour le profil",
      saved: "Profil de l'organisme mis a jour.",
    },
    support: {
      title: "Support et tutoriels",
      subtitle: "Les tutoriels DDR originaux sont relies aux ecrans React fonctionnels.",
      setup: "Configurer DDR2",
      account: "Ajouter un compte",
      donor: "Ajouter un donateur",
      donation: "Ajouter un don",
      report: "Produire des rapports",
      receipt: "Produire des recus",
      helpText: "Besoin d'aide? Utilisez ces raccourcis ou contactez le CQOC pour le soutien.",
    },
    alerts: {
      none: "Aucune alerte en attente. Les dons et recus sont a jour.",
      forgot: "Si ce courriel est actif, les instructions seront envoyees par l'administrateur DDR.",
    },
    footer: "Suite 106, 5425 Boulevard Laurier O, Saint-Hyacinthe, QC J2S 3V6",
  },
};

const navItems = [
  { id: "overview", icon: LayoutDashboard },
  { id: "donations", icon: CircleDollarSign },
  { id: "donors", icon: Users },
  { id: "accounts", icon: ClipboardList },
  { id: "receipts", icon: ReceiptText },
  { id: "reports", icon: BarChart3 },
  { id: "subscription", icon: Building2 },
];

const defaultReceiptPeriod = {
  dateDebut: "2026-01-01",
  dateFin: "2026-12-31",
};

async function api(path, options = {}) {
  const response = await fetch(path, {
    headers: { "Content-Type": "application/json", ...(options.headers || {}) },
    ...options,
  });

  const text = await response.text();
  const data = text ? JSON.parse(text) : null;

  if (!response.ok) {
    throw new Error(data?.error || "Request failed");
  }

  return data;
}

function formObject(form) {
  return Object.fromEntries(new FormData(form).entries());
}

function focusTarget(id) {
  const element = document.getElementById(id);
  if (!element) {
    return;
  }

  element.scrollIntoView({ behavior: "smooth", block: "start" });
  window.setTimeout(() => {
    element.querySelector("input, select, textarea, button")?.focus();
  }, 180);
}

function App() {
  const [language, setLanguage] = useState("en");
  const [activeView, setActiveView] = useState("overview");
  const [mobileOpen, setMobileOpen] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [currentUser, setCurrentUser] = useState(() => {
    const saved = localStorage.getItem("ddr-user");
    return saved ? JSON.parse(saved) : null;
  });
  const [bootstrap, setBootstrap] = useState(null);
  const [dashboard, setDashboard] = useState(null);
  const [donors, setDonors] = useState([]);
  const [accounts, setAccounts] = useState([]);
  const [donations, setDonations] = useState([]);
  const [receipts, setReceipts] = useState([]);
  const [receiptBatches, setReceiptBatches] = useState([]);
  const [reportResult, setReportResult] = useState(null);
  const [query, setQuery] = useState("");
  const [member, setMember] = useState(false);
  const [subscriptionAnswer, setSubscriptionAnswer] = useState("");
  const t = copy[language];

  async function loadWorkspace(search = query) {
    setLoading(true);
    const [bootstrapData, dashboardData, donorData, accountData, donationData, receiptData, batchData] =
      await Promise.all([
        api("/api/bootstrap"),
        api("/api/dashboard"),
        api(`/api/donors?search=${encodeURIComponent(search)}`),
        api("/api/accounts"),
        api("/api/donations?limit=500"),
        api("/api/receipts"),
        api("/api/receipt-batches"),
      ]);

    setBootstrap(bootstrapData);
    setDashboard(dashboardData);
    setDonors(donorData);
    setAccounts(accountData);
    setDonations(donationData);
    setReceipts(receiptData);
    setReceiptBatches(batchData);
    setLoading(false);
  }

  useEffect(() => {
    loadWorkspace().catch((loadError) => {
      setError(loadError.message);
      setLoading(false);
    });
  }, []);

  async function refresh(message) {
    await loadWorkspace();
    if (message) {
      showNotice(message);
    }
  }

  function showNotice(message) {
    setError("");
    setNotice(message);
    window.setTimeout(() => setNotice(""), 2800);
  }

  function showError(message) {
    setNotice("");
    setError(message);
    window.setTimeout(() => setError(""), 4200);
  }

  async function handleLogin(event) {
    event.preventDefault();
    try {
      const body = formObject(event.currentTarget);
      const result = await api("/api/auth/login", {
        method: "POST",
        body: JSON.stringify(body),
      });
      setCurrentUser(result.user);
      setLanguage(result.user.langue || "en");
      localStorage.setItem("ddr-user", JSON.stringify(result.user));
      showNotice("Logged in.");
    } catch (loginError) {
      showError(loginError.message);
    }
  }

  async function handleForgotPassword(email) {
    const result = await api("/api/auth/forgot-password", {
      method: "POST",
      body: JSON.stringify({ email }),
    });
    return result.message || t.alerts.forgot;
  }

  function logout() {
    localStorage.removeItem("ddr-user");
    setCurrentUser(null);
    setActiveView("overview");
    setQuery("");
  }

  async function handleAddDonor(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/donors", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          membre: data.membre === "on",
          recu: data.recu !== "off",
        }),
      });
      event.currentTarget.reset();
      await refresh(t.donorForm.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function archiveDonor(donor, actif) {
    try {
      await api(`/api/donors/${donor.donateurID}/archive`, {
        method: "PATCH",
        body: JSON.stringify({ actif }),
      });
      await refresh(actif ? "Donor reactivated." : "Donor archived.");
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleAddAccount(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/accounts", {
        method: "POST",
        body: JSON.stringify({ ...data, recu: data.recu === "on" }),
      });
      event.currentTarget.reset();
      await refresh(t.accounts.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function toggleAccount(account) {
    try {
      await api(`/api/accounts/${account.compteID}`, {
        method: "PUT",
        body: JSON.stringify({ ...account, recu: !account.recu }),
      });
      await refresh(t.accounts.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function deleteAccount(account) {
    if (!window.confirm(`Delete account ${account.noCompte} - ${account.nom}?`)) {
      return;
    }

    try {
      await api(`/api/accounts/${account.compteID}`, { method: "DELETE" });
      await refresh("Account deleted.");
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleAddDonation(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/donations", {
        method: "POST",
        body: JSON.stringify(data),
      });
      event.currentTarget.reset();
      await refresh(t.donationForm.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function deleteDonation(donation) {
    if (!window.confirm(`Delete donation ${donation.donID} from ${donation.donorName}?`)) {
      return;
    }

    try {
      await api(`/api/donations/${donation.donID}`, { method: "DELETE" });
      await refresh("Donation deleted.");
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleGenerateReceipts(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const result = await api("/api/receipts/generate", {
        method: "POST",
        body: JSON.stringify(data),
      });
      await refresh(`${t.receipts.generated} ${result.count} created.`);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function markEnvoi(envoiID, statut) {
    try {
      await api(`/api/envois/${envoiID}/status`, {
        method: "PATCH",
        body: JSON.stringify({ statut }),
      });
      await refresh("Receipt status updated.");
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleRunReport(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const params = new URLSearchParams(data);
      const result = await api(`/api/reports?${params.toString()}`);
      setReportResult({ type: data.type, ...result });
      showNotice("Report refreshed.");
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleSubscription(event) {
    event.preventDefault();

    if (subscriptionAnswer.trim() !== "70") {
      showError(t.subscription.securityError);
      return;
    }

    try {
      const data = formObject(event.currentTarget);
      await api("/api/subscription-requests", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          membre: member,
          langue: language,
        }),
      });
      event.currentTarget.reset();
      setMember(false);
      setSubscriptionAnswer("");
      showNotice(t.subscription.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleUpdateOrganization(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/organization", {
        method: "PUT",
        body: JSON.stringify({
          ...data,
          actif: data.actif === "on",
          membre: data.membre === "on",
        }),
      });
      await refresh(t.settings.saved);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleSearch(event) {
    const value = event.target.value;
    setQuery(value);
    try {
      const term = value.trim().toLowerCase();
      const [donorData, donationData, accountData, receiptData] = await Promise.all([
        api(`/api/donors?search=${encodeURIComponent(value)}`),
        api(`/api/donations?search=${encodeURIComponent(value)}&limit=500`),
        api("/api/accounts"),
        api("/api/receipts"),
      ]);

      setDonors(donorData);
      setDonations(donationData);
      setAccounts(activeView === "accounts" && term ? accountData.filter((account) => `${account.noCompte} ${account.nom}`.toLowerCase().includes(term)) : accountData);
      setReceipts(activeView === "receipts" && term
        ? receiptData.filter((receipt) => `${receipt.noRecu || receipt.recuID} ${receipt.prenom} ${receipt.nom} ${receipt.statut} ${receipt.dateDebut} ${receipt.dateFin}`.toLowerCase().includes(term))
        : receiptData);
    } catch (searchError) {
      showError(searchError.message);
    }
  }

  function openView(view) {
    setActiveView(view);
    setMobileOpen(false);
  }

  const activeOrg = bootstrap?.organisme;
  const displayUser = currentUser || bootstrap?.user;

  if (!currentUser) {
    return (
      <LoginScreen
        error={error}
        language={language}
        onForgotPassword={handleForgotPassword}
        onLanguageChange={setLanguage}
        onLogin={handleLogin}
        t={t}
      />
    );
  }

  return (
    <div className="app-shell">
      <aside className={`sidebar ${mobileOpen ? "is-open" : ""}`}>
        <div className="brand">
          <img src={brandLogo} alt="DDR2" />
          <button className="icon-button mobile-close" type="button" onClick={() => setMobileOpen(false)} aria-label="Close menu">
            <X size={18} />
          </button>
        </div>

        <div className="tenant-card">
          <Building2 size={18} />
          <div>
            <span>{activeOrg?.organisme || displayUser?.organisme || "DDR"}</span>
            <small>{t.overview.period}</small>
          </div>
        </div>

        <nav className="sidebar-nav" aria-label="Primary">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                className={activeView === item.id ? "active" : ""}
                key={item.id}
                type="button"
                onClick={() => openView(item.id)}
              >
                <Icon size={18} />
                <span>{t.nav[item.id]}</span>
              </button>
            );
          })}
        </nav>

        <div className="sidebar-footer">
          <button className={activeView === "support" ? "ghost-button active" : "ghost-button"} type="button" onClick={() => openView("support")}>
            <HelpCircle size={16} />
            <span>Support</span>
          </button>
          <button className={activeView === "settings" ? "ghost-button active" : "ghost-button"} type="button" onClick={() => openView("settings")}>
            <Settings size={16} />
            <span>Settings</span>
          </button>
          <button className="ghost-button" type="button" onClick={logout}>
            <LockKeyhole size={16} />
            <span>Logout</span>
          </button>
        </div>
      </aside>

      <main className="workspace">
        <Topbar
          language={language}
          onLanguageChange={setLanguage}
          onMenuClick={() => setMobileOpen(true)}
          onNotifications={() => showNotice(t.alerts.none)}
          onProfileClick={() => openView("settings")}
          onSearch={handleSearch}
          query={query}
          t={t}
          user={displayUser}
        />

        {notice && (
          <div className="toast success" role="status">
            <Check size={18} />
            <span>{notice}</span>
          </div>
        )}

        {error && (
          <div className="toast error" role="alert">
            <X size={18} />
            <span>{error}</span>
          </div>
        )}

        {loading && <div className="loading-state">Loading DDR data...</div>}

        {!loading && activeView === "overview" && (
          <Overview
            accounts={accounts}
            dashboard={dashboard}
            donations={donations}
            t={t}
            onViewChange={openView}
          />
        )}
        {!loading && activeView === "donations" && (
          <Donations
            accounts={accounts}
            bootstrap={bootstrap}
            donations={donations}
            donors={donors}
            t={t}
            onDelete={deleteDonation}
            onSubmit={handleAddDonation}
          />
        )}
        {!loading && activeView === "donors" && (
          <Donors
            bootstrap={bootstrap}
            donors={donors}
            query={query}
            setQuery={setQuery}
            t={t}
            onArchive={archiveDonor}
            onSearch={handleSearch}
            onSubmit={handleAddDonor}
          />
        )}
        {!loading && activeView === "accounts" && (
          <Accounts
            accounts={accounts}
            t={t}
            onDelete={deleteAccount}
            onSubmit={handleAddAccount}
            onToggle={toggleAccount}
          />
        )}
        {!loading && activeView === "receipts" && (
          <Receipts
            batches={receiptBatches}
            dashboard={dashboard}
            donations={donations}
            receipts={receipts}
            t={t}
            onGenerate={handleGenerateReceipts}
            onMark={markEnvoi}
          />
        )}
        {!loading && activeView === "reports" && (
          <Reports
            reportResult={reportResult}
            t={t}
            onRunReport={handleRunReport}
          />
        )}
        {!loading && activeView === "subscription" && (
          <Subscription
            member={member}
            setMember={setMember}
            subscriptionAnswer={subscriptionAnswer}
            setSubscriptionAnswer={setSubscriptionAnswer}
            t={t}
            onSubmit={handleSubscription}
          />
        )}
        {!loading && activeView === "settings" && (
          <SettingsView
            bootstrap={bootstrap}
            t={t}
            user={displayUser}
            onSubmit={handleUpdateOrganization}
          />
        )}
        {!loading && activeView === "support" && (
          <SupportView
            t={t}
            onViewChange={openView}
          />
        )}
      </main>
    </div>
  );
}

function LoginScreen({ error, language, onForgotPassword, onLanguageChange, onLogin, t }) {
  const [forgotOpen, setForgotOpen] = useState(false);
  const [forgotEmail, setForgotEmail] = useState("admin@ddr.local");
  const [forgotStatus, setForgotStatus] = useState("");

  async function submitForgotPassword() {
    setForgotStatus("");
    try {
      const message = await onForgotPassword(forgotEmail);
      setForgotStatus(message);
    } catch (forgotError) {
      setForgotStatus(forgotError.message);
    }
  }

  return (
    <main className="login-screen">
      <section className="intro-band login-shell">
        <div className="intro-copy">
          <span className="eyebrow">{t.overview.eyebrow}</span>
          <h1>{t.overview.title}</h1>
          <p>{t.overview.subtitle}</p>
          <div className="login-facts">
            <span><Check size={16} /> SQLite persistence</span>
            <span><Check size={16} /> Donors and gifts</span>
            <span><Check size={16} /> Receipt batches</span>
          </div>
        </div>

        <form className="login-panel" onSubmit={onLogin}>
          <img src={whiteLogo} alt="DDR2" />
          <div className="login-panel-title">
            <h2>{t.overview.loginTitle}</h2>
            <button className="language-toggle dark" type="button" onClick={() => onLanguageChange(language === "en" ? "fr" : "en")}>
              {language === "en" ? "FR" : "EN"}
            </button>
          </div>
          <p>{t.overview.loginHelp}</p>
          {error && <div className="inline-error">{error}</div>}
          <label>
            Email
            <input name="email" type="email" defaultValue="admin@ddr.local" required />
          </label>
          <label>
            Password
            <input name="password" type="password" defaultValue="password" required />
          </label>
          <button className="light-button" type="submit">
            <LockKeyhole size={16} />
            <span>Log in</span>
          </button>
          <button className="link-button light-link" type="button" onClick={() => setForgotOpen((open) => !open)}>
            {t.overview.forgot}
          </button>
          {forgotOpen && (
            <div className="forgot-form">
              <label>
                Email
                <input name="forgotEmail" type="email" value={forgotEmail} onChange={(event) => setForgotEmail(event.target.value)} required />
              </label>
              <button className="light-button" type="button" onClick={submitForgotPassword}>
                <Mail size={16} />
                <span>Send reset</span>
              </button>
              {forgotStatus && <div className="inline-hint">{forgotStatus}</div>}
            </div>
          )}
        </form>
      </section>
    </main>
  );
}

function Topbar({ language, onLanguageChange, onMenuClick, onNotifications, onProfileClick, onSearch, query, t, user }) {
  return (
    <header className="topbar">
      <button className="icon-button menu-button" type="button" onClick={onMenuClick} aria-label="Open menu">
        <Menu size={20} />
      </button>

      <div className="search-box">
        <Search size={17} />
        <input type="search" value={query} onChange={onSearch} placeholder={t.overview.search} />
      </div>

      <div className="topbar-actions">
        <button className="language-toggle" type="button" onClick={() => onLanguageChange(language === "en" ? "fr" : "en")}>
          {language === "en" ? "FR" : "EN"}
        </button>
        <button className="icon-button" type="button" aria-label="Notifications" onClick={onNotifications}>
          <Bell size={18} />
        </button>
        <button className="profile-chip" type="button" onClick={onProfileClick} aria-label="Open organization settings">
          <span>{initials(user)}</span>
          <div>
            <strong>{user?.prenom || "Admin"}</strong>
            <small>{user?.admin ? "Admin" : "User"}</small>
          </div>
          <ChevronDown size={16} />
        </button>
      </div>
    </header>
  );
}

function Overview({ accounts, dashboard, donations, t, onViewChange }) {
  const totals = dashboard?.totals || {};
  const metrics = [
    { label: t.metrics[0], value: currency(totals.ytdDonations || 0), trend: "SQLite", tone: "green" },
    { label: t.metrics[1], value: String(totals.receiptCount || 0), trend: currency(totals.receiptableTotal || 0), tone: "blue" },
    { label: t.metrics[2], value: String(totals.activeDonors || 0), trend: "Active", tone: "amber" },
    { label: t.metrics[3], value: String(totals.pendingReceipts || 0), trend: "Ready", tone: "red" },
  ];
  const monthly = dashboard?.monthly || [];
  const maxMonth = Math.max(...monthly.map((item) => item.amount), 1);
  const readyPercent = totals.pendingReceipts ? Math.max(0, Math.round(((donations.length - totals.pendingReceipts) / donations.length) * 100)) : 100;

  return (
    <section className="view-stack">
      <div className="intro-band">
        <div className="intro-copy">
          <span className="eyebrow">{t.overview.eyebrow}</span>
          <h1>{t.overview.title}</h1>
          <p>{t.overview.subtitle}</p>
          <div className="intro-actions">
            <button className="primary-button" type="button" onClick={() => onViewChange("donations")}>
              <Plus size={17} />
              <span>{t.actions[0]}</span>
            </button>
            <button className="secondary-button" type="button" onClick={() => onViewChange("receipts")}>
              <ReceiptText size={17} />
              <span>{t.actions[2]}</span>
            </button>
          </div>
        </div>
      </div>

      <div className="metric-grid">
        {metrics.map((metric) => (
          <article className={`metric-card tone-${metric.tone}`} key={metric.label}>
            <span>{metric.label}</span>
            <strong>{metric.value}</strong>
            <small>{metric.trend}</small>
          </article>
        ))}
      </div>

      <div className="two-column">
        <Panel title={t.overview.recentDonations} icon={CircleDollarSign}>
          <DataTable
            columns={["ID", "Donor", "Account", "Amount", "Status"]}
            rows={donations.slice(0, 6).map((donation) => [
              donation.donID,
              donation.donorName,
              `${donation.noCompte} - ${donation.libelleCompte}`,
              currency(donation.montant),
              <StatusPill key={donation.donID} value={donation.receiptStatus} />,
            ])}
          />
        </Panel>

        <Panel title={t.overview.monthlyIncome} icon={BarChart3}>
          <div className="bar-chart">
            {monthly.map((item) => (
              <div className="bar-item" key={item.month}>
                <div className="bar-track">
                  <span style={{ height: `${(item.amount / maxMonth) * 100}%` }} />
                </div>
                <small>{item.month.slice(5)}</small>
              </div>
            ))}
          </div>
        </Panel>
      </div>

      <div className="two-column secondary">
        <Panel title={t.overview.receiptReadiness} icon={FileCheck2}>
          <div className="readiness">
            <div>
              <strong>{readyPercent}%</strong>
              <span>Donation rows already issued or excluded from receipting</span>
            </div>
            <div className="progress"><span style={{ width: `${readyPercent}%` }} /></div>
            <ul>
              <li><Check size={15} /> {accounts.filter((account) => account.recu).length} receiptable accounts</li>
              <li><ClipboardList size={15} /> {totals.pendingReceipts || 0} donations ready for receipts</li>
              <li><BookOpenCheck size={15} /> {totals.receiptCount || 0} receipts stored</li>
            </ul>
          </div>
        </Panel>

        <Panel title={t.overview.quickActions} icon={BookOpenCheck}>
          <div className="action-grid">
            {[
              [Plus, t.actions[0], "donations"],
              [Users, t.actions[1], "donors"],
              [ReceiptText, t.actions[2], "receipts"],
              [Download, t.actions[3], "reports"],
            ].map(([Icon, label, view]) => (
              <button className="quick-action" type="button" key={label} onClick={() => onViewChange(view)}>
                <Icon size={19} />
                <span>{label}</span>
              </button>
            ))}
          </div>
        </Panel>
      </div>
    </section>
  );
}

function Donations({ accounts, bootstrap, donations, donors, t, onDelete, onSubmit }) {
  return (
    <section className="view-stack">
      <ViewHeader
        title={t.nav.donations}
        subtitle="Register gifts, assign accounts, and move receipt status forward."
        action={t.donationForm.add}
        actionTargetId="donation-form"
        icon={CircleDollarSign}
      />

      <div className="two-column form-layout">
        <Panel id="donation-form" title={t.donationForm.title} icon={Plus}>
          <form className="form-grid" onSubmit={onSubmit}>
            <label>
              {t.donationForm.donor}
              <select name="donateurID" required>
                {donors.map((donor) => (
                  <option value={donor.donateurID} key={donor.donateurID}>
                    {donor.numero} - {donor.fullName}
                  </option>
                ))}
              </select>
            </label>
            <label>
              {t.donationForm.account}
              <select name="compteID" required>
                {accounts.map((account) => (
                  <option value={account.compteID} key={account.compteID}>
                    {account.noCompte} - {account.nom}
                  </option>
                ))}
              </select>
            </label>
            <label>
              {t.donationForm.amount}
              <input name="montant" required min="1" step="0.01" type="number" placeholder="125.00" />
            </label>
            <label>
              {t.donationForm.date}
              <input name="dateDon" required type="date" defaultValue="2026-07-06" />
            </label>
            <label>
              {t.donationForm.method}
              <select name="methodeDonID" defaultValue={bootstrap?.methods?.[0]?.methodeDonID || ""}>
                {bootstrap?.methods?.map((method) => (
                  <option value={method.methodeDonID} key={method.methodeDonID}>
                    {method.methode_en}
                  </option>
                ))}
              </select>
            </label>
            <label>
              {t.donationForm.description}
              <input name="description" placeholder="Offering, campaign, batch note" />
            </label>
            <button className="primary-button form-submit" type="submit">
              <Plus size={17} />
              <span>{t.donationForm.add}</span>
            </button>
          </form>
        </Panel>

        <Panel title="Account mix" icon={BarChart3}>
          <div className="account-list">
            {accounts.map((account) => (
              <div className="account-row" key={account.compteID}>
                <span>{account.noCompte} - {account.nom}</span>
                <strong>{currency(account.total || 0)}</strong>
                <div className="progress"><span style={{ width: `${Math.min(100, (account.total || 0) / 20)}%` }} /></div>
              </div>
            ))}
          </div>
        </Panel>
      </div>

      <Panel title="Donation register" icon={FileText}>
        <DataTable
          columns={["ID", "Donor", "Date", "Account", "Method", "Amount", "Status", ""]}
          rows={donations.map((donation) => [
            donation.donID,
            donation.donorName,
            donation.dateDon,
            `${donation.noCompte} - ${donation.libelleCompte}`,
            donation.methode_en || "Unspecified",
            currency(donation.montant),
            <StatusPill key={`status-${donation.donID}`} value={donation.receiptStatus} />,
            <button className="icon-button table-icon" type="button" onClick={() => onDelete(donation)} aria-label="Delete donation" key={`delete-${donation.donID}`}>
              <Trash2 size={15} />
            </button>,
          ])}
        />
      </Panel>
    </section>
  );
}

function Donors({ bootstrap, donors, query, setQuery, t, onArchive, onSearch, onSubmit }) {
  return (
    <section className="view-stack">
      <ViewHeader
        title={t.donorDirectory}
        subtitle="Keep donor contact, giving history, and segmentation ready for receipting."
        action="New donor"
        actionTargetId="donor-form"
        icon={Users}
      />

      <div className="two-column form-layout">
        <Panel id="donor-form" title={t.donorForm.title} icon={UserPlus}>
          <form className="form-grid" onSubmit={onSubmit}>
            <label>
              Number
              <input name="numero" placeholder="Auto if blank" />
            </label>
            <label>
              First name
              <input name="prenom" required />
            </label>
            <label>
              Last name
              <input name="nom" required />
            </label>
            <label>
              Email
              <input name="courriel" type="email" />
            </label>
            <label>
              Address
              <input name="adresse" />
            </label>
            <label>
              City
              <input name="ville" />
            </label>
            <label>
              Postal code
              <input name="code_postal" />
            </label>
            <label>
              Province
              <select name="provinceID" defaultValue="1">
                {bootstrap?.provinces?.map((province) => (
                  <option value={province.provinceID} key={province.provinceID}>
                    {province.abreviation} - {province.provinceEtat_en}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Cell
              <input name="tel_cellulaire" />
            </label>
            <label>
              Residence
              <input name="tel_residence" />
            </label>
            <label className="checkbox-label">
              <input name="membre" type="checkbox" />
              <span>Member</span>
            </label>
            <label className="checkbox-label">
              <input name="recu" type="checkbox" defaultChecked />
              <span>Receipts enabled</span>
            </label>
            <label className="full-field">
              Notes
              <textarea name="notes" rows="3" />
            </label>
            <button className="primary-button form-submit" type="submit">
              <UserPlus size={17} />
              <span>{t.donorForm.title}</span>
            </button>
          </form>
        </Panel>

        <Panel title="Donor totals" icon={BarChart3}>
          <div className="account-list">
            {donors.slice(0, 6).map((donor) => (
              <div className="account-row" key={donor.donateurID}>
                <span>{donor.numero} - {donor.fullName}</span>
                <strong>{currency(donor.totalDonations || 0)}</strong>
                <div className="progress"><span style={{ width: `${Math.min(100, (donor.totalDonations || 0) / 20)}%` }} /></div>
              </div>
            ))}
          </div>
        </Panel>
      </div>

      <Panel title="Directory" icon={Search}>
        <div className="table-toolbar">
          <div className="search-box inline">
            <Search size={17} />
            <input value={query} onChange={(event) => { setQuery(event.target.value); onSearch(event); }} placeholder="Filter donors" />
          </div>
          <button className="secondary-button" type="button" onClick={() => downloadCSV("donors.csv", donors)}>
            <Download size={16} />
            <span>CSV</span>
          </button>
        </div>
        <DataTable
          columns={["No.", "Donor", "Email", "City", "Lifetime", "Last gift", "Receipts", ""]}
          rows={donors.map((donor) => [
            donor.numero,
            donor.fullName,
            donor.courriel || "-",
            donor.ville || "-",
            currency(donor.totalDonations || 0),
            donor.lastGift || "-",
            donor.recu ? "Yes" : "No",
            <button className="secondary-button compact" type="button" onClick={() => onArchive(donor, !donor.actif)} key={`archive-${donor.donateurID}`}>
              {donor.actif ? "Archive" : "Activate"}
            </button>,
          ])}
        />
      </Panel>
    </section>
  );
}

function Accounts({ accounts, t, onDelete, onSubmit, onToggle }) {
  return (
    <section className="view-stack">
      <ViewHeader
        title={t.accounts.title}
        subtitle={t.accounts.subtitle}
        action="Add account"
        actionTargetId="account-form"
        icon={ClipboardList}
      />

      <div className="two-column form-layout">
        <Panel id="account-form" title="Add account" icon={Plus}>
          <form className="form-grid" onSubmit={onSubmit}>
            <label>
              Account number
              <input name="noCompte" required type="number" />
            </label>
            <label>
              Name
              <input name="nom" required />
            </label>
            <label className="checkbox-label">
              <input name="recu" type="checkbox" defaultChecked />
              <span>Eligible for receipts</span>
            </label>
            <button className="primary-button form-submit" type="submit">
              <Plus size={17} />
              <span>Add account</span>
            </button>
          </form>
        </Panel>

        <Panel title="Receipt eligibility" icon={ReceiptText}>
          <div className="readiness">
            <div>
              <strong>{accounts.filter((account) => account.recu).length}</strong>
              <span>Accounts generate official receipt amounts</span>
            </div>
            <div className="progress">
              <span style={{ width: `${accounts.length ? (accounts.filter((account) => account.recu).length / accounts.length) * 100 : 0}%` }} />
            </div>
          </div>
        </Panel>
      </div>

      <Panel title="Accounts" icon={ClipboardList}>
        <DataTable
          columns={["No.", "Name", "Receipts", "Donations", "Total", ""]}
          rows={accounts.map((account) => [
            account.noCompte,
            account.nom,
            <button className="status-pill button-pill" type="button" onClick={() => onToggle(account)} key={`toggle-${account.compteID}`}>
              {account.recu ? "Receiptable" : "No receipt"}
            </button>,
            account.donationCount,
            currency(account.total || 0),
            <button className="icon-button table-icon" type="button" onClick={() => onDelete(account)} aria-label="Delete account" key={`delete-${account.compteID}`}>
              <Trash2 size={15} />
            </button>,
          ])}
        />
      </Panel>
    </section>
  );
}

function Receipts({ batches, dashboard, donations, receipts, t, onGenerate, onMark }) {
  const readyRows = donations.filter((donation) => donation.receiptStatus === "Ready");
  const reviewRows = donations.filter((donation) => donation.receiptStatus === "No receipt");

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.receipts.title}
        subtitle={t.receipts.subtitle}
        action="Generate"
        actionTargetId="receipt-generator"
        icon={ReceiptText}
      />

      <div className="receipt-band">
        <div className="receipt-copy">
          <img src={receiptImage} alt="" />
          <div>
            <span className="eyebrow">{t.receipts.batch}</span>
            <h2>Annual receipt batch</h2>
            <p>{readyRows.length} donation rows are ready and {reviewRows.length} are excluded by donor/account receipt settings.</p>
          </div>
        </div>
        <form id="receipt-generator" className="receipt-actions compact-form" onSubmit={onGenerate}>
          <input name="dateDebut" type="date" defaultValue={defaultReceiptPeriod.dateDebut} aria-label="Start date" />
          <input name="dateFin" type="date" defaultValue={defaultReceiptPeriod.dateFin} aria-label="End date" />
          <select name="mode" defaultValue="email" aria-label="Mode">
            <option value="email">Email</option>
            <option value="print">Print</option>
          </select>
          <button className="primary-button" type="submit">
            <FileCheck2 size={17} />
            <span>Generate</span>
          </button>
        </form>
      </div>

      <div className="metric-grid">
        <article className="metric-card tone-blue">
          <span>Stored receipts</span>
          <strong>{receipts.length}</strong>
          <small>{currency(receipts.reduce((sum, receipt) => sum + receipt.montant, 0))}</small>
        </article>
        <article className="metric-card tone-green">
          <span>Ready gifts</span>
          <strong>{dashboard?.totals?.pendingReceipts || 0}</strong>
          <small>Eligible rows</small>
        </article>
        <article className="metric-card tone-amber">
          <span>Batches</span>
          <strong>{batches.length}</strong>
          <small>Generated</small>
        </article>
        <article className="metric-card tone-red">
          <span>Review</span>
          <strong>{reviewRows.length}</strong>
          <small>Not receiptable</small>
        </article>
      </div>

      <div className="two-column">
        <Panel title="Receipts" icon={Check}>
          <DataTable
            columns={["No.", "Donor", "Period", "Amount", "Status", ""]}
            rows={receipts.map((receipt) => [
              receipt.noRecu || receipt.recuID,
              `${receipt.prenom} ${receipt.nom}`,
              `${receipt.dateDebut} to ${receipt.dateFin}`,
              currency(receipt.montant),
              <StatusPill key={`status-${receipt.recuID}`} value={humanStatus(receipt.statut)} />,
              receipt.envoiID ? (
                <button className="secondary-button compact" type="button" onClick={() => onMark(receipt.envoiID, "2-livre")} key={`mark-${receipt.recuID}`}>
                  Mark sent
                </button>
              ) : "-",
            ])}
          />
        </Panel>

        <Panel title="Batches" icon={Printer}>
          <DataTable
            columns={["Created", "Period", "Count", "Total"]}
            rows={batches.map((batch) => [
              new Date(batch.dateCreation).toLocaleString(),
              `${batch.dateDebut} to ${batch.dateFin}`,
              batch.recusCount,
              currency(batch.total),
            ])}
          />
        </Panel>
      </div>
    </section>
  );
}

function Reports({ reportResult, t, onRunReport }) {
  const summary = reportResult?.summary || [];
  const rows = Array.isArray(reportResult) ? reportResult : reportResult?.rows || reportResult || [];
  const downloadableRows = Array.isArray(rows) ? rows : summary;

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.reports.title}
        subtitle={t.reports.subtitle}
        action={t.reports.run}
        actionTargetId="report-builder"
        icon={BarChart3}
      />

      <Panel id="report-builder" title="Report builder" icon={FileText}>
        <form className="form-grid report-form" onSubmit={onRunReport}>
          <label>
            Report
            <select name="type" defaultValue="donations">
              <option value="donations">Donations</option>
              <option value="donors">Donors</option>
              <option value="accounts">Accounts</option>
              <option value="receipts">Receipts</option>
            </select>
          </label>
          <label>
            Group by
            <select name="groupBy" defaultValue="date">
              <option value="date">Date</option>
              <option value="account">Account</option>
              <option value="donor">Donor</option>
              <option value="method">Method</option>
            </select>
          </label>
          <label>
            Start
            <input name="dateDebut" type="date" defaultValue="2026-01-01" />
          </label>
          <label>
            End
            <input name="dateFin" type="date" defaultValue="2026-12-31" />
          </label>
          <button className="primary-button form-submit" type="submit">
            <BarChart3 size={17} />
            <span>{t.reports.run}</span>
          </button>
          <button className="secondary-button form-submit" type="button" disabled={!downloadableRows.length} onClick={() => downloadCSV("ddr-report.csv", downloadableRows)}>
            <Download size={17} />
            <span>{t.reports.export}</span>
          </button>
        </form>
      </Panel>

      {summary.length > 0 && (
        <Panel title="Summary" icon={BarChart3}>
          <DataTable
            columns={["Group", "Count", "Total"]}
            rows={summary.map((item) => [item.label, item.count, currency(item.total)])}
          />
        </Panel>
      )}

      {Array.isArray(rows) && rows.length > 0 && (
        <Panel title="Rows" icon={ClipboardList}>
          <DataTable
            columns={Object.keys(rows[0]).slice(0, 8)}
            rows={rows.slice(0, 50).map((row) => Object.values(row).slice(0, 8).map(formatCell))}
          />
        </Panel>
      )}
    </section>
  );
}

function Subscription({ member, setMember, subscriptionAnswer, setSubscriptionAnswer, t, onSubmit }) {
  return (
    <section className="view-stack">
      <ViewHeader
        title={t.subscription.title}
        subtitle={t.subscription.subtitle}
        action={t.subscription.submit}
        actionTargetId="subscription-form"
        icon={Building2}
      />

      <div className="two-column form-layout">
        <Panel title={t.subscription.pricing} icon={CircleDollarSign}>
          <div className="pricing-list">
            <PricingCard revenue="0 - $50,000" member="$60/year" nonMember="$70/year" />
            <PricingCard revenue="$50,001 +" member="$70/year" nonMember="$85/year" />
          </div>
          <div className="brochure-strip">
            <img src={brochureImage} alt="" />
            <p>For detailed service information, contact CQOC or review the DDR2 service flyer.</p>
          </div>
        </Panel>

        <Panel id="subscription-form" title={t.subscription.title} icon={ClipboardList}>
          <form className="form-grid subscription-form" onSubmit={onSubmit}>
            <label>
              Charity name
              <input name="organisme" required maxLength="50" />
            </label>
            <label>
              Registration number
              <input name="enregistrement" required maxLength="30" />
            </label>
            <label>
              Person in charge
              <input name="responsable" required maxLength="50" />
            </label>
            <label>
              Email
              <input name="responsable_courriel" required type="email" />
            </label>
            <label>
              Address
              <input name="adresse" />
            </label>
            <label>
              City
              <input name="ville" />
            </label>
            <label>
              Province
              <input name="province" defaultValue="Quebec" />
            </label>
            <label>
              Phone
              <input name="telephone" />
            </label>
            <label className="checkbox-label">
              <input checked={member} onChange={(event) => setMember(event.target.checked)} type="checkbox" />
              <span>CQOC member</span>
            </label>
            {member && (
              <label>
                Member number
                <input name="nomembre" />
              </label>
            )}
            <label>
              Security: 50 + 20
              <input
                required
                value={subscriptionAnswer}
                onChange={(event) => setSubscriptionAnswer(event.target.value)}
                inputMode="numeric"
              />
            </label>
            <button className="primary-button form-submit" type="submit">
              <Mail size={17} />
              <span>{t.subscription.submit}</span>
            </button>
          </form>
        </Panel>
      </div>
    </section>
  );
}

function SettingsView({ bootstrap, t, user, onSubmit }) {
  const organization = bootstrap?.organisme || {};
  const users = bootstrap?.users?.length ? bootstrap.users : [user].filter(Boolean);

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.settings.title}
        subtitle={t.settings.subtitle}
        action={t.settings.save}
        actionTargetId="organization-profile"
        icon={Settings}
      />

      <div className="two-column form-layout">
        <Panel id="organization-profile" title={t.settings.profile} icon={Building2}>
          <form className="form-grid" onSubmit={onSubmit} key={`${organization.organismeID}-${organization.organisme}-${organization.responsable_courriel}`}>
            <label>
              Organization name
              <input name="organisme" required maxLength="150" defaultValue={organization.organisme || ""} />
            </label>
            <label>
              Registration number
              <input name="enregistrement" required maxLength="30" defaultValue={organization.enregistrement || ""} />
            </label>
            <label>
              Contact name
              <input name="responsable" required maxLength="50" defaultValue={organization.responsable || ""} />
            </label>
            <label>
              Contact email
              <input name="responsable_courriel" required type="email" defaultValue={organization.responsable_courriel || ""} />
            </label>
            <label>
              Reply email
              <input name="reponse_courriel" type="email" defaultValue={organization.reponse_courriel || ""} />
            </label>
            <label>
              Phone
              <input name="telephone" maxLength="30" defaultValue={organization.telephone || ""} />
            </label>
            <label className="full-field">
              Address
              <input name="adresse" maxLength="150" defaultValue={organization.adresse || ""} />
            </label>
            <label>
              City
              <input name="ville" required maxLength="50" defaultValue={organization.ville || ""} />
            </label>
            <label>
              Postal code
              <input name="code_postal" maxLength="20" defaultValue={organization.code_postal || ""} />
            </label>
            <label>
              Province
              <select name="provinceID" defaultValue={organization.provinceID || 1}>
                {bootstrap?.provinces?.map((province) => (
                  <option value={province.provinceID} key={province.provinceID}>
                    {province.abreviation} - {province.provinceEtat_en}
                  </option>
                ))}
              </select>
            </label>
            <label>
              Currency
              <input name="devise" readOnly defaultValue={organization.devise || "CAD"} />
            </label>
            <label>
              Transit
              <input name="transit" maxLength="20" defaultValue={organization.transit || ""} />
            </label>
            <label>
              Folio
              <input name="folio" maxLength="30" defaultValue={organization.folio || ""} />
            </label>
            <label className="checkbox-label">
              <input name="membre" type="checkbox" defaultChecked={Boolean(organization.membre)} />
              <span>CQOC member</span>
            </label>
            <label className="checkbox-label">
              <input name="actif" type="checkbox" defaultChecked={organization.actif !== false} />
              <span>Organization active</span>
            </label>
            <button className="primary-button form-submit" type="submit">
              <Settings size={17} />
              <span>{t.settings.save}</span>
            </button>
          </form>
        </Panel>

        <Panel title={t.settings.users} icon={Users}>
          <DataTable
            columns={["Name", "Email", "Language", "Role", "Active"]}
            rows={users.map((account) => [
              `${account.prenom || ""} ${account.nom || ""}`.trim() || "User",
              account.courriel || "-",
              String(account.langue || "en").toUpperCase(),
              account.admin ? "Admin" : "User",
              account.actif === false ? "No" : "Yes",
            ])}
          />
        </Panel>
      </div>
    </section>
  );
}

function SupportView({ t, onViewChange }) {
  const cards = [
    [BookOpenCheck, t.support.setup, "settings"],
    [ClipboardList, t.support.account, "accounts"],
    [Users, t.support.donor, "donors"],
    [Plus, t.support.donation, "donations"],
    [BarChart3, t.support.report, "reports"],
    [ReceiptText, t.support.receipt, "receipts"],
  ];

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.support.title}
        subtitle={t.support.subtitle}
        icon={HelpCircle}
      />

      <Panel title={t.support.title} icon={BookOpenCheck}>
        <p className="panel-copy">{t.support.helpText}</p>
        <div className="action-grid support-grid">
          {cards.map(([Icon, label, view]) => (
            <button className="quick-action" type="button" key={label} onClick={() => onViewChange(view)}>
              <Icon size={19} />
              <span>{label}</span>
            </button>
          ))}
        </div>
      </Panel>

      <Panel title="CQOC" icon={Mail}>
        <div className="support-contact">
          <p>{copy.en.footer}</p>
          <a className="secondary-button" href="mailto:info@cqoc.org">
            <Mail size={16} />
            <span>info@cqoc.org</span>
          </a>
        </div>
      </Panel>
    </section>
  );
}

function ViewHeader({ title, subtitle, action, actionTargetId, icon: Icon, onAction }) {
  const handleAction = onAction || (actionTargetId ? () => focusTarget(actionTargetId) : null);

  return (
    <div className="view-header">
      <div>
        <span className="eyebrow"><Icon size={15} /> DDR2 SaaS</span>
        <h1>{title}</h1>
        <p>{subtitle}</p>
      </div>
      {action && handleAction && (
        <button className="primary-button" type="button" onClick={handleAction}>
          <Plus size={17} />
          <span>{action}</span>
        </button>
      )}
    </div>
  );
}

function Panel({ id, title, icon: Icon, children }) {
  return (
    <section className="panel" id={id}>
      <div className="panel-header">
        <div>
          <Icon size={18} />
          <h2>{title}</h2>
        </div>
      </div>
      {children}
    </section>
  );
}

function DataTable({ columns, rows }) {
  return (
    <div className="table-wrap">
      <table>
        <thead>
          <tr>
            {columns.map((column) => <th key={column}>{column}</th>)}
          </tr>
        </thead>
        <tbody>
          {rows.length === 0 ? (
            <tr>
              <td colSpan={columns.length}>No records found</td>
            </tr>
          ) : (
            rows.map((row, rowIndex) => (
              <tr key={`${rowIndex}-${row[0]}`}>
                {row.map((cell, cellIndex) => <td key={`${rowIndex}-${cellIndex}`}>{cell}</td>)}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}

function StatusPill({ value }) {
  const className = String(value || "").toLowerCase().replace(/\s+/g, "-");
  return <span className={`status-pill ${className}`}>{value}</span>;
}

function PricingCard({ revenue, member, nonMember }) {
  return (
    <article className="pricing-card">
      <span>Annual revenue</span>
      <strong>{revenue}</strong>
      <dl>
        <div>
          <dt>CQOC member</dt>
          <dd>{member}</dd>
        </div>
        <div>
          <dt>Non-member</dt>
          <dd>{nonMember}</dd>
        </div>
      </dl>
    </article>
  );
}

function currency(amount) {
  return new Intl.NumberFormat("en-CA", {
    style: "currency",
    currency: "CAD",
    maximumFractionDigits: 0,
  }).format(Number(amount || 0));
}

function initials(user) {
  const first = user?.prenom?.[0] || "A";
  const last = user?.nom?.[0] || "D";
  return `${first}${last}`.toUpperCase();
}

function humanStatus(status) {
  if (!status) {
    return "Generated";
  }

  if (status === "1-en-cours") {
    return "Queued";
  }
  if (status === "2-livre") {
    return "Delivered";
  }
  if (status === "2-a-imprimer") {
    return "Print";
  }
  if (status === "0-courriel-non-valide") {
    return "Invalid email";
  }

  return status;
}

function formatCell(value) {
  if (typeof value === "boolean") {
    return value ? "Yes" : "No";
  }
  if (value === null || value === undefined) {
    return "-";
  }
  if (typeof value === "number" && String(value).includes(".")) {
    return value.toFixed(2);
  }
  return String(value);
}

function downloadCSV(filename, rows) {
  if (!rows?.length) {
    return;
  }

  const headers = Object.keys(rows[0]);
  const csvRows = [
    headers.join(","),
    ...rows.map((row) => headers.map((header) => csvValue(row[header])).join(",")),
  ];
  const blob = new Blob([csvRows.join("\n")], { type: "text/csv;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}

function csvValue(value) {
  const normalized = value === null || value === undefined ? "" : String(value);
  return `"${normalized.replaceAll('"', '""')}"`;
}

export default App;
