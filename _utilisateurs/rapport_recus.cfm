<cfsetting RequestTimeout = "600">
<CFTRY>
	<cfset newLocal = SetLocale("English (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR TAX RECEIPTS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-receipts">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT REÇUS POUR FIN D'IMPÔT">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-recus">
	
	<CFParam name="message" default="">

	<cfset anneeDerniere=DateAdd("yyyy",-1, Now())>
	<cfset anneeDebut=DatePart("yyyy", anneeDerniere)>

	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="tousDonateurs">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
	</cfinvoke>
	<CFQUERY NAME="premier" dbtype="query">
		SELECT  Min(numero) as premier 
 		FROM tousDonateurs
	</CFQUERY>
	<CFQUERY NAME="dernier" dbtype="query">
		SELECT  Max(numero) as dernier 
 		FROM tousDonateurs
	</CFQUERY>

	<CFPARAM name="Form.dateDebut" default="#anneeDebut#-01-01">
	<CFPARAM name="Form.dateFin" default="#anneeDebut#-12-31">
	<CFParam name="annee" default="#anneeDebut#">
	<CFParam name="Form.sansCourriel" default="no">
	<CFParam name="Form.donateurs" default="tous">
	<CFParam name="Form.debut" default="#premier.premier#">
	<CFParam name="Form.fin" default="#dernier.dernier#">
	<CFParam name="Form.tri" default="nom">

	
	<CFIF StructKeyExists(Form, 'resetNoDonateurs')>
		<CFSET Form.debut = premier.premier>
		<CFSET Form.fin = dernier.dernier>
	</CFIF>

	<cfinvoke component="#APPLICATION.cfcRapports#" method = "RecusDonateurs" returnvariable ="DecompteDonateurs">
		<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
		<cfinvokeargument name="dateFin" value="#Form.dateFin#">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="sansCourriel" value="#Form.sansCourriel#">
		<cfinvokeargument name="debut" value="#Form.debut#">
		<cfinvokeargument name="fin" value="#Form.fin#">
		<cfinvokeargument name="tri" value="#Form.tri#">
	</cfinvoke>
	
	
	<CFIF StructKeyExists(Form, 'rapport')>
		<cfset annee=DatePart("yyyy", Form.dateDebut)>
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<!--- <cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusDonateursDates" returnvariable ="ListeDonateurs">
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="donateurs" value="#Form.donateurs#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
			<cfinvokeargument name="tri" value="#Form.tri#">
		</cfinvoke>	 --->	
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RecusDonateurs" returnvariable ="ListeDonateurs">
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="sansCourriel" value="#Form.sansCourriel#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
			<cfinvokeargument name="tri" value="#Form.tri#">
		</cfinvoke>
		
		
		<CFIF ListeDonateurs.recordcount NEQ 0>
			
			<cfset annee=DatePart("yyyy", Form.dateDebut)>
			<CFSET dateCreation = Now()>
			<cfset dateDebut=Form.dateDebut>
			<cfset dateFin=Form.dateFin>
			<cfset donateurs=Form.donateurs>
			<cfset debut=Form.debut>
			<cfset fin=Form.fin>
			<cfset tri=Form.tri>
			<!--- A PARTIR DE LA PAGE 2 JE DOIS RAJOUTER UN ESPACE EN HAUT DE PAGE <br STYLE="line-height:75%"> --->
			<!--- SI JE PLACE UN PAGEBREAK J'OBTIENS DES PAGES BLANCHES ---> 
			<cfset page=1>
			<!--- <cfoutput>#ListeDonateurs.recordcount#</cfoutput> --->
			<CFINCLUDE TEMPLATE="rapport_recus_#organisme.devise#_#session.langue#.inc">
			
		<CFELSE>
			<CFIF session.langue EQ "fr">
				<cfset message = "Impossibilité de générer un rapport de reçus <br>puisqu'il n'y a aucun don inscrit selon les critères demandés (dates, donateurs).">
			<CFELSE>
				<cfset message = "We can't generate a Receipt's Report <br>since no gifts are registered according to the required criteria (dates, donors)">
			</CFIF>
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
			div#tipDiv {
				background-color:#E1E5F1; 
				border:1px solid #667295;
				padding:4px;
				width:200px;
			}
			</style>
			<script src="/js/dw_tooltip_c.js" type="text/javascript"></script>
			<script type="text/javascript">
				/* 2 functions that can be used to vary tooltip width according to image width:
				dw_Tooltip.wrapImageToWidth and dw_Tooltip.wrapToWidth
				See www.dyn-web.com/code/tooltips/documentation2.php#wrapFn for info */
				dw_Tooltip.defaultProps = {
					//supportTouch: true, // set false by default
					wrapFn: dw_Tooltip.wrapImageToWidth
				}

				// Problems, errors? See http://www.dyn-web.com/tutorials/obj_lit.php#syntax

				dw_Tooltip.content_vars = {
					L1: {
						img: '/images/ie_print.png',
						w: 596, // width of image
						h: 536 // height of image

					},
					L2: {
						img: '/images/chrome_print.png',
						w: 314,
						h: 564
					},
					L3: {
						img: '/images/safari_print.png',
						w: 687,
						h: 460
					}
				}

				function afficherAvertissement() {
					var text = document.getElementById("avertissement");
					text.style.display = "block";
					}
			</script>
			
			
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc"> 
	
			<div class="w-section sectioncontenuprincipal">
			
				<!--- <CFINCLUDE TEMPLATe="_sous-menu-rapports.inc"> --->
				<CFINCLUDE TEMPLATe="_sous-menu-generateur-recus.inc">
				
				<div class="w-container containerprincipal">
      			<div class="blocfondblanc">
      				
        				<div class="containertyperapport">
          				<div class="titretyperapport">
          					<CFIF session.langue EQ "fr">
								<strong>GÉNÉRATEUR DE REÇUS D'IMPÔT POUR IMPRESSION(PDF)</strong>
							<CFELSE>
								<strong>GENERATOR OF INCOME TAX RECEIPTS FOR PRINTING(PDF)</strong>
							</CFIF>
          					
          				</div>
        				</div>
						
						<!--- LIEN VERS LES TUTORIELS --->
						<CFIF session.langue EQ "fr">
							<button style="background-color: white; padding-bottom: 20px;" onClick="showHideTut()">
								<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriel.png">
							</button>
							<div id="videoTut" style="display: none;">
								<iframe width="90%" height="400" src="https://www.youtube.com/embed/rx0MLyQCHjo?si=D-5GUGrCV-puZ52U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
							</div>
						<CFELSE>
							<button style="background-color: white; padding-bottom: 20px;" onClick="showHideTut()">
								<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorial.png">
							</button>
							<div id="videoTut" style="display: none;">
								<iframe width="90%" height="400" src="https://www.youtube.com/embed/4PkcDFd9g94?si=_T0_afDvGich2Mbj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
							</div>
						</CFIF>
						
        				<div class="w-form">
        					<div align="center">
        						<table style="width:60%;border:solid 1px #ccc;font-size:9pt;">
        							<tr style-"padding-top: 15px;">
        								<td align="center" colspan="3">
        									<CFIF session.langue EQ "fr">
        										<span style="color:red;">*** ATTENTION ***</SPAN><br>
												UTILISER UNIQUEMENT UN DES FURETEURS SUIVANTS POUR GÉNÉRER VOS REÇUS<br>
												(Évitez d'utiliser Edge ou Firefox)
        									<CFELSE>
												<span style="color:red;">*** WARNING ***</SPAN><br>
        										USE ONLY ONE OF THE FOLLOWING BROWSERS TO GENERATE YOUR RECEIPTS<br>
												(Avoid using Edge or Firefox)
        									</CFIF>
        								</td>
        							</tr>
        							<tr>
										<td align="center" style="width:33%;font-size:9pt;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/ie_logo.png">
        									Internet Explorer<br>
											<a href="#" class="showTip L1"><CFIF session.langue EQ "fr">Réglages imprimante<cfelse>Printer Settings</cfif></a>
        								</td>
        								<td align="center" style="width:33%;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/chrome_logo.png">
        									Google Chrome<br>
											<a href="#" class="showTip L2"><CFIF session.langue EQ "fr">Réglages imprimante<cfelse>Printer Settings</cfif></a>
        								</td>
										<td align="center" style="width:33%;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/safari_logo.png"> 
        									Safari<br>
											<a href="#" class="showTip L3"><CFIF session.langue EQ "fr">Réglages imprimante<cfelse>Printer Settings</cfif></a>
        								</td>
        							</tr>
        						</table>
        					</div>

        					<CFIF session.langue EQ "fr">
								
								<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_fr#" METHOD="POST">

									<cfif message NEQ "">
										<label class="labeldechamp" for="message" style="color:red;"><cfoutput>#message#</cfoutput></label>
									</cfif>
									<label class="labeldechamp" for="numdonateur" style="background-color: #FFF;border-top: 1px solid rgba(55, 55, 55, 0.15);">
										<cfif DecompteDonateurs.recordcount GT 500>
											<div style="color:red;">
												Votre sélection résulte en <cfoutput>#DecompteDonateurs.recordcount#</cfoutput> donateurs<br>
												<span style="font-size:12px;">
													Pour un résultat optimal, limiter le nombre de donateurs à un maximum de 500 par génération de reçus.<BR>
													Vous pouvez réduire le nombre de donateurs en modifiant la sélection par numéro de donateur.
												</span>
											</div>
										<cfelse>
											Votre sélection résulte en <cfoutput>#DecompteDonateurs.recordcount#</cfoutput> donateurs
										</cfif>
									</label>
									
									<div class="selectionperiode" >
										<label class="labeldechamp" for="periode" style="margin:0px 10px;">Pour la période allant du</label>
										<div class="w-embed champtexte">
											<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){};this.form.submit()" style="margin:0;padding:0;width:140px;"/>
										</div>
										<label class="labeldechamp" for="email" style="margin:0px 10px;">au</label>
										<div class="w-embed champtexte">
											<input type="text" value="<cfoutput>#DateFormat(DateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){};this.form.submit()" style="margin:0;padding:0;width:140px;"/>
										</div>
									</div>

									<div class="bloccheckbox">
										<div class="w-checkbox w-clearfix">
											<div class="w-radio champradiobutton radiobuttonpadding" style="text-align:left;">
												<cfinput class="w-radio-input"  data-name="sansCourriel" id="sansCourriel" name="sansCourriel" type="radio" value="no" checked="#form.sansCourriel EQ 'no'#" onclick="this.form.submit();">
												<label class="w-form-label" for="donateurstous"  >Tous les donateurs</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding"  style="text-align:left;">
												<cfinput class="w-radio-input"  data-name="sansCourriel" id="sansCourriel" name="sansCourriel" type="radio" value="yes" checked="#form.sansCourriel EQ 'yes'#" onclick="this.form.submit();">
												<label class="w-form-label" for="donateurstous">Donateurs sans adresse courriel <span style="font-size:12px;">(qui ne peuvent recevoir de reçus courriel)</span></label>
											</div>
										</div>
									</div>

									<div class="blocradiobuttons" style="background-color: rgba(55, 55, 55, .05);">
										<label class="labeldechamp" for="periode" style="margin:0px 10px;">Sélection par numéro de donateur</label>
										<div class="selectionnumdonateurs" >
											<label class="labeldechamp" for="Debut">De :</label>
											<input class="w-input champnumdonateur" data-name="Debut" id="debut" maxlength="256" name="debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>" onchange="this.form.submit();">
											<label class="labeldechamp" for="Fin">à :</label>
											<input class="w-input champnumdonateur" data-name="Fin" id="fin" maxlength="256" name="fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>" onchange="this.form.submit();">
										</div>
										<button class="w-button boutonselectionneur" name="resetNoDonateurs" type="submit" onclick="this.form.submit();">Réinitialiser</button>
									</div>
								
									<label class="labeldechamp" for="numdonateur">Tri</label>
									<div class="selectionneurdate">
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton radiobuttonpadding" >
											<cfinput class="w-radio-input" data-name="tri" id="trinom" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#" onchange="try{setCustomValidity('')}catch(e){};this.form.submit()">
											<label class="w-form-label" for="donateurstous">par nom</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding">
											<cfinput class="w-radio-input"  data-name="tri" id="trinumero" name="tri" type="radio" value="numero" checked="#tri EQ 'numero'#">
											<label class="w-form-label" for="donateursselection">par numéro</label>
											</div>
										</div>
									</div>
								
									<div class="blocchamp blocchamppleinelargeur">
										<cfif DecompteDonateurs.recordcount GT 500>
											<button class="w-button boutonvalider" name="alerte" type="button" onclick="afficherAvertissement()">Générer les reçus</button>
											<div id="avertissement" style="display: none;color:red;">
												Veuillez limiter le nombre de donateurs à 500
											</div>
										<cfelse>
											<input class="w-button boutonvalider" data-wait="Préparation du rapport en cours" name="rapport" type="submit" value="Générer les reçus" wait="Préparation du rapport en cours">
										</cfif>
									</div>
								</cfform>		
          					<CFELSE>
          				
								<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_en#" METHOD="POST" >
									<cfif message NEQ "">
										<label class="labeldechamp" for="message" style="color:red;"><cfoutput>#message#</cfoutput></label>
									</cfif>
									<label class="labeldechamp" for="numdonateur" style="background-color: #FFF;border-top: 1px solid rgba(55, 55, 55, 0.15);">
										<cfif DecompteDonateurs.recordcount GT 500>
											<div style="color:red;">
												Your selection results in  <cfoutput>#DecompteDonateurs.recordcount#</cfoutput> donors<br>
												<span style="font-size:12px;">
													For best results, limit the number of donors to a maximum of 500 per receipt generation.<BR>
													You can reduce the number of donors by modifying the selection by donor number.
												</span>
											</div>
										<cfelse>
											Your selection results in <cfoutput>#DecompteDonateurs.recordcount#</cfoutput> donors
										</cfif>
									</label>

									<div class="selectionperiode" >
										<label class="labeldechamp" for="periode" style="margin:0px 10px;">Period from</label>
										<div class="w-embed champtexte">
											<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){};this.form.submit()" style="margin:0;padding:0;width:140px;"/>
										</div>
										<label class="labeldechamp" for="email" style="margin:0px 10px;">to</label>
										<div class="w-embed champtexte">
											<input type="text" value="<cfoutput>#DateFormat(DateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){};this.form.submit()" style="margin:0;padding:0;width:140px;"/>
										</div>
									</div>

									<div class="bloccheckbox">
										<div class="w-checkbox w-clearfix">
											<div class="w-radio champradiobutton radiobuttonpadding" style="text-align:left;">
												<cfinput class="w-radio-input"  data-name="sansCourriel" id="sansCourriel" name="sansCourriel" type="radio" value="no" checked="#form.sansCourriel EQ 'no'#" onclick="this.form.submit();">
												<label class="w-form-label" for="donateurstous"  >All donors</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding"  style="text-align:left;">
												<cfinput class="w-radio-input"  data-name="sansCourriel" id="sansCourriel" name="sansCourriel" type="radio" value="yes" checked="#form.sansCourriel EQ 'yes'#" onclick="this.form.submit();">
												<label class="w-form-label" for="donateurstous">Donors without email addresses <span style="font-size:12px;">(who cannot receive email receipts)</span></label>
											</div>
										</div>
									</div>

									<div class="blocradiobuttons" style="background-color: rgba(55, 55, 55, .05);">
										<label class="labeldechamp" for="periode" style="margin:0px 10px;">Selection by donor number</label>
										<div class="selectionnumdonateurs" >
											<label class="labeldechamp" for="Debut">From :</label>
											<input class="w-input champnumdonateur" data-name="Debut" id="debut" maxlength="256" name="debut" placeholder="Donor no." required="required" type="text" value="<cfoutput>#debut#</cfoutput>" onchange="this.form.submit();">
											<label class="labeldechamp" for="Fin">To :</label>
											<input class="w-input champnumdonateur" data-name="Fin" id="fin" maxlength="256" name="fin" placeholder="Donor no." required="required" type="text" value="<cfoutput>#fin#</cfoutput>" onchange="this.form.submit();">
										</div>
										<button class="w-button boutonselectionneur" name="resetNoDonateurs" type="submit" onclick="this.form.submit();">Reset</button>
									</div>
									
									
								
									<label class="labeldechamp" for="numdonateur">Sort</label>
									<div class="selectionneurdate">
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton radiobuttonpadding" >
											<cfinput class="w-radio-input" data-name="tri" id="trinom" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
											<label class="w-form-label" for="donateurstous">by name</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding">
											<cfinput class="w-radio-input"  data-name="tri" id="trinumero" name="tri" type="radio" value="numero" checked="#tri EQ 'numero'#">
											<label class="w-form-label" for="donateursselection">by number</label>
											</div>
										</div>
									</div>
								
									<div class="blocchamp blocchamppleinelargeur">
										<cfif DecompteDonateurs.recordcount GT 500>
											<button class="w-button boutonvalider" name="alerte" type="button" onclick="afficherAvertissement()">Generate Receipts</button>
											<div id="avertissement" style="display: none;color:red;">
												Please limit the number of donors to 500
											</div>
										<cfelse>
											<input class="w-button boutonvalider" data-wait="Please wait..." name="rapport" type="submit" value="Generate Receipts" wait="Please wait...">
										</cfif>
									</div>
								</cfform>		
          					</CFIF>
        				</div>
      				</div>
    			</div>
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