import { Fragment, useEffect, useMemo, useState } from "react";
import {
  BarChart3,
  Bell,
  BookOpenCheck,
  Building2,
  CalendarDays,
  Check,
  CheckCircle2,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  ChevronsUpDown,
  CircleDollarSign,
  ClipboardList,
  CreditCard,
  Download,
  FileCheck2,
  FileSpreadsheet,
  FileText,
  Globe2,
  Maximize2,
  HelpCircle,
  Landmark,
  LayoutDashboard,
  Link2,
  LockKeyhole,
  Mail,
  Menu,
  Minimize2,
  Palette,
  PauseCircle,
  Pencil,
  Plus,
  Printer,
  ReceiptText,
  Search,
  Settings,
  SlidersHorizontal,
  Sparkles,
  Trash2,
  UserPlus,
  Users,
  Wallet,
  X,
} from "lucide-react";
import receiptImage from "../images/recu.png";

const copy = {
  en: {
    locale: "en-CA",
    product: "WeSERVE",
    organization: "WeSERVE",
    nav: {
      overview: "Overview",
      donations: "Donations",
      donors: "Donors",
      accounts: "Accounts",
      receipts: "Receipts",
      reports: "Reports",
      banking: "Connections",
      integrations: "Integrations",
      subscription: "Subscription",
      customization: "Customization",
      tenants: "Tenants",
    },
    overview: {
      eyebrow: "Operations dashboard",
      title: "Donation, donor, and receipt work in one secure workspace.",
      subtitle:
        "A local SQLite-backed WeSERVE workspace for charities that need accurate giving records, CRA-ready receipts, and fast yearly reporting.",
      search: "Search donor, receipt, account, or gift",
      period: "Fiscal year 2026",
      quickActions: "Quick actions",
      recentDonations: "Recent donations",
      monthlyIncome: "Monthly income",
      monthlyGivingSoFar: "Monthly giving so far",
      currentMonth: "This month",
      dayProgress: "Day",
      monthElapsed: "of month elapsed",
      monthlyAverage: "Monthly average",
      annualAverageProgress: "of annual monthly average",
      receiptReadiness: "Receipt readiness",
      loginTitle: "Secure portal access",
      loginHelp: "Use your organization email to access the workspace.",
      forgot: "Forgot password",
      loading: "Loading WeSERVE data...",
      facts: ["WeSERVE SaaS", "Donors and gifts", "Receipt batches"],
      readinessText: "Donation rows already issued or excluded from receipting",
      receiptableAccounts: "receiptable accounts",
      donationsReady: "donations ready for receipts",
      receiptsStored: "receipts stored",
    },
    common: {
      email: "Email",
      password: "Password",
      login: "Log in",
      sendReset: "Send reset",
      createWorkspace: "Create organization workspace",
      startWorkspace: "Start WeSERVE workspace",
      openMenu: "Open menu",
      closeMenu: "Close menu",
      notifications: "Notifications",
      allNotifications: "All notifications",
      noNotifications: "No notifications right now",
      openNotification: "Open notification",
      openSettings: "Open organization settings",
      accountSettings: "Account settings",
      myAccount: "My account",
      support: "Support",
      settings: "Settings",
      logout: "Log out",
      admin: "Admin",
      user: "User",
      active: "Active",
      inactive: "Inactive",
      yes: "Yes",
      no: "No",
      member: "Member",
      members: "Members",
      nonMember: "Non-member",
      csv: "CSV",
      noRecords: "No records found",
      status: "Status",
      name: "Name",
      unspecified: "Unspecified",
      delete: "Delete",
      activate: "Activate",
      deactivate: "Deactivate",
      archive: "Archive",
      view: "View",
      edit: "Edit",
      save: "Save",
      cancel: "Cancel",
      confirm: "Confirm",
      connect: "Connect",
      manage: "Manage",
      update: "Update",
      locked: "Locked",
      recommended: "Recommended",
      pending: "Pending",
      generated: "Generated",
      queued: "Queued",
      delivered: "Delivered",
      print: "Print",
      invalidEmail: "Invalid email",
      to: "to",
      previous: "Previous",
      next: "Next",
      seeAll: "See all",
      page: "Page",
      showing: "Showing",
      of: "of",
      perPage: "Entries per page",
    },
    actions: ["Add donation", "Add donor", "Generate receipts", "Generate report"],
    metrics: ["Year-to-date donations", "Receipts", "Active donors", "Pending receipts"],
    donorForm: {
      title: "Add donor",
      success: "Donor saved.",
      updated: "Donor updated.",
      new: "New donor",
      subtitle: "Keep donor contact details, giving history, and segmentation ready for receipting.",
      number: "Number",
      autoNumber: "Auto if blank",
      firstName: "First name",
      lastName: "Last name",
      address: "Address",
      city: "City",
      postalCode: "Postal code",
      province: "Province",
      cell: "Mobile",
      residence: "Home phone",
      receiptsEnabled: "Receipts enabled",
      notes: "Notes",
      totals: "Donor totals",
      directory: "Directory",
      filter: "Filter donors",
      lifetime: "Lifetime",
      lastGift: "Last gift",
      tourTitle: "Donor page tour",
      tourSubtitle: "A quick walkthrough of the donor workspace.",
      tourSteps: [
        { visual: "search", title: "Search and export", body: "Filter the donor directory, then export the visible list as CSV or Excel." },
        { visual: "add", title: "Add donor tab", body: "This side tab opens the form to add a new donor without leaving the directory." },
        { visual: "stats", title: "Stats tab", body: "This side tab opens donor totals and a quick summary of recent donor activity." },
        { visual: "edit", title: "Edit donors", body: "Use the pencil in each row to update a donor profile from the side panel." },
      ],
      tourDone: "Got it",
      tourReplay: "Show tutorial",
      reactivated: "Donor reactivated.",
      archived: "Donor archived.",
      deleted: "Donor deleted.",
      deleteTitle: "Delete this donor?",
      deleteBody: "Are you sure you want to delete {name}? Donors with existing donations should be set inactive instead.",
      deactivateTitle: "Make this donor inactive?",
      deactivateBody: "Are you sure you want to make {name} inactive? They will remain in the directory with an inactive status.",
      donationHistory: "Donation history",
      donorProfile: "Donor profile",
      donorStatement: "Donor statement",
      noDonations: "No donations recorded for this donor yet.",
      expandProfile: "Expand donor profile",
      donationCount: "Donation count",
      averageDonation: "Average donation",
      readyReceipts: "Ready receipts",
      totalDonors: "Donors",
    },
    donationForm: {
      title: "Record a donation",
      subtitle: "Register gifts, assign accounts, and move receipt status forward.",
      donor: "Donor",
      account: "Account",
      amount: "Amount",
      date: "Date",
      method: "Method",
      description: "Description",
      descriptionPlaceholder: "Offering, campaign, batch note",
      add: "Add donation",
      success: "Donation added to the register.",
      updated: "Donation updated.",
      accountMix: "Account mix",
      import: "Import donations",
      chooseFile: "Choose file",
      importHelp: "Upload CSV, Excel, PayPal, or bank export files before categorizing them.",
      register: "Donation register",
      registered: "Registered",
      summary: "Donation totals",
      totalDonations: "Total donations",
      totalAmount: "Total amount",
      ytdAmount: "YTD amount",
      ytdDonations: "YTD donations",
      donations: "donations",
      monthlySoFar: "so far",
      searchRegister: "Search donations",
      showAllPending: "Show all pending",
      collapsePending: "Collapse pending",
      averageGift: "Average gift",
      deleted: "Donation deleted.",
      confirmDelete: "Delete donation {id} from {name}?",
      deleteTitle: "Delete this donation?",
      deleteBody: "Are you sure you want to delete donation {id} from {name}? This action cannot be undone.",
      detectedDonor: "Detected donor",
      donorNumber: "Donor number",
      chooseAccount: "Choose account",
      categorizeSuccess: "Pending donation categorized.",
      noPendingDonations: "No pending donations to categorize.",
    },
    giving: {
      title: "Self-serve giving",
      subtitle: "Let donors tap a phone, enter their donor number, and confirm a gift through the payment gateway.",
      publicTitle: "Give to {organization}",
      publicSubtitle: "Enter your donor number, choose a fund, confirm the amount, and receive a confirmation number.",
      donorLookup: "Find my donor record",
      donorNumberHelp: "Use the donor number printed on your statement or given by the organization.",
      tapLink: "Tap / QR donation link",
      tapLinkHelp: "Put this link behind an NFC tag or QR code so donors can open the giving page from their phone.",
      gatewayStatus: "Payment gateway",
      testMode: "Test mode",
      liveMode: "Live mode",
      connected: "Connected",
      copyLink: "Copy link",
      copied: "Donation link copied.",
      openPortal: "Open donor portal",
      chooseDonor: "Choose donor number",
      fund: "Donation fund",
      suggested: "Suggested amounts",
      donorEmail: "Confirmation email",
      note: "Optional note",
      notePlaceholder: "Campaign, pledge, or dedication",
      pay: "Tap phone / confirm gift",
      confirmationTitle: "Gift confirmed",
      confirmationBody: "Your gift was approved and recorded. Keep this confirmation number for your records.",
      confirmationNumber: "Confirmation number",
      receiptStatus: "Receipt status",
      sentTo: "Confirmation shown for",
      thankYou: "Thank you for your generosity.",
      recent: "Recent self-serve confirmations",
      noRecent: "No self-serve payments yet.",
      lookupError: "Enter a valid donor number to continue.",
    },
    accounts: {
      title: "Account list",
      subtitle: "Accounts control how donations are grouped and whether they are receipt eligible.",
      success: "Account saved.",
      add: "Add account",
      accountNumber: "Account number",
      name: "Name",
      eligible: "Eligible for receipts",
      eligibility: "Receipt eligibility",
      eligibilityText: "Accounts generate official receipt amounts",
      receiptable: "Receiptable",
      noReceipt: "No receipt",
      deleted: "Account deleted.",
      confirmDelete: "Delete account {number} - {name}?",
      details: "Account details",
      donationsList: "Donations in this account",
      editTitle: "Edit account",
      emptyDonations: "No donations recorded in this account yet.",
      donationSingular: "donation",
      donationPlural: "donations",
      duplicate: "An account with this number already exists.",
      deleteTitle: "Delete this account?",
      deleteBody: "Are you sure you want to delete account {number} - {name}? This action cannot be undone.",
    },
    customization: {
      title: "Customization",
      subtitle: "Tune the workspace look and feel for your organization.",
      palette: "Color palette",
      preview: "Interface preview",
      apply: "Apply palette",
      current: "Current palette",
      custom: "Custom palette",
      customDescription: "Create your own palette with brand, accent, and highlight colors.",
      customName: "Palette name",
      saveCustom: "Save palette",
      savedPalettes: "Saved palettes",
      savedSuccess: "Palette saved.",
      brandColor: "Brand",
      accentColor: "Accent",
      highlightColor: "Highlight",
      options: [
        ["Default", "The original WeSERVE interface palette"],
        ["Evergreen", "Calm green for finance and operations"],
        ["Harbor", "Blue accent with a crisp SaaS feel"],
        ["Plum", "Warmer accent for a more branded workspace"],
      ],
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
      action: "Generate",
      annualBatch: "Annual receipt batch",
      batchSummary: "{ready} donation rows are ready and {review} are excluded by donor/account receipt settings.",
      startDate: "Start date",
      endDate: "End date",
      mode: "Mode",
      stored: "Stored receipts",
      readyGifts: "Ready gifts",
      eligibleRows: "Eligible rows",
      batches: "Batches",
      generatedLabel: "Generated",
      notReceiptable: "Not receiptable",
      markSent: "Mark sent",
      created: "Created",
      period: "Period",
      count: "Count",
      total: "Total",
      noEligibleRows: "No eligible receipt rows found for this period.",
      statusUpdated: "Receipt status updated.",
    },
    reports: {
      title: "Reports",
      subtitle: "Build donor, donation, receipt, and account reports from the SQLite database.",
      run: "Run report",
      export: "Export",
      builder: "Report builder",
      report: "Report",
      groupBy: "Group by",
      date: "Date",
      account: "Account",
      donor: "Donor",
      method: "Method",
      start: "Start",
      end: "End",
      donations: "Donations",
      donors: "Donors",
      accounts: "Accounts",
      receipts: "Receipts",
      summary: "Summary",
      group: "Group",
      rows: "Rows",
      details: "Details",
      month: "Month",
      accountsByMonth: "Accounts by month",
      generatedView: "Generated view",
      monthlySections: "Monthly sections",
      countLabel: "donations",
      noReport: "Run a report to preview the grouped result.",
      customTemplate: "Create a custom report",
      customTemplateDescription: "Save your own reusable report format.",
      customTemplates: "Custom reports",
      templateName: "Template name",
      templateDescription: "Description",
      saveTemplate: "Save template",
      reportType: "Report type",
      schedule: "Automatic generation",
      generateAutomatically: "Generate automatically",
      frequency: "Frequency",
      weekly: "Weekly",
      monthly: "Monthly",
      day: "Day",
      monday: "Monday",
      tuesday: "Tuesday",
      wednesday: "Wednesday",
      thursday: "Thursday",
      friday: "Friday",
      firstDay: "1st of the month",
      fifteenthDay: "15th of the month",
      lastDay: "Last day of the month",
      templateSaved: "Custom template saved.",
      refreshed: "Report refreshed.",
      templates: [
        { id: "donation-detail", title: "Detailed donations", description: "All donation rows with donor, account, method, date, and amount.", type: "donations", groupBy: "date" },
        { id: "monthly-ytd", title: "Monthly YTD summary", description: "Totals by month for the selected year-to-date period.", type: "donations", groupBy: "month" },
        { id: "account-month", title: "Accounts by month", description: "Monthly totals split by each SaaS account.", type: "donations", groupBy: "accountMonth" },
        { id: "donor-totals", title: "Donor totals", description: "Total giving by donor over the selected period.", type: "donations", groupBy: "donor" },
        { id: "account-totals", title: "Account totals", description: "Total giving by account over the selected period.", type: "donations", groupBy: "account" },
        { id: "receipt-list", title: "Receipt list", description: "Receipt rows generated for the selected period.", type: "receipts", groupBy: "date" },
      ],
    },
    subscription: {
      title: "Subscription information",
      subtitle:
        "Review your current plan, compare options, and submit changes for follow-up.",
      pricing: "Annual plans",
      submissionRequest: "Submission request",
      submit: "Submit request",
      currentPlan: "This is your plan",
      upgradePlan: "Upgrade plan",
      success: "Subscription request saved.",
      securityError: "The security answer must be 70.",
      charityName: "Charity name",
      registrationNumber: "Registration number",
      personInCharge: "Person in charge",
      address: "Address",
      city: "City",
      province: "Province",
      phone: "Phone",
      memberNumber: "Member number",
      security: "Security: 50 + 20",
      annualRevenue: "Annual revenue",
      plans: "Subscription options",
      choose: "Choose plan",
      plansList: [
        {
          name: "Base",
          price: "$29/mo",
          description: "Current default model for every tenant while future declinations are prepared.",
          features: ["Donor and donation tracking", "Manual receipts", "CSV exports"],
        },
        {
          name: "Gold",
          price: "$59/mo",
          description: "For growing organizations that need automation.",
          features: ["Everything in Base", "Receipt batches", "Bank notifications", "Priority support"],
        },
        {
          name: "Premium",
          price: "$99/mo",
          description: "For organizations with advanced workflows.",
          features: ["Everything in Gold", "Multi-user controls", "Payment method management", "Advanced reporting"],
        },
      ],
    },
    saas: {
      controlCenter: "SaaS control center",
      controlSubtitle: "Plan, billing, security, onboarding, API access, and audit controls for this workspace.",
      usage: "Usage and limits",
      onboarding: "Launch checklist",
      billing: "Billing center",
      invoices: "Invoices",
      auditLog: "Audit log",
      apiKeys: "API keys",
      webhooks: "Webhooks",
      security: "Security posture",
      securityHelp: "Set minimum password and access requirements for this tenant.",
      planChanged: "Subscription plan updated.",
      paymentAdded: "Payment method added.",
      paymentDeleted: "Payment method deleted.",
      securitySaved: "Security settings saved.",
      apiKeyCreated: "API key created. Copy the secret now; it will not be shown again.",
      apiKeyRevoked: "API key revoked.",
      webhookCreated: "Webhook endpoint created.",
      webhookDeleted: "Webhook endpoint deleted.",
      webhookTested: "Webhook test delivered.",
      createApiKey: "Create API key",
      revokeApiKey: "Revoke",
      addWebhook: "Add webhook",
      testWebhook: "Send test",
      saveSecurity: "Save security",
      mfaRequired: "Require MFA",
      passwordMinLength: "Minimum password length",
      sessionTimeoutDays: "Session timeout days",
      allowedDomains: "Allowed email domains",
      noPaymentMethods: "No payment methods yet.",
      noInvoices: "No invoices yet.",
      noApiKeys: "No API keys yet.",
      noWebhooks: "No webhook endpoints yet.",
      secretOnce: "Copy this secret now",
      currentPeriod: "Current period",
      renews: "Renews",
      trialEnds: "Trial ends",
      billingCycle: "Billing cycle",
      monthly: "Monthly",
      annual: "Annual",
      annualSavings: "Annual saves two months",
      choosePlan: "Choose this plan",
      included: "Included",
      used: "Used",
      remaining: "Remaining",
      event: "Event",
      actor: "Actor",
      entity: "Entity",
      when: "When",
      status: "Status",
      lastDelivery: "Last delivery",
      scopes: "Scopes",
      keyLabel: "Key label",
      webhookUrl: "Webhook URL",
      eventTypes: "Event types",
      lastFour: "Last four",
      expiry: "Expiry",
      tenantOverview: "Tenant overview",
      tenantSubtitle: "Platform-wide tenant list for SaaS admins.",
      tenants: "Tenants",
      activeTenants: "Active tenants",
      tenantCount: "Tenant count",
      subscriptionModel: "Subscription model",
    },
    settings: {
      title: "Organization settings",
      subtitle: "Update the charity profile fields used for receipts, replies, and deposit slips.",
      profile: "Organization profile",
      currentPlan: "Current plan",
      upgradePlan: "Upgrade plan",
      planHelp: "Gold plan active with receipt batches, bank notifications, and priority support.",
      users: "Users",
      userAccessTitle: "User access",
      userAccessHelp: "Access seats are attached to the organization. Admins can manage users while standard users only see their own account.",
      activeSeats: "Active seats",
      seatsRemaining: "Seats remaining",
      includedSeats: "Included seats",
      upgradeToAddUsers: "Upgrade to add more users",
      userLimitReached: "Your current plan has reached its user access limit.",
      save: "Update profile",
      saved: "Organization profile updated.",
      organizationName: "Organization name",
      registrationNumber: "Registration number",
      contactName: "Contact name",
      contactEmail: "Contact email",
      replyEmail: "Reply email",
      phone: "Phone",
      address: "Address",
      city: "City",
      postalCode: "Postal code",
      province: "Province",
      currency: "Currency",
      transit: "Transit",
      folio: "Folio",
      organizationActive: "Organization active",
      temporaryPassword: "Temporary password",
      firstName: "First name",
      lastName: "Last name",
      adminAccess: "Admin access",
      userRole: "User role",
      roleDescriptions: {
        saas_admin: "SaaS admin across all tenants",
        org_admin: "Organization admin",
        editor: "Editor",
        auditor: "Auditor",
        viewer: "Viewer",
      },
      addUser: "Add user",
      editUser: "Edit user",
      updateUser: "Update user",
      cancelEdit: "Cancel edit",
      language: "Language",
      role: "Role",
      userAdded: "User added to this workspace.",
      userUpdated: "User updated.",
      paymentMethods: "Payment methods",
      paymentSubtitle: "Manage the cards and billing methods used for your WeSERVE subscription.",
      defaultMethod: "Default",
      updatePayment: "Update payment method",
      deletePayment: "Delete payment method",
      defaultPaymentLocked: "Default payment method cannot be deleted",
      expires: "Expires",
      addPayment: "Add payment method",
      cardholder: "Cardholder",
      cardNumber: "Card number",
      expiryDate: "Expiry date",
      cvc: "CVC",
      customizationShortcut: "Customize interface",
    },
    banking: {
      title: "Connections",
      subtitle: "Connect banks, payment processors, and giving platforms so new donations can appear automatically for review.",
      pageSubtitle: "Manage connected sources and decide which SaaS accounts each connection can feed into.",
      bankAccount: "Bank account",
      paymentProcessor: "Payment processor",
      givingPlatform: "Giving platform",
      externalSource: "External source",
      paypal: "PayPal account",
      linked: "Linked",
      linkedAccounts: "Linked accounts",
      allAccounts: "All SaaS accounts",
      accountScope: "Associated SaaS accounts",
      addConnection: "Link another connection",
      addConnectionHelp: "Connect a bank, payment processor, or giving platform for incoming donations.",
      institution: "Institution",
      provider: "Provider",
      connectionType: "Connection type",
      accountNumber: "Account number",
      paypalEmail: "PayPal email",
      stripeAccount: "Stripe account ID",
      transitNumber: "Transit",
      ibanNumber: "IBAN / routing",
      identifier: "Identifier",
      sourceEmail: "Source email",
      sourceAccount: "Source account",
      routingDetails: "Routing / source details",
      scopeAll: "Use all accounts",
      scopeSelected: "Select accounts",
      connectSource: "Connect source",
      connected: "Connection saved.",
      accountingTitle: "Accounting integrations",
      accountingSubtitle: "Prepare donation exports for QuickBooks Online or Xero from the data already tracked in WeSERVE.",
      quickbooks: "QuickBooks Online",
      xero: "Xero",
      apiReady: "API ready",
      synced: "Synced",
      scopes: "Scopes",
      addAccounting: "Add accounting integration",
      syncDonations: "Sync donations",
      lastSync: "Last sync",
      noSync: "Not synced yet",
      accountingConnected: "Accounting integration saved.",
      accountingSynced: "{count} donations prepared for accounting export ({total}).",
      newDonations: "New donations",
      pendingNotification: "{count} pending new donations",
      newDonationHelp: "Incoming transactions are tagged as pending until you assign a donor and account.",
      categorize: "Categorize",
      imported: "Imported",
      recordManual: "Record a manual donation",
      manualHelp: "Open this form when you need to enter a donation manually.",
    },
    support: {
      title: "Support and tutorials",
      subtitle: "Tutorial shortcuts are mapped to the working WeSERVE screens.",
      setup: "How to set up WeSERVE",
      account: "Add an account",
      donor: "Add a donor",
      donation: "Add a gift",
      report: "Produce reports",
      receipt: "Produce receipts",
      helpText: "Need a hand? Use these shortcuts or contact your account administrator for support.",
      contact: "Contact your account administrator for WeSERVE support.",
    },
    alerts: {
      none: "No pending alerts. Receipt and donation data are current.",
      forgot: "If this email is active, reset instructions will be sent by the WeSERVE administrator.",
      loggedIn: "Logged in.",
      workspaceCreated: "Organization workspace created.",
    },
    footer: "Suite 106, 5425 Boulevard Laurier O, Saint-Hyacinthe, QC J2S 3V6",
  },
  fr: {
    locale: "fr-CA",
    product: "WeSERVE",
    organization: "WeSERVE",
    nav: {
      overview: "Accueil",
      donations: "Dons",
      donors: "Donateurs",
      accounts: "Comptes",
      receipts: "Reçus",
      reports: "Rapports",
      banking: "Connexions",
      integrations: "Intégrations",
      subscription: "Abonnement",
      customization: "Personnalisation",
      tenants: "Locataires",
    },
    overview: {
      eyebrow: "Tableau de bord",
      title: "Dons, donateurs et reçus dans un espace de travail sécurisé.",
      subtitle:
        "Un espace WeSERVE local avec SQLite pour tenir des registres fiables, produire les reçus et générer les rapports rapidement.",
      search: "Rechercher un donateur, un reçu, un compte ou un don",
      period: "Année fiscale 2026",
      quickActions: "Actions rapides",
      recentDonations: "Dons récents",
      monthlyIncome: "Revenus mensuels",
      monthlyGivingSoFar: "Dons mensuels jusqu'ici",
      currentMonth: "Ce mois-ci",
      dayProgress: "Jour",
      monthElapsed: "du mois écoulé",
      monthlyAverage: "Moyenne mensuelle",
      annualAverageProgress: "de la moyenne mensuelle annuelle",
      receiptReadiness: "Préparation des reçus",
      loginTitle: "Accès sécurisé",
      loginHelp: "Utilisez le courriel de votre organisme.",
      forgot: "Mot de passe oublié",
      loading: "Chargement des données WeSERVE...",
      facts: ["WeSERVE SaaS", "Donateurs et dons", "Lots de reçus"],
      readinessText: "Lignes de dons déjà émises ou exclues de l'émission de reçus",
      receiptableAccounts: "comptes admissibles aux reçus",
      donationsReady: "dons prêts pour les reçus",
      receiptsStored: "reçus enregistrés",
    },
    common: {
      email: "Courriel",
      password: "Mot de passe",
      login: "Se connecter",
      sendReset: "Envoyer la réinitialisation",
      createWorkspace: "Créer un espace pour l'organisme",
      startWorkspace: "Démarrer l'espace WeSERVE",
      openMenu: "Ouvrir le menu",
      closeMenu: "Fermer le menu",
      notifications: "Notifications",
      allNotifications: "Toutes les notifications",
      noNotifications: "Aucune notification pour le moment",
      openNotification: "Ouvrir la notification",
      openSettings: "Ouvrir les paramètres de l'organisme",
      accountSettings: "Paramètres du compte",
      myAccount: "Mon compte",
      support: "Support",
      settings: "Paramètres",
      logout: "Déconnexion",
      admin: "Admin",
      user: "Utilisateur",
      active: "Actif",
      inactive: "Inactif",
      yes: "Oui",
      no: "Non",
      member: "Membre",
      members: "Membres",
      nonMember: "Non-membre",
      csv: "CSV",
      noRecords: "Aucun dossier trouvé",
      status: "Statut",
      name: "Nom",
      unspecified: "Non précisé",
      delete: "Supprimer",
      activate: "Activer",
      deactivate: "Désactiver",
      archive: "Archiver",
      view: "Consulter",
      edit: "Modifier",
      save: "Enregistrer",
      cancel: "Annuler",
      confirm: "Confirmer",
      connect: "Connecter",
      manage: "Gérer",
      update: "Modifier",
      locked: "Verrouillé",
      recommended: "Recommandé",
      pending: "En attente",
      generated: "Généré",
      queued: "En file d'attente",
      delivered: "Livré",
      print: "Imprimer",
      invalidEmail: "Courriel non valide",
      to: "au",
      previous: "Précédent",
      next: "Suivant",
      seeAll: "Voir tout",
      page: "Page",
      showing: "Affichage",
      of: "sur",
      perPage: "Entrées par page",
    },
    actions: ["Ajouter un don", "Ajouter un donateur", "Générer les reçus", "Générer un rapport"],
    metrics: ["Dons depuis le début de l'année", "Reçus", "Donateurs actifs", "Reçus en attente"],
    donorForm: {
      title: "Ajouter un donateur",
      success: "Donateur enregistré.",
      updated: "Donateur mis à jour.",
      new: "Nouveau donateur",
      subtitle: "Gardez les coordonnées, l'historique des dons et la segmentation des donateurs prêts pour les reçus.",
      number: "Numéro",
      autoNumber: "Automatique si vide",
      firstName: "Prénom",
      lastName: "Nom",
      address: "Adresse",
      city: "Ville",
      postalCode: "Code postal",
      province: "Province",
      cell: "Cellulaire",
      residence: "Téléphone résidentiel",
      receiptsEnabled: "Reçus activés",
      notes: "Notes",
      totals: "Totaux des donateurs",
      directory: "Répertoire",
      filter: "Filtrer les donateurs",
      lifetime: "Total à vie",
      lastGift: "Dernier don",
      tourTitle: "Tutoriel de la page Donateurs",
      tourSubtitle: "Un aperçu rapide de l'espace de travail des donateurs.",
      tourSteps: [
        { visual: "search", title: "Recherche et exports", body: "Filtrez le répertoire des donateurs, puis exportez la liste visible en CSV ou Excel." },
        { visual: "add", title: "Onglet Ajouter", body: "Cet onglet latéral ouvre le formulaire pour ajouter un donateur sans quitter le répertoire." },
        { visual: "stats", title: "Onglet statistiques", body: "Cet onglet latéral ouvre les totaux et un résumé rapide de l'activité des donateurs." },
        { visual: "edit", title: "Modifier les donateurs", body: "Utilisez le crayon dans chaque ligne pour modifier un profil depuis le panneau latéral." },
      ],
      tourDone: "Compris",
      tourReplay: "Voir le tutoriel",
      reactivated: "Donateur réactivé.",
      archived: "Donateur archivé.",
      deleted: "Donateur supprimé.",
      deleteTitle: "Supprimer ce donateur?",
      deleteBody: "Voulez-vous vraiment supprimer {name}? Les donateurs avec des dons existants devraient plutôt être désactivés.",
      deactivateTitle: "Rendre ce donateur inactif?",
      deactivateBody: "Voulez-vous vraiment rendre {name} inactif? Il restera dans le répertoire avec le statut inactif.",
      donationHistory: "Historique des dons",
      donorProfile: "Profil du donateur",
      donorStatement: "Compte-rendu du donateur",
      noDonations: "Aucun don enregistré pour ce donateur.",
      expandProfile: "Agrandir le profil du donateur",
      donationCount: "Nombre de dons",
      averageDonation: "Don moyen",
      readyReceipts: "Reçus prêts",
      totalDonors: "Donateurs",
    },
    donationForm: {
      title: "Enregistrer un don",
      subtitle: "Enregistrez les dons, attribuez les comptes et faites avancer le statut des reçus.",
      donor: "Donateur",
      account: "Compte",
      amount: "Montant",
      date: "Date",
      method: "Méthode",
      description: "Description",
      descriptionPlaceholder: "Offrande, campagne, note de lot",
      add: "Ajouter le don",
      success: "Le don a été ajouté au registre.",
      updated: "Don modifié.",
      accountMix: "Répartition par compte",
      import: "Importer des dons",
      chooseFile: "Choisir un fichier",
      importHelp: "Téléversez des fichiers CSV, Excel, PayPal ou bancaires avant de les catégoriser.",
      register: "Registre des dons",
      registered: "Enregistrés",
      summary: "Totaux des dons",
      totalDonations: "Dons au total",
      totalAmount: "Montant total",
      ytdAmount: "Montant YTD",
      ytdDonations: "Dons YTD",
      donations: "dons",
      monthlySoFar: "jusqu'ici",
      searchRegister: "Rechercher dans les dons",
      showAllPending: "Afficher tous les dons en attente",
      collapsePending: "Réduire les dons en attente",
      averageGift: "Don moyen",
      deleted: "Don supprimé.",
      confirmDelete: "Supprimer le don {id} de {name}?",
      deleteTitle: "Supprimer ce don?",
      deleteBody: "Voulez-vous vraiment supprimer le don {id} de {name}? Cette action ne peut pas être annulée.",
      detectedDonor: "Donateur détecté",
      donorNumber: "Numéro de donateur",
      chooseAccount: "Choisir le compte",
      categorizeSuccess: "Don en attente catégorisé.",
      noPendingDonations: "Aucun don en attente à catégoriser.",
    },
    giving: {
      title: "Don autonome",
      subtitle: "Permettez aux donateurs de toucher avec leur téléphone, d'entrer leur numéro et de confirmer un don avec la passerelle de paiement.",
      publicTitle: "Donner à {organization}",
      publicSubtitle: "Entrez votre numéro de donateur, choisissez un fonds, confirmez le montant et recevez un numéro de confirmation.",
      donorLookup: "Trouver mon dossier donateur",
      donorNumberHelp: "Utilisez le numéro de donateur indiqué sur votre relevé ou fourni par l'organisme.",
      tapLink: "Lien don tactile / QR",
      tapLinkHelp: "Placez ce lien derrière une puce NFC ou un code QR pour ouvrir la page de don sur téléphone.",
      gatewayStatus: "Passerelle de paiement",
      testMode: "Mode test",
      liveMode: "Mode réel",
      connected: "Connectée",
      copyLink: "Copier le lien",
      copied: "Lien de don copié.",
      openPortal: "Ouvrir le portail donateur",
      chooseDonor: "Choisir le numéro de donateur",
      fund: "Fonds du don",
      suggested: "Montants suggérés",
      donorEmail: "Courriel de confirmation",
      note: "Note optionnelle",
      notePlaceholder: "Campagne, promesse ou dédicace",
      pay: "Toucher / confirmer le don",
      confirmationTitle: "Don confirmé",
      confirmationBody: "Votre don a été approuvé et enregistré. Conservez ce numéro de confirmation.",
      confirmationNumber: "Numéro de confirmation",
      receiptStatus: "Statut du reçu",
      sentTo: "Confirmation affichée pour",
      thankYou: "Merci pour votre générosité.",
      recent: "Confirmations autonomes récentes",
      noRecent: "Aucun paiement autonome pour le moment.",
      lookupError: "Entrez un numéro de donateur valide pour continuer.",
    },
    accounts: {
      title: "Liste des comptes",
      subtitle: "Les comptes classent les dons et déterminent s'ils sont admissibles aux reçus.",
      success: "Compte enregistré.",
      add: "Ajouter un compte",
      accountNumber: "Numéro de compte",
      name: "Nom",
      eligible: "Admissible aux reçus",
      eligibility: "Admissibilité aux reçus",
      eligibilityText: "Les comptes génèrent les montants des reçus officiels",
      receiptable: "Admissible",
      noReceipt: "Sans reçu",
      deleted: "Compte supprimé.",
      confirmDelete: "Supprimer le compte {number} - {name}?",
      details: "Détail du compte",
      donationsList: "Dons dans ce compte",
      editTitle: "Modifier le compte",
      emptyDonations: "Aucun don enregistré dans ce compte pour le moment.",
      donationSingular: "don",
      donationPlural: "dons",
      duplicate: "Un compte avec ce numéro existe déjà.",
      deleteTitle: "Supprimer ce compte?",
      deleteBody: "Voulez-vous vraiment supprimer le compte {number} - {name}? Cette action ne peut pas être annulée.",
    },
    customization: {
      title: "Personnalisation",
      subtitle: "Ajustez l'apparence de l'espace de travail pour votre organisme.",
      palette: "Palette de couleurs",
      preview: "Aperçu de l'interface",
      apply: "Appliquer la palette",
      current: "Palette actuelle",
      custom: "Palette personnalisée",
      customDescription: "Créez votre propre palette avec une couleur de marque, d'accent et de mise en valeur.",
      customName: "Nom de la palette",
      saveCustom: "Enregistrer la palette",
      savedPalettes: "Palettes enregistrées",
      savedSuccess: "Palette enregistrée.",
      brandColor: "Marque",
      accentColor: "Accent",
      highlightColor: "Mise en valeur",
      options: [
        ["Default", "La palette originale de l'interface WeSERVE"],
        ["Evergreen", "Vert calme pour la finance et les opérations"],
        ["Harbor", "Accent bleu avec une allure SaaS nette"],
        ["Plum", "Accent plus chaleureux pour une image personnalisée"],
      ],
    },
    donorDirectory: "Répertoire des donateurs",
    receipts: {
      title: "Centre des reçus",
      subtitle:
        "Générez les lots de reçus officiels à partir des donateurs et des comptes admissibles pour une période donnée.",
      batch: "Lot courant",
      review: "Révision requise",
      ready: "Prêt à émettre",
      print: "Imprimer le lot",
      email: "Envoyer par courriel",
      generated: "Lot de reçus généré.",
      action: "Générer",
      annualBatch: "Lot annuel de reçus",
      batchSummary: "{ready} lignes de dons sont prêtes et {review} sont exclues selon les paramètres de reçus du donateur ou du compte.",
      startDate: "Date de début",
      endDate: "Date de fin",
      mode: "Mode",
      stored: "Reçus enregistrés",
      readyGifts: "Dons prêts",
      eligibleRows: "Lignes admissibles",
      batches: "Lots",
      generatedLabel: "Générés",
      notReceiptable: "Non admissibles",
      markSent: "Marquer comme envoyé",
      created: "Créé",
      period: "Période",
      count: "Nombre",
      total: "Total",
      noEligibleRows: "Aucune ligne admissible aux reçus pour cette période.",
      statusUpdated: "Statut du reçu mis à jour.",
    },
    reports: {
      title: "Rapports",
      subtitle: "Produisez les rapports de dons, de donateurs, de reçus et de comptes à partir de SQLite.",
      run: "Lancer",
      export: "Exporter",
      builder: "Générateur de rapports",
      report: "Rapport",
      groupBy: "Grouper par",
      date: "Date",
      account: "Compte",
      donor: "Donateur",
      method: "Méthode",
      start: "Début",
      end: "Fin",
      donations: "Dons",
      donors: "Donateurs",
      accounts: "Comptes",
      receipts: "Reçus",
      summary: "Sommaire",
      group: "Groupe",
      rows: "Lignes",
      details: "Détails",
      month: "Mois",
      accountsByMonth: "Comptes par mois",
      generatedView: "Vue générée",
      monthlySections: "Sections mensuelles",
      countLabel: "dons",
      noReport: "Lancez un rapport pour voir le résultat regroupé.",
      customTemplate: "Créer un rapport personnalisé",
      customTemplateDescription: "Enregistrez votre propre format de rapport réutilisable.",
      customTemplates: "Rapports personnalisés",
      templateName: "Nom du template",
      templateDescription: "Description",
      saveTemplate: "Enregistrer le template",
      reportType: "Type de rapport",
      schedule: "Génération automatique",
      generateAutomatically: "Générer automatiquement",
      frequency: "Fréquence",
      weekly: "Hebdomadaire",
      monthly: "Mensuelle",
      day: "Jour",
      monday: "Lundi",
      tuesday: "Mardi",
      wednesday: "Mercredi",
      thursday: "Jeudi",
      friday: "Vendredi",
      firstDay: "1er du mois",
      fifteenthDay: "15 du mois",
      lastDay: "Dernier jour du mois",
      templateSaved: "Template personnalisé enregistré.",
      refreshed: "Rapport actualisé.",
      templates: [
        { id: "donation-detail", title: "Dons détaillés", description: "Toutes les lignes de dons avec donateur, compte, méthode, date et montant.", type: "donations", groupBy: "date" },
        { id: "monthly-ytd", title: "Sommaire mensuel YTD", description: "Totaux par mois pour la période sélectionnée.", type: "donations", groupBy: "month" },
        { id: "account-month", title: "Comptes par mois", description: "Totaux mensuels séparés par compte SaaS.", type: "donations", groupBy: "accountMonth" },
        { id: "donor-totals", title: "Totaux par donateur", description: "Total des dons par donateur sur la période sélectionnée.", type: "donations", groupBy: "donor" },
        { id: "account-totals", title: "Totaux par compte", description: "Total des dons par compte sur la période sélectionnée.", type: "donations", groupBy: "account" },
        { id: "receipt-list", title: "Liste des reçus", description: "Lignes de reçus générées pour la période sélectionnée.", type: "receipts", groupBy: "date" },
      ],
    },
    subscription: {
      title: "Informations d'abonnement",
      subtitle:
        "Consultez votre plan actuel, comparez les options et envoyez les changements pour le suivi.",
      pricing: "Forfaits annuels",
      submissionRequest: "Demande de soumission",
      submit: "Envoyer la demande",
      currentPlan: "C'est votre plan",
      upgradePlan: "Améliorer le plan",
      success: "Demande d'abonnement enregistrée.",
      securityError: "La réponse de sécurité doit être 70.",
      charityName: "Nom de l'organisme",
      registrationNumber: "Numéro d'enregistrement",
      personInCharge: "Personne responsable",
      address: "Adresse",
      city: "Ville",
      province: "Province",
      phone: "Téléphone",
      memberNumber: "Numéro de membre",
      security: "Sécurité : 50 + 20",
      annualRevenue: "Revenu annuel",
      plans: "Options d'abonnement",
      choose: "Choisir le forfait",
      plansList: [
        {
          name: "Base",
          price: "29 $/mois",
          description: "Modèle actuel par défaut pour tous les locataires.",
          features: ["Suivi des donateurs et des dons", "Reçus manuels", "Exports CSV"],
        },
        {
          name: "Gold",
          price: "59 $/mois",
          description: "Pour les organismes en croissance.",
          features: ["Tout dans Base", "Lots de reçus", "Notifications bancaires", "Support prioritaire"],
        },
        {
          name: "Premium",
          price: "99 $/mois",
          description: "Pour les flux de travail avancés.",
          features: ["Tout dans Gold", "Contrôles multiutilisateurs", "Gestion des paiements", "Rapports avancés"],
        },
      ],
    },
    saas: {
      controlCenter: "Centre de contrôle SaaS",
      controlSubtitle: "Plan, facturation, sécurité, démarrage, accès API et journal d'audit de cet espace.",
      usage: "Utilisation et limites",
      onboarding: "Liste de lancement",
      billing: "Centre de facturation",
      invoices: "Factures",
      auditLog: "Journal d'audit",
      apiKeys: "Clés API",
      webhooks: "Webhooks",
      security: "Sécurité",
      securityHelp: "Définissez les exigences de mot de passe et d'accès de ce locataire.",
      planChanged: "Plan d'abonnement mis à jour.",
      paymentAdded: "Méthode de paiement ajoutée.",
      paymentDeleted: "Méthode de paiement supprimée.",
      securitySaved: "Paramètres de sécurité enregistrés.",
      apiKeyCreated: "Clé API créée. Copiez le secret maintenant; il ne sera plus affiché.",
      apiKeyRevoked: "Clé API révoquée.",
      webhookCreated: "Webhook créé.",
      webhookDeleted: "Webhook supprimé.",
      webhookTested: "Test webhook livré.",
      createApiKey: "Créer une clé API",
      revokeApiKey: "Révoquer",
      addWebhook: "Ajouter un webhook",
      testWebhook: "Envoyer un test",
      saveSecurity: "Enregistrer la sécurité",
      mfaRequired: "Exiger MFA",
      passwordMinLength: "Longueur minimale du mot de passe",
      sessionTimeoutDays: "Jours avant expiration de session",
      allowedDomains: "Domaines courriel autorisés",
      noPaymentMethods: "Aucune méthode de paiement.",
      noInvoices: "Aucune facture.",
      noApiKeys: "Aucune clé API.",
      noWebhooks: "Aucun webhook.",
      secretOnce: "Copiez ce secret maintenant",
      currentPeriod: "Période actuelle",
      renews: "Renouvelle",
      trialEnds: "Essai jusqu'au",
      billingCycle: "Cycle de facturation",
      monthly: "Mensuel",
      annual: "Annuel",
      annualSavings: "Annuel économise deux mois",
      choosePlan: "Choisir ce plan",
      included: "Inclus",
      used: "Utilisé",
      remaining: "Restant",
      event: "Événement",
      actor: "Acteur",
      entity: "Entité",
      when: "Quand",
      status: "Statut",
      lastDelivery: "Dernière livraison",
      scopes: "Portées",
      keyLabel: "Libellé de la clé",
      webhookUrl: "URL webhook",
      eventTypes: "Types d'événement",
      lastFour: "Quatre derniers",
      expiry: "Expiration",
      tenantOverview: "Vue des locataires",
      tenantSubtitle: "Liste plateforme des locataires pour les admins SaaS.",
      tenants: "Locataires",
      activeTenants: "Locataires actifs",
      tenantCount: "Nombre de locataires",
      subscriptionModel: "Modèle d'abonnement",
    },
    settings: {
      title: "Paramètres de l'organisme",
      subtitle: "Mettez à jour les champs utilisés pour les reçus, les réponses et les dépôts.",
      profile: "Profil de l'organisme",
      currentPlan: "Plan actuel",
      upgradePlan: "Améliorer le plan",
      planHelp: "Plan Gold actif avec lots de reçus, notifications bancaires et support prioritaire.",
      users: "Utilisateurs",
      userAccessTitle: "Accès utilisateurs",
      userAccessHelp: "Les accès sont rattachés à l'organisation. Les admins peuvent gérer les utilisateurs; les utilisateurs standards voient seulement leur compte.",
      activeSeats: "Accès actifs",
      seatsRemaining: "Accès restants",
      includedSeats: "Accès inclus",
      upgradeToAddUsers: "Améliorer pour ajouter des utilisateurs",
      userLimitReached: "Votre plan actuel a atteint sa limite d'accès utilisateurs.",
      save: "Mettre à jour le profil",
      saved: "Profil de l'organisme mis à jour.",
      organizationName: "Nom de l'organisme",
      registrationNumber: "Numéro d'enregistrement",
      contactName: "Nom du contact",
      contactEmail: "Courriel du contact",
      replyEmail: "Courriel de réponse",
      phone: "Téléphone",
      address: "Adresse",
      city: "Ville",
      postalCode: "Code postal",
      province: "Province",
      currency: "Devise",
      transit: "Transit",
      folio: "Folio",
      organizationActive: "Organisme actif",
      temporaryPassword: "Mot de passe temporaire",
      firstName: "Prénom",
      lastName: "Nom",
      adminAccess: "Accès administrateur",
      userRole: "Rôle utilisateur",
      roleDescriptions: {
        saas_admin: "Admin SaaS pour tous les locataires",
        org_admin: "Admin de l'organisme",
        editor: "Éditeur",
        auditor: "Auditeur",
        viewer: "Lecteur",
      },
      addUser: "Ajouter un utilisateur",
      editUser: "Modifier l'utilisateur",
      updateUser: "Mettre à jour l'utilisateur",
      cancelEdit: "Annuler",
      language: "Langue",
      role: "Rôle",
      userAdded: "Utilisateur ajouté à cet espace.",
      userUpdated: "Utilisateur mis à jour.",
      paymentMethods: "Méthodes de paiement",
      paymentSubtitle: "Gérez les cartes et méthodes de facturation utilisées pour votre abonnement WeSERVE.",
      defaultMethod: "Par défaut",
      updatePayment: "Modifier la méthode de paiement",
      deletePayment: "Supprimer la méthode de paiement",
      defaultPaymentLocked: "La méthode de paiement par défaut ne peut pas être supprimée",
      expires: "Expire",
      addPayment: "Ajouter une méthode de paiement",
      cardholder: "Titulaire",
      cardNumber: "Numéro de carte",
      expiryDate: "Date d'expiration",
      cvc: "CVC",
      customizationShortcut: "Personnaliser l'interface",
    },
    banking: {
      title: "Connexions",
      subtitle: "Connectez des banques, processeurs de paiement et plateformes de dons pour faire apparaître automatiquement les nouveaux dons à réviser.",
      pageSubtitle: "Gérez les sources connectées et choisissez les comptes du SaaS admissibles pour chaque connexion.",
      bankAccount: "Compte bancaire",
      paymentProcessor: "Processeur de paiement",
      givingPlatform: "Plateforme de dons",
      externalSource: "Source externe",
      paypal: "Compte PayPal",
      linked: "Connecté",
      linkedAccounts: "Comptes liés",
      allAccounts: "Tous les comptes SaaS",
      accountScope: "Comptes SaaS associés",
      addConnection: "Lier une autre connexion",
      addConnectionHelp: "Connectez une banque, un processeur de paiement ou une plateforme de dons.",
      institution: "Institution",
      provider: "Fournisseur",
      connectionType: "Type de connexion",
      accountNumber: "Numéro de compte",
      paypalEmail: "Courriel PayPal",
      stripeAccount: "ID de compte Stripe",
      transitNumber: "Transit",
      ibanNumber: "IBAN / routage",
      identifier: "Identifiant",
      sourceEmail: "Courriel source",
      sourceAccount: "Compte source",
      routingDetails: "Routage / détails source",
      scopeAll: "Utiliser tous les comptes",
      scopeSelected: "Sélectionner des comptes",
      connectSource: "Connecter la source",
      connected: "Connexion enregistrée.",
      accountingTitle: "Intégrations comptables",
      accountingSubtitle: "Préparez les exports de dons pour QuickBooks Online ou Xero à partir des données déjà suivies dans WeSERVE.",
      quickbooks: "QuickBooks Online",
      xero: "Xero",
      apiReady: "API prête",
      synced: "Synchronisé",
      scopes: "Autorisations",
      addAccounting: "Ajouter une intégration comptable",
      syncDonations: "Synchroniser les dons",
      lastSync: "Dernière sync",
      noSync: "Pas encore synchronisé",
      accountingConnected: "Intégration comptable enregistrée.",
      accountingSynced: "{count} dons préparés pour l'export comptable ({total}).",
      newDonations: "Nouveaux dons",
      pendingNotification: "{count} nouveaux dons en attente",
      newDonationHelp: "Les transactions entrantes restent en attente jusqu'à l'attribution d'un donateur et d'un compte.",
      categorize: "Catégoriser",
      imported: "Importé",
      recordManual: "Enregistrer un don manuel",
      manualHelp: "Ouvrez ce formulaire lorsque vous devez saisir un don manuellement.",
    },
    support: {
      title: "Support et tutoriels",
      subtitle: "Les raccourcis de tutoriels sont reliés aux écrans WeSERVE fonctionnels.",
      setup: "Configurer WeSERVE",
      account: "Ajouter un compte",
      donor: "Ajouter un donateur",
      donation: "Ajouter un don",
      report: "Produire des rapports",
      receipt: "Produire des reçus",
      helpText: "Besoin d'aide? Utilisez ces raccourcis ou contactez votre administrateur de compte pour le soutien.",
      contact: "Contactez votre administrateur de compte pour obtenir du soutien WeSERVE.",
    },
    alerts: {
      none: "Aucune alerte en attente. Les dons et les reçus sont à jour.",
      forgot: "Si ce courriel est actif, les instructions seront envoyées par l'administrateur WeSERVE.",
      loggedIn: "Connexion réussie.",
      workspaceCreated: "Espace de l'organisme créé.",
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
  { id: "banking", icon: Landmark },
  { id: "integrations", icon: BookOpenCheck },
  { id: "subscription", icon: Building2 },
  { id: "customization", icon: Palette },
  { id: "tenants", icon: Globe2, saasOnly: true },
];

const appViews = new Set([...navItems.map((item) => item.id), "settings", "support"]);

const userSeatPlans = {
  Base: { seats: 2, next: "Gold" },
  Gold: { seats: 5, next: "Premium" },
  Premium: { seats: 15, next: null },
};

const demoUserAvatar =
  "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96'%3E%3Cdefs%3E%3ClinearGradient id='g' x1='14' y1='10' x2='86' y2='90' gradientUnits='userSpaceOnUse'%3E%3Cstop stop-color='%231d6f5f'/%3E%3Cstop offset='1' stop-color='%2386b9a5'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='96' height='96' rx='24' fill='url(%23g)'/%3E%3Ccircle cx='48' cy='36' r='16' fill='%23fff' fill-opacity='.95'/%3E%3Cpath d='M22 82c4-18 16-28 26-28s22 10 26 28' fill='%23fff' fill-opacity='.95'/%3E%3C/svg%3E";

const defaultReceiptPeriod = {
  dateDebut: "2026-01-01",
  dateFin: "2026-12-31",
};

async function api(path, options = {}) {
  const token = localStorage.getItem("ddr-token");
  const response = await fetch(path, {
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(options.headers || {}),
    },
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

function submitTarget(id) {
  const form = document.getElementById(id);
  if (form?.requestSubmit) {
    form.requestSubmit();
  }
}

function getPageTour(t, view) {
  const fr = t.common.yes === "Oui";
  const tours = {
    overview: {
      title: fr ? "Tutoriel de l'accueil" : "Overview tour",
      subtitle: fr ? "Les repères principaux du tableau de bord." : "The main signals in the dashboard.",
      steps: [
        { visual: "search", title: fr ? "Recherche globale" : "Global search", body: fr ? "Recherchez rapidement un donateur, un reçu, un compte ou un don." : "Search quickly for a donor, receipt, account, or gift." },
        { visual: "stats", title: fr ? "Indicateurs" : "Metrics", body: fr ? "Les cartes résument les dons, les reçus et les éléments à traiter." : "The cards summarize donations, receipts, and items needing attention." },
        { visual: "receipt", title: fr ? "Préparation des reçus" : "Receipt readiness", body: fr ? "Suivez le pourcentage des dons prêts pour les reçus officiels." : "Track the percentage of donations ready for official receipts." },
      ],
    },
    donations: {
      title: fr ? "Tutoriel des dons" : "Donations tour",
      subtitle: fr ? "Catégorisez les nouveaux dons et gérez le registre." : "Categorize new gifts and manage the register.",
      steps: [
        { visual: "pending", title: fr ? "Dons en attente" : "Pending donations", body: fr ? "Les transactions bancaires ou PayPal arrivent ici avant d'être catégorisées." : "Bank or PayPal transactions land here before categorization." },
        { visual: "add", title: fr ? "Ajouter un don" : "Add donation", body: fr ? "L'onglet latéral ajoute un don manuel sans quitter la page." : "The side tab records a manual donation without leaving the page." },
        { visual: "import", title: fr ? "Importer des dons" : "Import donations", body: fr ? "L'onglet import permet de téléverser un CSV, Excel, export PayPal ou export bancaire." : "The import tab uploads CSV, Excel, PayPal, or bank export files." },
        { visual: "banking", title: fr ? "Connexions" : "Connections", body: fr ? "L'onglet Connexions affiche les banques, processeurs et plateformes qui alimentent les nouveaux dons." : "The Connections tab shows banks, processors, and giving platforms feeding new donations." },
      ],
    },
    donors: {
      title: t.donorForm.tourTitle,
      subtitle: t.donorForm.tourSubtitle,
      steps: t.donorForm.tourSteps,
    },
    accounts: {
      title: fr ? "Tutoriel des comptes" : "Accounts tour",
      subtitle: fr ? "Gérez les comptes et leur admissibilité aux reçus." : "Manage accounts and receipt eligibility.",
      steps: [
        { visual: "add", title: t.accounts.add, body: fr ? "L'onglet plus ouvre le formulaire pour ajouter un compte." : "The plus side tab opens the form to add an account." },
        { visual: "receipt", title: t.accounts.eligibility, body: fr ? "L'onglet reçu résume les comptes admissibles et sans reçu." : "The receipt tab summarizes receiptable and no-receipt accounts." },
        { visual: "edit", title: fr ? "Actions du compte" : "Account actions", body: fr ? "Ouvrez un compte pour modifier, réduire ou supprimer depuis la rangée." : "Open an account to edit, collapse, or delete from the row." },
      ],
    },
    receipts: {
      title: fr ? "Tutoriel des reçus" : "Receipts tour",
      subtitle: fr ? "Générez et suivez les lots de reçus." : "Generate and track receipt batches.",
      steps: [
        { visual: "receipt", title: fr ? "Générateur" : "Generator", body: fr ? "Choisissez la période puis générez les reçus prêts." : "Choose the period and generate ready receipts." },
        { visual: "print", title: fr ? "Lots" : "Batches", body: fr ? "Suivez les lots, les statuts et les actions d'impression." : "Track batches, statuses, and print actions." },
      ],
    },
    reports: {
      title: fr ? "Tutoriel des rapports" : "Reports tour",
      subtitle: fr ? "Construisez et exportez les rapports." : "Build and export reports.",
      steps: [
        { visual: "stats", title: fr ? "Type de rapport" : "Report type", body: fr ? "Choisissez le type, le groupement et la période." : "Choose the type, grouping, and period." },
        { visual: "download", title: fr ? "Export" : "Export", body: fr ? "Exportez les résultats en CSV ou Excel une fois le rapport généré." : "Export results as CSV or Excel once the report is generated." },
      ],
    },
    banking: {
      title: fr ? "Tutoriel bancaire" : "Banking tour",
      subtitle: fr ? "Connectez les sources de dons automatiques." : "Connect automatic donation sources.",
      steps: [
        { visual: "banking", title: fr ? "Comptes connectés" : "Linked accounts", body: fr ? "Chaque tile représente une banque, PayPal ou Stripe connecté." : "Each tile represents a connected bank, PayPal, or Stripe source." },
        { visual: "add", title: fr ? "Ajouter une connexion" : "Add connection", body: fr ? "Le tile pointillé sert à connecter une nouvelle source." : "The dashed tile connects a new source." },
      ],
    },
    integrations: {
      title: fr ? "Tutoriel des intégrations" : "Integrations tour",
      subtitle: fr ? "Synchronisez les données de dons avec les outils comptables." : "Sync donation data with accounting tools.",
      steps: [
        { visual: "integration", title: fr ? "QuickBooks et Xero" : "QuickBooks and Xero", body: fr ? "Ajoutez les intégrations comptables utilisées par l'organisme." : "Add the accounting integrations your organization uses." },
        { visual: "download", title: fr ? "Sync comptable" : "Accounting sync", body: fr ? "Préparez les dons suivis dans WeSERVE pour l'export comptable." : "Prepare the donations tracked in WeSERVE for accounting export." },
      ],
    },
    subscription: {
      title: fr ? "Tutoriel abonnement" : "Subscription tour",
      subtitle: fr ? "Comparez les plans et envoyez une demande." : "Compare plans and submit a request.",
      steps: [
        { visual: "plan", title: fr ? "Plan actuel" : "Current plan", body: fr ? "Le plan Gold est marqué comme plan actuel de l'organisation." : "The Gold plan is marked as the organization's current plan." },
        { visual: "edit", title: fr ? "Demande" : "Submission", body: fr ? "Le formulaire permet d'envoyer une demande de changement." : "The form submits a change request." },
      ],
    },
    customization: {
      title: fr ? "Tutoriel personnalisation" : "Customization tour",
      subtitle: fr ? "Ajustez l'apparence de l'interface." : "Tune the look of the interface.",
      steps: [
        { visual: "palette", title: fr ? "Palettes" : "Palettes", body: fr ? "Choisissez une palette existante ou créez la vôtre." : "Choose an existing palette or create your own." },
        { visual: "preview", title: fr ? "Aperçu" : "Preview", body: fr ? "L'aperçu montre l'effet des couleurs avant application." : "The preview shows the color effect before applying." },
      ],
    },
    settings: {
      title: fr ? "Tutoriel paramètres" : "Settings tour",
      subtitle: fr ? "Gérez l'organisation, les utilisateurs et les paiements." : "Manage organization, users, and payments.",
      steps: [
        { visual: "edit", title: fr ? "Accordéons" : "Accordions", body: fr ? "Ouvrez chaque section pour modifier seulement ce dont vous avez besoin." : "Open each section to edit only what you need." },
        { visual: "users", title: fr ? "Accès utilisateurs" : "User seats", body: fr ? "Les limites d'accès dépendent du plan actif." : "User seat limits depend on the active plan." },
        { visual: "card", title: fr ? "Méthodes de paiement" : "Payment methods", body: fr ? "Modifiez ou supprimez les cartes, sauf la carte par défaut." : "Update or delete cards, except the default card." },
      ],
    },
    support: {
      title: fr ? "Tutoriel support" : "Support tour",
      subtitle: fr ? "Retrouvez les raccourcis d'aide." : "Find help shortcuts.",
      steps: [
        { visual: "help", title: fr ? "Guides" : "Guides", body: fr ? "Les raccourcis ouvrent les sections clés de WeSERVE." : "Shortcuts open key WeSERVE sections." },
        { visual: "mail", title: fr ? "Contact" : "Contact", body: fr ? "Utilisez le contact si vous avez besoin d'aide administrative." : "Use the contact area when you need administrative help." },
      ],
    },
  };

  return tours[view] || null;
}

function App() {
  const [language, setLanguage] = useState("en");
  const [activeView, setActiveView] = useState(() => {
    const savedView = localStorage.getItem("weserve-active-view");
    return appViews.has(savedView) ? savedView : "overview";
  });
  const [mobileOpen, setMobileOpen] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [quickActionsOpen, setQuickActionsOpen] = useState(false);
  const [activeTour, setActiveTour] = useState(null);
  const [tourHintActive, setTourHintActive] = useState(false);
  const [authToken, setAuthToken] = useState(() => localStorage.getItem("ddr-token") || "");
  const [currentUser, setCurrentUser] = useState(() => {
    if (!localStorage.getItem("ddr-token")) {
      return null;
    }
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
  const [palette, setPalette] = useState("Default");
  const [savedPalettes, setSavedPalettes] = useState([]);
  const [pendingDonations, setPendingDonations] = useState([]);
  const [bankingConnections, setBankingConnections] = useState([]);
  const [accountingIntegrations, setAccountingIntegrations] = useState([]);
  const [reportTemplates, setReportTemplates] = useState([]);
  const [saasSecret, setSaasSecret] = useState(null);
  const t = copy[language];
  const notifications = pendingDonations.map((donation) => ({
    id: donation.id,
    title: currency(donation.amount),
    meta: `${donation.source} - ${donation.date}`,
    body: donation.note,
    target: "donations",
  }));
  const pageTour = getPageTour(t, activeView);

  useEffect(() => {
    if (appViews.has(activeView)) {
      localStorage.setItem("weserve-active-view", activeView);
    }
  }, [activeView]);

  useEffect(() => {
    if (currentUser && activeView === "tenants" && currentUser.role !== "saas_admin") {
      setActiveView("overview");
    }
  }, [activeView, currentUser]);

  useEffect(() => {
    if (!currentUser || loading || !pageTour) {
      setTourHintActive(false);
      return;
    }

    const tourKey = `weserve-tour-${activeView}`;
    if (!localStorage.getItem(tourKey)) {
      setTourHintActive(true);
      localStorage.setItem(tourKey, "seen");
    } else {
      setTourHintActive(false);
    }
  }, [activeView, currentUser, loading, pageTour]);

  async function loadWorkspace(search = query) {
    setLoading(true);
    const [bootstrapData, dashboardData, donorData, accountData, donationData, pendingDonationData, receiptData, batchData] =
      await Promise.all([
        api("/api/bootstrap"),
        api("/api/dashboard"),
        api(`/api/donors?active=all&search=${encodeURIComponent(search)}`),
        api("/api/accounts"),
        api("/api/donations?limit=500"),
        api("/api/pending-donations"),
        api("/api/receipts"),
        api("/api/receipt-batches"),
      ]);

    const migratedBootstrapData = await migrateLocalFeatureStorage(bootstrapData);

    setBootstrap(migratedBootstrapData);
    setDashboard(dashboardData);
    setDonors(donorData);
    setAccounts(accountData);
    setDonations(donationData);
    setPendingDonations(pendingDonationData);
    setReceipts(receiptData);
    setReceiptBatches(batchData);
    setBankingConnections(migratedBootstrapData.bankingConnections || []);
    setAccountingIntegrations(migratedBootstrapData.accountingIntegrations || []);
    setReportTemplates(migratedBootstrapData.reportTemplates || []);
    setLoading(false);
  }

  async function migrateLocalFeatureStorage(bootstrapData) {
    if (!currentUser?.admin) {
      return bootstrapData;
    }

    const migratedData = { ...bootstrapData };

    const savedConnectionsRaw = localStorage.getItem("weserve-banking-connections");
    if (savedConnectionsRaw) {
      try {
        const savedConnections = JSON.parse(savedConnectionsRaw || "[]");
        if (Array.isArray(savedConnections) && savedConnections.length) {
          const existingConnections = migratedData.bankingConnections || [];
          const createdConnections = [];
          for (const connection of savedConnections) {
            const duplicate = existingConnections.some((item) => (
              item.institution === connection.institution &&
              item.accountNumber === connection.accountNumber
            ));
            if (!duplicate) {
              createdConnections.push(await api("/api/banking-connections", {
                method: "POST",
                body: JSON.stringify(connection),
              }));
            }
          }
          migratedData.bankingConnections = [...existingConnections, ...createdConnections];
        }
        localStorage.removeItem("weserve-banking-connections");
      } catch (migrationError) {
        if (migrationError instanceof SyntaxError) {
          localStorage.removeItem("weserve-banking-connections");
        }
      }
    }

    const savedTemplatesRaw = localStorage.getItem("weserve-report-templates");
    if (savedTemplatesRaw) {
      try {
        const savedTemplates = JSON.parse(savedTemplatesRaw || "[]");
        if (Array.isArray(savedTemplates) && savedTemplates.length) {
          const existingTemplates = migratedData.reportTemplates || [];
          const createdTemplates = [];
          for (const template of savedTemplates) {
            const duplicate = existingTemplates.some((item) => (
              item.title === template.title &&
              item.groupBy === template.groupBy &&
              item.type === template.type
            ));
            if (!duplicate) {
              createdTemplates.push(await api("/api/report-templates", {
                method: "POST",
                body: JSON.stringify(template),
              }));
            }
          }
          migratedData.reportTemplates = [...createdTemplates, ...existingTemplates];
        }
        localStorage.removeItem("weserve-report-templates");
      } catch (migrationError) {
        if (migrationError instanceof SyntaxError) {
          localStorage.removeItem("weserve-report-templates");
        }
      }
    }

    return migratedData;
  }

  useEffect(() => {
    if (!currentUser || !authToken) {
      setLoading(false);
      return;
    }

    loadWorkspace().catch((loadError) => {
      setError(loadError.message);
      if (loadError.message === "Authentication required") {
        clearSession();
      }
      setLoading(false);
    });
  }, [authToken, currentUser?.utilisateurID]);

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
      setAuthToken(result.token);
      setLanguage(result.user.langue || "en");
      localStorage.setItem("ddr-user", JSON.stringify(result.user));
      localStorage.setItem("ddr-token", result.token);
      showNotice(t.alerts.loggedIn);
    } catch (loginError) {
      showError(loginError.message);
    }
  }

  async function handleRegister(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const result = await api("/api/auth/register", {
        method: "POST",
        body: JSON.stringify({ ...data, langue: language }),
      });
      setCurrentUser(result.user);
      setAuthToken(result.token);
      setLanguage(result.user.langue || "en");
      localStorage.setItem("ddr-user", JSON.stringify(result.user));
      localStorage.setItem("ddr-token", result.token);
      showNotice(t.alerts.workspaceCreated);
    } catch (registerError) {
      showError(registerError.message);
    }
  }

  async function handleForgotPassword(email) {
    const result = await api("/api/auth/forgot-password", {
      method: "POST",
      body: JSON.stringify({ email }),
    });
    return result.message || t.alerts.forgot;
  }

  function clearSession() {
    localStorage.removeItem("ddr-user");
    localStorage.removeItem("ddr-token");
    localStorage.removeItem("weserve-active-view");
    setAuthToken("");
    setCurrentUser(null);
    setActiveView("overview");
    setQuery("");
  }

  async function logout() {
    await api("/api/auth/logout", { method: "POST" }).catch(() => {});
    clearSession();
  }

  async function handleAddDonor(event) {
    event.preventDefault();
    const form = event.currentTarget;
    try {
      const data = formObject(form);
      const createdDonor = await api("/api/donors", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          membre: data.membre === "on",
          recu: data.recu === "on",
        }),
      });
      form.reset();
      if (createdDonor?.donateurID) {
        setDonors((currentDonors) => [
          ...currentDonors.filter((donor) => donor.donateurID !== createdDonor.donateurID),
          createdDonor,
        ].sort((left, right) => Number(left.numero) - Number(right.numero)));
      }
      showNotice(t.donorForm.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function archiveDonor(donor, actif) {
    try {
      const updatedDonor = await api(`/api/donors/${donor.donateurID}/archive`, {
        method: "PATCH",
        body: JSON.stringify({ actif }),
      });
      setDonors((currentDonors) => currentDonors.map((item) => (
        item.donateurID === donor.donateurID ? { ...item, ...updatedDonor, actif } : item
      )));
      await refresh(actif ? t.donorForm.reactivated : t.donorForm.archived);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function deleteDonor(donor) {
    try {
      await api(`/api/donors/${donor.donateurID}`, { method: "DELETE" });
      setDonors((currentDonors) => currentDonors.filter((item) => item.donateurID !== donor.donateurID));
      showNotice(t.donorForm.deleted);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function updateDonor(donor, data) {
    try {
      await api(`/api/donors/${donor.donateurID}`, {
        method: "PUT",
        body: JSON.stringify({
          ...data,
          actif: donor.actif !== false,
          membre: data.membre === "on",
          recu: data.recu === "on",
        }),
      });
      await refresh(t.donorForm.updated);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleAddAccount(event) {
    event.preventDefault();
    const form = event.currentTarget;
    try {
      const data = formObject(form);
      if (accounts.some((account) => account.noCompte === Number(data.noCompte))) {
        showError(t.accounts.duplicate);
        return;
      }

      const createdAccount = await api("/api/accounts", {
        method: "POST",
        body: JSON.stringify({ ...data, recu: data.recu === "on" }),
      });
      form.reset();
      setAccounts((currentAccounts) => [...currentAccounts.filter((account) => account.compteID !== createdAccount.compteID), createdAccount].sort((left, right) => left.noCompte - right.noCompte));
      showNotice(t.accounts.success);
      return createdAccount;
    } catch (saveError) {
      showError(saveError.message);
      return null;
    }
  }

  async function handleUpdateAccount(account, data) {
    try {
      await api(`/api/accounts/${account.compteID}`, {
        method: "PUT",
        body: JSON.stringify({
          ...account,
          ...data,
          noCompte: Number(data.noCompte),
          recu: data.recu === "on" || data.recu === true,
        }),
      });
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
    try {
      await api(`/api/accounts/${account.compteID}`, { method: "DELETE" });
      await refresh(t.accounts.deleted);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleAddDonation(event) {
    event.preventDefault();
    const form = event.currentTarget;
    try {
      const data = formObject(form);
      const createdDonation = await api("/api/donations", {
        method: "POST",
        body: JSON.stringify(data),
      });
      form.reset();
      if (createdDonation?.donID) {
        setDonations((currentDonations) => [
          createdDonation,
          ...currentDonations.filter((donation) => donation.donID !== createdDonation.donID),
        ]);
      }
      showNotice(t.donationForm.success);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleUpdateDonation(donation, data) {
    try {
      await api(`/api/donations/${donation.donID}`, {
        method: "PUT",
        body: JSON.stringify(data),
      });
      await refresh(t.donationForm.updated);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
    }
  }

  async function handleCategorizePendingDonation(pendingDonation, data) {
    try {
      const result = await api(`/api/pending-donations/${encodeURIComponent(pendingDonation.id)}/categorize`, {
        method: "POST",
        body: JSON.stringify({
          donateurID: data.donateurID,
          numero: data.numero,
          compteID: data.compteID,
        }),
      });
      setPendingDonations(result.pending);
      await loadWorkspace(query);
      showNotice(t.donationForm.categorizeSuccess);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function deleteDonation(donation) {
    try {
      await api(`/api/donations/${donation.donID}`, { method: "DELETE" });
      await refresh(t.donationForm.deleted);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
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
      const message = result.count
        ? `${t.receipts.generated} ${result.count}`
        : t.receipts.noEligibleRows;
      await refresh(message);
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
      await refresh(t.receipts.statusUpdated);
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
      showNotice(t.reports.refreshed);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreateBankingConnection(data) {
    try {
      const createdConnection = await api("/api/banking-connections", {
        method: "POST",
        body: JSON.stringify(data),
      });
      setBankingConnections((currentConnections) => [...currentConnections, createdConnection]);
      await refresh(t.banking.connected);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
    }
  }

  async function handleCreateAccountingIntegration(data) {
    try {
      const createdIntegration = await api("/api/accounting-integrations", {
        method: "POST",
        body: JSON.stringify(data),
      });
      setAccountingIntegrations((currentIntegrations) => [...currentIntegrations, createdIntegration]);
      await refresh(t.banking.accountingConnected);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
    }
  }

  async function handleSyncAccountingIntegration(integration) {
    try {
      const result = await api(`/api/accounting-integrations/${integration.integrationID}/sync`, {
        method: "POST",
      });
      setAccountingIntegrations((currentIntegrations) => currentIntegrations.map((item) => (
        item.integrationID === result.integration.integrationID ? result.integration : item
      )));
      showNotice(t.banking.accountingSynced.replace("{count}", result.syncedCount).replace("{total}", currency(result.total)));
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreateReportTemplate(data) {
    try {
      const createdTemplate = await api("/api/report-templates", {
        method: "POST",
        body: JSON.stringify(data),
      });
      setReportTemplates((currentTemplates) => [createdTemplate, ...currentTemplates]);
      await refresh(t.reports.templateSaved);
      return createdTemplate;
    } catch (saveError) {
      showError(saveError.message);
      return null;
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

  async function handleUpdateSubscription(planID, billingCycle = "monthly") {
    try {
      await api("/api/subscription", {
        method: "PATCH",
        body: JSON.stringify({ planID, billingCycle }),
      });
      await refresh(t.saas.planChanged);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreatePaymentMethod(event) {
    event.preventDefault();
    try {
      await api("/api/payment-methods", {
        method: "POST",
        body: JSON.stringify(formObject(event.currentTarget)),
      });
      event.currentTarget.reset();
      await refresh(t.saas.paymentAdded);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
    }
  }

  async function handleDeletePaymentMethod(paymentMethod) {
    try {
      await api(`/api/payment-methods/${paymentMethod.paymentMethodID}`, { method: "DELETE" });
      await refresh(t.saas.paymentDeleted);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleUpdateSecuritySettings(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/security-settings", {
        method: "PATCH",
        body: JSON.stringify({
          ...data,
          mfaRequired: data.mfaRequired === "on",
        }),
      });
      await refresh(t.saas.securitySaved);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreateApiKey(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const apiKey = await api("/api/api-keys", {
        method: "POST",
        body: JSON.stringify({
          label: data.label,
          scopes: String(data.scopes || "").split(",").map((scope) => scope.trim()).filter(Boolean),
        }),
      });
      event.currentTarget.reset();
      await refresh(t.saas.apiKeyCreated);
      setSaasSecret({ type: "api", label: apiKey.label, secret: apiKey.secret });
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleRevokeApiKey(apiKey) {
    try {
      await api(`/api/api-keys/${apiKey.apiKeyID}`, { method: "DELETE" });
      await refresh(t.saas.apiKeyRevoked);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreateWebhook(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const webhook = await api("/api/webhooks", {
        method: "POST",
        body: JSON.stringify({
          url: data.url,
          events: String(data.events || "").split(",").map((eventName) => eventName.trim()).filter(Boolean),
        }),
      });
      event.currentTarget.reset();
      await refresh(t.saas.webhookCreated);
      setSaasSecret({ type: "webhook", label: webhook.url, secret: webhook.secret });
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleDeleteWebhook(webhook) {
    try {
      await api(`/api/webhooks/${webhook.webhookID}`, { method: "DELETE" });
      await refresh(t.saas.webhookDeleted);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleTestWebhook(webhook) {
    try {
      await api(`/api/webhooks/${webhook.webhookID}/test`, { method: "POST" });
      await refresh(t.saas.webhookTested);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleToggleOnboardingTask(task) {
    try {
      await api(`/api/onboarding/${task.taskKey}`, {
        method: "PATCH",
        body: JSON.stringify({ completed: !task.completed }),
      });
      await loadWorkspace();
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
          membre: Boolean(bootstrap?.organisme?.membre),
        }),
      });
      await refresh(t.settings.saved);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleCreateUser(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/users", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          admin: data.role === "org_admin" || data.role === "saas_admin",
          actif: true,
          langue: language,
        }),
      });
      event.currentTarget.reset();
      await refresh(t.settings.userAdded);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function handleUpdateUser(userAccount, event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      const updatedUser = await api(`/api/users/${userAccount.utilisateurID}`, {
        method: "PATCH",
        body: JSON.stringify({
          ...data,
          admin: data.role === "org_admin" || data.role === "saas_admin",
        }),
      });

      if (updatedUser.utilisateurID === currentUser?.utilisateurID) {
        const nextUser = { ...currentUser, ...updatedUser };
        setCurrentUser(nextUser);
        localStorage.setItem("ddr-user", JSON.stringify(nextUser));
      }

      await refresh(t.settings.userUpdated);
      return true;
    } catch (saveError) {
      showError(saveError.message);
      return false;
    }
  }

  async function toggleUser(userAccount) {
    try {
      await api(`/api/users/${userAccount.utilisateurID}/status`, {
        method: "PATCH",
        body: JSON.stringify({
          actif: !userAccount.actif,
          role: userAccount.role || (userAccount.admin ? "org_admin" : "viewer"),
        }),
      });
      await refresh(t.settings.userUpdated);
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
        api(`/api/donors?active=all&search=${encodeURIComponent(value)}`),
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
    localStorage.setItem("weserve-active-view", view);
    setActiveView(view);
    setMobileOpen(false);
    setQuickActionsOpen(false);
    setTourHintActive(false);
  }

  function handleNotificationSelect(notification) {
    openView(notification.target);
  }

  function launchPageTour() {
    setQuickActionsOpen(false);
    setTourHintActive(false);
    if (pageTour) {
      setActiveTour(pageTour);
      localStorage.setItem(`weserve-tour-${activeView}`, "seen");
    }
  }

  function dismissTourHint() {
    setTourHintActive(false);
    localStorage.setItem(`weserve-tour-${activeView}`, "seen");
  }

  function handleSavePalette(customPalette) {
    setSavedPalettes((currentPalettes) => {
      const paletteId = customPalette.id || `custom-${Date.now()}`;
      const nextPalette = { ...customPalette, id: paletteId };
      return [
        nextPalette,
        ...currentPalettes.filter((item) => item.id !== paletteId && item.name !== customPalette.name),
      ];
    });
    setPalette(customPalette.id || customPalette.name);
    showNotice(t.customization.savedSuccess);
  }

  const activeOrg = bootstrap?.organisme;
  const displayUser = currentUser || bootstrap?.user;
  const isPublicGivingPage = window.location.pathname.startsWith("/give");

  if (isPublicGivingPage) {
    return (
      <PublicDonationPortal
        language={language}
        onLanguageChange={setLanguage}
        t={t}
      />
    );
  }

  if (!currentUser) {
    return (
      <LoginScreen
        error={error}
        language={language}
        onForgotPassword={handleForgotPassword}
        onLanguageChange={setLanguage}
        onLogin={handleLogin}
        onRegister={handleRegister}
        t={t}
      />
    );
  }

  return (
    <div className="app-shell">
      <aside className={`sidebar ${mobileOpen ? "is-open" : ""}`}>
        <div className="brand">
          <span className="brand-wordmark">{t.product}</span>
          <button className="icon-button mobile-close" type="button" onClick={() => setMobileOpen(false)} aria-label={t.common.closeMenu}>
            <X size={18} />
          </button>
        </div>

        <div className="tenant-card">
          <Building2 size={18} />
          <div>
            <span>{activeOrg?.organisme || displayUser?.organisme || t.product}</span>
            <small>{t.overview.period}</small>
          </div>
        </div>

        <nav className="sidebar-nav" aria-label="Primary">
          {navItems.filter((item) => !item.saasOnly || displayUser?.role === "saas_admin").map((item) => {
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
            <span>{t.common.support}</span>
          </button>
          <button className={activeView === "settings" ? "ghost-button active" : "ghost-button"} type="button" onClick={() => openView("settings")}>
            <Settings size={16} />
            <span>{t.common.settings}</span>
          </button>
        </div>
      </aside>

      <main className="workspace">
        <Topbar
          language={language}
          onLanguageChange={setLanguage}
          onMenuClick={() => setMobileOpen(true)}
          notifications={notifications}
          onNotificationSelect={handleNotificationSelect}
          onProfileClick={() => openView("settings")}
          onLogout={logout}
          pendingDonationCount={pendingDonations.length}
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

        {loading && <div className="loading-state">{t.overview.loading}</div>}

        {!loading && activeView === "overview" && (
          <Overview
            accounts={accounts}
            donations={donations}
            donors={donors}
            pendingDonations={pendingDonations}
            receipts={receipts}
            t={t}
            onCategorizePending={handleCategorizePendingDonation}
            onViewChange={openView}
          />
        )}
        {!loading && activeView === "donations" && (
          <Donations
            accounts={accounts}
            bankingConnections={bankingConnections}
            bootstrap={bootstrap}
            donations={donations}
            donors={donors}
            language={language}
            pendingDonations={pendingDonations}
            t={t}
            onCategorizePending={handleCategorizePendingDonation}
            onDelete={deleteDonation}
            onSubmit={handleAddDonation}
            onUpdate={handleUpdateDonation}
          />
        )}
        {!loading && activeView === "donors" && (
          <Donors
            bootstrap={bootstrap}
            donations={donations}
            donors={donors}
            query={query}
            setQuery={setQuery}
            t={t}
            onArchive={archiveDonor}
            onDelete={deleteDonor}
            onSearch={handleSearch}
            onSubmit={handleAddDonor}
            onUpdate={updateDonor}
          />
        )}
        {!loading && activeView === "accounts" && (
          <Accounts
            accounts={accounts}
            donations={donations}
            t={t}
            onDelete={deleteAccount}
            onSubmit={handleAddAccount}
            onToggle={toggleAccount}
            onUpdate={handleUpdateAccount}
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
            customTemplates={reportTemplates}
            onCreateTemplate={handleCreateReportTemplate}
            reportResult={reportResult}
            t={t}
            onRunReport={handleRunReport}
          />
        )}
        {!loading && activeView === "banking" && (
          <BankingView
            accounts={accounts}
            linkedAccounts={bankingConnections}
            onCreateConnection={handleCreateBankingConnection}
            t={t}
          />
        )}
        {!loading && activeView === "integrations" && (
          <IntegrationsView
            accountingIntegrations={accountingIntegrations}
            onCreateAccountingIntegration={handleCreateAccountingIntegration}
            onSyncAccountingIntegration={handleSyncAccountingIntegration}
            t={t}
          />
        )}
        {!loading && activeView === "subscription" && (
          <Subscription
            saas={bootstrap?.saas}
            member={member}
            setMember={setMember}
            subscriptionAnswer={subscriptionAnswer}
            setSubscriptionAnswer={setSubscriptionAnswer}
            t={t}
            onPlanChange={handleUpdateSubscription}
            onSubmit={handleSubscription}
            onToggleTask={handleToggleOnboardingTask}
          />
        )}
        {!loading && activeView === "customization" && (
          <CustomizationView
            palette={palette}
            savedPalettes={savedPalettes}
            onSavePalette={handleSavePalette}
            setPalette={setPalette}
            t={t}
          />
        )}
        {!loading && activeView === "tenants" && displayUser?.role === "saas_admin" && (
          <TenantsView
            tenants={bootstrap?.platformTenants || []}
            t={t}
          />
        )}
        {!loading && activeView === "settings" && (
          <SettingsView
            bootstrap={bootstrap}
            saasSecret={saasSecret}
            setSaasSecret={setSaasSecret}
            t={t}
            user={displayUser}
            onCustomize={() => openView("customization")}
            onCreateApiKey={handleCreateApiKey}
            onCreatePaymentMethod={handleCreatePaymentMethod}
            onCreateWebhook={handleCreateWebhook}
            onCreateUser={handleCreateUser}
            onDeletePaymentMethod={handleDeletePaymentMethod}
            onDeleteWebhook={handleDeleteWebhook}
            onRevokeApiKey={handleRevokeApiKey}
            onTestWebhook={handleTestWebhook}
            onUpdateSecurity={handleUpdateSecuritySettings}
            onUpdateUser={handleUpdateUser}
            onSubmit={handleUpdateOrganization}
            onUserStatus={toggleUser}
          />
        )}
        {!loading && activeView === "support" && (
          <SupportView
            t={t}
            onViewChange={openView}
          />
        )}
      </main>

      {!loading && (
        <QuickActionLauncher
          hasPageTour={Boolean(pageTour)}
          isHintActive={tourHintActive}
          isOpen={quickActionsOpen}
          onHelp={launchPageTour}
          onToggle={() => setQuickActionsOpen((open) => !open)}
          onViewChange={openView}
          t={t}
        />
      )}
      {tourHintActive && <button className="tour-hint-scrim" type="button" aria-label={t.common.cancel} onClick={dismissTourHint} />}
      {activeTour && (
        <PageTourOverlay
          steps={activeTour.steps}
          subtitle={activeTour.subtitle}
          title={activeTour.title}
          doneLabel={t.donorForm.tourDone}
          onClose={() => setActiveTour(null)}
        />
      )}
    </div>
  );
}

function LoginScreen({ error, language, onForgotPassword, onLanguageChange, onLogin, onRegister, t }) {
  const [forgotOpen, setForgotOpen] = useState(false);
  const [signupOpen, setSignupOpen] = useState(false);
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
            {t.overview.facts.map((fact) => (
              <span key={fact}><Check size={16} /> {fact}</span>
            ))}
          </div>
        </div>

        <div className="login-panel">
          <span className="login-wordmark">{t.product}</span>
          <div className="login-panel-title">
            <h2>{t.overview.loginTitle}</h2>
            <button className="language-toggle dark" type="button" onClick={() => onLanguageChange(language === "en" ? "fr" : "en")}>
              {language === "en" ? "FR" : "EN"}
            </button>
          </div>
          <p>{t.overview.loginHelp}</p>
          {error && <div className="inline-error">{error}</div>}
          <form className="login-form" onSubmit={onLogin}>
            <label>
              {t.common.email}
              <input name="email" type="email" defaultValue="admin@ddr.local" required />
            </label>
            <label>
              {t.common.password}
              <input name="password" type="password" defaultValue="password" required />
            </label>
            <button className="light-button" type="submit">
              <LockKeyhole size={16} />
              <span>{t.common.login}</span>
            </button>
          </form>
          <button className="link-button light-link" type="button" onClick={() => setForgotOpen((open) => !open)}>
            {t.overview.forgot}
          </button>
          {forgotOpen && (
            <div className="forgot-form">
              <label>
                {t.common.email}
                <input name="forgotEmail" type="email" value={forgotEmail} onChange={(event) => setForgotEmail(event.target.value)} required />
              </label>
              <button className="light-button" type="button" onClick={submitForgotPassword}>
                <Mail size={16} />
                <span>{t.common.sendReset}</span>
              </button>
              {forgotStatus && <div className="inline-hint">{forgotStatus}</div>}
            </div>
          )}
          <button className="link-button light-link" type="button" onClick={() => setSignupOpen((open) => !open)}>
            {t.common.createWorkspace}
          </button>
          {signupOpen && (
            <form className="forgot-form signup-form" onSubmit={onRegister}>
              <label>
                {t.subscription.charityName}
                <input name="organisme" required maxLength="150" placeholder="Grace Community Church" />
              </label>
              <label>
                {t.subscription.registrationNumber}
                <input name="enregistrement" required maxLength="30" placeholder="123456789RR0001" />
              </label>
              <label>
                {t.donorForm.firstName}
                <input name="prenom" required maxLength="50" />
              </label>
              <label>
                {t.donorForm.lastName}
                <input name="nom" required maxLength="50" />
              </label>
              <label>
                {t.common.admin} {t.common.email.toLowerCase()}
                <input name="email" required type="email" />
              </label>
              <label>
                {t.common.password}
                <input name="password" required minLength="8" type="password" />
              </label>
              <label>
                {t.subscription.city}
                <input name="ville" maxLength="50" />
              </label>
              <label>
                {t.subscription.phone}
                <input name="telephone" maxLength="30" />
              </label>
              <button className="light-button" type="submit">
                <Building2 size={16} />
                <span>{t.common.startWorkspace}</span>
              </button>
            </form>
          )}
        </div>
      </section>
    </main>
  );
}

function PublicDonationPortal({ language, onLanguageChange, t }) {
  const params = new URLSearchParams(window.location.search);
  const [organizationID, setOrganizationID] = useState(params.get("org") || params.get("tenant") || "1");
  const [donorNumber, setDonorNumber] = useState(params.get("donor") || params.get("donorNumber") || "");
  const [portal, setPortal] = useState(null);
  const [amount, setAmount] = useState("50");
  const [confirmation, setConfirmation] = useState(null);
  const [loadingPortal, setLoadingPortal] = useState(true);
  const [portalError, setPortalError] = useState("");

  async function loadPortal(nextDonorNumber = donorNumber) {
    setLoadingPortal(true);
    setPortalError("");
    try {
      const portalParams = new URLSearchParams({ org: organizationID || "1" });
      if (nextDonorNumber) {
        portalParams.set("donor", nextDonorNumber);
      }
      const result = await api(`/api/public/donation-portal?${portalParams.toString()}`);
      setPortal(result);
      setDonorNumber(nextDonorNumber);
      const nextUrl = `/give?${portalParams.toString()}`;
      window.history.replaceState({}, "", nextUrl);
    } catch (loadError) {
      setPortalError(loadError.message);
    } finally {
      setLoadingPortal(false);
    }
  }

  useEffect(() => {
    loadPortal(donorNumber);
  }, []);

  async function submitLookup(event) {
    event.preventDefault();
    if (!donorNumber.trim()) {
      setPortalError(t.giving.lookupError);
      return;
    }
    setConfirmation(null);
    await loadPortal(donorNumber.trim());
  }

  async function submitDonation(event) {
    event.preventDefault();
    setPortalError("");
    try {
      const data = formObject(event.currentTarget);
      const result = await api("/api/public/donation-portal/checkout", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          org: organizationID || "1",
          donorNumber: portal?.donor?.donorNumber || donorNumber,
          amount,
        }),
      });
      setConfirmation(result.confirmation);
    } catch (paymentError) {
      setPortalError(paymentError.message);
    }
  }

  const organizationName = portal?.organization?.name || t.product;
  const gatewayMode = portal?.gateway?.mode === "live" ? t.giving.liveMode : t.giving.testMode;

  return (
    <main className="public-donation-screen">
      <section className="public-donation-shell">
        <div className="public-donation-hero">
          <span className="eyebrow"><Wallet size={15} /> {t.giving.title}</span>
          <h1>{t.giving.publicTitle.replace("{organization}", organizationName)}</h1>
          <p>{t.giving.publicSubtitle}</p>
          <div className="login-facts">
            <span><CreditCard size={16} /> {t.giving.gatewayStatus}: {gatewayMode}</span>
            <span><Check size={16} /> {t.giving.thankYou}</span>
          </div>
        </div>

        <div className="public-donation-card">
          <div className="login-panel-title">
            <h2>{portal?.donor ? portal.donor.fullName : t.giving.donorLookup}</h2>
            <button className="language-toggle dark" type="button" onClick={() => onLanguageChange(language === "en" ? "fr" : "en")}>
              {language === "en" ? "FR" : "EN"}
            </button>
          </div>

          {loadingPortal && <div className="loading-state">{t.overview.loading}</div>}
          {portalError && <div className="inline-error">{portalError}</div>}

          {!loadingPortal && !confirmation && (
            <>
              <form className="public-donor-lookup" onSubmit={submitLookup}>
                <label>
                  {t.donationForm.donorNumber}
                  <input name="donorNumber" value={donorNumber} onChange={(event) => setDonorNumber(event.target.value)} placeholder="1" required />
                </label>
                <label>
                  Organization
                  <input name="org" value={organizationID} onChange={(event) => setOrganizationID(event.target.value)} required />
                </label>
                <button className="secondary-button compact" type="submit">
                  <Search size={15} />
                  <span>{t.giving.donorLookup}</span>
                </button>
              </form>
              <p className="inline-hint">{t.giving.donorNumberHelp}</p>
            </>
          )}

          {!loadingPortal && portal?.donor && !confirmation && (
            <form className="public-donation-form" onSubmit={submitDonation}>
              <div className="public-donor-summary">
                <span className="status-pill issued">{t.common.active}</span>
                <strong>{portal.donor.donorNumber} - {portal.donor.fullName}</strong>
                <small>{portal.organization.registrationNumber}</small>
              </div>

              <label>
                {t.giving.fund}
                <select name="compteID" required defaultValue={portal.accounts[0]?.compteID || ""}>
                  {portal.accounts.map((account) => (
                    <option value={account.compteID} key={account.compteID}>
                      {account.noCompte} - {account.nom}
                    </option>
                  ))}
                </select>
              </label>

              <label>
                {t.donationForm.amount}
                <input name="amount" required min="1" step="0.01" type="number" value={amount} onChange={(event) => setAmount(event.target.value)} />
              </label>

              <div className="suggested-amounts" aria-label={t.giving.suggested}>
                {portal.suggestedAmounts.map((suggestedAmount) => (
                  <button className={Number(amount) === suggestedAmount ? "active" : ""} type="button" key={suggestedAmount} onClick={() => setAmount(String(suggestedAmount))}>
                    {currency(suggestedAmount)}
                  </button>
                ))}
              </div>

              <label>
                {t.giving.donorEmail}
                <input name="donorEmail" type="email" defaultValue={portal.donor.email || ""} />
              </label>
              <label>
                {t.giving.note}
                <input name="note" placeholder={t.giving.notePlaceholder} />
              </label>

              <button className="primary-button form-submit" type="submit">
                <CreditCard size={17} />
                <span>{t.giving.pay}</span>
              </button>
            </form>
          )}

          {confirmation && (
            <div className="public-confirmation-card" role="status">
              <CheckCircle2 size={34} />
              <h2>{t.giving.confirmationTitle}</h2>
              <p>{t.giving.confirmationBody}</p>
              <dl className="banking-detail-list">
                <div>
                  <dt>{t.giving.confirmationNumber}</dt>
                  <dd>{confirmation.confirmationNumber}</dd>
                </div>
                <div>
                  <dt>{t.donationForm.amount}</dt>
                  <dd>{currency(confirmation.amount)}</dd>
                </div>
                <div>
                  <dt>{t.giving.fund}</dt>
                  <dd>{confirmation.account}</dd>
                </div>
                <div>
                  <dt>{t.giving.receiptStatus}</dt>
                  <dd>{confirmation.receiptStatus}</dd>
                </div>
                <div>
                  <dt>{t.giving.sentTo}</dt>
                  <dd>{confirmation.donorEmail || confirmation.donor}</dd>
                </div>
              </dl>
              <button className="secondary-button compact" type="button" onClick={() => setConfirmation(null)}>
                <Plus size={15} />
                <span>{t.donationForm.add}</span>
              </button>
            </div>
          )}
        </div>
      </section>
    </main>
  );
}

function Topbar({ language, notifications = [], onLanguageChange, onLogout, onMenuClick, onNotificationSelect, onProfileClick, onSearch, pendingDonationCount = 0, query, t, user }) {
  const [notificationsOpen, setNotificationsOpen] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);

  function selectNotification(notification) {
    onNotificationSelect(notification);
    setNotificationsOpen(false);
  }

  function openAccountSettings() {
    onProfileClick();
    setProfileOpen(false);
  }

  return (
    <header className="topbar">
      <button className="icon-button menu-button" type="button" onClick={onMenuClick} aria-label={t.common.openMenu}>
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
        <div className="notification-menu">
          <button
            className="icon-button notification-button"
            type="button"
            aria-expanded={notificationsOpen}
            aria-label={t.banking.pendingNotification.replace("{count}", pendingDonationCount)}
            onClick={() => {
              setNotificationsOpen((open) => !open);
              setProfileOpen(false);
            }}
          >
            <Bell size={18} />
            {pendingDonationCount > 0 && <span>{pendingDonationCount}</span>}
          </button>
          {notificationsOpen && (
            <div className="notification-dropdown">
              <div className="notification-dropdown-header">
                <strong>{t.common.allNotifications}</strong>
                <small>{t.banking.pendingNotification.replace("{count}", pendingDonationCount)}</small>
              </div>
              <div className="notification-list">
                {notifications.length ? notifications.map((notification) => (
                  <button
                    className="notification-item"
                    type="button"
                    key={notification.id}
                    onClick={() => selectNotification(notification)}
                  >
                    <span className="status-pill pending">{t.common.pending}</span>
                    <strong>{notification.title}</strong>
                    <small>{notification.meta}</small>
                    <p>{notification.body}</p>
                  </button>
                )) : (
                  <div className="notification-empty">{t.common.noNotifications}</div>
                )}
              </div>
            </div>
          )}
        </div>
        <div className="profile-menu">
          <button
            className="profile-chip"
            type="button"
            onClick={() => {
              setProfileOpen((open) => !open);
              setNotificationsOpen(false);
            }}
            aria-expanded={profileOpen}
            aria-label={t.common.accountSettings}
          >
            <img src={demoUserAvatar} alt="" />
            <div>
              <strong>{user?.prenom || "Admin"}</strong>
              <small>{user?.admin ? t.common.admin : t.common.user}</small>
            </div>
            <ChevronDown size={16} />
          </button>
          {profileOpen && (
            <div className="profile-dropdown">
              <div className="profile-dropdown-header">
                <img className="profile-dropdown-avatar" src={demoUserAvatar} alt="" />
                <div>
                  <strong>{`${user?.prenom || ""} ${user?.nom || ""}`.trim() || "Admin"}</strong>
                  <small>{user?.courriel || user?.email || "-"}</small>
                </div>
              </div>
              <button type="button" onClick={openAccountSettings}>
                <Settings size={16} />
                <span>{t.common.accountSettings}</span>
              </button>
              <button type="button" onClick={onLogout}>
                <LockKeyhole size={16} />
                <span>{t.common.logout}</span>
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}

function Overview({ accounts, donations, donors, pendingDonations, receipts, t, onCategorizePending, onViewChange }) {
  const [categorizingDonationId, setCategorizingDonationId] = useState(null);
  const [showAllPending, setShowAllPending] = useState(false);
  const currentYear = String(new Date().getFullYear());
  const ytdDonations = donations.filter((donation) => String(donation.dateDon || "").startsWith(currentYear));
  const ytdTotal = ytdDonations.reduce((sum, donation) => sum + Number(donation.montant || 0), 0);
  const pendingReceipts = donations.filter((donation) => donation.receiptStatus === "Ready").length;
  const monthlyMap = ytdDonations.reduce((months, donation) => {
    const month = String(donation.dateDon || "").slice(0, 7);
    if (!month) {
      return months;
    }

    months.set(month, (months.get(month) || 0) + Number(donation.montant || 0));
    return months;
  }, new Map());
  const monthly = Array.from(monthlyMap, ([month, amount]) => ({ month, amount })).sort((left, right) => left.month.localeCompare(right.month));
  const today = new Date();
  const currentMonthKey = today.toISOString().slice(0, 7);
  const currentMonthGiving = monthly.find((item) => item.month === currentMonthKey)?.amount || 0;
  const daysInMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0).getDate();
  const currentDay = today.getDate();
  const monthProgress = Math.min(100, Math.round((currentDay / daysInMonth) * 100));
  const annualMonthlyAverage = monthly.length ? ytdTotal / monthly.length : 0;
  const monthlyAverageProgress = annualMonthlyAverage ? Math.round((currentMonthGiving / annualMonthlyAverage) * 100) : 0;
  const monthlyAverageFill = Math.min(monthlyAverageProgress, 100);
  const monthlyAverageOverTarget = monthlyAverageProgress > 100;
  const metrics = [
    { label: t.metrics[0], value: currency(ytdTotal), trend: `${ytdDonations.length} ${t.donationForm.ytdDonations}`, tone: "green" },
    { label: t.metrics[2], value: String(donors.filter((donor) => donor.actif).length), trend: t.common.active, tone: "blue" },
    { label: t.banking.newDonations, value: String(pendingDonations.length), trend: t.common.pending, tone: "amber", icon: Bell },
  ];
  const maxMonth = Math.max(...monthly.map((item) => item.amount), 1);
  const readyPercent = pendingReceipts ? Math.max(0, Math.round(((donations.length - pendingReceipts) / donations.length) * 100)) : 100;

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

      <article className="monthly-giving-card">
        <div className="monthly-giving-header">
          <div className="monthly-giving-copy">
            <span>{t.overview.monthlyGivingSoFar}</span>
            <strong>{currency(currentMonthGiving)}</strong>
            <small>{t.overview.currentMonth}</small>
          </div>
          <button className="secondary-button monthly-giving-report" type="button" onClick={() => onViewChange("reports")}>
            <BarChart3 size={17} />
            <span>{t.actions[3]}</span>
          </button>
        </div>
        <div className="monthly-giving-progress">
          <div className="monthly-giving-progress-block">
            <div className="monthly-giving-progress-meta">
              <span>{monthProgress}% {t.overview.monthElapsed}</span>
              <strong>{t.overview.dayProgress} {currentDay} / {daysInMonth}</strong>
            </div>
            <div className="monthly-giving-track" aria-label={`${monthProgress}% ${t.overview.monthElapsed}`}>
              <span style={{ width: `${monthProgress}%` }} />
            </div>
          </div>
          <div className="monthly-giving-progress-block">
            <div className="monthly-giving-progress-meta">
              <span>{monthlyAverageProgress}% {t.overview.annualAverageProgress}</span>
              <strong>{t.overview.monthlyAverage}: {currency(annualMonthlyAverage)}</strong>
            </div>
            <div
              className={`monthly-giving-track is-average ${monthlyAverageOverTarget ? "is-over-target" : ""}`}
              aria-label={`${monthlyAverageProgress}% ${t.overview.annualAverageProgress}`}
            >
              <span style={{ width: `${monthlyAverageFill}%` }} />
            </div>
          </div>
        </div>
      </article>

      <div className="metric-grid overview-metric-grid">
        {metrics.map((metric) => (
          <article className={`metric-card tone-${metric.tone}`} key={metric.label}>
            <span className="metric-card-title">
              {metric.icon && <metric.icon size={17} />}
              <span>{metric.label}</span>
            </span>
            <strong>{metric.value}</strong>
            <small>{metric.trend}</small>
          </article>
        ))}
      </div>

      {pendingDonations.length > 0 && (
        <section className={`pending-donations-band ${showAllPending ? "is-open" : ""} ${categorizingDonationId ? "has-categorizing" : ""}`}>
          <div className="pending-donations-header">
            <div>
              <span className="eyebrow"><Bell size={15} /> {t.common.pending}</span>
              <h2>{t.banking.newDonations}</h2>
              <p className="panel-copy">{t.banking.newDonationHelp}</p>
            </div>
            <button className="secondary-button compact pending-toggle" type="button" onClick={() => setShowAllPending((isOpen) => !isOpen)} aria-expanded={showAllPending}>
              <ChevronDown size={15} />
              <span>{showAllPending ? t.donationForm.collapsePending : `${t.donationForm.showAllPending} (${pendingDonations.length})`}</span>
            </button>
          </div>
          {showAllPending && (
            <div className="incoming-donation-list">
              {pendingDonations.map((donation) => {
                const detectedDonor = donors.find((donor) => donor.numero === donation.donorNumber);
                const isCategorizing = categorizingDonationId === donation.id;

                return (
                  <article className={`incoming-donation ${isCategorizing ? "is-categorizing" : ""}`} key={donation.id}>
                    <div className="incoming-donation-summary">
                      <div>
                        <span className="status-pill pending">{t.common.pending}</span>
                        <strong>{currency(donation.amount)}</strong>
                        <small>{donation.source} • {donation.date} • {donation.methodLabel}</small>
                        <p>{donation.note}</p>
                        <p className="detected-donor">
                          {t.donationForm.detectedDonor}: {detectedDonor?.fullName || donation.donorNumber}
                        </p>
                      </div>
                      <button
                        className="categorize-chip-button"
                        type="button"
                        onClick={() => setCategorizingDonationId(isCategorizing ? null : donation.id)}
                        aria-label={t.banking.categorize}
                        title={t.banking.categorize}
                      >
                        <Link2 size={14} />
                        <span>{t.banking.categorize}</span>
                      </button>
                    </div>
                    {isCategorizing && (
                      <CategorizeDonationForm
                        accounts={accounts}
                        detectedDonor={detectedDonor}
                        donation={donation}
                        donors={donors}
                        onSubmit={(data) => {
                          onCategorizePending(donation, data);
                          setCategorizingDonationId(null);
                        }}
                        t={t}
                      />
                    )}
                  </article>
                );
              })}
            </div>
          )}
        </section>
      )}

      <div className="two-column">
        <Panel
          title={t.overview.recentDonations}
          icon={CircleDollarSign}
          action={(
            <button className="secondary-button compact" type="button" onClick={() => onViewChange("donations")}>
              <span>{t.common.seeAll}</span>
              <ChevronRight size={15} />
            </button>
          )}
        >
          <DataTable
            t={t}
            columns={["ID", t.donationForm.donor, t.donationForm.account, t.donationForm.amount, "Status"]}
            rows={donations.slice(0, 6).map((donation) => [
              donation.donID,
              donation.donorName,
              `${donation.noCompte} - ${donation.libelleCompte}`,
              currency(donation.montant),
              <StatusPill key={donation.donID} t={t} value={donation.receiptStatus} />,
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

      <div className="overview-secondary">
        <Panel title={t.overview.receiptReadiness} icon={FileCheck2}>
          <div className="readiness">
            <div>
              <strong>{readyPercent}%</strong>
              <span>{t.overview.readinessText}</span>
            </div>
            <div className="progress"><span style={{ width: `${readyPercent}%` }} /></div>
            <ul>
              <li><Check size={15} /> {accounts.filter((account) => account.recu).length} {t.overview.receiptableAccounts}</li>
              <li><ClipboardList size={15} /> {pendingReceipts} {t.overview.donationsReady}</li>
              <li><BookOpenCheck size={15} /> {receipts.length} {t.overview.receiptsStored}</li>
            </ul>
          </div>
        </Panel>
      </div>
    </section>
  );
}

function QuickActionLauncher({ hasPageTour, isHintActive, isOpen, onHelp, onToggle, onViewChange, t }) {
  const quickActions = [
    [Plus, t.actions[0], "donations"],
    [Users, t.actions[1], "donors"],
    [ReceiptText, t.actions[2], "receipts"],
    [BarChart3, t.actions[3], "reports"],
  ];

  return (
    <div className={`quick-launcher ${isOpen ? "is-open" : ""}`}>
      {isOpen && (
        <div className="quick-launcher-menu">
          <span className="quick-launcher-title">{t.overview.quickActions}</span>
          {quickActions.map(([Icon, label, view]) => (
            <button className="quick-launcher-action" type="button" key={label} onClick={() => onViewChange(view)}>
              <Icon size={17} />
              <span>{label}</span>
            </button>
          ))}
        </div>
      )}

      <div className="quick-launcher-buttons">
        {hasPageTour && (
          <button
            className={`quick-launcher-help ${isHintActive ? "is-hinting" : ""}`}
            type="button"
            aria-label={t.donorForm.tourReplay}
            title={t.donorForm.tourReplay}
            onClick={onHelp}
          >
            <HelpCircle size={21} />
          </button>
        )}
        <button
          className="quick-launcher-toggle"
          type="button"
          aria-expanded={isOpen}
          aria-label={t.overview.quickActions}
          onClick={onToggle}
        >
          {isOpen ? <X size={22} /> : <Plus size={24} />}
        </button>
      </div>
    </div>
  );
}

function Donations({ accounts, bankingConnections, bootstrap, donations, donors, language, pendingDonations, t, onCategorizePending, onDelete, onSubmit, onUpdate }) {
  const [categorizingDonationId, setCategorizingDonationId] = useState(null);
  const [registerCategorizingDonationId, setRegisterCategorizingDonationId] = useState(null);
  const [activeDrawer, setActiveDrawer] = useState(null);
  const [editingDonation, setEditingDonation] = useState(null);
  const [donationPendingDelete, setDonationPendingDelete] = useState(null);
  const [showAllPending, setShowAllPending] = useState(false);
  const [donationSearch, setDonationSearch] = useState("");
  const [donationToolsOpen, setDonationToolsOpen] = useState(false);
  const linkedBankAccounts = bankingConnections || [];
  const selfServeGiving = bootstrap?.selfServeGiving || {};
  const allDonationRows = [
    ...pendingDonations.map((donation) => ({
      id: donation.id,
      donor: donors.find((donor) => donor.numero === donation.donorNumber)?.fullName || donation.donorNumber,
      date: donation.date,
      account: "-",
      method: donation.methodLabel || t.banking.imported,
      amount: donation.amount,
      status: "pending",
      source: donation.source,
      raw: donation,
    })),
    ...donations.map((donation) => ({
      id: donation.donID,
      donor: donation.donorName,
      date: donation.dateDon,
      account: `${donation.noCompte} - ${donation.libelleCompte}`,
      method: donation.methode_en || t.common.unspecified,
      amount: donation.montant,
      status: donation.receiptStatus,
      source: donation.description || "",
      raw: donation,
    })),
  ];
  const normalizedSearch = donationSearch.trim().toLowerCase();
  const filteredDonationRows = normalizedSearch
    ? allDonationRows.filter((row) => `${row.id} ${row.donor} ${row.date} ${row.account} ${row.method} ${row.source} ${row.status}`.toLowerCase().includes(normalizedSearch))
    : allDonationRows;
  const donationExportRows = filteredDonationRows.map((row) => ({
    ID: row.id,
    Donor: row.donor,
    Date: row.date,
    Account: row.account,
    Method: row.method,
    Description: row.source || "",
    Amount: row.amount,
    Status: row.status,
  }));
  const filteredPendingCount = filteredDonationRows.filter((row) => row.status === "pending").length;
  const filteredRegisteredCount = filteredDonationRows.length - filteredPendingCount;
  const donationTotal = donations.reduce((sum, donation) => sum + Number(donation.montant || 0), 0);
  const today = new Date();
  const currentYear = String(today.getFullYear());
  const currentMonthKey = today.toISOString().slice(0, 7);
  const ytdDonations = donations.filter((donation) => String(donation.dateDon || "").startsWith(currentYear));
  const ytdTotal = ytdDonations.reduce((sum, donation) => sum + Number(donation.montant || 0), 0);
  const monthlyDonations = donations.filter((donation) => String(donation.dateDon || "").startsWith(currentMonthKey));
  const monthlyTotal = monthlyDonations.reduce((sum, donation) => sum + Number(donation.montant || 0), 0);
  const currentMonthName = new Intl.DateTimeFormat(language === "fr" ? "fr-CA" : "en-CA", { month: "long" }).format(today);
  const currentMonthLabel = `${currentMonthName.charAt(0).toUpperCase()}${currentMonthName.slice(1)} ${t.donationForm.monthlySoFar}`;
  const averageGift = donations.length ? donationTotal / donations.length : 0;

  return (
    <section className="view-stack donation-page">
      <ViewHeader
        title={t.nav.donations}
        subtitle={t.donationForm.subtitle}
        action={t.donationForm.add}
        secondaryAction={t.donationForm.import}
        icon={CircleDollarSign}
        onAction={() => setActiveDrawer("add")}
        onSecondaryAction={() => setActiveDrawer("import")}
        secondaryIcon={Download}
        stacked
      />

      <section className="donation-summary-strip" aria-label={t.donationForm.summary}>
        <article className="donation-summary-card">
          <span><FileText size={16} /> {t.donationForm.totalDonations}</span>
          <strong>{donations.length}</strong>
        </article>
        <article className="donation-summary-card">
          <span><CircleDollarSign size={16} /> {currentMonthLabel}</span>
          <strong>{currency(monthlyTotal)}</strong>
          <small>{monthlyDonations.length} {t.donationForm.donations}</small>
        </article>
        <article className="donation-summary-card">
          <span><CalendarDays size={16} /> {t.donationForm.ytdAmount}</span>
          <strong>{currency(ytdTotal)}</strong>
          <small>{ytdDonations.length} {t.donationForm.ytdDonations}</small>
        </article>
      </section>

      {pendingDonations.length > 0 && (
        <section className={`pending-donations-band ${showAllPending ? "is-open" : ""} ${categorizingDonationId ? "has-categorizing" : ""}`}>
          <div className="pending-donations-header">
            <div>
              <span className="eyebrow"><Bell size={15} /> {t.common.pending}</span>
              <h2>{t.banking.newDonations}</h2>
              <p className="panel-copy">{t.banking.newDonationHelp}</p>
            </div>
            <button className="secondary-button compact pending-toggle" type="button" onClick={() => setShowAllPending((isOpen) => !isOpen)} aria-expanded={showAllPending}>
              <ChevronDown size={15} />
              <span>{showAllPending ? t.donationForm.collapsePending : `${t.donationForm.showAllPending} (${pendingDonations.length})`}</span>
            </button>
          </div>
          {showAllPending && (
            <div className="incoming-donation-list">
              {pendingDonations.map((donation) => {
                const detectedDonor = donors.find((donor) => donor.numero === donation.donorNumber);
                const isCategorizing = categorizingDonationId === donation.id;

                return (
                  <article className={`incoming-donation ${isCategorizing ? "is-categorizing" : ""}`} key={donation.id}>
                    <div className="incoming-donation-summary">
                      <div>
                        <span className="status-pill pending">{t.common.pending}</span>
                        <strong>{currency(donation.amount)}</strong>
                        <small>{donation.source} • {donation.date} • {donation.methodLabel}</small>
                        <p>{donation.note}</p>
                        <p className="detected-donor">
                          {t.donationForm.detectedDonor}: {detectedDonor?.fullName || donation.donorNumber}
                        </p>
                      </div>
                      <button className="categorize-chip-button" type="button" onClick={() => setCategorizingDonationId(isCategorizing ? null : donation.id)} aria-label={t.banking.categorize} title={t.banking.categorize}>
                        <Link2 size={14} />
                        <span>{t.banking.categorize}</span>
                      </button>
                    </div>
                    {isCategorizing && (
                      <CategorizeDonationForm
                        accounts={accounts}
                        detectedDonor={detectedDonor}
                        donation={donation}
                        donors={donors}
                        onSubmit={(data) => onCategorizePending(donation, data)}
                        t={t}
                      />
                    )}
                  </article>
                );
              })}
            </div>
          )}
        </section>
      )}

      <Panel title={t.donationForm.register} icon={FileText}>
        <div className="table-toolbar donor-directory-toolbar donation-register-toolbar">
          <div className="search-box inline">
            <Search size={17} />
            <input value={donationSearch} onChange={(event) => setDonationSearch(event.target.value)} placeholder={t.donationForm.searchRegister} />
          </div>
          <button className="secondary-button compact donor-tools-toggle" type="button" onClick={() => setDonationToolsOpen((isOpen) => !isOpen)} aria-expanded={donationToolsOpen} aria-label={t.common.manage} title={t.common.manage}>
            <SlidersHorizontal size={16} />
          </button>
          <div className={`donor-directory-tools donation-register-tools ${donationToolsOpen ? "is-open" : ""}`}>
            <div className="register-counts">
              <span className="status-pill issued">{filteredRegisteredCount} {t.donationForm.registered}</span>
              <span className="status-pill pending">{filteredPendingCount} {t.common.pending}</span>
            </div>
            <div className="export-actions">
              <button className="secondary-button compact" type="button" onClick={() => downloadCSV("donations.csv", donationExportRows)}>
                <FileText size={16} />
                <span>{t.common.csv}</span>
              </button>
              <button className="secondary-button compact" type="button" onClick={() => downloadExcel("donations.xls", donationExportRows)}>
                <FileSpreadsheet size={16} />
                <span>Excel</span>
              </button>
            </div>
          </div>
        </div>
        <DataTable
          t={t}
          paginate
          columns={["ID", t.donationForm.donor, t.donationForm.date, t.donationForm.account, t.donationForm.method, t.donationForm.description, t.donationForm.amount, t.common.status, ""]}
          rows={filteredDonationRows.map((row) => [
            row.id,
            row.donor,
            row.date,
            row.account,
            row.method,
            row.source || "-",
            currency(row.amount),
            row.status === "pending"
              ? <span className="status-pill pending donation-pending" key={`pending-${row.id}`}>{t.common.pending}</span>
              : <StatusPill key={`status-${row.id}`} t={t} value={row.status} />,
            row.status === "pending" ? (
              <button className="categorize-chip-button" type="button" key={`categorize-${row.id}`} aria-label={t.banking.categorize} title={t.banking.categorize} onClick={() => {
                setRegisterCategorizingDonationId((currentId) => currentId === row.id ? null : row.id);
              }}>
                <Link2 size={14} />
                <span>{t.banking.categorize}</span>
              </button>
            ) : (
              <div className="account-actions" key={`actions-${row.id}`}>
                <button
                  className="icon-button table-icon"
                  type="button"
                  onClick={() => {
                    setEditingDonation(row.raw);
                    setActiveDrawer("edit");
                  }}
                  aria-label={`${t.common.edit} ${row.donor}`}
                  title={t.common.edit}
                >
                  <Pencil size={15} />
                </button>
                <button
                  className="icon-button table-icon danger"
                  type="button"
                  onClick={() => setDonationPendingDelete(row.raw)}
                  aria-label={t.common.delete}
                  title={t.common.delete}
                >
                  <Trash2 size={15} />
                </button>
              </div>
            ),
          ])}
          rowClassName={(row) => String(row[7]?.props?.className || "").includes("donation-pending") ? "donation-register-pending-row" : ""}
          expandedRowContent={(row) => {
            const pendingDonation = pendingDonations.find((donation) => donation.id === row[0]);
            if (!pendingDonation || registerCategorizingDonationId !== pendingDonation.id) {
              return null;
            }

            const detectedDonor = donors.find((donor) => donor.numero === pendingDonation.donorNumber);
            return (
              <div className="donation-register-accordion">
                <CategorizeDonationForm
                  accounts={accounts}
                  detectedDonor={detectedDonor}
                  donation={pendingDonation}
                  donors={donors}
                  onSubmit={(data) => {
                    onCategorizePending(pendingDonation, data);
                    setRegisterCategorizingDonationId(null);
                  }}
                  t={t}
                />
              </div>
            );
          }}
        />
      </Panel>

      <div className={`donor-edge-drawers donation-edge-drawers ${activeDrawer ? "has-open-drawer" : ""}`}>
        <button className={`donor-edge-tab ${activeDrawer === "add" ? "active" : ""}`} type="button" onClick={() => {
          setEditingDonation(null);
          setActiveDrawer((drawer) => drawer === "add" ? null : "add");
        }} aria-label={t.donationForm.add} title={t.donationForm.add} aria-expanded={activeDrawer === "add"}>
          <Plus size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "import" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "import" ? null : "import")} aria-label={t.donationForm.import} title={t.donationForm.import} aria-expanded={activeDrawer === "import"}>
          <Download size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "stats" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "stats" ? null : "stats")} aria-label={t.donationForm.accountMix} title={t.donationForm.accountMix} aria-expanded={activeDrawer === "stats"}>
          <BarChart3 size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "banking" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "banking" ? null : "banking")} aria-label={t.banking.title} title={t.banking.title} aria-expanded={activeDrawer === "banking"}>
          <Landmark size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "selfServe" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "selfServe" ? null : "selfServe")} aria-label={t.giving.title} title={t.giving.title} aria-expanded={activeDrawer === "selfServe"}>
          <Wallet size={18} />
        </button>

        {activeDrawer === "add" && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-add-drawer">
            <EdgePanelHeader icon={Plus} title={t.donationForm.add} subtitle={t.banking.manualHelp} onClose={() => setActiveDrawer(null)} t={t} />
            <DonationForm
              accounts={accounts}
              bootstrap={bootstrap}
              donors={donors}
              onSubmit={async (event) => {
                await onSubmit(event);
                setActiveDrawer(null);
              }}
              t={t}
            />
          </aside>
        )}

        {activeDrawer === "edit" && editingDonation && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-edit-drawer">
            <EdgePanelHeader icon={Pencil} title={t.common.edit} subtitle={t.donationForm.register} onClose={() => {
              setActiveDrawer(null);
              setEditingDonation(null);
            }} t={t} />
            <DonationForm
              accounts={accounts}
              bootstrap={bootstrap}
              donation={editingDonation}
              donors={donors}
              onSubmit={async (event) => {
                event.preventDefault();
                const saved = await onUpdate(editingDonation, formObject(event.currentTarget));
                if (saved) {
                  setActiveDrawer(null);
                  setEditingDonation(null);
                }
              }}
              submitLabel={t.common.save}
              t={t}
            />
          </aside>
        )}

        {activeDrawer === "import" && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-import-drawer">
            <EdgePanelHeader icon={Download} title={t.donationForm.import} subtitle={t.donationForm.importHelp} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="donation-import-dropzone">
              <Download size={24} />
              <strong>{t.donationForm.import}</strong>
              <span>CSV, Excel, PayPal, bank export</span>
              <label className="file-picker-button">
                <Plus size={16} />
                <span>{t.donationForm.chooseFile}</span>
                <input type="file" accept=".csv,.xls,.xlsx" aria-label={t.donationForm.import} />
              </label>
            </div>
            <div className="donation-import-steps">
              <div>
                <span>1</span>
                <p>{t.banking.newDonations}</p>
              </div>
              <div>
                <span>2</span>
                <p>{t.banking.categorize}</p>
              </div>
              <div>
                <span>3</span>
                <p>{t.donationForm.register}</p>
              </div>
            </div>
          </aside>
        )}

        {activeDrawer === "stats" && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-stats-drawer">
            <EdgePanelHeader icon={BarChart3} title={t.donationForm.accountMix} subtitle={t.donationForm.register} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="edge-stat-grid">
              <div className="donor-total-summary">
                <span>{t.donationForm.register}</span>
                <strong>{donations.length}</strong>
              </div>
              <div className="donor-total-summary">
                <span>{t.donationForm.amount}</span>
                <strong>{currency(donationTotal)}</strong>
              </div>
              <div className="donor-total-summary is-pending">
                <span>{t.common.pending}</span>
                <strong>{pendingDonations.length}</strong>
              </div>
              <div className="donor-total-summary">
                <span>{t.donationForm.averageGift}</span>
                <strong>{currency(averageGift)}</strong>
              </div>
            </div>
            <div className="account-list">
              {accounts.map((account) => (
                <div className="account-row" key={account.compteID}>
                  <span>{account.noCompte} - {account.nom}</span>
                  <strong>{currency(account.total || 0)}</strong>
                  <div className="progress"><span style={{ width: `${Math.min(100, (account.total || 0) / 20)}%` }} /></div>
                </div>
              ))}
            </div>
          </aside>
        )}

        {activeDrawer === "banking" && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-banking-drawer">
            <EdgePanelHeader icon={Landmark} title={t.banking.title} subtitle={t.banking.subtitle} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="banking-accordion-list">
              {linkedBankAccounts.map((bankAccount) => (
                <BankingConnectionRow bankAccount={bankAccount} key={bankAccount.id} t={t} />
              ))}
            </div>
          </aside>
        )}

        {activeDrawer === "selfServe" && (
          <aside className="donor-edge-panel app-edge-panel" id="donation-self-serve-drawer">
            <EdgePanelHeader icon={Wallet} title={t.giving.title} subtitle={t.giving.subtitle} onClose={() => setActiveDrawer(null)} t={t} />
            <SelfServeGivingPanel
              donors={donors}
              organization={bootstrap?.organisme}
              selfServeGiving={selfServeGiving}
              t={t}
            />
          </aside>
        )}
      </div>

      {donationPendingDelete && (
        <ConfirmDialog
          body={t.donationForm.deleteBody.replace("{id}", donationPendingDelete.donID).replace("{name}", donationPendingDelete.donorName)}
          confirmLabel={t.common.delete}
          icon={Trash2}
          isDanger
          onCancel={() => setDonationPendingDelete(null)}
          onConfirm={async () => {
            const deleted = await onDelete(donationPendingDelete);
            if (deleted) {
              setDonationPendingDelete(null);
            }
          }}
          t={t}
          title={t.donationForm.deleteTitle}
        />
      )}
    </section>
  );
}

function buildSelfServeGivingUrl(organizationID, donorNumber = "") {
  const params = new URLSearchParams({ org: String(organizationID || 1) });
  if (donorNumber) {
    params.set("donor", donorNumber);
  }
  return `${window.location.origin}/give?${params.toString()}`;
}

function SelfServeGivingPanel({ donors, organization, selfServeGiving, t }) {
  const [selectedDonorNumber, setSelectedDonorNumber] = useState(donors[0]?.numero || "");
  const [copied, setCopied] = useState(false);
  const gateway = selfServeGiving?.gateway || {};
  const recentPayments = selfServeGiving?.recentPayments || [];
  const givingUrl = buildSelfServeGivingUrl(organization?.organismeID, selectedDonorNumber);
  const gatewayMode = gateway.mode === "live" ? t.giving.liveMode : t.giving.testMode;

  async function copyGivingLink() {
    setCopied(false);
    try {
      await navigator.clipboard.writeText(givingUrl);
      setCopied(true);
    } catch {
      setCopied(false);
    }
  }

  return (
    <div className="self-serve-giving-panel">
      <article className="payment-method-tile giving-link-card">
        <div className="payment-card-mark">
          <Wallet size={22} />
        </div>
        <div>
          <span>{t.giving.gatewayStatus}</span>
          <h2>{gateway.provider || "test_gateway"}</h2>
          <p>{gatewayMode} • {gateway.status || t.giving.connected}</p>
        </div>
      </article>

      <label>
        {t.giving.chooseDonor}
        <select value={selectedDonorNumber} onChange={(event) => setSelectedDonorNumber(event.target.value)}>
          {donors.map((donor) => (
            <option value={donor.numero} key={donor.donateurID}>
              {donor.numero} - {donor.fullName}
            </option>
          ))}
        </select>
      </label>

      <div className="giving-link-box">
        <span>{t.giving.tapLink}</span>
        <input value={givingUrl} readOnly />
        <p>{t.giving.tapLinkHelp}</p>
        <div className="payment-card-actions">
          <button className="secondary-button compact" type="button" onClick={copyGivingLink}>
            <Link2 size={15} />
            <span>{copied ? t.giving.copied : t.giving.copyLink}</span>
          </button>
          <a className="primary-button compact" href={givingUrl} target="_blank" rel="noreferrer">
            <CreditCard size={15} />
            <span>{t.giving.openPortal}</span>
          </a>
        </div>
      </div>

      <div className="recent-self-serve-list">
        <h3>{t.giving.recent}</h3>
        {recentPayments.length === 0 && <p className="panel-copy">{t.giving.noRecent}</p>}
        {recentPayments.map((payment) => (
          <article className="incoming-donation" key={payment.paymentID}>
            <div className="incoming-donation-summary">
              <div>
                <span className="status-pill issued">{payment.gatewayStatus}</span>
                <strong>{currency(payment.amount)}</strong>
                <small>{payment.confirmationNumber} • {payment.donorName}</small>
                <p>{payment.account}</p>
              </div>
            </div>
          </article>
        ))}
      </div>
    </div>
  );
}

function DonationForm({ accounts, bootstrap, donation, donors, onSubmit, submitLabel, t }) {
  return (
    <form className="form-grid donation-manual-form" onSubmit={onSubmit}>
      <label>
        {t.donationForm.donor}
        <select name="donateurID" required defaultValue={donation?.donateurID || donors[0]?.donateurID || ""}>
          {donors.map((donor) => (
            <option value={donor.donateurID} key={donor.donateurID}>
              {donor.numero} - {donor.fullName}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t.donationForm.account}
        <select name="compteID" required defaultValue={donation?.compteID || accounts[0]?.compteID || ""}>
          {accounts.map((account) => (
            <option value={account.compteID} key={account.compteID}>
              {account.noCompte} - {account.nom}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t.donationForm.amount}
        <input name="montant" required min="1" step="0.01" type="number" placeholder="125.00" defaultValue={donation?.montant || ""} />
      </label>
      <label>
        {t.donationForm.date}
        <input name="dateDon" required type="date" defaultValue={donation?.dateDon || "2026-07-06"} />
      </label>
      <label>
        {t.donationForm.method}
        <select name="methodeDonID" defaultValue={donation?.methodeDonID || bootstrap?.methods?.[0]?.methodeDonID || ""}>
          {bootstrap?.methods?.map((method) => (
            <option value={method.methodeDonID} key={method.methodeDonID}>
              {method.methode_en}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t.donationForm.description}
        <input name="description" placeholder={t.donationForm.descriptionPlaceholder} defaultValue={donation?.description || ""} />
      </label>
      <button className="primary-button form-submit" type="submit">
        {donation ? <Check size={17} /> : <Plus size={17} />}
        <span>{submitLabel || t.donationForm.add}</span>
      </button>
    </form>
  );
}

function CategorizeDonationForm({ accounts, detectedDonor, donation, donors, onSubmit, t }) {
  function submitCategorization(event) {
    event.preventDefault();
    const data = formObject(event.currentTarget);
    onSubmit({
      ...data,
      numero: donation.donorNumber,
    });
  }

  return (
    <form className="categorize-donation-form" onSubmit={submitCategorization}>
      <label>
        {t.donationForm.detectedDonor}
        <select name="donateurID" required defaultValue={detectedDonor?.donateurID || ""}>
          {!detectedDonor && <option value="">{t.donationForm.donor}</option>}
          {donors.map((donor) => (
            <option value={donor.donateurID} key={donor.donateurID}>
              {donor.numero} - {donor.fullName}
            </option>
          ))}
        </select>
      </label>
      <label>
        {t.donationForm.chooseAccount}
        <select name="compteID" required>
          {accounts.map((account) => (
            <option value={account.compteID} key={account.compteID}>
              {account.noCompte} - {account.nom}
            </option>
          ))}
        </select>
      </label>
      <button className="primary-button compact" type="submit">
        <Link2 size={15} />
        <span>{t.banking.categorize}</span>
      </button>
    </form>
  );
}

function bankBrand(institution = "") {
  const name = institution.toLowerCase();

  if (name.includes("paypal")) {
    return { type: "paypal", color: "#0070ba", soft: "#e6f4ff" };
  }

  if (name.includes("stripe")) {
    return { type: "card", color: "#635bff", soft: "#eeecff" };
  }

  if (name.includes("zeffy")) {
    return { type: "external", color: "#5636d6", soft: "#f0edff" };
  }

  if (name.includes("canada helps") || name.includes("canadahelps")) {
    return { type: "external", color: "#e43d30", soft: "#fdecea" };
  }

  if (name.includes("rbc") || name.includes("royal bank")) {
    return { type: "bank", color: "#0051a5", soft: "#e7f0fb" };
  }

  if (name.includes("nationale") || name.includes("national")) {
    return { type: "bank", color: "#d71920", soft: "#fdeaea" };
  }

  if (name.includes("desjardins")) {
    return { type: "bank", color: "#00874e", soft: "#e5f5ec" };
  }

  if (name.includes("td")) {
    return { type: "bank", color: "#00843d", soft: "#e6f5ec" };
  }

  if (name.includes("bmo")) {
    return { type: "bank", color: "#0079c1", soft: "#e6f3fb" };
  }

  if (name.includes("cibc")) {
    return { type: "bank", color: "#8a1538", soft: "#fae8ef" };
  }

  if (name.includes("scotia")) {
    return { type: "bank", color: "#ed1b2f", soft: "#fde8eb" };
  }

  return { type: "bank", color: "#1d6f5f", soft: "#e8f4ef" };
}

function BankBrandIcon({ brand, size = 18 }) {
  if (brand.type === "paypal") {
    return <Wallet size={size} />;
  }

  if (brand.type === "card") {
    return <CreditCard size={size} />;
  }

  if (brand.type === "external") {
    return <Globe2 size={size} />;
  }

  return <Landmark size={size} />;
}

function connectionCategory(connection, selectedProvider) {
  if (selectedProvider?.category) {
    return selectedProvider.category;
  }

  if (connection?.category) {
    return connection.category;
  }

  const brandType = bankBrand(`${connection?.institution || ""} ${connection?.accountNumber || ""}`).type;
  if (brandType === "paypal" || brandType === "card") {
    return "processor";
  }
  if (brandType === "external") {
    return "giving";
  }

  return "bank";
}

function connectionCategoryLabel(category, t) {
  if (category === "processor") {
    return t.banking.paymentProcessor;
  }
  if (category === "giving") {
    return t.banking.givingPlatform;
  }

  return t.banking.bankAccount;
}

function BankingConnectionRow({ bankAccount, t }) {
  const brand = bankBrand(`${bankAccount.institution} ${bankAccount.accountNumber}`);

  return (
    <article className="banking-connection-row" style={{ "--bank-color": brand.color, "--bank-soft": brand.soft }}>
      <div className="banking-connection-main">
        <div className="bank-brand-mark">
          <BankBrandIcon brand={brand} size={18} />
        </div>
        <div className="banking-connection-title">
          <span>{bankAccount.institution}</span>
          <small>{bankAccount.accountNumber}</small>
        </div>
        <span className="status-pill issued"><CheckCircle2 size={14} /> {t.banking.linked}</span>
      </div>
    </article>
  );
}

function bankingAccountNames(bankAccount, accounts, t) {
  if (bankAccount.scope === "all") {
    return t.banking.allAccounts;
  }

  const selectedAccountIds = Array.isArray(bankAccount.accountIds) ? bankAccount.accountIds : [];
  const selectedAccounts = accounts.filter((account) => selectedAccountIds.includes(account.compteID));
  return selectedAccounts.length
    ? selectedAccounts.map((account) => `${account.noCompte} - ${account.nom}`).join(", ")
    : t.common.unspecified;
}

function maskSensitiveValue(value = "", visibleCount = 4) {
  const cleanValue = String(value).trim();
  const visibleValue = cleanValue.replace(/\s/g, "").slice(-visibleCount);
  return visibleValue ? `**** ${visibleValue}` : "";
}

function maskEmail(value = "") {
  const [name = "", domain = ""] = String(value).trim().split("@");
  if (!name || !domain) {
    return maskSensitiveValue(value);
  }

  return `${name.slice(0, 2)}***@${domain}`;
}

function BankingView({
  accounts,
  linkedAccounts = [],
  onCreateConnection,
  t,
}) {
  const providerGroups = [
    {
      label: t.banking.bankAccount,
      options: [
        { value: "Banque Nationale", label: "Banque Nationale", type: "bank", category: "bank" },
        { value: "Desjardins", label: "Desjardins", type: "bank", category: "bank" },
        { value: "RBC", label: "RBC", type: "bank", category: "bank" },
        { value: "TD Bank", label: "TD Bank", type: "bank", category: "bank" },
        { value: "BMO", label: "BMO", type: "bank", category: "bank" },
        { value: "CIBC", label: "CIBC", type: "bank", category: "bank" },
        { value: "Scotiabank", label: "Scotiabank", type: "bank", category: "bank" },
      ],
    },
    {
      label: t.banking.paymentProcessor,
      options: [
        { value: "PayPal", label: "PayPal", type: "paypal", category: "processor" },
        { value: "Stripe", label: "Stripe", type: "card", category: "processor" },
      ],
    },
    {
      label: t.banking.givingPlatform,
      options: [
        { value: "Zeffy", label: "Zeffy", type: "external", category: "giving" },
        { value: "CanadaHelps", label: "CanadaHelps", type: "external", category: "giving" },
      ],
    },
  ];
  const bankingProviders = providerGroups.flatMap((group) => group.options);
  const [addBankOpen, setAddBankOpen] = useState(false);
  const [selectedProvider, setSelectedProvider] = useState(bankingProviders[0]);
  const [scopeMode, setScopeMode] = useState("all");

  async function addLinkedBankAccount(event) {
    event.preventDefault();
    const form = event.currentTarget;
    const formData = new FormData(event.currentTarget);
    const data = Object.fromEntries(formData.entries());
    const selectedAccountIds = formData.getAll("accountIds").map(Number);

    const didCreate = await onCreateConnection({
      category: selectedProvider.category,
      institution: data.provider,
      accountNumber: selectedProvider.type === "paypal" || selectedProvider.type === "external"
        ? maskEmail(data.paypalEmail || data.sourceEmail)
        : maskSensitiveValue(data.accountNumber || data.stripeAccount),
      transit: selectedProvider.type === "bank" ? data.transit : selectedProvider.label,
      iban: selectedProvider.type === "bank"
        ? maskSensitiveValue(data.iban)
        : maskSensitiveValue(data.stripeAccount || data.sourceAccount || data.paypalEmail),
      scope: data.scope,
      accountIds: data.scope === "all" ? [] : selectedAccountIds,
    });

    if (didCreate) {
      form.reset();
      setSelectedProvider(bankingProviders[0]);
      setScopeMode("all");
      setAddBankOpen(false);
    }
  }

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.banking.title}
        subtitle={t.banking.pageSubtitle}
        icon={Landmark}
      />

      <div className="banking-tile-grid">
        {linkedAccounts.map((bankAccount) => {
          const brand = bankBrand(bankAccount.institution);
          const category = connectionCategory(bankAccount);
          const detailLabels = category === "bank"
            ? [t.banking.transitNumber, t.banking.ibanNumber]
            : [t.banking.provider, t.banking.identifier];

          return (
          <article className="linked-bank-tile" key={bankAccount.id} style={{ "--bank-color": brand.color, "--bank-soft": brand.soft }}>
            <div className="linked-bank-topline">
              <div className="bank-brand-mark large">
                <BankBrandIcon brand={brand} size={24} />
              </div>
              <span className="status-pill issued"><CheckCircle2 size={14} /> {t.banking.linked}</span>
            </div>
            <div>
              <span>{connectionCategoryLabel(category, t)}</span>
              <h2>{bankAccount.institution}</h2>
              <p>{bankAccount.accountNumber}</p>
            </div>
            <dl className="banking-detail-list">
              <div>
                <dt>{detailLabels[0]}</dt>
                <dd>{bankAccount.transit}</dd>
              </div>
              <div>
                <dt>{detailLabels[1]}</dt>
                <dd>{bankAccount.iban}</dd>
              </div>
            </dl>
            <div className="banking-scope-box">
              <strong>{t.banking.accountScope}</strong>
              <p>{bankingAccountNames(bankAccount, accounts, t)}</p>
            </div>
          </article>
          );
        })}

        <button className="linked-bank-tile add-bank-tile" type="button" onClick={() => setAddBankOpen((open) => !open)} aria-expanded={addBankOpen}>
          <span><Plus size={28} /></span>
          <strong>{t.banking.addConnection}</strong>
          <small>{t.banking.addConnectionHelp}</small>
        </button>
      </div>

      {addBankOpen && (
        <Panel title={t.banking.addConnection} icon={Plus}>
          <form className="form-grid banking-link-form" onSubmit={addLinkedBankAccount}>
            <label>
              {t.banking.provider}
              <select
                aria-label={t.banking.provider}
                name="provider"
                value={selectedProvider.value}
                onChange={(event) => setSelectedProvider(bankingProviders.find((provider) => provider.value === event.target.value) || bankingProviders[0])}
              >
                {providerGroups.map((group) => (
                  <optgroup label={group.label} key={group.label}>
                    {group.options.map((provider) => (
                      <option value={provider.value} key={provider.value}>{provider.label}</option>
                    ))}
                  </optgroup>
                ))}
              </select>
            </label>
            <label>
              {t.banking.connectionType}
              <input value={connectionCategoryLabel(selectedProvider.category, t)} readOnly />
            </label>
            {selectedProvider.type === "bank" && (
              <>
                <label>
                  {t.banking.accountNumber}
                  <input name="accountNumber" placeholder="**** 1842" required />
                </label>
                <label>
                  {t.banking.transitNumber}
                  <input name="transit" placeholder="006" required />
                </label>
                <label>
                  {t.banking.ibanNumber}
                  <input name="iban" placeholder="CA-006-1842" required />
                </label>
              </>
            )}
            {selectedProvider.type === "paypal" && (
              <label>
                {t.banking.paypalEmail}
                <input name="paypalEmail" placeholder="finance@organization.org" required type="email" />
              </label>
            )}
            {selectedProvider.type === "card" && (
              <label>
                {t.banking.stripeAccount}
                <input name="stripeAccount" placeholder="acct_1234" required />
              </label>
            )}
            {selectedProvider.type === "external" && (
              <>
                <label>
                  {t.banking.sourceEmail}
                  <input name="sourceEmail" placeholder="donations@organization.org" required type="email" />
                </label>
                <label>
                  {t.banking.sourceAccount}
                  <input name="sourceAccount" placeholder="external-source-1234" required />
                </label>
              </>
            )}
            <label>
              {t.banking.accountScope}
              <select aria-label={t.banking.accountScope} name="scope" value={scopeMode} onChange={(event) => setScopeMode(event.target.value)}>
                <option value="all">{t.banking.scopeAll}</option>
                <option value="selected">{t.banking.scopeSelected}</option>
              </select>
            </label>
            {scopeMode === "selected" && (
              <label className="full-field">
                {t.banking.linkedAccounts}
                <select aria-label={t.banking.linkedAccounts} name="accountIds" multiple required>
                  {accounts.map((account) => (
                    <option value={account.compteID} key={account.compteID}>
                      {account.noCompte} - {account.nom}
                    </option>
                  ))}
                </select>
              </label>
            )}
            <button className="primary-button form-submit" type="submit">
              <Link2 size={17} />
              <span>{t.banking.connectSource}</span>
            </button>
          </form>
        </Panel>
      )}

    </section>
  );
}

function IntegrationsView({ accountingIntegrations = [], onCreateAccountingIntegration, onSyncAccountingIntegration, t }) {
  const accountingProviders = [
    {
      id: "quickbooks",
      name: t.banking.quickbooks,
      color: "#2ca01c",
      scopes: ["com.intuit.quickbooks.accounting"],
    },
    {
      id: "xero",
      name: t.banking.xero,
      color: "#13b5ea",
      scopes: ["offline_access", "accounting.invoices", "accounting.payments", "accounting.banktransactions", "accounting.manualjournals"],
    },
  ];

  function providerLabel(provider) {
    return accountingProviders.find((item) => item.id === provider)?.name || provider;
  }

  function providerColor(provider) {
    return accountingProviders.find((item) => item.id === provider)?.color || "var(--brand)";
  }

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.banking.accountingTitle}
        subtitle={t.banking.accountingSubtitle}
        icon={BookOpenCheck}
      />

      <div className="accounting-integration-grid">
        {accountingIntegrations.map((integration) => (
          <article
            className="accounting-integration-card"
            key={integration.id}
            style={{ "--accounting-color": providerColor(integration.provider) }}
          >
            <div className="accounting-integration-topline">
              <div className="accounting-provider-mark">
                <BookOpenCheck size={22} />
              </div>
              <span className={`status-pill ${integration.status === "synced" ? "issued" : "ready"}`}>
                <CheckCircle2 size={14} />
                {integration.status === "synced" ? t.banking.synced : t.banking.apiReady}
              </span>
            </div>
            <div>
              <span>{providerLabel(integration.provider)}</span>
              <h2>{integration.displayName}</h2>
              <p>{integration.lastSyncAt ? `${t.banking.lastSync}: ${new Date(integration.lastSyncAt).toLocaleString()}` : t.banking.noSync}</p>
            </div>
            <div className="accounting-scope-list" aria-label={t.banking.scopes}>
              {(integration.scopes || []).map((scope) => (
                <span key={scope}>{scope}</span>
              ))}
            </div>
            <button className="secondary-button compact" type="button" onClick={() => onSyncAccountingIntegration(integration)}>
              <FileSpreadsheet size={16} />
              <span>{t.banking.syncDonations}</span>
            </button>
          </article>
        ))}

        {accountingProviders.map((provider) => (
          <button
            className="accounting-integration-card accounting-provider-card"
            key={provider.id}
            style={{ "--accounting-color": provider.color }}
            type="button"
            onClick={() => onCreateAccountingIntegration({
              provider: provider.id,
              displayName: provider.name,
              scopes: provider.scopes,
              syncMode: "donations",
            })}
          >
            <div className="accounting-provider-mark">
              <Plus size={22} />
            </div>
            <strong>{t.banking.addAccounting}</strong>
            <span>{provider.name}</span>
          </button>
        ))}
      </div>
    </section>
  );
}

function Donors({ bootstrap, donations, donors, query, setQuery, t, onArchive, onDelete, onSearch, onSubmit, onUpdate }) {
  const [activeDrawer, setActiveDrawer] = useState(null);
  const [editingDonor, setEditingDonor] = useState(null);
  const [selectedDonorId, setSelectedDonorId] = useState(null);
  const [expandedDonorId, setExpandedDonorId] = useState(null);
  const [donorFilters, setDonorFilters] = useState({ member: false, receipts: false });
  const [donorToolsOpen, setDonorToolsOpen] = useState(false);
  const [donorPendingDeactivate, setDonorPendingDeactivate] = useState(null);
  const [donorPendingDelete, setDonorPendingDelete] = useState(null);
  const selectedDonor = donors.find((donor) => donor.donateurID === selectedDonorId);
  const expandedDonor = donors.find((donor) => donor.donateurID === expandedDonorId);
  const filteredDonors = donors.filter((donor) => (
    (!donorFilters.member || donor.membre) &&
    (!donorFilters.receipts || donor.recu)
  ));
  const memberLabel = donors.filter((donor) => donor.membre).length > 1 ? t.common.members : t.common.member;
  const donorExportRows = filteredDonors.map((donor) => ({
    Number: donor.numero,
    Donor: donor.fullName,
    Email: donor.courriel || "",
    City: donor.ville || "",
    Member: donor.membre ? t.common.yes : t.common.no,
    Receipts: donor.recu ? t.common.yes : t.common.no,
    Lifetime: donor.totalDonations || 0,
    LastGift: donor.lastGift || "",
  }));

  useEffect(() => {
    if (selectedDonorId && !donors.some((donor) => donor.donateurID === selectedDonorId)) {
      setSelectedDonorId(null);
    }

    if (expandedDonorId && !donors.some((donor) => donor.donateurID === expandedDonorId)) {
      setExpandedDonorId(null);
    }
  }, [donors, selectedDonorId, expandedDonorId]);

  function donorDonations(donor) {
    return donations.filter((donation) => donation.donateurID === donor.donateurID);
  }

  return (
    <section className="view-stack donor-page">
      <ViewHeader
        title={t.donorDirectory}
        subtitle={t.donorForm.subtitle}
        action={t.donorForm.title}
        icon={Users}
        onAction={() => {
          setEditingDonor(null);
          setActiveDrawer("add");
        }}
        stacked
      />

      {expandedDonor ? (
        <Panel title={`${expandedDonor.numero} - ${expandedDonor.fullName}`} icon={Minimize2}>
          <div className="expanded-account-toolbar">
            <button className="icon-button" type="button" onClick={() => setExpandedDonorId(null)} aria-label={t.common.cancel}>
              <Minimize2 size={18} />
            </button>
          </div>
          <DonorDetail
            donor={expandedDonor}
            donations={donorDonations(expandedDonor)}
            isExpanded
            onExpand={() => setExpandedDonorId(expandedDonor.donateurID)}
            t={t}
          />
        </Panel>
      ) : (
      <Panel title={t.donorForm.directory} icon={Search}>
        <div className="table-toolbar donor-directory-toolbar">
          <div className="search-box inline">
            <Search size={17} />
            <input value={query} onChange={(event) => { setQuery(event.target.value); onSearch(event); }} placeholder={t.donorForm.filter} />
          </div>
          <button className="secondary-button compact donor-tools-toggle" type="button" onClick={() => setDonorToolsOpen((isOpen) => !isOpen)} aria-expanded={donorToolsOpen} aria-label={t.common.manage} title={t.common.manage}>
            <SlidersHorizontal size={16} />
          </button>
          <div className={`donor-directory-tools ${donorToolsOpen ? "is-open" : ""}`}>
            <div className="register-counts">
              <span className="status-pill issued">{filteredDonors.length} {t.donorForm.totalDonors}</span>
              <span className="status-pill ready">{filteredDonors.filter((donor) => donor.actif).length} {t.common.active}</span>
            </div>
            <div className="donor-filter-toggles">
              <label className={`filter-check-pill ${donorFilters.member ? "is-active" : ""}`}>
                <input
                  checked={donorFilters.member}
                  onChange={(event) => setDonorFilters((filters) => ({ ...filters, member: event.target.checked }))}
                  type="checkbox"
                />
                <Check size={14} />
                <span>{memberLabel}</span>
              </label>
              <label className={`filter-check-pill ${donorFilters.receipts ? "is-active" : ""}`}>
                <input
                  checked={donorFilters.receipts}
                  onChange={(event) => setDonorFilters((filters) => ({ ...filters, receipts: event.target.checked }))}
                  type="checkbox"
                />
                <ReceiptText size={14} />
                <span>{t.nav.receipts}</span>
              </label>
            </div>
            <div className="export-actions">
              <button className="secondary-button compact" type="button" onClick={() => downloadCSV("donors.csv", donorExportRows)}>
                <FileText size={16} />
                <span>{t.common.csv}</span>
              </button>
              <button className="secondary-button compact" type="button" onClick={() => downloadExcel("donors.xls", donorExportRows)}>
                <FileSpreadsheet size={16} />
                <span>Excel</span>
              </button>
            </div>
          </div>
        </div>
        <DataTable
          t={t}
          paginate
          alwaysShowPagination
          onRowClick={(row) => {
            const donor = filteredDonors.find((item) => item.numero === row[1]);
            if (donor) {
              setSelectedDonorId(selectedDonor?.donateurID === donor.donateurID ? null : donor.donateurID);
            }
          }}
          columns={[t.common.status, "No.", t.donationForm.donor, t.common.email, t.donorForm.city, t.common.member, t.nav.receipts, t.donorForm.lifetime, t.donorForm.lastGift, ""]}
          rows={filteredDonors.map((donor) => [
            <span className={`status-pill donor-status-pill ${donor.actif ? "is-active" : "is-inactive"}`} key={`status-${donor.donateurID}`}>
              {donor.actif ? t.common.active : t.common.inactive}
            </span>,
            donor.numero,
            donor.fullName,
            donor.courriel || "-",
            donor.ville || "-",
            <BooleanIcon key={`member-${donor.donateurID}`} value={donor.membre} trueLabel={t.common.yes} falseLabel={t.common.no} />,
            <BooleanIcon key={`receipt-${donor.donateurID}`} value={donor.recu} trueLabel={t.common.yes} falseLabel={t.common.no} />,
            currency(donor.totalDonations || 0),
            donor.lastGift || "-",
            <div className="account-actions" key={`actions-${donor.donateurID}`} onClick={(event) => event.stopPropagation()}>
              <button
                className="icon-button table-icon"
                type="button"
                onClick={() => {
                  setEditingDonor(donor);
                  setActiveDrawer("edit");
                }}
                aria-label={`${t.common.edit} ${donor.fullName}`}
                title={t.common.edit}
              >
                <Pencil size={16} />
              </button>
              <button
                className="icon-button table-icon"
                type="button"
                onClick={() => setExpandedDonorId(donor.donateurID)}
                aria-label={`${t.donorForm.expandProfile} ${donor.fullName}`}
                title={t.common.view}
              >
                <Maximize2 size={16} />
              </button>
              <button
                className={`icon-button table-icon ${donor.actif ? "" : "success"}`}
                type="button"
                onClick={() => {
                  if (donor.actif) {
                    setDonorPendingDeactivate(donor);
                    return;
                  }

                  onArchive(donor, true);
                }}
                aria-label={`${donor.actif ? t.common.deactivate : t.common.activate} ${donor.fullName}`}
                title={donor.actif ? t.common.deactivate : t.common.activate}
              >
                {donor.actif ? <PauseCircle size={16} /> : <CheckCircle2 size={16} />}
              </button>
              <button
                className="icon-button table-icon danger"
                type="button"
                onClick={() => setDonorPendingDelete(donor)}
                aria-label={`${t.common.delete} ${donor.fullName}`}
                title={t.common.delete}
              >
                <Trash2 size={16} />
              </button>
            </div>,
          ])}
          rowClassName={(row) => {
            const donor = filteredDonors.find((item) => item.numero === row[1]);
            return donor?.donateurID === selectedDonorId ? "donor-directory-row is-open" : "donor-directory-row";
          }}
          expandedRowContent={(row) => {
            const donor = filteredDonors.find((item) => item.numero === row[1]);
            if (!donor || donor.donateurID !== selectedDonorId) {
              return null;
            }

            return (
              <div className="donor-directory-accordion">
                <DonorDetail
                  donor={donor}
                  donations={donorDonations(donor)}
                  onExpand={() => setExpandedDonorId(donor.donateurID)}
                  t={t}
                />
              </div>
            );
          }}
        />
      </Panel>
      )}

      <div className={`donor-edge-drawers ${activeDrawer ? "has-open-drawer" : ""}`}>
        <button
          className={`donor-edge-tab ${activeDrawer === "add" ? "active" : ""}`}
          type="button"
          onClick={() => {
            setEditingDonor(null);
            setActiveDrawer((drawer) => drawer === "add" ? null : "add");
          }}
          aria-label={t.donorForm.new}
          title={t.donorForm.new}
          aria-expanded={activeDrawer === "add"}
          aria-controls="donor-add-drawer"
        >
          <UserPlus size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "stats" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "stats" ? null : "stats")} aria-label={t.donorForm.totals} title={t.donorForm.totals} aria-expanded={activeDrawer === "stats"} aria-controls="donor-stats-drawer">
          <BarChart3 size={18} />
        </button>

        {(activeDrawer === "add" || activeDrawer === "edit") && (
          <aside className="donor-edge-panel" id="donor-add-drawer">
            <EdgePanelHeader
              icon={activeDrawer === "edit" ? Pencil : UserPlus}
              title={activeDrawer === "edit" ? t.common.edit : t.donorForm.title}
              subtitle={t.donorForm.subtitle}
              onClose={() => setActiveDrawer(null)}
              t={t}
            />
            <DonorForm
              bootstrap={bootstrap}
              donor={activeDrawer === "edit" ? editingDonor : null}
              onSubmit={async (event) => {
                if (activeDrawer === "edit" && editingDonor) {
                  event.preventDefault();
                  await onUpdate(editingDonor, formObject(event.currentTarget));
                  setActiveDrawer(null);
                  setEditingDonor(null);
                  return;
                }

                await onSubmit(event);
                setActiveDrawer(null);
              }}
              submitLabel={activeDrawer === "edit" ? t.common.save : t.donorForm.title}
              t={t}
            />
          </aside>
        )}

        {activeDrawer === "stats" && (
          <aside className="donor-edge-panel" id="donor-stats-drawer">
            <EdgePanelHeader icon={BarChart3} title={t.donorForm.totals} subtitle={t.donorForm.directory} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="donor-total-summary">
              <span>{t.donorForm.totals}</span>
              <strong>{donors.length}</strong>
            </div>
            <div className="account-list">
              {donors.slice(0, 6).map((donor) => (
                <div className="account-row" key={donor.donateurID}>
                  <span>{donor.numero} - {donor.fullName}</span>
                  <strong>{currency(donor.totalDonations || 0)}</strong>
                  <div className="progress"><span style={{ width: `${Math.min(100, (donor.totalDonations || 0) / 20)}%` }} /></div>
                </div>
              ))}
            </div>
          </aside>
        )}
      </div>

      {donorPendingDeactivate && (
        <ConfirmDialog
          body={t.donorForm.deactivateBody.replace("{name}", donorPendingDeactivate.fullName)}
          confirmLabel={t.common.deactivate}
          icon={PauseCircle}
          onCancel={() => setDonorPendingDeactivate(null)}
          onConfirm={async () => {
            const donor = donorPendingDeactivate;
            setDonorPendingDeactivate(null);
            await onArchive(donor, false);
          }}
          t={t}
          title={t.donorForm.deactivateTitle}
        />
      )}

      {donorPendingDelete && (
        <ConfirmDialog
          body={t.donorForm.deleteBody.replace("{name}", donorPendingDelete.fullName)}
          confirmLabel={t.common.delete}
          isDanger
          onCancel={() => setDonorPendingDelete(null)}
          onConfirm={async () => {
            await onDelete(donorPendingDelete);
            setDonorPendingDelete(null);
          }}
          t={t}
          title={t.donorForm.deleteTitle}
        />
      )}

    </section>
  );
}

function DonorDetail({ donor, donations, isExpanded = false, onExpand, t }) {
  const total = donations.reduce((sum, donation) => sum + Number(donation.montant || 0), 0);
  const averageDonation = donations.length ? total / donations.length : 0;
  const readyReceipts = donations.filter((donation) => donation.receiptStatus === "Ready").length;
  const visibleDonations = isExpanded ? donations : donations.slice(0, 5);
  const statementRows = donations.map((donation) => ({
    Date: donation.dateDon,
    Account: `${donation.noCompte} - ${donation.libelleCompte}`,
    Description: donation.description || "",
    Amount: donation.montant,
    Status: translateStatus(donation.receiptStatus, t),
  }));

  return (
    <div className={`donor-detail ${isExpanded ? "is-expanded" : ""}`}>
      <div className="panel-subheader">
        <h3>{t.donorForm.donorStatement}</h3>
        <div className="export-actions">
          <button className="secondary-button compact" type="button" onClick={() => downloadCSV(`donor-${donor.numero}-statement.csv`, statementRows)}>
            <FileText size={16} />
            <span>{t.common.csv}</span>
          </button>
          <button className="secondary-button compact" type="button" onClick={() => downloadExcel(`donor-${donor.numero}-statement.xls`, statementRows)}>
            <FileSpreadsheet size={16} />
            <span>Excel</span>
          </button>
        </div>
      </div>
      <div className="donor-statement-grid">
        <div>
          <span>{t.donorForm.donationCount}</span>
          <strong>{donations.length}</strong>
        </div>
        <div>
          <span>{t.donorForm.lifetime}</span>
          <strong>{currency(total)}</strong>
        </div>
        <div>
          <span>{t.donorForm.averageDonation}</span>
          <strong>{currency(averageDonation)}</strong>
        </div>
        <div>
          <span>{t.donorForm.readyReceipts}</span>
          <strong>{readyReceipts}</strong>
        </div>
      </div>

      <div className={`account-detail-grid donor-detail-grid ${isExpanded ? "is-expanded" : ""}`}>
        <div>
          <span>{t.common.email}</span>
          <strong>{donor.courriel || "-"}</strong>
        </div>
        <div>
          <span>{t.donorForm.city}</span>
          <strong>{donor.ville || "-"}</strong>
        </div>
        <div>
          <span>{t.common.member}</span>
          <span className="donor-detail-boolean-value">
            <BooleanIcon value={donor.membre} trueLabel={t.common.yes} falseLabel={t.common.no} />
          </span>
        </div>
        <div>
          <span>{t.nav.receipts}</span>
          <span className="donor-detail-boolean-value">
            <BooleanIcon value={donor.recu} trueLabel={t.common.yes} falseLabel={t.common.no} />
          </span>
        </div>
        <div>
          <span>{t.donorForm.lifetime}</span>
          <strong>{currency(total)}</strong>
        </div>
      </div>

      <div className="panel-subheader">
        <h3>{t.donorForm.donationHistory}</h3>
        {!isExpanded && (
          <button className="icon-button table-icon" type="button" onClick={onExpand} aria-label={t.donorForm.expandProfile} title={t.common.view}>
            <Maximize2 size={15} />
          </button>
        )}
      </div>
      <div className="donor-history-table">
        <DataTable
          t={t}
          paginate={isExpanded}
          columns={[t.donationForm.date, t.donationForm.account, t.donationForm.description, t.donationForm.amount, t.common.status]}
          emptyMessage={t.donorForm.noDonations}
          rows={visibleDonations.map((donation) => [
            donation.dateDon,
            `${donation.noCompte} - ${donation.libelleCompte}`,
            donation.description || "-",
            currency(donation.montant),
            <StatusPill key={`donor-donation-status-${donation.donID}`} t={t} value={donation.receiptStatus} />,
          ])}
        />
      </div>
    </div>
  );
}

function DonorForm({ bootstrap, donor, onSubmit, submitLabel, t }) {
  return (
    <form className="form-grid" onSubmit={onSubmit}>
              <label>
                {t.donorForm.number}
                <input name="numero" placeholder={t.donorForm.autoNumber} defaultValue={donor?.numero || ""} />
              </label>
              <label>
                {t.donorForm.firstName}
                <input name="prenom" required defaultValue={donor?.prenom || ""} />
              </label>
              <label>
                {t.donorForm.lastName}
                <input name="nom" required defaultValue={donor?.nom || ""} />
              </label>
              <label>
                Email
                <input name="courriel" type="email" defaultValue={donor?.courriel || ""} />
              </label>
              <label>
                {t.donorForm.address}
                <input name="adresse" defaultValue={donor?.adresse || ""} />
              </label>
              <label>
                {t.donorForm.city}
                <input name="ville" defaultValue={donor?.ville || ""} />
              </label>
              <label>
                {t.donorForm.postalCode}
                <input name="code_postal" defaultValue={donor?.code_postal || ""} />
              </label>
              <label>
                {t.donorForm.province}
                <select name="provinceID" defaultValue={donor?.provinceID || "1"}>
                  {bootstrap?.provinces?.map((province) => (
                    <option value={province.provinceID} key={province.provinceID}>
                      {province.abreviation} - {province.provinceEtat_en}
                    </option>
                  ))}
                </select>
              </label>
              <label>
                {t.donorForm.cell}
                <input name="tel_cellulaire" defaultValue={donor?.tel_cellulaire || ""} />
              </label>
              <label>
                {t.donorForm.residence}
                <input name="tel_residence" defaultValue={donor?.tel_residence || ""} />
              </label>
              <label className="checkbox-label">
                <input name="membre" type="checkbox" defaultChecked={Boolean(donor?.membre)} />
                <span>{t.common.member}</span>
              </label>
              <label className="checkbox-label">
                <input name="recu" type="checkbox" defaultChecked={donor ? Boolean(donor.recu) : true} />
                <span>{t.donorForm.receiptsEnabled}</span>
              </label>
              <label className="full-field">
                {t.donorForm.notes}
                <textarea name="notes" rows="3" defaultValue={donor?.notes || ""} />
              </label>
              <button className="primary-button form-submit" type="submit">
                <UserPlus size={17} />
                <span>{submitLabel}</span>
              </button>
    </form>
  );
}

function Accounts({ accounts, donations, t, onDelete, onSubmit, onToggle, onUpdate }) {
  const [selectedAccountId, setSelectedAccountId] = useState(null);
  const [editingAccountId, setEditingAccountId] = useState(null);
  const [expandedAccountId, setExpandedAccountId] = useState(null);
  const [activeDrawer, setActiveDrawer] = useState(null);
  const [accountPendingDelete, setAccountPendingDelete] = useState(null);
  const selectedAccount = accounts.find((account) => account.compteID === selectedAccountId);
  const expandedAccount = accounts.find((account) => account.compteID === expandedAccountId);
  const receiptableAccountCount = accounts.filter((account) => account.recu).length;
  const receiptEligibilityPercent = accounts.length ? (receiptableAccountCount / accounts.length) * 100 : 0;
  const accountExportRows = accounts.map((account) => ({
    Number: account.noCompte,
    Account: account.nom,
    Receiptable: account.recu ? t.common.yes : t.common.no,
    Donations: account.donationCount || 0,
    Total: account.total || 0,
  }));

  useEffect(() => {
    if (!accounts.length) {
      setSelectedAccountId(null);
      setEditingAccountId(null);
      setExpandedAccountId(null);
      setAccountPendingDelete(null);
      return;
    }

    if (selectedAccountId && !accounts.some((account) => account.compteID === selectedAccountId)) {
      setSelectedAccountId(null);
      setEditingAccountId(null);
    }

    if (expandedAccountId && !accounts.some((account) => account.compteID === expandedAccountId)) {
      setExpandedAccountId(null);
    }

    if (accountPendingDelete && !accounts.some((account) => account.compteID === accountPendingDelete.compteID)) {
      setAccountPendingDelete(null);
    }
  }, [accounts, selectedAccountId]);

  function submitAccountEdit(event, account) {
    event.preventDefault();
    const data = formObject(event.currentTarget);
    onUpdate(account, {
      ...data,
      recu: data.recu === "on",
    });
    setEditingAccountId(null);
  }

  function accountDonations(account) {
    return donations.filter((donation) => donation.compteID === account.compteID);
  }

  async function submitNewAccount(event) {
    const createdAccount = await onSubmit(event);
    if (createdAccount?.compteID) {
      setSelectedAccountId(createdAccount.compteID);
      setEditingAccountId(null);
      setExpandedAccountId(null);
      setActiveDrawer(null);
    }
  }

  function openAddAccountDrawer() {
    setActiveDrawer("add");
    window.setTimeout(() => focusTarget("account-form"), 0);
  }

  async function confirmDeleteAccount() {
    if (!accountPendingDelete) {
      return;
    }

    await onDelete(accountPendingDelete);
    setAccountPendingDelete(null);
  }

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.accounts.title}
        subtitle={t.accounts.subtitle}
        action={t.accounts.add}
        onAction={openAddAccountDrawer}
        icon={ClipboardList}
        stacked
      />

      {expandedAccount ? (
        <Panel title={`${expandedAccount.noCompte} - ${expandedAccount.nom}`} icon={Maximize2}>
          <div className="expanded-account-toolbar">
            <button className="icon-button" type="button" onClick={() => setExpandedAccountId(null)} aria-label={t.common.cancel}>
              <Minimize2 size={18} />
            </button>
          </div>

          <AccountDetail
            account={expandedAccount}
            donations={accountDonations(expandedAccount)}
            isEditing={editingAccountId === expandedAccount.compteID}
            isExpanded
            onCancelEdit={() => setEditingAccountId(null)}
            onEdit={() => setEditingAccountId(expandedAccount.compteID)}
            onSubmitEdit={(event) => submitAccountEdit(event, expandedAccount)}
            t={t}
          />
        </Panel>
      ) : (
        <Panel title={t.nav.accounts} icon={ClipboardList}>
          <div className="panel-subheader">
            <h3>{t.accounts.title}</h3>
            <div className="export-actions">
              <button className="secondary-button compact" type="button" onClick={() => downloadCSV("accounts.csv", accountExportRows)} disabled={!accountExportRows.length}>
                <FileText size={16} />
                <span>{t.common.csv}</span>
              </button>
              <button className="secondary-button compact" type="button" onClick={() => downloadExcel("accounts.xls", accountExportRows)} disabled={!accountExportRows.length}>
                <FileSpreadsheet size={16} />
                <span>Excel</span>
              </button>
            </div>
          </div>
          <div className="account-accordion">
            {accounts.map((account) => {
              const isOpen = selectedAccount?.compteID === account.compteID;
              const isEditing = editingAccountId === account.compteID;

              return (
                <article className={`account-accordion-item ${isOpen ? "is-open" : ""}`} key={account.compteID}>
                  <button
                    className="account-accordion-summary"
                    type="button"
                    onClick={() => {
                      setSelectedAccountId(isOpen ? null : account.compteID);
                      setEditingAccountId(null);
                    }}
                    aria-expanded={isOpen}
                  >
                    <span className="account-summary-number">{account.noCompte}</span>
                    <span className="account-summary-name">{account.nom}</span>
                    <span className={`status-pill receipt-eligibility ${account.recu ? "is-receiptable" : "is-not-receiptable"}`}>
                      {account.recu ? t.accounts.receiptable : t.accounts.noReceipt}
                    </span>
                    <span className="account-summary-donations">{account.donationCount} {account.donationCount === 1 ? t.accounts.donationSingular : t.accounts.donationPlural}</span>
                    <strong className="account-summary-total">{currency(account.total || 0)}</strong>
                  </button>

                  {isOpen && (
                    <div className="account-accordion-body">
                      <div className="account-actions">
                        <button className="icon-button table-icon" type="button" onClick={() => setEditingAccountId(account.compteID)} aria-label={t.common.edit}>
                          <Pencil size={15} />
                        </button>
                        <button
                          className="icon-button table-icon"
                          type="button"
                          onClick={() => {
                            setSelectedAccountId(null);
                            setEditingAccountId(null);
                          }}
                          aria-label={t.common.cancel}
                        >
                          <Minimize2 size={15} />
                        </button>
                        <button className="icon-button table-icon danger" type="button" onClick={() => setAccountPendingDelete(account)} aria-label={t.common.delete}>
                          <Trash2 size={15} />
                        </button>
                      </div>

                      <AccountDetail
                        account={account}
                        donations={accountDonations(account)}
                        isEditing={isEditing}
                        onCancelEdit={() => setEditingAccountId(null)}
                        onEdit={() => setEditingAccountId(account.compteID)}
                        onSubmitEdit={(event) => submitAccountEdit(event, account)}
                        showInlineEdit={false}
                        t={t}
                      />
                    </div>
                  )}
                </article>
              );
            })}
          </div>
        </Panel>
      )}

      <div className={`donor-edge-drawers account-edge-drawers ${activeDrawer ? "has-open-drawer" : ""}`}>
        <button className={`donor-edge-tab ${activeDrawer === "add" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "add" ? null : "add")} aria-label={t.accounts.add} title={t.accounts.add} aria-expanded={activeDrawer === "add"} aria-controls="account-add-drawer">
          <Plus size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "eligibility" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "eligibility" ? null : "eligibility")} aria-label={t.accounts.eligibility} title={t.accounts.eligibility} aria-expanded={activeDrawer === "eligibility"} aria-controls="account-eligibility-drawer">
          <ReceiptText size={18} />
        </button>

        {activeDrawer === "add" && (
          <aside className="donor-edge-panel app-edge-panel" id="account-add-drawer">
            <EdgePanelHeader icon={Plus} title={t.accounts.add} subtitle={t.accounts.subtitle} onClose={() => setActiveDrawer(null)} t={t} />
          <form className="form-grid" id="account-form" onSubmit={submitNewAccount}>
            <label>
              {t.accounts.accountNumber}
              <input name="noCompte" required type="number" />
            </label>
            <label>
              {t.accounts.name}
              <input name="nom" required />
            </label>
            <label className="checkbox-label">
              <input name="recu" type="checkbox" defaultChecked />
              <span>{t.accounts.eligible}</span>
            </label>
            <button className="primary-button form-submit" type="submit">
              <Plus size={17} />
              <span>{t.accounts.add}</span>
            </button>
          </form>
          </aside>
        )}

        {activeDrawer === "eligibility" && (
          <aside className="donor-edge-panel app-edge-panel" id="account-eligibility-drawer">
            <EdgePanelHeader icon={ReceiptText} title={t.accounts.eligibility} subtitle={t.accounts.eligibilityText} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="account-eligibility-panel">
              <div className="readiness">
            <div>
                  <strong>{receiptableAccountCount}</strong>
              <span>{t.accounts.eligibilityText}</span>
            </div>
            <div className="progress">
                  <span style={{ width: `${receiptEligibilityPercent}%` }} />
            </div>
          </div>
              <div className="account-eligibility-stats">
                <div>
                  <span>{t.accounts.receiptable}</span>
                  <strong>{receiptableAccountCount}</strong>
                </div>
                <div className="is-no-receipt">
                  <span>{t.accounts.noReceipt}</span>
                  <strong>{accounts.length - receiptableAccountCount}</strong>
                </div>
                <div>
                  <span>{t.nav.accounts}</span>
                  <strong>{accounts.length}</strong>
                </div>
              </div>
            </div>
          </aside>
        )}
      </div>

      {accountPendingDelete && (
        <ConfirmDialog
          body={t.accounts.deleteBody.replace("{number}", accountPendingDelete.noCompte).replace("{name}", accountPendingDelete.nom)}
          confirmLabel={t.common.delete}
          isDanger
          onCancel={() => setAccountPendingDelete(null)}
          onConfirm={confirmDeleteAccount}
          t={t}
          title={t.accounts.deleteTitle}
        />
      )}

    </section>
  );
}

function ConfirmDialog({ body, confirmLabel, icon: Icon = Trash2, isDanger = false, onCancel, onConfirm, t, title }) {
  return (
    <div className="modal-backdrop" role="presentation" onClick={onCancel}>
      <section className="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="confirm-dialog-title" onClick={(event) => event.stopPropagation()}>
        <div className={`confirm-dialog-icon ${isDanger ? "is-danger" : ""}`}>
          <Icon size={20} />
        </div>
        <div>
          <h2 id="confirm-dialog-title">{title}</h2>
          <p>{body}</p>
        </div>
        <div className="confirm-dialog-actions">
          <button className="secondary-button" type="button" onClick={onCancel}>
            <X size={16} />
            <span>{t.common.cancel}</span>
          </button>
          <button className={isDanger ? "primary-button danger-button" : "primary-button"} type="button" onClick={onConfirm}>
            <Check size={16} />
            <span>{confirmLabel || t.common.confirm}</span>
          </button>
        </div>
      </section>
    </div>
  );
}

function PageTourOverlay({ doneLabel, onClose, steps, subtitle, title }) {
  return (
    <div className="page-tour-overlay" role="presentation" onClick={onClose}>
      <section className="page-tour-card" role="dialog" aria-modal="true" aria-label={title} onClick={(event) => event.stopPropagation()}>
        <EdgePanelHeader icon={HelpCircle} title={title} subtitle={subtitle} onClose={onClose} t={{ common: { close: doneLabel, cancel: doneLabel } }} />
        <div className="page-tour-steps">
          {steps.map((step) => (
            <article className="page-tour-step" key={step.title}>
              <PageTourVisual visual={step.visual} />
              <div>
                <h3>{step.title}</h3>
                <p>{step.body}</p>
              </div>
            </article>
          ))}
        </div>
        <button className="primary-button page-tour-done" type="button" onClick={onClose}>
          <Check size={16} />
          <span>{doneLabel}</span>
        </button>
      </section>
    </div>
  );
}

function PageTourVisual({ visual }) {
  if (visual === "search") {
    return (
      <span className="page-tour-search-visual" aria-hidden="true">
        <Search size={15} />
        <i />
      </span>
    );
  }

  const Icon = {
    add: UserPlus,
    banking: Landmark,
    card: CreditCard,
    download: Download,
    stats: BarChart3,
    edit: Pencil,
    help: HelpCircle,
    import: Download,
    integration: BookOpenCheck,
    mail: Mail,
    palette: Palette,
    pending: Bell,
    plan: Sparkles,
    preview: LayoutDashboard,
    print: Printer,
    receipt: ReceiptText,
    users: Users,
  }[visual] || HelpCircle;

  return (
    <span className="page-tour-icon-visual" aria-hidden="true">
      <Icon size={18} />
    </span>
  );
}

function AccountDetail({ account, donations, isEditing, isExpanded = false, onCancelEdit, onEdit, onSubmitEdit, showInlineEdit = true, t }) {
  if (isEditing) {
    return (
      <form className="form-grid compact-account-form" onSubmit={onSubmitEdit}>
        <label>
          {t.accounts.accountNumber}
          <input name="noCompte" required type="number" defaultValue={account.noCompte} />
        </label>
        <label>
          {t.accounts.name}
          <input name="nom" required defaultValue={account.nom} />
        </label>
        <label className="checkbox-label">
          <input name="recu" type="checkbox" defaultChecked={Boolean(account.recu)} />
          <span>{t.accounts.eligible}</span>
        </label>
        <div className="account-edit-actions">
          <button className="secondary-button" type="button" onClick={onCancelEdit}>
            <X size={16} />
            <span>{t.common.cancel}</span>
          </button>
          <button className="primary-button" type="submit">
            <Check size={16} />
            <span>{t.common.save}</span>
          </button>
        </div>
      </form>
    );
  }

  return (
    <>
      <div className={`account-detail-grid ${isExpanded ? "is-expanded" : ""}`}>
        <div>
          <span>{t.accounts.accountNumber}</span>
          <strong>{account.noCompte}</strong>
        </div>
        <div>
          <span>{t.accounts.name}</span>
          <strong>{account.nom}</strong>
        </div>
        <div>
          <span>{t.nav.receipts}</span>
          <strong className={`receipt-eligibility-text ${account.recu ? "is-receiptable" : "is-not-receiptable"}`}>
            {account.recu ? t.accounts.receiptable : t.accounts.noReceipt}
          </strong>
        </div>
        <div>
          <span>{t.nav.donations}</span>
          <strong>{account.donationCount}</strong>
        </div>
        <div>
          <span>{t.receipts.total}</span>
          <strong>{currency(account.total || 0)}</strong>
        </div>
      </div>

      <div className="panel-subheader">
        <h3>{t.accounts.donationsList}</h3>
        {showInlineEdit && (
          <button className="icon-button table-icon" type="button" onClick={onEdit} aria-label={t.common.edit}>
            <Pencil size={15} />
          </button>
        )}
      </div>

      <DataTable
        t={t}
        columns={[t.donationForm.date, t.donationForm.donor, t.donationForm.description, t.donationForm.amount, t.common.status]}
        rows={donations.map((donation) => [
          donation.dateDon,
          donation.donorName,
          donation.description || "-",
          currency(donation.montant),
          <StatusPill key={`account-donation-${donation.donID}`} t={t} value={donation.receiptStatus} />,
        ])}
        emptyMessage={t.accounts.emptyDonations}
      />
    </>
  );
}

function Receipts({ batches, dashboard, donations, receipts, t, onGenerate, onMark }) {
  const readyRows = donations.filter((donation) => donation.receiptStatus === "Ready");
  const reviewRows = donations.filter((donation) => donation.receiptStatus === "No receipt");
  const receiptExportRows = receipts.map((receipt) => ({
    Number: receipt.noRecu || receipt.recuID,
    Donor: `${receipt.prenom} ${receipt.nom}`,
    Period: `${receipt.dateDebut} ${t.common.to} ${receipt.dateFin}`,
    Amount: receipt.montant,
    Status: humanStatus(receipt.statut, t),
  }));
  const batchExportRows = batches.map((batch) => ({
    Created: new Date(batch.dateCreation).toLocaleString(),
    Period: `${batch.dateDebut} ${t.common.to} ${batch.dateFin}`,
    Count: batch.recusCount,
    Total: batch.total,
  }));

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.receipts.title}
        subtitle={t.receipts.subtitle}
        action={t.receipts.action}
        actionTargetId="receipt-generator"
        icon={ReceiptText}
        onAction={() => submitTarget("receipt-generator")}
      />

      <div className="receipt-band">
        <div className="receipt-copy">
          <img src={receiptImage} alt="" />
          <div>
            <span className="eyebrow">{t.receipts.batch}</span>
            <h2>{t.receipts.annualBatch}</h2>
            <p>{t.receipts.batchSummary.replace("{ready}", readyRows.length).replace("{review}", reviewRows.length)}</p>
          </div>
        </div>
        <form id="receipt-generator" className="receipt-actions compact-form" onSubmit={onGenerate}>
          <input name="dateDebut" type="date" defaultValue={defaultReceiptPeriod.dateDebut} aria-label={t.receipts.startDate} />
          <input name="dateFin" type="date" defaultValue={defaultReceiptPeriod.dateFin} aria-label={t.receipts.endDate} />
          <select name="mode" defaultValue="email" aria-label={t.receipts.mode}>
            <option value="email">Email</option>
            <option value="print">{t.common.print}</option>
          </select>
          <button className="primary-button" type="submit">
            <FileCheck2 size={17} />
            <span>{t.receipts.action}</span>
          </button>
        </form>
      </div>

      <div className="metric-grid">
        <article className="metric-card tone-blue">
          <span>{t.receipts.stored}</span>
          <strong>{receipts.length}</strong>
          <small>{currency(receipts.reduce((sum, receipt) => sum + receipt.montant, 0))}</small>
        </article>
        <article className="metric-card tone-green">
          <span>{t.receipts.readyGifts}</span>
          <strong>{dashboard?.totals?.pendingReceipts || 0}</strong>
          <small>{t.receipts.eligibleRows}</small>
        </article>
        <article className="metric-card tone-amber">
          <span>{t.receipts.batches}</span>
          <strong>{batches.length}</strong>
          <small>{t.receipts.generatedLabel}</small>
        </article>
        <article className="metric-card tone-red">
          <span>{t.receipts.review}</span>
          <strong>{reviewRows.length}</strong>
          <small>{t.receipts.notReceiptable}</small>
        </article>
      </div>

      <div className="two-column">
        <Panel title={t.nav.receipts} icon={Check}>
          <div className="panel-subheader">
            <h3>{t.nav.receipts}</h3>
            <div className="export-actions">
              <button className="secondary-button compact" type="button" onClick={() => downloadCSV("receipts.csv", receiptExportRows)} disabled={!receiptExportRows.length}>
                <FileText size={16} />
                <span>{t.common.csv}</span>
              </button>
              <button className="secondary-button compact" type="button" onClick={() => downloadExcel("receipts.xls", receiptExportRows)} disabled={!receiptExportRows.length}>
                <FileSpreadsheet size={16} />
                <span>Excel</span>
              </button>
            </div>
          </div>
          <DataTable
            t={t}
            columns={["No.", t.donationForm.donor, t.receipts.period, t.donationForm.amount, t.common.status, ""]}
            rows={receipts.map((receipt) => [
              receipt.noRecu || receipt.recuID,
              `${receipt.prenom} ${receipt.nom}`,
              `${receipt.dateDebut} ${t.common.to} ${receipt.dateFin}`,
              currency(receipt.montant),
              <StatusPill key={`status-${receipt.recuID}`} t={t} value={humanStatus(receipt.statut, t)} />,
              receipt.envoiID ? (
                <button className="secondary-button compact" type="button" onClick={() => onMark(receipt.envoiID, "2-livre")} key={`mark-${receipt.recuID}`}>
                  {t.receipts.markSent}
                </button>
              ) : "-",
            ])}
          />
        </Panel>

        <Panel title={t.receipts.batches} icon={Printer}>
          <div className="panel-subheader">
            <h3>{t.receipts.batches}</h3>
            <div className="export-actions">
              <button className="secondary-button compact" type="button" onClick={() => downloadCSV("receipt-batches.csv", batchExportRows)} disabled={!batchExportRows.length}>
                <FileText size={16} />
                <span>{t.common.csv}</span>
              </button>
              <button className="secondary-button compact" type="button" onClick={() => downloadExcel("receipt-batches.xls", batchExportRows)} disabled={!batchExportRows.length}>
                <FileSpreadsheet size={16} />
                <span>Excel</span>
              </button>
            </div>
          </div>
          <DataTable
            t={t}
            columns={[t.receipts.created, t.receipts.period, t.receipts.count, t.receipts.total]}
            rows={batches.map((batch) => [
              new Date(batch.dateCreation).toLocaleString(),
              `${batch.dateDebut} ${t.common.to} ${batch.dateFin}`,
              batch.recusCount,
              currency(batch.total),
            ])}
          />
        </Panel>
      </div>
    </section>
  );
}

function Reports({ customTemplates = [], reportResult, t, onCreateTemplate, onRunReport }) {
  const [selectedTemplateId, setSelectedTemplateId] = useState(t.reports.templates[0]?.id || "donation-detail");
  const [showCustomTemplateForm, setShowCustomTemplateForm] = useState(false);
  const [customTemplateDraft, setCustomTemplateDraft] = useState({
    title: "",
    description: "",
    type: "donations",
    groupBy: "accountMonth",
    automatic: false,
    frequency: "weekly",
    day: "monday",
  });
  const summary = reportResult?.summary || [];
  const rows = Array.isArray(reportResult) ? reportResult : reportResult?.rows || reportResult || [];
  const reportTemplates = [...t.reports.templates, ...customTemplates];
  const selectedTemplate = reportTemplates.find((template) => template.id === selectedTemplateId) || reportTemplates[0];
  const downloadableRows = reportExportRows(rows, summary, selectedTemplate, t);
  const reportRowCount = Array.isArray(rows) ? rows.length : 0;
  const reportGroupCount = summary.length;
  const reportTotal = summary.reduce((sum, item) => sum + Number(item.total || 0), 0);

  function updateCustomTemplateDraft(field, value) {
    setCustomTemplateDraft((draft) => ({ ...draft, [field]: value }));
  }

  async function saveCustomTemplate() {
    const title = customTemplateDraft.title.trim();

    if (!title) {
      return;
    }

    const template = await onCreateTemplate({
      title,
      description: customTemplateDraft.description.trim() || t.reports.customTemplateDescription,
      type: customTemplateDraft.type,
      groupBy: customTemplateDraft.groupBy,
      automatic: customTemplateDraft.automatic,
      frequency: customTemplateDraft.frequency,
      day: customTemplateDraft.day,
    });

    if (!template) {
      return;
    }

    setSelectedTemplateId(template.id);
    setShowCustomTemplateForm(false);
    setCustomTemplateDraft({
      title: "",
      description: "",
      type: "donations",
      groupBy: "accountMonth",
      automatic: false,
      frequency: "weekly",
      day: "monday",
    });
  }

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.reports.title}
        subtitle={t.reports.subtitle}
        action={t.reports.run}
        actionTargetId="report-builder"
        icon={BarChart3}
      />

      <Panel id="report-builder" title={t.reports.builder} icon={FileText}>
        <form className="report-builder-form" onSubmit={onRunReport}>
          <div className="report-builder-intro">
            <span className="report-builder-icon"><BarChart3 size={20} /></span>
            <div>
              <strong>{t.reports.builder}</strong>
            </div>
          </div>
          <div className="report-template-grid">
            {reportTemplates.map((template) => (
              <label className={`report-template-card ${selectedTemplateId === template.id ? "is-selected" : ""}`} key={template.id}>
                <input
                  checked={selectedTemplateId === template.id}
                  name="reportTemplate"
                  onChange={() => setSelectedTemplateId(template.id)}
                  type="radio"
                  value={template.id}
                />
                <span>{template.custom ? <Sparkles size={16} /> : <FileText size={16} />} {template.title}</span>
                <small>{template.description}</small>
                {template.automatic && (
                  <em><CalendarDays size={14} /> {formatTemplateSchedule(template, t)}</em>
                )}
              </label>
            ))}
            <button
              className={`report-template-card report-template-create ${showCustomTemplateForm ? "is-selected" : ""}`}
              onClick={() => setShowCustomTemplateForm((isOpen) => !isOpen)}
              type="button"
            >
              <span><Plus size={17} /> {t.reports.customTemplate}</span>
              <small>{t.reports.customTemplateDescription}</small>
            </button>
          </div>
          {showCustomTemplateForm && (
            <div className="custom-report-template">
              <div className="custom-report-template-header">
                <span className="report-builder-icon"><Sparkles size={19} /></span>
                <div>
                  <strong>{t.reports.customTemplates}</strong>
                  <small>{t.reports.customTemplateDescription}</small>
                </div>
              </div>
              <div className="custom-report-template-fields">
                <label className="is-wide">
                  <span>{t.reports.templateName}</span>
                  <input
                    onChange={(event) => updateCustomTemplateDraft("title", event.target.value)}
                    placeholder={t.reports.templateName}
                    type="text"
                    value={customTemplateDraft.title}
                  />
                </label>
                <label className="is-wide">
                  <span>{t.reports.templateDescription}</span>
                  <input
                    onChange={(event) => updateCustomTemplateDraft("description", event.target.value)}
                    placeholder={t.reports.customTemplateDescription}
                    type="text"
                    value={customTemplateDraft.description}
                  />
                </label>
                <label>
                  <span>{t.reports.reportType}</span>
                  <select value={customTemplateDraft.type} onChange={(event) => updateCustomTemplateDraft("type", event.target.value)}>
                    <option value="donations">{t.reports.donations}</option>
                    <option value="receipts">{t.reports.receipts}</option>
                  </select>
                </label>
                <label>
                  <span>{t.reports.groupBy}</span>
                  <select value={customTemplateDraft.groupBy} onChange={(event) => updateCustomTemplateDraft("groupBy", event.target.value)}>
                    <option value="date">{t.reports.date}</option>
                    <option value="month">{t.reports.month}</option>
                    <option value="accountMonth">{t.reports.accountsByMonth}</option>
                    <option value="account">{t.reports.account}</option>
                    <option value="donor">{t.reports.donor}</option>
                    <option value="method">{t.reports.method}</option>
                  </select>
                </label>
                <label className="custom-template-toggle is-wide">
                  <input
                    checked={customTemplateDraft.automatic}
                    onChange={(event) => updateCustomTemplateDraft("automatic", event.target.checked)}
                    type="checkbox"
                  />
                  <span>{t.reports.generateAutomatically}</span>
                </label>
                {customTemplateDraft.automatic && (
                  <>
                    <label>
                      <span>{t.reports.frequency}</span>
                      <select value={customTemplateDraft.frequency} onChange={(event) => updateCustomTemplateDraft("frequency", event.target.value)}>
                        <option value="weekly">{t.reports.weekly}</option>
                        <option value="monthly">{t.reports.monthly}</option>
                      </select>
                    </label>
                    <label>
                      <span>{t.reports.day}</span>
                      <select value={customTemplateDraft.day} onChange={(event) => updateCustomTemplateDraft("day", event.target.value)}>
                        {customTemplateDraft.frequency === "weekly" ? (
                          <>
                            <option value="monday">{t.reports.monday}</option>
                            <option value="tuesday">{t.reports.tuesday}</option>
                            <option value="wednesday">{t.reports.wednesday}</option>
                            <option value="thursday">{t.reports.thursday}</option>
                            <option value="friday">{t.reports.friday}</option>
                          </>
                        ) : (
                          <>
                            <option value="first">{t.reports.firstDay}</option>
                            <option value="fifteenth">{t.reports.fifteenthDay}</option>
                            <option value="last">{t.reports.lastDay}</option>
                          </>
                        )}
                      </select>
                    </label>
                  </>
                )}
              </div>
              <div className="report-builder-actions">
                <button className="primary-button" disabled={!customTemplateDraft.title.trim()} onClick={saveCustomTemplate} type="button">
                  <Plus size={17} />
                  <span>{t.reports.saveTemplate}</span>
                </button>
              </div>
            </div>
          )}
          <input name="type" readOnly type="hidden" value={selectedTemplate.type} />
          <input name="groupBy" readOnly type="hidden" value={selectedTemplate.groupBy} />
          <div className="report-builder-fields">
            <label>
              <span>{t.reports.start}</span>
              <input name="dateDebut" type="date" defaultValue="2026-01-01" />
            </label>
            <label>
              <span>{t.reports.end}</span>
              <input name="dateFin" type="date" defaultValue="2026-12-31" />
            </label>
          </div>
          <div className="report-builder-actions">
            <button className="primary-button" type="submit">
              <BarChart3 size={17} />
              <span>{t.reports.run}</span>
            </button>
            <button className="secondary-button" type="button" disabled={!downloadableRows.length} onClick={() => downloadCSV("weserve-report.csv", downloadableRows)}>
              <FileText size={17} />
              <span>{t.common.csv}</span>
            </button>
            <button className="secondary-button" type="button" disabled={!downloadableRows.length} onClick={() => downloadExcel("weserve-report.xls", downloadableRows)}>
              <FileSpreadsheet size={17} />
              <span>Excel</span>
            </button>
          </div>
        </form>
      </Panel>

      {(reportGroupCount > 0 || reportRowCount > 0) && (
        <section className="report-result-strip" aria-label={t.reports.summary}>
          <article>
            <span>{t.reports.group}</span>
            <strong>{reportGroupCount}</strong>
          </article>
          <article>
            <span>{t.reports.rows}</span>
            <strong>{reportRowCount}</strong>
          </article>
          <article>
            <span>{t.receipts.total}</span>
            <strong>{currency(reportTotal)}</strong>
          </article>
        </section>
      )}

      {(summary.length > 0 || rows.length > 0) && (
        <Panel title={t.reports.generatedView} icon={ClipboardList}>
          <ReportResultView rows={rows} selectedTemplate={selectedTemplate} summary={summary} t={t} />
        </Panel>
      )}
    </section>
  );
}

function ReportResultView({ rows, selectedTemplate, summary, t }) {
  if (!summary.length && !rows.length) {
    return <div className="empty-state">{t.reports.noReport}</div>;
  }

  if (selectedTemplate.groupBy === "accountMonth") {
    return <AccountsByMonthReport rows={rows} t={t} />;
  }

  if (selectedTemplate.groupBy === "month") {
    return <SummaryCardReport summary={summary} t={t} variant="month" />;
  }

  if (selectedTemplate.groupBy === "donor" || selectedTemplate.groupBy === "account" || selectedTemplate.groupBy === "method") {
    return <SummaryCardReport summary={summary} t={t} />;
  }

  if (selectedTemplate.id === "donation-detail") {
    return <DonationDetailReport rows={rows} t={t} />;
  }

  if (selectedTemplate.type === "receipts") {
    return (
      <DataTable
        columns={Object.keys(rows[0] || {}).slice(0, 8)}
        rows={rows.slice(0, 50).map((row) => Object.values(row).slice(0, 8).map(formatCell))}
        t={t}
      />
    );
  }

  return (
    <DataTable
      columns={[t.reports.group, t.receipts.count, t.receipts.total]}
      rows={summary.map((item) => [formatReportLabel(item.label, t), item.count, currency(item.total)])}
    />
  );
}

function AccountsByMonthReport({ rows, t }) {
  const sections = accountMonthSummary(rows, t);

  return (
    <div className="report-section-stack">
      {sections.map((section) => (
        <article className="report-section-card" key={section.monthKey}>
          <div className="report-section-header">
            <div>
              <span>{t.reports.monthlySections}</span>
              <h3>{section.title}</h3>
            </div>
            <strong>{currency(section.total)}</strong>
          </div>
          <div className="report-line-list">
            {section.items.map((item) => (
              <div className="report-line-item" key={item.label}>
                <div>
                  <strong>{item.label}</strong>
                  <span>{item.count} {t.reports.countLabel}</span>
                </div>
                <b>{currency(item.total)}</b>
              </div>
            ))}
          </div>
        </article>
      ))}
    </div>
  );
}

function accountMonthSummary(rows, t) {
  return Array.from(rows.reduce((months, donation) => {
    const monthKey = String(donation.dateDon || "").slice(0, 7) || "Unknown";
    const month = months.get(monthKey) || new Map();
    const accountKey = `${donation.noCompte || ""} - ${donation.libelleCompte || t.common.unspecified}`;
    const account = month.get(accountKey) || {
      label: accountKey,
      count: 0,
      total: 0,
    };
    account.count += 1;
    account.total += Number(donation.montant || 0);
    month.set(accountKey, account);
    months.set(monthKey, month);
    return months;
  }, new Map()).entries())
    .sort(([left], [right]) => right.localeCompare(left))
    .map(([monthKey, accounts]) => {
      const items = Array.from(accounts.values()).sort((left, right) => left.label.localeCompare(right.label));
      return {
        monthKey,
        title: monthName(monthKey, t),
        total: items.reduce((sum, item) => sum + item.total, 0),
        count: items.reduce((sum, item) => sum + item.count, 0),
        items,
      };
    });
}

function SummaryCardReport({ summary, t, variant }) {
  const items = [...summary].sort((left, right) => String(right.label).localeCompare(String(left.label)));

  return (
    <div className="report-summary-grid">
      {items.map((item) => (
        <article className="report-summary-card" key={item.label}>
          <span>{variant === "month" ? monthName(item.label, t) : formatReportLabel(item.label, t)}</span>
          <strong>{currency(item.total)}</strong>
          <small>{item.count} {t.reports.countLabel}</small>
        </article>
      ))}
    </div>
  );
}

function DonationDetailReport({ rows, t }) {
  return (
    <DataTable
      columns={[t.reports.date, t.reports.donor, t.reports.account, t.reports.method, t.receipts.total]}
      rows={rows.map((row) => [
        formatCell(row.dateDon),
        row.donorName || t.common.unspecified,
        `${row.noCompte || ""} - ${row.libelleCompte || t.common.unspecified}`,
        row.methode_en || t.common.unspecified,
        currency(row.montant),
      ])}
      t={t}
      paginate
    />
  );
}

function reportExportRows(rows, summary, selectedTemplate, t) {
  if (selectedTemplate?.groupBy === "accountMonth") {
    return accountMonthSummary(rows, t).flatMap((section) => section.items.map((item) => ({
      Month: section.title,
      Account: item.label,
      Donations: item.count,
      Total: item.total,
    })));
  }

  if (selectedTemplate?.groupBy === "month") {
    return summary.map((item) => ({
      Month: monthName(item.label, t),
      Donations: item.count,
      Total: item.total,
    }));
  }

  if (["account", "donor", "method"].includes(selectedTemplate?.groupBy)) {
    return summary.map((item) => ({
      Group: formatReportLabel(item.label, t),
      Donations: item.count,
      Total: item.total,
    }));
  }

  if (selectedTemplate?.type === "receipts") {
    return rows.map((row) => ({ ...row }));
  }

  return rows.map((row) => ({
    Date: row.dateDon,
    Donor: row.donorName || t.common.unspecified,
    Account: `${row.noCompte || ""} - ${row.libelleCompte || t.common.unspecified}`,
    Method: row.methode_en || t.common.unspecified,
    Amount: row.montant,
    Status: translateStatus(row.receiptStatus, t),
  }));
}

function TenantsView({ tenants = [], t }) {
  const activeTenants = tenants.filter((tenant) => tenant.actif).length;

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.saas.tenantOverview}
        subtitle={t.saas.tenantSubtitle}
        icon={Globe2}
      />

      <div className="overview-metric-grid tenant-metric-grid">
        {[
          [t.saas.tenantCount, tenants.length],
          [t.saas.activeTenants, activeTenants],
          [t.settings.users, tenants.reduce((total, tenant) => total + Number(tenant.activeUsers || 0), 0)],
        ].map(([label, value]) => (
          <article className="metric-card" key={label}>
            <span className="metric-card-title">
              <Building2 size={17} />
              <span>{label}</span>
            </span>
            <strong>{value}</strong>
          </article>
        ))}
      </div>

      <Panel title={t.saas.tenants} icon={Building2}>
        <DataTable
          columns={[t.settings.organizationName, t.saas.subscriptionModel, t.common.status, t.settings.users, t.donorForm.totalDonors, t.donationForm.donations, t.saas.renews]}
          rows={tenants.map((tenant) => [
            tenant.organisme,
            tenant.planName || "-",
            tenant.actif ? t.common.active : t.common.inactive,
            tenant.activeUsers,
            tenant.donors,
            tenant.donations,
            `${currency(tenant.renewalAmount)} / ${tenant.billingCycle || "-"}`,
          ])}
          emptyMessage={t.common.noRecords}
          paginate
          t={t}
        />
      </Panel>
    </section>
  );
}

function Subscription({ saas, member, setMember, subscriptionAnswer, setSubscriptionAnswer, t, onPlanChange, onSubmit, onToggleTask }) {
  const subscription = saas?.subscription;
  const currentPlanID = subscription?.planID || "base";
  const plans = saas?.plans?.length ? saas.plans : t.subscription.plansList.map((plan) => ({
    planID: plan.name.toLowerCase(),
    name: plan.name,
    monthlyPrice: Number(String(plan.price).replace(/[^0-9.]/g, "")) || 0,
    annualPrice: (Number(String(plan.price).replace(/[^0-9.]/g, "")) || 0) * 10,
    description: plan.description,
    features: plan.features,
    recommended: plan.name === "Gold",
  }));
  const [billingCycle, setBillingCycle] = useState(subscription?.billingCycle || "monthly");

  useEffect(() => {
    setBillingCycle(subscription?.billingCycle || "monthly");
  }, [subscription?.billingCycle]);

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.subscription.title}
        subtitle={t.subscription.subtitle}
        action={t.subscription.submit}
        actionTargetId="subscription-form"
        icon={Building2}
        stacked
      />

      <Panel title={t.subscription.plans} icon={Sparkles}>
        <div className="billing-cycle-toggle" role="group" aria-label={t.saas.billingCycle}>
          {["monthly", "annual"].map((cycle) => (
            <button
              className={billingCycle === cycle ? "secondary-button active" : "secondary-button"}
              key={cycle}
              type="button"
              onClick={() => setBillingCycle(cycle)}
            >
              {cycle === "annual" ? t.saas.annual : t.saas.monthly}
            </button>
          ))}
          <span>{t.saas.annualSavings}</span>
        </div>
        <div className="subscription-plan-grid">
          {plans.map((plan) => (
            <article className={`subscription-plan plan-${plan.name.toLowerCase()} ${plan.planID === currentPlanID ? "is-current" : ""} ${plan.recommended ? "is-featured" : ""}`} key={plan.planID}>
              {plan.planID === currentPlanID && <span className="plan-badge">{t.subscription.currentPlan}</span>}
              <span>{plan.name}</span>
              <strong>{currency(billingCycle === "annual" ? plan.annualPrice : plan.monthlyPrice)}<small>/{billingCycle === "annual" ? "yr" : "mo"}</small></strong>
              <p>{plan.description}</p>
              <dl className="plan-limit-list">
                <div><dt>{t.settings.includedSeats}</dt><dd>{plan.includedSeats}</dd></div>
                <div><dt>{t.saas.included}</dt><dd>{plan.donorLimit?.toLocaleString?.() || plan.donorLimit} donors</dd></div>
              </dl>
              <ul>
                {plan.features.map((feature) => (
                  <li key={feature}><CheckCircle2 size={16} /> {feature}</li>
                ))}
              </ul>
              <button className={plan.planID === currentPlanID ? "secondary-button" : "primary-button"} type="button" disabled={plan.planID === currentPlanID} onClick={() => onPlanChange(plan.planID, billingCycle)}>
                <span>{plan.planID === currentPlanID ? t.subscription.currentPlan : t.saas.choosePlan}</span>
              </button>
            </article>
          ))}
        </div>
      </Panel>

      {saas?.usage && (
        <Panel title={t.saas.usage} icon={BarChart3}>
          <div className="usage-meter-grid">
            {Object.entries(saas.usage).map(([metricKey, metric]) => (
              <UsageMeter key={metricKey} metric={metric} t={t} />
            ))}
          </div>
          {subscription && (
            <div className="subscription-status-card">
              <span className="status-pill issued">{subscription.status}</span>
              <dl>
                <div><dt>{t.saas.currentPeriod}</dt><dd>{subscription.currentPeriodStart} {t.common.to} {subscription.currentPeriodEnd}</dd></div>
                <div><dt>{t.saas.renews}</dt><dd>{currency(subscription.renewalAmount)} / {subscription.billingCycle}</dd></div>
                <div><dt>{t.saas.trialEnds}</dt><dd>{subscription.trialEndsAt || "-"}</dd></div>
              </dl>
            </div>
          )}
        </Panel>
      )}

      {saas?.onboardingTasks?.length > 0 && (
        <Panel title={t.saas.onboarding} icon={CheckCircle2}>
          <div className="onboarding-checklist">
            {saas.onboardingTasks.map((task) => (
              <button className={task.completed ? "onboarding-task is-complete" : "onboarding-task"} key={task.taskKey} type="button" onClick={() => onToggleTask(task)}>
                {task.completed ? <CheckCircle2 size={18} /> : <CircleDollarSign size={18} />}
                <span>{task.title}</span>
                <small>{task.completed ? t.common.done || "Done" : t.common.pending}</small>
              </button>
            ))}
          </div>
        </Panel>
      )}

      <Panel id="subscription-form" title={t.subscription.submissionRequest} icon={ClipboardList}>
          <form className="form-grid subscription-form" onSubmit={onSubmit}>
            <label>
              {t.subscription.charityName}
              <input name="organisme" required maxLength="50" />
            </label>
            <label>
              {t.subscription.registrationNumber}
              <input name="enregistrement" required maxLength="30" />
            </label>
            <label>
              {t.subscription.personInCharge}
              <input name="responsable" required maxLength="50" />
            </label>
            <label>
              {t.common.email}
              <input name="responsable_courriel" required type="email" />
            </label>
            <label>
              {t.subscription.address}
              <input name="adresse" />
            </label>
            <label>
              {t.subscription.city}
              <input name="ville" />
            </label>
            <label>
              {t.subscription.province}
              <input name="province" defaultValue="Quebec" />
            </label>
            <label>
              {t.subscription.phone}
              <input name="telephone" />
            </label>
            <label className="checkbox-label">
              <input checked={member} onChange={(event) => setMember(event.target.checked)} type="checkbox" />
              <span>{t.common.member}</span>
            </label>
            {member && (
              <label>
                {t.subscription.memberNumber}
                <input name="nomembre" />
              </label>
            )}
            <label>
              {t.subscription.security}
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
    </section>
  );
}

function UsageMeter({ metric, t }) {
  const percent = Math.min(Number(metric.percent || 0), 100);

  return (
    <article className="usage-meter">
      <div>
        <span>{metric.label}</span>
        <strong>{metric.used?.toLocaleString?.() || metric.used} / {metric.limit?.toLocaleString?.() || metric.limit}</strong>
      </div>
      <div className="usage-bar" aria-label={`${metric.label} ${percent}%`}>
        <span style={{ width: `${percent}%` }} />
      </div>
      <small>{metric.remaining?.toLocaleString?.() || metric.remaining} {t.saas.remaining}</small>
    </article>
  );
}

function roleLabel(role, t, definitions = {}) {
  return t.settings.roleDescriptions?.[role] || definitions[role]?.label || role;
}

function roleOptionsForUser(bootstrap, user) {
  const options = bootstrap?.roleOptions?.length ? bootstrap.roleOptions : ["org_admin", "editor", "auditor", "viewer"];
  return user?.role === "saas_admin" ? options : options.filter((role) => role !== "saas_admin");
}

function RoleSelect({ bootstrap, disabled = false, name = "role", t, user, value = "viewer" }) {
  const definitions = bootstrap?.roleDefinitions || {};

  return (
    <select name={name} defaultValue={value || "viewer"} disabled={disabled}>
      {roleOptionsForUser(bootstrap, user).map((role) => (
        <option value={role} key={role}>
          {roleLabel(role, t, definitions)}
        </option>
      ))}
    </select>
  );
}

function SettingsView({ bootstrap, saasSecret, setSaasSecret, t, user, onCustomize, onCreateApiKey, onCreatePaymentMethod, onCreateUser, onCreateWebhook, onDeletePaymentMethod, onDeleteWebhook, onRevokeApiKey, onTestWebhook, onUpdateSecurity, onUpdateUser, onSubmit, onUserStatus }) {
  const organization = bootstrap?.organisme || {};
  const saas = bootstrap?.saas || {};
  const subscription = saas.subscription || {};
  const currentPlan = subscription.plan || {};
  const users = bootstrap?.users?.length ? bootstrap.users : [user].filter(Boolean);
  const isAdmin = Boolean(user?.admin);
  const currentPlanName = currentPlan.name || "Base";
  const currentSeatPlan = {
    seats: currentPlan.includedSeats || userSeatPlans[currentPlanName]?.seats || 1,
    next: userSeatPlans[currentPlanName]?.next || null,
  };
  const activeSeatCount = users.filter((account) => account?.actif !== false).length;
  const seatsRemaining = Math.max(currentSeatPlan.seats - activeSeatCount, 0);
  const canAddUser = seatsRemaining > 0;
  const [addPaymentOpen, setAddPaymentOpen] = useState(false);
  const [activeDrawer, setActiveDrawer] = useState(null);
  const [editingUserId, setEditingUserId] = useState(null);
  const [openSettingsSections, setOpenSettingsSections] = useState({
    profile: true,
    users: false,
    payments: false,
    security: false,
    api: false,
    audit: false,
  });
  const toggleSettingsSection = (section) => {
    setOpenSettingsSections((openSections) => ({
      ...openSections,
      [section]: !openSections[section],
    }));
  };
  const openProfileSection = () => {
    setOpenSettingsSections((openSections) => ({ ...openSections, profile: true }));
    window.setTimeout(() => focusTarget("organization-profile"), 0);
  };
  const editingUser = users.find((account) => account.utilisateurID === editingUserId);

  return (
    <section className="view-stack settings-page">
      <ViewHeader
        title={t.settings.title}
        subtitle={t.settings.subtitle}
        action={isAdmin ? t.settings.save : t.common.accountSettings}
        onAction={openProfileSection}
        icon={Settings}
      />

        <SettingsAccordionSection
          id="organization-profile"
          title={isAdmin ? t.settings.profile : t.common.myAccount}
          icon={isAdmin ? Building2 : UserPlus}
          isOpen={openSettingsSections.profile}
          onToggle={() => toggleSettingsSection("profile")}
        >
          {!isAdmin && (
            <div className="account-settings-card">
              <img className="account-avatar" src={demoUserAvatar} alt="" />
              <div>
                <strong>{`${user?.prenom || ""} ${user?.nom || ""}`.trim() || t.common.user}</strong>
                <small>{user?.courriel || user?.email || "-"}</small>
              </div>
            </div>
          )}
          {isAdmin ? (
          <Fragment>
          <div className="account-settings-card">
            <span className="account-avatar">{(organization.organisme || t.product).slice(0, 2).toUpperCase()}</span>
            <div>
              <strong>{organization.organisme || t.product}</strong>
              <small>{organization.responsable_courriel || user?.courriel || user?.email || "-"}</small>
            </div>
          </div>
          <form className="form-grid settings-profile-form" onSubmit={onSubmit} key={`${organization.organismeID}-${organization.organisme}-${organization.responsable_courriel}`}>
            <label>
              {t.settings.organizationName}
              <input name="organisme" required maxLength="150" defaultValue={organization.organisme || ""} />
            </label>
            <label>
              {t.settings.registrationNumber}
              <input name="enregistrement" required maxLength="30" defaultValue={organization.enregistrement || ""} />
            </label>
            <label>
              {t.settings.contactName}
              <input name="responsable" required maxLength="50" defaultValue={organization.responsable || ""} />
            </label>
            <label>
              {t.settings.contactEmail}
              <input name="responsable_courriel" required type="email" defaultValue={organization.responsable_courriel || ""} />
            </label>
            <label>
              {t.settings.replyEmail}
              <input name="reponse_courriel" type="email" defaultValue={organization.reponse_courriel || ""} />
            </label>
            <label>
              {t.settings.phone}
              <input name="telephone" maxLength="30" defaultValue={organization.telephone || ""} />
            </label>
            <label className="full-field">
              {t.settings.address}
              <input name="adresse" maxLength="150" defaultValue={organization.adresse || ""} />
            </label>
            <label>
              {t.settings.city}
              <input name="ville" required maxLength="50" defaultValue={organization.ville || ""} />
            </label>
            <label>
              {t.settings.postalCode}
              <input name="code_postal" maxLength="20" defaultValue={organization.code_postal || ""} />
            </label>
            <label>
              {t.settings.province}
              <select name="provinceID" defaultValue={organization.provinceID || 1}>
                {bootstrap?.provinces?.map((province) => (
                  <option value={province.provinceID} key={province.provinceID}>
                    {province.abreviation} - {province.provinceEtat_en}
                  </option>
                ))}
              </select>
            </label>
            <label>
              {t.settings.currency}
              <input name="devise" readOnly defaultValue={organization.devise || "CAD"} />
            </label>
            <label>
              {t.settings.transit}
              <input name="transit" maxLength="20" defaultValue={organization.transit || ""} />
            </label>
            <label>
              {t.settings.folio}
              <input name="folio" maxLength="30" defaultValue={organization.folio || ""} />
            </label>
            <label className="checkbox-label">
              <input name="actif" type="checkbox" defaultChecked={organization.actif !== false} />
              <span>{t.settings.organizationActive}</span>
            </label>
            <button className="primary-button form-submit" type="submit">
              <Settings size={17} />
              <span>{t.settings.save}</span>
            </button>
          </form>
          </Fragment>
          ) : (
            <form className="form-grid settings-profile-form">
              <label>
                {t.settings.contactName}
                <input readOnly value={`${user?.prenom || ""} ${user?.nom || ""}`.trim() || t.common.user} />
              </label>
              <label>
                {t.common.email}
                <input readOnly value={user?.courriel || user?.email || ""} />
              </label>
              <label>
                {t.settings.role}
                <input readOnly value={roleLabel(user?.role || "viewer", t, bootstrap?.roleDefinitions)} />
              </label>
            </form>
          )}
        </SettingsAccordionSection>

        {isAdmin && (
        <SettingsAccordionSection
          title={t.settings.users}
          icon={Users}
          isOpen={openSettingsSections.users}
          onToggle={() => toggleSettingsSection("users")}
        >
          <div className={`user-access-card ${canAddUser ? "" : "is-limited"}`}>
            <div>
              <span className="status-pill issued">{currentPlanName}</span>
              <h3>{t.settings.userAccessTitle}</h3>
              <p>{canAddUser ? t.settings.userAccessHelp : t.settings.userLimitReached}</p>
            </div>
            <div className="user-access-metrics">
              <div>
                <span>{t.settings.activeSeats}</span>
                <strong>{activeSeatCount}</strong>
              </div>
              <div>
                <span>{t.settings.includedSeats}</span>
                <strong>{currentSeatPlan.seats}</strong>
              </div>
              <div className={canAddUser ? "" : "is-warning"}>
                <span>{t.settings.seatsRemaining}</span>
                <strong>{seatsRemaining}</strong>
              </div>
            </div>
            {!canAddUser && (
              <button className="primary-button" type="button" onClick={() => setActiveDrawer("plan")}>
                <Sparkles size={17} />
                <span>{t.settings.upgradeToAddUsers}</span>
              </button>
            )}
          </div>
          <form
            className="form-grid user-form"
            onSubmit={(event) => {
              if (!canAddUser) {
                event.preventDefault();
                setActiveDrawer("plan");
                return;
              }
              onCreateUser(event);
            }}
          >
            <label>
              {t.settings.firstName}
              <input name="prenom" required maxLength="50" disabled={!canAddUser} />
            </label>
            <label>
              {t.settings.lastName}
              <input name="nom" required maxLength="50" disabled={!canAddUser} />
            </label>
            <label>
              {t.common.email}
              <input name="email" required type="email" disabled={!canAddUser} />
            </label>
            <label>
              {t.settings.temporaryPassword}
              <input name="password" required minLength="8" type="password" disabled={!canAddUser} />
            </label>
            <label>
              {t.settings.userRole}
              <RoleSelect bootstrap={bootstrap} disabled={!canAddUser} t={t} user={user} value="viewer" />
            </label>
            <button className="primary-button form-submit" type={canAddUser ? "submit" : "button"} onClick={!canAddUser ? () => setActiveDrawer("plan") : undefined}>
              {canAddUser ? <UserPlus size={17} /> : <Sparkles size={17} />}
              <span>{canAddUser ? t.settings.addUser : t.settings.upgradeToAddUsers}</span>
            </button>
          </form>
          {editingUser && (
            <form
              className="form-grid user-form user-edit-form"
              onSubmit={async (event) => {
                const didUpdate = await onUpdateUser(editingUser, event);
                if (didUpdate) {
                  setEditingUserId(null);
                }
              }}
              key={`edit-user-${editingUser.utilisateurID}`}
            >
              <label>
                {t.settings.firstName}
                <input name="prenom" required maxLength="50" defaultValue={editingUser.prenom || ""} />
              </label>
              <label>
                {t.settings.lastName}
                <input name="nom" required maxLength="50" defaultValue={editingUser.nom || ""} />
              </label>
              <label>
                {t.common.email}
                <input name="email" required type="email" defaultValue={editingUser.courriel || ""} />
              </label>
              <label>
                {t.settings.language}
                <select name="langue" defaultValue={editingUser.langue || "en"}>
                  <option value="en">EN</option>
                  <option value="fr">FR</option>
                </select>
              </label>
              <label>
                {t.settings.userRole}
                <RoleSelect bootstrap={bootstrap} t={t} user={user} value={editingUser.role || (editingUser.admin ? "org_admin" : "viewer")} />
              </label>
              <div className="form-submit user-edit-actions">
                <button className="secondary-button" type="button" onClick={() => setEditingUserId(null)}>
                  <X size={17} />
                  <span>{t.settings.cancelEdit}</span>
                </button>
                <button className="primary-button" type="submit">
                  <Pencil size={17} />
                  <span>{t.settings.updateUser}</span>
                </button>
              </div>
            </form>
          )}
          <DataTable
            columns={[t.common.name, t.common.email, t.settings.language, t.settings.role, t.common.active, ""]}
            rows={users.map((account) => [
              `${account.prenom || ""} ${account.nom || ""}`.trim() || t.common.user,
              account.courriel || "-",
              String(account.langue || "en").toUpperCase(),
              roleLabel(account.role || (account.admin ? "org_admin" : "viewer"), t, bootstrap?.roleDefinitions),
              account.actif === false ? t.common.no : t.common.yes,
              (
                <div className="table-action-group" key={`user-actions-${account.utilisateurID}`}>
                  <button className="icon-button table-icon" type="button" onClick={() => setEditingUserId(account.utilisateurID)} aria-label={t.settings.editUser} title={t.settings.editUser}>
                    <Pencil size={16} />
                  </button>
                  {account.utilisateurID === user?.utilisateurID ? null : (
                    <button className="secondary-button compact" type="button" onClick={() => onUserStatus(account)}>
                      {account.actif === false ? t.common.activate : t.common.deactivate}
                    </button>
                  )}
                </div>
              ),
            ])}
          />
        </SettingsAccordionSection>
        )}

        {isAdmin && (
        <SettingsAccordionSection
          title={t.settings.paymentMethods}
          icon={CreditCard}
          isOpen={openSettingsSections.payments}
          onToggle={() => toggleSettingsSection("payments")}
        >
          <p className="panel-copy">{t.settings.paymentSubtitle}</p>
          <div className="payment-tile-grid">
            {saas.paymentMethods?.length ? saas.paymentMethods.map((paymentMethod) => (
              <PaymentMethodCard
                brand={paymentMethod.brand}
                details={`•••• ${paymentMethod.last4}`}
                expiry={`${paymentMethod.expiryMonth}/${paymentMethod.expiryYear}`}
                isDefault={paymentMethod.isDefault}
                key={paymentMethod.paymentMethodID}
                onDelete={() => onDeletePaymentMethod(paymentMethod)}
                t={t}
              />
            )) : (
              <div className="empty-state-card">{t.saas.noPaymentMethods}</div>
            )}
            <button className="payment-method-tile add-payment-tile" type="button" onClick={() => setAddPaymentOpen((open) => !open)} aria-expanded={addPaymentOpen}>
              <span><Plus size={28} /></span>
              <strong>{t.settings.addPayment}</strong>
              <small>{t.settings.paymentSubtitle}</small>
            </button>
          </div>
          {addPaymentOpen && (
            <form className="form-grid payment-link-form" onSubmit={async (event) => {
              const saved = await onCreatePaymentMethod(event);
              if (saved) {
                setAddPaymentOpen(false);
              }
            }}>
              <label>
                {t.settings.cardholder}
                <input name="cardholder" autoComplete="cc-name" placeholder="Grace Community Church" />
              </label>
              <label>
                {t.settings.cardNumber}
                <input name="cardNumber" autoComplete="cc-number" inputMode="numeric" placeholder="•••• •••• •••• 4242" />
              </label>
              <label>
                {t.settings.expiryDate}
                <input name="expiryDate" autoComplete="cc-exp" inputMode="numeric" placeholder="04/29" />
              </label>
              <label>
                {t.settings.cvc}
                <input name="cvc" autoComplete="cc-csc" inputMode="numeric" maxLength="4" placeholder="123" />
              </label>
              <button className="primary-button form-submit" type="submit">
                <CreditCard size={17} />
                <span>{t.settings.addPayment}</span>
              </button>
            </form>
          )}
          <div className="settings-subsection">
            <h3>{t.saas.invoices}</h3>
            <DataTable
              columns={["#", t.common.status, t.saas.when, t.saas.renews, t.common.description || "Description"]}
              rows={(saas.invoices || []).map((invoice) => [
                invoice.invoiceNumber,
                invoice.status,
                invoice.issuedAt,
                currency(invoice.amount),
                invoice.description,
              ])}
              emptyMessage={t.saas.noInvoices}
              t={t}
            />
          </div>
        </SettingsAccordionSection>
        )}

        {isAdmin && (
        <SettingsAccordionSection
          title={t.saas.security}
          icon={LockKeyhole}
          isOpen={openSettingsSections.security}
          onToggle={() => toggleSettingsSection("security")}
        >
          <p className="panel-copy">{t.saas.securityHelp}</p>
          <form className="form-grid settings-profile-form" onSubmit={onUpdateSecurity}>
            <label className="checkbox-label">
              <input name="mfaRequired" type="checkbox" defaultChecked={Boolean(saas.security?.mfaRequired)} />
              <span>{t.saas.mfaRequired}</span>
            </label>
            <label>
              {t.saas.passwordMinLength}
              <input name="passwordMinLength" min="8" max="64" type="number" defaultValue={saas.security?.passwordMinLength || 8} />
            </label>
            <label>
              {t.saas.sessionTimeoutDays}
              <input name="sessionTimeoutDays" min="1" max="90" type="number" defaultValue={saas.security?.sessionTimeoutDays || 30} />
            </label>
            <label className="full-field">
              {t.saas.allowedDomains}
              <input name="allowedDomains" placeholder="organization.org, charity.ca" defaultValue={(saas.security?.allowedDomains || []).join(", ")} />
            </label>
            <button className="primary-button form-submit" type="submit">
              <LockKeyhole size={17} />
              <span>{t.saas.saveSecurity}</span>
            </button>
          </form>
        </SettingsAccordionSection>
        )}

        {isAdmin && (
        <SettingsAccordionSection
          title={`${t.saas.apiKeys} & ${t.saas.webhooks}`}
          icon={Link2}
          isOpen={openSettingsSections.api}
          onToggle={() => toggleSettingsSection("api")}
        >
          {saasSecret && (
            <div className="secret-reveal-card">
              <div>
                <span>{t.saas.secretOnce}</span>
                <strong>{saasSecret.label}</strong>
                <code>{saasSecret.secret}</code>
              </div>
              <button className="icon-button" type="button" onClick={() => setSaasSecret(null)} aria-label={t.common.close || t.common.cancel}>
                <X size={16} />
              </button>
            </div>
          )}
          <div className="saas-admin-grid">
            <div>
              <h3>{t.saas.apiKeys}</h3>
              <form className="form-grid compact-saas-form" onSubmit={onCreateApiKey}>
                <label>
                  {t.saas.keyLabel}
                  <input name="label" required placeholder="Donation import automation" />
                </label>
                <label>
                  {t.saas.scopes}
                  <input name="scopes" placeholder="donations:read, donors:read" />
                </label>
                <button className="primary-button form-submit" type="submit">
                  <LockKeyhole size={17} />
                  <span>{t.saas.createApiKey}</span>
                </button>
              </form>
              <DataTable
                columns={[t.common.name, t.saas.scopes, t.common.status, ""]}
                rows={(saas.apiKeys || []).map((apiKey) => [
                  `${apiKey.label} (${apiKey.keyPrefix}...)`,
                  apiKey.scopes.join(", "),
                  apiKey.active ? t.common.active : t.common.inactive,
                  apiKey.active ? (
                    <button className="secondary-button compact" type="button" onClick={() => onRevokeApiKey(apiKey)} key={`revoke-${apiKey.apiKeyID}`}>
                      {t.saas.revokeApiKey}
                    </button>
                  ) : "",
                ])}
                emptyMessage={t.saas.noApiKeys}
                t={t}
              />
            </div>
            <div>
              <h3>{t.saas.webhooks}</h3>
              <form className="form-grid compact-saas-form" onSubmit={onCreateWebhook}>
                <label>
                  {t.saas.webhookUrl}
                  <input name="url" required type="url" placeholder="https://example.org/weserve/webhook" />
                </label>
                <label>
                  {t.saas.eventTypes}
                  <input name="events" placeholder="donation.created, receipt.generated" />
                </label>
                <button className="primary-button form-submit" type="submit">
                  <Link2 size={17} />
                  <span>{t.saas.addWebhook}</span>
                </button>
              </form>
              <DataTable
                columns={["URL", t.saas.eventTypes, t.saas.lastDelivery, ""]}
                rows={(saas.webhooks || []).map((webhook) => [
                  webhook.url,
                  webhook.events.join(", "),
                  webhook.lastDeliveryStatus || t.common.pending,
                  (
                    <div className="table-action-group" key={`webhook-${webhook.webhookID}`}>
                      <button className="secondary-button compact" type="button" onClick={() => onTestWebhook(webhook)}>
                        {t.saas.testWebhook}
                      </button>
                      <button className="icon-button table-icon danger" type="button" onClick={() => onDeleteWebhook(webhook)} aria-label={t.common.delete}>
                        <Trash2 size={15} />
                      </button>
                    </div>
                  ),
                ])}
                emptyMessage={t.saas.noWebhooks}
                t={t}
              />
            </div>
          </div>
        </SettingsAccordionSection>
        )}

        {isAdmin && (
        <SettingsAccordionSection
          title={t.saas.auditLog}
          icon={FileText}
          isOpen={openSettingsSections.audit}
          onToggle={() => toggleSettingsSection("audit")}
        >
          <DataTable
            columns={[t.saas.event, t.saas.actor, t.saas.entity, t.saas.when]}
            rows={(saas.auditEvents || []).map((event) => [
              event.action,
              event.actorEmail || "system",
              `${event.entityType}${event.entityID ? ` #${event.entityID}` : ""}`,
              event.createdAt,
            ])}
            emptyMessage={t.common.noRecords}
            paginate
            t={t}
          />
        </SettingsAccordionSection>
        )}

      {isAdmin && (
      <div className={`donor-edge-drawers settings-edge-drawers ${activeDrawer ? "has-open-drawer" : ""}`}>
        <button className={`donor-edge-tab ${activeDrawer === "plan" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "plan" ? null : "plan")} aria-label={t.settings.currentPlan} title={t.settings.currentPlan} aria-expanded={activeDrawer === "plan"}>
          <Sparkles size={18} />
        </button>
        <button className={`donor-edge-tab ${activeDrawer === "customization" ? "active" : ""}`} type="button" onClick={() => setActiveDrawer((drawer) => drawer === "customization" ? null : "customization")} aria-label={t.customization.title} title={t.customization.title} aria-expanded={activeDrawer === "customization"}>
          <Palette size={18} />
        </button>

        {activeDrawer === "plan" && (
          <aside className="donor-edge-panel app-edge-panel" id="settings-plan-drawer">
            <EdgePanelHeader icon={Sparkles} title={t.settings.currentPlan} subtitle={t.settings.planHelp} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="settings-plan-card">
              <span className="status-pill issued">{currentPlanName}</span>
              <strong>{currency(subscription.renewalAmount || currentPlan.monthlyPrice || 0)}</strong>
              <p>{currentPlan.description || t.subscription.plansList[1]?.description}</p>
              <ul>
                {(currentPlan.features || t.subscription.plansList[1]?.features || []).map((feature) => (
                  <li key={feature}><CheckCircle2 size={15} /> {feature}</li>
                ))}
              </ul>
              <button className="primary-button" type="button" onClick={() => setActiveDrawer(null)}>
                <Sparkles size={16} />
                <span>{t.settings.upgradePlan}</span>
              </button>
            </div>
          </aside>
        )}

        {activeDrawer === "customization" && (
          <aside className="donor-edge-panel app-edge-panel" id="settings-customization-drawer">
            <EdgePanelHeader icon={Palette} title={t.customization.title} subtitle={t.customization.subtitle} onClose={() => setActiveDrawer(null)} t={t} />
            <div className="settings-shortcut-panel">
              <button className="primary-button" type="button" onClick={onCustomize}>
                <Palette size={16} />
                <span>{t.settings.customizationShortcut}</span>
              </button>
            </div>
          </aside>
        )}
      </div>
      )}
    </section>
  );
}

function paymentCardBrand(brand = "") {
  const normalizedBrand = brand.toLowerCase();
  if (normalizedBrand.includes("visa")) {
    return { className: "visa", label: "Visa", type: "visa" };
  }
  if (normalizedBrand.includes("mastercard") || normalizedBrand.includes("master card")) {
    return { className: "mastercard", label: "Mastercard", type: "mastercard" };
  }
  if (normalizedBrand.includes("amex") || normalizedBrand.includes("american express")) {
    return { className: "amex", label: "American Express", type: "amex" };
  }
  return { className: "card", label: "Card", type: "card" };
}

function PaymentCardLogo({ brand }) {
  if (brand.type === "visa") {
    return (
      <svg aria-label={brand.label} className="payment-logo-svg visa-logo" role="img" viewBox="0 0 92 36">
        <text x="3" y="27">VISA</text>
      </svg>
    );
  }

  if (brand.type === "mastercard") {
    return (
      <svg aria-label={brand.label} className="payment-logo-svg mastercard-logo" role="img" viewBox="0 0 92 44">
        <circle className="mc-left" cx="38" cy="17" r="14" />
        <circle className="mc-right" cx="54" cy="17" r="14" />
        <text x="18" y="38">mastercard</text>
      </svg>
    );
  }

  if (brand.type === "amex") {
    return <span>AMEX</span>;
  }

  return <CreditCard size={20} />;
}

function PaymentMethodCard({ brand, details, expiry, isDefault = false, onDelete, t }) {
  const cardBrand = paymentCardBrand(brand);

  return (
    <article className="payment-method-tile">
      <div className="linked-bank-topline">
        <div className={`payment-card-mark ${cardBrand.className}`}>
          <PaymentCardLogo brand={cardBrand} />
        </div>
        {isDefault && <span className="status-pill issued"><CheckCircle2 size={14} /> {t.settings.defaultMethod}</span>}
      </div>
      <div>
        <span>{t.settings.paymentMethods}</span>
        <h2>{brand}</h2>
        <p>{details}</p>
      </div>
      <dl className="banking-detail-list">
        <div>
          <dt>{t.settings.expires}</dt>
          <dd>{expiry}</dd>
        </div>
        <div>
          <dt>{t.common.status}</dt>
          <dd>{isDefault ? t.settings.defaultMethod : t.common.active}</dd>
        </div>
      </dl>
      <div className="payment-card-actions">
        <button className="icon-button table-icon payment-action-pill" type="button" aria-label={t.settings.updatePayment} title={t.settings.updatePayment}>
          <Pencil size={15} />
        </button>
        <button
          className="icon-button table-icon payment-action-pill danger"
          type="button"
          disabled={isDefault}
          onClick={onDelete}
          title={isDefault ? t.settings.defaultPaymentLocked : t.settings.deletePayment}
          aria-label={isDefault ? t.settings.defaultPaymentLocked : t.settings.deletePayment}
        >
          <Trash2 size={15} />
        </button>
      </div>
    </article>
  );
}

function CustomizationView({ onSavePalette, palette, savedPalettes, setPalette, t }) {
  const [customName, setCustomName] = useState(t.customization.custom);
  const [customColors, setCustomColors] = useState(["#1d6f5f", "#2f6fbb", "#b7791f"]);
  const [customPaletteOpen, setCustomPaletteOpen] = useState(false);
  const palettes = [
    { name: "Default", colors: ["#1d6f5f", "#2f6fbb", "#b7791f"] },
    { name: "Evergreen", colors: ["#1d6f5f", "#2f6fbb", "#b7791f"] },
    { name: "Harbor", colors: ["#2563eb", "#0f766e", "#64748b"] },
    { name: "Plum", colors: ["#7c3aed", "#db2777", "#334155"] },
  ];
  const customDraft = { id: "Custom", name: customName || t.customization.custom, colors: customColors };
  const activePalette = palette === "Custom"
    ? customDraft
    : savedPalettes.find((item) => item.id === palette) || palettes.find((item) => item.name === palette) || palettes[0];

  function updateCustomColor(index, color) {
    setCustomColors((currentColors) => currentColors.map((currentColor, colorIndex) => (
      colorIndex === index ? color : currentColor
    )));
    setPalette("Custom");
    setCustomPaletteOpen(true);
  }

  function saveCustomPalette(event) {
    event.preventDefault();
    const name = customName.trim() || t.customization.custom;
    onSavePalette({
      id: `custom-${name.toLowerCase().replace(/[^a-z0-9]+/g, "-")}-${Date.now()}`,
      name,
      colors: customColors,
    });
  }

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.customization.title}
        subtitle={t.customization.subtitle}
        icon={Palette}
      />

      <div className="two-column form-layout">
        <Panel title={t.customization.palette} icon={Palette}>
          <div className="palette-list">
            {palettes.map((option, index) => (
              <button
                className={palette === option.name ? "palette-option is-selected" : "palette-option"}
                key={option.name}
                type="button"
                onClick={() => setPalette(option.name)}
              >
                <span className="palette-swatches">
                  {option.colors.map((color) => <i key={color} style={{ background: color }} />)}
                </span>
                <strong>{t.customization.options[index][0]}</strong>
                <small>{t.customization.options[index][1]}</small>
              </button>
            ))}
            <button
              className={palette === "Custom" ? "palette-option is-selected" : "palette-option"}
              type="button"
              aria-expanded={customPaletteOpen}
              onClick={() => {
                setPalette("Custom");
                setCustomPaletteOpen((open) => !open);
              }}
            >
              <span className="custom-palette-icon" aria-hidden="true">
                <i />
                <Plus size={16} />
              </span>
              <strong>{t.customization.custom}</strong>
              <small>{t.customization.customDescription}</small>
            </button>
          </div>

          {savedPalettes.length > 0 && (
            <div className="saved-palette-section">
              <h3>{t.customization.savedPalettes}</h3>
              <div className="palette-list saved">
                {savedPalettes.map((option) => (
                  <button
                    className={palette === option.id ? "palette-option is-selected" : "palette-option"}
                    key={option.id}
                    type="button"
                    onClick={() => setPalette(option.id)}
                  >
                    <span className="palette-swatches">
                      {option.colors.map((color) => <i key={color} style={{ background: color }} />)}
                    </span>
                    <strong>{option.name}</strong>
                    <small>{t.customization.custom}</small>
                  </button>
                ))}
              </div>
            </div>
          )}

          {customPaletteOpen && (
            <form className="custom-palette-builder" onSubmit={saveCustomPalette}>
              <label className="custom-palette-name">
                <span>{t.customization.customName}</span>
                <input
                  type="text"
                  value={customName}
                  onChange={(event) => {
                    setCustomName(event.target.value);
                    setPalette("Custom");
                  }}
                />
              </label>
              {[
                t.customization.brandColor,
                t.customization.accentColor,
                t.customization.highlightColor,
              ].map((label, index) => (
                <label key={label}>
                  <span>{label}</span>
                  <input
                    type="color"
                    value={customColors[index]}
                    onChange={(event) => updateCustomColor(index, event.target.value)}
                  />
                  <strong>{customColors[index].toUpperCase()}</strong>
                </label>
              ))}
              <button className="secondary-button" type="submit">
                <Check size={16} />
                <span>{t.customization.saveCustom}</span>
              </button>
            </form>
          )}
        </Panel>

        <Panel title={t.customization.preview} icon={Sparkles}>
          <div className="theme-preview" style={{ "--preview-brand": activePalette.colors[0], "--preview-accent": activePalette.colors[1] }}>
            <div className="theme-preview-sidebar">
              <span>{t.product}</span>
              <i />
              <i />
              <i />
            </div>
            <div className="theme-preview-main">
              <span>{t.customization.current}: {activePalette.name}</span>
              <strong>{t.overview.title}</strong>
              <div>
                <button type="button">{t.actions[0]}</button>
                <button type="button">{t.actions[3]}</button>
              </div>
            </div>
          </div>
          <button className="primary-button" type="button">
            <Check size={16} />
            <span>{t.customization.apply}</span>
          </button>
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

      <Panel title="Support" icon={Mail}>
        <div className="support-contact">
          <p>Contact your account administrator for WeSERVE support.</p>
        </div>
      </Panel>
    </section>
  );
}

function ViewHeader({ title, subtitle, action, actionTargetId, icon: Icon, onAction, secondaryAction, secondaryIcon: SecondaryIcon = Download, onSecondaryAction, stacked = false }) {
  const handleAction = onAction || (actionTargetId ? () => focusTarget(actionTargetId) : null);

  return (
    <div className={`view-header ${stacked ? "is-stacked" : ""}`}>
      <div>
        <span className="eyebrow"><Icon size={15} /> WeSERVE SaaS</span>
        <h1>{title}</h1>
        <p>{subtitle}</p>
      </div>
      {(action && handleAction) || (secondaryAction && onSecondaryAction) ? (
        <div className="view-header-actions">
          {action && handleAction && (
            <button className="primary-button" type="button" onClick={handleAction}>
              <Plus size={17} />
              <span>{action}</span>
            </button>
          )}
          {secondaryAction && onSecondaryAction && (
            <button className="secondary-button" type="button" onClick={onSecondaryAction}>
              <SecondaryIcon size={17} />
              <span>{secondaryAction}</span>
            </button>
          )}
        </div>
      ) : null}
    </div>
  );
}

function BooleanIcon({ value, trueLabel, falseLabel }) {
  const isTrue = Boolean(value);

  return (
    <span className={`boolean-icon ${isTrue ? "is-true" : "is-false"}`} aria-label={isTrue ? trueLabel : falseLabel} data-sort-value={isTrue ? "0" : "1"} title={isTrue ? trueLabel : falseLabel}>
      {isTrue ? <Check size={16} /> : <X size={16} />}
    </span>
  );
}

function EdgePanelHeader({ icon: Icon, title, subtitle, onClose, t }) {
  return (
    <div className="edge-panel-hero">
      <div className="edge-panel-icon">
        <Icon size={20} />
      </div>
      <div>
        <span className="eyebrow">WeSERVE SaaS</span>
        <h2>{title}</h2>
        {subtitle && <p>{subtitle}</p>}
      </div>
      <button className="icon-button" type="button" onClick={onClose} aria-label={t.common.close || t.common.cancel}>
        <X size={16} />
      </button>
    </div>
  );
}

function Panel({ id, title, icon: Icon, action, children }) {
  return (
    <section className="panel" id={id}>
      <div className="panel-header">
        <div>
          <Icon size={18} />
          <h2>{title}</h2>
        </div>
        {action}
      </div>
      {children}
    </section>
  );
}

function SettingsAccordionSection({ id, title, icon: Icon, isOpen, onToggle, children }) {
  return (
    <section className={`panel settings-accordion-section ${isOpen ? "is-open" : ""}`} id={id}>
      <button className="panel-header settings-accordion-toggle" type="button" onClick={onToggle} aria-expanded={isOpen}>
        <div>
          <Icon size={18} />
          <h2>{title}</h2>
        </div>
        <ChevronDown size={18} />
      </button>
      {isOpen && (
        <div className="settings-accordion-content">
          {children}
        </div>
      )}
    </section>
  );
}

function sortableCellValue(cell) {
  const text = cellToText(cell).trim();
  const numeric = Number(text.replace(/[^0-9.-]/g, ""));
  const timestamp = Date.parse(text);

  if (text && Number.isFinite(timestamp) && /\d{4}-\d{2}-\d{2}/.test(text)) {
    return timestamp;
  }

  if (text && Number.isFinite(numeric) && /[0-9]/.test(text)) {
    return numeric;
  }

  return text.toLowerCase();
}

function cellToText(cell) {
  if (cell === null || cell === undefined) {
    return "";
  }

  if (typeof cell === "string" || typeof cell === "number" || typeof cell === "boolean") {
    return String(cell);
  }

  if (Array.isArray(cell)) {
    return cell.map(cellToText).join(" ");
  }

  if (typeof cell === "object" && "props" in cell) {
    if (cell.props["data-sort-value"] !== undefined) {
      return String(cell.props["data-sort-value"]);
    }

    if (cell.props["aria-label"] || cell.props.title) {
      return String(cell.props["aria-label"] || cell.props.title);
    }

    return cellToText(cell.props.children);
  }

  return "";
}

function DataTable({ columns, rows, t, emptyMessage, rowClassName, expandedRowContent, onRowClick, alwaysShowPagination = false, paginate = false, pageSize = 10 }) {
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedPageSize, setSelectedPageSize] = useState(pageSize);
  const [sortConfig, setSortConfig] = useState(null);
  const paginationSizes = [10, 50, 100, 500];
  const sortedRows = useMemo(() => {
    if (!sortConfig) {
      return rows;
    }

    return [...rows].sort((left, right) => {
      const leftValue = sortableCellValue(left[sortConfig.index]);
      const rightValue = sortableCellValue(right[sortConfig.index]);

      if (leftValue < rightValue) {
        return sortConfig.direction === "asc" ? -1 : 1;
      }

      if (leftValue > rightValue) {
        return sortConfig.direction === "asc" ? 1 : -1;
      }

      return 0;
    });
  }, [rows, sortConfig]);
  const showPaginationControls = paginate && sortedRows.length > 0 && (alwaysShowPagination || sortedRows.length > paginationSizes[0]);
  const shouldPaginate = paginate && sortedRows.length > selectedPageSize;
  const totalPages = shouldPaginate ? Math.ceil(sortedRows.length / selectedPageSize) : 1;
  const safeCurrentPage = Math.min(currentPage, totalPages);
  const pageStart = showPaginationControls ? (safeCurrentPage - 1) * selectedPageSize : 0;
  const pageEnd = showPaginationControls ? Math.min(pageStart + selectedPageSize, sortedRows.length) : sortedRows.length;
  const visibleRows = showPaginationControls ? sortedRows.slice(pageStart, pageEnd) : sortedRows;

  useEffect(() => {
    setCurrentPage(1);
  }, [rows.length, selectedPageSize, sortConfig]);

  useEffect(() => {
    if (currentPage > totalPages) {
      setCurrentPage(totalPages);
    }
  }, [currentPage, totalPages]);

  function sortColumn(columnIndex) {
    setSortConfig((currentSort) => {
      if (currentSort?.index === columnIndex) {
        return {
          index: columnIndex,
          direction: currentSort.direction === "asc" ? "desc" : "asc",
        };
      }

      return { index: columnIndex, direction: "asc" };
    });
  }

  const renderPaginationControls = (position) => showPaginationControls ? (
    <div className="table-pagination">
      <span>{t?.common?.showing || "Showing"} {pageStart + 1}-{pageEnd} {t?.common?.of || "of"} {sortedRows.length}</span>
      <div className="pagination-actions">
        {position === "top" && (
          <label className="pagination-size">
            <span>{t?.common?.perPage || "Entries per page"}</span>
            <select value={selectedPageSize} onChange={(event) => setSelectedPageSize(Number(event.target.value))}>
              {paginationSizes.map((size) => <option value={size} key={size}>{size}</option>)}
            </select>
          </label>
        )}
        <button className="secondary-button compact" type="button" onClick={() => setCurrentPage((page) => Math.max(1, page - 1))} disabled={safeCurrentPage === 1}>
          <ChevronLeft size={15} />
          <span>{t?.common?.previous || "Previous"}</span>
        </button>
        <span className="pagination-page">{t?.common?.page || "Page"} {safeCurrentPage} / {totalPages}</span>
        <button className="secondary-button compact" type="button" onClick={() => setCurrentPage((page) => Math.min(totalPages, page + 1))} disabled={safeCurrentPage === totalPages}>
          <span>{t?.common?.next || "Next"}</span>
          <ChevronRight size={15} />
        </button>
      </div>
    </div>
  ) : null;

  return (
    <>
      {renderPaginationControls("top")}
      <div className="table-wrap">
        <table>
          <thead>
            <tr>
              {columns.map((column, columnIndex) => {
                const isSortable = column !== "";
                const isSorted = sortConfig?.index === columnIndex;

                return (
                  <th key={column || `column-${columnIndex}`} aria-sort={isSorted ? (sortConfig.direction === "asc" ? "ascending" : "descending") : undefined}>
                    {isSortable ? (
                      <button className={`table-sort-button ${isSorted ? "is-active" : ""}`} type="button" onClick={() => sortColumn(columnIndex)}>
                        <span>{column}</span>
                        <ChevronsUpDown size={14} />
                      </button>
                    ) : column}
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody>
            {rows.length === 0 ? (
              <tr>
                <td colSpan={columns.length}>{emptyMessage || t?.common?.noRecords || "No records found"}</td>
              </tr>
            ) : (
              visibleRows.map((row, rowIndex) => {
                const absoluteRowIndex = pageStart + rowIndex;
                const expandedContent = expandedRowContent?.(row, absoluteRowIndex);

                return (
                  <Fragment key={`${absoluteRowIndex}-${row[0]}-group`}>
                    <tr
                      className={`${rowClassName?.(row, absoluteRowIndex) || ""} ${onRowClick ? "is-clickable" : ""}`.trim()}
                      key={`${absoluteRowIndex}-${row[0]}`}
                      onClick={onRowClick ? () => onRowClick(row, absoluteRowIndex) : undefined}
                      onKeyDown={onRowClick ? (event) => {
                        if (event.key === "Enter" || event.key === " ") {
                          event.preventDefault();
                          onRowClick(row, absoluteRowIndex);
                        }
                      } : undefined}
                      tabIndex={onRowClick ? 0 : undefined}
                    >
                      {row.map((cell, cellIndex) => <td key={`${absoluteRowIndex}-${cellIndex}`}>{cell}</td>)}
                    </tr>
                    {expandedContent && (
                      <tr className="table-expanded-row" key={`${absoluteRowIndex}-${row[0]}-expanded`}>
                        <td colSpan={columns.length}>{expandedContent}</td>
                      </tr>
                    )}
                  </Fragment>
                );
              })
            )}
          </tbody>
        </table>
      </div>
      {renderPaginationControls("bottom")}
    </>
  );
}

function StatusPill({ value, t }) {
  const className = String(value || "").toLowerCase().replace(/\s+/g, "-");
  return <span className={`status-pill ${className}`}>{translateStatus(value, t)}</span>;
}

function PricingCard({ revenue, member, nonMember }) {
  return (
    <article className="pricing-card">
      <span>Annual revenue</span>
      <strong>{revenue}</strong>
      <dl>
        <div>
          <dt>Member</dt>
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

function translateStatus(status, t) {
  if (status === "Ready") {
    return t?.receipts?.ready || status;
  }
  if (status === "No receipt") {
    return t?.accounts?.noReceipt || status;
  }
  if (status === "Pending") {
    return t?.receipts?.review || status;
  }
  return status;
}

function humanStatus(status, t) {
  if (!status) {
    return t.common.generated;
  }

  if (status === "1-en-cours") {
    return t.common.queued;
  }
  if (status === "2-livre") {
    return t.common.delivered;
  }
  if (status === "2-a-imprimer") {
    return t.common.print;
  }
  if (status === "0-courriel-non-valide") {
    return t.common.invalidEmail;
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

function monthName(monthKey, t) {
  const [year, month] = String(monthKey || "").split("-");
  const date = new Date(Number(year), Number(month) - 1, 1);

  if (Number.isNaN(date.getTime())) {
    return formatReportLabel(monthKey, t);
  }

  return new Intl.DateTimeFormat(t.locale || "en-CA", {
    month: "long",
    year: "numeric",
  }).format(date);
}

function formatReportLabel(label, t) {
  if (!label) {
    return t.common.unspecified;
  }

  if (/^\d{4}-\d{2}$/.test(String(label))) {
    return monthName(label, t);
  }

  return String(label);
}

function formatTemplateSchedule(template, t) {
  const dayLabels = {
    monday: t.reports.monday,
    tuesday: t.reports.tuesday,
    wednesday: t.reports.wednesday,
    thursday: t.reports.thursday,
    friday: t.reports.friday,
    first: t.reports.firstDay,
    fifteenth: t.reports.fifteenthDay,
    last: t.reports.lastDay,
  };

  const frequency = template.frequency === "monthly" ? t.reports.monthly : t.reports.weekly;
  return `${frequency} - ${dayLabels[template.day] || template.day}`;
}

function downloadCSV(filename, rows) {
  const { headers, normalizedRows } = normalizeExportRows(rows);
  if (!normalizedRows.length) {
    return;
  }

  const csvRows = [
    headers.map(csvValue).join(","),
    ...normalizedRows.map((row) => headers.map((header) => csvValue(row[header])).join(",")),
  ];
  const blob = new Blob([`\uFEFF${csvRows.join("\r\n")}`], { type: "text/csv;charset=utf-8" });
  downloadBlob(filename, blob);
}

function downloadExcel(filename, rows) {
  const { headers, normalizedRows } = normalizeExportRows(rows);
  if (!normalizedRows.length) {
    return;
  }

  const safeFilename = filename.endsWith(".xls") ? filename : filename.replace(/\.[^.]+$/, "") + ".xls";
  const escapeHtml = (value) => formatCell(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
  const tableRows = [
    `<tr>${headers.map((header) => `<th>${escapeHtml(header)}</th>`).join("")}</tr>`,
    ...normalizedRows.map((row) => `<tr>${headers.map((header) => `<td style="mso-number-format:'\\@';">${escapeHtml(row[header])}</td>`).join("")}</tr>`),
  ];
  const worksheet = `<!doctype html>
    <html>
      <head>
        <meta charset="UTF-8" />
        <style>
          table { border-collapse: collapse; }
          th, td { border: 1px solid #d9e3e1; padding: 6px 8px; text-align: left; }
          th { background: #e8f4ef; font-weight: 700; }
        </style>
      </head>
      <body><table>${tableRows.join("")}</table></body>
    </html>
  `;
  const blob = new Blob([worksheet], { type: "application/vnd.ms-excel;charset=utf-8" });
  downloadBlob(safeFilename, blob);
}

function normalizeExportRows(rows) {
  const normalizedRows = (rows || []).map((row) => (row && typeof row === "object" && !Array.isArray(row) ? row : { Value: row }));
  const headers = Array.from(normalizedRows.reduce((set, row) => {
    Object.keys(row).forEach((key) => set.add(key));
    return set;
  }, new Set()));

  return { headers, normalizedRows };
}

function downloadBlob(filename, blob) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  link.style.display = "none";
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

function csvValue(value) {
  const normalized = value === null || value === undefined ? "" : String(value);
  return `"${normalized.replaceAll('"', '""')}"`;
}

export default App;
