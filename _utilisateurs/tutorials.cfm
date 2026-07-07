<CFTRY>
	
	<CFSET VARIABLES.title_fr = "DDR TUTORIELS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/tutoriels">
	<CFSET VARIABLES.title_en = "DDR TUTORIALS">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/tutorials">
	
	
	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
	<head>
		<CFINCLUDE TEMPLATe="../_head.inc">
	</head>

	<body class="stylebody">
	
	<CFINCLUDE TEMPLATe="_menu.inc">
			
	<div class="w-section sectionsousheader">
		<div class="w-container containersousheader">
			<div class="wrappersousheader">
				<h3 class="headingbreadcrumb"><CFIF Session.langue EQ "fr">Bienvenue<CFELSE>Welcome</CFIF> <cfoutput>#Session.utilisateur.prenom# #Session.utilisateur.nom# (#Session.utilisateur.organisme#)</cfoutput> </h3>
				
			</div>
		</div>
	</div>
	<div class="w-section sectioncontenuprincipal">
			
		<div class="w-container containerprincipal">
			<div class="blocfondblanc">
				<CFIF Session.langue EQ "fr">
					<img src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriels.png" width="160"> 
				<CFELSE>
					<img src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorials.png" width="160"> 
				</CFIF>
			</div>
		</div>

		<!--- VIDEOS TUTORIALS (ROW 1)--->
		<div class="w-container containerprincipal">
			<div class="blocfondblanc">
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/F5IPlR8y0vE?si=1ZE2P4gMhI212tk7<CFELSE>https://www.youtube.com/embed/Omx1mxamnpc?si=n12H-sMY571LXYf1</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr">COMMENT CONFIGURER LE DDR2<CFELSE>HOW TO SET UP THE DDR2</CFIF></h3>
				</div> 
			</div>  
			<div class="blocfondblanc">
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/8r2LfFsKUk0?si=Q9ApcZ15YcqMymBC<CFELSE>https://www.youtube.com/embed/rxhgrNkMVD8?si=GdIbRtyfvOhb5PfM</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr"><a href="/fr/secure/ajout-compte">COMMENT AJOUTER UN COMPTE</a><CFELSE><a href="/en/secure/add-account">HOW TO ADD AN ACCOUNT ON THE DDR2</a></CFIF></h3>
				</div> 
			</div>
			<div class="blocfondblanc">
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/6EIju80WLMI?si=FdYWi6wc6fP-7GJ8<CFELSE>https://www.youtube.com/embed/4DZpGi5pMGU?si=Ar7hXCsnmJXbN2W4</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr"><a href="/fr/secure/ajout-donateur">COMMENT AJOUTER UN DONATEUR</a><CFELSE><a href="/en/secure/add-donor">HOW TO ADD DONORS ON THE DDR2</a></CFIF></h3>
				</div> 
			</div>
		</div>
		
		<!--- VIDEOS TUTORIALS (ROW 2)--->
		<div class="w-container containerprincipal">
			<div class="blocfondblanc"> 
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/dLTi4JbE0X4?si=3mfZmCfIguQfB3Ke<CFELSE>https://www.youtube.com/embed/xFQLk-BR63o?si=z8BDkqgBzrdw4GiF</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr"><a href="/fr/secure/ajout-donateur">COMMENT AJOUTER UN DON</a><CFELSE><a href="/en/secure/add-gift">HOW TO ADD GIFTS ON THE DDR2</a></CFIF></h3>
				</div> 
			</div>  
			<div class="blocfondblanc">
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/hV57lDcwSF8?si=UNkZ9gLMmlOKIoeC<CFELSE>https://www.youtube.com/embed/4GFgmdr4qRY?si=P7lJ8pVapTmNW6i_</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr"><a href="/fr/secure/rapport-dons">COMMENT SORTIR UN RAPPORT</a><CFELSE><a href="/en/secure/report-gifts">HOW TO PRODUCE REPORTS ON THE DDR2</a></CFIF></h3>
				</div> 
			</div>
			<div class="blocfondblanc">
				<iframe width="100%" height="180" src="<CFIF Session.langue EQ "fr">https://www.youtube.com/embed/rx0MLyQCHjo?si=D-5GUGrCV-puZ52U<CFELSE>https://www.youtube.com/embed/4PkcDFd9g94?si=_T0_afDvGich2Mbj</CFIF>" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
				<div class="containerliens">
					<h3 class="h3boite"><CFIF Session.langue EQ "fr"><a href="/fr/secure/rapport-recus">COMMENT PRODUIRE UN REÇU</a><CFELSE><a href="/en/secure/report-receipts">HOW TO PRODUCE RECEIPTS ON THE DDR2</a></CFIF></h3>
				</div>
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
		<CFINCLUDE TEMPLATE="../_envoi_erreur.inc"> 
		<CFIF Session.langue EQ "fr">
			<CFLOCATION URL="#APPLICATION.Racine#/fr/erreur" ADDTOKEN="NO">
		<CFELSE>
			<CFLOCATION URL="#APPLICATION.Racine#/en/error" ADDTOKEN="NO">
		</CFIF>
	</CFCATCH>
</CFTRY>