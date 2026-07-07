<CFTRY>

	<cfset newLocal = SetLocale("French (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR ACCOUNTS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-accounts">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT COMPTES">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-comptes">
	
	<!--- Use cfsetting to block output of HTML  outside cfoutput tags. ---> 
<!--- 	<cfsetting enablecfoutputonly="Yes">  --->

	<CFParam name="statut" default="tous">
	<CFParam name="tri" default="noCompte">
	<CFParam name="typeexport" default="pdf">

	<CFIF isDefined('Form.rapport')>
	
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportComptes" returnvariable ="ListeComptes">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="statut" value="#Form.statut#">
			<cfinvokeargument name="tri" value="#Form.tri#">
		</cfinvoke>		
		
		<!--- <cfset typerapport=Form.typerapport> --->
		<cfset statut=Form.statut>
		<cfset tri=Form.tri>
		
		
		<CFIF session.langue EQ "fr">
			<cfswitch expression="#statut#">
				<cfcase value="recu"><cfset TitreRapport="LISTE DES COMPTES AVEC RE&Ccedil;US"></cfcase>
				<cfcase value="sansRecu"><cfset TitreRapport="LISTE DES COMPTES SANS RE&Ccedil;US"></cfcase>
				<cfcase value="tous"><cfset TitreRapport="LISTE DE TOUS LES COMPTES"></cfcase>
			</cfswitch>
		<cfelse>
			<cfswitch expression="#statut#">
				<cfcase value="recu"><cfset TitreRapport="ACCOUNTS' LIST WITH RECEIPTS"></cfcase>
				<cfcase value="sansRecu"><cfset TitreRapport="ACCOUNT'S LIST WITHOUT RECEIPTS"></cfcase>
				<cfcase value="tous"><cfset TitreRapport="ALL ACCOUNTS' LIST"></cfcase>
			</cfswitch>
		</cfif>
		
		<!--- <CFIF typeexport EQ "pdf"> --->
		
		
			<cfdocument format="pdf"  overwrite="true" localURL="true">

				<cfdocumentitem type="header">
					<style>
						.BlocEntete{
							font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
							font-size: 14px;
							font-weight: normal;
							background-color: #DDDDDD;
							border-bottom:1px solid black;
						}
					</style>
					<table border=0 cellpadding=2 cellspacing=0 width="100%">
						<THEAD>
							<TH  CLASS="BlocEntete"><br><cfoutput>#TitreRapport#</cfoutput></TH>
						</THEAD>
					
					</table>
				</cfdocumentitem>
				<cfdocumentitem type="footer">
					<style>
						.BlocPiedDePage{
							font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
							font-size: 10px;
							font-weight: normal;
							background-color: #DDDDDD;
							border-bottom:1px solid black;
						}
					</style>
					<table border=0 cellpadding=2 cellspacing=0 width="100%" CLASS="BlocPiedDePage">
						<tr >
							<td><cfoutput>#DateFormat(Now(),"yyyy-mm-dd")#</cfoutput></td>
							<td align="center"><cfoutput>#organisme.organisme#</cfoutput></td>
							<td align="right">Page <cfoutput>#cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
						</tr>
					</table>
				</cfdocumentitem>
				<cfdocumentsection>
					<style>
						.BlocEntete{
							font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
							font-size: 12px;
							font-weight: normal;
							background-color: #DDDDDD;
							border-bottom:1px solid black;
							text-align:left;
						}
						.BlocCorps{
							font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
							font-size: 11px;
							font-weight: normal;
						}
					</style>
					<CFIF session.langue EQ "fr">
						<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
							<THEAD >
								<TH CLASS="BlocEntete" >#&nbsp;</TH>
								<TH CLASS="BlocEntete">Re&ccedil;u</TH>
								<TH CLASS="BlocEntete">Nom</TH>
							</THEAD>
			
						
							<cfoutput query="ListeComptes" >
								<tr STYLE="line-height:20px;">
									<td >#noCompte#&nbsp;</td>
									<td ><CFIF recu>oui<cfelse>non</cfif></td>
									<td >#nom#</td>
								</tr>
							</CFOUTPUT>
	
						</table>
					<CFELSE>
						<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
							<THEAD >
								<TH CLASS="BlocEntete" >#&nbsp;</TH>
								<TH CLASS="BlocEntete">Receipt</TH>
								<TH CLASS="BlocEntete">Name</TH>
							</THEAD>
			
					
							<cfoutput query="ListeComptes" >
								<tr STYLE="line-height:20px;">
									<td >#noCompte#&nbsp;</td>
									<td ><CFIF recu>yes<cfelse>no</cfif></td>
									<td >#nom#</td>
								</tr>
							</CFOUTPUT>
	
						</table>
					</CFIF>
				</cfdocumentsection>
			
			</cfdocument>
		<!--- <CFELSE>
					<cfsetting enablecfoutputonly="Yes">
					<cfcontent type="application/msexcel">
					<cfheader name="Content-Disposition" value="filename=rapport.xls"> 
								
					<style>
						.BlocEntete{
							font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
							font-size: 14px;
							font-weight: normal;
							background-color: #DDDDDD;
							border-bottom:1px solid black;
						}
					</style>
					<cfoutput>
						<table border=0 cellpadding=2 cellspacing=0 width="100%">
							<THEAD>
								<TH  CLASS="BlocEntete"><br>#TitreRapport#</TH>
							</THEAD>
										
									
							<CFIF session.langue EQ "fr">
								<THEAD >
									<TH CLASS="BlocEntete" >#&nbsp;</TH>
									<TH CLASS="BlocEntete">Re&ccedil;u</TH>
									<TH CLASS="BlocEntete">Nom</TH>
								</THEAD>
								<CFLOOP query="ListeComptes" >
									<tr STYLE="line-height:20px;">
										<td >#noCompte#&nbsp;</td>
										<td ><CFIF recu>oui<cfelse>non</cfif></td>
										<td >#nom#</td>
									</tr>
								</CFLOOP>
							<CFELSE>
								<THEAD >
									<TH CLASS="BlocEntete" >#&nbsp;</TH>
									<TH CLASS="BlocEntete">Receipt</TH>
									<TH CLASS="BlocEntete">Name</TH>
								</THEAD>
								<CFLOOP query="ListeComptes" >
									<tr STYLE="line-height:20px;">
										<td >#noCompte#&nbsp;</td>
										<td ><CFIF recu>yes<cfelse>no</cfif></td>
										<td >#nom#</td>
									</tr>
								</CFLOOP>
							</CFIF>
						</table>
					</cfoutput>
				</CFIF> --->
		
	</CFIF>
	
	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<!--- <div class="w-section sectionsousheader">
							<div class="w-container containersousheader">
				 				<div class="wrappersousheader">
				 					<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Rapports &gt; Rapport de comptes</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Reports &gt;Accounts' Report</h3>
									</CFIF>
				 				</div>
							</div>
						</div> --->
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-rapports.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
						<div class="containertyperapport">
							<div class="titretyperapport">
								<CFIF session.langue EQ "fr">
									<strong>RAPPORT DE COMPTES</strong>
								<CFELSE>
									<strong>ACCOUNTS' REPORT</strong>
								</CFIF>
							</div>
        				</div>
        				
						<div class="w-form">
						
							<!--- LIEN VERS LES TUTORIELS --->
							<CFIF session.langue EQ "fr">
								<button style="background-color: white;" onClick="showHideTut()">
									<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriel.png">
								</button>
								<div id="videoTut" style="display: none;">
									<iframe width="90%" height="400" src="https://www.youtube.com/embed/hV57lDcwSF8?si=UNkZ9gLMmlOKIoeC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
								</div>
							<CFELSE>
								<button style="background-color: white;" onClick="showHideTut()">
									<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorial.png">
								</button>
								<div id="videoTut" style="display: none;">
									<iframe width="90%" height="400" src="https://www.youtube.com/embed/4GFgmdr4qRY?si=P7lJ8pVapTmNW6i_" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
								</div>
							</CFIF>
						
							<CFIF session.langue EQ "fr">
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_fr#" METHOD="POST">
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Statut des comptes</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="recu" checked="#statut EQ 'recu'#">
												<label class="w-form-label" for="grouperpardate">Avec reçus</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="sansRecu" checked="#statut EQ 'sansRecu'#">
												<label class="w-form-label" for="grouperparcompte">Sans reçus</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="Tous" checked="#statut EQ 'tous'#">
												<label class="w-form-label" for="grouperpardonateur">Tous</label>
											</div>
										</div>
									</div>
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Trier</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="noCompte" checked="#tri EQ 'noCompte'#">
												<label class="w-form-label" for="numdonateur"># de compte</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
												<label class="w-form-label" for="nomprenom">Nom de compte</label>
											</div>
										</div>
									</div>

									<!--- <div class="blocradiobuttons">
																			<div class="containerradiobuttons">
																				<div class="w-radio w-clearfix champradiobutton">
																					<cfinput class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="pdf" checked="#typeexport EQ 'pdf'#">
																					<label class="w-form-label petittextegris" for="pdf">Export PDF</label>
																				</div>
																				<div class="w-radio w-clearfix champradiobutton">
																					<cfinput class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="excel" checked="#typeexport EQ 'excel'#">
																					<label class="w-form-label petittextegris" for="excel">Export Excel</label>
																				</div>
																			</div>
																		</div> --->
								
									<div class="blocchamp blocchamppleinelargeur">
									<cfinput class="w-button boutonvalider" data-wait="Préparation du rapport en cours" name="rapport" type="submit" formtarget="_blank" value="Générer le rapport" wait="Préparation du rapport en cours">
									</div>
								</CFFORM>
							<CFELSE>
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_en#" METHOD="POST">
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Status of the account</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="recu" checked="#statut EQ 'recu'#">
												<label class="w-form-label" for="grouperpardate">With Receipts</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="sansRecu" checked="#statut EQ 'sansRecu'#">
												<label class="w-form-label" for="grouperparcompte">Without Receipts</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="Tous" checked="#statut EQ 'tous'#">
												<label class="w-form-label" for="grouperpardonateur">All</label>
											</div>
										</div>
									</div>
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Sort by</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="noCompte" checked="#tri EQ 'noCompte'#">
												<label class="w-form-label" for="numdonateur">Account Numberr</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
												<label class="w-form-label" for="nomprenom">Account Name</label>
											</div>
										</div>
									</div>
								
									<!--- <div class="blocradiobuttons">
																			<div class="containerradiobuttons">
																				<div class="w-radio w-clearfix champradiobutton">
																					<input class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="pdf">
																					<label class="w-form-label petittextegris" for="pdf">Export PDF</label>
																				</div>
																				<div class="w-radio w-clearfix champradiobutton">
																					<input class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="excel">
																					<label class="w-form-label petittextegris" for="excel">Export Excel</label>
																				</div>
																			</div>
																		</div> --->
								
									<div class="blocchamp blocchamppleinelargeur">
									<cfinput class="w-button boutonvalider" data-wait="Wait for report" name="rapport" type="submit" formtarget="_blank" value="Display Report" wait="Wait for report">
									</div>
								</CFFORM>
							</CFIF>
						</div>
      			</div>
    			</div>
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
			<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
			<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
 		</body>
 	</html>
	
	<script type='text/javascript'>
		function showHideTut() {
		var x = document.getElementById("videoTut");
		if (x.style.display === "none") {
			x.style.display = "block";
		} else {
			x.style.display = "none";
			y.style.display = "block";
		}
	}
	</script>
	
	<CFCATCH>
		
		<!--- <CFINCLUDE TEMPLATE="../_envoi_erreur.inc"> 
				<CFIF Session.langue EQ "fr">
					<CFLOCATION URL="#APPLICATION.Racine#/fr/erreur" ADDTOKEN="NO">
				<CFELSE>
					<CFLOCATION URL="#APPLICATION.Racine#/en/error" ADDTOKEN="NO">
				</CFIF> --->
	
	<cfoutput>
				#DateFormat(now(),"DD MMMM, YYYY")# #TimeFormat(now(),"(HH:MM:SS)")#<br>
				Une erreur est survenue sur DDR
				<BR>
				<CFIF isDefined('Session.utilisateur.prenom')>
				Utilisateur : #Session.utilisateur.prenom# #Session.utilisateur.nom# <BR>
				</CFIF>
				<cfif IsDefined('cfcatch')> Message : #cfcatch.Message#<BR></CFIF>
								
				<cfif IsDefined('cfcatch')><cfdump var="#cfcatch#" label="cfcatch"></cfif>
				<HR>
				<cfdump var="#Form#" label="Form Variables">
				<HR>
				<cfdump var="#URL#" label="URL Variables">
				<HR>
				<cfdump var="#session#" label="Session Variables">
			</cfoutput>
	</CFCATCH>
</CFTRY>