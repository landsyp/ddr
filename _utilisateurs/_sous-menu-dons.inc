		<CFIF session.langue EQ "fr">
  			<div class="w-container containerprincipal">
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "don.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/ajout-don">AJOUTER UN DON</a>
			 					<!--- ADMIN - NIVEAU 2 --->
								<CFIF listFind("0,1,2",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "dons-batch.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/import-dons-lot">IMPORT DONS EN LOT (EXCEL)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "dons_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-dons/page-1">LISTE DES DONS</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "compte.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/ajout-compte">AJOUTER UN COMPTE</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "comptes_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-comptes/page-1">LISTE DES COMPTES</a>
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
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "don.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/add-gift">ADD A GIFT</a>
			 					<!--- ADMIN - NIVEAU 2 --->
								<CFIF listFind("0,1,2",Session.utilisateur.statut)>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "dons-batch.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/gifts-batch-import">GIFTS BATCH IMPORT (EXCEL)</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "dons_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/gifts-list/page-1">GIFTS' LIST</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "compte.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/add-account">ADD AN ACCOUNT</a>
									<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "comptes_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/accounts-list/page-1">ACCOUNT'S LIST</a>
								</CFIF>
							</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		</CFIF>