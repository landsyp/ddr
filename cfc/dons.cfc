<cfcomponent displayname="dons" hint="Cette composante gere les fonctions pour les donss">
	
	<cffunction name="donAjout" access="remote" returntype="string" >
		<cfargument name="dateDon" required="true">
		<cfargument name="description" required="true">
		<cfargument name="montant" required="true">
		<cfargument name="noCompte" required="true">
		<cfargument name="numero" required="true">
		<cfargument name="methodeDonID" required="false" default="">
		<cfargument name="organismeID"  required="true">
		
		<CFQUERY NAME="trouveDonateurID" DATASOURCE="#APPLICATION.DSN#" >
			SELECT 	donateurID FROM donateurs
			WHERE	numero	=	<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
			AND		organismeID	=	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFQUERY NAME="trouveCompteID" DATASOURCE="#APPLICATION.DSN#" >
			SELECT 	compteID FROM comptes
			WHERE	noCompte	=	<CFQUERYPARAM VALUE="#Val(arguments.noCompte)#" CFSQLTYPE="CF_SQL_INTEGER" maxlength="50">
			AND		organismeID	=	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFIF trouveDonateurID.recordcount EQ 1 AND trouveCompteID.recordcount EQ 1>
		
			<CFQUERY NAME="donAjout" DATASOURCE="#APPLICATION.DSN#" RESULT="Neodon">
			INSERT INTO dons (compteID, dateDon, description, donateurID,  montant, methodeDonID) 
			VALUES (	<CFQUERYPARAM VALUE="#trouveCompteID.compteID#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#dateDon#" CFSQLTYPE="CF_SQL_DATE">,
						<CFQUERYPARAM VALUE="#Trim(arguments.description)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.description EQ ""#">,
						<CFQUERYPARAM VALUE="#trouveDonateurID.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#arguments.montant#" CFSQLTYPE="CF_SQL_MONEY">,
						<CFQUERYPARAM VALUE="#arguments.methodeDonID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#NOT isNumeric(arguments.methodeDonID)#">
						)
			</CFQUERY>
			<cfset LOCAL.donID = Neodon.IDENTITYCOL>
		<CFELSE>
			<cfset LOCAL.donID = 0>
		</CFIF>
		
		<CFRETURN LOCAL.donID>
		
	</cffunction>
	
	<cffunction name="donEdition" access="remote" returntype="string" >
		<cfargument name="dateDon" required="true">
		<cfargument name="description" required="true">
		<cfargument name="montant" required="true">
		<cfargument name="noCompte" required="true">
		<cfargument name="numero" required="true">
		<cfargument name="methodeDonID" required="false" default="">
		<cfargument name="organismeID"  required="true">
		<cfargument name="donID"  required="true">
		
		<CFQUERY NAME="trouveDonateurID" DATASOURCE="#APPLICATION.DSN#" >
			SELECT 	donateurID FROM donateurs
			WHERE		numero	=	<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
			AND		organismeID	=	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFQUERY NAME="trouveCompteID" DATASOURCE="#APPLICATION.DSN#" >
			SELECT 	compteID FROM comptes
			WHERE		noCompte	=	<CFQUERYPARAM VALUE="#Val(arguments.noCompte)#" CFSQLTYPE="CF_SQL_INTEGER" maxlength="50">
			AND		organismeID	=	<CFQUERYPARAM VALUE="#Val(arguments.organismeID)#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFIF trouveDonateurID.recordcount EQ 1 AND trouveCompteID.recordcount EQ 1>
		
			<CFQUERY NAME="donEdition" DATASOURCE="#APPLICATION.DSN#" RESULT="MajDon">
			UPDATE dons 
				SET	compteID			= 	<CFQUERYPARAM VALUE="#trouveCompteID.compteID#" CFSQLTYPE="CF_SQL_INTEGER">,
						dateDon 		= 	<CFQUERYPARAM VALUE="#dateDon#" CFSQLTYPE="CF_SQL_DATE">,
						description		=	<CFQUERYPARAM VALUE="#Trim(arguments.description)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.description EQ ""#">,
						donateurID		=	<CFQUERYPARAM VALUE="#trouveDonateurID.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">,
						montant			=	<CFQUERYPARAM VALUE="#arguments.montant#" CFSQLTYPE="CF_SQL_MONEY">,
						methodeDonID	=	<CFQUERYPARAM VALUE="#arguments.methodeDonID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#trim(arguments.methodeDonID) EQ ""#">
				WHERE donID	=	<CFQUERYPARAM VALUE="#arguments.donID#" CFSQLTYPE="CF_SQL_INTEGER">
		
			</CFQUERY>
			<CFIF Session.langue EQ "fr">
				<CFSET LOCAL.message = "L'information a &eacute;t&eacute; mise &agrave; jour avec succ&egrave;s.">
			<CFELSE>
				<CFSET LOCAL.message = "Information was updated successfully.">
			</CFIF>
		<CFELSE>
			<CFIF Session.langue EQ "fr">
				<CFSET LOCAL.message = "Le syst&egrave;me ne peut reconna&icirc;tre le num&eacute;ro de compte ou le num&eacute;ro du donateur.">
			<CFELSE>
				<CFSET LOCAL.message = "The account number or the donor number can't be recognized.">
			</CFIF>
		</CFIF>
		
		<CFRETURN LOCAL.message>
		
	</cffunction>
	
	<cffunction name="donInfos" access="remote" returntype="query" >
		<cfargument name="donID"  required="true" >
		
		<CFQUERY NAME="donInfos" DATASOURCE="#APPLICATION.DSN#">
		SELECT d.donID, d.compteID, d.dateDon, d.description, d.donateurID, d.montant, d.verouille, d.methodeDonID, c.noCompte, dt.numero
		FROM dons AS d
			INNER JOIN comptes AS c ON d.compteID = c.compteID
			INNER JOIN donateurs AS dt ON d.donateurID = dt.donateurID
		WHERE d.donID = <CFQUERYPARAM VALUE="#arguments.donID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN donInfos>
	</cffunction>
	
	<cffunction name="donateurInfos" access="remote" returntype="query" >
		<cfargument name="donateurID"  required="true" >
		
		<CFQUERY NAME="donateurInfos" DATASOURCE="#APPLICATION.DSN#">
		SELECT * FROM donateurs
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN donateurInfos>
	</cffunction>
	
	<cffunction name="donsListe" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDon"  required="false" default="">
		<cfargument name="dateDonFin"  required="false" default="">
		<cfargument name="langue"  required="false" default="fr">
		<cfargument name="numero"  required="false" default="">
		<cfargument name="noCompte"  required="false" default="">
		<cfargument name="montant"  required="false" default="">
		<cfargument name="description"  required="false" default="">
		<cfargument name="tri"  required="false" default="dateD">
		
		<CFIF isNumeric(arguments.montant)>
			 <CFSET LOCAL.montant = arguments.montant>
		<CFELSE>
			<CFSET LOCAL.montant = "">
		</CFIF>
		
		<!---  --->
		<CFQUERY NAME="donsListe" DATASOURCE="#APPLICATION.DSN#">
		SELECT d.donID, d.donateurID, d.compteID, d.montant, d.description, d.dateDon, d.verouille, dr.courriel, dr.nom, dr.prenom, dr.numero, c.noCompte, c.nom as libelleCompte, m.methode_#arguments.langue# as methode, methode_intuit FROM dons AS d 
			INNER JOIN  donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
			LEFT JOIN methodesDon AS m ON d.methodeDonID = m.methodeDonID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.dateDon NEQ "" AND isDate(arguments.dateDon)>AND d.dateDon >= <CFQUERYPARAM VALUE="#arguments.dateDon#" CFSQLTYPE="CF_SQL_DATE"> </CFIF>
		<CFIF arguments.dateDonFin NEQ "" AND isDate(arguments.dateDonFin)>AND d.dateDon <= <CFQUERYPARAM VALUE="#arguments.dateDonFin#" CFSQLTYPE="CF_SQL_DATE"> </CFIF>
		<!--- <CFIF arguments.dateDon NEQ "">AND d.dateDon LIKE <CFQUERYPARAM VALUE="%#arguments.dateDon#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF> --->
		<CFIF arguments.numero NEQ "">AND dr.numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		<CFIF arguments.noCompte NEQ "">AND c.noCompte = <CFQUERYPARAM VALUE="#arguments.noCompte#" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		<CFIF LOCAL.montant NEQ "">AND d.montant = <CFQUERYPARAM VALUE="#LOCAL.montant#" CFSQLTYPE="CF_SQL_money"> </CFIF>
		<CFIF arguments.description NEQ "">AND d.description LIKE <CFQUERYPARAM VALUE="%#arguments.description#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		ORDER BY 
		<CFIF arguments.tri EQ "dateA">
			d.dateDon ASC, dr.nom, dr.prenom
		<CFELSEIF arguments.tri EQ "dateD">
			d.dateDon DESC, dr.nom, dr.prenom
		<CFELSEIF arguments.tri EQ "donateurA">
			CAST(dr.numero as BIGINT)
		<CFELSEIF arguments.tri EQ "donateurD">
			CAST(dr.numero as BIGINT) DESC
		<CFELSEIF arguments.tri EQ "compteA">
			c.noCompte 
		<CFELSEIF arguments.tri EQ "compteD">
			c.noCompte DESC
		<CFELSEIF arguments.tri EQ "donA">
			d.montant
		<CFELSEIF arguments.tri EQ "donD">
			d.montant DESC
		<CFELSEIF arguments.tri EQ "methodeA">
			methode
		<CFELSEIF arguments.tri EQ "methodeD">
			methode DESC
		</CFIF>
		</CFQUERY>
		
		<CFRETURN donsListe>
	</cffunction>
	
	<cffunction name="donsListeTous" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		
		<CFQUERY NAME="donsListeTous" DATASOURCE="#APPLICATION.DSN#">
		SELECT d.donID, d.donateurID, d.compteID, d.dateEntree, d.montant, d.description, d.dateDon, d.verouille, dr.nom, dr.prenom, dr.numero, c.noCompte, c.nom as libelleCompte FROM dons AS d 
			INNER JOIN  donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		ORDER BY d.dateDon DESC, dr.nom, dr.prenom
		</CFQUERY>
		<CFRETURN donsListeTous>
	</cffunction>
	
	<cffunction name="donsTotal" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDon"  required="false" default="">
		<cfargument name="dateDonFin"  required="false" default="">
		<cfargument name="numero"  required="false" default="">
		<cfargument name="noCompte"  required="false" default="">
		<cfargument name="montant"  required="false" default="">
		<cfargument name="description"  required="false" default="">
		<CFIF isNumeric(arguments.montant)>
			 <CFSET LOCAL.montant = arguments.montant>
		<CFELSE>
			<CFSET LOCAL.montant = "">
		</CFIF>
		
		<CFQUERY NAME="donsTotal" DATASOURCE="#APPLICATION.DSN#">
		SELECT SUM(d.montant) as total FROM dons AS d 
			INNER JOIN  donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<!--- <CFIF arguments.dateDon NEQ "">AND d.dateDon LIKE <CFQUERYPARAM VALUE="%#arguments.dateDon#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF> --->
		<CFIF arguments.dateDon NEQ "" AND isDate(arguments.dateDon)>AND d.dateDon >= <CFQUERYPARAM VALUE="#arguments.dateDon#" CFSQLTYPE="CF_SQL_DATE"> </CFIF>
		<CFIF arguments.dateDonFin NEQ "" AND isDate(arguments.dateDonFin)>AND d.dateDon <= <CFQUERYPARAM VALUE="#arguments.dateDonFin#" CFSQLTYPE="CF_SQL_DATE"> </CFIF>
		<CFIF arguments.numero NEQ "">AND dr.numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		<CFIF arguments.noCompte NEQ "">AND c.noCompte = <CFQUERYPARAM VALUE="#arguments.noCompte#" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		<CFIF LOCAL.montant NEQ "">AND d.montant = <CFQUERYPARAM VALUE="#LOCAL.montant#" CFSQLTYPE="CF_SQL_money"> </CFIF>
		<CFIF arguments.description NEQ "">AND d.description LIKE <CFQUERYPARAM VALUE="%#arguments.description#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
		</CFQUERY>
		
		<CFRETURN donsTotal>
	</cffunction>

	<cffunction name="donSupprimer" access="remote" returntype="string" >
		<cfargument name="donID"  required="true" >
		
		<CFSET LOCAL.message = "">
		
		<CFQUERY NAME="donSupprimer" DATASOURCE="#APPLICATION.DSN#">
		DELETE FROM dons
		WHERE donID = <CFQUERYPARAM VALUE="#arguments.donID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
	
		<CFIF session.utilisateur.langue EQ "fr">
			<CFSET LOCAL.message = "Don supprim&eacute; avec succ&egrave;s">
		<CFELSE>
			<CFSET LOCAL.message = "Gift deleted successfully">
		</CFIF>
		<CFRETURN LOCAL.message>
	</cffunction>
	
	<cffunction name="donsVerouiller" access="remote" >
		<cfargument name="organismeID"  required="true" >
		
		<CFQUERY NAME="donsVerouiller" DATASOURCE="#APPLICATION.DSN#">
		UPDATE dons
			SET verouille = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		WHERE donID IN (SELECT donID FROM dons AS d 
								INNER JOIN donateurs AS dr ON d.donateurID = dr.donateurID 
								WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">)
		</CFQUERY>
	</cffunction>
	
	<cffunction name="InfosOrganisme" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		
		<CFQUERY NAME="InfosOrganisme" DATASOURCE="#APPLICATION.DSN#">
		SELECT  o.organismeID, o.adresse, o.code_postal, o.date_fin_licence, o.enregistrement, o.etatID, o.membre, o.organisme, o.provinceID, o.responsable, o.signature, o.telephone, o.ville, p.abreviation as province
  		FROM organismes as o 
  			INNER JOIN provinces AS p ON o.provinceID = p.provinceID
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFRETURN InfosOrganisme>
	</cffunction>

	<cffunction name="methodesDonListe" access="remote" returntype="query" >
		<cfargument name="langue"  required="true" >

		<CFIF arguments.langue EQ "fr">
			<CFQUERY NAME="methodesDonListe" DATASOURCE="#APPLICATION.DSN#">
			SELECT methodeDonID, methode_fr AS methode
			FROM methodesDon
			ORDER BY ordre
			</CFQUERY>
		<CFELSE>
			<CFQUERY NAME="methodesDonListe" DATASOURCE="#APPLICATION.DSN#">
			SELECT methodeDonID, methode_en AS methode
			FROM methodesDon
			ORDER BY ordre
			</CFQUERY>
		</CFIF>

		<CFRETURN methodesDonListe>
	</cffunction>

	<cffunction name="RapportRecus" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="annee"  required="true" >
		<cfargument name="donateurs"  required="false" default="tous">
		<cfargument name="debut"  required="false" default="">
		<cfargument name="fin"  required="false" default="">
		
		<CFQUERY NAME="RapportRecus" DATASOURCE="#APPLICATION.DSN#">
		SELECT d.donID, d.donateurID, d.compteID, d.montant, d.description, d.dateDon, d.verouille, dr.adresse, dr.code_postal, dr.donateurID, dr.nom, dr.prenom, dr.numero, dr.ville, c.noCompte, c.nom as libelleCompte, p.abreviation as province 
		FROM dons AS d 
			INNER JOIN  donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
			INNER JOIN provinces AS p ON dr.provinceID = p.provinceID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		AND	c.recu = <CFQUERYPARAM VALUE="TRUE" CFSQLTYPE="CF_SQL_BIT">
		<CFIF arguments.donateurs EQ "selection">
			<CFIF arguments.debut NEQ "">
				AND dr.numero >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND dr.numero <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
		</CFIF>
		ORDER BY dr.nom, dr.prenom, dr.donateurID
		</CFQUERY>
		
		<CFRETURN RapportRecus>
	</cffunction>
	
</cfcomponent>
