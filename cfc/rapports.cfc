<cfcomponent displayname="rapports" hint="Cette composante gere les fonctions pour les rapports">
	
	<cffunction name="bordereauDepot" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="date" required="true" >
		<cfargument name="dateDebut" required="false" default="">
		<cfargument name="dateFin" required="false" default="">
		<cfargument name="donateurs" required="false" default="tous">
		<cfargument name="debut" required="false" default="">
		<cfargument name="fin" required="false" default="">
		<cfargument name="langue" required="true" >

		<CFQUERY NAME="bordereauDepot" DATASOURCE="#APPLICATION.DSN#">
			SELECT DatePart(year,d.datedon) year, DatePart(month,d.datedon) month, d.datedon, d.montant,  dr.numero, dr.prenom, dr.nom, md.methode_#arguments.langue# as mode
			FROM dons AS d
				INNER JOIN donateurs AS dr ON d.donateurID = dr.donateurID
				LEFT JOIN methodesDon AS md ON d.methodeDonID = md.methodeDonID
				
			WHERE dr.organismeID = 	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND		d.methodeDonID  IN (5,6)<!--- Comptant, cheque --->
			<CFIF arguments.date EQ "periode">
				<CFIF arguments.dateDebut NEQ "">
					AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
				</CFIF>
				<CFIF arguments.dateFin NEQ "">
					AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE"> 
				</CFIF>
			</CFIF>
			<CFIF arguments.donateurs EQ "selection">
				<CFIF arguments.debut NEQ "">
					AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
				</CFIF>
				<CFIF arguments.fin NEQ "">
					AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR"> 
				</CFIF>
			</CFIF>
			ORDER BY mode, CAST(dr.numero as NUMERIC(18,0)), dr.nom, dr.prenom
		</CFQUERY>
	
		<CFRETURN bordereauDepot>
	</cffunction>
	
	<cffunction name="InfosOrganisme" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		
		<CFQUERY NAME="InfosOrganisme" DATASOURCE="#APPLICATION.DSN#">
		SELECT  o.organismeID, o.adresse, o.code_postal, o.date_fin_licence, o.devise, o.enregistrement, o.enregistrement_us, o.etatID, o.folio, o.logoExt, o.membre, o.organisme, o.provinceID, o.reponse_courriel, o.responsable, o.signatureExt, o.telephone, o.transit, o.ville, p.abreviation as province
  		FROM organismes as o 
  			INNER JOIN provinces AS p ON o.provinceID = p.provinceID
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFRETURN InfosOrganisme>
	</cffunction>
	
	<cffunction name="RapportRecusDonateurs" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="annee"  required="true" >
		<cfargument name="donateurs"  required="false" default="tous">
		<cfargument name="debut"  required="false" default="">
		<cfargument name="fin"  required="false" default="">
		<cfargument name="tri"  required="true" default="ORDER BY dr.nom, dr.prenom">
		
		<CFQUERY NAME="RapportRecusDonateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT dr.donateurID, dr.adresse, dr.code_postal, dr.donateurID, dr.nom, dr.prenom, dr.numero, dr.ville, p.abreviation as province 
		FROM donateurs AS dr 
			INNER JOIN provinces AS p ON dr.provinceID = p.provinceID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.donateurs EQ "selection">
			<CFIF arguments.debut NEQ "">
				AND dr.numero >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND dr.numero <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
		</CFIF>
		AND dr.donateurID IN (SELECT d.donateurID FROM dons as d 
										INNER JOIN comptes AS c ON d.compteID = c.compteID 
										WHERE c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
										AND	year(d.dateDon) = <CFQUERYPARAM VALUE="#arguments.annee#" CFSQLTYPE="CF_SQL_INTEGER">)
		AND dr.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		<CFIF arguments.tri EQ "nom">
			ORDER BY dr.nom, dr.prenom
		<CFELSE>
			ORDER BY CAST(dr.numero as NUMERIC(18,0))
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RapportRecusDonateurs>
	</cffunction>
	
	<cffunction name="RapportRecusCourrielsDonateursDates" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="donateurs"  required="false" default="tous">
		<cfargument name="debut"  required="false" default="">
		<cfargument name="fin"  required="false" default="">
		<cfargument name="tri"  required="true" default="ORDER BY dr.nom, dr.prenom"> 
		
		<CFQUERY NAME="RapportRecusDonateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT dr.donateurID, dr.adresse, dr.code_postal, dr.donateurID, dr.nom, dr.prenom, dr.numero, dr.ville, p.abreviation as province, dr.courriel
		FROM donateurs AS dr 
			INNER JOIN provinces AS p ON dr.provinceID = p.provinceID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.donateurs EQ "selection">  
			<CFIF arguments.debut NEQ "">  
				AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR">  
			</CFIF> 
			<!--- AND dr.donateurID IN (62652,62664,62690,63175,63278,63329,64259,64583,64594,65940,66588,66601,67296,67302,67303,67311,67699,67896,68098,68118,69584) --->
		</CFIF>
		AND courriel IS NOT NULL
		<!--- ceux qui ont effectués des dons durant la période requise --->
		AND dr.donateurID IN (SELECT d.donateurID FROM dons as d 
								INNER JOIN comptes AS c ON d.compteID = c.compteID 
								WHERE c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
								AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
								AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">)
		<!--- ceux qui n'ont pas déjà reçus le courriel pour la période requise --->
		AND dr.donateurID NOT IN (SELECT donateurID FROM envois 
									WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
									AND dateDebut =  <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
									AND dateFin  =	<CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
									AND statut = <CFQUERYPARAM VALUE="2-livre" CFSQLTYPE="CF_SQL_VARCHAR">)
		AND dr.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		<CFIF arguments.tri EQ "nom">
			ORDER BY dr.nom, dr.prenom
		<CFELSE>
			ORDER BY CAST(dr.numero as NUMERIC(18,0))
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RapportRecusDonateurs>
	</cffunction>

	<cffunction name="RapportRecusDonateursDates" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="donateurs"  required="false" default="tous">
		<cfargument name="debut"  required="false" default="">
		<cfargument name="fin"  required="false" default="">
		<cfargument name="tri"  required="true" default="ORDER BY dr.nom, dr.prenom"> 
		
		<CFQUERY NAME="RapportRecusDonateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT dr.donateurID, dr.adresse, dr.code_postal, dr.donateurID, dr.nom, dr.prenom, dr.numero, dr.ville, p.abreviation as province, dr.courriel
		FROM donateurs AS dr 
			INNER JOIN provinces AS p ON dr.provinceID = p.provinceID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.donateurs EQ "selection">  
			<CFIF arguments.debut NEQ "">  
				AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR">  
			</CFIF> 
		
		<CFELSEIF arguments.donateurs EQ "sansCourriel"> 
			AND courriel IS NULL
		</CFIF>
		AND dr.donateurID IN (SELECT d.donateurID FROM dons as d 
										INNER JOIN comptes AS c ON d.compteID = c.compteID 
										WHERE c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
										AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
										AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">)
		AND dr.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		<CFIF arguments.tri EQ "nom">
			ORDER BY dr.nom, dr.prenom
		<CFELSE>
			ORDER BY CAST(dr.numero as NUMERIC(18,0))
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RapportRecusDonateurs>
	</cffunction>

	<cffunction name="RecusDonateurs" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="sansCourriel"  required="true" >
		<cfargument name="debut"  required="true" >
		<cfargument name="fin"  required="true">
		<cfargument name="tri"  required="true" default="ORDER BY dr.nom, dr.prenom"> 
		
		<CFQUERY NAME="RecusDonateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT dr.donateurID, dr.adresse, dr.code_postal, dr.donateurID, dr.nom, dr.prenom, dr.numero, dr.ville, p.abreviation as province, dr.courriel
		FROM donateurs AS dr 
			INNER JOIN provinces AS p ON dr.provinceID = p.provinceID
		WHERE dr.organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.debut NEQ "">  
			AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
		</CFIF>
		<CFIF arguments.fin NEQ "">
			AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR">  
		</CFIF> 
		
		<CFIF arguments.sansCourriel EQ "yes"> 
			AND courriel IS NULL
		</CFIF>
		AND dr.donateurID IN (SELECT distinct d.donateurID FROM dons as d 
										INNER JOIN comptes AS c ON d.compteID = c.compteID 
										WHERE c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
										AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
										AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">)
		AND dr.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
		<CFIF arguments.tri EQ "nom">
			ORDER BY dr.nom, dr.prenom
		<CFELSE>
			ORDER BY CAST(dr.numero as NUMERIC(18,0))
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RecusDonateurs>
	</cffunction>
				
	<cffunction name="RapportRecusMontant" access="remote" returntype="numeric" >
		<cfargument name="annee"  required="true" >
		<cfargument name="donateurID"  required="true">
		
		<CFQUERY NAME="RapportRecusMontant" DATASOURCE="#APPLICATION.DSN#">
		SELECT SUM(montant) as montantTotal FROM dons as d 
			INNER JOIN comptes AS c ON d.compteID = c.compteID 
			WHERE d.donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
			AND	year(d.dateDon) = <CFQUERYPARAM VALUE="#arguments.annee#" CFSQLTYPE="CF_SQL_INTEGER">
		</CFQUERY>
		<CFRETURN RapportRecusMontant.montantTotal>
	</cffunction>
	
	<cffunction name="RapportRecusMontantDates" access="remote" returntype="numeric" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="donateurID"  required="true">
		
		<CFQUERY NAME="RapportRecusMontantDates" DATASOURCE="#APPLICATION.DSN#">
		SELECT SUM(montant) as montantTotal FROM dons as d 
			INNER JOIN comptes AS c ON d.compteID = c.compteID 
			WHERE d.donateurID = <CFQUERYPARAM VALUE="#arguments.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">
			AND	c.recu = <CFQUERYPARAM VALUE="True" CFSQLTYPE="CF_SQL_BIT">
			AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
			AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
		</CFQUERY>
		<CFRETURN RapportRecusMontantDates.montantTotal>
	</cffunction>
	
	<cffunction name="RapportDons" access="remote" returntype="query" >
		<cfargument name="langue"  required="true" default="fr" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="grouperpar" required="false" default="date" >
		<cfargument name="date" required="true" >
		<cfargument name="dateDebut" required="false" default="">
		<cfargument name="dateFin" required="false" default="">
		<cfargument name="donateurs" required="false" default="tous">
		<cfargument name="debut" required="false" default="">
		<cfargument name="fin" required="false" default="">
		
		<cfset LOCAL.langue = (arguments.langue EQ "fr") ? "fr" : "en">
		<!--- <CFQUERY NAME="DonsOrganimses" DATASOURCE="#APPLICATION.DSN#">
		SELECT * FROM dons 
		WHERE compteID IN  (SELECT compteID FROM comptes WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">) 
		</CFQUERY> --->
		
		<CFQUERY NAME="RapportDons" DATASOURCE="#APPLICATION.DSN#">
		SELECT  d.datedon, d.description, d.montant,  dr.prenom, dr.nom, dr.nom+', '+dr.prenom AS nomComplet, dr.numero, dr.recu AS recuDonateur, c.Nocompte, c.nom as compte, c.recu, ISNULL(md.ordre, 0) AS methodeOrdre, md.methode_#LOCAL.langue# AS methode, c.recu & dr.recu as donRecu
		FROM dons AS d
			INNER JOIN donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
			LEFT JOIN methodesDon AS md ON d.methodeDonID = md.methodeDonID
		WHERE dr.organismeID = 	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.date EQ "periode">
			<CFIF arguments.dateDebut NEQ "">
				AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
			</CFIF>
			<CFIF arguments.dateFin NEQ "">
				AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE"> 
			</CFIF>
		</CFIF>
		<CFIF arguments.donateurs EQ "selection">
			<CFIF arguments.debut NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
		</CFIF>
		<CFIF arguments.grouperpar EQ "date">
			<!--- ORDER BY d.datedon, c.recu, dr.nom, dr.prenom, c.Nocompte --->
			ORDER BY d.datedon, donRecu, CAST(dr.numero as NUMERIC(18,0)), dr.nom, dr.prenom 
		<CFELSEIF arguments.grouperpar EQ "compte">
			ORDER BY c.Nocompte, donRecu, CAST(dr.numero as NUMERIC(18,0)), dr.nom, dr.prenom, d.datedon
		<CFELSEIF arguments.grouperpar EQ "donateur">
			ORDER BY  dr.nom, dr.prenom,  donRecu, d.datedon, c.Nocompte
		<CFELSEIF arguments.grouperpar EQ "numero">
			ORDER BY CAST(dr.numero as NUMERIC(18,0)), donRecu, dr.nom, dr.prenom, d.datedon, c.Nocompte
		<CFELSEIF arguments.grouperpar EQ "methode">
			ORDER BY methodeOrdre,  donRecu, dr.nom, dr.prenom, d.datedon, c.Nocompte
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RapportDons>
	</cffunction>
	
	<cffunction name="RapportDonsSommaire" access="remote" returntype="query" >
		<cfargument name="organismeID" required="true" >
		<cfargument name="grouperpar" required="true" >
		<cfargument name="date" required="true" >
		<cfargument name="dateDebut" required="false" default="">
		<cfargument name="dateFin" required="false" default="">
		<cfargument name="donateurs" required="false" default="tous">
		<cfargument name="debut" required="false" default="">
		<cfargument name="fin" required="false" default="">
		
		<cfset LOCAL.langue = (arguments.langue EQ "fr") ? "fr" : "en">
		<CFQUERY NAME="RapportDonsSommaire" DATASOURCE="#APPLICATION.DSN#">
		SELECT DatePart(year,d.datedon) year, DatePart(month,d.datedon) month, d.datedon, d.montant, c.Nocompte, c.nom as compte, dr.numero, dr.prenom, dr.nom, c.recu, ISNULL(md.ordre, 0) AS methodeOrdre, md.methode_#LOCAL.langue# AS methode
		FROM dons AS d
			INNER JOIN donateurs AS dr ON d.donateurID = dr.donateurID
			INNER JOIN comptes AS c ON d.compteID = c.compteID
			LEFT JOIN methodesDon AS md ON d.methodeDonID = md.methodeDonID
		WHERE dr.organismeID = 	<CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.date EQ "periode">
			<CFIF arguments.dateDebut NEQ "">
				AND d.datedon >= <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE"> 
			</CFIF>
			<CFIF arguments.dateFin NEQ "">
				AND d.datedon <= <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE"> 
			</CFIF>
		</CFIF>
		<CFIF arguments.donateurs EQ "selection">
			<CFIF arguments.debut NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
			<CFIF arguments.fin NEQ "">
				AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR"> 
			</CFIF>
		</CFIF>
		<!--- <CFIF Find("date", arguments.grouperpar)> 
			ORDER BY year, month, d.datedon
		<CFELSEIF Find("compte", arguments.grouperpar)>
			ORDER BY year, month, c.NoCompte
		<CFELSEIF Find("donateur",arguments.grouperpar)>
			ORDER BY year, month, dr.nom, dr.numero
		<CFELSEIF Find("methode", arguments.grouperpar)>
			ORDER BY year, month, methodeOrdre
		</CFIF> --->
		<CFIF arguments.grouperpar EQ "date" OR arguments.grouperpar EQ "mois-date"> 
			ORDER BY year, month, d.datedon
		<CFELSEIF arguments.grouperpar EQ "annee-date">
			ORDER BY year, d.datedon
		<CFELSEIF arguments.grouperpar EQ "compte" OR arguments.grouperpar EQ "mois-compte">
			ORDER BY year, month, c.NoCompte
		<CFELSEIF arguments.grouperpar EQ "annee-compte">
			ORDER BY year, c.NoCompte
		<CFELSEIF arguments.grouperpar EQ "donateur" OR arguments.grouperpar EQ "mois-donateur"> 
			ORDER BY year, month, dr.nom, dr.numero
		<CFELSEIF arguments.grouperpar EQ "annee-donateur"> 
			ORDER BY year, dr.nom, dr.numero
		<CFELSEIF arguments.grouperpar EQ "methode" OR arguments.grouperpar EQ "mois-methode">
			ORDER BY year, month, methodeOrdre
		<CFELSEIF arguments.grouperpar EQ "annee-methode"> 
			ORDER BY year, methodeOrdre
		</CFIF>
		</CFQUERY>
	
		<CFRETURN RapportDonsSommaire>
	</cffunction>
	
	<cffunction name="rapportDonateurs" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="statut"  required="false" default="">
		<cfargument name="tri"  required="false" default="">
		
		<CFIF arguments.statut EQ "actif">
			<cfset LOCAL.actif = "True">
		<CFELSEIF arguments.statut EQ "inactif">
			<cfset LOCAL.actif = "False">
		</CFIF>
		
		<CFQUERY NAME="rapportDonateurs" DATASOURCE="#APPLICATION.DSN#">
		SELECT  d.donateurID, d.actif, d.adresse, d.code_postal, d.courriel, d.nom, d.notes, d.numero, d.organismeID, d.prenom, d.provinceID, d.tel_bureau, d.tel_cellulaire, d.tel_residence, d.ville, p.abreviation as province
 		FROM donateurs AS d
 			INNER JOIN provinces AS p ON d.provinceID = p.provinceID
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.statut NEQ "tous">AND d.actif = <CFQUERYPARAM VALUE="#LOCAL.actif#" CFSQLTYPE="CF_SQL_BIT"> </CFIF>
		<CFIF arguments.tri EQ "numero">ORDER BY CAST(d.numero as NUMERIC(18,0))</CFIF>
		<CFIF arguments.tri EQ "nom">ORDER BY d.nom, d.prenom</CFIF>
		</CFQUERY>
		<CFRETURN rapportDonateurs>
	</cffunction>
	
	<cffunction name="rapportComptes" access="remote" returntype="query" >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="statut"  required="false" default="">
		<cfargument name="tri"  required="false" default="">
		
		<CFIF arguments.statut EQ "recu">
			<cfset LOCAL.recu = "True">
		<CFELSEIF arguments.statut EQ "sansRecu">
			<cfset LOCAL.recu = "False">
		</CFIF>
		
		<CFQUERY NAME="rapportComptes" DATASOURCE="#APPLICATION.DSN#">
		SELECT  compteID, noCompte, nom, recu
 		FROM comptes 
		WHERE organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
		<CFIF arguments.statut NEQ "tous">AND recu = <CFQUERYPARAM VALUE="#LOCAL.recu#" CFSQLTYPE="CF_SQL_BIT"> </CFIF>
		<CFIF arguments.tri EQ "noCompte">ORDER BY noCompte</CFIF>
		<CFIF arguments.tri EQ "nom">ORDER BY nom</CFIF>
		</CFQUERY>
		
		<CFRETURN rapportComptes>
	</cffunction>

	<cffunction name="SupprimerEnvoisEnCours" access="remote"  >
		<cfargument name="organismeID"  required="true" >
		<cfargument name="dateDebut"  required="true" >
		<cfargument name="dateFin"  required="true" >
		<cfargument name="donateurs"  required="false" default="tous">
		<cfargument name="debut"  required="false" default="">
		<cfargument name="fin"  required="false" default="">
		
		<cfset LOCAL.dateDebut = dateFormat(arguments.dateDebut, 'yyyy-mm-dd') & "-00-00-00">
		<cfset LOCAL.dateFin = dateFormat(arguments.dateFin, 'yyyy-mm-dd') & "-23-59-59">
		
		<CFQUERY NAME="envoisInfo" DATASOURCE="#APPLICATION.DSN#">
			DELETE FROM envois 
			WHERE	organismeID = <CFQUERYPARAM VALUE="#arguments.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			and  	statut = <CFQUERYPARAM VALUE="1-en-cours" CFSQLTYPE="CF_SQL_VARCHAR">
			<cfif arguments.dateDebut NEQ "">
				AND	dateDebut = <CFQUERYPARAM VALUE="#arguments.dateDebut#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<cfif arguments.dateFin NEQ "">
				AND	dateFin = <CFQUERYPARAM VALUE="#arguments.dateFin#" CFSQLTYPE="CF_SQL_DATE">
			</cfif>
			<!--- <CFIF arguments.donateurs EQ "selection">  
				<CFIF arguments.debut NEQ "">  
					AND CAST(dr.numero as NUMERIC(18,0)) >= <CFQUERYPARAM VALUE="#arguments.debut#" CFSQLTYPE="CF_SQL_VARCHAR"> 
				</CFIF>
				<CFIF arguments.fin NEQ "">
					AND CAST(dr.numero as NUMERIC(18,0)) <= <CFQUERYPARAM VALUE="#arguments.fin#" CFSQLTYPE="CF_SQL_VARCHAR">  
				</CFIF> 
			</CFIF> --->
		</CFQUERY>


		
	</cffunction>
	
</cfcomponent>
