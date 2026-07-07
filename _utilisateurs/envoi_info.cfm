<CFTRY>
    <CFParam name="URL.envoiCode" default="">

    <CFSET VARIABLES.title_en = "DDR INFO ON EMAILS SENT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/bulk-emails-info-#URL.envoiCode#">
	<CFSET VARIABLES.title_fr = "DDR INFO SUR ENVOI">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/info-sur-envoi-#URL.envoiCode#">

	<CFParam name="URL.page" default="1">
	<CFParam name="messageerreur" default="">
	<CFParam name="messagesucces" default="">
	
	
	<CFIF isDefined('URL.tri')>
		<cfset Session.tri = URL.tri>
	<CFELSE>
		<cfset Session.tri = "statutA">
	</CFIF>
	
	<CFIF StructKeyExists(Form,'renvoi')>
	
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiRecuInfo" returnvariable ="envoiOriginal">
			<cfinvokeargument name="envoiID" value="#Form.envoiID#">
		</cfinvoke>
		
		<cfset annee=DatePart("yyyy", envoiOriginal.dateDebut)>
		
		<CFIF envoiOriginal.courriel EQ "">
			<CFIF session.langue EQ "fr">
				<cfset messageerreur = "Impossibilité d'envoyer le reçu puisqu'il n'y a aucun courriel inscrit pour ce donateur.">
			<CFELSE>
				<cfset messageerreur = "Unable to send the receipt since there is no email registered for this donor.">
			</CFIF>

		<CFELSE>

			<cfset envoitimestamp = dateFormat(now(), 'yyyy-mm-dd') & "-" & timeFormat(now(), 'HH-mm-ss')>
 
			<!--- NOUVEL ENVOI  --->
			<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "renvoiAjout" returnvariable ="neoEnvoiID">
				<cfinvokeargument name="envoiIDOrigine" value="#envoiOriginal.envoiID#">
				<cfinvokeargument name="dateDebut" value="#envoiOriginal.dateDebut#">
				<cfinvokeargument name="dateFin" value="#envoiOriginal.dateFin#">
				<cfinvokeargument name="donateurID" value="#envoiOriginal.donateurID#">
				<cfinvokeargument name="envoiCode" value="#envoitimestamp#">
				<cfinvokeargument name="montant" value="#envoiOriginal.montant#">
				<cfinvokeargument name="noRecu" value="#envoiOriginal.noRecu#">
				<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			</cfinvoke>
			
			<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiRecuInfo" returnvariable ="renvoiInfo">
				<cfinvokeargument name="envoiID" value="#neoEnvoiID#">
			</cfinvoke>
			<!--- <CFIF session.langue EQ "fr">
				<cfset messagecourriel = "<p>Voici un autre envoi courriel de votre re&ccedil;u pour fins d'imp&ocirc;t no #envoiOriginal.NoRecu# pour vos dons à l'organisme <b>#Session.utilisateur.organisme#</b></p><p>Merci de votre support !</p>">
			<CFELSE>
				<cfset messagecourriel = "<p>Here is another email of your tax receipt #envoiOriginal.NoRecu# for your donations to <b>#Session.utilisateur.organisme#</b></p><p>Thanks for your support!</p>">
			</CFIF> --->
			<cfset messagecourriel=Form.messagecourriel> 
			<CFINCLUDE TEMPLATE="generateur_renvoi_courriel_#organisme.devise#_#session.langue#.inc">

			<CFIF session.langue EQ "fr">
				<cfset messagesucces = "L'envoi du re&ccedil;u est en cours&nbsp;.<a href='#APPLICATION.Racine#/fr/secure/info-sur-envoi-#envoitimestamp#/page-1'>Consultez le statut de l'envoi</a>.">
			<cfelse>
				<cfset messagesucces = "Receipt is being sent by email. <a href='#APPLICATION.Racine#/en/secure/bulk-emails-info-#envoitimestamp#/page-1'>Check the status of the email</a>.">
			</cfif>
		</CFIF>
		
	</CFIF> 
	
	
	<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiInfo" returnvariable ="envoiInfo">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="envoiCode" value="#URL.envoiCode#">
		<cfinvokeargument name="tri" value="#Session.tri#">
	</cfinvoke>
	
	
	<!--- POUR LE RENVOI D'UN RECU DEJA ENVOYE PAR COURRIEL --->
	<CFIF StructKeyExists(Form,'EnvoiDeNouveau')>
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcenvoiRecus#" method = "envoiRecuInfo" returnvariable ="envoiRecuInfo">
			<cfinvokeargument name="envoiID" value="#Form.envoiID#">
		</cfinvoke>
		
		<CFIF envoiRecuInfo.courriel NEQ "">
			<cfset envoitimestamp = dateFormat(now(), 'yyyy-mm-dd') & "-" & timeFormat(now(), 'HH-mm-ss')>
		
			<cfinvoke component="#APPLICATION.cfcenvoiRecus#" method = "renvoiAjout" >
				<cfinvokeargument name="envoiID" value="#Form.envoiID#">
			</cfinvoke>
			
			<CFINCLUDE TEMPLATE="generateur_renvoi_courriel_#organisme.devise#_#session.langue#.inc">

			<CFIF session.langue EQ "fr">
				<cfset messagesucces = "L'envoi du re&ccedil;u est en cours&nbsp;.<br/><a href='#APPLICATION.Racine#/fr/secure/info-sur-envoi-#envoitimestamp#/page-1'>Consultez les statistiques</a>.">
			<cfelse>
				<cfset messagesucces = "Receipt is being sent by email.<br/><a href='#APPLICATION.Racine#/en/secure/bulk-emails-info-#envoitimestamp#/page-1'>View the statistics</a>.">
			</cfif>
		<CFELSE>
			<CFIF session.langue EQ "fr">
				<cfset messageerreur = "Impossibilité d'envoyer le reçu <br>puisqu'il n'y a aucun courriel inscrit pour ce donateur.">
			<CFELSE>
				<cfset messageerreur = "We can't send the receipt <br>since there is no email registered to this donor.">
			</CFIF>
		</CFIF>
	</CFIF>
	

	<cfset donateursParPage = 50>
	<cfset premierDonateur = ((URL.page-1)*donateursParPage)+1>
	<cfset nbrePages = Ceiling(envoiInfo.recordcount/donateursParPage)>

	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			<script>
				function blocking(nr)
				{
					if (document.layers)
					{
						current = (document.layers[nr].display == 'none') ? 'block' : 'none';
						document.layers[nr].display = current;
					}
					else if (document.all)
					{
						current = (document.all[nr].style.display == 'none') ? 'block' : 'none';
						document.all[nr].style.display = current;
					}
					else if (document.getElementById)
					{
						vista = (document.getElementById(nr).style.display == 'none') ? 'block' : 'none';
						document.getElementById(nr).style.display = vista;
					}
				}
			</script>
		</head>

		<body>
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
			<div class="w-section sectioncontenuprincipal">
			
  				<CFINCLUDE TEMPLATe="_sous-menu-generateur-recus.inc">

				<CFIF session.langue EQ "fr">
					<cfset statutLabels = {
						"0-courriel-non-valide" = "Courriel vide ou non valide"
						, "1-en-cours" = "En cours d'envoi"
						, "2-livre" = "Livré"
						, "3-rejete" = "Erreur de livraison (bounce)"
						, "4-spam" = "Identifié comme spam"
					}>
					<div class="w-container containerprincipal">
						<div class="blockfondblancpageinterne">
							<div class="containertyperapport">
								<div class="titretyperapport">
									<strong>RAPPORT D'ENVOI PAR COURRIEL</strong>
								</div>
							</div>
							<div class="containerselectionneur">
								<cfoutput>Envoi fait le #left(URL.envoiCode, 10)# #replace(mid(URL.envoiCode, 12, 5), '-', ' h ')#</cfoutput> <!--- URL.envoiCode is of format 'yyyy-mm-dd-HH-mm-ss' --->
								<br/><cfoutput>#envoiInfo.recordCount#</cfoutput> donateurs dans l'envoi de re&ccedil;us courriel
							</div><!--- <div class="containerselectionneur"> --->
							<div style="font-size:10pt;color:red;">
								<cfif messagesucces NEQ ""><cfoutput>#messagesucces#</cfoutput></CFIF>
								<cfif messageerreur NEQ ""><cfoutput>#messageerreur#</cfoutput></CFIF>
							</div>
							<div class="lignedetableau headertableau">
								<div class="itemligne" STYLE="display:inline;"><strong>No. donateur</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"><strong>No. re&ccedil;u</strong></div>
								<div class="itemligne"><strong>Nom, Pr&eacute;nom</strong> <a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"><strong>Courriel</strong></div>
								<div class="itemligne"><strong>Statut</strong> <a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"></div>
							</div>
							<cfoutput query="envoiInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
								<div class="lignedetableau">
									<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#envoiInfo.donateurID#">## #envoiInfo.numero#</a></div>
									<div class="itemligne"><CFIF structKeyExists(statutLabels, envoiInfo.statut) AND envoiInfo.statut EQ "2-livre">e-#envoiInfo.noRecu#</CFIF></div>
									<div class="itemligne">#envoiInfo.nom#<CFIF envoiInfo.prenom NEQ "">, #envoiInfo.prenom#</CFIF></div>
									<div class="itemligne"><CFIF envoiInfo.courriel NEQ "">#envoiInfo.courriel#</CFIF></div>
									<div class="itemligne">#(structKeyExists(statutLabels, envoiInfo.statut)) ? statutLabels[envoiInfo.statut]: envoiInfo.statut#</div>
									<div class="itemligne">
										<CFIF structKeyExists(statutLabels, envoiInfo.statut) AND envoiInfo.statut EQ "2-livre" AND envoiInfo.envoiIDOrigine EQ ""  AND envoiInfo.DateDebut NEQ "">
											<!--- <cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST">
												<input type="hidden" name="envoiID" id="envoiID" value="#envoiInfo.envoiID#"> 
												<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Renvoyer" name="renvoi" >
											</cfform> --->
											<a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Envoyer de nouveau</a>
											
											<div class="modalwrapper" id="message-#envoiID#" style="display:none;">
												<div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Fermer X</a>
													<p style="font-size:12pt;">Message accompagnant l'envoi du re&ccedil;u e-#envoiInfo.noRecu# au donateur <CFIF envoiInfo.prenom NEQ "">#envoiInfo.prenom#</CFIF> #envoiInfo.nom#</p>
													<div class="w-form">
														<cfform action="#file_name_fr#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
															<input type="hidden" name="envoiID" id="envoiID" value="#envoiInfo.envoiID#"> 
															<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/> 
															<!--- <input autofocus="autofocus" class="blocchamp motdepassecourriel w-input" data-name="Courriel" id="Courriel" maxlength="256" name="Courriel" required="" type="email" pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{1,63}$" oninvalid="setCustomValidity('Veuillez entrer une adresse courriel valide.')" onchange="try{setCustomValidity('')}catch(e){}"> --->
															
															<input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Veuillez patienter">
														</cfform>
													</div>
												</div>
											</div>
										<CFELSEIF envoiInfo.envoiIDOrigine NEQ "">
											Renvoi du re&ccedil;u  e-#envoiInfo.NoRecu#
										</CFIF>
									</div>
								</div>
							</cfoutput>

							<div class="blockpagination">
								<cfloop index="page" from="1" to="#nbrePages#">
								<a class="w-inline-block blocklienpagination" href="<cfoutput>#file_name_fr#</cfoutput>/page-<cfoutput>#page#</cfoutput>">
									<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
								</a>
								</cfloop>
							</div>
						</div>
					</div><!--- <div class="w-container containerprincipal"> --->
				<CFELSE>
					<cfset statutLabels = {
						"0-courriel-non-valide" = "Email is empty or not valid"
						, "1-en-cours" = "Being sent"
						, "2-livre" = "Delivered"
						, "3-rejete" = "Bounced"
						, "4-spam" = "Identified as spam"
					}>
					<div class="w-container containerprincipal">
						<div class="blockfondblancpageinterne">
							<div class="containertyperapport">
								<div class="titretyperapport">
									<strong>EMAIL REPORT</strong>
								</div>
							</div>
							<div class="containerselectionneur">
								Emails sent on <cfoutput>#left(URL.envoiCode, 10)# #replace(mid(URL.envoiCode, 12, 5), '-', ':')#</cfoutput> <!--- URL.envoiCode is of format 'yyyy-mm-dd-HH-mm-ss' --->
								<br/><cfoutput>#envoiInfo.recordCount#</cfoutput> donors in the emails sent
							</div><!--- <div class="containerselectionneur"> --->
							<div style="font-size:10pt;color:red;">
								<cfif messagesucces NEQ ""><cfoutput>#messagesucces#</cfoutput></CFIF>
								<cfif messageerreur NEQ ""><cfoutput>#messageerreur#</cfoutput></CFIF>
							</div>
							<div class="lignedetableau headertableau">
								<div class="itemligne" STYLE="display:inline;"><strong>Donor #</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"><strong>Receipt #</strong></div>
								<div class="itemligne"><strong>Name</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"><strong>Email</strong></div>
								<div class="itemligne"><strong>Status</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								<div class="itemligne"></div>
							</div>
							<cfoutput query="envoiInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
								<div class="lignedetableau">
									<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-donor-#envoiInfo.donateurID#">## #envoiInfo.numero#</a></div>
									<div class="itemligne"><CFIF structKeyExists(statutLabels, envoiInfo.statut) AND envoiInfo.statut EQ "2-livre">e-#envoiInfo.noRecu#</CFIF></div>
									<div class="itemligne">
										#envoiInfo.nom#<CFIF prenom NEQ "">, #envoiInfo.prenom#</CFIF>
									</div>
									<div class="itemligne">
										<CFIF envoiInfo.courriel NEQ "">#envoiInfo.courriel#</CFIF>
									</div>
									<div class="itemligne">#(structKeyExists(statutLabels, envoiInfo.statut)) ? statutLabels[envoiInfo.statut]: envoiInfo.statut#</div>
									<div class="itemligne">
										<CFIF structKeyExists(statutLabels, envoiInfo.statut) AND envoiInfo.statut EQ "2-livre" AND envoiInfo.envoiIDOrigine EQ ""  AND envoiInfo.DateDebut NEQ "">
											<!--- <cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
												<input type="hidden" name="envoiID" id="envoiID" value="#envoiInfo.envoiID#"> 
												<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Resend" name="renvoi" >
											</cfform> --->
											<a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Resend</a>
											
											<div class="modalwrapper" id="message-#envoiID#" style="display:none;">
												<div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Close X</a>
													<p style="font-size:12pt;">Message accompanying the sending of receipt e-#envoiInfo.noRecu# to donor <CFIF envoiInfo.prenom NEQ "">#envoiInfo.prenom#</CFIF> #envoiInfo.nom#</p>
													<div class="w-form">
														<cfform action="#file_name_en#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
															<input type="hidden" name="envoiID" id="envoiID" value="#envoiInfo.envoiID#"> 
															<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/> 
															<!--- <input autofocus="autofocus" class="blocchamp motdepassecourriel w-input" data-name="Courriel" id="Courriel" maxlength="256" name="Courriel" required="" type="email" pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{1,63}$" oninvalid="setCustomValidity('Veuillez entrer une adresse courriel valide.')" onchange="try{setCustomValidity('')}catch(e){}"> --->
															
															<input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Send" wait="Please wait">
														</cfform>
													</div>
												</div>
											</div>
										<CFELSEIF envoiInfo.envoiIDOrigine NEQ "">
											Receipt e-#envoiInfo.NoRecu# was resent
										</CFIF>
									</div>
								</div>
							</cfoutput>

							<div class="blockpagination">
								<cfloop index="page" from="1" to="#nbrePages#">
								<a class="w-inline-block blocklienpagination" href="<cfoutput>#file_name_en#</cfoutput>/page-<cfoutput>#page#</cfoutput>">
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