<cfcomponent displayname="recus" hint="Cette composante gere les fonctions pour la production de re�us pdf">
	
	<cffunction name="recuAjout" access="remote">
		<cfargument name="dateCreation" type="date" required="true" >
		<cfargument name="dateDebut" type="date" required="true">
		<cfargument name="dateFin" type="date" required="true" >
		<cfargument name="donateurID" type="numeric" required="true" >
		<cfargument name="montant" type="string" required="true" >
		<cfargument name="organismeID" type="numeric" required="true" >
		
		<!--- 	S'IL EXISTE DÉJÀ UN OU DES REÇUS POUR CE DONATEUR POUR LA MÊME PÉRIODE  
				ON LE SUPPRIME AFIN QU'IL N'Y AIT QU'UN SEUL REÇU POUR CETTE PÉRIODE (AVEC LES MONTANTS LES PLUS RÉCENTS) ---> 
		<CFQUERY NAME="supprimerRecusMemePeriode" DATASOURCE="#APPLICATION.DSN#">
		DELETE FROM recus 
		WHERE 	dateDebut 	= 	<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
		AND		dateFin		=	<CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
		AND		donateurID	=	<CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		AND		organismeID	=	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>

		<CFQUERY NAME="recuAjout" DATASOURCE="#APPLICATION.DSN#">
		INSERT INTO recus (dateCreation, dateDebut,  dateFin, donateurID, montant, organismeID)
		VALUES (
			<CFQUERYPARAM VALUE="#arguments.dateCreation#" CFSQLTYPE="CF_SQL_TIMESTAMP">
			,<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
			,<CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
			, <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			, <CFQUERYPARAM VALUE="#arguments.montant#" CFSQLTYPE="CF_SQL_MONEY">
			, <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		)
		</CFQUERY>
		
	</cffunction>


	<cffunction name="recusInfo" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="dateDebut" required="false" default="" >
		<cfargument name="dateFin" required="false" default="" >
		<cfargument name="numero" required="false" default="" >
		<cfargument name="tri" required="false" default="dateCreationD" >
		
		<cfset LOCAL.dateDe = dateFormat(arguments.dateDebut, 'yyyy-mm-dd') & "-00-00-00">
		<cfset LOCAL.dateA = dateFormat(arguments.dateFin, 'yyyy-mm-dd') & "-23-59-59">

		<CFQUERY NAME="recusInfo" DATASOURCE="#APPLICATION.DSN#">
			SELECT  r.recuID, r.dateCreation, r.dateDebut, r.dateFin, r.donateurID, r.montant, d.nom, d.prenom, d.numero, d.courriel
			FROM recus AS r
				LEFT JOIN donateurs AS d ON r.donateurID = d.donateurID
			WHERE	r.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			<cfif arguments.dateDebut NEQ "">
			AND	r.dateDebut  >= 	<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<cfif arguments.dateFin NEQ "">
			AND	r.dateFin	<= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<cfif arguments.tri  EQ "nomA">
				ORDER BY d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<cfelseif arguments.tri EQ "numeroA">
				ORDER BY CAST(d.numero as INT)
			<cfelseif arguments.tri EQ "numeroD">
				ORDER BY CAST(d.numero as INT) DESC
			<cfelseif arguments.tri EQ "dateDeA">
				ORDER BY r.dateDebut
			<cfelseif arguments.tri EQ "dateDeD">
				ORDER BY r.dateDebut  DESC
			<cfelseif arguments.tri EQ "dateAA">
				ORDER BY r.dateFin
			<cfelseif arguments.tri EQ "dateAD">
				ORDER BY r.dateFin  DESC
			<cfelseif arguments.tri EQ "dateCreationA">
				ORDER BY r.dateCreation
			<cfelseif arguments.tri EQ "dateCreationD">
				ORDER BY r.dateCreation  DESC
			<cfelse>
				ORDER BY r.dateCreation  DESC
			</cfif>
		</CFQUERY>
		<CFRETURN recusInfo>
	</cffunction>
	
	<cffunction name="recusDistinctInfo" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="dateDebut" required="false" default="" >
		<cfargument name="dateFin" required="false" default="" >
		<cfargument name="numero" required="false" default="" >
		<cfargument name="tri" required="false" default="dateCreationD" >
		
		<cfset LOCAL.dateDe = dateFormat(arguments.dateDebut, 'yyyy-mm-dd') & "-00-00-00">
		<cfset LOCAL.dateA = dateFormat(arguments.dateFin, 'yyyy-mm-dd') & "-23-59-59">

		<CFQUERY NAME="recusDistinctInfo" DATASOURCE="#APPLICATION.DSN#">
			SELECT  distinct r.dateDebut, r.dateFin, r.donateurID, r.montant, d.nom, d.prenom, cast(d.numero as int) numero, d.courriel
			FROM recus AS r
				LEFT JOIN donateurs AS d ON r.donateurID = d.donateurID
			WHERE	r.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			<cfif arguments.dateDebut NEQ "">
			AND	r.dateDebut  >= 	<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<cfif arguments.dateFin NEQ "">
			AND	r.dateFin	<= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<cfif arguments.tri  EQ "nomA">
				ORDER BY d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<cfelseif arguments.tri EQ "numeroA">
				<!--- ORDER BY CAST(d.numero as INT), d.nom, d.prenom --->
				ORDER BY numero
			<cfelseif arguments.tri EQ "numeroD">
				<!--- ORDER BY CAST(d.numero as INT) DESC --->
				ORDER BY numero DESC
			<cfelseif arguments.tri EQ "dateDeA">
				ORDER BY r.dateDebut
			<cfelseif arguments.tri EQ "dateDeD">
				ORDER BY r.dateDebut  DESC
			<cfelseif arguments.tri EQ "dateAA">
				ORDER BY r.dateFin
			<cfelseif arguments.tri EQ "dateAD">
				ORDER BY r.dateFin  DESC
			<!--- <cfelseif arguments.tri EQ "dateCreationA">
				ORDER BY r.dateCreation
			<cfelseif arguments.tri EQ "dateCreationD">
				ORDER BY r.dateCreation  DESC --->
			<cfelse>
				ORDER BY d.nom, d.prenom
			</cfif>
		</CFQUERY>
		<CFRETURN recusDistinctInfo>
	</cffunction>
	
	<cffunction name="recusListe" access="remote" returntype="array" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="annee" type="numeric" required="false" default="0">

		<CFQUERY NAME="recusListe" DATASOURCE="#APPLICATION.DSN#">
		SELECT dateCreation, dateDebut, dateFin, COUNT(*) AS recusCount
		FROM recus
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<cfif arguments.annee NEQ "0">
			AND LEFT(dateCreation, 4) = <CFQUERYPARAM VALUE="#arguments.annee#" CFSQLTYPE="CF_SQL_INTEGER">
		</cfif>
		GROUP BY dateCreation
		ORDER BY dateCreation DESC
		</CFQUERY>
		<CFRETURN lrecusListe>
	</cffunction>
	
	<cffunction name="impressionsListe" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="annee" type="numeric" required="false" default="0">
		
		<CFQUERY NAME="impressionsListe" DATASOURCE="#APPLICATION.DSN#">
		SELECT DISTINCT dateCreation, dateDebut, dateFin, organismeID
		FROM recus
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<cfif arguments.annee NEQ "0">
			AND YEAR(dateCreation) = <CFQUERYPARAM VALUE="#arguments.annee#" CFSQLTYPE="CF_SQL_INTEGER">
		</cfif>
		ORDER BY dateCreation DESC
		</CFQUERY>
		<CFRETURN impressionsListe>
	</cffunction>
	
	<cffunction name="MontantTotalRecu" access="remote" returntype="numeric" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="donateurID"  required="true">
		
		<CFQUERY NAME="MontantTotalRecu" DATASOURCE="#APPLICATION.DSN#">
		SELECT SUM(montant) as montantTotal FROM dons as d 
			INNER JOIN comptes AS c ON d.compteID = c.compteID 
			WHERE d.donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
			AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
			AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
		</CFQUERY>
		<CFRETURN MontantTotalRecu.montantTotal>
	</cffunction>

</cfcomponent>
