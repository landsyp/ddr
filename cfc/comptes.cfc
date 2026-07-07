<cfcomponent displayname="comptes" hint="Cette composante gere les fonctions pour les comptes">
	
	
	
	<cffunction name="compteAjout" access="remote" returntype="string" >
		<cfargument name="organismeID" required="true">
		<cfargument name="noCompte" required="true">
		<cfargument name="nom" required="true">
		<cfargument name="recu" required="true">
		
		
		<CFQUERY NAME="checkNumero" DATASOURCE="#APPLICATION.DSN#">
			SELECT compteID FROM comptes
			WHERE	organismeID = <CFQUERYPARAM VALUE="#val(arguments.organismeID)#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	noCompte = <CFQUERYPARAM VALUE="#Val(arguments.noCompte)#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFIF checkNumero.recordcount EQ 0>
			<CFQUERY NAME="compteAjout" DATASOURCE="#APPLICATION.DSN#" RESULT="NeoCompte">
			INSERT INTO comptes (organismeID, noCompte, nom, recu)
			VALUES (	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#arguments.noCompte#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="100">,
						<CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT">)
			</CFQUERY>
			<cfset LOCAL.CompteID = NeoCompte.IDENTITYCOL>
		<CFELSE>
			<cfset LOCAL.CompteID = 0>
		</CFIF>
		<CFRETURN LOCAL.CompteID>
	</cffunction>
	
	<cffunction name="CompteEdition" access="remote" returntype="string" >
		<cfargument name="noCompte" required="true">
		<cfargument name="nom" required="true">
		<cfargument name="recu" required="true">
		<cfargument name="compteID"  required="true">

		<CFQUERY NAME="CompteEdition" DATASOURCE="#APPLICATION.DSN#" RESULT="NeoUtilisateur">
		UPDATE comptes 
			SET	
					noCompte = <CFQUERYPARAM VALUE="#arguments.noCompte#" CFSQLTYPE="CF_SQL_INTEGER" >,
					nom = <CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="100">,
					recu = <CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT" >			
			WHERE compteID	=	<CFQUERYPARAM VALUE="#arguments.compteID#" CFSQLTYPE="CF_SQL_INTEGER">
		
		</CFQUERY>
		
		<CFIF Session.langue EQ "fr">
			<CFSET LOCAL.message = "Le compte a &eacute;t&eacute; mise &agrave; jour avec succ&egrave;s.">
		<CFELSE>
			<CFSET LOCAL.message = "The account was updated successfully.">
		</CFIF>
		
		<CFRETURN LOCAL.message>
		
	</cffunction>
	
	<cffunction name="compteInfos" access="remote" returntype="query" >
		<cfargument name="compteID"  required="true" >
		
		<CFQUERY NAME="compteInfos" DATASOURCE="#APPLICATION.DSN#">
		SELECT c.compteId, c.organismeID, c.noCompte, c.nom, c.recu, o.organisme 
			FROM comptes AS c
				INNER JOIN organismes AS o ON c.organismeID = o.organismeID
		WHERE compteID = <CFQUERYPARAM VALUE="#arguments.compteID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN compteInfos>
	</cffunction>
	
	<cffunction name="compteNomParNumero" access="remote" returntype="string" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="noCompte"  required="true" >
		
		<CFQUERY NAME="compteNomParNumero" DATASOURCE="#APPLICATION.DSN#">
		SELECT nom FROM comptes
		WHERE noCompte = <CFQUERYPARAM VALUE="#arguments.noCompte#" CFSQLTYPE="CF_SQL_INTEGER">
		AND 	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN compteNomParNumero.nom>
	</cffunction>
	
	
	<cffunction name="comptesListe" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		
		
		<CFQUERY NAME="comptesListe" DATASOURCE="#APPLICATION.DSN#">
		SELECT  compteID, noCompte, nom, recu
 		FROM comptes 
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		ORDER BY noCompte
		</CFQUERY>
		
		<CFRETURN comptesListe>
	</cffunction>
	
	<cffunction name="compteSupprimer" access="remote" returntype="string" >
		<cfargument name="compteID"  required="true" >
		
		<CFSET LOCAL.message = "">
		
		<CFQUERY NAME="check" DATASOURCE="#APPLICATION.DSN#">
			SELECT * FROM dons 
			WHERE compteID = <CFQUERYPARAM VALUE="#arguments.compteID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFIF check.recordcount EQ 0>
			<CFQUERY NAME="compteSupprimer" DATASOURCE="#APPLICATION.DSN#">
			DELETE FROM comptes
			WHERE compteID = <CFQUERYPARAM VALUE="#arguments.compteID#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFQUERY>
			<CFSET LOCAL.message = "succes">
			<CFIF session.langue EQ "fr">
				<CFSET Session.message = "Compte supprim&eacute; avec succ&egrave;s">
			<CFELSE>
				<CFSET Session.message = "Account deleted successfully">
			</CFIF>
		<CFELSE>
			<CFSET LOCAL.message = "echec">
			<CFIF session.langue EQ "fr">
				<CFSET Session.messageEchec = "Le compte ne peut &ecirc;tre supprim&eacute; car il est associ&eacute; à au moins un don.">
			<CFELSE>
				<CFSET Session.messageEchec = "The account can't be deleted.  It is linked to at least one gift.">
			</CFIF>
		</CFIF>
		<CFRETURN LOCAL.message>
	</cffunction>
	
	
	
	
</cfcomponent>
