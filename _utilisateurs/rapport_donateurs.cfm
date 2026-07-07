<CFTRY>

	<cfset newLocal = SetLocale("French (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR DONORS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-donors">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT DONATEURS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-donateurs">
	
	<CFParam name="statut" default="tous">
	<CFParam name="tri" default="numero">
	<CFParam name="format" default="pdf">
	<CFParam name="confidentiel" default="False">
	<!--- <CFParam name="typeexport" default="pdf"> --->

	<CFIF isDefined('Form.rapport')>
	
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportDonateurs" returnvariable ="ListeDonateurs">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="statut" value="#Form.statut#">
			<cfinvokeargument name="tri" value="#Form.tri#">
		</cfinvoke>		
		
		<!--- <cfset typerapport=Form.typerapport> --->
		<cfset statut=Form.statut>
		<cfset tri=Form.tri>
		<cfset format=Form.format>
		<CFIF isDefined('Form.confidentiel')>
			<cfset confidentiel="True">
		<CFELSE>
			<cfset confidentiel="False">
		</CFIF>
		<!--- <cfset typeexport=Form.typeexport> --->
		
		<CFIF session.langue EQ "fr">
			<cfswitch expression="#statut#">
				<cfcase value="actif"><cfset TitreRapport="LISTE DES DONATEURS ACTIFS"></cfcase>
				<cfcase value="inactif"><cfset TitreRapport="LISTE DES DONATEURSS INACTIFS"></cfcase>
				<cfcase value="tous"><cfset TitreRapport="LISTE DE TOUS LES DONATEURS"></cfcase>
			</cfswitch>
		<cfelse>
			<cfswitch expression="#statut#">
				<cfcase value="actif"><cfset TitreRapport="DONORS' LIST (ACTIVE)"></cfcase>
				<cfcase value="inactif"><cfset TitreRapport="DONOR'S LIST (INACTIVE)"></cfcase>
				<cfcase value="tous"><cfset TitreRapport="DONOR'S LIST (ALL)"></cfcase>
			</cfswitch>
		</cfif>
		
		
		<CFIF format EQ "pdf">
		
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
								<TH CLASS="BlocEntete">Actif</TH>
								<TH CLASS="BlocEntete">Nom du donateur</TH>
								<TH CLASS="BlocEntete">Adresse</TH>
								<TH CLASS="BlocEntete">Ville</TH>
								<TH CLASS="BlocEntete">Prov.</TH>
								<TH CLASS="BlocEntete">C.P.</TH>
								<TH CLASS="BlocEntete">Tél. rés.</TH>
								<TH CLASS="BlocEntete">Tél. cell.</TH>
							</THEAD>
			
							
							<cfoutput query="ListeDonateurs" >
								<tr STYLE="line-height:20px;">
									<td valign="top">#numero#</td>
									<td valign="top"><CFIF actif>oui<cfelse>non</cfif></td>
									<td valign="top"><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
									<td valign="top">#adresse#</td>
									<td valign="top">#ville#</td>
									<td valign="top">#province#</td>
									<td valign="top">#code_postal#</td>
									<td valign="top">#tel_residence#</td>
									<td valign="top">#tel_cellulaire#</td>
								</tr>
							</CFOUTPUT>
	
						</table>
					<CFELSE>
						<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
							<THEAD >
								<TH CLASS="BlocEntete" >#&nbsp;</TH>
								<TH CLASS="BlocEntete">Active</TH>
								<TH CLASS="BlocEntete">Name</TH>
								<TH CLASS="BlocEntete">Address</TH>
								<TH CLASS="BlocEntete">City</TH>
								<TH CLASS="BlocEntete">Prov.</TH>
								<TH CLASS="BlocEntete">P.C.</TH>
								<TH CLASS="BlocEntete">Home Phone</TH>
								<TH CLASS="BlocEntete">Cell Phone</TH>
							</THEAD>
			
							<cfoutput query="ListeDonateurs" >
								<tr STYLE="line-height:20px;">
									<td  valign="top">#numero#</td>
									<td  valign="top"><CFIF actif>yes<cfelse>no</cfif></td>
									<td valign="top"><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
									<td  valign="top">#adresse#</td>
									<td valign="top">#ville#</td>
									<td valign="top">#province#</td>
									<td valign="top">#code_postal#</td>
									<td valign="top">#tel_residence#</td>
									<td valign="top">#tel_cellulaire#</td>
								</tr>
							</CFOUTPUT>
	
						</table>
					</CFIF>
				</cfdocumentsection>
			
			</cfdocument>
		<CFELSE>
			<cfheader name="Content-Disposition" value="inline; filename=donateurs.xls"> 
			<cfcontent type="application/msexcel; charset=windows-1252">
			<html xmlns:o="urn:schemas-microsoft-com:office:office"
    			xmlns:x="urn:schemas-microsoft-com:office:excel"
    			xmlns="http://www.w3.org/TR/REC-html40">
			<body>
				<CFIF session.langue EQ "fr">
					<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
						<THEAD >
							<TH CLASS="BlocEntete" >#&nbsp;</TH>
							<TH CLASS="BlocEntete">Actif</TH>
							<TH CLASS="BlocEntete">Nom du donateur</TH>
							<TH CLASS="BlocEntete">Adresse</TH>
							<TH CLASS="BlocEntete">Ville</TH>
							<TH CLASS="BlocEntete">Prov.</TH>
							<TH CLASS="BlocEntete">C.P.</TH>
							<TH CLASS="BlocEntete">Courriel</TH>
							<TH CLASS="BlocEntete">Tél. rés.</TH>
							<TH CLASS="BlocEntete">Tél. cell.</TH>
							<TH CLASS="BlocEntete">Notes</TH>
						</THEAD>
			
							
						<cfoutput query="ListeDonateurs" >
							<tr STYLE="line-height:20px;">
								<td >#numero#</td>
								<td ><CFIF actif>oui<cfelse>non</cfif></td>
								<td><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
								<td >#adresse#</td>
								<td >#ville#</td>
								<td >#province#</td>
								<td>#code_postal#</td>
								<td>#courriel#</td>
								<td >#tel_residence#</td>
								<td >#tel_cellulaire#</td>
								<td >#notes#</td>
							</tr>
						</CFOUTPUT>
	
					</table>
				<CFELSE>
					<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
						<THEAD >
							<TH CLASS="BlocEntete" >#&nbsp;</TH>
							<TH CLASS="BlocEntete">Active</TH>
							<TH CLASS="BlocEntete">Name</TH>
							<TH CLASS="BlocEntete">Address</TH>
							<TH CLASS="BlocEntete">City</TH>
							<TH CLASS="BlocEntete">Prov.</TH>
							<TH CLASS="BlocEntete">P.C.</TH>
							<TH CLASS="BlocEntete">Email</TH>
							<TH CLASS="BlocEntete">Home Phone</TH>
							<TH CLASS="BlocEntete">Cell Phone</TH>
							<TH CLASS="BlocEntete">Notes</TH>
						</THEAD>
			
						<cfoutput query="ListeDonateurs" >
							<tr STYLE="line-height:20px;">
								<td >#numero#</td>
								<td ><CFIF actif>yes<cfelse>no</cfif></td>
								<td><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
								<td >#adresse#</td>
								<td >#ville#</td>
								<td >#province#</td>
								<td>#code_postal#</td>
								<td>#courriel#</td>
								<td >#tel_residence#</td>
								<td >#tel_cellulaire#</td>
								<td >#notes#</td>
							</tr>
						</CFOUTPUT>
	
					</table>
				</CFIF>
			</body>
			</html>
		</CFIF>
	<CFELSE>
	
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
	
				<div class="w-section sectioncontenuprincipal">
			
					<CFINCLUDE TEMPLATe="_sous-menu-rapports.inc">
				
					<div class="w-container containerprincipal">
						<div class="blocfondblanc">
							<div class="containertyperapport">
								<div class="titretyperapport">
									<CFIF session.langue EQ "fr">
										<strong>RAPPORT DE DONATEURS</strong>
									<CFELSE>
										<strong>DONORS' REPORT</strong>
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
											<label class="labeldechamp" for="numdonateur">Statut des donateurs</label>
											<div class="containerradiobuttons">
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="actif" checked="#statut EQ 'actif'#">
													<label class="w-form-label" for="grouperpardate">Actif</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="inactif" checked="#statut EQ 'inactif'#">
													<label class="w-form-label" for="grouperparcompte">Inactif</label>
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
													<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="numero" checked="#tri EQ 'numero'#">
													<label class="w-form-label" for="numdonateur"># de donateur</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
													<label class="w-form-label" for="nomprenom">Nom, prénom</label>
												</div>
											</div>
										</div>
										<div class="blocradiobuttons">
											<label class="labeldechamp" for="numdonateur">Format</label>
											<div class="containerradiobuttons">
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="format" id="format" name="format" type="radio" value="pdf" checked="#format EQ 'pdf'#">
													<label class="w-form-label" for="numdonateur">PDF</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="format" id="format" name="format" type="radio" value="excel" checked="#format EQ 'excel'#">
													<label class="w-form-label" for="nomprenom">EXCEL (incluant courriels)</label>
												</div>
											</div>
										</div>
								
										<div class="bloccheckbox">
											<div class="w-checkbox w-clearfix">
												<cfinput class="w-checkbox-input" data-name="confidentiel" id="confidentiel" name="confidentiel" checked="#confidentiel EQ 'True'#" type="checkbox">
												<label class="w-form-label petittextegris" for="Confidentialt">Cacher le nom des donateurs</label>
											</div>
										</div>
										<div class="blocchamp blocchamppleinelargeur">
										<cfinput class="w-button boutonvalider" data-wait="Préparation du rapport en cours" name="rapport" type="submit" formtarget="_blank" value="Générer le rapport" wait="Préparation du rapport en cours">
										</div>
									</CFFORM>
								<CFELSE>
									<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_en#" METHOD="POST">
										<div class="blocradiobuttons">
											<label class="labeldechamp" for="numdonateur">Status of the donor</label>
											<div class="containerradiobuttons">
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="actif" checked="#statut EQ 'actif'#">
													<label class="w-form-label" for="grouperpardate">Active</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="statut" id="statut" name="statut" type="radio" value="inactif" checked="#statut EQ 'inactif'#">
													<label class="w-form-label" for="grouperparcompte">Inactive</label>
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
													<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="numero" checked="#tri EQ 'numero'#">
													<label class="w-form-label" for="numdonateur">Donor number</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="tri" id="tri" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
													<label class="w-form-label" for="nomprenom">Last Name, First Name</label>
												</div>
											</div>
										</div>
										
										<div class="blocradiobuttons">
											<label class="labeldechamp" for="numdonateur">Format</label>
											<div class="containerradiobuttons">
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="format" id="format" name="format" type="radio" value="pdf" checked="#format EQ 'pdf'#">
													<label class="w-form-label" for="numdonateur">PDF</label>
												</div>
												<div class="w-radio champradiobutton">
													<cfinput class="w-radio-input" data-name="format" id="format" name="format" type="radio" value="excel" checked="#format EQ 'excel'#">
													<label class="w-form-label" for="nomprenom">EXCEL (including emails)</label>
												</div>
											</div>
										</div>
								
										<div class="bloccheckbox">
											<div class="w-checkbox w-clearfix">
												<cfinput class="w-checkbox-input" data-name="confidentiel" id="confidentiel" name="confidentiel" checked="#confidentiel EQ 'True'#" type="checkbox">
												<label class="w-form-label petittextegris" for="Confidentialt">Hide the donor's number</label>
											</div>
										</div>
										<!--- <div class="blocradiobuttons">
													<div class="containerradiobuttons">
														<div class="w-radio w-clearfix champradiobutton">
															<input class="w-radio-input" data-name="typeexport" id="pdf" name="typeexport" type="radio" value="pdf">
															<label class="w-form-label petittextegris" for="pdf">Export PDF</label>
														</div>
														<div class="w-radio w-clearfix champradiobutton">
															<input class="w-radio-input" data-name="typeexport" id="excel" name="typeexport" type="radio" value="excel">
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
		
 	</CFIF>
	<CFCATCH>
		
		<CFINCLUDE TEMPLATE="../_envoi_erreur.inc"> 
		<CFIF Session.langue EQ "fr">
			<CFLOCATION URL="#APPLICATION.Racine#/fr/erreur" ADDTOKEN="NO">
		<CFELSE>
			<CFLOCATION URL="#APPLICATION.Racine#/en/error" ADDTOKEN="NO">
		</CFIF>
	
	<!--- <cfoutput>
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
			</cfoutput> --->
	</CFCATCH>
</CFTRY>