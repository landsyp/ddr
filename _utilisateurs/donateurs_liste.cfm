<CFTRY>
	<!--- <CFOUTPUT>#Session.utilisateur.organismeID#</CFOUTPUT> --->
	
	<CFSET VARIABLES.title_en = "DDR DONORS LIST">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/donors-list/page-1">
	<CFSET VARIABLES.title_fr = "DDR LISTE DES DONATEURS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/liste-des-donateurs/page-1">
	
	<CFParam name="URL.page" default="1">
	<CFParam name="Session.code_postal" default="">
	<CFParam name="Session.courriel" default="">
	<CFParam name="Session.donateurActif" default="True">
	<CFParam name="Session.nom" default="">
	<CFParam name="Session.numero" default="">
	<CFParam name="Session.prenom" default="">
	<CFParam name="Session.tel_residence" default="">
	<CFParam name="Session.tel_cellulaire" default="">
	<CFParam name="Session.ville" default="">
	<CFParam name="Session.tri" default="numeroA">
	
	<CFIF structKeyExists(Form,'filtre')>
		<CFIF structKeyExists(form, 'actif')>
			<cfset Session.donateurActif = "true">
		<CFELSE>
			<cfset Session.donateurActif = "false">
		</CFIF>
		<cfset Session.code_postal = Trim(Form.code_postal)>
		<cfset Session.courriel = Trim(Form.courriel)>
		<cfset Session.nom = Trim(Form.nom)>
		<cfset Session.numero = Trim(Form.numero)>
		<cfset Session.prenom = Trim(Form.prenom)>
		<cfset Session.tel_residence = Trim(Form.tel_residence)>
		<cfset Session.tel_cellulaire = Trim(Form.tel_cellulaire)>
		<cfset Session.ville = Trim(Form.ville)>
	</CFIF>
	
	<CFIF structKeyExists(Form,'Initialiser')>
		<cfset Session.code_postal = "">
		<cfset Session.courriel = "">
		<cfset Session.numero = "">
		<cfset Session.nom = "">
		<cfset Session.prenom = "">
		<cfset Session.tel_residence = "">
		<cfset Session.tel_cellulaire = "">
		<cfset Session.ville = "">
		<cfset Session.donateurActif = "true">
	</CFIF>

	<CFIF isDefined('URL.tri')>
		<cfset Session.tri = URL.tri>
	<CFELSE>
		<cfset Session.tri = "numeroA">
	</CFIF>

	<CFIF isDefined('URL.archiverDID')>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateurInfos" returnvariable ="donateurArchive">
			<cfinvokeargument name="donateurID" value="#URL.archiverDID#">
		</cfinvoke>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method ="donateurArchiver" returnvariable ="message">
			<cfinvokeargument name="donateurID" value="#URL.archiverDID#">
		</cfinvoke>
	</CFIF>
	<CFIF isDefined('URL.activerDID')>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateurInfos" returnvariable ="donateurActive">
			<cfinvokeargument name="donateurID" value="#URL.activerDID#">
		</cfinvoke>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method ="donateurActiver" returnvariable ="message">
			<cfinvokeargument name="donateurID" value="#URL.activerDID#">
		</cfinvoke>
	</CFIF>
	
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="liste">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="actif" value="#Session.donateurActif#">
		<cfinvokeargument name="code_postal" value="#Session.code_postal#">
		<cfinvokeargument name="courriel" value="#Session.courriel#">
		<cfinvokeargument name="numero" value="#Session.numero#">
		<cfinvokeargument name="nom" value="#Session.nom#">
		<cfinvokeargument name="prenom" value="#Session.prenom#">
		<cfinvokeargument name="tel_residence" value="#Session.tel_residence#">
		<cfinvokeargument name="tel_cellulaire" value="#Session.tel_cellulaire#">
		<cfinvokeargument name="ville" value="#Session.ville#">
		<cfinvokeargument name="tri" value="#Session.tri#">
		
	</cfinvoke>
	
	<cfset donateursParPage = 50>
	<cfset premierDonateur = ((URL.page-1)*donateursParPage)+1>
	<cfset nbrePages = Ceiling(liste.recordcount/donateursParPage)>


	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			<STYLE>
			 /* Tooltip container */
			.tooltip {
    			position: relative;
    			display: inline-block;
    			border-bottom: 1px dotted black; /* If you want dots under the hoverable text */
			}

			/* Tooltip text */
			.tooltip .tooltiptext {
    			visibility: hidden;
    			width: 120px;
    			background-color: #555;
    			color: #fff;
    			text-align: center;
    			padding: 5px 0;
    			border-radius: 6px;
    			font-size:9px;

    			/* Position the tooltip text */
    			position: absolute;
    			z-index: 1;
    			bottom: 125%;
    			left: 50%;
    			margin-left: -60px;

    			/* Fade in tooltip */
    			opacity: 0;
    			transition: opacity 1s;
			}

			/* Tooltip arrow */
			.tooltip .tooltiptext::after {
    			content: "";
    			position: absolute;
    			top: 100%;
    			left: 50%;
    			margin-left: -5px;
    			border-width: 5px;
    			border-style: solid;
    			border-color: #555 transparent transparent transparent;
			}

			/* Show the tooltip text when you mouse over the tooltip container */
			.tooltip:hover .tooltiptext {
    			visibility: visible;
    			opacity: 1;
			}
			</STYLE>
		</head>

		<body>
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
			<!--- <div class="w-section sectionsousheader">
			    			<div class="w-container containersousheader">
			      			<div class="wrappersousheader">
			        			
			        				<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Donateurs &gt; Liste des donateurs</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Donors &gt; Donors' List</h3>
									</CFIF>
			      			</div>
			    			</div>
			  			</div> --->
  			
  			<div class="w-section sectioncontenuprincipal">
  			
    			<CFINCLUDE TEMPLATe="_sous-menu-donateurs.inc">
		
    			<div class="w-container containerprincipal" style="max-width:80%;">
      			<div class="blockfondblancpageinterne">
      				<CFIF isDefined('URL.archiverDID') OR isDefined('URL.activerDID')>
						<div class="blocsucces">
						<div><cfoutput>#message#</cfoutput></div>
						</div>
					</cfif>
					<CFIF session.langue EQ "fr">
						<div class="containerselectionneur">
							<cfoutput>#liste.recordcount#</cfoutput> donateurs
							<div class="w-form wrapperformulaire">
								<cfform class="formulaireselection" data-name="Search Form" id="search-form" name="search-form" ACTION="#file_name_fr#" METHOD="POST">
									<!--- <label class="labelselection" for="Num-de-don">AFFINER SELON &gt;</label> --->
									<label class="labelselection" for="Num-de-don">Actif</label>
									<cfinput class="w-input champselection" data-name="actif" id="actif"  name="actif" type="checkbox" checked="#Session.donateurActif EQ 'True'#">
									<label class="labelselection" for="Num-de-don"># Donateur</label>
									<cfinput class="w-input champselection" data-name="No de donateur" id="numero" maxlength="100" name="numero" type="text" value="#Session.numero#">
									<label class="labelselection" for="prenom">Nom</label>
									<cfinput class="w-input champselection" data-name="nom" id="nom" maxlength="150" name="nom" type="text" style="width:75px;" value="#Session.nom#">
									<label class="labelselection" for="nom">Pr&eacute;nom</label>
									<cfinput class="w-input champselection" data-name="Prenom" id="prenom" maxlength="150" name="prenom" type="text" style="width:75px;" value="#Session.prenom#">
									<label class="labelselection" for="nom">Ville</label>
									<cfinput class="w-input champselection" data-name="ville" id="ville" maxlength="150" name="ville" type="text" style="width:75px;" value="#Session.ville#">
									<label class="labelselection" for="nom">Code postal</label>
									<cfinput class="w-input champselection" data-name="code_postal" id="code_postal" maxlength="150" name="code_postal" type="text" style="width:75px;" value="#Session.code_postal#">
									<label class="labelselection" for="nom">Courriel</label>
									<cfinput class="w-input champselection" data-name="courriel" id="courriel" maxlength="256" name="courriel" type="text" style="width:100px;" value="#Session.courriel#">
									<label class="labelselection" for="nom">Tél. résidence</label>
									<cfinput class="w-input champselection" data-name="tel_residence" id="tel_residence" maxlength="100" name="tel_residence" type="text" style="width:75px;" value="#Session.tel_residence#">
									<label class="labelselection" for="nom">Tél. mobile</label>
									<cfinput class="w-input champselection" data-name="tel_cellulaire" id="tel_cellulaire" maxlength="100" name="tel_cellulaire" type="text" style="width:75px;" value="#Session.tel_cellulaire#">
									
									<!--- <cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >&nbsp;
									<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Initialiser" name="Initialiser" > --->
								<!--- </cfform> --->
							</div>
							
							<div class="w-form wrapper formulaire">
									<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >&nbsp;
									<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Initialiser" name="Initialiser" >
								</cfform>
							</div>
								
						
						</div>
						
						<div class="lignedetableau headertableau">
							<div class="itemligne" STYLE="display:inline;"><strong>No.</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
							<div class="itemligne"><strong>Nom, Pr&eacute;nom</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
							<div class="itemligne"><strong>Ville</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-villeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/fr/secure/liste-des-donateurs/tri-villeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
							<div class="itemligne"><strong>Code postal</strong></div>
							<div class="itemligne"><strong>Province</strong></div>
							<div class="itemligne"><strong>Courriel</strong></div>
							<div class="itemligne"><strong>T&eacute;l&eacute;phone r&eacute;sidence</strong></div>
							<div class="itemligne"><strong>T&eacute;l&eacute;phone cellulaire</strong></div>
							<div class="itemligne"><strong>Actif?</strong></div>
							<div class="editerligne"></div>
						</div>
        			
       					<cfoutput query="liste" startRow=#premierDonateur# maxrows=#donateursParPage#>
							<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "DonateurVerifierDuplicatNumero" returnvariable ="duplicat">
								<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
								<cfinvokeargument name="numero" value="#numero#">
							</cfinvoke>
        					<cfif actif>
        						<div class="lignedetableau" >
        					<cfelse>
        						<div class="lignedetableau inactif" >
        					</cfif>
        				
          					<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#donateurID#">## #numero#</a> <cfif duplicat GT 1><span style="color:red;">X #duplicat#</span></cfif></div>
          					<div class="itemligne">
								#nom#<CFIF prenom NEQ "">, #prenom#</CFIF>
								<CFIF notes NEQ "">
          						 <div class="tooltip">&nbsp;<img  src="https://solution-ddr.com/images/info.png" style="max-width:none;"s>
									<span class="tooltiptext">#notes#</span>
									</div>
								</CFIF>
							</div>
          					<div class="itemligne">#ville#</div>
          					<div class="itemligne">#code_postal#</div>
          					<div class="itemligne">#province#</div>
          					<div class="itemligne">
          						<CFIF courriel NEQ "">#courriel#
          						 <!--- <div class="tooltip"><img  src="https://solution-ddr.com/images/courriel.png"  >
									<span class="tooltiptext" style="bottom:100%;"><a href="mailto:#courriel#" STYLE="color:white;">#courriel#</a></span>
								</div> --->
								</CFIF>
          					</div>
          					<div class="itemligne">#tel_residence#</div>
          					<div class="itemligne">#tel_cellulaire#</div>
          					<div class="itemligne"><cfif actif>oui<cfelse>non</cfif></div>
          					<div class="editerligne">
            					<a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#donateurID#"><img class="iconetableau" src="/images/iconmonstr-pencil-4.svg" width="14" TITLE="Modifier">
            					</a>
            					<cfif actif>
            						<a class="w-inline-block lientableau" data-ix="show-confirmation-deleting" href="#APPLICATION.Racine#/fr/secure/archiver-donateur-#donateurID#"><img class="iconetableau" src="/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Archiver">
            						</a>
            					<cfelse>
            						<a class="w-inline-block lientableau" data-ix="show-confirmation-deleting" href="#APPLICATION.Racine#/fr/secure/activer-donateur-#donateurID#"><img class="iconetableau" src="/images/check.png" width="14" TITLE="Activer">
            						</a>
            					</cfif>
          					</div>
        					</div>
        				</cfoutput>
        			
						<div class="blockpagination">
							<cfloop index="page" from="1" to="#nbrePages#">
								<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-donateurs/page-<cfoutput>#page#</cfoutput>">
									<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
								</a>
							</cfloop>		
						</div>
        			<CFELSE>
        				<div class="containerselectionneur">
        					<cfoutput>#liste.recordcount#</cfoutput> donors
          					<div class="w-form wrapperformulaire">
            					<cfform class="formulaireselection" data-name="Search Form" id="search-form" name="search-form" ACTION="#file_name_en#" METHOD="POST">
            						<!--- <label class="labelselection" for="Num-de-don">AFFINER SELON &gt;</label> --->
									<label class="labelselection" for="Num-de-don">Active :</label>
									<cfinput class="w-input champselection" data-name="actif" id="actif"  name="actif" type="checkbox" checked="#Session.donateurActif EQ 'True'#">
									<label class="labelselection" for="Num-de-don">No.</label>
									<cfinput class="w-input champselection" data-name="No de donateur" id="numero" maxlength="256" name="numero" type="text" value="#Session.numero#">
									<label class="labelselection" for="prenom">Family Name</label>
									<cfinput class="w-input champselection" data-name="nom" id="nom" maxlength="256" name="nom" type="text" value="#Session.nom#">
									<label class="labelselection" for="nom">First Name</label>
									<cfinput class="w-input champselection" data-name="Prenom" id="prenom" maxlength="256" name="prenom" type="text" value="#Session.prenom#">
									<label class="labelselection" for="nom">City</label>
									<cfinput class="w-input champselection" data-name="ville" id="ville" maxlength="150" name="ville" type="text" style="width:75px;" value="#Session.ville#">
									<label class="labelselection" for="nom">Postal Code</label>
									<cfinput class="w-input champselection" data-name="code_postal" id="code_postal" maxlength="150" name="code_postal" type="text" style="width:75px;" value="#Session.code_postal#">
									<label class="labelselection" for="nom">Email</label>
									<cfinput class="w-input champselection" data-name="courriel" id="courriel" maxlength="256" name="courriel" type="text" style="width:100px;" value="#Session.courriel#">
									<label class="labelselection" for="nom">Home phone</label>
									<cfinput class="w-input champselection" data-name="tel_residence" id="tel_residence" maxlength="100" name="tel_residence" type="text" style="width:75px;" value="#Session.tel_residence#">
									<label class="labelselection" for="nom">Cell phone</label>
									<cfinput class="w-input champselection" data-name="tel_cellulaire" id="tel_cellulaire" maxlength="100" name="tel_cellulaire" type="text" style="width:75px;" value="#Session.tel_cellulaire#">
									<!--- <cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" > --->
            					<!--- </cfform> --->
          					</div>
							<div class="w-form wrapper formulaire">
								<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >&nbsp;
								<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Clear" name="Initialiser" >
							</cfform>
							</div>
        				</div>
        				<div class="lignedetableau headertableau">
          					<div class="itemligne "><strong>Donor #</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
          					<div class="itemligne"><strong>Name</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
          					<div class="itemligne"><strong>City</strong> <a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-villeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/en/secure/donors-list/sort-villeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
          					<div class="itemligne"><strong>Postal Code</strong></div>
          					<div class="itemligne"><strong>Province</strong></div>
							<div class="itemligne"><strong>Email</strong></div>
          					<div class="itemligne"><strong>Home Phone</strong></div>
          					<div class="itemligne"><strong>Cell Phone</strong></div>
          					<div class="itemligne"><strong>Active?</strong></div>
          					<div class="editerligne"></div>
        				</div>
        			
       					<cfoutput query="liste" startRow=#premierDonateur# maxrows=#donateursParPage#>
        					<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "DonateurVerifierDuplicatNumero" returnvariable ="duplicat">
								<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
								<cfinvokeargument name="numero" value="#numero#">
							</cfinvoke>
							<cfif actif>
        						<div class="lignedetableau" >
        					<cfelse>
        						<div class="lignedetableau inactif" >
        					</cfif>
        				
          					<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-donor-#donateurID#">## #numero#</a> <cfif duplicat GT 1><span style="color:red;">X #duplicat#</span></cfif></div>
          					<div class="itemligne">
								#nom#<CFIF prenom NEQ "">, #prenom#</CFIF>
								<CFIF notes NEQ "">
          						 <div class="tooltip">&nbsp;<img  src="https://solution-ddr.com/images/info.png" style="max-width:none;"s>
									<span class="tooltiptext">#notes#</span>
									</div>
								</CFIF>
							</div>
          					<div class="itemligne">#ville#</div>
          					<div class="itemligne">#code_postal#</div>
          					<div class="itemligne">#province#</div>
							<div class="itemligne">
          						<CFIF courriel NEQ "">#courriel#
          						 <!--- <div class="tooltip"><img  src="https://solution-ddr.com/images/courriel.png" STYLE="height:16px;" >
									<span class="tooltiptext" style="bottom:100%;"><a href="mailto:#courriel#" STYLE="color:white;">#courriel#</a></span>
								</div> --->
								</CFIF>
          					</div>
          					<div class="itemligne">#tel_residence#</div>
          					<div class="itemligne">#tel_cellulaire#</div>
          					<div class="itemligne"><cfif actif>oui<cfelse>non</cfif></div>
          					<div class="editerligne">
            					<a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-donor-#donateurID#"><img class="iconetableau" src="/images/iconmonstr-pencil-4.svg" width="14" TITLE="Edit">
            					</a>
            					<cfif actif>
            						<a class="w-inline-block lientableau" data-ix="show-confirmation-deleting" href="#APPLICATION.Racine#/en/secure/archive-donor-#donateurID#"><img class="iconetableau" src="/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Archive">
            						</a>
            					<cfelse>
            						<a class="w-inline-block lientableau" data-ix="show-confirmation-deleting" href="#APPLICATION.Racine#/en/secure/activate-donor-#donateurID#"><img class="iconetableau" src="/images/check.png" width="14" TITLE="Activate">
            						</a>
            					</cfif>
          					</div>
        					</div>
        					</cfoutput>
        			
        					<div class="blockpagination">
        						<cfloop index="page" from="1" to="#nbrePages#">
		 							<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/donors-list/page-<cfoutput>#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
		 							</a>
		 						</cfloop>		
        					</div>
        				</CFIF>
      			</div>
    			</div>
  			</div>		
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