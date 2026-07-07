<CFTRY>
	<CFSET VARIABLES.title_fr = "DDR2 Connexion">
	<CFSET VARIABLES.file_name_fr = "#APPLICATION.Racine#/fr/entretien">
	<CFSET VARIABLES.title_en = "DDR Login">
	<CFSET VARIABLES.file_name_en = "#APPLICATION.Racine#/en/maintenance">
		
	

<!DOCTYPE html>
<!-- This site was created in Webflow. http://www.webflow.com-->
<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->

<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5762c676d86198e52416ed61">
	<head>
		<CFINCLUDE TEMPLATe="_head.inc">
	</head>

	
	<body class="stylebody">
		
		<CFIF Session.langue EQ "fr">
			<div class="w-section sectionheader">
				<div class="w-container containerheader">
					<div class="w-row">
						<div class="w-col w-col-8 w-col-stack w-clearfix">
							<div class="w-nav containerheadercolonne1" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
								<div class="w-container navigationddr">
									<a class="w-nav-brand" href="#"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png"></a>
								</div>
								<div class="w-nav-button hamburgermenu">
									<div class="w-icon-nav-menu"></div>
								</div>
							</div>
						</div>
						<div class="w-col w-col-4 w-col-stack colonne2menuprincipal">
							
							<!--- LANGUES --->
							<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
								<div class="w-dropdown-toggle containerselecteurlangue">
									<div>Fran&ccedil;ais</div>
									<div class="w-icon-dropdown-toggle"></div>
								</div>
								<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_en#</cfoutput>">English</a>
								</nav>
							</div>
							
						</div>
					</div>
				</div>
			</div>
			
		<CFELSE>
			<div class="w-section sectionheader">
				<div class="w-container containerheader">
					<div class="w-row">
						<div class="w-col w-col-8 w-col-stack w-clearfix">
							<div class="w-nav containerheadercolonne1" data-animation="default" data-collapse="medium" data-contain="1" data-duration="400">
								<div class="w-container navigationddr">
									<a class="w-nav-brand" href="#"><img class="logoddr" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/CQOC-DDR2_vert.png">
									</a>
								</div>
								<div class="w-nav-button hamburgermenu">
									<div class="w-icon-nav-menu"></div>
								</div>
							</div>
						</div>
						<div class="w-col w-col-4 w-col-stack colonne2menuprincipal">
							
							<!--- LANGUES --->
							<div class="w-dropdown selecteurlangue" data-delay="0" data-hover="1">
								<div class="w-dropdown-toggle containerselecteurlangue">
									<div>English</div>
									<div class="w-icon-dropdown-toggle"></div>
								</div>
								<nav class="w-dropdown-list containterparametresmenu"><a class="w-dropdown-link liselecteurlangue" href="<cfoutput>#file_name_fr#</cfoutput>">Fran&ccedil;ais</a>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</div>
		</CFIF>
	
		
		<div class="w-section sectioncontenuprincipal">
			
  			<div class="w-container containerprincipal"> 
	 			<div class="blocfondblanc fondbleu">
	 				<CFIF Session.langue EQ "fr">
						<img class="loginlogo" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/DDR2_blanc.png" TITLE="Logo DDR2">
						<h1 STYLE="color:#fff;text-align:center;padding:6px;">MAINTENANCE</h1>
						
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>Nous sommes dans l'&eacute;tape finale de la migration du DDR2 vers un serveur qui r&eacute;pond aux crit&egrave;res de s&eacute;curit&eacute; les plus actuels. C'est une &eacute;tape d&eacute;licate qui requiert que l'on ferme le site pour une courte p&eacute;riode . </em></p>
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>Toujours dans le but de mieux vous servir . </em></p>
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>Merci de votre compr&eacute;hension !<br />L'&eacute;quipe du CQOC</em></p>
						
					<CFELSE>
						<img class="loginlogo" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/DDR2_blanc.png" TITLE="DDR logo">
						<h1 STYLE="color:#fff;text-align:center;padding:6px;">MAINTENANCE</h1>
						
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>We are in the final stage of migrating DDR2 to a server that meets the most up-to-date security criteria. This is a delicate step that requires us to close the site for a short period of time.  </em></p>
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>Always with the aim of serving you better .</em></p>
						<p STYLE="color:#fff;text-align:left;padding:6px;font-size:14px;"><em>Thank you for your understanding!<br />The CQOC team</em></p>

						
						
						
					</CFIF>
	 			</div><!--- <div class="blocfondblanc fondbleu"> --->
  			</div><!--- <div class="w-container containerprincipal"> --->
		</div><!--- <div class="w-section sectioncontenuprincipal"> --->
		
		<CFINCLUDE TEMPLATe="_footer.inc">
		
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
		<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
		<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
	</body>
</html>
	<CFCATCH>
		
		<CFINCLUDE TEMPLATE="_envoi_erreur.inc"> 
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