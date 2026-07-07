		<CFIF session.langue EQ "fr">
  			<div class="w-container containerprincipal">
	 			<div class="blocsousmenu">
					<div class="w-nav barresousnavigation" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
		  				<div class="w-container containersousmenu">
			 				<nav class="w-nav-menu containernavigationsousmenu" role="navigation">
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "rapport_recus.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-recus">Pour impression <BR> <IMG SRC="/images/pdfToPrint.png" STYLE="height:20px;" title="pdf pour impression"></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "rapport_impression_pdf">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-impression-pdf/page-1"><em>Rapport impression</em></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "impressions_liste">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-impressions-pdf/page-1"><em>Rapport impression/date</em></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "generateur_recus_courriels.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/generateur-recus-courriels">Pour envois courriel<BR> <IMG SRC="/images/pdfToMail.png" STYLE="height:20px;"><!--- <span style="color:red;font-size:8pt;">(version d'essai)</span> ---></a>
								 <a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "rapport_envois_courriel">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-envois-courriel/page-1"><em>Rapport envois</em>  </a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "envois_liste.cfm" OR CGI.SCRIPT_NAME CONTAINS "envoi_info.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-envois/page-1"><em>Rapport envois/date</em></a> 
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
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "rapport_recus.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-receipts">For printing  <BR> <IMG SRC="/images/pdfToPrint.png" STYLE="height:20px;" title="PDF to print"></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "rapport_impression_pdf">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-pdf-printing/page-1"><em>Printing report</em></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu pdf <cfif CGI.SCRIPT_NAME CONTAINS "impressions_liste">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/pdf-printing-list/page-1"><em>Printing report/date</em></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "generateur_recus_courriels.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/receipts-email-generator">For emailing  <BR> <IMG SRC="/images/pdfToMail.png" STYLE="height:20px;"><!--- <span style="color:red;font-size:8pt;">(trial version)</span> ---></a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "rapport_envois_courriel" OR CGI.SCRIPT_NAME CONTAINS "envoi_info.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-bulk-emails/page-1">Emailings report </a>
								<a class="w-nav-link itemmenuprincipal itemsousmenu courriel <cfif CGI.SCRIPT_NAME CONTAINS "envois_liste.cfm" OR CGI.SCRIPT_NAME CONTAINS "envoi_info.cfm">w--current</CFIF>" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/bulk-emails-list/page-1">Emailings report/date</a>
			 				</nav>
		  				</div>
					</div>
	 			</div>
  			</div>
  		</CFIF>