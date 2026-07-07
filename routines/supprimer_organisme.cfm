		<CFSET arguments.organismeID = 142>
		
		<!--- <CFQUERY NAME="utilisateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT utilisateurID FROM utilisateurs
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFSET les_utilisateurs = ValueList(utilisateurs.utilisateurID)>
		<cfoutput>#les_utilisateurs#</cfoutput>
		<!--- SUPPRIMER VISITES --->
		<CFQUERY NAME="visitesSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM visites
		WHERE utilisateurID IN (<CFQUERYPARAM VALUE="#les_utilisateurs#" CFSQLTYPE="CF_SQL_INTEGER" LIST="yes">)
		</CFQUERY>
		<!--- SUPPRIMER TROUSSE --->
		<CFQUERY NAME="troussesSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM trousses
		WHERE utilisateurID IN (<CFQUERYPARAM VALUE="#les_utilisateurs#" CFSQLTYPE="CF_SQL_INTEGER" LIST="yes">)
		</CFQUERY>
		<!--- SUPPRIMER UTILISATEURS --->
		<CFQUERY NAME="utilisateursSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM utilisateurs
		WHERE utilisateurID IN (<CFQUERYPARAM VALUE="#les_utilisateurs#" CFSQLTYPE="CF_SQL_INTEGER" LIST="yes">)
		</CFQUERY>
		<!--- SUPPRIMER DONS --->
		<CFQUERY NAME="donsSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM dons
		WHERE 	donateurID IN (SELECT donateurID FROM donateurs WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">)
		</CFQUERY>
		<!--- SUPPRIMER DONATEURS --->
		<CFQUERY NAME="donateursSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM donateurs
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<!--- SUPPRIMER COMPTES --->
		<CFQUERY NAME="comptesSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM comptes
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY> 
		<!--- SUPPRIMER ORGANISME --->
		<CFQUERY NAME="organismeSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE  FROM organismes
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY> --->