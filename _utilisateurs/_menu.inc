	<CFIF Session.langue EQ "fr">
		<div class="w-section sectionheader">
  			<div class="w-container containerheader">
	 			<div class="w-row">
					<div class="w-col w-col-9 w-col-stack w-clearfix">
		  				<div class="w-nav containerheadercolonne1" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
			 				<div class="w-container navigationddr">
								<a class="w-nav-brand" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/accueil"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png"></a>
								<nav class="w-nav-menu containermenuprincipal" role="navigation">
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "don.cfm" OR CGI.SCRIPT_NAME CONTAINS "dons_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-dons/page-1">Dons</a>
									<!--- ADMIN ET NIVEAU 2 --->
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-donateurs/page-1">Donateurs</a>
									</CFIF>
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2,5",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-dons">Rapports</a>
									</CFIF>
									<!--- ADMIN --->
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-recus">Reçus impôt</a> 
									</CFIF>
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0",Session.utilisateur.statut)><!--- <cfoutput>#Session.utilisateur.statut#</cfoutput> --->
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/tutoriels">Tutoriels<!--- <img height="30" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/video_tut.png" TITLE="Tutoriels"> ---></a>
									</CFIF>
									<a class="w-nav-link itemmenuprincipal itemparametresmobile" href="#">Paramètres</a>
									<a class="w-nav-link itemmenuprincipal itemparametresmobile" href="#">Changer de langue</a> 
									<!--- fin licence --->
								</nav>
			 				</div>
			 				<div class="w-nav-button hamburgermenu">
								<div class="w-icon-nav-menu"></div>
			 				</div>
		  				</div>
					</div>
					<div class="w-col w-col-3 w-col-stack colonne2menuprincipal">
		  				<div class="w-dropdown w-clearfix" data-delay="0" data-hover="1">
			 				<div class="w-dropdown-toggle containerparametres">
								<div class="lienparametres">Param&egrave;tres</div>
			 				</div>
			 				<nav class="w-dropdown-list containterparametresmenu">
			 					<!--- GESTIONNAIRE SEULEMENT --->
								<CFIF isDefined('Session.utilisateur.supraAdmin') AND Session.utilisateur.supraAdmin>
			 						<a class="w-dropdown-link liparametres parametreicone5"  href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/admin-liste-organismes/page-1">Gestion clients</a>
			 					</CFIF>
								<!--- ADMIN SEULEMENT --->
								<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1",Session.utilisateur.statut)>
									<a class="w-dropdown-link liparametres parametreicone1" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/parametres-profil">Profil de l'organisme</a>
			 						<a class="w-dropdown-link liparametres parametreicone2" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-utilisateurs/page-1">Utilisateurs</a>
			 					</CFIF>
								<!--- TOUS --->
			 					<a class="w-dropdown-link liparametres parametreicone4" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/deconnexion"><strong>Se déconnecter</strong></a>
			 				</nav>
		  				</div>
		  				<!--- LANGUES --->
						<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
							<div class="w-dropdown-toggle containerselecteurlangue">
								<div>FR</div>
								<div class="w-icon-dropdown-toggle"></div>
							</div>
							<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_en#</cfoutput>">EN</a>
							</nav>
						</div>
		  				
					</div>
	 			</div>
  			</div>
		</div>
	<CFELSE>
		<div class="w-section sectionheader">
  			<div class="w-container containerheader">
	 			<div class="w-row">
					<div class="w-col w-col-8 w-col-stack w-clearfix">
		  				<div class="w-nav containerheadercolonne1" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
			 				<div class="w-container navigationddr">
								<a class="w-nav-brand" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/home"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png"></a>
								<nav class="w-nav-menu containermenuprincipal" role="navigation">
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "don.cfm" OR CGI.SCRIPT_NAME CONTAINS "dons_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/gifts-list/page-1">Gifts</a>
									<!--- ADMIN ET NIVEAU 2 --->
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/donors-list/page-1">Donors</a>
									</CFIF>
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2,5",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-gifts">Reports</a>
									</CFIF>
									<!--- ADMIN --->
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-receipts">Tax Receipts</a>
									</CFIF>
									<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1",Session.utilisateur.statut)>
										<a class="w-nav-link itemmenuprincipal" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/tutorials"><!--- <img height="30" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/video_tut.png"> --->Tutorials</a> 
									</CFIF>
									<a class="w-nav-link itemmenuprincipal itemparametresmobile" href="#">Parameters</a><a class="w-nav-link itemmenuprincipal itemparametresmobile" href="#">Change language</a>
								</nav>
			 				</div>
			 				<div class="w-nav-button hamburgermenu">
								<div class="w-icon-nav-menu"></div>
			 				</div>
		  				</div>
					</div>
					<div class="w-col w-col-4 w-col-stack colonne2menuprincipal">
		  				<div class="w-dropdown w-clearfix" data-delay="0" data-hover="1"> 
			 				<div class="w-dropdown-toggle containerparametres">
								<div class="lienparametres">Parameters</div>
			 				</div>
			 				<nav class="w-dropdown-list containterparametresmenu">
								<!--- GESTIONNAIRE SEULEMENT --->
			 					<CFIF isDefined('Session.utilisateur.supraAdmin') AND Session.utilisateur.supraAdmin>
			 						<a class="w-dropdown-link liparametres parametreicone5"  href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/admin-charities-list/page-1">Clients Management</a>
			 					</CFIF>
								<!--- ADMIN SEULEMENT --->
								<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1",Session.utilisateur.statut)>
									<a class="w-dropdown-link liparametres parametreicone1" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/parameters-profile">Your account</a>
			 						<a class="w-dropdown-link liparametres parametreicone2" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/users-list/page-1">Users</a>
			 					</CFIF>
								
			 					<a class="w-dropdown-link liparametres parametreicone4" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/logout"><strong>Logout</strong></a>
			 				</nav>
		  				</div>
		  				<!--- LANGUES --->
						<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
							<div class="w-dropdown-toggle containerselecteurlangue">
								<div>EN</div>
								<div class="w-icon-dropdown-toggle"></div>
							</div>
							<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_fr#</cfoutput>">FR</a>
							</nav>
						</div>
					</div>
	 			</div>
  			</div>
		</div>
	</CFIF>