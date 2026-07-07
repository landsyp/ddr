		<CFIF session.langue EQ "fr">
  			<div class="w-container containerprincipal">
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
			 					<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2,5",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "bordereau_depot.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/bordereau-depot">BORDEREAU DÉPÔT</a>
			 					</CFIF>
								<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-dons">DONS (D&eacute;taill&eacute;)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons-sommaire.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-dons-sommaire">DONS (Sommaire)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_donateurs.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-donateurs">DONATEURS</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_comptes.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-comptes">COMPTES</a>
			 					</CFIF>
								<CFIF Session.utilisateur.admin>
			 						<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_recus.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-recus">REÇUS IMPÔT</a>
			 					</CFIF>
			 				</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		<CFELSE>
  			<div class="w-container containerprincipal"> 
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
			 					<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2,5",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "bordereau_depot.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/deposit-slip">DEPOSIT SLIP</a>
			 					</CFIF>
								<CFIF isDefined('Session.utilisateur.statut') AND listFind("0,1,2",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-gifts">GIFTS (Detailed)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons_sommaire.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-gifts-summary">GIFTS (Summary)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_donateurs.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-donors">DONORS</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_comptes.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-accounts">ACCOUNTS</a>
			 					</CFIF>
								<CFIF Session.utilisateur.admin>
			 						<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_recus.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-receipts">TAX RECEIPTS</a>
			 					</CFIF>
			 				</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		</CFIF>