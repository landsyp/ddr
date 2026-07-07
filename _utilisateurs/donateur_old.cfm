<CFTRY>
	<CFIF isDefined('URL.DID')>
		<CFSET VARIABLES.title_en = "DDR DONOR EDIT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/edit-donor-#URL.DID#">
		<CFSET VARIABLES.title_fr = "DDR MODIFICATION DONATEUR">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/editer-donateur-#URL.DID#">
	<CFELSE>
		<CFSET VARIABLES.title_en = "DDR DONOR ADD">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/add-donor">
		<CFSET VARIABLES.title_fr = "DDR AJOUT DONATEUR">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/ajout-donateur">
	</CFIF>

	<CFParam name="actif" default="True">
	<CFParam name="adresse" default="">
	<CFParam name="code_postal" default="">
	<CFParam name="courriel" default="">
	<CFParam name="membre" default="False">
	<CFParam name="nom" default="">
	<CFParam name="numero" default="">
	<CFParam name="prenom" default="">
	<CFParam name="donateurProvinceID" default="9">
	<CFParam name="recu" default="True">
	<CFParam name="tel_cellulaire" default="">
	<CFParam name="tel_residence" default="">
	<CFParam name="ville" default="">
	
	<CFParam name="Session.message" default="">
	<CFParam name="Session.messageEchec" default="">
	
	<CFIF isDefined('URL.tri')>
		<cfset tri=URL.tri>
	<CFELSE>
		<cfset tri="numeroA">
	</CFIF>
	
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "provincesListe" returnvariable ="provinces">
		<cfinvokeargument name="langue" value="#Session.langue#">
	</cfinvoke>
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="listeDonateurs">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="tri" value="#tri#">
	</cfinvoke>
	
	<!--- AJOUT --->
	<CFIF isDefined('Form.ajout')>
		<CFIF isDefined('Form.actif')>
			<cfset Form.actif = "True">
		<CFELSE>
			<cfset Form.actif = "False">
		</CFIF>
		<CFIF isDefined('Form.membre')>
			<cfset Form.membre = "True">
		<CFELSE>
			<cfset Form.membre = "False">
		</CFIF>
		<CFIF isDefined('Form.recu')>
			<cfset Form.recu = "True">
		<CFELSE>
			<cfset Form.recu = "False">
		</CFIF>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateurAjout" returnvariable ="did">
			<cfinvokeargument name="actif" value="#Form.actif#">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Ucase(Form.code_postal)#">
			<cfinvokeargument name="courriel" value="#Form.courriel#">
			<cfinvokeargument name="membre" value="#Form.membre#">
			<cfinvokeargument name="nom" value="#Form.nom#">
			<cfinvokeargument name="numero" value="#Form.numero#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="prenom" value="#Form.prenom#">
			<cfinvokeargument name="provinceID" value="#Form.provinceID#">
			<cfinvokeargument name="recu" value="#Form.recu#">
			<cfinvokeargument name="tel_cellulaire" value="#Form.tel_cellulaire#">
			<cfinvokeargument name="tel_residence" value="#Form.tel_residence#">
			<cfinvokeargument name="ville" value="#Form.ville#">
		</cfinvoke>
		
		<cfset actif =Form.actif >
		<cfset adresse =Form.adresse >
		<cfset code_postal =Form.code_postal >
		<cfset courriel =Form.courriel >
		<cfset membre =Form.membre >
		<cfset nom =Form.nom >
		<cfset numero =Form.numero >
		<cfset prenom =Form.prenom >
		<cfset recu =Form.recu >
		<cfset donateurProvinceID =Form.provinceID >
		<cfset tel_cellulaire =Form.tel_cellulaire >
		<cfset tel_residence =Form.tel_residence >
		<cfset ville =Form.ville >
		
		<CFIF Session.langue EQ "fr">
			<CFIF did NEQ 0>
				<cfset Session.message="Le donateur a &eacute;t&eacute; inscrit avec succ&egrave;s.">
				<cfset Session.messageEchec="">
				<CFLOCATION URL="#APPLICATION.Racine#/fr/secure/editer-donateur-#did#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="Le num&eacute;ro #Form.numero# existe d&eacute;j&agrave;.">
			</CFIF>
		<CFELSE>
			<CFIF did NEQ 0>
				<cfset Session.message="The donor has been successfully registered.">
				<cfset Session.messageEchec="">
				<CFLOCATION URL="#APPLICATION.Racine#/en/secure/edit-donor-#did#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="The donor number already exists.">
			</CFIF>
		</CFIF>
	</CFIF>
	
	<!--- MISE A JOUR --->
	<CFIF isDefined('Form.edition')>
		<CFIF isDefined('Form.actif')>
			<cfset Form.actif = "True">
		<CFELSE>
			<cfset Form.actif = "False">
		</CFIF>
		<CFIF isDefined('Form.membre')>
			<cfset Form.membre = "True">
		<CFELSE>
			<cfset Form.membre = "False">
		</CFIF>
		<CFIF isDefined('Form.recu')>
			<cfset Form.recu = "True">
		<CFELSE>
			<cfset Form.recu = "False">
		</CFIF>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateurEdition" returnvariable ="message">
			<cfinvokeargument name="actif" value="#Form.actif#">
			<cfinvokeargument name="adresse" value="#Form.adresse#">
			<cfinvokeargument name="code_postal" value="#Ucase(Form.code_postal)#">
			<cfinvokeargument name="courriel" value="#Form.courriel#">
			<cfinvokeargument name="membre" value="#Form.membre#">
			<cfinvokeargument name="nom" value="#Form.nom#">
			<cfinvokeargument name="numero" value="#Form.numero#">
			<cfinvokeargument name="prenom" value="#Form.prenom#">
			<cfinvokeargument name="provinceID" value="#Form.provinceID#">
			<cfinvokeargument name="recu" value="#Form.recu#">
			<cfinvokeargument name="tel_cellulaire" value="#Form.tel_cellulaire#">
			<cfinvokeargument name="tel_residence" value="#Form.tel_residence#">
			<cfinvokeargument name="ville" value="#Form.ville#">
			<cfinvokeargument name="donateurID" value="#URL.DID#">
		</cfinvoke>
		<cfset Session.message=message>
		<cfset Session.messageEchec="">
	</CFIF>
	
	
	<CFIF isDefined('URL.DID')>
	
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "DonateurInfos" returnvariable ="donateur">
			<cfinvokeargument name="donateurID" value="#URL.DID#">
		</cfinvoke>

		<cfset actif =donateur.actif >
		<cfset adresse =donateur.adresse >
		<cfset code_postal =donateur.code_postal >
		<cfset courriel =donateur.courriel >
		<cfset membre =donateur.membre >
		<cfset nom =donateur.nom >
		<cfset numero =donateur.numero >
		<cfset prenom =donateur.prenom >
		<cfset donateurProvinceID =donateur.provinceID >
		<cfset recu =donateur.recu >
		<cfset tel_cellulaire =donateur.tel_cellulaire >
		<cfset tel_residence =donateur.tel_residence >
		<cfset ville =donateur.ville >
	<CFELSE>
		<cfset Session.message="">	
		<cfset Session.messageEchec="">
	</CFIF>
	
	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			
			<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
			<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
			
			
			<SCRIPT LANGUAGE="javascript">
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
				// -->
				
			</SCRIPT>
			<style>
				#listedonateurs { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:0px; }
				#donorslist { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:0px; }
			</style>
			<script>
				$(function() {
					$( "#listedonateurs" ).draggable();
					$( "#donorslist" ).draggable();
				});
			</script>
			<style>
    			.odd {
        			background-color: #EEEEEE;
    			}
    			.even {
        			background-color: #FFFFFF;
    			}
			</style>
		</head>

		<body>
			
			<!--- DIV FLOTTANTS --->
			<CFIF Session.langue EQ "fr">
				<div id="listedonateurs" class="blocfondblanc" STYLE="z-index: 10;display:block;overflow: scroll;">
					<table STYLE="width:100%;font-size:12px;border:thin solid #DDD;">
						<tr >
							<td colspan="3" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('listedonateurs'); blocking('donateurlien1');blocking('donateurlien2');return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Fermer"></a>
							</td>
						</tr>
						<tr style="background-color:#00b9ff;color:#fff">
							<th STYLE="text-align:left;">No. <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/ajout-donateur/tri-numeroA"><img  src="https://solution-ddr.com/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/ajout-donateur/tri-numeroD"><img  src="https://solution-ddr.com/images/tri_des_blanc.png" STYLE="height:5px;"></a>
							</th>
							<th  STYLE="text-align:left;">Nom <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/ajout-donateur/tri-nomA"><img  src="https://solution-ddr.com/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/ajout-donateur/tri-nomD"><img  src="https://solution-ddr.com/images/tri_des_blanc.png" STYLE="height:5px;"></a>
							</th>
							<th  STYLE="text-align:left;">Pr&eacute;nom</th>
						</tr>
						<cfoutput query="listeDonateurs">
							<cfif actif>
								<tr class="<cfif (listeDonateurs.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">
									<td STYLE="text-align:left;padding-left:4px;">#numero#</td>
									<td STYLE="text-align:left;padding-left:4px;">#nom#</td>
									<td STYLE="text-align:left;padding-left:4px;">#prenom#</td>
								</tr>
							</cfif>
						</cfoutput>
					</table>
				</div>

			<CFELSE>
				<div id="donorslist" class="blocfondblanc" STYLE="z-index: 10;display:block;overflow: scroll;">
					<table STYLE="width:100%;font-size:12px;border:thin solid #DDD;">
						<tr >
							<td colspan="3" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('donorslist'); blocking('donateurlien1');blocking('donateurlien2');return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Close"></a>
							</td>
						</tr>
						<tr style="background-color:#00b9ff;color:#fff">
							<th STYLE="text-align:left;">No. <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/add-donor/sort-numeroA"><img  src="https://solution-ddr.com/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/add-donor/sort-numeroD"><img  src="https://solution-ddr.com/images/tri_des_blanc.png" STYLE="height:5px;"></a>
							</th>
							<th  STYLE="text-align:left;">Last Name <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/add-donor/sort-nomA"><img  src="https://solution-ddr.com/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/add-donor/sort-nomD"><img  src="https://solution-ddr.com/images/tri_des_blanc.png" STYLE="height:5px;"></a>
							</th>
							<th  STYLE="text-align:left;">First Name</th>
						</tr>
						<cfoutput query="listeDonateurs">
							<cfif actif>
								<tr class="<cfif (listeDonateurs.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">
									<td STYLE="text-align:left;padding-left:4px;">#numero#</td>
									<td STYLE="text-align:left;padding-left:4px;">#nom#</td>
									<td STYLE="text-align:left;padding-left:4px;">#prenom#</td>
								</tr>
							</cfif>
						</cfoutput>
					</table>
				</div>
				
				
			</CFIF>
		
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
			<!--- <div class="w-section sectionsousheader">
			    			<div class="w-container containersousheader">
			      			<div class="wrappersousheader">
			      				<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Donateurs &gt; Ajouter un donateur</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Donors &gt; Add a donor</h3>
									</CFIF>
			      			</div>
			    			</div>
			  			</div> --->
			
  			<div class="w-section sectioncontenuprincipal">
  			
    			<CFINCLUDE TEMPLATe="_sous-menu-donateurs.inc">
    			
    			<div class="w-container containerprincipal">
      			<div class="blocfondblanc">
        				<div class="w-form">
        					<CFIF session.langue EQ "fr">
          					<CFform  class="blocformulaireajouterdon" method="POST" action="#file_name_fr#" data-name="Ajouter donateur" id="wf-form-Ajouter-donateur" name="wf-form-Ajouter-donateur">
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
              						<!--- <label class="labeldechamp" for="numdonateur"># du donateur <a href="#" class="lienbleu" onClick="blocking('listedonateurs');blocking('donateurlien1');blocking('donateurlien2'); return false;">(cacher liste)</a></label> --->
              						<div id="donateurlien1" Style="display:none;">
											<label class="labeldechamp" for="numdonateur"># donateur <a href="#" class="lienbleu" onClick="blocking('listedonateurs');blocking('donateurlien1');blocking('donateurlien2'); return false;">(afficher liste)</a></label>
										</div>
										<div id="donateurlien2" Style="display:block;">
											<label class="labeldechamp" for="numdonateur"># donateur <a href="#" class="lienbleu" onClick="blocking('listedonateurs');blocking('donateurlien1');blocking('donateurlien2'); return false;">(cacher liste)</a></label>
										</div>
              						<input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="256" name="numero" required="" type="text" value="<cfoutput>#numero#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Veuillez entrer le no du donateur')" onchange="try{setCustomValidity('')}catch(e){}" >
            						
            					</div>
            					<div class="blocchamp">
              						
              						<div class="checkboxmiddle w-checkbox">
                						<cfinput class="w-checkbox-input" data-name="actif" id="actif" name="actif" type="checkbox" checked="#actif EQ 'True'#">
                						<label class="w-form-label" for="checkbox">Actif ?</label>
                						
              						</div>
              						<div class="checkboxmiddle w-checkbox" STYLE="padding-top:10px;">
											<cfinput class="w-checkbox-input" data-name="membre" id="membre" name="membre" type="checkbox" checked="#membre EQ 'True'#">
											<label class="w-form-label" for="checkbox">Membre ?</label>
										</div>
              						<div class="checkboxmiddle w-checkbox" STYLE="padding-top:10px;">
											<cfinput class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" checked="#recu EQ 'True'#">
											<label class="w-form-label" for="checkbox">Re&ccedil;u ?</label>
										</div>
										
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="nom">Nom (organisme ou individu)</label>
              						<input class="w-input champtexte" data-name="nom" id="nom" maxlength="75" name="nom" value="<cfoutput>#nom#</cfoutput>" required="" type="text" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le nom du donateur')" onchange="try{setCustomValidity('')}catch(e){}">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="prenom">Pr&eacute;nom</label>
              						<input class="w-input champtexte" data-name="prenom" id="prenom" maxlength="50" name="prenom" value="<cfoutput>#prenom#</cfoutput>" type="text">
            					</div>
            					
            					<div class="blocchamp">
              						<label class="labeldechamp" for="adresse">Adresse</label>
              						<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  required="" value="<cfoutput>#adresse#</cfoutput>" type="text" pattern=".{6,}" oninvalid="setCustomValidity('Veuillez inscrire l\'adresse du donateur.')" onchange="try{setCustomValidity('')}catch(e){}">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="ville">Ville</label>
              						<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville"  value="<cfoutput>#ville#</cfoutput>" type="text">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="codepostal">Code postal</label>
              						<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal" value="<cfoutput>#code_postal#</cfoutput>" type="text" style="text-transform: uppercase">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="SelecteurProvince">Province</label>
              						<select class="w-select selecteurprovince" data-name="provinceID" id="provinceID" name="provinceID">
										<option value="0">-- S&eacute;lection -- </option>
										<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ donateurProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
										</select>
            					</div>
            					<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="courriel">Courriel</label>
              						<input class="w-input champtexte" data-name="courriel" id="courriel" maxlength="150" name="courriel" type="email" value="<cfoutput>#courriel#</cfoutput>">
            					</div>
            					<div class="blocchamp"></div>
            					<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="telephoneresidence">T&eacute;l&eacute;phone (r&eacute;sidence)</label>
              						<input class="w-input champtexte" data-name="tel_residence" id="tel_residence" maxlength="30" name="tel_residence" type="text" value="<cfoutput>#tel_residence#</cfoutput>">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="telephonecellulaire">T&eacute;l&eacute;phone (cellulaire)</label>
              						<input class="w-input champtexte" data-name="tel_cellulaire" id="tel_cellulaire" maxlength="30" name="tel_cellulaire" type="text" value="<cfoutput>#tel_cellulaire#</cfoutput>">
            					</div>
            					
            					<!--- <div class="blocchamp"></div> --->
            					<div class="blocchamp blocchamppleinelargeur">
            						<CFIF isDefined('URL.DID')>
											<input class="w-button boutonvalider" data-wait="Mise à jour en cours" type="submit" name="edition" value="Mise &agrave; jour" wait="Enregistrement en cours">
										<CFELSE>		
											<input class="w-button boutonvalider" data-wait="Enregistrement en cours" type="submit" name="ajout" value="Ajouter le donateur" wait="Enregistrement en cours">
										</CFIF>
            					</div>
            				</CFFORM>
            			<CFELSE>
            				<CFform  class="blocformulaireajouterdon" method="POST" action="#file_name_en#" data-name="Ajouter donateur" id="wf-form-Ajouter-donateur" name="wf-form-Ajouter-donateur">
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
              						<!--- <label class="labeldechamp" for="numdonateur"># donor :</label> --->
              						<div id="donateurlien1" Style="display:none;">
											<label class="labeldechamp" for="numdonateur"># donor <a href="#" class="lienbleu" onClick="blocking('donorslist');blocking('donateurlien1');blocking('donateurlien2'); return false;">(View List)</a></label>
										</div>
										<div id="donateurlien2" Style="display:block;">
											<label class="labeldechamp" for="numdonateur"># donor <a href="#" class="lienbleu" onClick="blocking('donorslist');blocking('donateurlien1');blocking('donateurlien2'); return false;">(Hide List)</a></label>
										</div>
              						<input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="256" name="numero" required="" type="text" value="<cfoutput>#numero#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Please enter donor\'s number')" onchange="try{setCustomValidity('')}catch(e){}" >
            					</div>
            					<div class="blocchamp">
              						
              						<div class="checkboxmiddle w-checkbox">
                						<cfinput class="w-checkbox-input" data-name="actif" id="actif" name="actif" type="checkbox" checked="#actif EQ 'True'#">
                						<label class="w-form-label" for="checkbox">Active ?</label>
              						</div>
              						<div class="checkboxmiddle w-checkbox" STYLE="padding-top:10px;">
											<cfinput class="w-checkbox-input" data-name="membre" id="membre" name="membre" type="checkbox" checked="#membre EQ 'True'#">
											<label class="w-form-label" for="checkbox">Member ?</label>
										</div>
              						<div class="checkboxmiddle w-checkbox" STYLE="padding-top:10px;">
											<cfinput class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" checked="#recu EQ 'True'#">
											<label class="w-form-label" for="checkbox">Receipt ?</label>
										</div>
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="nom">Organization or Last Name :</label>
              						<input class="w-input champtexte" data-name="nom" id="nom" maxlength="75" name="nom" value="<cfoutput>#nom#</cfoutput>" required="" type="text" pattern="[a-zA-Z0-9áàâäãåçéèêëíìîïñóòôöõúùûüýÿæœÁÀÂÄÃÅÇÉÈÊËÍÌÎÏÑÓÒÔÖÕÚÙÛÜÝŸÆŒ._-\s]+" oninvalid="setCustomValidity('Enter last name of donor')" onchange="try{setCustomValidity('')}catch(e){}">
              						
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="prenom">First Name :</label>
              						<input class="w-input champtexte" data-name="prenom" id="prenom" maxlength="50" name="prenom" value="<cfoutput>#prenom#</cfoutput>"  type="text" >
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="adresse">Address :</label>
              						<input class="w-input champtexte" data-name="adresse" id="adresse" maxlength="150" name="adresse"  required="" value="<cfoutput>#adresse#</cfoutput>" type="text" pattern=".{6,}" oninvalid="setCustomValidity('Enter address of donor.')" onchange="try{setCustomValidity('')}catch(e){}">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="ville">City :</label>
              						<input class="w-input champtexte" data-name="ville" id="ville" maxlength="50" name="ville"  value="<cfoutput>#ville#</cfoutput>" type="text">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="codepostal">Postal Code :</label>
              						<input class="w-input champtexte" data-name="code_postal" id="code_postal" maxlength="20" name="code_postal" value="<cfoutput>#code_postal#</cfoutput>" type="text" style="text-transform: uppercase">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="SelecteurProvince">Province :</label>
              						<select class="w-select selecteurprovince" data-name="provinceID" id="provinceID" name="provinceID">
										<option value="0">-- Select -- </option>
										<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ donateurProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
										</select>
            					</div>
            					<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="courriel">Email :</label>
              						<input class="w-input champtexte" data-name="courriel" id="courriel" maxlength="150" name="courriel" type="email" value="<cfoutput>#courriel#</cfoutput>">
            					</div>
            					<div class="blocchamp"></div>
            					<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="telephoneresidence">Home Phone</label>
              						<input class="w-input champtexte" data-name="tel_residence" id="tel_residence" maxlength="30" name="tel_residence" type="text" value="<cfoutput>#tel_residence#</cfoutput>">
            					</div>
            					<div class="blocchamp">
              						<label class="labeldechamp" for="telephonecellulaire">Cell Phone</label>
              						<input class="w-input champtexte" data-name="tel_cellulaire" id="tel_cellulaire" maxlength="30" name="tel_cellulaire" type="text" value="<cfoutput>#tel_cellulaire#</cfoutput>">
            					</div>
            					
            					<!--- <div class="blocchamp"></div> --->
            					<div class="blocchamp blocchamppleinelargeur">
            						<CFIF isDefined('URL.DID')>
											<input class="w-button boutonvalider" data-wait="Update in process" type="submit" name="edition" value="Update" wait="Update in process">
										<CFELSE>		
											<input class="w-button boutonvalider" data-wait="Pease wait" type="submit" name="ajout" value="Add donor" wait="Please wait">
										</CFIF>
            					</div>
          					</CFFORM>
          				</CFIF>
        				</div>
      			</div>
    			</div>
  			</div>
			
			<!--- <CFIF Session.langue EQ "fr">
							<CFform method="POST" action="#file_name_fr#" class="course-finder-form clearfix">
								Num&eacute;ro :	<CFinput type="text" value="#numero#" name="numero" placeholder="Num&eacute;ro" required message="Veuillez inscrire le num&eacute;ro du donateur"/>
						
								Actif ? <CFinput type="checkbox" name="actif" checked="#actif EQ 'True'#"><br>
						
								<br>
								Prenom :	<CFinput type="text" value="#prenom#" name="prenom" placeholder="Prenom" required message="Veuillez inscrire lee pr&eacute;nom"/><br>
								Nom : <CFinput type="text" value="#nom#" name="nom" placeholder="Nom" required message="Veuillez inscrire lee nom"/><br>
								Courriel :	<CFinput type="text" value="#courriel#" name="courriel" placeholder="Prenom" required message="Veuillez inscrire l'adresse courriel"/><br>
								Adresse :	<CFinput type="text" value="#adresse#" name="adresse" placeholder="Adresse" /><br>
								Ville :	<CFinput type="text" value="#ville#" name="ville" placeholder="Ville" /><br>
								Code postal :	<CFinput type="text" value="#code_postal#" name="code_postal" placeholder="Code postal" /><br>
								Province : <select name="provinceID">
													<option value="0">-- S&eacute;lection -- </option>
													<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ donateurProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
												</select><br>
										
								T&eacute;l r&eacute;sidence :	<CFinput type="text" value="#tel_residence#" name="tel_residence" placeholder="T&eacute;l&eacute;phone r&eacute;sidence" /><br>
								T&eacute;l cellulaire :	<CFinput type="text" value="#tel_cellulaire#" name="tel_cellulaire" placeholder="T&eacute;l&eacute;phone cellulaire" /><br>
						
								<CFIF isDefined('URL.DID')>
									<input name="edition" type="submit" value="Mise &agrave; jour" />
								<CFELSE>		
									<input name="ajout" type="submit" value="Ajouter" />
								</CFIF>
							</CFform>
						<CFELSE>
							<CFform method="POST" action="#file_name_en#" class="course-finder-form clearfix">
								
								Number :	<CFinput type="text" value="#numero#" name="numero" placeholder="Num&eacute;ro" required message="Veuillez inscrire le num&eacute;ro du donateur"/>
						
								Active ? <CFinput type="checkbox" name="actif" checked="#actif EQ 'True'#"><br>
						
								<br>
								First Name :	<CFinput type="text" value="#prenom#" name="prenom" placeholder="Prenom" required message="Veuillez inscrire lee pr&eacute;nom"/><br>
								Last Name : <CFinput type="text" value="#nom#" name="nom" placeholder="Nom" required message="Veuillez inscrire lee nom"/><br>
								Email :	<CFinput type="text" value="#courriel#" name="courriel" placeholder="Prenom" required message="Veuillez inscrire l'adresse courriel"/><br>
								Address :	<CFinput type="text" value="#adresse#" name="adresse" placeholder="Adresse" /><br>
								City :	<CFinput type="text" value="#ville#" name="ville" placeholder="Ville" /><br>
								Postal Code :	<CFinput type="text" value="#code_postal#" name="code_postal" placeholder="Code postal" /><br>
								Province : <select name="provinceID">
													<option value="0">-- S&eacute;lection -- </option>
													<cfoutput query="provinces"><option value="#provinceID#" <CFIF provinceID EQ donateurProvinceID>SELECTED</CFIF>>#province#</option></CFOUTPUT>
												</select><br>
										
								Phone :	<CFinput type="text" value="#tel_residence#" name="tel_residence" placeholder="T&eacute;l&eacute;phone r&eacute;sidence" /><br>
								Cellular :	<CFinput type="text" value="#tel_cellulaire#" name="tel_cellulaire" placeholder="T&eacute;l&eacute;phone cellulaire" /><br>
						
								<CFIF isDefined('URL.DID')>
									<input name="edition" type="submit" value="Update" />
								<CFELSE>		
									<input name="ajout" type="submit" value="Add" />
								</CFIF>
							
							</CFform>
						</CFIF> --->
						
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