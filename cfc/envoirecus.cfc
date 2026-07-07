<cfcomponent displayname="envoirecus" hint="Cette composante gere les fonctions pour l'envoi de reçus">
	
	<cffunction name="envoiAjout" access="remote">
		<cfargument name="organismeID" type="numeric" required="true" >
		<cfargument name="dateDebut" type="date" required="false" default="">
		<cfargument name="dateFin" type="date" required="false" default="">
		<cfargument name="envoisDonateurs" type="array" required="true" >
		<cfargument name="envoiCode" type="string" required="true" >
		<cfargument name="envoiIDAddition" type="numeric" required="true" default="1000" >
		
		<cfloop array="#arguments.envoisDonateurs#" index="local.envoiDonateur">
			
			<cfset local.donateurID = local.envoiDonateur.donateurID>
			<cfset local.statut = local.envoiDonateur.hasValidEmail ? '1-en-cours' : '0-courriel-non-valide'>
			
			<cfset LOCAL.montant = THIS.MontantTotalRecu(arguments.dateDebut,arguments.dateFin,  local.donateurID)> 
			
			<CFQUERY NAME="local.insEnvois" DATASOURCE="#APPLICATION.DSN#" RESULT="local.NeoEnvoi">
			INSERT INTO envois (dateDebut, dateFin, donateurID, envoiCode, montant, organismeID,  statut)
			VALUES (
				<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#arguments.dateDebut EQ ""#">
				,<CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#arguments.dateFin EQ ""#">
				, <CFQUERYPARAM VALUE="#local.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
				,<CFQUERYPARAM VALUE="#arguments.envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
				, <CFQUERYPARAM VALUE="#LOCAL.montant#" CFSQLTYPE="CF_SQL_MONEY">
				, <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
				, <CFQUERYPARAM VALUE="#local.statut#" CFSQLTYPE="CF_SQL_VARCHAR">
			)
			</CFQUERY>
			<cfset local.envoiDonateur.envoiID = local.NeoEnvoi.IDENTITYCOL + arguments.envoiIDAddition>
			<CFQUERY NAME="update" DATASOURCE="#APPLICATION.DSN#">
				UPDATE envois
				SET noRecu = <CFQUERYPARAM VALUE="#local.envoiDonateur.envoiID#" CFSQLTYPE="CF_SQL_INTEGER">
				WHERE envoiID = <CFQUERYPARAM VALUE="#local.NeoEnvoi.IDENTITYCOL#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFQUERY>
			
		</cfloop>
		<CFRETURN arguments.envoisDonateurs>
	</cffunction>

	<cffunction name="envoisListe" access="remote" returntype="array" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="annee" type="numeric" required="false" default="0">

		<CFQUERY NAME="local.RapportEnvois" DATASOURCE="#APPLICATION.DSN#">
		SELECT e.dateDebut, e.dateFin, e.envoiCode, e.statut, COUNT(*) AS statutCount
		FROM envois AS e 
		WHERE e.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<cfif arguments.annee NEQ "0">
			AND LEFT(e.envoiCode, 4) = <CFQUERYPARAM VALUE="#arguments.annee#" CFSQLTYPE="CF_SQL_INTEGER">
		</cfif>
		GROUP BY  e.envoiCode, e.dateDebut, e.dateFin, e.statut
		ORDER BY e.envoiCode DESC, e.statut
		</CFQUERY>

		<cfset local.envoisListe = arrayNew(1)>
		<cfoutput query="local.RapportEnvois" group="envoiCode">
			<cfset local.envoiStatut = structNew()>
			<cfset local.envoiStatut.envoiCode = local.RapportEnvois.envoiCode>
			<cfset local.envoiStatut.dateDebut = local.RapportEnvois.dateDebut>
			<cfset local.envoiStatut.dateFin = local.RapportEnvois.dateFin>
			<cfoutput>
				<cfset local.envoiStatut['#local.RapportEnvois.statut#'] = local.RapportEnvois.statutCount>
			</cfoutput>
			<cfset arrayAppend(local.envoisListe, duplicate(local.envoiStatut))>
			
		</cfoutput>

		<CFRETURN local.envoisListe>
	</cffunction>

	<cffunction name="envoiInfo" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="envoiCode" required="true" >
		<cfargument name="tri" required="false" default="statutA" >

		<CFQUERY NAME="RapportEnvoi" DATASOURCE="#APPLICATION.DSN#">
			SELECT e.envoiID, e.envoiIDOrigine,  e.envoiCode, e.dateDebut, e.dateFin, e.donateurID, e.noRecu, e.statut, d.donateurID, d.nom, d.prenom, d.numero, d.courriel
			FROM envois AS e 
				LEFT JOIN donateurs AS d ON e.donateurID = d.donateurID
			WHERE	e.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND		e.envoiCode = <CFQUERYPARAM VALUE="#arguments.envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
			<cfif arguments.tri EQ "statutA">
				ORDER BY e.statut, d.nom, d.prenom
			<cfelseif arguments.tri EQ "statutD">
				ORDER BY e.statut DESC, d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomA">
				ORDER BY d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<cfelseif arguments.tri EQ "numeroA">
				ORDER BY CAST(d.numero as INT)
			<cfelseif arguments.tri EQ "numeroD">
				ORDER BY CAST(d.numero as INT) DESC
			</cfif>
		</CFQUERY>
		<CFRETURN RapportEnvoi>
	</cffunction>
	
	<cffunction name="envoisInfo" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="dateDe" required="false" default="" >
		<cfargument name="dateA" required="false" default="" >
		<cfargument name="numero" required="false" default="" >
		<cfargument name="statut" required="false" default="tous" >
		<cfargument name="tri" required="false" default="statutA" >
		
		<cfset LOCAL.dateDe = dateFormat(arguments.dateDe, 'yyyy-mm-dd') & "-00-00-00">
		<cfset LOCAL.dateA = dateFormat(arguments.dateA, 'yyyy-mm-dd') & "-23-59-59">
		
		<CFQUERY NAME="envoisInfo" DATASOURCE="#APPLICATION.DSN#">
			SELECT e.envoiID, e.envoiIDOrigine, e.envoiCode, e.dateDebut, e.dateFin, e.donateurID, e.montant, e.noRecu, e.statut, d.donateurID, d.nom, d.prenom, d.numero, d.courriel
			FROM envois AS e 
				LEFT JOIN donateurs AS d ON e.donateurID = d.donateurID
			WHERE	e.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			<cfif arguments.statut NEQ "tous">
				and  statut = <CFQUERYPARAM VALUE="#arguments.statut#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.dateDe NEQ "">
				AND	e.envoiCode > <CFQUERYPARAM VALUE="#LOCAL.dateDe#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.dateA NEQ "">
				AND	e.envoiCode < <CFQUERYPARAM VALUE="#LOCAL.dateA#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.numero NEQ "">
				and  numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.tri EQ "statutA">
				ORDER BY e.statut, d.nom, d.prenom
			<cfelseif arguments.tri EQ "statutD">
				ORDER BY e.statut DESC, d.nom, d.prenom
			<cfelseif arguments.tri EQ "dateEnvoiA">
				ORDER BY e.envoiCode
			<cfelseif arguments.tri EQ "dateEnvoiD">
				ORDER BY e.envoiCode DESC
			<cfelseif arguments.tri EQ "nomA">
				ORDER BY d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<cfelseif arguments.tri EQ "numeroA">
				ORDER BY CAST(d.numero as INT) 
			<cfelseif arguments.tri EQ "numeroD">
				ORDER BY CAST(d.numero as INT) DESC
			<cfelse>
				ORDER BY e.envoiCode DESC
			</cfif>
		</CFQUERY>

		<CFRETURN envoisInfo>
	</cffunction>
	
	<!--- RECUS LIVRES EN EXCLUANT RECUS REENVOYES --->
	<cffunction name="envoisInfoExcel" access="remote" returntype="query" > 
		<cfargument name="organismeID" required="true" >
		<cfargument name="dateDe" required="false" default="" >
		<cfargument name="dateA" required="false" default="" >
		<cfargument name="numero" required="false" default="" >
		<cfargument name="statut" required="false" default="tous" >
		<cfargument name="tri" required="false" default="statutA" >
		
		<cfset LOCAL.dateDe = dateFormat(arguments.dateDe, 'yyyy-mm-dd') & "-00-00-00">
		<cfset LOCAL.dateA = dateFormat(arguments.dateA, 'yyyy-mm-dd') & "-23-59-59">
		
		<CFQUERY NAME="envoisInfoExcel" DATASOURCE="#APPLICATION.DSN#">
			SELECT e.envoiID, e.envoiIDOrigine, e.envoiCode, e.dateDebut, e.dateFin, e.donateurID, e.montant, e.noRecu, e.statut, d.donateurID, d.nom, d.prenom, d.numero, d.courriel
			FROM envois AS e 
				LEFT JOIN donateurs AS d ON e.donateurID = d.donateurID
			WHERE	e.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			<!--- AND		e.envoiIDOrigine IS NULL --->
			<cfif arguments.statut NEQ "tous">
				and  statut = <CFQUERYPARAM VALUE="#arguments.statut#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.dateDe NEQ "">
				AND	e.envoiCode > <CFQUERYPARAM VALUE="#LOCAL.dateDe#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.dateA NEQ "">
				AND	e.envoiCode < <CFQUERYPARAM VALUE="#LOCAL.dateA#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.numero NEQ "">
				and  numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR">
			</cfif>
			<cfif arguments.tri EQ "statutA">
				ORDER BY e.statut, d.nom, d.prenom
			<cfelseif arguments.tri EQ "statutD">
				ORDER BY e.statut DESC, d.nom, d.prenom
			<cfelseif arguments.tri EQ "dateEnvoiA">
				ORDER BY e.envoiCode
			<cfelseif arguments.tri EQ "dateEnvoiD">
				ORDER BY e.envoiCode DESC
			<cfelseif arguments.tri EQ "nomA">
				ORDER BY d.nom, d.prenom
			<cfelseif arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<cfelseif arguments.tri EQ "numeroA">
				ORDER BY CAST(d.numero as INT) 
			<cfelseif arguments.tri EQ "numeroD">
				ORDER BY CAST(d.numero as INT) DESC
			<cfelse>
				ORDER BY e.envoiCode DESC
			</cfif>
		</CFQUERY>

		<CFRETURN envoisInfoExcel>
	</cffunction>
	
	<!--- POUR LE RENVOI COURRIEL DU MEME RECU --->
	<cffunction name="envoiRecuInfo" access="remote" returntype="query" >
		<cfargument name="envoiID" required="true" >
		
		<CFQUERY NAME="envoiRecuInfo" DATASOURCE="#APPLICATION.DSN#">
			SELECT 	e.envoiID, e.dateDebut, e.dateFin, e.donateurID, e.envoiCode, e.montant, e.noRecu, e.organismeID, e.statut,  d.adresse, d.code_postal, d.courriel, d.donateurID, d.nom,  d.numero, d.prenom, d.ville, p.abreviation as province  
			FROM 	envois AS e 
				LEFT JOIN donateurs AS d ON e.donateurID = d.donateurID
				INNER JOIN provinces AS p ON d.provinceID = p.provinceID
			WHERE	e.envoiID = <CFQUERYPARAM VALUE="#arguments.envoiID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFRETURN envoiRecuInfo>
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
	
	<cffunction name="renvoiAjout" access="remote" returntype="numeric">
		<cfargument name="envoiIDOrigine" type="numeric" required="true" >
		<cfargument name="dateDebut" type="date" required="false" default="">
		<cfargument name="dateFin" type="date" required="false" default="">
		<cfargument name="donateurID" type="numeric" required="true">
		<cfargument name="envoiCode" type="string" required="true" >
		<!--- <cfargument name="montant" type="numeric" required="true" > --->
		<cfargument name="noRecu" type="numeric" required="true" >
		<cfargument name="organismeID" type="numeric" required="true" >

		<!--- RECALCUL DU MONTANT EN CAS DE MODIFICATION --->
		<cfset LOCAL.montant = THIS.MontantTotalRecu(arguments.dateDebut,arguments.dateFin,  arguments.donateurID)> 
		
		<CFQUERY NAME="local.insEnvois" DATASOURCE="#APPLICATION.DSN#" RESULT="NeoEnvoi">
		INSERT INTO envois (envoiIDOrigine, dateDebut, dateFin, donateurID, envoiCode, montant, noRecu, organismeID,  statut)
		VALUES (
			<CFQUERYPARAM VALUE="#arguments.envoiIDOrigine#" CFSQLTYPE="CF_SQL_INTEGER">
			,<CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE" NULL="#arguments.dateDebut EQ ""#">
			,<CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE" NULL="#arguments.dateFin EQ ""#">
			, <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			,<CFQUERYPARAM VALUE="#arguments.envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
			, <CFQUERYPARAM VALUE="#LOCAL.montant#" CFSQLTYPE="CF_SQL_MONEY">
			, <CFQUERYPARAM VALUE="#arguments.noRecu#" CFSQLTYPE="CF_SQL_INTEGER">
			, <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			, <CFQUERYPARAM VALUE="1-en-cours" CFSQLTYPE="CF_SQL_VARCHAR">
		)
		</CFQUERY>	
		
		<cfset renvoiID = NeoEnvoi.IDENTITYCOL >
		
		<CFRETURN renvoiID>
		
	</cffunction>

	
	<cffunction name="VerificationEnvoiReussi" access="remote" returntype="query" >
		<cfargument name="donateurID" required="true" >
		<cfargument name="noRecu" required="true" >

		<CFQUERY NAME="VerificationEnvoiReussi" DATASOURCE="#APPLICATION.DSN#">
		SELECT envoiID, envoiIDOrigine, dateDebut, dateFin, donateurID, envoiCode, montant, noRecu, organismeID, statut
		FROM    envois
		WHERE  	donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		AND 	noRecu =  <CFQUERYPARAM VALUE="#arguments.noRecu#" CFSQLTYPE="CF_SQL_INTEGER">
		AND 	statut = <CFQUERYPARAM VALUE="2-livre" CFSQLTYPE="CF_SQL_VARCHAR">
		</CFQUERY>	
		<CFRETURN VerificationEnvoiReussi>
		
	</cffunction>

</cfcomponent>
