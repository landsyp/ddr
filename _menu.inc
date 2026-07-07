	<CFIF Session.langue EQ "fr">
		<div class="w-section sectionheader">
  			<div class="w-container containerheader">
	 			<div class="w-row">
					<div class="w-col w-col-8 w-col-stack w-clearfix">
		  				<div class="w-nav containerheadercolonne1" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
			 				<div class="w-container navigationddr">
								<a class="w-nav-brand" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/accueil"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png">
								</a>
								<nav class="w-nav-menu containermenuprincipal" role="navigation">
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "index.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/accueil">Connexion</a>
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "abonnement.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/abonnement">Abonnement</a>
									<!--- <a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "tarifs.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/tarifs">Tarifs</a> --->
									<a class="w-nav-link itemmenuprincipal" href="https://cqoc.org/ddr-2/" target="_blank">Contact  - Tarification</a>
								</nav>
			 				</div>
			 				<div class="w-nav-button hamburgermenu">
								<div class="w-icon-nav-menu"></div>
			 				</div>
		  				</div>
					</div>
					<div class="w-col w-col-4 w-col-stack colonne2menuprincipal">
		  				
		  				<!--- LANGUES --->
						<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
							<div class="w-dropdown-toggle containerselecteurlangue">
								<div>Fran&ccedil;ais</div>
								<div class="w-icon-dropdown-toggle"></div>
							</div>
							<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_en#</cfoutput>">English</a>
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
								<a class="w-nav-brand" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/home"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png">
								</a>
								<nav class="w-nav-menu containermenuprincipal" role="navigation">
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "index.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/home">Log in</a>
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "abonnement.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/subscription">Subscription</a>
									<a class="w-nav-link itemmenuprincipal <cfif CGI.SCRIPT_NAME CONTAINS "tarifs.cfm" >w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/rates">Rates</a>
									<a class="w-nav-link itemmenuprincipal" href="https://cqoc.org/en/ddr-2/" target="_blank">Contact  - Pricing</a>
								</nav>
			 				</div>
			 				<div class="w-nav-button hamburgermenu">
								<div class="w-icon-nav-menu"></div>
			 				</div>
		  				</div>
					</div>
					<div class="w-col w-col-4 w-col-stack colonne2menuprincipal">
		  				
		  				<!--- LANGUES --->
						<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
							<div class="w-dropdown-toggle containerselecteurlangue">
								<div>English</div>
								<div class="w-icon-dropdown-toggle"></div>
							</div>
							<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_fr#</cfoutput>">Fran&ccedil;ais</a>
							</nav>
						</div>
					</div>
	 			</div>
  			</div>
		</div>
	</CFIF>