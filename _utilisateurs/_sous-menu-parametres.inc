		<CFIF session.langue EQ "fr">
  			<div class="w-container containerprincipal">
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "profil.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/parametres-profil">PROFIL DE L'ORGANISME</a>
			 					<CFIF isDefined('Session.utilisateur.admin') AND Session.utilisateur.admin>
			 						<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "utilisateurs_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-utilisateurs/page-1">LISTE DES UTILISATEURS</a>
			 					</CFIF>
			 					<!--- <a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "aide.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/aide">AIDE</a> --->
			 					
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
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "profil.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/parameters-profile">YOUR ACCOUNT</a>
			 					<CFIF isDefined('Session.utilisateur.admin') AND Session.utilisateur.admin>
			 						<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "utilisateurs_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/users-LIST/page-1">USERS</a>
			 					</cfif>
			 					<!--- <a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons_sommaire.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/help">HELP</a> --->
			 					
			 				</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		</CFIF>