<cfcomponent displayname="donateurs" hint="Cette composante gere les fonctions pour les donateurs">
	
	<cffunction name="donateurAjout" access="remote" returntype="string" >
		<cfargument name="actif" required="true">
		<cfargument name="adresse" required="true">
		<cfargument name="code_postal" required="true">
		<cfargument name="courriel" required="true">
		<cfargument name="membre" required="true">
		<cfargument name="nom" required="true">
		<cfargument name="notes" required="true">
		<cfargument name="numero" required="true">
		<cfargument name="organismeID"  required="true">
		<cfargument name="prenom" required="true">
		<cfargument name="provinceID" required="true">
		<cfargument name="recu" required="true">
		<cfargument name="tel_cellulaire" required="true">
		<cfargument name="tel_residence" required="true">
		<cfargument name="ville" required="true">
		
		<CFQUERY NAME="checkNumero" DATASOURCE="#APPLICATION.DSN#">
			SELECT donateurID FROM donateurs
			WHERE	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	numero = <CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
		</CFQUERY>
		
		<CFIF checkNumero.recordcount EQ 0>
			<CFIF arguments.prenom NEQ "">
				<cfset LOCAL.prenom = "#Trim(arguments.prenom)#">
			<CFELSE>
				<cfset LOCAL.prenom = " ">
			</CFIF>
		
			<CFQUERY NAME="donateurAjout" DATASOURCE="#APPLICATION.DSN#" RESULT="Neodonateur">
			INSERT INTO donateurs (actif, adresse, code_postal, courriel, membre, nom, notes, numero, organismeID, prenom, provinceID, recu, tel_cellulaire, tel_residence, ville)
			VALUES (	<CFQUERYPARAM VALUE="#arguments.actif#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.adresse)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.adresse EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.code_postal)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="20" NULL="#arguments.code_postal EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.courriel)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.courriel EQ ""#">,
						<CFQUERYPARAM VALUE="#arguments.membre#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150">,
						<CFQUERYPARAM VALUE="#Trim(arguments.notes)#" CFSQLTYPE="CF_SQL_LONGVARCHAR" >,
						<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
						<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#LOCAL.prenom#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150">,
						<CFQUERYPARAM VALUE="#arguments.provinceID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#arguments.provinceID EQ 0#">,
						<CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.tel_cellulaire)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_cellulaire EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.tel_residence)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_residence EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.ville)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50" NULL="#arguments.ville EQ ""#">)
			</CFQUERY>
			<cfset LOCAL.donateurID = Neodonateur.IDENTITYCOL>
		<CFELSE>
			<cfset LOCAL.donateurID = 0>
		</CFIF>
		
		<CFRETURN LOCAL.donateurID>
		
	</cffunction>
	
	<cffunction name="donateurAjoutBatch" access="remote" returntype="string" >
		<cfargument name="actif" required="true">
		<cfargument name="adresse" required="true">
		<cfargument name="code_postal" required="true">
		<cfargument name="courriel" required="true">
		<cfargument name="membre" required="true">
		<cfargument name="nom" required="true">
		<cfargument name="numero" required="true">
		<cfargument name="organismeID"  required="true">
		<cfargument name="prenom" required="true">
		<cfargument name="provinceID" required="true">
		<cfargument name="recu" required="true">
		<cfargument name="tel_cellulaire" required="true">
		<cfargument name="tel_residence" required="true">
		<cfargument name="ville" required="true">
		
		<CFQUERY NAME="checkNumero" DATASOURCE="#APPLICATION.DSN#">
			SELECT donateurID FROM donateurs
			WHERE	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND		(numero = <CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
			OR		(nom = <CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50"> AND prenom = <CFQUERYPARAM VALUE="#Trim(arguments.prenom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">))
		</CFQUERY>
		
		<CFIF checkNumero.recordcount EQ 0>
			<CFIF arguments.prenom NEQ "">
				<cfset LOCAL.prenom = "#Trim(arguments.prenom)#">
			<CFELSE>
				<cfset LOCAL.prenom = " ">
			</CFIF>
		
			<CFQUERY NAME="donateurAjout" DATASOURCE="#APPLICATION.DSN#" RESULT="Neodonateur">
			INSERT INTO donateurs (actif, adresse, code_postal, courriel, membre, nom, numero, organismeID, prenom, provinceID, recu, tel_cellulaire, tel_residence, ville)
			VALUES (	<CFQUERYPARAM VALUE="#arguments.actif#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.adresse)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.adresse EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.code_postal)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="20" NULL="#arguments.code_postal EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.courriel)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.courriel EQ ""#">,
						<CFQUERYPARAM VALUE="#arguments.membre#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
						<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
						<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">,
						<CFQUERYPARAM VALUE="#LOCAL.prenom#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
						<CFQUERYPARAM VALUE="#arguments.provinceID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#arguments.provinceID EQ 0#">,
						<CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#Trim(arguments.tel_cellulaire)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_cellulaire EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.tel_residence)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_residence EQ ""#">,
						<CFQUERYPARAM VALUE="#Trim(arguments.ville)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50" NULL="#arguments.ville EQ ""#">)
			</CFQUERY>
			<cfset LOCAL.donateurID = Neodonateur.IDENTITYCOL>
		<CFELSE>
			<cfset LOCAL.donateurID = 0>
			<CFQUERY NAME="donateurMAJ" DATASOURCE="#APPLICATION.DSN#" RESULT="NeoUtilisateur">
				UPDATE donateurs 
				SET	actif 	= 	<CFQUERYPARAM VALUE="#arguments.actif#" CFSQLTYPE="CF_SQL_BIT">,
					adresse	=	<CFQUERYPARAM VALUE="#Trim(arguments.adresse)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.adresse EQ ""#">,
					code_postal	=	<CFQUERYPARAM VALUE="#Trim(arguments.code_postal)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="20" NULL="#arguments.code_postal EQ ""#">,
					courriel	=	<CFQUERYPARAM VALUE="#Trim(arguments.courriel)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.courriel EQ ""#">,
					membre 	= 	<CFQUERYPARAM VALUE="#arguments.membre#" CFSQLTYPE="CF_SQL_BIT">,
					nom		=	<CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
					numero	=	<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
					prenom	=	<CFQUERYPARAM VALUE="#Trim(arguments.prenom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
					provinceID = <CFQUERYPARAM VALUE="#arguments.provinceID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#arguments.provinceID EQ 0#">,
					recu		=	<CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT">,
					tel_cellulaire = <CFQUERYPARAM VALUE="#Trim(arguments.tel_cellulaire)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_cellulaire EQ ""#">,
					tel_residence = <CFQUERYPARAM VALUE="#Trim(arguments.tel_residence)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_residence EQ ""#">,
					ville = <CFQUERYPARAM VALUE="#Trim(arguments.ville)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50" NULL="#arguments.ville EQ ""#">			
				WHERE donateurID	=	<CFQUERYPARAM VALUE="#checkNumero.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFQUERY>
		</CFIF>
		
		<CFRETURN LOCAL.donateurID>
		
	</cffunction>
	
	<cffunction name="donateurEdition" access="remote" returntype="string" >
		<cfargument name="actif" required="true">
		<cfargument name="adresse" required="true">
		<cfargument name="code_postal" required="true">
		<cfargument name="courriel" required="true">
		<cfargument name="membre" required="true">
		<cfargument name="nom" required="true">
		<cfargument name="notes" required="true">
		<cfargument name="numero" required="true">
		<cfargument name="prenom" required="true">
		<cfargument name="provinceID" required="true">
		<cfargument name="recu" required="true">
		<cfargument name="tel_cellulaire" required="true">
		<cfargument name="tel_residence" required="true">
		<cfargument name="ville" required="true">
		<cfargument name="donateurID"  required="true">
		
		<CFIF arguments.prenom NEQ "">
			<cfset LOCAL.prenom = "#Trim(arguments.prenom)#">
		<CFELSE>
			<cfset LOCAL.prenom = " ">
		</CFIF>
		
		<CFQUERY NAME="VerifierNumeroExistant" DATASOURCE="#APPLICATION.DSN#">
		SELECT * FROM donateurs
		WHERE 	donateurID 	<>	<CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		AND		organismeID =	<CFQUERYPARAM VALUE="#Session.utilisateur.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		AND		numero 		=	<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
		</CFQUERY>
		
		<CFIF VerifierNumeroExistant.recordcount GTE 1>
			<CFIF Session.langue EQ "fr">
				<CFSET LOCAL.message = "Erreur : le num&eacute;ro d'utilisateur entr&eacute; est d&eacute;j&agrave; utilis&eacute;">
			<CFELSE>
				<CFSET LOCAL.message = "Error : the donor number entered is already used.">
			</CFIF>
		<CFELSE> 
			<CFQUERY NAME="donateurEdition" DATASOURCE="#APPLICATION.DSN#" RESULT="NeoUtilisateur">
			UPDATE donateurs 
				SET	actif 	= 	<CFQUERYPARAM VALUE="#arguments.actif#" CFSQLTYPE="CF_SQL_BIT">,
						adresse	=	<CFQUERYPARAM VALUE="#Trim(arguments.adresse)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.adresse EQ ""#">,
						code_postal	=	<CFQUERYPARAM VALUE="#Trim(arguments.code_postal)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="20" NULL="#arguments.code_postal EQ ""#">,
						courriel	=	<CFQUERYPARAM VALUE="#Trim(arguments.courriel)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150" NULL="#arguments.courriel EQ ""#">,
						membre 	= 	<CFQUERYPARAM VALUE="#arguments.membre#" CFSQLTYPE="CF_SQL_BIT">,
						nom		=	<CFQUERYPARAM VALUE="#Trim(arguments.nom)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150">,
						notes	=	<CFQUERYPARAM VALUE="#Trim(arguments.notes)#" CFSQLTYPE="CF_SQL_LONGVARCHAR">,
						numero	=	<CFQUERYPARAM VALUE="#Trim(arguments.numero)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">,
						prenom	=	<CFQUERYPARAM VALUE="#LOCAL.prenom#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="150">,
						provinceID = <CFQUERYPARAM VALUE="#arguments.provinceID#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#arguments.provinceID EQ 0#">,
						recu		=	<CFQUERYPARAM VALUE="#arguments.recu#" CFSQLTYPE="CF_SQL_BIT">,
						tel_cellulaire = <CFQUERYPARAM VALUE="#Trim(arguments.tel_cellulaire)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_cellulaire EQ ""#">,
						tel_residence = <CFQUERYPARAM VALUE="#Trim(arguments.tel_residence)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="30" NULL="#arguments.tel_residence EQ ""#">,
						ville = <CFQUERYPARAM VALUE="#Trim(arguments.ville)#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="75" NULL="#arguments.ville EQ ""#">			
				WHERE donateurID	=	<CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			</CFQUERY>
			<CFIF Session.langue EQ "fr">
				<CFSET LOCAL.message = "L'information a &eacute;t&eacute; mise &agrave; jour avec succ&egrave;s.">
			<CFELSE>
				<CFSET LOCAL.message = "Information was updated successfully.">
			</CFIF>
		</CFIF>
		<CFRETURN LOCAL.message>
		
	</cffunction>
	
	<cffunction name="donateurInfos" access="remote" returntype="query" >
		<cfargument name="donateurID"  required="true" >
		
		<CFQUERY NAME="donateurInfos" DATASOURCE="#APPLICATION.DSN#">
		SELECT * FROM donateurs
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN donateurInfos>
	</cffunction>
	
	<cffunction name="donateurNomParNumero" access="remote" returntype="string" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="numero"  required="true" >
		
		<CFQUERY NAME="donateurNomParNumero" DATASOURCE="#APPLICATION.DSN#">
		<!--- UTILISATION DE ISNULL CAR SI LE CHAMP PRENOM EST NULL LA FONCTION NE RETOURNE RIEN --->
		SELECT ISNULL(prenom+' ','')+' '+ISNULL(nom+' ','') as nomComplet FROM donateurs
		WHERE numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR">
		AND 	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN donateurNomParNumero.nomcomplet>
	</cffunction>
	
	<cffunction name="donateursListe" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="actif"  required="false" default="True">
		<cfargument name="code_postal"  required="false" default="">
		<cfargument name="courriel"  required="false" default="">
		<cfargument name="numero"  required="false" default="">
		<cfargument name="nom"  required="false" default="">
		<cfargument name="prenom"  required="false" default="" >
		<cfargument name="tel_cellulaire"  required="false" default="" >
		<cfargument name="tel_residence"  required="false" default="" >
		<cfargument name="ville"  required="false" default="" >
		<cfargument name="recherche"  required="false" default="">
		<cfargument name="tri"  required="true" default="ORDER BY CAST(d.numero as NUMERIC(30,0))" >
		
		<CFQUERY NAME="donateursListe" DATASOURCE="#APPLICATION.DSN#">
			SELECT  d.donateurID, d.actif, d.adresse, d.code_postal, d.courriel, d.membre, d.nom, d.notes, numero, d.organismeID, d.prenom, d.provinceID, d.tel_bureau, d.tel_cellulaire, d.tel_residence, d.ville, p.abreviation as province
 			FROM donateurs AS d
 				INNER JOIN provinces AS p ON d.provinceID = p.provinceID
			WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	actif	=	<CFQUERYPARAM VALUE="#arguments.actif#" CFSQLTYPE="CF_SQL_BIT">
			<CFIF arguments.code_postal NEQ "">AND d.code_postal LIKE <CFQUERYPARAM VALUE="%#arguments.code_postal#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.courriel NEQ "">AND d.courriel LIKE <CFQUERYPARAM VALUE="%#arguments.courriel#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.numero NEQ "">AND d.numero LIKE <CFQUERYPARAM VALUE="%#arguments.numero#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.nom NEQ "">AND d.nom LIKE <CFQUERYPARAM VALUE="%#arguments.nom#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.prenom NEQ "">AND d.prenom LIKE <CFQUERYPARAM VALUE="%#arguments.prenom#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.tel_cellulaire NEQ "">AND d.tel_cellulaire LIKE <CFQUERYPARAM VALUE="%#arguments.tel_cellulaire#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.tel_residence NEQ "">AND d.tel_residence LIKE <CFQUERYPARAM VALUE="%#arguments.tel_residence#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.ville NEQ "">AND d.ville LIKE <CFQUERYPARAM VALUE="%#arguments.ville#%" CFSQLTYPE="CF_SQL_VARCHAR"> </CFIF>
			<CFIF arguments.recherche NEQ "">AND (d.nom LIKE <CFQUERYPARAM VALUE="%#arguments.recherche#%" CFSQLTYPE="CF_SQL_VARCHAR"> OR d.prenom LIKE <CFQUERYPARAM VALUE="%#arguments.recherche#%" CFSQLTYPE="CF_SQL_VARCHAR">)</CFIF>
			<CFIF arguments.tri EQ "numeroA">
				<!--- ORDER BY CAST(d.numero as INT) --->
				ORDER BY CAST(d.numero as NUMERIC(30,0))
			<CFELSEIF arguments.tri EQ "numeroD">
				<!--- ORDER BY CAST(d.numero as INT) DESC --->
				ORDER BY CAST(d.numero as NUMERIC(30,0)) DESC
			<CFELSEIF arguments.tri EQ "nomA">
				ORDER BY d.nom, d.prenom
			<CFELSEIF arguments.tri EQ "nomD">
				ORDER BY d.nom DESC, d.prenom DESC
			<CFELSEIF arguments.tri EQ "villeA">
				ORDER BY d.ville
			<CFELSEIF arguments.tri EQ "villeD">
				ORDER BY d.ville DESC
			</CFIF>

		</CFQUERY>
		
		<CFRETURN donateursListe>
	</cffunction>
	
	<cffunction name="donateursListeTous" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		
		<CFQUERY NAME="donateursListeTous" DATASOURCE="#APPLICATION.DSN#">
			SELECT  d.donateurID, d.actif, d.adresse, d.code_postal, d.courriel, d.membre, d.nom, d.notes, d.numero, d.organismeID, d.prenom, d.provinceID, d.tel_bureau, d.tel_cellulaire, d.tel_residence, d.ville, p.abreviation as province
 			FROM donateurs AS d
 				INNER JOIN provinces AS p ON d.provinceID = p.provinceID
			WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFRETURN donateursListeTous>
	</cffunction>
	
	<cffunction name="donateurArchiver" access="remote" returntype="string" >
		<cfargument name="donateurID"  required="true" >
		
		<CFSET LOCAL.message = "">
		<CFQUERY NAME="donateur" DATASOURCE="#APPLICATION.DSN#">
		SELECT numero, nom, prenom
		FROM donateurs
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFQUERY NAME="donateurArchiver" DATASOURCE="#APPLICATION.DSN#">
		UPDATE donateurs
		SET actif = <CFQUERYPARAM VALUE="False" CFSQLTYPE="CF_SQL_BIT">
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
	
		<CFIF session.langue EQ "fr">
			<CFSET LOCAL.message = "Donateur #donateur.prenom# #donateur.nom# (#donateur.numero#) a &eacute;t&eacute; archiv&eacute; avec succ&egrave;s">
		<CFELSE>
			<CFSET LOCAL.message = "Donor #donateur.prenom# #donateur.nom# (#donateur.numero#) was archived successfully">
		</CFIF>
		<CFRETURN LOCAL.message>
	</cffunction>
	
	<cffunction name="donateurActiver" access="remote" returntype="string" >
		<cfargument name="donateurID"  required="true" >
		
		<CFSET LOCAL.message = "">
		
		<CFQUERY NAME="donateur" DATASOURCE="#APPLICATION.DSN#">
		SELECT numero, nom, prenom
		FROM donateurs
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		
		<CFQUERY NAME="donateurActiver" DATASOURCE="#APPLICATION.DSN#">
		UPDATE donateurs
		SET actif = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		WHERE donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
	
		<CFIF session.langue EQ "fr">
			<CFSET LOCAL.message = "Donateur #donateur.prenom# #donateur.nom# (#donateur.numero#) a &eacute;t&eacute; activ&eacute; avec succ&egrave;s">
		<CFELSE>
			<CFSET LOCAL.message = "Donor #donateur.prenom# #donateur.nom# (#donateur.numero#) was activated successfully">
		</CFIF>
		<CFRETURN LOCAL.message>
	</cffunction> 
	
	
	<CFFUNCTION NAME="DonateurSuggestions" ACCESS="remote" RETURNTYPE="array"> 
		<cfargument name="suggestion" required="true">
		<cfargument name="organismeID"  required="true" >
		<cfset var tableau = ArrayNew(1)> 
		<cfquery name="DonateurSuggestions" datasource="#APPLICATION.DSN#" cachedwithin="#CreateTimeSpan(0,0,30,0)#"> 
		SELECT	numero
		FROM	donateurs
		WHERE	(numero LIKE <cfqueryparam value="%#suggestion#%"  cfsqltype="cf_sql_varchar">)
		AND organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		ORDER BY numero
		</cfquery> 
		
		<!--- CONVERT QUERY TO ARRAY ---> 
		<cfloop query="DonateurSuggestions"> 
			<cfset arrayAppend(tableau, numero)> 
		</cfloop> 
		<cfreturn tableau> 
	</CFFUNCTION> 
	
	<CFFUNCTION NAME="DonateurVerifierDuplicatNumero" ACCESS="remote" RETURNTYPE="numeric"> 
		<cfargument name="numero" required="true">
		<cfargument name="organismeID"  required="true" >
		
		<cfquery name="DonateurVerifierDuplicatNumero" datasource="#APPLICATION.DSN#" > 
		SELECT donateurID FROM donateurs
			WHERE	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	numero = <CFQUERYPARAM VALUE="#arguments.numero#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">
		</cfquery> 
		
		<cfreturn DonateurVerifierDuplicatNumero.recordcount> 
		
	</CFFUNCTION> 
	
	<cffunction name="provincesListe" access="remote" returntype="query" >
		<cfargument name="langue"  required="true" >
		
		<CFIF arguments.langue EQ "fr">
			<CFQUERY NAME="provincesListe" DATASOURCE="#APPLICATION.DSN#">
			SELECT pr.provinceID, pa.pays_fr+' '+pr.provinceEtat_fr AS province, pa.ordre FROM provinces as pr
				INNER JOIN pays AS pa ON pr.paysID = pa.paysID 
			ORDER BY ordre, province
			</CFQUERY>
		<CFELSE>
			<CFQUERY NAME="provincesListe" DATASOURCE="#APPLICATION.DSN#">
			SELECT pr.provinceID, pa.pays_en+' '+pr.provinceEtat_en AS province, pa.ordre FROM provinces as pr
				INNER JOIN pays AS pa ON pr.paysID = pa.paysID 
			ORDER BY ordre, province
			</CFQUERY>
		</CFIF> 
		
		<CFRETURN provincesListe>
	</cffunction>
	
	<cffunction name="ProchainNoDonateur" access="remote" returntype="string" >
		<cfargument name="organismeID"  required="true" >
		
		<cfquery name="NoDonateur" datasource="#APPLICATION.DSN#" > 
		SELECT	Max(CAST(numero as NUMERIC(10,0))) AS dernier
		FROM	donateurs
		WHERE	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</cfquery> 
		
		<!--- PAS DE DONATEUR  --->
		<CFIF NoDonateur.dernier EQ "">
			<CFSET LOCAL.numero = 1>
		<CFELSEIF isNumeric(NoDonateur.dernier)>
			<CFSET LOCAL.numero = NoDonateur.dernier+1 >
		<CFELSE>
			<CFSET LOCAL.numero = 1>
		</CFIF>
		<CFRETURN LOCAL.numero>
	</cffunction>
	
	<cffunction name="TrouvreProvinceID" access="remote" returntype="string" >
		<cfargument name="abreviation"  required="true" >
		
		<CFQUERY NAME="TrouvreProvinceID" DATASOURCE="#APPLICATION.DSN#">
			SELECT provinceID FROM provinces
			WHERE	abreviation = <CFQUERYPARAM VALUE="#arguments.abreviation#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="2">
		</CFQUERY>
		<CFIF TrouvreProvinceID.recordcount NEQ 0>
			<CFSET LOCAL.provinceID = TrouvreProvinceID.provinceID>
		<CFELSE>
			<CFSET LOCAL.provinceID = 0>
		</CFIF>
		
		<CFRETURN LOCAL.provinceID>
	</cffunction>
	
</cfcomponent>
