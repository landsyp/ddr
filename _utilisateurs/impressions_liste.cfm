<CFTRY>
	
	<CFSET VARIABLES.title_en = "DDR PRINTING LIST">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/pdf-printing-list/page-#URL.page#">
	<CFSET VARIABLES.title_fr = "DDR LISTE IMPRESSIONS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/liste-impressions-pdf/page-#URL.page#">
	
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	
	<cfset anneeCourante = DatePart("yyyy", Now())>
	
	<CFParam name="Session.anneeImpression" default="#anneeCourante#">
	
	<CFIF StructKeyExists(Form, 'filtre')>
		<cfset Session.anneeImpression = Form.anneeImpression>
	</CFIF>
	
	<!--- <cfinvoke component="#APPLICATION.cfcRecus#" method = "recusListe" returnvariable ="recusListe">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="annee" value="#Session.anneeImpression#">
	</cfinvoke> --->
	
	<cfinvoke component="#APPLICATION.cfcRecus#" method = "impressionsListe" returnvariable ="impressionsListe">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="annee" value="#Session.anneeImpression#">
	</cfinvoke>
	

	<cfset impressionsParPage = 50>
	<cfset premiereImpression = ((URL.page-1)*impressionsParPage)+1>
	<cfset nbrePages = Ceiling(impressionsListe.recordcount/impressionsParPage)>
	
	<!--- <cfoutput>#nbrePages#</cfoutput> --->

	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body>
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
			<div class="w-section sectioncontenuprincipal">
			
  				<CFINCLUDE TEMPLATe="_sous-menu-generateur-recus.inc">

				<CFIF session.langue EQ "fr">
					<div class="w-container containerprincipal">
						<div class="blockfondblancpageinterne">
							<div class="containertyperapport">
								<div class="titretyperapport">
									<strong>RAPPORTS DES IMPRESSIONS</strong>
									<BR>
								</div>
							</div>
							<div class="containerselectionneur">
	  							<cfoutput>#impressionsListe.recordcount#</cfoutput> productions de  re&ccedil;us format pdf   
								
		 						<div class="w-form wrapperformulaire">
									<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST">
			  							<label class="labelselection" for="Annee">Ann&eacute;e :</label>
			  							<input class="w-input champselection" data-name="Annee" id="anneeImpression" maxlength="50" name="anneeImpression" value="<cfoutput>#Session.anneeImpression#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('L\'ann&eacute;e doit correspondre &agrave; une valeur num&eacute;rique')" onchange="try{setCustomValidity('')}catch(e){}">
			  							<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >
									</cfform>
		 						</div>
	  						</div><!--- <div class="containerselectionneur"> --->
	  						<div class="lignedetableau headertableau">
		 						<div class="itemligne itemdate"><strong>Date cr&eacute;ation</strong></div>
		 						<div class="itemligne"><strong>Date d&eacute;but</strong></div>
		 						<div class="itemligne"><strong>Date fin</strong></div>
		 						<div class="itemligne"><strong>Total donateurs</strong></div>
								<div class="itemligne"><strong>Total dons </strong></div>
	  						</div>
							<cfoutput query="impressionsListe" group="DateCreation">
								<div class="lignedetableau">
									<cfoutput>
										<CFQUERY NAME="RecusImprimes" DATASOURCE="#APPLICATION.DSN#">
										SELECT SUM(montant) AS totalDons, COUNT(*) AS totalDonateurs
										FROM 	recus
										WHERE 	dateCreation = 	<CFQUERYPARAM VALUE="#dateCreation#" CFSQLTYPE="CF_SQL_VARCHAR">
										AND		organismeID = 	<CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
										</CFQUERY>
										<!--- <div class="itemligne  itemdate""><a href="#APPLICATION.Racine#/fr/secure/info-sur-impression-#dateCreation#/page-1">#DateFormat(dateCreation, "yyyy-mm-dd")# #timeFormat(dateCreation, "HH:mm:ss")#</a></div> --->
										<div class="itemligne  itemdate"">#DateFormat(dateCreation, "yyyy-mm-dd")# #timeFormat(dateCreation, "HH:mm:ss")#</div>
										<div class="itemligne">#DateFormat(dateDebut, "yyyy-mm-dd")#</div>
										<div class="itemligne">#DateFormat(dateFin, "yyyy-mm-dd")#</div>
										<div class="itemligne">#RecusImprimes.totalDonateurs#</div>
										<div class="itemligne"><cfif RecusImprimes.totalDons NEQ "">#LSCurrencyFormat(RecusImprimes.totalDons)#</CFIF></div>
									</cfoutput>
	  							</div>
	  						</cfoutput>
							<span style="font-size:10pt;">* Le total des dons appara&icirc;t seulement pour les envois effectu&eacute;s apr&egrave;s le 4 mars 2020</span>
	  						<div class="blockpagination">
	  							<cfloop index="page" from="1" to="#nbrePages#">
		 						<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-envois/page-<cfoutput>#page#</cfoutput>">
									<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
		 						</a>
		 						</cfloop>
	  						</div>
						</div>
 					</div><!--- <div class="w-container containerprincipal"> --->
 				<CFELSE>
 					<div class="w-container containerprincipal">
						<div class="blockfondblancpageinterne">
							<div class="containertyperapport">
								<div class="titretyperapport">
									<strong>EMAIL REPORTS</strong>
									<BR>(BETA VERSION)
								</div>
							</div>
	  						<div class="containerselectionneur">
	  							<cfoutput>#impressionsListe.recordcount#</cfoutput> receipt bulk email mailings have been sent
		 						<div class="w-form wrapperformulaire">
									<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
			  							<label class="labelselection" for="Num-de-don">Year:</label>
			  							<input class="w-input champselection" data-name="Annee" id="anneeImpression" maxlength="50" name="anneeImpression" value="<cfoutput>#Session.anneeImpression#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('The Year should be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
			  							<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >
									</cfform>
		 						</div>
	  						</div><!--- <div class="containerselectionneur"> --->
	  						<div class="lignedetableau headertableau">
		 						<div class="itemligne itemdate"><strong>Date produced</strong></div>
		 						<div class="itemligne"><strong>Starting Date</strong></div>
		 						<div class="itemligne"><strong>End Date</strong></div>
		 						<div class="itemligne"><strong>Total donors</strong></div>
		 						<div class="itemligne"><strong>Total gifts</strong></div>
	  						</div>
	  						<cfoutput query="impressionsListe" group="DateCreation">
								<div class="lignedetableau">
									<cfoutput>
										<CFQUERY NAME="RecusImprimes" DATASOURCE="#APPLICATION.DSN#">
										SELECT SUM(montant) AS totalDons, COUNT(*) AS totalDonateurs
										FROM 	recus
										WHERE 	dateCreation = 	<CFQUERYPARAM VALUE="#dateCreation#" CFSQLTYPE="CF_SQL_VARCHAR">
										AND		organismeID = 	<CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
										</CFQUERY>
										<!--- <div class="itemligne  itemdate""><a href="#APPLICATION.Racine#/fr/secure/info-sur-impression-#dateCreation#/page-1">#DateFormat(dateCreation, "yyyy-mm-dd")# #timeFormat(dateCreation, "HH:mm:ss")#</a></div> --->
										<div class="itemligne  itemdate"">#DateFormat(dateCreation, "yyyy-mm-dd")# #timeFormat(dateCreation, "HH:mm:ss")#</div>
										<div class="itemligne">#DateFormat(dateDebut, "yyyy-mm-dd")#</div>
										<div class="itemligne">#DateFormat(dateFin, "yyyy-mm-dd")#</div>
										<div class="itemligne">#RecusImprimes.totalDonateurs#</div>
										<div class="itemligne"><cfif RecusImprimes.totalDons NEQ "">#LSCurrencyFormat(RecusImprimes.totalDons)#</CFIF></div>
									</cfoutput>
	  							</div>
	  						</cfoutput>
							<span style="font-size:10pt;">* Total of gifts delivered appears only for emailings after March 4, 2020</span>
	  						<div class="blockpagination">
	  							<cfloop index="page" from="1" to="#nbrePages#">
		 						<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/bulk-emails-list/page-<cfoutput>#page#</cfoutput>">
									<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
		 						</a>
		 						</cfloop>
	  						</div>
						</div>
 					</div><!--- <div class="w-container containerprincipal"> --->
 				</CFIF>
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
			<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
			<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
		</body>
	</html>
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