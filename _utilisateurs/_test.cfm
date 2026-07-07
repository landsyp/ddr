<CFTRY>
	<cfset courriel = 'olivier@bridgeweb.dev'>
	<cfset mailBody = 'bonjour thru AWS SES at ' & now()>
	<cfset mailSubject = 'DDR email'>
	<!--- 
	<cfmail to="#courriel#"  from="#APPLICATION.CourrielInfo#" subject="DDR email" type="HTML">
		bonjour
	</cfmail>
	--->

	<!--- <cfmail attributeCollection="#APPLICATION.emailAttributeCollection#" to="#courriel#" subject="#mailSubject#">
		#mailBody#
	</cfmail>

	<cfdump var="#mailBody#" label="mailBody">
 --->
	<!--- 
	<cfscript>
		mailerService = new mail();
		mailerService.setTo(courriel);
		mailerService.setServer("email-smtp.us-east-1.amazonaws.com"); 
		mailerService.setUseTLS("yes"); 
		mailerService.setPort("25"); 
		mailerService.setUsername(CreateObject("java", "java.lang.System").getenv("AWS_SES_ACCESS_KEY_ID")); 
		mailerService.setPassword(CreateObject("java", "java.lang.System").getenv("AWS_SES_SECRET_ACCESS_KEY")); 
		mailerService.setSubject("DDR email"); 
		mailerService.setDebug("yes"); 
		mailerService.send(body=mailBody); 

	</cfscript>
	--->

	<!--- <cfquery name="NoDonateur" datasource="#APPLICATION.DSN#" > 
	SELECT	Max(CAST(numero as NUMERIC(10,0))) AS dernier
	FROM	donateurs
	WHERE	organismeID = 133 
	</cfquery> 
	
	<cfoutput>#NoDonateur.dernier#</cfoutput><BR> --->

		
	<!--- <cfset origValue = "00000001"> 
	<cfset newValue = ReReplace(origValue, "0+", "", "all")>
	<cfoutput>#newValue#</cfoutput> --->
	
		<!--- <CFQUERY NAME="RecusLivres" DATASOURCE="#APPLICATION.DSN#">
		SELECT        envoiID, dateDebut, dateFin, donateurID, envoiCode, montant, organismeID, statut
		FROM            envois
		WHERE        (organismeID = 239) AND (envoiCode = '2019-09-02-16-22-29')
		ORDER BY envoiID
		</CFQUERY>
		
		<CFOUTPUT query="RecusLivres">
			<CFQUERY NAME="total" DATASOURCE="#APPLICATION.DSN#">
				SELECT SUM(montant) as montantTotal FROM dons as d 
				INNER JOIN comptes AS c ON d.compteID = c.compteID 
				WHERE d.donateurID = <CFQUERYPARAM VALUE="#donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
				AND	c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
				AND d.datedon >= <CFQUERYPARAM VALUE="#dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
				AND d.datedon <= <CFQUERYPARAM VALUE="#dateFin#" CFSQLTYPE="CF_SQL_DATE">
			</CFQUERY>
			#envoiID# #donateurID# #total.montantTotal#<BR>
			<CFQUERY NAME="update" DATASOURCE="#APPLICATION.DSN#">
				UPDATE envois
				SET montant = <CFQUERYPARAM VALUE="#total.montantTotal#" CFSQLTYPE="CF_SQL_MONEY">
				WHERE envoiID = #envoiID#
			</CFQUERY> 
		</CFOUTPUT> --->
		
		
		
		<!--- <CFQUERY NAME="RecusLivres" DATASOURCE="#APPLICATION.DSN#">
		SELECT        envoiID, dateDebut, dateFin, donateurID, envoiCode, montant, organismeID, statut
		FROM            envois
		WHERE        statut = '2-livre'
		ORDER BY envoiID
		</CFQUERY>
		<CFOUTPUT query="RecusLivres">
			<CFSET noRecu = envoiID+1000>
			#envoiID#  #noRecu#<BR>
			<CFQUERY NAME="update" DATASOURCE="#APPLICATION.DSN#">
				UPDATE envois
				SET noRecu = <CFQUERYPARAM VALUE="#noRecu#" CFSQLTYPE="CF_SQL_INTEGER">
				WHERE envoiID = #envoiID#
			</CFQUERY> 
		</cfoutput> --->
		
	
	<CFCATCH>

	
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