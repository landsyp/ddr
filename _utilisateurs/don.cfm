<CFTRY>
	<cfset newLocal = SetLocale("French (Canadian)")>
	
	<CFIF isDefined('URL.DID')>
		<CFSET VARIABLES.title_en = "DDR EDIT GIFT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/edit-gift-#URL.DID#">
		<CFSET VARIABLES.title_fr = "DDR DON EDITION">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/editer-don-#URL.DID#">
	<CFELSE>
		<CFSET VARIABLES.title_en = "DDR ADD GIFT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/add-gift">
		<CFSET VARIABLES.title_fr = "DDR DON AJOUT">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/ajout-don">
	</CFIF>
	
	<CFParam name="Session.dateDon" default="#DateFormat(Now(),'yyyy-mm-dd')#">
	<CFParam name="description" default="">
	<CFParam name="montant" default="">
	<CFParam name="noCompte" default="">
	<CFParam name="numero" default="">
	<CFParam name="thisMethodeDonID" default="">
	<CFParam name="organismeID" default="#Session.utilisateur.organismeID#">
	<CFParam name="Session.repCompte" default="False">
	<CFParam name="Session.repdate" default="False">
	<CFParam name="Session.repDonateur" default="False">
	<CFParam name="Session.repDescription" default="False"> 
	<CFParam name="Session.repMode" default="False"> 
	<CFParam name="Session.affichageDonateurs" default="False"> 
	<CFParam name="Session.affichageComptes" default="True"> 
	<CFParam name="champsRecherche" default=""> 
	
	<CFSET Session.message="">
	<CFSET Session.messageEchec="">
	
	<CFIF StructKeyExists(URL, "tri")>
		<cfset tri=URL.tri>
	<CFELSE>
		<cfset tri="numeroA">
	</CFIF>
	
	<CFIF StructKeyExists(Form, "recherche")>
		<cfset champsRecherche=Form.recherche>
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="listeDonateurs">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="recherche" value="#Form.recherche#">
			<cfinvokeargument name="tri" value="#tri#">
		</cfinvoke>
	<CFELSE>
		<cfset champsRecherche="">
		<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="listeDonateurs">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="tri" value="#tri#">
		</cfinvoke>
	</CFIF>

	<cfinvoke component="#APPLICATION.cfcComptes#" method = "comptesListe" returnvariable ="listeComptes">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
	</cfinvoke>

	<cfinvoke component="#APPLICATION.cfcDons#" method = "MethodesDonListe" returnvariable ="methodesDon">
		<cfinvokeargument name="langue" value="#session.langue#">
	</cfinvoke>

	<!--- AJOUT --->
	<CFIF isDefined('Form.ajout')>
		
		<CFIF StructKeyExists(Form,'repCompte')>
			<cfset Session.repCompte="True">
		<CFELSE>
			<cfset Session.repCompte="False">
		</CFIF>
		<CFIF StructKeyExists(Form,'repdate')>
			<cfset Session.repdate="True">
		<CFELSE>
			<cfset Session.repdate="False">
		</CFIF>
		<CFIF StructKeyExists(Form,'repDonateur')>
			<cfset Session.repDonateur="True">
		<CFELSE>
			<cfset Session.repDonateur="False">
		</CFIF>
		<CFIF StructKeyExists(Form,'repDescription')>
			<cfset Session.repDescription="True">
		<CFELSE>
			<cfset Session.repDescription="False">
		</CFIF>
		<CFIF StructKeyExists(Form, 'repMode')>
			<cfset Session.repMode="True">
		<CFELSE>
			<cfset Session.repMode="False">
		</CFIF>
		<CFIF StructKeyExists(Form, 'affichageDonateurs')> 
			<CFSET Session.affichageDonateurs =true>
		<CFELSE>
			<CFSET Session.affichageDonateurs =false>
		</CFIF>
		<!--- <CFIF Form.affichageDonateurs>
			<CFSET Session.affichageDonateurs =true>
		<CFELSE>
			<CFSET Session.affichageDonateurs =false>
		</CFIF> --->
			
		<cfinvoke component="#APPLICATION.cfcDons#" method = "donAjout" returnvariable ="did">
			<cfinvokeargument name="dateDon" value="#Form.dateDon#">
			<cfinvokeargument name="description" value="#Form.description#">
			<cfinvokeargument name="montant" value="#Form.montant#">
			<cfinvokeargument name="noCompte" value="#Form.noCompte#">
			<cfinvokeargument name="numero" value="#Form.numero#">
			<cfinvokeargument name="methodeDonID" value="#Form.methodeDonID#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
			
		<CFIF did EQ 0>
			<CFIF session.langue EQ "fr">
				<CFSET Session.messageEchec = "Le syst&egrave;me ne peut reconna&icirc;tre le num&eacute;ro de compte ou le num&eacute;ro du donateur.">
			<CFELSE>
				<CFSET Session.messageEchec = "We can't identify the donor number or the account number.">
			</CFIF>
			<cfset Session.message="">
		<CFELSE>
			<CFIF session.langue EQ "fr">
				<CFSET Session.message = "Le don a &eacute;t&eacute; enregistr&eacute; avec succ&egrave;s.">
			<CFELSE>
				<CFSET Session.message = "The gift has been successfully created.">
			</CFIF>
			<cfset Session.messageEchec="">
			<CFIF Session.repdate><cfset Session.dateDon=Form.dateDon><CFELSE><cfset Session.dateDon=""></CFIF>
			<cfset description ="">
			<cfset montant ="" >
			<CFIF Session.repCompte><cfset noCompte=Form.noCompte><CFELSE><cfset noCompte=""></CFIF>
			<CFIF Session.repDonateur><cfset numero=Form.numero><CFELSE><cfset numero =""></CFIF>
			<CFIF Session.repDescription><cfset description=Form.description><CFELSE><cfset description =""></CFIF>
			<CFIF Session.repMode><cfset thisMethodeDonID=Form.methodeDonID><CFELSE><cfset thisMethodeDonID =""></CFIF>
		</CFIF>		
	</CFIF>
	 
	<!--- MISE A JOUR --->
	<CFIF StructKeyExists(Form,'modification')>
		
		<cfinvoke component="#APPLICATION.cfcDons#" method = "donEdition" returnvariable ="message">
			<cfinvokeargument name="dateDon" value="#Form.dateDon#">
			<cfinvokeargument name="description" value="#Form.description#">
			<cfinvokeargument name="montant" value="#Form.montant#">
			<cfinvokeargument name="noCompte" value="#Form.noCompte#">
			<cfinvokeargument name="numero" value="#Form.numero#">
			<cfinvokeargument name="methodeDonID" value="#Form.methodeDonID#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="donID" value="#URL.DID#">
		</cfinvoke>
	</CFIF>
	
	<CFIF isDefined('URL.DID')>

		<cfinvoke component="#APPLICATION.cfcDons#" method = "DonInfos" returnvariable ="don">
			<cfinvokeargument name="donID" value="#URL.DID#">
		</cfinvoke>
		<cfset Session.dateDon =don.dateDon >
		<cfset description =don.description >
		<cfset montant =don.montant >
		<cfset noCompte =don.noCompte >
		<cfset numero =don.numero >
		<cfset thisMethodeDonID =don.methodeDonID >

	</CFIF>
	
	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			
			<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
			<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
			<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
			
			<style>
				#listedonateurs { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:280px; }
				#listecomptes { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:0px; }
				#donorslist { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:280px; }
				#accountslist { width: 280px; height:600px; padding: 0.1em; position:fixed; top:130px; right:0px; }
    			.odd {
        			background-color: #EEEEEE;
    			}
    			.even {
        			background-color: #FFFFFF;
    			}
			</style>
			<script>
				function UpdateNomDonateur(numeroDonateur)
				{
					$( "#nomParNumero" ).load("/cfc/donateurs?method=donateurNomParNumero&organismeID=<cfoutput>#Session.utilisateur.organismeID#</cfoutput>&numero=" + numeroDonateur);
				}
				function UpdateNomCompte(numeroCompte)
				{
					$( "#nomParCompte" ).load("/cfc/comptes?method=compteNomParNumero&organismeID=<cfoutput>#Session.utilisateur.organismeID#</cfoutput>&noCompte=" + numeroCompte);
				}
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
				function CopieNumero(champ,valeur,champsuivant)
				{
					document.getElementById(champ).value = valeur;
					document.getElementById(champ).focus();
					if (champ == 'numero') {
						UpdateNomDonateur(valeur);
					}
					else if (champ = 'noCompte') {
						UpdateNomCompte(valeur);
					}
					document.getElementById(champsuivant).select();
				}
				$(function() {
					$( "#listecomptes" ).draggable();
					$( "#listedonateurs" ).draggable();
					$( "#accountslist" ).draggable();
					$( "#donorslist" ).draggable();
					
					

					<CFIF session.langue EQ "en">
						$( "#dateDon" ).datepicker({ dateFormat: 'yy-mm-dd' });
					<CFELSE>
						$("#dateDon" ).datepicker({ 
						altField: "#datepicker",
						closeText: 'Fermer',
						prevText: 'Pr&#xE9;c&#xE9;dent',
						nextText: 'Suivant',
						currentText: 'Aujourd\'hui',
						monthNames: ['Janvier', 'F&#xE9;vrier', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Ao&#xFB;t', 'Septembre', 'Octobre', 'Novembre', 'D&#xE9;cembre'],
						monthNamesShort: ['Janv.', 'F&#xE9;vr.', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil.', 'Ao&#xFB;t', 'Sept.', 'Oct.', 'Nov.', 'D&#xE9;c.'],
						dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
						dayNamesShort: ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'],
						dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
						weekHeader: 'Sem.',
						dateFormat: 'yy-mm-dd'
						});
					</CFIF>
					$( "#numero" ).change("change paste keyup", function() {
						var numeroDonateur = this.value;
						UpdateNomDonateur(numeroDonateur);
					});
					$( "#noCompte" ).change("change paste keyup", function() {
						var numeroCompte = this.value;
						UpdateNomCompte(numeroCompte);
					});
  				} );
  			</script>
		</head>

		<body> 
			
			<!--- DIV FLOTTANTS --->
			<CFIF Session.langue EQ "fr">
				<div id="listedonateurs" class="blocfondblanc" STYLE="z-index: 10000;display:<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche") OR Session.affichageDonateurs>block<cfelse>none</cfif>;overflow: scroll;">
					<form class="formulaireselection" data-name="search Form" id="search-form" name="search-form" ACTION="<cfoutput>#file_name_fr#</cfoutput>" METHOD="POST" style="margin-top:0px;">
					<table STYLE="width:100%;font-size:8pt;border:thin solid #DDD;">
						<tr >
							<td colspan="2" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('listedonateurs'); blocking('donateurlien1');blocking('donateurlien2');return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Fermer"></a>
							</td>
						</tr>
						<tr style="background-color:#009AA9;color:#fff">
							<th STYLE="text-align:left;">No. <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-numeroA"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</cfoutput>/tri-numeroD"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_des_blanc.png" STYLE="height:5px;"></a></th>
							<!--- LES NOMS DES DONATEURS DISPONIBLES UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
							<CFIF listFind("0,1,2",Session.utilisateur.statut)>
								<th  STYLE="text-align:left;">
									Nom <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-nomA"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</cfoutput>/tri-nomD"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_des_blanc.png" STYLE="height:5px;"></a>
									<input class="w-input champselection" data-name="Recherche donateur" id="recherche" maxlength="50" name="recherche" placeholder="Recherche nom" style="display:inline;width:100px;font-size:10px;font-weight:100;margin-bottom:0px;" type="text" value="<cfoutput>#champsRecherche#</cfoutput>" >
								</th>
							</CFIF>
						</tr>
						<cfoutput query="listeDonateurs">
							<cfif actif>
								<tr class="<cfif (listeDonateurs.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">
									<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('numero','#numero#','noCompte')">#numero#</a></td>
									<!--- LES NOMS DES DONATEURS DISPONIBLES UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
									<CFIF listFind("0,1,2",Session.utilisateur.statut)>	
										<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('numero','#numero#','noCompte')">#nom#, #prenom#</a></td>
									</CFIF>
								</tr>
							</cfif>
						</cfoutput>
					</table>
					</form>
				</div>
				<div id="listecomptes" class="blocfondblanc" STYLE="z-index: 10000;display:block;overflow: scroll;">
					<table STYLE="width:100%;font-size:8pt;border:thin solid #DDD;">
						<tr >
							<td colspan="3" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('listecomptes'); blocking('comptelien1');blocking('comptelien2'); return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Fermer"></a>
							</td>
						</tr>
						<tr style="background-color:#009AA9;color:#fff">
						<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Compte</th>
						<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Description</th>
						<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Re&ccedil;u?</th>
						</tr>
						<cfoutput query="listeComptes">
							<tr class="<cfif (listeComptes.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">
							<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('noCompte','#noCompte#','montant')">#noCompte#</a></td>
							<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('noCompte','#noCompte#','montant')">#nom#</a></td>
							<td STYLE="text-align:left;padding-left:4px;"><cfif recu>oui<cfelse>non</cfif></td>
							</tr>
						</cfoutput>
					</table>
				</div>
			<CFELSE>
				<div id="donorslist" class="blocfondblanc" STYLE="z-index: 10000;display:<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche") OR Session.affichageDonateurs>block<cfelse>none</cfif>;overflow: scroll;">
					<form class="formulaireselection" data-name="search Form" id="search-form" name="search-form" ACTION="<cfoutput>#file_name_en#</cfoutput>" METHOD="POST" style="margin-top:0px;">
					<table STYLE="width:100%;font-size:8pt;border:thin solid #DDD;">
						<tr >
							<td colspan="2" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('donorslist'); blocking('donateurlien1');blocking('donateurlien2');return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Close"></a>
							</td>
						</tr>
						<tr style="background-color:#009AA9;color:#fff">
							<th STYLE="text-align:left;">No. <a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroA"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroD"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_des_blanc.png" STYLE="height:5px;"></a></th>
							<!--- LES NOMS DES DONATEURS DISPONIBLES UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
							<CFIF listFind("0,1,2",Session.utilisateur.statut)>
								<th  STYLE="text-align:left;">
									Name <a href="<cfoutput>#file_name_en#</cfoutput>/sort-nomA"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_asc_blanc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</cfoutput>/sort-nomD"><img  src="<cfoutput>#APPLICATION.Racine#</CFOUTPUT>/images/tri_des_blanc.png" STYLE="height:5px;"></a>
									<input class="w-input champselection" data-name="Recherche donateur" id="recherche" maxlength="50" name="recherche" placeholder="search by name" style="display:inline;width:100px;font-size:10px;font-weight:100;margin-bottom:0px;" type="text" value="<cfoutput>#champsRecherche#</cfoutput>" >
								</th>
							</CFIF>
						</tr>
						<cfoutput query="listeDonateurs">
							<cfif actif>
								<tr class="<cfif (listeDonateurs.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">								
									<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('numero','#numero#','noCompte')">#numero#</a></td>
									<!--- LES NOMS DES DONATEURS DISPONIBLES UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
									<CFIF listFind("0,1,2",Session.utilisateur.statut)>
										<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('numero','#numero#','noCompte')">#nom#, #prenom#</a></td>	
									</CFIF>
								</tr>
							</cfif>
						</cfoutput>
					</table>
					</form>
				</div>
				<div id="accountslist" class="blocfondblanc" STYLE="z-index: 10000;display:block;overflow: scroll;">
					<table STYLE="width:100%;font-size:8pt;border:thin solid #DDD;">
						<tr >
							<td colspan="3" STYLE="text-align:right;padding:4px 4px 0 0;">	
								<a class="w-inline-block " href="##" onClick="blocking('accountslist'); blocking('comptelien1');blocking('comptelien2'); return false;"><img class="iconetableau" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Close"></a>
								</td>
						</tr>
						<tr style="background-color:#009AA9;color:#fff">
							<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Account</th>
							<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Name</th>
							<th STYLE="text-align:left;padding-left:4px;vertical-align:top;">Receipt?</th>
						</tr>
						<cfoutput query="listeComptes">
							<tr class="<cfif (listeComptes.currentRow MOD 2 EQ 0)>even<cfelse>odd</cfif>">
								<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('noCompte','#noCompte#','montant')">#noCompte#</a></td>
								<td STYLE="text-align:left;padding-left:4px;"><a href="##" ONCLICK="CopieNumero('noCompte','#noCompte#','montant')">#nom#</a></td>
								<td STYLE="text-align:left;padding-left:4px;"><cfif recu>yes<cfelse>no</cfif></td>
							</tr>
						</cfoutput>
					</table>
				</div>
				
			</CFIF>
				
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-dons.inc">
				
  				<div class="w-container containerprincipal">
	 				<div class="blocfondblanc" STYLE="padding-top:0px;">
						<div class="w-form">
							<CFIF session.langue EQ "fr">
								<!--- LIEN VERS LES TUTORIELS --->
								<div style="padding-top: 20px;"></div>
								<button style="background-color: white;" onClick="showHideTut()">
									<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriel.png">
								</button>
								<div id="videoTut" style="display: none;">
									<iframe width="100%" height="400" src="https://www.youtube.com/embed/dLTi4JbE0X4?si=bkfpuuOnr_Tql_zb" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
								</div>
		  						<cfform class="blocformulaireajouterdon" data-name="Email Form" ACTION="#file_name_fr#" id="don-form" name="don-form" METHOD="POST">
									
									
									<CFIF Session.message NEQ "">
										<div class="blocsucces"><cfoutput>#Session.message#</cfoutput></div>
									</CFIF>
									<CFIF Session.messageEchec NEQ "">
										<div class="blocechec"><cfoutput>#Session.messageEchec#</cfoutput></div>
									</CFIF>
									<cfset Session.message="">
									<cfset Session.messageEchec="">
              					
			 						<div class="blocchamp blocchamppleinelargeur">
										<label class="labeldechamp" for="email">Date du don </label>
										<div class="w-embed champtexte">
				  							<!--- <input type="date" name="date" style="margin:0;padding:0;"> --->
				  							<!--- <CFinput type="datefield" value="#DateFormat(Session.dateDon, "yyyy-mm-dd")#" name="dateDon" mask="yyyy-mm-dd" placeholder="Date du don" required message="Veuillez inscrire la date du don"/> --->
				  							<input type="text" value="<cfoutput>#DateFormat(Session.dateDon, "yyyy-mm-dd")#</cfoutput>" name="dateDon" id="dateDon"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}"/>
										</div>
			 						</div>
			 					
			 						<div class="blocchamp">
										<!--- CODE POUR FENETRE MODALEDONATEURS --->
										<div id="donateurlien1" Style="display:<CFIF Session.affichageDonateurs>bock<CFELSE>none</CFIF>;">
											<label class="labeldechamp" for="numdonateur"># donateur
											<a href="#" class="lienbleu" onClick="blocking('listedonateurs');blocking('donateurlien1');blocking('donateurlien2'); return false;">(<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche") >afficher<cfelse>cacher</cfif>&nbsp;liste)</a>
											</label>
										</div>
										<div id="donateurlien2" Style="display:<CFIF Session.affichageDonateurs>none<CFELSE>block</CFIF>;">
											<label class="labeldechamp" for="numdonateur"># donateur  
											<a href="#" class="lienbleu" onClick="blocking('listedonateurs');blocking('donateurlien1');blocking('donateurlien2'); return false;">(<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche")>cacher<cfelse>afficher</cfif>&nbsp;liste)</a>
											</label>
										</div>
										<input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="50" name="numero" required="" type="text" value="<cfoutput>#numero#</cfoutput>"  pattern="[0-9]+" oninvalid="setCustomValidity('Veuillez entrer le no du donateur')" onchange="try{setCustomValidity('')}catch(e){}" >
										<!--- <CFDIV bind="cfc:#APPLICATION.cfcDonateurs#.donateurNomParNumero('#Session.utilisateur.organismeID#',{numero})" bindonload="false" class="textesouschamp" ></CFDIV> --->
										<!--- <CFDIV bind="cfc:cfc.donateurs.donateurNomParNumero('#Session.utilisateur.organismeID#',{numero})" bindonload="false" class="textesouschamp" ></CFDIV> --->
										<!--- LE NOM DU DONATEUR DISPONIBLE UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
										<CFIF listFind("0,1,2",Session.utilisateur.statut)>
											<div id="nomParNumero" class="textesouschamp"></div>
										</CFIF>
									</div>
			 						<div class="blocchamp">
			 							<!--- CODE POUR FENETRE MODALE COMPTES --->
										<div id="comptelien1" Style="display:block;">
											<label class="labeldechamp" for="numcompte"># compte <a href="#" class="lienbleu" onClick="blocking('listecomptes');blocking('comptelien1');blocking('comptelien2'); return false;">(cacher liste)</a></label>
										</div>
										<div id="comptelien2" Style="display:none;">
											<label class="labeldechamp" for="numcompte"># compte <a href="#" class="lienbleu" onClick="blocking('listecomptes');blocking('comptelien1');blocking('comptelien2'); return false;">(afficher liste)</a></label>
										</div>
										
										<input autofocus="autofocus" class="w-input champtexte" data-name="noCompte" id="noCompte" maxlength="256" name="noCompte" required="" type="text" value="<cfoutput>#noCompte#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Veuillez entrer le no du compte')" onchange="try{setCustomValidity('')}catch(e){}">
										<!--- <CFDIV bind="cfc:cfc.comptes.compteNomParNumero('#Session.utilisateur.organismeID#',{noCompte})" bindonload="false" class="textesouschamp"></CFDIV> --->
										<div id="nomParCompte" class="textesouschamp"></div>
									</div>
									<!--- ESSENTIEL POUR EVITER LE DESENLIGNEMENT SI SEULEMENT UN DES CFDIV NE S'AFFICHE PAS --->
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp">
										<label class="labeldechamp" for="montantdon">Montant du don</label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="montant" id="montant" maxlength="256" name="montant" required type="text" value="<cfif montant NEQ ""><cfoutput>#DecimalFormat(montant)#</cfoutput></cfif>" pattern="-?(0\.((0[1-9]{1})|-?([1-9]{1}([0-9]{1})?)))|-?(([1-9]+[0-9]*)(\.([0-9]{1,2}))?)" oninvalid="setCustomValidity('Veuillez entrer le montant du don')" onchange="try{setCustomValidity('')}catch(e){}">
			 						</div>
			 						<div class="blocchamp">
										<label class="labeldechamp" for="description">Description </label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="description" id="description" maxlength="256" name="description"  type="text" value="<cfoutput>#description#</cfoutput>">
			 						</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<label class="labeldechamp" for="methodeDonID">M&eacutethode de paiement</label>
										<div class="w-embed champtexte">
											<select name="methodeDonID" id="methodeDonID">
												<option value="">S&eacute;lectionner</option>
												<cfloop query="methodesDon">
													<option value="<cfoutput>#methodesDon.methodeDonID#</cfoutput>" <cfif methodesDon.methodeDonID EQ thisMethodeDonID>selected</cfif> ><cfoutput>#methodesDon.methode#</cfoutput></option>
												</cfloop>
											</select>
										</div>
			 						</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<CFIF isDefined('URL.DID')>
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
												<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="modification" type="submit" value="Modifier le don">	
			 								</div>
										<CFELSE>
											<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="ajout" type="submit" value="Valider et ajouter un autre don">
											
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
												
												<div class="petittextegris"><strong>R&eacute;p&eacute;ter les champs : </strong></div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep date" id="repdate" name="repdate" checked="#Session.repdate EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Date-du-don">Date du don</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep donateur" id="repDonateur" name="repDonateur" checked="#Session.repDonateur EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Num-du-donateur"># donateur</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep no compte" id="repCompte" name="repCompte" checked="#Session.repCompte EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Num-de-compte"># compte</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep description" id="repDescription" name="repDescription" checked="#Session.repDescription EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="description">Description</label>
				  									</div>
													<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep mode" id="repMode" name="repMode" checked="#Session.repMode EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="mode">M&eacute;thode</label>
				  									</div>
												</div>
											</div>
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
												<div class="w-checkbox w-clearfix champcheckbox">
													<cfinput class="w-checkbox-input" data-name="defaut donateurs" id="affichageDonateurs" name="affichageDonateurs" checked="#Session.affichageDonateurs EQ 'True'#" type="checkbox" onClick="blocking('listedonateurs'); blocking('donateurlien1');blocking('donateurlien2');">
													<label class="w-form-label petittextegris" for="donateurs">Afficher la liste des donateurs par d&eacute;faut</label>
												</div>
			 								</div>
			 							</CFIF>
									</div><!--- <div class="blocchamp blocchamppleinelargeur"> --->
								</cfform>
								
							<CFELSE>
									<!--- LIEN VERS LES TUTORIELS --->
									<div style="padding-top: 20px;"></div>
									<button style="background-color: white;" onClick="showHideTut()">
										<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorial.png">
									</button>
									<div id="videoTut" style="display: none;">
										<iframe width="100%" height="400" src="https://www.youtube.com/embed/xFQLk-BR63o?si=z8BDkqgBzrdw4GiF" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
									</div>
		
									<cfform class="blocformulaireajouterdon" data-name="Email Form" ACTION="#file_name_EN#" id="don-form" name="don-form" METHOD="POST">
									
									<CFIF Session.message NEQ "">
										<div class="blocsucces"><cfoutput>#Session.message#</cfoutput></div>
									</CFIF>
									<CFIF Session.messageEchec NEQ "">
										<div class="blocechec"><cfoutput>#Session.messageEchec#</cfoutput></div>
									</CFIF>
									<cfset Session.message="">
									<cfset Session.messageEchec="">
              					
									<div class="blocchamp blocchamppleinelargeur">
										<label class="labeldechamp" for="email">Date of gift</label>
										<div class="w-embed champtexte">
											<input type="text" value="<cfoutput>#DateFormat(Session.dateDon, "yyyy-mm-dd")#</cfoutput>" name="dateDon" id="dateDon"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Enter date using format yyyy-mm-dd ')" onchange="try{setCustomValidity('')}catch(e){}"/>
										</div>
			 						</div>
			 						<div class="blocchamp">
			 							<!--- fenetre modale --->
										<!--- CODE POUR FENETRE DONATEURS CACHEE PAR DEFAUT --->
										<div id="donateurlien1" Style="display:<CFIF Session.affichageDonateurs>bock<CFELSE>none</CFIF>;">
											<label class="labeldechamp" for="numdonateur">Donor # 
											<a href="#" class="lienbleu" onClick="blocking('donorslist');blocking('donateurlien1');blocking('donateurlien2'); return false;">(<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche")>view<cfelse>hide</cfif>&nbsp;list)</a>
											</label>
										</div>
										<div id="donateurlien2" Style="display:<CFIF Session.affichageDonateurs>none<CFELSE>block</CFIF>;">
											<label class="labeldechamp" for="numdonateur">Donor # 
											<a href="#" class="lienbleu" onClick="blocking('donorslist');blocking('donateurlien1');blocking('donateurlien2'); return false;">(<CFIF StructKeyExists(URL, "tri") OR StructKeyExists(Form, "recherche")>hide<cfelse>view</cfif>&nbsp;list)</a>
											</label>
										</div>
										
										<input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="256" name="numero" required="" type="text" value="<cfoutput>#numero#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Enter donor number')" onchange="try{setCustomValidity('')}catch(e){}" >
										<!--- <CFDIV bind="cfc:cfc.donateurs.donateurNomParNumero('#Session.utilisateur.organismeID#',{numero})" bindonload="false" class="textesouschamp" ></CFDIV> --->
										<!--- LE NOM DU DONATEUR DISPONIBLE UNIQUEMENT POUR ADMIN -NIVEAU 2 --->
										<CFIF listFind("0,1,2",Session.utilisateur.statut)>
											<div id="nomParNumero" class="textesouschamp"></div>
										</CFIF>
									</div>
			 						<div class="blocchamp">
			 							<!--- fenetre modale --->
										<!--- <label class="labeldechamp" for="numcompte"><a href="#" class="lienbleu" data-ix="apparition-modal-comptes">Account #:</a></label> --->
										
										<div id="comptelien1" Style="display:block;">
											<label class="labeldechamp" for="numcompte">Account # <a href="#" class="lienbleu" onClick="blocking('accountslist');blocking('comptelien1');blocking('comptelien2'); return false;">(hide list)</a></label>
										</div>
										<div id="comptelien2" Style="display:none;">
											<label class="labeldechamp" for="numcompte">Account # <a href="#" class="lienbleu" onClick="blocking('accountslist');blocking('comptelien1');blocking('comptelien2'); return false;">(view list)</a></label>
										</div>
										<input autofocus="autofocus" class="w-input champtexte" data-name="noCompte" id="noCompte" maxlength="256" name="noCompte" required="" type="text" value="<cfoutput>#noCompte#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Enter account number')" onchange="try{setCustomValidity('')}catch(e){}">
										<!--- <CFDIV bind="cfc:cfc.comptes.compteNomParNumero('#Session.utilisateur.organismeID#',{noCompte})" bindonload="false" class="textesouschamp"></CFDIV> --->
										<div id="nomParCompte" class="textesouschamp"></div>
									</div>
									<!--- ESSENTIEL POUR EVITER LE DESENLIGNEMENT SI SEULEMENT UN DES CFDIV NE S'AFFICHE PAS --->
									<div class="blocchamp blocchamppleinelargeur doubleseparateur"></div>
									<div class="blocchamp">
										<label class="labeldechamp" for="montantdon">Gift amount</label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="montant" id="montant" maxlength="256" name="montant" required="" type="text" value="<cfoutput>#DecimalFormat(montant)#</cfoutput>" pattern="-?(0\.((0[1-9]{1})|-?([1-9]{1}([0-9]{1})?)))|-?(([1-9]+[0-9]*)(\.([0-9]{1,2}))?)" oninvalid="setCustomValidity('Enter gift amount')" onchange="try{setCustomValidity('')}catch(e){}">
			 						</div>
			 						<div class="blocchamp">
										<label class="labeldechamp" for="description">Description</label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="description" id="description" maxlength="256" name="description"  type="text" value="<cfoutput>#description#</cfoutput>">
			 						</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<label class="labeldechamp" for="method">Payment Method</label>
										<div class="w-embed champtexte">
											<select name="methodeDonID" id="methodeDonID">
												<option value="">Select</option>
												<cfloop query="methodesDon">
													<option value="<cfoutput>#methodesDon.methodeDonID#</cfoutput>" <cfif methodesDon.methodeDonID EQ thisMethodeDonID>selected</cfif> ><cfoutput>#methodesDon.methode#</cfoutput></option>
												</cfloop>
											</select>
										</div>
			 						</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<CFIF isDefined('URL.DID')>
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
												<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="modification" type="submit" value="Modifier le don">	
			 								</div>
										<CFELSE>
											<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="submit" value="Confirm and add another gift">
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
													
												<div class="petittextegris"><strong>Repeat fields: </strong></div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep date" id="repdate" name="repdate" checked="#Session.repdate EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Date-du-don">Date of gift</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep donateur" id="repDonateur" name="repDonateur" checked="#Session.repDonateur EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Num-du-donateur">Donor #</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep no compte" id="repCompte" name="repCompte" checked="#Session.repCompte EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="Num-de-compte">Account #</label>
				  									</div>
				  									<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep description" id="repDescription" name="repDescription" checked="#Session.repDescription EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="description">Description</label>
				  									</div>
													<div class="w-checkbox w-clearfix champcheckbox">
					 									<cfinput class="w-checkbox-input" data-name="Rep mode" id="repMode" name="repMode" checked="#Session.repMode EQ 'True'#" type="checkbox">
					 									<label class="w-form-label petittextegris" for="mode">Method</label>
				  									</div>
												</div>
												
			 								</div>
											<div class="blocchamp blocchamppleinelargeur doubleseparateur">
											
												<div class="w-checkbox w-clearfix champcheckbox">
													<cfinput class="w-checkbox-input" data-name="defaut donateurs" id="affichageDonateurs" name="affichageDonateurs" checked="#Session.affichageDonateurs EQ 'True'#" type="checkbox" onClick="blocking('donorslist');blocking('donateurlien1');blocking('donateurlien2'); ">
													<label class="w-form-label petittextegris" for="donateurs">Display the list of default donors by default</label>
												</div>
												
			 								</div>
			 							</CFIF>
		  							
									</div><!--- <div class="blocchamp blocchamppleinelargeur"> --->
								</cfform>
							</CFIF>
	 					</div><!--- <div class="w-form"> --->
  					</div><!--- <div class="blocfondblanc"> --->
				</div><!--- <div class="w-container containerprincipal"> --->
				
				
				
				
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<!--- <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script> --->
			<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
			<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
			
			
			
 		</body>
	 </html>
	 
	<script type='text/javascript'>
		function showHideTut() {
        var x = document.getElementById("videoTut");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
            y.style.display = "block";
        }
    }
	</script>
	 
	
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

