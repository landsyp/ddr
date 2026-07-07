<CFTRY>
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	<CFSET VARIABLES.title_en = "DDR EDIT CHARITY">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/parameters-profile">
	<CFSET VARIABLES.title_fr = "DDR ORGANISME PROFIL">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/parametres-profil">
	
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
		
		<CFIF Form.logo NEQ "">
			<CFFILE ACTION="UPLOAD" FILEFIELD="logo" DESTINATION="#APPLICATION.Path#\_utilisateurs\logos\temp" NAMECONFLICT="OVERWRITE" ACCEPT="image/gif, image/jpeg, image/png">
			<cfset extension=File.ClientFileExt>
			<cfset document1 = "#APPLICATION.Path#\_utilisateurs\logos\temp\#file.serverfile#">
			<cfset document2 = "#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#File.ClientFileExt#">   
			<CFIF document1 NEQ document2>
				<cffile action="COPY" source=#document1# destination=#document2#>
				<cffile action="DELETE" file=#document1#>
			</CFIF>
			<cfset logoExt=File.ClientFileExt>
		<CFELSE>
			<cfset logoExt="">
		</CFIF>
	
		<cfinvoke component="#APPLICATION.cfcUtilisateurs#" method = "organismeEdition" returnvariable ="message">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Form.code_postal#">
			<cfinvokeargument name="enregistrement" value="#Form.enregistrement#">
			<cfinvokeargument name="folio" value="#Form.folio#"> 
			<cfinvokeargument name="logoExt" value="#logoExt#"> 
			<cfinvokeargument name="organisme" value="#Form.organisme#">
			<cfinvokeargument name="provinceID" value="#Form.provinceID#">
			<cfinvokeargument name="reponse_courriel" value="#Form.reponse_courriel#">
			<cfinvokeargument name="responsable" value="#Form.responsable#">
			<cfinvokeargument name="responsable_courriel" value="#Form.responsable_courriel#">
			<cfinvokeargument name="signatureExt" value="#signatureExt#">
			<cfinvokeargument name="telephone" value="#Form.telephone#">
			<cfinvokeargument name="transit" value="#Form.transit#"> 
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
							<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Param&egrave;tres &gt; Compte de l'organisme</h3>
						<CFELSE>
							<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Parameters &gt; Charity Profile</h3>
						</CFIF>
	 				</div>
  				</div>
			</div>
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-parametres.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
						<div class="w-form">
							<CFIF session.langue EQ "fr">
								<cfform class="blocformulaireajouterdon" action="#file_name_fr#" data-name="MAJ profil" id="maj-profil" name="maj-profil" METHOD="POST" ENCTYPE="multipart/form-data">
									<CFIF isDefined('Form.modification')>
										<div class="blocchamp blocchamppleinelargeur">
											<div class="blocsucces"><cfoutput>#message#</cfoutput></div>
										</div>
									</CFIF>
									<div class="blocchamp">
										<label class="labeldechamp" for="nomorganisme">Nom de l'organisme *</label>
										<input class="w-input champtexte" data-name="organisme" id="organisme" maxlength="150" name="organisme" required="required" type="text" value="<cfoutput>#organisme.organisme#</cfoutput>" pattern="[a-zA-Z0-9������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom de l\'organisme')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrement">Numéro d'enregistrement *</label>
										<input class="w-input champtexte" data-name="enregistrement" id="enregistrement" maxlength="30" name="enregistrement" required="required"  type="text" value="<cfoutput>#organisme.enregistrement#</cfoutput>" pattern="[a-zA-Z0-9������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le num�ro d\'enregistrement')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="nomresponsable">Responsable *</label>
										<input class="w-input champtexte" data-name="responsable" id="responsable" maxlength="50" name="responsable" required="required" type="text" value="<cfoutput>#organisme.responsable#</cfoutput>" pattern="[a-zA-Z������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom du responsable')" onchange="try{setCustomValidity('')}catch(e){}" >
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrement">Adresse courriel du responsable *</label>
										<input class="w-input champtexte" data-name="responsable_courriel" id="responsable_courriel" maxlength="150" name="responsable_courriel" required="required"  type="text" value="<cfoutput>#organisme.responsable_courriel#</cfoutput>" pattern="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)" oninvalid="setCustomValidity('Veuillez entrer l\'adresse courriel du responsable')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp ">
										<label class="labeldechamp" for="numenregistrement">Adresse courriel réponse *</label>
										<input class="w-input champtexte" data-name="reponse_courriel" id="reponse_courriel" maxlength="150" name="reponse_courriel" required="required"  type="text" value="<cfoutput>#organisme.reponse_courriel#</cfoutput>" pattern="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)" oninvalid="setCustomValidity('Veuillez entrer l\'adresse courriel utilisée pour répondre à vos meesages ')" onchange="try{setCustomValidity('')}catch(e){}">
										<span style="font-size:8pt;">* Adresse courriel utilisée par les donateurs pour répondre aux envois courriels de votre organisme. (ex. envoi courriel des reçus d'impôt)</span>
									</div>
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp">
										<label class="labeldechamp" for="adresse">Adresse</label>
										<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  type="text" value="<cfoutput>#organisme.adresse#</cfoutput>"> 
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="ville">Ville</label>
										<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville" required="required" type="text" value="<cfoutput>#organisme.ville#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="codepostal">Code postal</label>
										<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal"  type="text" value="<cfoutput>#organisme.code_postal#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="SelecteurProvince">Province</label>
										<select class="w-select selecteurprovince" data-name="provinceID" id="provinceID" name="provinceID">
										<option value="0">-- Selectionner -- </option>
										<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ organisme.ProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
										</select>
									</div> 
									<div class="blocchamp">
										<label class="labeldechamp" for="telephoneresidence">Téléphone</label>
										<input class="w-input champtexte" data-name="telephone" id="telephone" maxlength="30" name="telephone"  type="text" value="<cfoutput>#organisme.telephone#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="telephoneresidence">Devise</label>
										<input class="w-input champtexte" data-name="devise" id="devise" maxlength="30" name="devise"  type="text" value="<cfoutput>#organisme.devise#</cfoutput>" readonly>
									</div>
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp blocchamppleinelargeur">
										<span style="font-size:8pt;">Pour ajout automatique au bordereau de dépôt</span>
									</div> 
									<div class="blocchamp">
										<label class="labeldechamp" for="transit">Transit</label>
										<input class="w-input champtexte" data-name="transit" id="transit" maxlength="20" name="transit"  type="text" value="<cfoutput>#organisme.transit#</cfoutput>"> 
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="folio">Folio/No de compte</label>
										<input class="w-input champtexte" data-name="folio" id="folio" maxlength="30" name="folio" type="text" value="<cfoutput>#organisme.folio#</cfoutput>">
									</div>
									
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									
									<!--- SIGNATURE --->
									<div class="blocchamp specialsignature">
										<label class="labeldechamp" for="telelphonetravail">Signature pour reçus d'impôt</label>
										<div>
											<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
												<cfimage source="#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" action="info" structname="info_signature" > 
												<cfset signature_width 	= 	info_signature.width>	
												<cfset signature_height	=	info_signature.height>
												<img class="blocsignature" src="/_utilisateurs/signatures/<cfoutput>#Session.utilisateur.organismeID#.#organisme.signatureExt#?#TimeFormat(Now(), "hh:nn:ss")#</cfoutput>"  style="margin-bottom:0px;">
											
												<div <!--- class="petittextegris" ---> style="margin-bottom:10px;">
													<CFIF signature_width/signature_height GT 4>
														<span STYLE="color:red;">La largeur du fichier signature ne peut dépasser 4 fois sa hauteur. Veuillez télécharger un autre fichier.<br>
														</span>
													</CFIF>
													Largeur <cfoutput>#signature_width#px hauteur  #signature_height#px</cfoutput>
												</div>
												<br>
												<!--- <cfdump var="#info_signature#"></cfdump>  --->
											</CFIF>
										</div>
										<label for="signature"> <span class="w-button telechargerbouton">Télécharger une nouvelle signature</span></label>
										<input style="visibility: hidden; position: absolute;" id="signature" class="form-control" type="file" name="signature">
										<div class="petittextegris">Utiliser une image de type jpg, png, gif.<br> Votre fichier ne devrait pas avoir plus de 400 Ko.</div> 
									</div>
									
									<!--- LOGO --->
									<div class="blocchamp specialsignature">
										<label class="labeldechamp" for="logo">Logo de l'organisme</label>
										<div>
											<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')>
												<cfimage source="#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#" action="info" structname="info_logo" > 
												<cfset logo_width 	= 	info_logo.width>
												<cfset logo_height	=	info_logo.height>
												<img class="blocsignature" src="/_utilisateurs/logos/<cfoutput>#Session.utilisateur.organismeID#.#organisme.logoExt#?#TimeFormat(Now(), "hh:nn:ss")#</cfoutput>"  >
											
												<div class="petittextegris"> 
													<CFIF logo_width GT 400 OR logo_height GT 400>
														<span STYLE="color:red;">Pour un meilleur résultat, limiter la taille de votre logo à un maximum de 400px en largeur et en hauteur. 
														Votre logo dépasse ces dimensions.<br> 
														</span>
													</CFIF>
													Largeur <cfoutput>#logo_width#px hauteur  #logo_height#px</cfoutput>
												</div>
												<br>
											</CFIF>
										</div>
										<label for="logo"> <span class="w-button telechargerbouton">Télécharger un nouveau logo</span></label>
										<input style="visibility: hidden; position: absolute;" id="logo" class="form-control" type="file" name="logo">
										<div class="petittextegris">Image de type jpg, png, gif.</div> 
									</div>
									
									
									<!--- <div class="blocchamp">
									</div> --->
									
									
									<div class="blocchamp blocchamppleinelargeur">
										<input class="w-button boutonvalider" name="modification" data-wait="Mise à jour en cours" type="submit" value="Mettre à jour le profil" wait="Enregistrement en cours">
									</div>
								</cfform>
							<cfelse>
								<cfform class="blocformulaireajouterdon" action="#file_name_en#" data-name="MAJ profil" id="maj-profil" name="maj-profil" METHOD="POST" ENCTYPE="multipart/form-data">
									<CFIF isDefined('Form.modification')>
										<div class="blocchamp blocchamppleinelargeur">
											<div class="blocsucces"><cfoutput>#message#</cfoutput></div>
										</div>
									</CFIF>
									<div class="blocchamp">
										<label class="labeldechamp" for="nomorganisme">Organization Name :</label>
										<input class="w-input champtexte" data-name="organisme" id="organisme" maxlength="150" name="organisme" required="required" type="text" value="<cfoutput>#organisme.organisme#</cfoutput>" pattern="[a-zA-Z0-9������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Please enter the organization name')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrement">Registration Number</label>
										<input class="w-input champtexte" data-name="enregistrement" id="enregistrement" maxlength="30" name="enregistrement" required="required"  type="text" value="<cfoutput>#organisme.enregistrement#</cfoutput>" pattern="[a-zA-Z0-9������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Please enter your registration number')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="nomresponsable">Contact Name</label>
										<input class="w-input champtexte" data-name="responsable" id="responsable" maxlength="50" name="responsable" required="required" type="text" value="<cfoutput>#organisme.responsable#</cfoutput>" pattern="[a-zA-Z������������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Please enter the contact name')" onchange="try{setCustomValidity('')}catch(e){}" >
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrement">Contact Email *</label>
										<input class="w-input champtexte" data-name="responsable_courriel" id="responsable_courriel" maxlength="30" name="responsable_courriel" required="required"  type="text" value="<cfoutput>#organisme.responsable_courriel#</cfoutput>" pattern="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)" oninvalid="setCustomValidity('Please enter the contact email')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp ">
										<label class="labeldechamp" for="numenregistrement">Reply email*</label>
										<input class="w-input champtexte" data-name="reponse_courriel" id="reponse_courriel" maxlength="30" name="reponse_courriel" required="required"  type="text" value="<cfoutput>#organisme.reponse_courriel#</cfoutput>" pattern="^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)" oninvalid="setCustomValidity('Please enter the reply email')" onchange="try{setCustomValidity('')}catch(e){}">
										<span style="font-size:8pt;">* Email address used by donors to reply to your organization's email messages. (e.g. emailing tax receipts).</span>
									</div>

									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp">
										<label class="labeldechamp" for="adresse">Address</label>
										<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  type="text" value="<cfoutput>#organisme.adresse#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="ville">City</label>
										<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville" required="required" type="text" value="<cfoutput>#organisme.ville#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="codepostal">Postal Code</label>
										<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal"  type="text" value="<cfoutput>#organisme.code_postal#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="SelecteurProvince">Province</label>
										<select class="w-select selecteurprovince" data-name="provinceID" id="provinceID" name="provinceID">
										<option value="0">-- Select -- </option>
										<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ organisme.ProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
										</select>
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="telephoneresidence">Telephone</label>
										<input class="w-input champtexte" data-name="telephone" id="telephone" maxlength="30" name="telephone"  type="text" value="<cfoutput>#organisme.telephone#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="telephoneresidence">Currency</label>
										<input class="w-input champtexte" data-name="devise" id="devise" maxlength="30" name="devise"  type="text" value="<cfoutput>#organisme.devise#</cfoutput>" readonly>
									</div>
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp blocchamppleinelargeur">
										<span style="font-size:8pt;">For automatic insert to deposit slip</span>
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="transit">Transit</label>
										<input class="w-input champtexte" data-name="transit" id="transit" maxlength="20" name="transit"  type="text" value="<cfoutput>#organisme.transit#</cfoutput>"> 
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="folio">Folio</label>
										<input class="w-input champtexte" data-name="folio" id="folio" maxlength="30" name="folio" type="text" value="<cfoutput>#organisme.folio#</cfoutput>">
									</div>
									
									<!--- <div class="blocchamp"></div> --->
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									
									<!--- SIGNATURE --->
									<div class="blocchamp specialsignature">
										<label class="labeldechamp" for="telelphonetravail">Account Signature</label>
										<div>
											<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
												<cfimage source="#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" action="info" structname="info_signature" > 
												<cfset signature_width 	= 	info_signature.width>	
												<cfset signature_height	=	info_signature.height>
												<img class="blocsignature" src="/_utilisateurs/signatures/<cfoutput>#Session.utilisateur.organismeID#.#organisme.signatureExt#</cfoutput>"  >
											
												<div class="petittextegris">
													<CFIF signature_width/signature_height GT 4>  
														<span STYLE="color:red;">The width of the signature file can't exceed 4 times it's height. Please upload another file.<br>
														</span>
													</CFIF>
													Width <cfoutput>#signature_width#px Height  #signature_height#px</cfoutput>
												</div>
												
												<br>
											</CFIF>
										</div>
										<label for="signature"> <span class="w-button telechargerbouton">Upload new signature</span></label>
										<input style="visibility: hidden; position: absolute;" id="signature" class="form-control" type="file" name="signature">
										<div class="petittextegris">Image type: jpg, png, gif.</div>
									</div>	
										
										
									<!--- LOGO --->
									<div class="blocchamp specialsignature">
										<label class="labeldechamp" for="logo">Organization Logo</label>
										<div>
											<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#')>
												<cfimage source="#APPLICATION.Path#\_utilisateurs\logos\#Session.utilisateur.organismeID#.#organisme.logoExt#" action="info" structname="info_logo" > 
												<cfset logo_width 	= 	info_logo.width>
												<cfset logo_height	=	info_logo.height>
												<img class="blocsignature" src="/_utilisateurs/logos/<cfoutput>#Session.utilisateur.organismeID#.#organisme.logoExt#?#TimeFormat(Now(), "hh:nn:ss")#</cfoutput>"  >
											
												<div class="petittextegris"> 
													<CFIF logo_width GT 400 OR logo_height GT 400>
														<span STYLE="color:red;">For best results, limit the size of your logo to a maximum of 400px in width and height. Your logo exceeds these dimensions.<br> 
														</span>
													</CFIF>
													Width <cfoutput>#logo_width#px Height  #logo_height#px</cfoutput>
												</div>
												<br>
											</CFIF>
										</div>
										<label for="logo"> <span class="w-button telechargerbouton">Upload new logo</span></label>
										<input style="visibility: hidden; position: absolute;" id="logo" class="form-control" type="file" name="logo">
										<div class="petittextegris">Image of type jpg, png, gif.</div> 
									</div>

									<div class="blocchamp blocchamppleinelargeur">
										<input class="w-button boutonvalider" name="modification" data-wait="Please wait..." type="submit" value="Update your profile" wait="Please wait...">
									</div>
								</cfform>
							</cfif> 
        				</div><!--- <div class="w-form"> --->
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