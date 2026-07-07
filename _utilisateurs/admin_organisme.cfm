<CFTRY>
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	<CFIF isDefined('URL.OID')>
		<CFSET VARIABLES.title_en = "DDR CHARITY EDIT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/admin-edit-charity-#URL.OID#">
		<CFSET VARIABLES.title_fr = "DDR MODIFICATION DONATEUR">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/admin-editer-organisme-#URL.OID#">
	<CFELSE>
		<CFSET VARIABLES.title_en = "DDR ADD CHARITY">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/admin-add-charity">
		<CFSET VARIABLES.title_fr = "DDR AJOUT ORGANISME">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/admin-ajout-organisme">
	</CFIF>
	<CFParam name="actif" default="">
	<CFParam name="adresse" default="">
	<CFParam name="code_postal" default="">
	<CFParam name="date_fin_licence" default="">
	<CFParam name="devise" default="CAD">
	<CFParam name="enregistrement" default="">
	<CFParam name="enregistrement_us" default="">
	<CFParam name="interne" default="False">
	<CFParam name="membre" default="False">
	<CFParam name="organisme" default="">
	<CFParam name="OrgProvinceID" default="9">
	<CFParam name="responsable" default="">
	<CFParam name="responsable_courriel" default="">
	<CFParam name="telephone" default="">
	<CFParam name="ville" default="">
	<CFParam name="Session.message" default="">
	<CFParam name="Session.messageEchec" default="">

	
	<!--- AJOUT --->
	<CFIF isDefined('Form.ajout')>
		
		<CFIF isDefined('Form.interne')>
			<cfset Form.interne = "True">
		<CFELSE>
			<cfset Form.interne = "False">
		</CFIF>		
		<CFIF isDefined('Form.membre')>
			<cfset Form.membre = "True">
		<CFELSE>
			<cfset Form.membre = "False">
		</CFIF>
		<CFIF isDefined('Form.actif')>
			<cfset Form.actif = "True">
		<CFELSE>
			<cfset Form.actif = "False">
		</CFIF>
	
		<cfinvoke component="#APPLICATION.cfcAdmin#" method = "organismeAjout" returnvariable ="oid">
			<cfinvokeargument name="actif" value="#Form.actif#">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Form.code_postal#">
			<cfinvokeargument name="date_fin_licence" value="#Form.date_fin_licence#">
			<cfinvokeargument name="devise" value="#Form.devise#">
			<cfinvokeargument name="enregistrement" value="#Form.enregistrement#">
			<cfinvokeargument name="enregistrement_us" value="#Form.enregistrement_us#">
			<cfinvokeargument name="interne" value="#Form.interne#">
			<cfinvokeargument name="membre" value="#Form.membre#">
			<cfinvokeargument name="organisme" value="#Form.organisme#">
			<cfinvokeargument name="provinceID" value="#Form.OrgProvinceID#">
			<cfinvokeargument name="responsable" value="#Form.responsable#">
			<cfinvokeargument name="responsable_courriel" value="#Form.responsable_courriel#">
			<cfinvokeargument name="telephone" value="#Form.telephone#">
			<cfinvokeargument name="ville" value="#Form.ville#">
		</cfinvoke>
		
		<cfset actif =Form.actif >
		<cfset adresse =Form.adresse >
		<cfset code_postal =Form.code_postal >
		<cfset date_fin_licence =Form.date_fin_licence >
		<cfset devise =Form.devise >
		<cfset enregistrement =Form.enregistrement >
		<cfset enregistrement_us =Form.enregistrement_us >
		<cfset interne =	Form.interne >
		<cfset membre =	Form.membre >
		<cfset organisme =Form.organisme >
		<cfset OrgProvinceID =Form.OrgProvinceID >
		<cfset responsable =Form.responsable >
		<cfset responsable_courriel =Form.responsable_courriel>
		<cfset telephone =Form.telephone >
		<cfset ville =Form.ville >
		
		<CFIF Session.langue EQ "fr">
			<CFIF oid NEQ 0>
				<cfset Session.message="L'organisme a &eacute;t&eacute; inscrit avec succ&egrave;s.">
				<cfset Session.messageEchec=""> 
				<CFLOCATION URL="#APPLICATION.Racine#/fr/secure/admin-editer-organisme-#oid#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="L'organisme existe d&eacute;j&agrave;.">
			</CFIF>
		<CFELSE>
			<CFIF oid NEQ 0>
				<cfset Session.message="The charity has been successfully registered.">
				<cfset Session.messageEchec="">
				<CFLOCATION URL="#APPLICATION.Racine#/en/secure/admin-edit-charity-#oid#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="The charity already exists.">
			</CFIF>
		</CFIF>
	</CFIF>
	
	
	
	<!--- MISE A JOUR --->
	<CFIF isDefined('Form.edition')>
		
		<!--- <CFIF Form.signature NEQ "">
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
				</CFIF> --->
		
		<CFIF isDefined('Form.interne')>
			<cfset Form.interne = "True">
		<CFELSE>
			<cfset Form.interne = "False">
		</CFIF>		
		<CFIF isDefined('Form.membre')>
			<cfset Form.membre = "True">
		<CFELSE>
			<cfset Form.membre = "False">
		</CFIF>
		<CFIF isDefined('Form.actif')>
			<cfset Form.actif = "True">
		<CFELSE>
			<cfset Form.actif = "False">
		</CFIF>
						
		<cfinvoke component="#APPLICATION.cfcAdmin#" method = "organismeEdition" returnvariable ="message">
			<cfinvokeargument name="actif" value="#Form.actif#">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Form.code_postal#">
			<cfinvokeargument name="date_fin_licence" value="#Form.date_fin_licence#">
			<cfinvokeargument name="devise" value="#Form.devise#">
			<cfinvokeargument name="enregistrement" value="#Form.enregistrement#">
			<cfinvokeargument name="enregistrement_us" value="#Form.enregistrement_us#">
			<cfinvokeargument name="interne" value="#Form.interne#">
			<cfinvokeargument name="membre" value="#Form.membre#">
			<cfinvokeargument name="organisme" value="#Form.organisme#">
			<cfinvokeargument name="provinceID" value="#Form.OrgProvinceID#">
			<cfinvokeargument name="responsable" value="#Form.responsable#">
			<cfinvokeargument name="responsable_courriel" value="#Form.responsable_courriel#">
			<!--- <cfinvokeargument name="signatureExt" value="#signatureExt#"> --->
			<cfinvokeargument name="telephone" value="#Form.telephone#">
			<cfinvokeargument name="ville" value="#Form.ville#">
			<cfinvokeargument name="organismeID" value="#URL.OID#">
		</cfinvoke>
		
		<cfset actif =Form.actif >
		<cfset adresse =Form.adresse >
		<cfset code_postal =Form.code_postal >
		<cfset date_fin_licence =Form.date_fin_licence >
		<cfset devise =Form.devise >
		<cfset enregistrement =Form.enregistrement >
		<cfset enregistrement_us =Form.enregistrement_us >
		<cfset interne =	Form.interne >
		<cfset membre =	Form.membre >
		<cfset organisme =Form.organisme >
		<cfset OrgProvinceID =Form.OrgProvinceID >
		<cfset responsable =Form.responsable >
		<cfset responsable_courriel =Form.responsable_courriel >
		<cfset telephone =Form.telephone >
		<cfset ville =Form.ville >
		
		<cfset Session.message=message>
		<cfset Session.messageEchec="">
		
	</CFIF>
	
	<CFIF isDefined('URL.OID')>
	
		<cfinvoke component="#APPLICATION.cfcAdmin#" method = "OrganismeInfos" returnvariable ="nouvelOrganisme">
			<cfinvokeargument name="organismeID" value="#URL.OID#">
		</cfinvoke>
		<cfset actif =nouvelOrganisme.actif >
		<cfset adresse =nouvelOrganisme.adresse >
		<cfset code_postal =nouvelOrganisme.code_postal >
		<cfset date_fin_licence =nouvelOrganisme.date_fin_licence >
		<cfset devise =nouvelOrganisme.devise >
		<cfset enregistrement =nouvelOrganisme.enregistrement > 
		<cfset enregistrement_us =nouvelOrganisme.enregistrement_us >
		<cfset interne =nouvelOrganisme.interne >
		<cfset membre =nouvelOrganisme.membre >
		<cfset organisme =nouvelOrganisme.organisme >
		<cfset OrgProvinceID =nouvelOrganisme.ProvinceID >
		<cfset responsable =nouvelOrganisme.responsable >
		<cfset responsable_courriel =nouvelOrganisme.responsable_courriel >
		<cfset telephone =nouvelOrganisme.telephone >
		<cfset ville =nouvelOrganisme.ville >
	<!--- <CFELSE>
		<cfset Session.message="">	
		<cfset Session.messageEchec=""> --->
	</CFIF>
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "provincesListe" returnvariable ="provinces">
		<cfinvokeargument name="langue" value="#Session.langue#">
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
			
				<CFINCLUDE TEMPLATe="_sous-menu-admin.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
						<div class="w-form">
							<CFIF session.langue EQ "fr">
								<cfform class="blocformulaireajouterdon" action="#file_name_fr#" data-name="MAJ profil" id="maj-profil" name="maj-profil" METHOD="POST" ENCTYPE="multipart/form-data">
									<CFIF Session.message NEQ "">
										<div class="blocchamp blocchamppleinelargeur">
											<div class="blocsucces">
												<div><cfoutput>#Session.message#</cfoutput></div>
											</div>
										</div>
									</CFIF>
									<CFIF Session.messageEchec NEQ "">
										<div class="blocchamp blocchamppleinelargeur">
											<div class="blocechec">
												<div><cfoutput>#Session.messageEchec#</cfoutput></div>
											</div>
										</div>
									</CFIF>
									<cfset Session.message="">
									<cfset Session.messageEchec="">
									
									<div class="blocchamp">
										<label class="labeldechamp" for="nomorganisme">Nom de l'organisme :</label>
										<input class="w-input champtexte" data-name="organisme" id="organisme" maxlength="50" name="organisme" required="" type="text" value="<cfoutput>#organisme#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom de l\'organisme')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp"></div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrement">Numéro d'enregistrement :</label>
										<input class="w-input champtexte" data-name="enregistrement" id="enregistrement" maxlength="30" name="enregistrement" required=""  type="text" value="<cfoutput>#enregistrement#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le numéro d\'enregistrement')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="numenregistrementus">Numéro d'enregistrement US :</label>
										<input class="w-input champtexte" data-name="enregistrement_us" id="enregistrement_us" maxlength="30" name="enregistrement_us"   type="text" value="<cfoutput>#enregistrement_us#</cfoutput>" >
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="responsable">Responsable :</label>
										<input class="w-input champtexte" data-name="responsable" id="responsable" maxlength="50" name="responsable" required="" type="text" value="<cfoutput>#responsable#</cfoutput>" pattern="[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom du responsable')" onchange="try{setCustomValidity('')}catch(e){}">
									</div>
								
									<div class="blocchamp">
										<label class="labeldechamp" for="responsable">Responsable courriel :</label>
										<input class="w-input champtexte" data-name="responsable_courriel" id="responsable_courriel" maxlength="100" name="responsable_courriel"  type="text" value="<cfoutput>#responsable_courriel#</cfoutput>" >
									</div>
								
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
								
									<div class="blocchamp">
										<label class="labeldechamp" for="adresse">Adresse :</label>
										<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  type="text" value="<cfoutput>#adresse#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="ville">Ville :</label>
										<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville"  type="text" value="<cfoutput>#ville#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="codepostal">Code postal :</label>
										<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal"  type="text" value="<cfoutput>#code_postal#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="SelecteurProvince">Province :</label>
										<select class="w-select selecteurprovince" data-name="OrgProvinceID" id="OrgProvinceID" name="OrgProvinceID">
										<option value="0">-- Select -- </option>
										<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ OrgProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
										</select>
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="telephoneresidence">T&eacute;l&eacute;phone :</label>
										<input class="w-input champtexte" data-name="telephone" id="telephone" maxlength="30" name="telephone"  type="text" value="<cfoutput>#telephone#</cfoutput>">
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="devise">Devise</label>
										<select class="w-select devise" data-name="devise" id="devise" name="devise">
										<option value="0">-- S&eacute;lectionner -- </option>
										<option value="CAD" <CFIF devise EQ "CAD">SELECTED</CFIF>>CAD</option>
										<option value="USD" <CFIF devise EQ "USD">SELECTED</CFIF>>USD</option>
										</select>
									</div>
									<!--- <div class="blocchamp"></div> --->
									<div class="blocchamp">
										<div class="checkboxmiddle w-checkbox">
											<cfinput class="w-checkbox-input" data-name="interne" id="interne" name="interne" type="checkbox" checked="#interne EQ 'True'#">
											<label class="w-form-label" for="checkbox">Interne</label>
										</div>
									</div>
									<div class="blocchamp">
										<label class="labeldechamp" for="dateLicence">sp&eacute;cifier date fin licence (externe) :</label>
										<CFinput type="datefield" value="#DateFormat(date_fin_licence, "yyyy-mm-dd")#" name="date_fin_licence" mask="yyyy-mm-dd"  required message="Veuillez inscrire la date de fin de licence"/>
									</div>
									<div class="blocchamp">
										<div class="checkboxmiddle w-checkbox">
											<cfinput class="w-checkbox-input" data-name="membre" id="membre" name="membre" type="checkbox" checked="#membre EQ 'True'#">
											<label class="w-form-label" for="checkbox">Membre</label>
										</div>
									</div>
									<div class="blocchamp">
										<div class="checkboxmiddle w-checkbox">
											<cfinput class="w-checkbox-input" data-name="actif" id="actif" name="actif" type="checkbox" checked="#actif EQ 'True'#">
											<label class="w-form-label" for="checkbox">Actif</label>
										</div>
									</div>
									
									<div class="blocchamp blocchamppleinelargeur">
										<CFIF isDefined('URL.OID')>
												<input class="w-button boutonvalider" data-wait="Mise à jour en cours" type="submit" name="edition" value="Mise &agrave; jour" wait="Enregistrement en cours">
											<CFELSE>		
												<input class="w-button boutonvalider" data-wait="Enregistrement en cours" type="submit" name="ajout" value="Ajouter l'organisme" wait="Enregistrement en cours">
											</CFIF>
								
									</div>
								</cfform>
							<CFELSE>
								<cfform class="blocformulaireajouterdon" action="#file_name_en#" data-name="MAJ profil" id="maj-profil" name="maj-profil" METHOD="POST" ENCTYPE="multipart/form-data">
								<CFIF Session.message NEQ "">
									<div class="blocchamp blocchamppleinelargeur">
										<div class="blocsucces">
											<div><cfoutput>#Session.message#</cfoutput></div>
										</div>
									</div>
								</CFIF>
								<CFIF Session.messageEchec NEQ "">
									<div class="blocchamp blocchamppleinelargeur">
										<div class="blocechec">
											<div><cfoutput>#Session.messageEchec#</cfoutput></div>
										</div>
									</div>
								</CFIF>
								<cfset Session.message="">
								<cfset Session.messageEchec="">
								<div class="blocchamp">
									<label class="labeldechamp" for="nomorganisme">Name of charity :</label>
									<input class="w-input champtexte" data-name="organisme" id="organisme" maxlength="50" name="organisme" required="" type="text" value="<cfoutput>#organisme#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Enter name of charity')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								<div class="blocchamp"></div>
								<div class="blocchamp">
									<label class="labeldechamp" for="numenregistrement">Registration Number :</label>
									<input class="w-input champtexte" data-name="enregistrement" id="enregistrement" maxlength="30" name="enregistrement" required=""  type="text" value="<cfoutput>#enregistrement#</cfoutput>" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Enter registration number')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="numenregistrementus">Registration Number US :</label>
									<input class="w-input champtexte" data-name="enregistrement_us" id="enregistrement_us" maxlength="30" name="enregistrement_us" type="text" value="<cfoutput>#enregistrement_us#</cfoutput>" >
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="responsable">Person in charge :</label>
									<input class="w-input champtexte" data-name="responsable" id="responsable" maxlength="50" name="responsable" required="" type="text" value="<cfoutput>#responsable#</cfoutput>" pattern="[a-zA-ZáàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Enter name of person in charge')" onchange="try{setCustomValidity('')}catch(e){}">
								</div>
								
								<div class="blocchamp">
									<label class="labeldechamp" for="responsable">Person in charge email :</label>
									<input class="w-input champtexte" data-name="responsable_courriel" id="responsable_courriel" maxlength="100" name="responsable_courriel"  type="text" value="<cfoutput>#responsable_courriel#</cfoutput>" >
								</div>
								
								<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
								
								<div class="blocchamp">
									<label class="labeldechamp" for="adresse">Address :</label>
									<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  type="text" value="<cfoutput>#adresse#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="ville">City :</label>
									<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville"  type="text" value="<cfoutput>#ville#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="codepostal">Postal Code :</label>
									<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal"  type="text" value="<cfoutput>#code_postal#</cfoutput>">
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="SelecteurProvince">Province :</label>
									<select class="w-select selecteurprovince" data-name="OrgProvinceID" id="OrgProvinceID" name="OrgProvinceID">
									<option value="0">-- Select -- </option>
									<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ OrgProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
									</select>
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="telephoneresidence">Phone :</label>
									<input class="w-input champtexte" data-name="telephone" id="telephone" maxlength="30" name="telephone"  type="text" value="<cfoutput>#telephone#</cfoutput>">
								</div>
								<div class="blocchamp">
										<label class="labeldechamp" for="devise">Currency</label>
										<select class="w-select devise" data-name="devise" id="devise" name="devise">
										<option value="0">-- Select -- </option>
										<option value="CAD" <CFIF devise EQ "CAD">SELECTED</CFIF>>CAD</option>
										<option value="USD" <CFIF devise EQ "USD">SELECTED</CFIF>>USD</option>
										</select>
									</div>
								<!--- <div class="blocchamp"></div> --->
								<div class="blocchamp">
									<div class="checkboxmiddle w-checkbox">
										<cfinput class="w-checkbox-input" data-name="interne" id="interne" name="interne" type="checkbox" checked="#interne EQ 'True'#">
										<label class="w-form-label" for="checkbox">Internal</label>
									</div>
								</div>
								<div class="blocchamp">
									<label class="labeldechamp" for="telephoneresidence">End of license date :</label>
									<CFinput class="w-input champtexte" type="datefield" value="#DateFormat(date_fin_licence, "yyyy-mm-dd")#" name="date_fin_licence" mask="yyyy-mm-dd"  required message="Enter end of license date"/>
								</div>
								<div class="blocchamp">
              						<div class="checkboxmiddle w-checkbox">
                						<cfinput class="w-checkbox-input" data-name="membre" id="membre" name="membre" type="checkbox" checked="#membre EQ 'True'#">
                						<label class="w-form-label" for="checkbox">Member</label>
              						</div>
            					</div>
								<div class="blocchamp">
									<div class="checkboxmiddle w-checkbox">
										<cfinput class="w-checkbox-input" data-name="actif" id="actif" name="actif" type="checkbox" checked="#actif EQ 'True'#">
										<label class="w-form-label" for="checkbox">Active</label>
									</div>
								</div>
								
								<div class="blocchamp blocchamppleinelargeur">
									<CFIF isDefined('URL.OID')>
											<input class="w-button boutonvalider" data-wait="Update in process" type="submit" name="edition" value="Update" wait="Update in process">
										<CFELSE>		
											<input class="w-button boutonvalider" data-wait="Registration in process" type="submit" name="ajout" value="Add charity" wait="Registration in process">
										</CFIF>
								
								</div>
							</cfform>
							</CFIF>
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