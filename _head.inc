	<meta charset="utf-8">
	<title><CFIF Session.langue EQ "fr"><cfoutput>#VARIABLES.title_fr#</cfoutput><CFELSE><cfoutput>#VARIABLES.title_en#</cfoutput></CFIF></title>
	<meta property="og:title" content="DDR">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="generator" content="Webflow">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/css/normalize.css">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/css/webflow.css">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/css/ddr.webflow.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js"></script>
	<script>
 	WebFont.load({
		google: {
	  	families: ["Montserrat:400,700","Roboto:300,regular,500","Roboto Condensed:300,regular,700","Roboto Slab:300,regular,700","Arbutus Slab:regular"]
		}
 	});
	</script>
	<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/modernizr.js"></script>

	<script src="https://www.google.com/recaptcha/api.js?render=<cfoutput>#application.SiteKey#</cfoutput>"></script>
	
	<link rel="apple-touch-icon" sizes="57x57" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/apple-touch-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/apple-touch-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/apple-touch-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/apple-touch-icon-76x76.png">
	<link rel="icon" type="image/png" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/favicon-32x32.png" sizes="32x32">
	<link rel="icon" type="image/png" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/favicon-96x96.png" sizes="96x96">
	<link rel="icon" type="image/png" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/favicon-16x16.png" sizes="16x16">
	<link rel="manifest" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/manifest.json">
	<link rel="mask-icon" href="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">