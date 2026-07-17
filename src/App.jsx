import { useEffect, useMemo, useState } from "react";
import {
  BarChart3,
  Bell,
  BookOpenCheck,
  Building2,
  Check,
  CheckCircle2,
  ChevronDown,
  CircleDollarSign,
  ClipboardList,
  CreditCard,
  Download,
  FileCheck2,
  FileText,
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
  Pencil,
  Plus,
  Printer,
  ReceiptText,
  Search,
  Settings,
  ShieldCheck,
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
    product: "WeSERVE",
    organization: "WeSERVE",
    nav: {
      overview: "Overview",
      donations: "Donations",
      donors: "Donors",
      accounts: "Accounts",
      receipts: "Receipts",
      reports: "Reports",
      banking: "Banking",
      subscription: "Subscription",
      customization: "Customization",
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
      support: "Support",
      settings: "Settings",
      logout: "Log out",
      admin: "Admin",
      user: "User",
      active: "Active",
      yes: "Yes",
      no: "No",
      member: "Member",
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
      recommended: "Recommended",
      pending: "Pending",
      generated: "Generated",
      queued: "Queued",
      delivered: "Delivered",
      print: "Print",
      invalidEmail: "Invalid email",
      to: "to",
    },
    actions: ["Add donation", "Add donor", "Generate receipts", "Generate report"],
    metrics: ["Year-to-date donations", "Receipts", "Active donors", "Pending receipts"],
    donorForm: {
      title: "Add donor",
      success: "Donor saved.",
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
      reactivated: "Donor reactivated.",
      archived: "Donor archived.",
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
      accountMix: "Account mix",
      register: "Donation register",
      deleted: "Donation deleted.",
      confirmDelete: "Delete donation {id} from {name}?",
      detectedDonor: "Detected donor",
      donorNumber: "Donor number",
      chooseAccount: "Choose account",
      categorizeSuccess: "Pending donation categorized.",
      noPendingDonations: "No pending donations to categorize.",
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
      refreshed: "Report refreshed.",
    },
    subscription: {
      title: "Subscription request",
      subtitle:
        "Request access for a charity and store the request in SQLite for follow-up.",
      pricing: "Annual plans",
      submit: "Submit request",
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
          name: "Basic",
          price: "$29/mo",
          description: "For small teams getting started.",
          features: ["Donor and donation tracking", "Manual receipts", "CSV exports"],
        },
        {
          name: "Gold",
          price: "$59/mo",
          description: "For growing organizations that need automation.",
          features: ["Everything in Basic", "Receipt batches", "Bank notifications", "Priority support"],
        },
        {
          name: "Premium",
          price: "$99/mo",
          description: "For organizations with advanced workflows.",
          features: ["Everything in Gold", "Multi-user controls", "Payment method management", "Advanced reporting"],
        },
      ],
    },
    settings: {
      title: "Organization settings",
      subtitle: "Update the charity profile fields used for receipts, replies, and deposit slips.",
      profile: "Charity profile",
      users: "Users",
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
      adminAccess: "Admin access",
      addUser: "Add user",
      language: "Language",
      role: "Role",
      userAdded: "User added to this workspace.",
      userUpdated: "User access updated.",
      paymentMethods: "Payment methods",
      paymentSubtitle: "Manage the cards and billing methods used for your WeSERVE subscription.",
      defaultMethod: "Default",
      expires: "Expires",
      addPayment: "Add payment method",
      cardholder: "Cardholder",
      cardNumber: "Card number",
      expiryDate: "Expiry date",
      customizationShortcut: "Customize interface",
    },
    banking: {
      title: "Banking connections",
      subtitle: "Connect bank or PayPal accounts so new donations can appear automatically for review.",
      pageSubtitle: "Manage connected bank accounts and decide which SaaS accounts each connection can feed into.",
      bankAccount: "Bank account",
      paypal: "PayPal account",
      linked: "Linked",
      linkedAccounts: "Linked accounts",
      allAccounts: "All SaaS accounts",
      accountScope: "Associated SaaS accounts",
      addBank: "Link another bank account",
      addBankHelp: "Connect a new bank source for incoming donations.",
      institution: "Institution",
      provider: "Provider",
      connectionType: "Connection type",
      accountNumber: "Account number",
      paypalEmail: "PayPal email",
      stripeAccount: "Stripe account ID",
      transitNumber: "Transit",
      ibanNumber: "IBAN / routing",
      scopeAll: "Use all accounts",
      scopeSelected: "Select accounts",
      connectBank: "Connect bank account",
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
    product: "WeSERVE",
    organization: "WeSERVE",
    nav: {
      overview: "Accueil",
      donations: "Dons",
      donors: "Donateurs",
      accounts: "Comptes",
      receipts: "Reçus",
      reports: "Rapports",
      banking: "Banque",
      subscription: "Abonnement",
      customization: "Personnalisation",
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
      support: "Support",
      settings: "Paramètres",
      logout: "Déconnexion",
      admin: "Admin",
      user: "Utilisateur",
      active: "Actif",
      yes: "Oui",
      no: "Non",
      member: "Membre",
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
      recommended: "Recommandé",
      pending: "En attente",
      generated: "Généré",
      queued: "En file d'attente",
      delivered: "Livré",
      print: "Imprimer",
      invalidEmail: "Courriel non valide",
      to: "au",
    },
    actions: ["Ajouter un don", "Ajouter un donateur", "Générer les reçus", "Générer un rapport"],
    metrics: ["Dons depuis le début de l'année", "Reçus", "Donateurs actifs", "Reçus en attente"],
    donorForm: {
      title: "Ajouter un donateur",
      success: "Donateur enregistré.",
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
      reactivated: "Donateur réactivé.",
      archived: "Donateur archivé.",
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
      accountMix: "Répartition par compte",
      register: "Registre des dons",
      deleted: "Don supprimé.",
      confirmDelete: "Supprimer le don {id} de {name}?",
      detectedDonor: "Donateur détecté",
      donorNumber: "Numéro de donateur",
      chooseAccount: "Choisir le compte",
      categorizeSuccess: "Don en attente catégorisé.",
      noPendingDonations: "Aucun don en attente à catégoriser.",
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
      refreshed: "Rapport actualisé.",
    },
    subscription: {
      title: "Demande d'abonnement",
      subtitle:
        "Enregistrez une demande d'accès pour un organisme dans SQLite pour le suivi.",
      pricing: "Forfaits annuels",
      submit: "Envoyer la demande",
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
          name: "Basic",
          price: "29 $/mois",
          description: "Pour les petites équipes qui démarrent.",
          features: ["Suivi des donateurs et des dons", "Reçus manuels", "Exports CSV"],
        },
        {
          name: "Gold",
          price: "59 $/mois",
          description: "Pour les organismes en croissance.",
          features: ["Tout dans Basic", "Lots de reçus", "Notifications bancaires", "Support prioritaire"],
        },
        {
          name: "Premium",
          price: "99 $/mois",
          description: "Pour les flux de travail avancés.",
          features: ["Tout dans Gold", "Contrôles multiutilisateurs", "Gestion des paiements", "Rapports avancés"],
        },
      ],
    },
    settings: {
      title: "Paramètres de l'organisme",
      subtitle: "Mettez à jour les champs utilisés pour les reçus, les réponses et les dépôts.",
      profile: "Profil de l'organisme",
      users: "Utilisateurs",
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
      adminAccess: "Accès administrateur",
      addUser: "Ajouter un utilisateur",
      language: "Langue",
      role: "Rôle",
      userAdded: "Utilisateur ajouté à cet espace.",
      userUpdated: "Accès utilisateur mis à jour.",
      paymentMethods: "Méthodes de paiement",
      paymentSubtitle: "Gérez les cartes et méthodes de facturation utilisées pour votre abonnement WeSERVE.",
      defaultMethod: "Par défaut",
      expires: "Expire",
      addPayment: "Ajouter une méthode de paiement",
      cardholder: "Titulaire",
      cardNumber: "Numéro de carte",
      expiryDate: "Date d'expiration",
      customizationShortcut: "Personnaliser l'interface",
    },
    banking: {
      title: "Connexions bancaires",
      subtitle: "Connectez un compte bancaire ou PayPal pour faire apparaître automatiquement les nouveaux dons à réviser.",
      pageSubtitle: "Gérez les comptes bancaires connectés et choisissez les comptes du SaaS admissibles pour chaque connexion.",
      bankAccount: "Compte bancaire",
      paypal: "Compte PayPal",
      linked: "Connecté",
      linkedAccounts: "Comptes liés",
      allAccounts: "Tous les comptes SaaS",
      accountScope: "Comptes SaaS associés",
      addBank: "Lier un autre compte bancaire",
      addBankHelp: "Connectez une nouvelle source bancaire pour les dons entrants.",
      institution: "Institution",
      provider: "Fournisseur",
      connectionType: "Type de connexion",
      accountNumber: "Numéro de compte",
      paypalEmail: "Courriel PayPal",
      stripeAccount: "ID de compte Stripe",
      transitNumber: "Transit",
      ibanNumber: "IBAN / routage",
      scopeAll: "Utiliser tous les comptes",
      scopeSelected: "Sélectionner des comptes",
      connectBank: "Connecter le compte bancaire",
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
  { id: "subscription", icon: Building2 },
  { id: "customization", icon: Palette },
];

const defaultReceiptPeriod = {
  dateDebut: "2026-01-01",
  dateFin: "2026-12-31",
};

const incomingDonationQueue = [
  { id: "bank-001", source: "Stripe payout", date: "2026-07-16", amount: 250, donorNumber: "1", methodID: 4, methodLabel: "Card", note: "Grace Family - online gift" },
  { id: "paypal-014", source: "PayPal", date: "2026-07-15", amount: 75, donorNumber: "2", methodID: 4, methodLabel: "Card", note: "Monthly support" },
];

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

function App() {
  const [language, setLanguage] = useState("en");
  const [activeView, setActiveView] = useState("overview");
  const [mobileOpen, setMobileOpen] = useState(false);
  const [notice, setNotice] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [quickActionsOpen, setQuickActionsOpen] = useState(false);
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
  const [pendingDonations, setPendingDonations] = useState(incomingDonationQueue);
  const t = copy[language];
  const notifications = pendingDonations.map((donation) => ({
    id: donation.id,
    title: currency(donation.amount),
    meta: `${donation.source} - ${donation.date}`,
    body: donation.note,
    target: "donations",
  }));

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
      await refresh(actif ? t.donorForm.reactivated : t.donorForm.archived);
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

  async function handleCategorizePendingDonation(pendingDonation, data) {
    try {
      await api("/api/donations", {
        method: "POST",
        body: JSON.stringify({
          donateurID: data.donateurID,
          numero: data.numero,
          compteID: data.compteID,
          montant: pendingDonation.amount,
          dateDon: pendingDonation.date,
          methodeDonID: pendingDonation.methodID,
          description: pendingDonation.note,
        }),
      });
      setPendingDonations((currentDonations) => currentDonations.filter((donation) => donation.id !== pendingDonation.id));
      await loadWorkspace(query);
      showNotice(t.donationForm.categorizeSuccess);
    } catch (saveError) {
      showError(saveError.message);
    }
  }

  async function deleteDonation(donation) {
    if (!window.confirm(t.donationForm.confirmDelete.replace("{id}", donation.donID).replace("{name}", donation.donorName))) {
      return;
    }

    try {
      await api(`/api/donations/${donation.donID}`, { method: "DELETE" });
      await refresh(t.donationForm.deleted);
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

  async function handleCreateUser(event) {
    event.preventDefault();
    try {
      const data = formObject(event.currentTarget);
      await api("/api/users", {
        method: "POST",
        body: JSON.stringify({
          ...data,
          admin: data.admin === "on",
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

  async function toggleUser(userAccount) {
    try {
      await api(`/api/users/${userAccount.utilisateurID}/status`, {
        method: "PATCH",
        body: JSON.stringify({
          actif: !userAccount.actif,
          admin: userAccount.admin,
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
    setQuickActionsOpen(false);
  }

  function handleNotificationSelect(notification) {
    openView(notification.target);
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
            <span>{t.common.support}</span>
          </button>
          <button className={activeView === "settings" ? "ghost-button active" : "ghost-button"} type="button" onClick={() => openView("settings")}>
            <Settings size={16} />
            <span>{t.common.settings}</span>
          </button>
          <button className="ghost-button" type="button" onClick={logout}>
            <LockKeyhole size={16} />
            <span>{t.common.logout}</span>
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
            pendingDonations={pendingDonations}
            t={t}
            onCategorizePending={handleCategorizePendingDonation}
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
            reportResult={reportResult}
            t={t}
            onRunReport={handleRunReport}
          />
        )}
        {!loading && activeView === "banking" && (
          <BankingView
            accounts={accounts}
            t={t}
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
        {!loading && activeView === "customization" && (
          <CustomizationView
            palette={palette}
            savedPalettes={savedPalettes}
            onSavePalette={handleSavePalette}
            setPalette={setPalette}
            t={t}
          />
        )}
        {!loading && activeView === "settings" && (
          <SettingsView
            bootstrap={bootstrap}
            t={t}
            user={displayUser}
            onCustomize={() => openView("customization")}
            onCreateUser={handleCreateUser}
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
          isOpen={quickActionsOpen}
          onToggle={() => setQuickActionsOpen((open) => !open)}
          onViewChange={openView}
          t={t}
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

function Topbar({ language, notifications = [], onLanguageChange, onMenuClick, onNotificationSelect, onProfileClick, onSearch, pendingDonationCount = 0, query, t, user }) {
  const [notificationsOpen, setNotificationsOpen] = useState(false);

  function selectNotification(notification) {
    onNotificationSelect(notification);
    setNotificationsOpen(false);
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
            onClick={() => setNotificationsOpen((open) => !open)}
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
        <button className="profile-chip" type="button" onClick={onProfileClick} aria-label={t.common.openSettings}>
          <span>{initials(user)}</span>
          <div>
            <strong>{user?.prenom || "Admin"}</strong>
            <small>{user?.admin ? t.common.admin : t.common.user}</small>
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
    { label: t.metrics[2], value: String(totals.activeDonors || 0), trend: t.common.active, tone: "amber" },
    { label: t.metrics[3], value: String(totals.pendingReceipts || 0), trend: t.receipts.ready, tone: "red" },
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
              <li><ClipboardList size={15} /> {totals.pendingReceipts || 0} {t.overview.donationsReady}</li>
              <li><BookOpenCheck size={15} /> {totals.receiptCount || 0} {t.overview.receiptsStored}</li>
            </ul>
          </div>
        </Panel>
      </div>
    </section>
  );
}

function QuickActionLauncher({ isOpen, onToggle, onViewChange, t }) {
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
  );
}

function Donations({ accounts, bootstrap, donations, donors, pendingDonations, t, onCategorizePending, onDelete, onSubmit }) {
  const [manualFormOpen, setManualFormOpen] = useState(false);
  const [categorizingDonationId, setCategorizingDonationId] = useState(null);

  return (
    <section className="view-stack">
      <ViewHeader
        title={t.nav.donations}
        subtitle={t.donationForm.subtitle}
        action={t.donationForm.add}
        actionTargetId="donation-form"
        icon={CircleDollarSign}
      />

      <section className="pending-donations-band">
        <div>
          <span className="eyebrow"><Bell size={15} /> {t.common.pending}</span>
          <h2>{t.banking.newDonations}</h2>
          <p className="panel-copy">{t.banking.newDonationHelp}</p>
        </div>
        <div className="incoming-donation-list">
          {pendingDonations.length ? pendingDonations.map((donation) => {
            const detectedDonor = donors.find((donor) => donor.numero === donation.donorNumber);
            const isCategorizing = categorizingDonationId === donation.id;

            return (
            <article className={`incoming-donation ${isCategorizing ? "is-categorizing" : ""}`} key={donation.id}>
              <div>
                <span className="status-pill pending">{t.common.pending}</span>
                <strong>{currency(donation.amount)}</strong>
                <small>{donation.source} • {donation.date} • {donation.methodLabel}</small>
                <p>{donation.note}</p>
                <p className="detected-donor">
                  {t.donationForm.detectedDonor}: {detectedDonor?.fullName || donation.donorNumber}
                </p>
              </div>
              <button className="secondary-button compact" type="button" onClick={() => setCategorizingDonationId(isCategorizing ? null : donation.id)}>
                <Link2 size={15} />
                <span>{t.banking.categorize}</span>
              </button>
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
          }) : (
            <div className="incoming-empty-state">{t.donationForm.noPendingDonations}</div>
          )}
        </div>
      </section>

      <Panel title={t.banking.title} icon={Landmark}>
        <div className="banking-subtle-layout">
          <p className="panel-copy">{t.banking.subtitle}</p>
          <div className="banking-card-list subtle">
            <BankingConnection icon={Landmark} label={t.banking.bankAccount} meta="RBC •••• 0921" t={t} />
            <BankingConnection icon={Wallet} label={t.banking.paypal} meta="finance@grace.local" t={t} />
          </div>
        </div>
      </Panel>

      <Panel id="donation-form" title={t.banking.recordManual} icon={Plus}>
        <button className="manual-donation-toggle" type="button" onClick={() => setManualFormOpen((open) => !open)} aria-expanded={manualFormOpen}>
          <div>
            <strong>{t.donationForm.title}</strong>
            <span>{t.banking.manualHelp}</span>
          </div>
          <ChevronDown size={18} />
        </button>

        {manualFormOpen && (
          <form className="form-grid donation-manual-form" onSubmit={onSubmit}>
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
              <input name="description" placeholder={t.donationForm.descriptionPlaceholder} />
            </label>
            <button className="primary-button form-submit" type="submit">
              <Plus size={17} />
              <span>{t.donationForm.add}</span>
            </button>
          </form>
        )}
      </Panel>

      <div className="two-column form-layout">
        <Panel title={t.donationForm.accountMix} icon={BarChart3}>
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

        <Panel title={t.donationForm.register} icon={FileText}>
          <DataTable
            t={t}
            columns={["ID", t.donationForm.donor, t.donationForm.date, t.donationForm.account, t.donationForm.method, t.donationForm.amount, t.common.status, ""]}
            rows={[
              ...pendingDonations.map((donation) => [
                donation.id,
                donors.find((donor) => donor.numero === donation.donorNumber)?.fullName || donation.donorNumber,
                donation.date,
                "-",
                donation.methodLabel || t.banking.imported,
                currency(donation.amount),
                <span className="status-pill pending" key={`pending-${donation.id}`}>{t.common.pending}</span>,
                <button className="secondary-button compact" type="button" key={`categorize-${donation.id}`}>
                  <Link2 size={15} />
                  <span>{t.banking.categorize}</span>
                </button>,
              ]),
              ...donations.map((donation) => [
                donation.donID,
                donation.donorName,
                donation.dateDon,
                `${donation.noCompte} - ${donation.libelleCompte}`,
                donation.methode_en || t.common.unspecified,
                currency(donation.montant),
                <StatusPill key={`status-${donation.donID}`} t={t} value={donation.receiptStatus} />,
                <button className="icon-button table-icon" type="button" onClick={() => onDelete(donation)} aria-label={t.common.delete} key={`delete-${donation.donID}`}>
                  <Trash2 size={15} />
                </button>,
              ]),
            ]}
          />
        </Panel>
      </div>
    </section>
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

  return <Landmark size={size} />;
}

function BankingConnection({ icon: Icon, label, meta, t }) {
  const brand = bankBrand(`${label} ${meta}`);

  return (
    <article className="banking-connection" style={{ "--bank-color": brand.color, "--bank-soft": brand.soft }}>
      <div className="bank-brand-mark">
        <BankBrandIcon brand={brand} size={18} />
      </div>
      <span>{label}</span>
      <small>{meta}</small>
      <strong><CheckCircle2 size={15} /> {t.banking.linked}</strong>
    </article>
  );
}

function defaultBankingConnections(accounts = []) {
  return [
    {
      id: "national-bank",
      institution: "Banque Nationale",
      accountNumber: "**** 4921",
      transit: "006",
      iban: "CA-006-4921",
      scope: "all",
      accountIds: [],
    },
    {
      id: "paypal-giving",
      institution: "PayPal Giving",
      accountNumber: "finance@weserve.local",
      transit: "PayPal",
      iban: "PP-1842",
      scope: "selected",
      accountIds: accounts.slice(0, 2).map((account) => account.compteID),
    },
  ];
}

function savedBankingConnections(accounts) {
  try {
    const savedConnections = JSON.parse(localStorage.getItem("weserve-banking-connections") || "null");
    return Array.isArray(savedConnections) && savedConnections.length ? savedConnections : defaultBankingConnections(accounts);
  } catch {
    return defaultBankingConnections(accounts);
  }
}

function BankingView({ accounts, t }) {
  const bankingProviders = [
    { value: "Banque Nationale", label: "Banque Nationale", type: "bank" },
    { value: "Desjardins", label: "Desjardins", type: "bank" },
    { value: "RBC", label: "RBC", type: "bank" },
    { value: "TD Bank", label: "TD Bank", type: "bank" },
    { value: "BMO", label: "BMO", type: "bank" },
    { value: "CIBC", label: "CIBC", type: "bank" },
    { value: "Scotiabank", label: "Scotiabank", type: "bank" },
    { value: "PayPal", label: "PayPal", type: "paypal" },
    { value: "Stripe", label: "Stripe", type: "card" },
  ];
  const [linkedAccounts, setLinkedAccounts] = useState(() => savedBankingConnections(accounts));
  const [addBankOpen, setAddBankOpen] = useState(false);
  const [selectedProvider, setSelectedProvider] = useState(bankingProviders[0]);
  const [scopeMode, setScopeMode] = useState("all");

  useEffect(() => {
    localStorage.setItem("weserve-banking-connections", JSON.stringify(linkedAccounts));
  }, [linkedAccounts]);

  function accountNames(bankAccount) {
    if (bankAccount.scope === "all") {
      return t.banking.allAccounts;
    }

    const selectedAccounts = accounts.filter((account) => bankAccount.accountIds.includes(account.compteID));
    return selectedAccounts.length
      ? selectedAccounts.map((account) => `${account.noCompte} - ${account.nom}`).join(", ")
      : t.common.unspecified;
  }

  function addLinkedBankAccount(event) {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const data = Object.fromEntries(formData.entries());
    const selectedAccountIds = formData.getAll("accountIds").map(Number);

    setLinkedAccounts((currentAccounts) => [
      ...currentAccounts,
      {
        id: `bank-${Date.now()}`,
        institution: data.provider,
        accountNumber: data.accountNumber || data.paypalEmail || data.stripeAccount,
        transit: selectedProvider.type === "bank" ? data.transit : selectedProvider.label,
        iban: selectedProvider.type === "bank" ? data.iban : data.stripeAccount || data.paypalEmail,
        scope: data.scope,
        accountIds: data.scope === "all" ? [] : selectedAccountIds,
      },
    ]);
    event.currentTarget.reset();
    setSelectedProvider(bankingProviders[0]);
    setScopeMode("all");
    setAddBankOpen(false);
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

          return (
          <article className="linked-bank-tile" key={bankAccount.id} style={{ "--bank-color": brand.color, "--bank-soft": brand.soft }}>
            <div className="linked-bank-topline">
              <div className="bank-brand-mark large">
                <BankBrandIcon brand={brand} size={24} />
              </div>
              <span className="status-pill issued"><CheckCircle2 size={14} /> {t.banking.linked}</span>
            </div>
            <div>
              <span>{t.banking.bankAccount}</span>
              <h2>{bankAccount.institution}</h2>
              <p>{bankAccount.accountNumber}</p>
            </div>
            <dl className="banking-detail-list">
              <div>
                <dt>{t.banking.transitNumber}</dt>
                <dd>{bankAccount.transit}</dd>
              </div>
              <div>
                <dt>{t.banking.ibanNumber}</dt>
                <dd>{bankAccount.iban}</dd>
              </div>
            </dl>
            <div className="banking-scope-box">
              <strong>{t.banking.accountScope}</strong>
              <p>{accountNames(bankAccount)}</p>
            </div>
          </article>
          );
        })}

        <button className="linked-bank-tile add-bank-tile" type="button" onClick={() => setAddBankOpen((open) => !open)} aria-expanded={addBankOpen}>
          <span><Plus size={28} /></span>
          <strong>{t.banking.addBank}</strong>
          <small>{t.banking.addBankHelp}</small>
        </button>
      </div>

      {addBankOpen && (
        <Panel title={t.banking.addBank} icon={Plus}>
          <form className="form-grid banking-link-form" onSubmit={addLinkedBankAccount}>
            <label>
              {t.banking.provider}
              <select
                name="provider"
                value={selectedProvider.value}
                onChange={(event) => setSelectedProvider(bankingProviders.find((provider) => provider.value === event.target.value) || bankingProviders[0])}
              >
                {bankingProviders.map((provider) => (
                  <option value={provider.value} key={provider.value}>{provider.label}</option>
                ))}
              </select>
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
            <label>
              {t.banking.accountScope}
              <select name="scope" value={scopeMode} onChange={(event) => setScopeMode(event.target.value)}>
                <option value="all">{t.banking.scopeAll}</option>
                <option value="selected">{t.banking.scopeSelected}</option>
              </select>
            </label>
            {scopeMode === "selected" && (
              <label className="full-field">
                {t.banking.linkedAccounts}
                <select name="accountIds" multiple required>
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
              <span>{t.banking.connectBank}</span>
            </button>
          </form>
        </Panel>
      )}
    </section>
  );
}

function Donors({ bootstrap, donors, query, setQuery, t, onArchive, onSearch, onSubmit }) {
  return (
    <section className="view-stack">
      <ViewHeader
        title={t.donorDirectory}
        subtitle={t.donorForm.subtitle}
        action={t.donorForm.new}
        actionTargetId="donor-form"
        icon={Users}
      />

      <div className="two-column form-layout">
        <Panel id="donor-form" title={t.donorForm.title} icon={UserPlus}>
          <form className="form-grid" onSubmit={onSubmit}>
            <label>
              {t.donorForm.number}
              <input name="numero" placeholder={t.donorForm.autoNumber} />
            </label>
            <label>
              {t.donorForm.firstName}
              <input name="prenom" required />
            </label>
            <label>
              {t.donorForm.lastName}
              <input name="nom" required />
            </label>
            <label>
              Email
              <input name="courriel" type="email" />
            </label>
            <label>
              {t.donorForm.address}
              <input name="adresse" />
            </label>
            <label>
              {t.donorForm.city}
              <input name="ville" />
            </label>
            <label>
              {t.donorForm.postalCode}
              <input name="code_postal" />
            </label>
            <label>
              {t.donorForm.province}
              <select name="provinceID" defaultValue="1">
                {bootstrap?.provinces?.map((province) => (
                  <option value={province.provinceID} key={province.provinceID}>
                    {province.abreviation} - {province.provinceEtat_en}
                  </option>
                ))}
              </select>
            </label>
            <label>
              {t.donorForm.cell}
              <input name="tel_cellulaire" />
            </label>
            <label>
              {t.donorForm.residence}
              <input name="tel_residence" />
            </label>
            <label className="checkbox-label">
              <input name="membre" type="checkbox" />
              <span>{t.common.member}</span>
            </label>
            <label className="checkbox-label">
              <input name="recu" type="checkbox" defaultChecked />
              <span>{t.donorForm.receiptsEnabled}</span>
            </label>
            <label className="full-field">
              {t.donorForm.notes}
              <textarea name="notes" rows="3" />
            </label>
            <button className="primary-button form-submit" type="submit">
              <UserPlus size={17} />
              <span>{t.donorForm.title}</span>
            </button>
          </form>
        </Panel>

        <Panel title={t.donorForm.totals} icon={BarChart3}>
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

      <Panel title={t.donorForm.directory} icon={Search}>
        <div className="table-toolbar">
          <div className="search-box inline">
            <Search size={17} />
            <input value={query} onChange={(event) => { setQuery(event.target.value); onSearch(event); }} placeholder={t.donorForm.filter} />
          </div>
          <button className="secondary-button" type="button" onClick={() => downloadCSV("donors.csv", donors)}>
            <Download size={16} />
            <span>{t.common.csv}</span>
          </button>
        </div>
        <DataTable
          t={t}
          columns={["No.", t.donationForm.donor, t.common.email, t.donorForm.city, t.donorForm.lifetime, t.donorForm.lastGift, t.nav.receipts, ""]}
          rows={donors.map((donor) => [
            donor.numero,
            donor.fullName,
            donor.courriel || "-",
            donor.ville || "-",
            currency(donor.totalDonations || 0),
            donor.lastGift || "-",
            donor.recu ? t.common.yes : t.common.no,
            <button className="secondary-button compact" type="button" onClick={() => onArchive(donor, !donor.actif)} key={`archive-${donor.donateurID}`}>
              {donor.actif ? t.common.archive : t.common.activate}
            </button>,
          ])}
        />
      </Panel>
    </section>
  );
}

function Accounts({ accounts, donations, t, onDelete, onSubmit, onToggle, onUpdate }) {
  const [selectedAccountId, setSelectedAccountId] = useState(null);
  const [editingAccountId, setEditingAccountId] = useState(null);
  const [expandedAccountId, setExpandedAccountId] = useState(null);
  const [accountPendingDelete, setAccountPendingDelete] = useState(null);
  const selectedAccount = accounts.find((account) => account.compteID === selectedAccountId);
  const expandedAccount = accounts.find((account) => account.compteID === expandedAccountId);

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
    }
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
        actionTargetId="account-form"
        icon={ClipboardList}
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
                    <span>{account.donationCount} {account.donationCount === 1 ? t.accounts.donationSingular : t.accounts.donationPlural}</span>
                    <strong>{currency(account.total || 0)}</strong>
                  </button>

                  {isOpen && (
                    <div className="account-accordion-body">
                      <div className="account-actions">
                        <button className="icon-button table-icon" type="button" onClick={() => setEditingAccountId(account.compteID)} aria-label={t.common.edit}>
                          <Pencil size={15} />
                        </button>
                        <button className="icon-button table-icon" type="button" onClick={() => setExpandedAccountId(account.compteID)} aria-label={t.common.view}>
                          <Maximize2 size={15} />
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

      <div className="two-column form-layout">
        <Panel id="account-form" title={t.accounts.add} icon={Plus}>
          <form className="form-grid" onSubmit={submitNewAccount}>
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
        </Panel>

        <Panel title={t.accounts.eligibility} icon={ReceiptText}>
          <div className="readiness">
            <div>
              <strong>{accounts.filter((account) => account.recu).length}</strong>
              <span>{t.accounts.eligibilityText}</span>
            </div>
            <div className="progress">
              <span style={{ width: `${accounts.length ? (accounts.filter((account) => account.recu).length / accounts.length) * 100 : 0}%` }} />
            </div>
          </div>
        </Panel>
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

function ConfirmDialog({ body, confirmLabel, isDanger = false, onCancel, onConfirm, t, title }) {
  return (
    <div className="modal-backdrop" role="presentation" onClick={onCancel}>
      <section className="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="confirm-dialog-title" onClick={(event) => event.stopPropagation()}>
        <div className="confirm-dialog-icon">
          <Trash2 size={20} />
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

function AccountDetail({ account, donations, isEditing, isExpanded = false, onCancelEdit, onEdit, onSubmitEdit, t }) {
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
        <button className="icon-button table-icon" type="button" onClick={onEdit} aria-label={t.common.edit}>
          <Pencil size={15} />
        </button>
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

      <Panel title={t.subscription.plans} icon={Sparkles}>
        <div className="subscription-plan-grid">
          {t.subscription.plansList.map((plan, index) => (
            <article className={`subscription-plan ${index === 1 ? "is-featured" : ""}`} key={plan.name}>
              {index === 1 && <span className="plan-badge">{t.common.recommended}</span>}
              <span>{plan.name}</span>
              <strong>{plan.price}</strong>
              <p>{plan.description}</p>
              <ul>
                {plan.features.map((feature) => (
                  <li key={feature}><CheckCircle2 size={16} /> {feature}</li>
                ))}
              </ul>
              <button className={index === 1 ? "primary-button" : "secondary-button"} type="button">
                <span>{t.subscription.choose}</span>
              </button>
            </article>
          ))}
        </div>
      </Panel>

      <div className="two-column form-layout">
        <Panel id="subscription-form" title={t.subscription.title} icon={ClipboardList}>
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

        <Panel title={t.subscription.pricing} icon={ShieldCheck}>
          <div className="plan-note-list">
            {t.subscription.plansList.map((plan) => (
              <div className="plan-note" key={`note-${plan.name}`}>
                <span>{plan.name}</span>
                <strong>{plan.price}</strong>
              </div>
            ))}
          </div>
        </Panel>
      </div>
    </section>
  );
}

function SettingsView({ bootstrap, t, user, onCustomize, onCreateUser, onSubmit, onUserStatus }) {
  const organization = bootstrap?.organisme || {};
  const users = bootstrap?.users?.length ? bootstrap.users : [user].filter(Boolean);
  const [addPaymentOpen, setAddPaymentOpen] = useState(false);

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
              <span>Member</span>
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
          <form className="form-grid user-form" onSubmit={onCreateUser}>
            <label>
              First name
              <input name="prenom" required maxLength="50" />
            </label>
            <label>
              Last name
              <input name="nom" required maxLength="50" />
            </label>
            <label>
              Email
              <input name="email" required type="email" />
            </label>
            <label>
              Temporary password
              <input name="password" required minLength="8" type="password" />
            </label>
            <label className="checkbox-label">
              <input name="admin" type="checkbox" />
              <span>Admin access</span>
            </label>
            <button className="primary-button form-submit" type="submit">
              <UserPlus size={17} />
              <span>Add user</span>
            </button>
          </form>
          <DataTable
            columns={["Name", "Email", "Language", "Role", "Active", ""]}
            rows={users.map((account) => [
              `${account.prenom || ""} ${account.nom || ""}`.trim() || "User",
              account.courriel || "-",
              String(account.langue || "en").toUpperCase(),
              account.admin ? "Admin" : "User",
              account.actif === false ? "No" : "Yes",
              account.utilisateurID === user?.utilisateurID ? "-" : (
                <button className="secondary-button compact" type="button" onClick={() => onUserStatus(account)} key={`user-${account.utilisateurID}`}>
                  {account.actif === false ? "Activate" : "Deactivate"}
                </button>
              ),
            ])}
          />
        </Panel>
      </div>

      <div className="two-column form-layout">
        <Panel title={t.settings.paymentMethods} icon={CreditCard}>
          <p className="panel-copy">{t.settings.paymentSubtitle}</p>
          <div className="payment-tile-grid">
            <PaymentMethodCard
              brand="Visa"
              details="•••• 4242"
              expiry="04/29"
              isDefault
              t={t}
            />
            <PaymentMethodCard
              brand="Mastercard"
              details="•••• 1881"
              expiry="11/28"
              t={t}
            />
            <button className="payment-method-tile add-payment-tile" type="button" onClick={() => setAddPaymentOpen((open) => !open)} aria-expanded={addPaymentOpen}>
              <span><Plus size={28} /></span>
              <strong>{t.settings.addPayment}</strong>
              <small>{t.settings.paymentSubtitle}</small>
            </button>
          </div>
          {addPaymentOpen && (
            <form className="form-grid payment-link-form">
              <label>
                {t.settings.cardholder}
                <input name="cardholder" placeholder="Grace Community Church" />
              </label>
              <label>
                {t.settings.cardNumber}
                <input name="cardNumber" placeholder="•••• •••• •••• 4242" />
              </label>
              <label>
                {t.settings.expiryDate}
                <input name="expiryDate" placeholder="04/29" />
              </label>
              <button className="primary-button form-submit" type="button" onClick={() => setAddPaymentOpen(false)}>
                <CreditCard size={17} />
                <span>{t.settings.addPayment}</span>
              </button>
            </form>
          )}
        </Panel>

        <Panel title={t.customization.title} icon={Palette}>
          <p className="panel-copy">{t.customization.subtitle}</p>
          <button className="primary-button" type="button" onClick={onCustomize}>
            <Palette size={16} />
            <span>{t.settings.customizationShortcut}</span>
          </button>
        </Panel>
      </div>
    </section>
  );
}

function PaymentMethodCard({ brand, details, expiry, isDefault = false, t }) {
  return (
    <article className="payment-method-tile">
      <div className="linked-bank-topline">
        <div className="payment-card-mark">
          <CreditCard size={20} />
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
      <div className="banking-scope-box payment-scope-box">
        <strong>{t.common.manage}</strong>
        <p>{brand} {details}</p>
        <button className="icon-button table-icon" type="button" aria-label={t.common.manage}>
          <Pencil size={15} />
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

function ViewHeader({ title, subtitle, action, actionTargetId, icon: Icon, onAction }) {
  const handleAction = onAction || (actionTargetId ? () => focusTarget(actionTargetId) : null);

  return (
    <div className="view-header">
      <div>
        <span className="eyebrow"><Icon size={15} /> WeSERVE SaaS</span>
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

function DataTable({ columns, rows, t, emptyMessage }) {
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
              <td colSpan={columns.length}>{emptyMessage || t?.common?.noRecords || "No records found"}</td>
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
