<CFTRY>
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	<CFSET VARIABLES.title_en = "DDR ADD CHARITY">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/admin-add-charity">
	<CFSET VARIABLES.title_fr = "DDR AJOUT ORGANISME">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/admin-ajout-organisme">
	
	
	
	
	
	<!--- MISE A JOUR --->
	<CFIF isDefined('Form.modification')>
		
		<CFIF Form.signature NEQ "">
			<CFFILE ACTION="UPLOAD" FILEFIELD="signature" DESTINATION="#APPLICATION.Path#\_utilisateurs\signatures\temp" NAMECONFLICT="OVERWRITE" ACCEPT="image/gif, image/jpeg, image/png">
			<cfset extension=File.ClientFileExt>
			<cfset document1 = "#APPLICATION.Path#\_utilisateurs\signatures\temp\#file.serverfile#">
			<cfset document2 = "#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#File.ClientFileExt#">   
			<CFIF document1 NEQ document2>
				<cffile action="COPY" source=#document1# destination=#document2#>
				<cffile action="DELETE" file=#document1#>
			</CFIF>
			<cfset signatureExt=File.ClientFileExt>
		<CFELSE>
			<cfset signatureExt="">
		</CFIF>
	
		<cfinvoke component="#APPLICATION.cfcUtilisateurs#" method = "organismeEdition" returnvariable ="message">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Form.code_postal#">
			<cfinvokeargument name="enregistrement" value="#Form.enregistrement#">
			<cfinvokeargument name="organisme" value="#Form.organisme#">
			<cfinvokeargument name="provinceID" value="#Form.provinceID#">
			<cfinvokeargument name="responsable" value="#Form.responsable#">
			<cfinvokeargument name="signatureExt" value="#signatureExt#">
			<cfinvokeargument name="telephone" value="#Form.telephone#">
			<cfinvokeargument name="ville" value="#Form.ville#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
	</CFIF>
	
	
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "provincesListe" returnvariable ="provinces">
		<cfinvokeargument name="langue" value="#Session.langue#">
	</cfinvoke>
	
	<cfinvoke component="#APPLICATION.cfcUtilisateurs#" method = "OrganismeInfos" returnvariable ="organisme">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
	</cfinvoke>
		
	
	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
	
			<div class="w-section sectionsousheader">
				<div class="w-container containersousheader">
	 				<div class="wrappersousheader">
	 					<CFIF session.langue EQ "fr">
							<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Admin &gt; Ajout organisme</h3>
						<CFELSE>
							<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Admin &gt; Add Charity</h3>
						</CFIF>
	 				</div>
  				</div>
			</div>
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-parametres.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
						<div class="w-form">
							<cfform class="blocformulaireajouterdon" action="#file_name_fr#" data-name="MAJ profil" id="maj-profil" name="maj-profil" METHOD="POST" ENCTYPE="multipart/form-data">
								<CFIF isDefined('Form.modification')>
									<div class="blocchamp blocchamppleinelargeur">
										<div class="blocsucces"><cfoutput>#message#</cfoutput></div>
									</div>
								</CFIF>
								<div class="blocchamp">
									<label class="labeldechamp" for="nomorganisme">Nom de l'organisme :</label>
									<input class="w-input champtexte" data-name="organisme" id="organisme" maxlength="50" name="organisme" required="" type="text" value="<cfoutput>#organisme.organisme#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom de l\'organisme')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="responsable">Responsable :</label>
									<input class="w-input champtexte" data-name="responsable" id="responsable" maxlength="50" name="responsable" required="" type="text" value="<cfoutput>#organisme.responsable#</cfoutput>" pattern="[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom du responsable')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="numenregistrement">Numéro d'enregistrement :</label>
									<input class="w-input champtexte" data-name="enregistrement" id="enregistrement" maxlength="30" name="enregistrement" required=""  type="text" value="<cfoutput>#organisme.enregistrement#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le numéro d\'enregistrement')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								<div class="blocchamp"></div>
								<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
								<div class="blocchamp">
									<label class="labeldechamp" for="adresse">Adresse :</label>
									<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  type="text" value="<cfoutput>#organisme.adresse#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="ville">Ville :</label>
									<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville" required="required" type="text" value="<cfoutput>#organisme.ville#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="codepostal">Code postal :</label>
									<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal"  type="text" value="<cfoutput>#organisme.code_postal#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="SelecteurProvince">Province :</label>
									<select class="w-select selecteurprovince" data-name="provinceID" id="provinceID" name="provinceID">
									<option value="0">-- Select -- </option>
									<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ organisme.ProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
									</select>
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="telephoneresidence">T&eacute;l&eacute;phone :</label>
									<input class="w-input champtexte" data-name="telephone" id="telephone" maxlength="30" name="telephone"  type="text" value="<cfoutput>#organisme.telephone#</cfoutput>">
								</div>
								<div class="blocchamp"></div>
								<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
								<div class="blocchamp specialsignature">
									<label class="labeldechamp" for="telelphonetravail">Signature du compte :</label>
								<div>
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
										<cfimage source="#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" action="info" structname="info_signature" > 
										<cfset logo_width 	= 	info_signature.width>	
										<cfset logo_height	=	info_signature.height>
										<img class="blocsignature" src="/_utilisateurs/signatures/<cfoutput>#Session.utilisateur.organismeID#.#organisme.signatureExt#</cfoutput>"  >
										
										<div class="petittextegris">
											<CFIF logo_width/logo_height GT 4>
												<span STYLE="color:red;">La largeur du fichier signature ne peut dépasser 4 fois sa hauteur. Veuillez t&eacute;l&eacute;charger un autre fichier.<br>
												</span>
											</CFIF>
											Largeur <cfoutput>#logo_width#px hauteur  #logo_height#px</cfoutput>
										</div>
										<br>
									</CFIF>
								</div>
								<!--- <a class="w-button telechargerbouton" href="#">T&eacute;l&eacute;charger une nouvelle photo</a> --->
								
								<label for="signature"> <span class="w-button telechargerbouton">T&eacute;l&eacute;charger une nouvelle photo</span></label>
    <input style="visibility: hidden; position: absolute;" id="signature" class="form-control" type="file" name="signature">
								<div class="petittextegris">Image de type jpg, png, gif.
									<!--- <br>R&eacute;solution de 300px x 75px ---></div>
								</div>
								<div class="blocchamp"></div>
								<div class="blocchamp blocchamppleinelargeur">
								<input class="w-button boutonvalider" name="modification" data-wait="Mise &agrave; jour en cours" type="submit" value="Mettre &agrave; jour le profil" wait="Enregistrement en cours">
								
								</div>
							</cfform>
        				</div><div class="w-form">
      			</div><!--- <div class="blocfondblanc"> --->
    			</div><!--- <div class="w-container containerprincipal"> --->
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