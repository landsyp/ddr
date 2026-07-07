<CFTRY>
	
	<CFSET VARIABLES.title_en = "DDR EMAILS LIST">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/bulk-emails-list/page-#URL.page#">
	<CFSET VARIABLES.title_fr = "DDR LISTE ENVOIS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/liste-des-envois/page-#URL.page#">
	
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	
	<cfset anneeCourante = DatePart("yyyy", Now())>
	
	<CFParam name="Session.anneeEnvoi" default="#anneeCourante#">

	<CFIF StructKeyExists(Form, 'filtre')>
		<cfset Session.anneeEnvoi = Form.anneeEnvoi>
	</CFIF>

	<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoisListe" returnvariable ="envoisListe">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="annee" value="#Session.anneeEnvoi#">
		</cfinvoke>

	<cfset envoisParPage = 50>
	<cfset premierEnvoi = ((URL.page-1)*envoisParPage)+1>
	<cfset nbrePages = Ceiling(arrayLen(envoisListe)/envoisParPage)>
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
									<strong>RAPPORTS D'ENVOIS COURRIEL GROUP&Eacute;S PAR ENVOI</strong>
									
								</div>
							</div>

							<div class="containerselectionneur">
	  							<cfoutput>#arrayLen(envoisListe)#</cfoutput> envois  courriel en masse de re&ccedil;us 
								
		 						<div class="w-form wrapperformulaire">
									<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST">
			  							<label class="labelselection" for="Annee">Ann&eacute;e :</label>
			  							<input class="w-input champselection" data-name="Annee" id="anneeEnvoi" maxlength="50" name="anneeEnvoi" value="<cfoutput>#Session.anneeEnvoi#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('L\'ann&eacute;e doit correspondre &agrave; une valeur num&eacute;rique')" onchange="try{setCustomValidity('')}catch(e){}">
			  							<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >
									</cfform>
		 						</div>
	  						</div><!--- <div class="containerselectionneur"> --->
	  						<div class="lignedetableau headertableau">
		 						<div class="itemligne itemdate"><strong>Date heure<br>envoi</strong></div>
								<div class="itemligne"><strong>Date d&eacute;but</strong></div>
								<div class="itemligne"><strong>Date fin </strong></div>
		 						<div class="itemligne"><strong>Courriels <br>non valides</strong></div>
		 						<div class="itemligne"><strong>En cours</strong></div>
		 						<div class="itemligne"><strong>Livrés</strong></div>
		 						<div class="itemligne"><strong>Erreurs de livraison</strong></div>
		 						<div class="itemligne"><strong>Spam</strong></div>
		 						<div class="itemligne"><strong>Total <br>envoy&eacute;s</strong></div>
								<div class="itemligne"><strong>Total dons livr&eacute;s *</strong></div>
	  						</div>
	  						<cfloop index="i" from=#premierEnvoi# to=#min(arrayLen(envoisListe), envoisParPage)#>
								<cfset envoi = envoisListe[i]>
								<div class="lignedetableau">
									<cfoutput>
										<CFQUERY NAME="RecusLivres" DATASOURCE="#APPLICATION.DSN#">
										SELECT SUM(montant) AS totalDons
										FROM envois
										WHERE 	organismeID = 	<CFQUERYPARAM VALUE="#Session.utilisateur.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
										AND 		envoiCode = 	<CFQUERYPARAM VALUE="#envoi.envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
										AND		statut	=	<CFQUERYPARAM VALUE="2-livre" CFSQLTYPE="CF_SQL_VARCHAR">
										</CFQUERY>

										<div class="itemligne itemdate"><a href="#APPLICATION.Racine#/fr/secure/info-sur-envoi-#envoi.envoiCode#/page-1">#left(envoi.envoiCode, 10)# #replace(mid(envoi.envoiCode, 12, 5), '-', ' h ')#</a></div> <!--- envoi.envoiCode is of format 'yyyy-mm-dd-HH-mm-ss' --->
										<div class="itemligne">#envoi.dateDebut#</div>
										<div class="itemligne">#envoi.dateFin#</div>
										<cfset nbCourrielInvalide = structKeyExists(envoi, '0-courriel-non-valide') ? envoi['0-courriel-non-valide'] : 0>
										<div class="itemligne">#nbCourrielInvalide#</div>
										<cfset nbEnCours = structKeyExists(envoi, '1-en-cours') ? envoi['1-en-cours'] : 0>
										<div class="itemligne">#nbEnCours#</div>
										<cfset nbLivres = structKeyExists(envoi, '2-livre') ? envoi['2-livre'] : 0>
										<div class="itemligne">#nbLivres#</div>
										<cfset nbRejetes = structKeyExists(envoi, '3-rejete') ? envoi['3-rejete'] : 0>
										<div class="itemligne">#nbRejetes#</div>
										<cfset nbSpam = structKeyExists(envoi, '4-spam') ? envoi['4-spam'] : 0>
										<div class="itemligne">#nbSpam#</div>
										<cfset nbTotal = nbCourrielInvalide + nbEnCours + nbLivres + nbRejetes + nbSpam>
										<div class="itemligne">#nbTotal#</div>
										<div class="itemligne"><cfif RecusLivres.totalDons NEQ "">#LSCurrencyFormat(RecusLivres.totalDons)#</CFIF></div>
									</cfoutput>
									
	  							</div>
	  						</cfloop>
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
									<strong>EMAIL REPORTS GROUPED BY DATE SENT</strong>
									
								</div>
							</div>
	  						<div class="containerselectionneur">
	  							<cfoutput>#arrayLen(envoisListe)#</cfoutput> bulk email receipts have been sent
		 						<div class="w-form wrapperformulaire">
									<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
			  							<label class="labelselection" for="Num-de-don">Year:</label>
			  							<input class="w-input champselection" data-name="Annee" id="anneeEnvoi" maxlength="50" name="anneeEnvoi" value="<cfoutput>#Session.anneeEnvoi#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('The Year should be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
			  							<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >
									</cfform>
		 						</div>
	  						</div><!--- <div class="containerselectionneur"> --->
	  						<div class="lignedetableau headertableau">
		 						<div class="itemligne itemdate"><strong>Date sent</strong></div>
		 						<div class="itemligne"><strong>Invalid Email</strong></div>
		 						<div class="itemligne"><strong>In Progress</strong></div>
		 						<div class="itemligne"><strong>Delivered</strong></div>
		 						<div class="itemligne"><strong>Rejected</strong></div>
		 						<div class="itemligne"><strong>Spam</strong></div>
		 						<div class="itemligne"><strong>Total Sent</strong></div>
								<div class="itemligne"><strong>Total gifts delivered *</strong></div>
		 						
	  						</div>
	  						<cfloop index="i" from=#premierEnvoi# to=#min(arrayLen(envoisListe), envoisParPage)#>
								<cfset envoi = envoisListe[i]>
	  							<div class="lignedetableau">
									<cfoutput>
										<CFQUERY NAME="RecusLivres" DATASOURCE="#APPLICATION.DSN#">
										SELECT SUM(montant) AS totalDons
										FROM 	envois
										WHERE 	organismeID = 	<CFQUERYPARAM VALUE="#Session.utilisateur.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
										AND		envoiCode = 	<CFQUERYPARAM VALUE="#envoi.envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
										AND		statut	=	<CFQUERYPARAM VALUE="2-livre" CFSQLTYPE="CF_SQL_VARCHAR">
										</CFQUERY>
										<div class="itemligne itemdate"><a href="#APPLICATION.Racine#/en/secure/bulk-emails-info-#envoi.envoiCode#/page-1">#left(envoi.envoiCode, 10)# #replace(mid(envoi.envoiCode, 12, 5), '-', ':')#</a></div> <!--- envoi.envoiCode is of format 'yyyy-mm-dd-HH-mm-ss' --->
										<cfset nbCourrielInvalide = structKeyExists(envoi, '0-courriel-non-valide') ? envoi['0-courriel-non-valide'] : 0>
										<div class="itemligne">#nbCourrielInvalide#</div>
										<cfset nbEnCours = structKeyExists(envoi, '1-en-cours') ? envoi['1-en-cours'] : 0>
										<div class="itemligne">#nbEnCours#</div>
										<cfset nbLivres = structKeyExists(envoi, '2-livre') ? envoi['2-livre'] : 0>
										<div class="itemligne">#nbLivres#</div>
										<cfset nbRejetes = structKeyExists(envoi, '3-rejete') ? envoi['3-rejete'] : 0>
										<div class="itemligne">#nbRejetes#</div>
										<cfset nbSpam = structKeyExists(envoi, '4-spam') ? envoi['4-spam'] : 0>
										<div class="itemligne">#nbSpam#</div>
										<cfset nbTotal = nbCourrielInvalide + nbEnCours + nbLivres + nbRejetes + nbSpam>
										<div class="itemligne">#nbTotal#</div>
										<div class="itemligne"><cfif RecusLivres.totalDons NEQ "">#LSCurrencyFormat(RecusLivres.totalDons)#</CFIF></div>
									</cfoutput>
								</div>
	  						</cfloop>
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