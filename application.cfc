<cfcomponent
	output="false"
	hint="I set up the application and define the application-level events.">

	<cfprocessingdirective pageencoding="utf-8" />

<!--- DDR - CREATION 1 juin 2016 --->

	<cfif FindNoCase("C:\dev\ddr",cgi.path_translated)>
  		<cfset THIS.name="ddr-local">
 	<cfelseif FindNoCase("C:\sites\ddr",cgi.path_translated)>
  			<cfset THIS.name="ddr">
 	</cfif>
	<cfset THIS.ApplicationTimeout = CreateTimeSpan(0, 1, 00, 0)>
	<cfset THIS.SessionManagement = "Yes">
	<cfset THIS.SessionTimeout = CreateTimeSpan(0, 1, 00, 0)>
	<cfset THIS.ClientManagement = "Yes">

	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="true"
		enablecfoutputonly="false"
		/>

	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false">

		<!--- INITIALIZE APPLICATION --->
		<!--- <cfset StructClear( APPLICATION ) /> --->
		
		<cfset APPLICATION.BD_usager="">
		<cfset APPLICATION.BD_mdp="">

	
		<!--- URLS AND PATHS --->
		<cfset APPLICATION.DSN	=	"ddr">
		<cfset APPLICATION.DSN_dev	=	"ddrDev">
		<cfset APPLICATION.Racine	=	"https://solution-ddr.com">
		<cfset APPLICATION.Racine_SSL	=	"https://solution-ddr.com">
		<cfset APPLICATION.Path	=	"C:\sites\ddr">
		<cfset APPLICATION.TITLE	=	"ddr">
		<cfset APPLICATION.cfcAdmin =	"cfc.admin">
		<cfset APPLICATION.cfcAdmin =	"cfc.admin">
		<cfset APPLICATION.cfcComptes =	"cfc.comptes">
		<cfset APPLICATION.cfcDonateurs =	"cfc.donateurs">
		<cfset APPLICATION.cfcDons 	=	"cfc.dons">
		<cfset APPLICATION.cfcRapports =	"cfc.rapports">
		<cfset APPLICATION.cfcRecus 	=	"cfc.recus">
		<cfset APPLICATION.cfcUtilisateurs =	"cfc.utilisateurs">
		<cfset APPLICATION.cfcEnvoiRecus =	"cfc.envoirecus">
				
		<cfset APPLICATION.PathCFC	=	"#APPLICATION.Path#\cfc">
		
		<cfset application.stripePublicKey = "pk_test_zNuQcRs9K5T3aJwC2s1jIBuh">
		<cfset application.stripeSecretKey = CreateObject("java", "java.lang.System").getenv("STRIPE_SECRET_KEY")> 
		
		<cfset APPLICATION.CourrielDeveloppeur	=	"francois@creationstouche.com">
		<cfset APPLICATION.CourrielInfo	=	"info@cqoc.org">
		<cfset APPLICATION.CourrielAlertes	=	"ebienvenue@cqoc.org;dalexandre@cqoc.org">
		
		<!--- 	AMAZON SES - SMTP SETTINGS --->

		<!--- iCREATIONS ACCOUNT --->
		<!--- 
		<cfset APPLICATION.emailAttributeCollection = {
			from = "RECU IMPOT DONATEUR <info@solution-ddr.com>", 
			server = "email-smtp.us-east-1.amazonaws.com", 
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY") 
		}>
		<cfset APPLICATION.emailAttributeCollectionResend = { 
			from = "RECU IMPOT DONATEUR <ddr-reply@cqoc.org>",
			server = "email-smtp.us-east-1.amazonaws.com",
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")
		}>
 --->
		<!--- BRIDGEMEDIA ACCOUNT--->
		<cfset APPLICATION.emailAttributeCollection = {
			from = "RECUS IMPOT <info@solution-ddr.com>", 
			server = "email-smtp.us-east-1.amazonaws.com", 
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")
		}>
		<cfset APPLICATION.emailAttributeCollectionInfo = {
			from = "CQOC DDR2 <info@solution-ddr.com>", 
			server = "email-smtp.us-east-1.amazonaws.com", 
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")
		}>

		<cfset APPLICATION.emailAttributeCollectionTo = {
			to = "info@cqoc.org", 
			server = "email-smtp.us-east-1.amazonaws.com", 
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")
		}>
		
		<cfset APPLICATION.emailAttributeCollectionResend = { 
			from = "RECUS IMPOT <ddr-reply@cqoc.org>",
			server = "email-smtp.us-east-1.amazonaws.com",
			useTLS = "yes",
			port = "25",
			username = CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID"),
			password = CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")
		}>
		
		<!--- ------------------------------- --->
		<!--- RECAPTCHA V3 --->
		<cfset APPLICATION.SiteKey = "6Le7uuErAAAAAM3Q2QhsiLK-r84nMSv5cik3_p8j">
		<cfset APPLICATION.SecretKey = CreateObject("java", "java.lang.System").getenv("RECAPTCHA_SECRET_KEY")>


		<cfreturn true />
	</cffunction>

	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="I initialize the session.">
		
		<!--- <cfset StructClear( SESSION ) /> --->
		
		<CFSET Session.langue="fr">
		
		
	</cffunction>

	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="I initialize the page request.">

		<!--- DEFINING ARGUMENTS --->
		<cfargument
			name="Page"
			type="string"
			required="true"
			hint="Page requested by visitor."
			/>

		<!--- TO REINITIALIZE PAGE --->
		<cfif StructKeyExists(URL, 'restart')>
			<cfset THIS.OnApplicationStart()>
		</cfif>
		
		<!--- DECONNEXION --->
		<cfif StructKeyExists(URL, 'logout')>
			
			<!--- EN FERMANT LA SESSION ON VEROUILLE LES DONS ENTRES  --->
			<cfif StructKeyExists(SESSION, 'utilisateur')>
				<cfinvoke component="#APPLICATION.cfcDons#" method = "donsVerouiller" returnvariable ="message">
					<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
				</cfinvoke>
			</cfif>
			
			<!--- <cfset exists = StructDelete( SESSION, 'utilisateur', true ) /> --->
			<cfset StructDelete( SESSION, 'utilisateur' ) />
			<cfset structclear(session)>
			
			<CFIF URL.langue EQ "fr">
				<CFLOCATION URL="#APPLICATION.Racine#/fr/accueil" ADDTOKEN="No">
			<CFELSE>
				<CFLOCATION URL="#APPLICATION.Racine#/en/home" ADDTOKEN="No">
			</CFIF>
		</cfif>
		
		<!--- <cfif NOT StructKeyExists(SESSION, 'utilisateur') AND CGI.SCRIPT_NAME DOES NOT CONTAIN "index.cfm" AND CGI.SCRIPT_NAME DOES NOT CONTAIN "tarifs.cfm" AND CGI.SCRIPT_NAME DOES NOT CONTAIN "abonnement.cfm"> --->
		<cfif NOT StructKeyExists(SESSION, 'utilisateur') 
			AND CGI.PATH_TRANSLATED NEQ "#APPLICATION.Path#\index.cfm" 
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "tarifs.cfm" 
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "abonnement.cfm" 
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "abonnement2.cfm" 
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "conditions.cfm" 
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "/sns/"
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "maintenance.cfm"
			AND CGI.SCRIPT_NAME DOES NOT CONTAIN "ddr_alerte_expiration_license.cfm">
			<CFIF Session.langue EQ "fr">
				<CFLOCATION URL="#APPLICATION.Racine#/fr/accueil" ADDTOKEN="No">
			<CFELSE>
				<CFLOCATION URL="#APPLICATION.Racine#/en/home" ADDTOKEN="No">
			</CFIF>
		</cfif>
		
		<cfif StructKeyExists(URL, 'langue')>
			<cfset SESSION.langue = Iif( URL.langue EQ "fr", DE("fr"), DE("en") )>
		</cfif>

		<cfreturn true />
	</cffunction>

</cfcomponent>

