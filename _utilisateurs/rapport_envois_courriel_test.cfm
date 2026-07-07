<CFTRY>
	<cfset anneeCourante = DatePart("yyyy", Now())>
	<CFParam name="Session.DateDe" default="#anneeCourante#-01-01">
	<CFParam name="Session.DateA" default="#DateFormat(Now(), "yyyy-mm-dd")#">
	<CFParam name="Session.numero" default="">
	<CFParam name="URL.page" default="1">
	<CFIF StructKeyExists(URL,'tri')>
		<cfset Session.tri = URL.tri>
	<CFELSE>
		<cfset Session.tri = "">
	</CFIF>
	
	<CFSET VARIABLES.title_en = "DDR INFO ON EMAILS SENT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-bulk-emails"> 
	<CFSET VARIABLES.title_fr = "DDR INFO SUR ENVOI">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-envois-courriel/test">
	
	<cfset newLocal = SetLocale("English (Canadian)")>
	
	<CFIF StructKeyExists(Form, 'filtre')>
		<cfset Session.dateDe = Form.dateDe>
		<cfset Session.dateA = Form.dateA>
		<cfset Session.numero = Form.numero>
	</CFIF> 
	
	<!--- RENVOI DU RECU --->
	<CFIF StructKeyExists(Form,'renvoi')>
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiRecuInfo" returnvariable ="envoiOriginal">
			<cfinvokeargument name="envoiID" value="#Form.envoiID#">
		</cfinvoke>
		<CFIF  envoiOriginal.dateDebut NEQ "">
			<cfset annee=DatePart("yyyy", envoiOriginal.dateDebut)>
		<CFELSE>
			<cfset annee=DatePart("yyyy", envoiOriginal.dateDebut)>
		</CFIF>
		
		<CFIF envoiOriginal.courriel EQ "">
			<CFIF session.langue EQ "fr">
				<cfset messageerreur = "Impossibilité d'envoyer le reçu <br>puisqu'il n'y a aucun courriel inscrit pour ce donateur.">
			<CFELSE>
				<cfset messageerreur = "Unable to send the receipt <br> since there is no email registered for this donor.">
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
				<!--- <cfinvokeargument name="montant" value="#envoiOriginal.montant#"> --->
				<cfinvokeargument name="noRecu" value="#envoiOriginal.noRecu#">
				<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			</cfinvoke>
			<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoiRecuInfo" returnvariable ="renvoiInfo">
				<cfinvokeargument name="envoiID" value="#neoEnvoiID#">
			</cfinvoke>
			<cfset messagecourriel=Form.messagecourriel>
			<CFINCLUDE TEMPLATE="generateur_renvoi_courriel_#organisme.devise#_#session.langue#.inc">
			<CFIF session.langue EQ "fr">
				<cfset messagesucces = "L'envoi du reçu est en cours.<br/><a href='#APPLICATION.Racine#/fr/secure/info-sur-envoi-#envoitimestamp#/page-1'>Consultez le statut de l'envoi</a>.">
			<cfelse>
				<cfset messagesucces = "Receipt is being sent by email.<br/><a href='#APPLICATION.Racine#/en/secure/bulk-emails-info-#envoitimestamp#/page-1'>Check the status of the email</a>.">
			</cfif>
		</CFIF>
	</CFIF> 


	
	
	<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoisInfo" returnvariable ="envoisInfo">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDe" value="#Session.dateDe#">
		<cfinvokeargument name="dateA" value="#session.dateA#">
		<cfinvokeargument name="numero" value="#session.numero#">
		<cfinvokeargument name="tri" value="#Session.tri#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoisInfo" returnvariable ="envoisEnCoursInfo">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDe" value="#Session.dateDe#">
		<cfinvokeargument name="dateA" value="#session.dateA#">
		<cfinvokeargument name="numero" value="#session.numero#">
		<cfinvokeargument name="statut" value="1-en-cours">
	</cfinvoke>
	
	<!--- SEULEMENT L'ENVOI D'ORIGINE POUR ELIMINER LES DOUBLONS DE RECUS--->
	<cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "envoisInfoExcel" returnvariable ="envoisInfoExcel">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDe" value="#Session.dateDe#">
		<cfinvokeargument name="dateA" value="#session.dateA#">
		<cfinvokeargument name="numero" value="#session.numero#">
		<cfinvokeargument name="tri" value="#Session.tri#">
	</cfinvoke>
	
	<cfset donateursParPage = 50>
	<cfset premierDonateur = ((URL.page-1)*donateursParPage)+1>
	<cfset nbrePages = Ceiling(envoisInfo.recordcount/donateursParPage)> 
	
	<!--- STATUTS DES ENVOIS RETOURNES PAR AMAZON --->
	<CFIF session.langue EQ "fr">
		<cfset statutLabels = {
			"0-courriel-non-valide" = "Courriel vide ou non valide"
			, "1-en-cours" = "En cours d'envoi"
			, "2-livre" = "Livré"
			, "3-rejete" = "Erreur de livraison"
			, "4-spam" = "Identifié comme spam"
		}>
	<CFELSE>
		<cfset statutLabels = {
			"0-courriel-non-valide" = "Email is empty or not valid"
			, "1-en-cours" = "Being sent"
			, "2-livre" = "Delivered"
			, "3-rejete" = "Bounced"
			, "4-spam" = "Identified as spam"
		}>
	</CFIF>
	
	<!--- EXPORT EXCEL --->
	<CFIF StructKeyExists(URL, 'excel')>
		<cfheader name="Content-Disposition" value="inline; filename=recus.xls"> 
		<cfcontent type="application/msexcel; charset=windows-1252">
		<html xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns="http://www.w3.org/TR/REC-html40">
		<body>
			<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
				<THEAD>
					<CFIF session.langue EQ "fr">
						<TH CLASS="BlocEntete">Date d'envoi</TH>
						<TH CLASS="BlocEntete"># Donateur</TH>
						<TH CLASS="BlocEntete"># Reçu</TH>
						<TH CLASS="BlocEntete">Nom </TH>
						<TH CLASS="BlocEntete">Courriel</TH>
						<TH CLASS="BlocEntete">Statut</TH>
						<TH CLASS="BlocEntete">Montant</TH>
					<CFELSE>
						<TH CLASS="BlocEntete">Date Sent</TH>
						<TH CLASS="BlocEntete">Donor #</TH>
						<TH CLASS="BlocEntete">Receipt #</TH>
						<TH CLASS="BlocEntete">Name</TH>
						<TH CLASS="BlocEntete">Email</TH>
						<TH CLASS="BlocEntete">Status</TH>
						<TH CLASS="BlocEntete">Amount</TH>
					</CFIF>
				</THEAD>
				<CFSET total = 0>
				<cfoutput query="envoisInfoExcel">
					<tr STYLE="line-height:20px;">
						<td>#Left(envoiCode,10)#</td>
						<td>#numero#</td> 
						<td><CFIF structKeyExists(statutLabels, statut) AND statut EQ "2-livre">e-#noRecu#</CFIF></td>
						<td>#nom#<CFIF prenom NEQ "">, #prenom#</CFIF></td>
						<td><CFIF courriel NEQ "">#courriel#</CFIF></td>
						<td>#(structKeyExists(statutLabels, statut)) ? statutLabels[statut]: statut#</td>
						<td>
							<CFIF structKeyExists(statutLabels, statut) AND statut EQ "2-livre">#trim(numberFormat(montant,'__.00'))#</CFIF>
						</td>
					</tr>
					<CFIF montant NEQ "" AND statut EQ "2-livre"><CFSET total = total+montant></CFIF> 
				</cfoutput>	
					<tr STYLE="line-height:20px;">
						<td></td>
						<td></td>
						<td></td> 
						<td></td>
						<td></td> 
						<td style="text-align:right;"><strong>Total</strong></td>
						<td><strong><cfoutput>#DecimalFormat(total)#</cfoutput></strong></td>
					</tr>
			</table>
		</body>
		</html>
	<CFELSE>
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
						<!--- <cfset statutLabels = {
							"0-courriel-non-valide" = "Courriel vide ou non valide"
							, "1-en-cours" = "En cours d'envoi"
							, "2-livre" = "Livré"
							, "3-rejete" = "Erreur de livraison"
							, "4-spam" = "Identifié comme spam"
						}> --->
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<div class="containertyperapport"> 
									<div class="titretyperapport">
										<strong>RAPPORT D'ENVOIS COURRIEL</strong>
									</div>
								</div>
								
								<div class="containerselectionneur">
									<cfoutput>#envoisInfo.recordcount#</cfoutput> reçus envoyés par courriel
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-envois-excel">Exporter vers Excel<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="exporter vers Excel"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST"> 
											<label class="labelselection" for="Num-de-don">Date de :</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateDe" value="#Session.datede#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don">Date fin :</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateA" value="#Session.dateA#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don"># donateur :</label>
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('Le # donateur doit correspondre à une valeur numérique')" onchange="try{setCustomValidity('')}catch(e){}">
											
											<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >
										</cfform>
									</div>
								</div>

								<CFIF envoisEnCoursInfo.recordcount NEQ 0>
									<DIV class="blocfondblanc" style="color:red;font-size:10pt;border:1px solid #ddd;margin-bottom:4px;padding-top:0px;">
										*** Si certains reçus conservent le statut <b>"En cours d'envoi"</b> plus de 10 minutes après l'envoi, <br>
										<a href="https://solution-ddr.com/fr/secure/generateur-recus-courriels" style="color:red;">relancer l'envoi avec les mêmes dates de début et de fin de période</a>.<br>
										Les reçus déjà livrés seront ignorés mais une nouvelle tentative sera effectuée <br>
										pour les reçus qui ont conservés le statut "En cours d'envoi". ***
									</DIV>
								</CFIF>
								
								<TABLE style="width:100%;">
									<tr class="enteteTableau">
										<td><strong>Date envoi</strong>&nbsp;<a href="<cfoutput>#file_name_fr#</cfoutput>/tri-dateEnvoiA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-dateEnvoiD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td STYLE="display:inline;"><strong># donateur</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td><strong># reçu</strong></td>
										<td><strong>Montant</strong></td>
										<td><strong>Nom, Prénom</strong> <a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td><strong>Courriel</strong></td>
										<td><strong>Statut</strong> <a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td></td>
									</tr>
                                    <cfoutput query="envoisInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
                                        <tr class="celluleTableau">
                                            <td>#Left(envoisInfo.envoiCode,10)#</td>
                                            <td><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#envoisInfo.donateurID#">## #envoisInfo.numero#</a></td>
                                            <td><!--- <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">e-#envoisInfo.noRecu#</CFIF> --->e-#envoisInfo.noRecu#</td>
                                            <td><!--- <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">#LSCurrencyFormat(envoisInfo.montant)#</CFIF> --->#LSCurrencyFormat(envoisInfo.montant)#</td> 
                                            <td>#envoisInfo.nom#<CFIF envoisInfo.prenom NEQ "">, #envoisInfo.prenom#</CFIF></td>
                                            <td><CFIF envoisInfo.courriel NEQ "">#envoisInfo.courriel#</CFIF></td>
                                            <!--- EN COURS D'ENVOI --->
                                            <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "1-en-cours">
                                                <td class="celluleTableau attente"> En cours d'envoi</td>
                                            <!--- 1ER ENVOI RÉUSSI --->
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine EQ "">
                                                <td class="celluleTableau livre"> Livré</td>
                                            <!--- RENVOI RÉUSSI --->
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine NEQ "">
                                                <td class="celluleTableau renvoi-livre">Livré de nouveau</td>
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "3-rejete">
                                                <td class="celluleTableau rejetee">Erreur de livraison</td>
                                            <CFELSE>
                                                <td> #(structKeyExists(statutLabels, envoisInfo.statut)) ? statutLabels[envoisInfo.statut]: envoisInfo.statut#</td>
                                            </CFIF>
                                            
                                            </td>
                                            <td>
                                                <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine EQ "" AND envoisInfo.DateDebut NEQ "">
                                                    <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Envoyer de nouveau</a>
                                                    <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                        <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Fermer X</a>
                                                            <p style="font-size:12pt;">Message accompagnant l'envoi du reçu e-#envoisInfo.noRecu# au donateur <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                            <div class="w-form">
                                                                <cfform action="#file_name_fr#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                    <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                    
                                                                    <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                        <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                    <CFELSE>
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/>
                                                                    </CFIF>
                                                                    <input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Veuillez patienter">
                                                                </cfform> 
                                                            </div>
                                                        </div>
                                                    </div>
                                                <!--- SI ENVOI REJETÉ ON PERMET DE RÉESSAYER L'ENVOI AFIN DE CONSERVER LE MÊME No DE REÇU --->
                                                <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "3-rejete" AND envoisInfo.envoiIDOrigine EQ "" AND envoisInfo.DateDebut NEQ "">
                                                    <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Vérifier l'adresse courriel<BR> et essayer de nouveau</a>
                                                    <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                        <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Fermer X</a>
                                                            <p style="font-size:12pt;">Message accompagnant l'envoi du reçu e-#envoisInfo.noRecu# au donateur <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                            <div class="w-form">
                                                                <cfform action="#file_name_fr#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                    <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                    
                                                                    <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                        <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                    <CFELSE>
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/>
                                                                    </CFIF>
                                                                    <input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Veuillez patienter">
                                                                </cfform>
                                                            </div>
                                                        </div>
                                                    </div> 
                                                <!--- SI ENVOI DEMEURE "EN COURS D'ENVOI" ON PERMET DE REÉSSAYER L'ENVOI
														FAUT REVOIR CAR DÈS L'ENVOI LE LIEN APPARAÎT INDIQUANT UNE ERREUR
														AVANT LA MISE À JOUR DU STATUT
												 --->

                                                <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "1-en-cours">
                                                    <!--- <cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "VerificationEnvoiReussi" returnvariable ="envoiReussi">
                                                        <cfinvokeargument name="donateurID" value="#envoisInfo.donateurID#">
                                                        <cfinvokeargument name="noRecu" value="#envoisInfo.noRecu#">
                                                    </cfinvoke>
                                                    <CFIF envoiReussi.recordcount EQ 0>
                                                        <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');"><!--- Une erreur est survenue<BR> --->Essayer de nouveau</a>
                                                        <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                            <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Fermer X</a>
                                                                <p style="font-size:12pt;">Message accompagnant l'envoi du reçu e-#envoisInfo.noRecu# au donateur <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                                <div class="w-form">
                                                                    <cfform action="#file_name_fr#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                        <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                        
                                                                        <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                            <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                            <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                        <CFELSE>
                                                                            <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/>
                                                                        </CFIF>
                                                                        <input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Veuillez patienter">
                                                                    </cfform>
                                                                </div>
                                                            </div>
                                                        </div> 
                                                        <!--- <a href="#file_name_fr#">Rafraîchir la page <br>pour actualiser le statut</a>
                                                    <CFELSE>
                                                        Vous pouvez supprimer cet envoi --->
                                                    </CFIF>
                                                    <br> --->
													<a href="#file_name_fr#">Rafraîchir la page <br>pour actualiser le statut</a>
												<CFELSEIF envoisInfo.envoiIDOrigine NEQ "">
													&nbsp;&nbsp;Renvoi du reçu  e-#envoisInfo.NoRecu#
												</CFIF>
                                            </td>
                                        </tr>
                                    </cfoutput>
								</TABLE>

								

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
						<!--- <cfset statutLabels = {
							"0-courriel-non-valide" = "Email is empty or not valid"
							, "1-en-cours" = "Being sent"
							, "2-livre" = "Delivered"
							, "3-rejete" = "Bounced"
							, "4-spam" = "Identified as spam"
						}> ---> 
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<div class="containertyperapport">
									<div class="titretyperapport">
										<strong>EMAILS REPORT</strong>
									</div>
								</div>
								
								<div class="containerselectionneur">
									<cfoutput>#envoisInfo.recordcount#</cfoutput> receipts sent by email
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-emails-excel">Excel Export<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="Excel Export"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
											<label class="labelselection" for="Num-de-don">From:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateDe" value="#Session.datede#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don">To:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateA" value="#Session.dateA#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don"># donor :</label>
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('The donor # must be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
											
											<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >
										</cfform>
									</div>
								</div>

                                <TABLE style="width:100%;">
									<tr class="enteteTableau">
										<td><strong>Date Sent</strong>&nbsp;<a href="<cfoutput>#file_name_en#</cfoutput>/tri-dateEnvoiA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-dateEnvoiD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td STYLE="display:inline;"><strong>Donor #</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/tri-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td><strong>Receipt #</strong></td>
										<td><strong>Amount</strong></td>
										<td><strong>Name</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td><strong>Email</strong></td>
										<td><strong>Status</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></td>
										<td></td>
									</tr>
                                    <cfoutput query="envoisInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
                                        <tr class="celluleTableau">
                                            <td>#Left(envoisInfo.envoiCode,10)#</td>
                                            <td><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#envoisInfo.donateurID#">## #envoisInfo.numero#</a></td>
                                            <td><!--- <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">e-#envoisInfo.noRecu#</CFIF> --->e-#envoisInfo.noRecu#</td>
                                            <td><!--- <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">#LSCurrencyFormat(envoisInfo.montant)#</CFIF> --->#LSCurrencyFormat(envoisInfo.montant)#</td> 
                                            <td>#envoisInfo.nom#<CFIF envoisInfo.prenom NEQ "">, #envoisInfo.prenom#</CFIF></td>
                                            <td><CFIF envoisInfo.courriel NEQ "">#envoisInfo.courriel#</CFIF></td>
                                            <!--- EN COURS D'ENVOI --->
                                            <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "1-en-cours">
                                                <td class="celluleTableau attente"> In progress</td>
                                            <!--- 1ER ENVOI RÉUSSI --->
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine EQ "">
                                                <td class="celluleTableau livre"> Sent</td>
                                            <!--- RENVOI RÉUSSI --->
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine NEQ "">
                                                <td class="celluleTableau renvoi-livre">Resent</td>
                                            <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "3-rejete">
                                                <td class="celluleTableau rejetee">Delivery error</td>
                                            <CFELSE>
                                                <td> #(structKeyExists(statutLabels, envoisInfo.statut)) ? statutLabels[envoisInfo.statut]: envoisInfo.statut#</td>
                                            </CFIF>
                                            
                                            </td>
                                            <td>
                                                <CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine EQ "" AND envoisInfo.DateDebut NEQ "">
                                                    <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Resend</a>
                                                    <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                        <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Close X</a>
                                                            <p style="font-size:12pt;">Message accompanying the sending of receipt e-#envoisInfo.noRecu# to donor <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                            <div class="w-form">
                                                                <cfform action="#file_name_en#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                    <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                    
                                                                    <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                        <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                    <CFELSE>
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="" richtext="yes" toolbar="Basic"/>
                                                                    </CFIF>
                                                                    <input class="boutonvalider w-button" data-wait="Please wait" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Please wait">
                                                                </cfform> 
                                                            </div>
                                                        </div>
                                                    </div>
                                                <!--- SI ENVOI REJETÉ ON PERMET DE RÉESSAYER L'ENVOI AFIN DE CONSERVER LE MÊME No DE REÇU --->
                                                <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "3-rejete" AND envoisInfo.envoiIDOrigine EQ "" AND envoisInfo.DateDebut NEQ "">
                                                    <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Check email address<BR> and try again</a>
                                                    <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                        <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Close X</a>
                                                            <p style="font-size:12pt;">Message accompanying the sending of receipt e-#envoisInfo.noRecu# to donor <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                            <div class="w-form">
                                                                <cfform action="#file_name_en#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                    <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                    
                                                                    <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                        <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                    <CFELSE>
                                                                        <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="" richtext="yes" toolbar="Basic"/>
                                                                    </CFIF>
                                                                    <input class="boutonvalider w-button" data-wait="Please wait" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Please wait">
                                                                </cfform>
                                                            </div>
                                                        </div>
                                                    </div> 
                                                <!--- SI ENVOI DEMEURE "EN COURS D'ENVOI" ON PERMET DE REÉSSAYER L'ENVOI
														FAUT REVOIR CAR DÈS L'ENVOI LE LIEN APPARAÎT INDIQUANT UNE ERREUR
														AVANT LA MISE À JOUR DU STATUT
												 --->

                                                <CFELSEIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "1-en-cours">
                                                    <!--- <cfinvoke component="#APPLICATION.cfcEnvoiRecus#" method = "VerificationEnvoiReussi" returnvariable ="envoiReussi">
                                                        <cfinvokeargument name="donateurID" value="#envoisInfo.donateurID#">
                                                        <cfinvokeargument name="noRecu" value="#envoisInfo.noRecu#">
                                                    </cfinvoke>
                                                    <CFIF envoiReussi.recordcount EQ 0>
                                                        <a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">An error has occurred<BR>Try again</a>
                                                        <div class="modalwrapper" id="message-#envoiID#" style="display:none;">
                                                            <div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Close X</a>
                                                                <p style="font-size:12pt;">Message accompanying the sending of receipt e-#envoisInfo.noRecu# to donor <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
                                                                <div class="w-form">
                                                                    <cfform action="#file_name_en#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
                                                                        <input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
                                                                        
                                                                        <CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
                                                                            <CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
                                                                            <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
                                                                        <CFELSE>
                                                                            <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="" richtext="yes" toolbar="Basic"/>
                                                                        </CFIF>
                                                                        <input class="boutonvalider w-button" data-wait="Please wait" name="renvoi" id="renvoi" type="submit" value="Envoi" wait="Please wait">
                                                                    </cfform>
                                                                </div>
                                                            </div>
                                                        </div> 
                                                        Rafraîchir la page pour actualiser le statut
                                                    <CFELSE>
                                                        Vous pouvez supprimer cet envoi
                                                    </CFIF> --->
                                                    <a href="#file_name_en#">Refresh page <br>to update status</a>
                                                <CFELSEIF envoisInfo.envoiIDOrigine NEQ "">
                                                    Receipt e-#envoisInfo.NoRecu# was resent
                                                </CFIF>
                                            </td>
                                        </tr>
                                    </cfoutput>
								</TABLE>

								<!--- <div class="lignedetableau headertableau">
									<div class="itemligne"><strong>Date Sent</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/tri-dateEnvoiA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-dateEnvoiD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne" STYLE="display:inline;"><strong>Donor #</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Receipt #</strong></div>
									<div class="itemligne"><strong>Amount</strong></div>
									<div class="itemligne"><strong>Name</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Email</strong></div>
									<div class="itemligne"><strong>Status</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"></div>
								</div>
								<cfoutput query="envoisInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
									<div class="lignedetableau">
										<div class="itemligne">#Left(envoisInfo.envoiCode,10)#</div>
										<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-donor-#envoisInfo.donateurID#">## #envoisInfo.numero#</a></div>
										<div class="itemligne"><CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">e-#envoisInfo.noRecu#</CFIF></div>
										<div class="itemligne"><CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre">#LSCurrencyFormat(envoisInfo.montant)#</CFIF></div>
										<div class="itemligne">#envoisInfo.nom#<CFIF envoisInfo.prenom NEQ "">, #envoisInfo.prenom#</CFIF></div>
										<div class="itemligne">
											<CFIF envoisInfo.courriel NEQ "">#envoisInfo.courriel#</CFIF> 
										</div>
										<div class="itemligne">#(structKeyExists(statutLabels, envoisInfo.statut)) ? statutLabels[envoisInfo.statut]: envoisInfo.statut#</div>
										<div class="itemligne">
											<CFIF structKeyExists(statutLabels, envoisInfo.statut) AND envoisInfo.statut EQ "2-livre" AND envoisInfo.envoiIDOrigine EQ ""  AND envoisInfo.DateDebut NEQ "">
												<a href="##" class="w-inline-block lientableau" onClick="blocking('message-#envoiID#');">Resend</a>
												
												<div class="modalwrapper" id="message-#envoiID#" style="display:none;">
													<div class="messageenvoimodal"><a href="##" class="ajoutpadding lienbleu"  onClick="blocking('message-#envoiID#');">Close X</a>
														<p style="font-size:12pt;">Message accompanying the sending of receipt e-#envoisInfo.noRecu# to donor <CFIF envoisInfo.prenom NEQ "">#envoisInfo.prenom#</CFIF> #envoisInfo.nom#</p>
														<div class="w-form">
															<cfform action="#file_name_en#" data-name="Envoi recu" id="envoi-courriel" name="envoi-courriel">
																<input type="hidden" name="envoiID" id="envoiID" value="#envoisInfo.envoiID#"> 
																
																<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')> 
																	<CFSET logoHTML = '<IMG SRC="' & APPLICATION.Racine & '/_utilisateurs/logos/' & Session.utilisateur.organismeID & '.' & organisme.logoExt & '" style="width: 200px;"/>'> 
																	<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="#logoHTML#" richtext="yes" toolbar="Basic"/>  
																<CFELSE>
																	<cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Please enter a message for the recipient."  value="" richtext="yes" toolbar="Basic"/>
																</CFIF> 
																<!--- <cftextarea name="messagecourriel" id="messagecourriel" wrap="virtual" height="300" width="550" required="yes" message="Veuillez inscrire un message pour le destinataire."  value="" richtext="yes" toolbar="Basic"/>  --->
																<!--- <input autofocus="autofocus" class="blocchamp motdepassecourriel w-input" data-name="Courriel" id="Courriel" maxlength="256" name="Courriel" required="" type="email" pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{1,63}$" oninvalid="setCustomValidity('Veuillez entrer une adresse courriel valide.')" onchange="try{setCustomValidity('')}catch(e){}"> --->
																
																<input class="boutonvalider w-button" data-wait="Veuillez patienter" name="renvoi" id="renvoi" type="submit" value="Send" wait="Please wait">
															</cfform>
														</div>
													</div>
												</div>
											<CFELSEIF envoisInfo.envoiIDOrigine NEQ "">
												Receipt e-#envoisInfo.NoRecu# was resent
											</CFIF>
										</div>
									</div>
								</cfoutput> --->

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
		</cfoutput>  --->
			
	</CFCATCH>
</CFTRY>