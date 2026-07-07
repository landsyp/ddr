				<CFIF session.langue EQ "fr">
					<div class="w-container containerprincipal">
      				<div class="blocsousmenu">
        				<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
          				<div class="w-container containersousmenu">
            				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
            					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateur.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/ajout-donateur">AJOUTER UN DONATEUR</a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateurs-batch.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/import-donateurs-lot">IMPORT DONATEURS EN LOT (EXCEL)</a>
            					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateurs_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-donateurs/page-1">LISTE DES DONATEURS</a>
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
            					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateur.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/add-donor">ADD A DONOR</a>
            					<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateurs-batch.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/donors-batch-import">DONORS BATCH IMPORT (EXCEL)</a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu <cfif CGI.SCRIPT_NAME CONTAINS "donateurs_liste.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/donors-list/page-1">DONORS' LIST</a>
            				</nav>
          				</div>
        				</div>
      				</div>
    				</div>
    			</CFIF>