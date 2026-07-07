		<CFIF session.langue EQ "fr">
  			<div class="w-container containerprincipal">
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "admin_organisme.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/admin-ajout-organisme" STYLE="color:red;">AJOUT ORGANISME</a>
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "admin_organismes_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/admin-liste-organismes/page-1" STYLE="color:red;">LISTE ORGANISMES</a>
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
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "admin_ajout_organisme.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/admin-add-charity" STYLE="color:red;">ADD CHARITY</a>
			 					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "admin_organismes_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/admin-charities-list/page-1" STYLE="color:red;">CHARITIES' LIST</a>
			 					<!--- <a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "rapport_dons_sommaire.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/help">HELP</a> --->
			 					
			 				</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		</CFIF>