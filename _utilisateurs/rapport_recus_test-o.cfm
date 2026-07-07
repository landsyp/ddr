<CFTRY>

	<cfset newLocal = SetLocale("French (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR RECEIPTS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-receipts-test">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT RE&Ccedil;US">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-recus-test">
	
	<CFParam name="message" default="">
	
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
	<CFParam name="tri" default="nom">
	
	<CFIF isDefined('Form.rapport')>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusDonateursDates" returnvariable ="ListeDonateurs">
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="donateurs" value="#Form.donateurs#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
			<cfinvokeargument name="tri" value="#Form.tri#">
		</cfinvoke>		
		
		<CFIF ListeDonateurs.recordcount NEQ 0>
			
			<cfset annee=DatePart("yyyy", Form.dateDebut)> --->
			<cfset dateDebut=Form.dateDebut>
			<cfset dateFin=Form.dateFin>
			<cfset donateurs=Form.donateurs>
			<cfset debut=Form.debut>
			<cfset fin=Form.fin>
			<cfset tri=Form.tri>
			<!--- A PARTIR DE LA PAGE 2 JE DOIS RAJOUTER UN ESPACE EN HAUT DE PAGE <br STYLE="line-height:75%"> --->
			<!--- SI JE PLACE UN PAGEBREAK J'OBTIENS DES PAGES BLANCHES ---> 
			<cfset page=1>
		
			<CFIF session.langue EQ "fr">
				<CFINCLUDE TEMPLATe="rapport_recus_fr.inc">
			<CFELSE>
				<CFINCLUDE TEMPLATe="rapport_recus_en.inc">
			</CFIF>
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
			<script>
  				$( function() {
    				$( "#dateDebut" ).datepicker({ dateFormat: 'yy-mm-dd' });
    				$( "#dateFin" ).datepicker({ dateFormat: 'yy-mm-dd' });
  				} );
  				</script>
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<!--- <div class="w-section sectionsousheader">
							<div class="w-container containersousheader">
				 				<div class="wrappersousheader">
				 					<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Rapports &gt; Rapport de re&ccedil;us</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Reports &gt; Recipts Report</h3>
									</CFIF>
				 				</div>
			  				</div>
						</div> --->
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-rapports.inc">
				
				<div class="w-container containerprincipal">
      			<div class="blocfondblanc">
      				
        				<div class="containertyperapport">
          				<div class="titretyperapport">
          					<CFIF session.langue EQ "fr">
									<strong>RAPPORT DE RE&Ccedil;US</strong>
								<CFELSE>
									<strong>RECEIPTS' REPORT</strong>
								</CFIF>
          					
          				</div>
        				</div>
        				<div class="w-form">
        					<div align="center">
        						<table style="width:60%;border:solid 1px #ccc;font-size:9pt;">
        							<tr>
        								<td align="center" colspan="3">
        									<CFIF session.langue EQ "fr">
        										COMPATIBILIT&Eacute;
        									<CFELSE>
        										COMPATIBILITY
        									</CFIF>
        								</td>
        							</tr>
        							<tr>
        								<td align="center" style="width:33%;font-size:9pt;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/ie_logo.png">
        									Internet Explorer
        								</td>
        								<td align="center" style="width:33%;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/chrome_logo.png">
        									Google Chrome
        								</td>
        								<td align="center" style="width:33%;">
        									<img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/safari_logo.png">
        									Safari
        								</td>
        							</tr>
        						</table>
        					</div>
        					<CFIF session.langue EQ "fr">
          					<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_fr#" METHOD="POST">
            					
          						<cfif message NEQ "">
          							<label class="labeldechamp" for="message" style="color:red;"><cfoutput>#message#</cfoutput></label>
          						</cfif>
            					
            					<label class="labeldechamp" for="numdonateur">Dates</label>
            					<div class="selectionperiode" style="background-color: #FFF;border-bottom: 1px solid rgba(55, 55, 55, 0.15);">
										<label class="labeldechamp" for="email">De&nbsp;&nbsp;&nbsp;</label>
										<div class="w-embed champtexte">
											<!--- <CFinput type="datefield" value="#DateFormat(dateDebut, "yyyy-mm-dd")#" name="dateDebut" id="dateDebut" mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  style="margin:0;padding:0;width:140px;"/> --->
											<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}"/>
										</div>
										
										<label class="labeldechamp" for="email">&nbsp;&nbsp;&Agrave;&nbsp;&nbsp;&nbsp;</label>
										<div class="w-embed champtexte">
											<!--- <CFinput type="datefield" value="#DateFormat(dateFin, "yyyy-mm-dd")#" name="dateFin" id="dateFin" mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  style="margin:0;padding:0;width:140px;"/> --->
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
                  						<label class="w-form-label" for="donateursselection">Selectionner les donateurs</label>
                						</div>
              						</div>
            					</div>
            					<div class="blocradiobuttons">
              						<div class="selectionnumdonateurs" data-ix="display-none-on-load-2">
                						<label class="labeldechamp" for="Debut">De :</label>
                						<input class="w-input champnumdonateur" data-name="Debut" id="debut" maxlength="256" name="debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>">
                						<label class="labeldechamp" for="Fin">&Agrave; :</label>
                						<input class="w-input champnumdonateur" data-name="Fin" id="fin" maxlength="256" name="fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>">
              						</div>
            					</div>
            				
            					<label class="labeldechamp" for="numdonateur">Tri</label>
            					<div class="selectionneurdate">
              						<div class="containerradiobuttons">
                						<div class="w-radio champradiobutton radiobuttonpadding" >
                  						<cfinput class="w-radio-input" data-name="tri" id="trinom" name="tri" type="radio" value="nom" checked="#tri EQ 'nom'#">
                  						<label class="w-form-label" for="donateurstous">par nom</label>
                						</div>
                						<div class="w-radio champradiobutton radiobuttonpadding">
                  						<cfinput class="w-radio-input"  data-name="tri" id="trinumero" name="tri" type="radio" value="numero" checked="#tri EQ 'numero'#">
                  						<label class="w-form-label" for="donateursselection">par num&eacute;ro</label>
                						</div>
              						</div>
            					</div>
            				
            					<div class="blocchamp blocchamppleinelargeur">
              						<input class="w-button boutonvalider" data-wait="Pr&eacute; du rapport en cours" name="rapport" type="submit" value="G&eacute;n&eacute;rer le rapport" wait="Pr&eacute; du rapport en cours">
            					</div>
          					</cfform>		
          				<CFELSE>
          				
          					<cfform data-name="Rapport Recus" id="rapport-recus" name="rapport-recus" ACTION="#file_name_en#" METHOD="POST">
            					<cfif message NEQ "">
          							<label class="labeldechamp" for="message" style="color:red;"><cfoutput>#message#</cfoutput></label>
          						</cfif>
            					
            					<label class="labeldechamp" for="numdonateur">Dates</label>
            					<div class="selectionperiode" style="background-color: #FFF;border-bottom: 1px solid rgba(55, 55, 55, 0.15);">
										<label class="labeldechamp" for="email">From&nbsp;&nbsp;&nbsp;</label>
										<div class="w-embed champtexte">
											<!--- <CFinput type="datefield" value="#DateFormat(dateDebut, "yyyy-mm-dd")#" name="dateDebut" id="dateDebut" mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  style="margin:0;padding:0;width:140px;"/> --->
											<input type="text" value="<cfoutput>#DateFormat(DateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="yyyy-mm-dd" required pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Please enter date using format yyyy-mm-dd')" onchange="try{setCustomValidity('')}catch(e){}"/>
										</div>
										
										<label class="labeldechamp" for="email">&nbsp;&nbsp;To&nbsp;&nbsp;&nbsp;</label>
										<div class="w-embed champtexte">
											<!--- <CFinput type="datefield" value="#DateFormat(dateFin, "yyyy-mm-dd")#" name="dateFin" id="dateFin" mask="yyyy-mm-dd" placeholder="yyyy-mm-dd"  style="margin:0;padding:0;width:140px;"/> --->
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
              						<input class="w-button boutonvalider" data-wait="Please wait..." name="rapport" type="submit" value="Generate Report" wait="Please wait...">
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