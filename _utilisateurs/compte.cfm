<CFTRY>
	<CFIF isDefined('URL.CID')>
		<CFSET VARIABLES.title_en = "DDR EDIT ACCOUNT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/edit-account-#URL.CID#">
		<CFSET VARIABLES.title_fr = "DDR COMPTE EDITION">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/editer-compte-#URL.CID#">
	<CFELSE>
		<CFSET VARIABLES.title_en = "DDR ADD ACCOUNT">
		<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/add-account">
		<CFSET VARIABLES.title_fr = "DDR COMPTE AJOUT">
		<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/ajout-compte">
	</CFIF>
	
	<CFParam name="noCompte" default="">
	<CFParam name="nom" default="">
	<CFParam name="recu" default="0">
	<CFParam name="organismeID" default="#Session.utilisateur.organismeID#">
	<CFParam name="Session.message" default="">
	<CFParam name="Session.messageEchec" default="">
	
	<!--- AJOUT --->
	<CFIF isDefined('Form.ajout')>
		<CFIF isDefined('Form.recu')>
			<cfset Form.recu = "True">
		<CFELSE>
			<cfset Form.recu = "False">
		</CFIF>
		<cfinvoke component="#APPLICATION.cfcComptes#" method = "compteAjout" returnvariable ="cid">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="noCompte" value="#Form.noCompte#">
			<cfinvokeargument name="nom" value="#Form.nom#">
			<cfinvokeargument name="recu" value="#Form.recu#">
		</cfinvoke>
			
		<!--- <CFIF cid EQ 0>
					<CFIF session.langue EQ "fr">
						<CFSET Session.messageEchec = "Le num&eacute;ro de compte existe d&eacute;j&agrave;.">
					<CFELSE>
						<CFSET Session.messageEchec = "The account number already exists.">
					</CFIF>
					<cfset Session.message="">
				<CFELSE>
					<CFIF session.langue EQ "fr">
						<CFSET Session.message = "Le compte a &eacute;t&eacute; enregistr&eacute; avec succ&egrave;s.">
					<CFELSE>
						<CFSET Session.message = "The account has been successfully created.">
					</CFIF>
					<cfset Session.messageEchec="">
					
				</CFIF>	 --->
		
		<cfset noCompte =Form.noCompte>
		<cfset nom =Form.nom>
		<cfset recu =Form.recu >
		
		<CFIF Session.langue EQ "fr">
			<CFIF cid NEQ 0>
				<cfset Session.message="Le compte a &eacute;t&eacute; enregistr&eacute; avec succ&egrave;s.">
				<cfset Session.messageEchec="">
				<CFLOCATION URL="#APPLICATION.Racine#/fr/secure/editer-compte-#cid#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="Le num&eacute;ro de compte existe d&eacute;j&agrave;.">
			</CFIF>
		<CFELSE>
			<CFIF cid NEQ 0>
				<cfset Session.message="The account has been successfully created.">
				<cfset Session.messageEchec="">
				<CFLOCATION URL="#APPLICATION.Racine#/en/secure/edit-account-#cid#" ADDTOKEN="NO">
			<CFELSE>
				<cfset Session.message="">
				<cfset Session.messageEchec="The account number already exists.">
			</CFIF>
		</CFIF>
	</CFIF>
	
	<!--- MISE A JOUR --->
	<CFIF isDefined('Form.modification')>
		<CFIF isDefined('Form.recu')>
			<cfset Form.recu = "True">
		<CFELSE>
			<cfset Form.recu = "False">
		</CFIF>
		<cfinvoke component="#APPLICATION.cfcComptes#" method = "compteEdition" returnvariable ="message">
			<cfinvokeargument name="noCompte" value="#Form.noCompte#">
			<cfinvokeargument name="nom" value="#Form.nom#">
			<cfinvokeargument name="recu" value="#Form.recu#">
			<cfinvokeargument name="compteID" value="#URL.CID#">
		</cfinvoke>
		<cfset Session.message=message>
		<cfset Session.messageEchec="">
	</CFIF>
	
	
	<CFIF isDefined('URL.CID')>
	
		<cfinvoke component="#APPLICATION.cfcComptes#" method = "CompteInfos" returnvariable ="compte">
			<cfinvokeargument name="compteID" value="#URL.CID#">
		</cfinvoke>
		<cfset noCompte =compte.noCompte >
		<cfset nom =compte.nom >
		<cfset recu =compte.recu >
	<CFELSE>
		<cfset Session.message="">	
		<cfset Session.messageEchec="">
	</CFIF>
	
	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<!--- <div class="w-section sectionsousheader">
							<div class="w-container containersousheader">
				 				<div class="wrappersousheader">
				 					<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Dons &gt; Ajouter un compte</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Gifts &gt; Add an account</h3>
									</CFIF>
				 				</div>
			  				</div>
						</div> --->
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-dons.inc">
	
  				<div class="w-container containerprincipal">
	 				<div class="blocfondblanc">
						
						<!--- LIEN VERS LES TUTORIELS --->
						<CFIF session.langue EQ "fr">
							<button style="background-color: white;" onClick="showHideTut()">
								<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriel.png">
							</button>
							<div id="videoTut" style="display: none;">
								<iframe width="90%" height="400" src="https://www.youtube.com/embed/8r2LfFsKUk0?si=Q9ApcZ15YcqMymBC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
							</div>
						<CFELSE>
							<button style="background-color: white;" onClick="showHideTut()">
								<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorial.png">
							</button>
							<div id="videoTut" style="display: none;">
								<iframe width="90%" height="400" src="https://www.youtube.com/embed/rxhgrNkMVD8?si=GdIbRtyfvOhb5PfM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
							</div>
						</CFIF>
						
						<div class="w-form">
							<CFIF session.langue EQ "fr">
		  						<cfform class="blocformulaireajouterdon" data-name="Email Form" ACTION="#file_name_fr#" id="don-form" name="don-form" METHOD="POST">
		
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
								
			 						
			 						<div class="blocchamp">
										<label class="labeldechamp" for="numdonateur"># compte :</label>
										<!--- <input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="256" name="numero" required="required" type="text" value="<cfoutput>#numero#</cfoutput>"> --->
										<input autofocus="autofocus" class="w-input champtexte" data-name="noCompte" id="noCompte" maxlength="256" name="noCompte" required="" type="text" value="<cfoutput>#noCompte#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Veuillez entrer le no du compte')" onchange="try{setCustomValidity('')}catch(e){}" >		
			 						</div>
			 						<div class="blocchamp">
										<label class="labeldechamp" for="numcompte">Libell&eacute; du compte :</label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="nom" id="nom" maxlength="100" name="nom" required="" type="text" value="<cfoutput>#nom#</cfoutput>" pattern="[a-zA-Z0-9�����������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Veuillez entrer le libell&eacute; du compte')" onchange="try{setCustomValidity('')}catch(e){}">
										
									</div>
									<div class="blocchamp">
              						<div class="w-checkbox">
                						<!--- <input class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" > --->
                						<cfinput class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" checked="#recu EQ 'True'#">
                						<label class="w-form-label" for="checkbox">Cocher pour associer ce compte à l'&eacute;mission de re&ccedil;us</label>
              						</div>
            					</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<CFIF isDefined('URL.CID')>
											<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="modification" type="submit" value="Modifier ce compte">	
			 								
										<CFELSE>
											<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="ajout" type="submit" value="Ajouter ce compte">	
			 								
			 							</CFIF>
									</div><!--- <div class="blocchamp blocchamppleinelargeur"> --->
								</cfform>
							<CFELSE>
								<cfform class="blocformulaireajouterdon" data-name="Email Form" ACTION="#file_name_en#" id="don-form" name="don-form" METHOD="POST">
		
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
								
			 						
			 						<div class="blocchamp">
										<label class="labeldechamp" for="numdonateur">Account #:</label>
										<!--- <input autofocus="autofocus" class="w-input champtexte" data-name="numero" id="numero" maxlength="256" name="numero" required="required" type="text" value="<cfoutput>#numero#</cfoutput>"> --->
										<input autofocus="autofocus" class="w-input champtexte" data-name="noCompte" id="noCompte" maxlength="256" name="noCompte" required="" type="text" value="<cfoutput>#noCompte#</cfoutput>" pattern="[0-9]+" oninvalid="setCustomValidity('Please enter the account number')" onchange="try{setCustomValidity('')}catch(e){}" >		
			 						</div>
			 						<div class="blocchamp">
										<label class="labeldechamp" for="numcompte">Account name:</label>
										<input autofocus="autofocus" class="w-input champtexte" data-name="nom" id="nom" maxlength="100" name="nom" required="" type="text" value="<cfoutput>#nom#</cfoutput>" pattern="[a-zA-Z0-9�����������������������������������������������������ݟƌ._-\s]+" oninvalid="setCustomValidity('Please enter the account name')" onchange="try{setCustomValidity('')}catch(e){}">
										
									</div>
									<div class="blocchamp">
              						<div class="w-checkbox">
                						<!--- <input class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" > --->
                						<cfinput class="w-checkbox-input" data-name="recu" id="recu" name="recu" type="checkbox" checked="#recu EQ 'True'#">
                						<label class="w-form-label" for="checkbox">Check to issue receipt for this account</label>
              						</div>
            					</div>

			 						<div class="blocchamp blocchamppleinelargeur">
										<CFIF isDefined('URL.CID')>
											<input class="w-button boutonvalider" data-wait="Please wait..." name="modification" type="submit" value="Edit this account">	
			 								
										<CFELSE>
											<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="submit" value="Add this account">	
			 								
			 							</CFIF>
									</div><!--- <div class="blocchamp blocchamppleinelargeur"> --->
								</cfform>
							</CFIF>
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