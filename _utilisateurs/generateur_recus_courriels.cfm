<cfsetting RequestTimeout = "600">
<CFTRY>

	<cfset newLocal = SetLocale("English (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR TAX RECEIPTS - BULK EMAIL SEND">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/receipts-email-generator">
	<CFSET VARIABLES.title_fr = "DDR REÇUS POUR FIN D'IMPÔT - ENVOI PAR COURRIEL">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/generateur-recus-courriels">

	<CFParam name="messageerreur" default="">
	<CFParam name="messagesucces" default="">
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="tousDonateurs">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
	</cfinvoke>
	<CFQUERY NAME="premier" dbtype="query">
		SELECT  Min(numero) as debut 
 		FROM tousDonateurs
	</CFQUERY>
	<CFQUERY NAME="dernier" dbtype="query">
		SELECT  Max(numero) as fin 
 		FROM tousDonateurs
	</CFQUERY>
	<cfset anneeDerniere=DateAdd("yyyy",-1, Now())>
	<cfset anneeDebut=DatePart("yyyy", anneeDerniere)>
	<CFPARAM name="dateDebut" default="#anneeDebut#-01-01">
	<CFPARAM name="dateFin" default="#anneeDebut#-12-31">
	<CFParam name="annee" default="#anneeDebut#">
	<CFParam name="donateurs" default="tous">
	<CFParam name="debut" default="#premier.debut#">
	<CFParam name="fin" default="#dernier.fin#">
	<CFParam name="messagecourriel" default="">
	
	
	<CFIF StructKeyExists(Form,'rapport')>
		<cfset annee=DatePart("yyyy", Form.dateDebut)>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>

		<!--- ON SUPPRIME LES ENVOIS "1-en-cours" QUI CORRESPONDENT À CETTE DEMANDE D'ENVOI --->
		<!--- INUTILE DE LES CONSERVER, ILS PORTENT À CONFUSION --->
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "SupprimerEnvoisEnCours" >
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="donateurs" value="#Form.donateurs#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusCourrielsDonateursDates" returnvariable ="ListeDonateurs">
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="donateurs" value="#Form.donateurs#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
		</cfinvoke>

		<!--- Vérifier s'il y a des courriels dans les donateurs récupérés --->
		<cfset nombreCourrielsDesDonateurs = listLen(valueList(ListeDonateurs.courriel))>
		
		<CFIF nombreCourrielsDesDonateurs EQ 0>
			<CFIF session.langue EQ "fr">
				<cfset messageerreur = "Impossibilité d'envoyer les reçus <br>puisqu'il n'y a aucun courriel inscrit selon les critères demandés (dates, donateurs).">
			<CFELSE>
				<cfset messageerreur = "We can't send the receipts <br>since no emails are registered according to the required criteria (dates, donors).">
			</CFIF>

		<CFELSE>

			<cfset envoitimestamp = dateFormat(now(), 'yyyy-mm-dd') & "-" & timeFormat(now(), 'HH-mm-ss')>

			<cfset envois = arrayNew(1)>
			<!--- Si le nombre de donateurs != le nombre de courriels des donateurs récupérés, c'est qu'il y a des donateurs sans adresse courriel --->
			<cfloop query="ListeDonateurs">
				<cfset envoiDonateur = {
					donateurID = ListeDonateurs.donateurID
					, prenom = ListeDonateurs.prenom
					, nom = ListeDonateurs.nom
					, courriel = ListeDonateurs.courriel
					, numero = ListeDonateurs.numero
					, adresse = ListeDonateurs.adresse
					, ville = ListeDonateurs.ville
					, province = ListeDonateurs.province
					, code_postal = ListeDonateurs.code_postal
				}>
				<cfset envoiDonateur.hasValidEmail = ListeDonateurs.courriel NEQ ''>
				<cfset arrayAppend(envois, envoiDonateur)>
			</cfloop>
			<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiAjout" returnvariable ="envoisDonateurs">
				<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
				<cfinvokeargument name="dateFin" value="#Form.dateFin#">
				<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
				<cfinvokeargument name="envoisDonateurs" value="#envois#">
				<cfinvokeargument name="envoiCode" value="#envoitimestamp#">
			</cfinvoke>

			<cfset messagecourriel=Form.messagecourriel>
			<CFINCLUDE TEMPLATE="generateur_recus_courriels_#organisme.devise#_#session.langue#.inc">

			<CFIF session.langue EQ "fr">
				<cfset messagesucces = "L'envoi des re&ccedil;us est en cours&nbsp;.<br/><a href='#APPLICATION.Racine#/fr/secure/info-sur-envoi-#envoitimestamp#/page-1'>Consultez les statistiques</a>.">
			<cfelse>
				<cfset messagesucces = "Receipts are being sent by email.<br/><a href='#APPLICATION.Racine#/en/secure/bulk-emails-info-#envoitimestamp#/page-1'>View the statistics</a>.">
			</cfif>
		</CFIF>
		
	</CFIF> 
	
	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			
			<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
			<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
			<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
			<!--- <script>
  				$( function() {
    				$( "#dateDebut" ).datepicker({ dateFormat: 'yy-mm-dd' });
    				$( "#dateFin" ).datepicker({ dateFormat: 'yy-mm-dd' });
  				} );
			</script> --->
			
			
			<CFIF session.langue EQ "en">
				<script>
					$( function() {
						$( "#dateDebut" ).datepicker({ dateFormat: 'yy-mm-dd' });
						$( "#dateFin" ).datepicker({ dateFormat: 'yy-mm-dd' });
					} );
				</script>
			<CFELSE>
				<script>
					$( function() {
						$("#dateDebut" ).datepicker({ 
						altField: "#datepicker",
						closeText: 'Fermer',
						prevText: 'Précédent',
						nextText: 'Suivant',
						currentText: 'Aujourd\'hui',
						monthNames: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
						monthNamesShort: ['Janv.', 'Févr.', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil.', 'Août', 'Sept.', 'Oct.', 'Nov.', 'Déc.'],
						dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
						dayNamesShort: ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'],
						dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
						weekHeader: 'Sem.',
						dateFormat: 'yy-mm-dd'
						});
						
						$( "#dateFin" ).datepicker({ 
						altField: "#datepicker",
						closeText: 'Fermer',
						prevText: 'Précédent',
						nextText: 'Suivant',
						currentText: 'Aujourd\'hui',
						monthNames: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
						monthNamesShort: ['Janv.', 'Févr.', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil.', 'Août', 'Sept.', 'Oct.', 'Nov.', 'Déc.'],
						dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
						dayNamesShort: ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'],
						dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
						weekHeader: 'Sem.',
						dateFormat: 'yy-mm-dd'
						});
					});
				</script>
				
			</CFIF>
			
			
			<style type="text/css">
				/* optional styles */
				#messagesucces {
					background-color:#EEEEEE; 
					border:1px solid #667295;
					color:red;
				}
			</style>

		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-generateur-recus.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
        				<div class="containertyperapport">
							<div class="titretyperapport">
								<CFIF session.langue EQ "fr">
									<strong>GÉNÉRATEUR DE REÇUS POUR FIN D'IMPÔT - ENVOI PAR COURRIEL</strong><BR>
									<!--- <span style="color:red;">VERSION D'ESSAI (BETA)</span><br> ---> 
									<span style="color:red;font-size:9pt;">*** Soyez avisé que tout envoi génère des reçus officiels acheminés aux donateurs ***</span>
								<CFELSE>
									<strong>GENERATOR OF INCOME TAX RECEIPTS - BULK EMAIL SEND</strong><BR>
									<!--- <span style="color:red;">BETA VERSION D'ESSAI </span><br> --->
									<span style="color:red;font-size:9pt;">*** Please be advised that all mailings generate official receipts that are sent to donors.  ***</span>
								</CFIF>
							</div>
        				</div>
        				<div class="w-form">
							<CFIF session.langue EQ "fr">
								<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_fr#" METHOD="POST">

								<cfif messageerreur NEQ "">
									<label class="labeldechamp" for="messageerreur" style="color:red;"><cfoutput>#messageerreur#</cfoutput></label>
								</cfif>
								<label class="labeldechamp" for="numdonateur">Dates</label>
								<div class="selectionperiode" style="background-color: #FFF;border-bottom: 1px solid rgba(55, 55, 55, 0.15);">
									<label class="labeldechamp" for="email">De&nbsp;&nbsp;&nbsp;</label>
									<div class="w-embed champtexte">
										<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}"/>
									</div>
									
									<label class="labeldechamp" for="email">&nbsp;&nbsp;À&nbsp;&nbsp;&nbsp;</label>
									<div class="w-embed champtexte">
										<input type="text" value="<cfoutput>#DateFormat(DateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}"/>
									</div>
								</div>
								<label class="labeldechamp" for="numdonateur">Donateurs</label>
								<div class="selectionneurdate">
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-selection-des-donateurs">
										<cfinput class="w-radio-input" data-ix="cacher-la-selection-des-donateurs" data-name="donateurs" id="donateurstous" name="donateurs" type="radio" value="tous" checked="#donateurs EQ 'tous'#">
										<label class="w-form-label" for="donateurstous">Tous</label>
										</div>
										<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-selection-de-donateurs">
										<cfinput class="w-radio-input" data-ix="montrer-la-selection-de-donateurs" data-name="donateurs" id="donateursselection" name="donateurs" type="radio" value="selection" checked="#donateurs EQ 'selection'#">
										<label class="w-form-label" for="donateursselection">Sélectionner les donateurs</label>
										</div>
									</div>
								</div> 
								<div class="blocradiobuttons">
									<div class="selectionnumdonateurs" data-ix="display-none-on-load-2">
										<label class="labeldechamp" for="Debut">De :</label>
										<input class="w-input champnumdonateur" data-name="Debut" id="debut" maxlength="256" name="debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>">
										<label class="labeldechamp" for="Fin">à :</label>
										<input class="w-input champnumdonateur" data-name="Fin" id="fin" maxlength="256" name="fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>">
									</div>
								</div>
								<div class="messageformatcourriel">
									<label class="labeldechamp" for="messagecourriel">Message accompagnant le courriel</label>
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
										<CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
										<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
									<CFELSE>
										<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/> 
									</CFIF>
									<!--- <textarea name="messagecourriel" id="messagecourriel" wrap="virtual" rows="5" cols="60" required pattern="^((\b[a-zA-Z]{2,40}\b)\s*){2,}$" oninvalid="setCustomValidity('Veuillez inscrire un message pour le(s) destinataire(s).')" onchange="try{setCustomValidity('')}catch(e){}"/></textarea> --->
								</div>
								<cfif messagesucces NEQ "">
									<label class="labeldechamp" for="messagesucces" id="messagesucces"><cfoutput>#messagesucces#</cfoutput></label>
								</cfif>
								<div class="blocchamp blocchamppleinelargeur">
									<input class="w-button boutonvalider" data-wait="Rapport en cours" name="rapport" type="submit" value="Générer les reçus et envoyer par courriel" wait="Rapport en cours" onclick="return confirm('Voulez-vous vraiment envoyer les re&ccedil;us par courriel ?');">
								</div>
								</cfform>
							<CFELSE>
							
								<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_en#" METHOD="POST">
								<cfif messageerreur NEQ "">
									<label class="labeldechamp" for="messageerreur" style="color:red;"><cfoutput>#messageerreur#</cfoutput></label>
								</cfif>
								
								<label class="labeldechamp" for="numdonateur">Dates</label>
								<div class="selectionperiode" style="background-color: #FFF;border-bottom: 1px solid rgba(55, 55, 55, 0.15);">
									<label class="labeldechamp" for="email">From&nbsp;&nbsp;&nbsp;</label>
									<div class="w-embed champtexte">
										<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="yyyy-mm-dd" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Please enter date using format yyyy-mm-dd')" onchange="try{setCustomValidity('')}catch(e){}"/>
									</div>
									
									<label class="labeldechamp" for="email">&nbsp;&nbsp;To&nbsp;&nbsp;&nbsp;</label>
									<div class="w-embed champtexte">
										<input type="text" value="<cfoutput>#DateFormat(DateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="yyyy-mm-dd" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Please enter date using format yyyy-mm-dd')" onchange="try{setCustomValidity('')}catch(e){}"/>
									</div>
								</div>						
								<label class="labeldechamp" for="numdonateur">Donors</label>
								<div class="selectionneurdate">
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-selection-des-donateurs">
										<cfinput class="w-radio-input" data-ix="cacher-la-selection-des-donateurs" data-name="donateurs" id="donateurstous" name="donateurs" type="radio" value="tous" checked="#donateurs EQ 'tous'#">
										<label class="w-form-label" for="donateurstous">All</label>
										</div>
										<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-selection-de-donateurs">
										<cfinput class="w-radio-input" data-ix="montrer-la-selection-de-donateurs" data-name="donateurs" id="donateursselection" name="donateurs" type="radio" value="selection" checked="#donateurs EQ 'selection'#">
										<label class="w-form-label" for="donateursselection">Select donors</label>
										</div>
									</div>
								</div>
								<div class="blocradiobuttons">
									<div class="selectionnumdonateurs" data-ix="display-none-on-load-2">
										<label class="labeldechamp" for="Debut">From</label>
										<input class="w-input champnumdonateur" data-name="Debut" id="debut" maxlength="256" name="debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>">
										<label class="labeldechamp" for="Fin">To</label>
										<input class="w-input champnumdonateur" data-name="Fin" id="fin" maxlength="256" name="fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>">
									</div>
								</div>
								<div class="messageformatcourriel">
									<label class="labeldechamp" for="messagecourriel">Message accompagnying the email</label>
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
										<CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
										<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
									<CFELSE>
										<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/> 
									</CFIF>
									<!--- <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300"  value="" richtext="yes" toolbar="Basic"/> --->
								</div>

								<cfif messagesucces NEQ "">
									<label class="labeldechamp" for="messagesucces" id="messagesucces"><cfoutput>#messagesucces#</cfoutput></label>
								</cfif>
								<div class="blocchamp blocchamppleinelargeur">
									<input class="w-button boutonvalider" data-wait="Please wait..." name="rapport" type="submit" value="Generate Receipts and Send by Email" wait="Please wait..." onclick="return confirm('Do you really want to send email receipts to the selected donors ?');>
								</div>
								</cfform>		
							</CFIF>
						</div>	
        			</div><!--- <div class="blocfondblanc"> --->
      			</div><!--- <div class="w-container containerprincipal">--->
    			
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<!--- <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script> --->
			<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
			<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
 		</body>
 	</html>
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