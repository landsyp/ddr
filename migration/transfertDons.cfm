<cfsetting showDebugOutput="No">
<cfsetting RequestTimeout = "600">
<CFTRY>
	<!--- *** NE PAS OUBLIE D'INSCRIRE L'ORGANISMEID  *** --->

	<!--- MODELE EXCEL AVEC ENTETE--->
	<!--- 				
			1	giftID (Access inséré dans dons.donID_DDR1)
			2	donateurID_DDR1
			3	compteID_DDR1
			4	dateDon
			5	montant
			6	description
		--->

	<CFTRANSACTION>
		<CFIF isDefined('Form.uploadexcel')>
		
			<!--- AJOUT MANUEL --->
			
			<!--- <cfset organismeID = "310"> --->
			
		
			<CFFILE ACTION="UPLOAD" FILEFIELD="dons" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
				<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
			
				<cfset document2 = "#APPLICATION.Path#\temp\newdocument.#File.ClientFileExt#">
			
				<cffile action="COPY" source=#document1# destination=#document2#>
			
				<cffile action="DELETE" file=#document1#> 
			
				<cfspreadsheet action="read" src="#Application.Path#\temp\newdocument.xlsx" query="excelquery" sheet="1" >
				<!--- <cfdump var="#excelquery#"> --->
			
				<cfoutput query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
				
					<CFQUERY NAME="getcompteID" DATASOURCE="#APPLICATION.DSN#" >
						SELECT compteID FROM comptes 
						WHERE  compteID_DDR1 = <CFQUERYPARAM VALUE="#excelQuery.col_3#" CFSQLTYPE="CF_SQL_INTEGER" >
						AND	organismeID = <CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER" >
					</CFQUERY>
					<CFQUERY NAME="getdonateurID" DATASOURCE="#APPLICATION.DSN#" >
						SELECT donateurID FROM donateurs 
						WHERE  donateurID_DDR1 = <CFQUERYPARAM VALUE="#excelQuery.col_2#" CFSQLTYPE="CF_SQL_INTEGER" >
						AND	organismeID = <CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER" >
					</CFQUERY>
					
					<table style="border: solid 1px black;">
					<tr>
					<td>giftid</td>
					<td>#excelQuery.col_1#</td>
					</tr>
					<tr>
					<td>donateurID_DDR1</td> 
					<td>#excelQuery.col_2# - #getdonateurID.donateurID#</td>
					</tr>
					<tr>
					<td>compteID_DDR1</td>
					<td>#excelQuery.col_3# - #getcompteID.compteID#</td>
					</tr>
					<tr>
					<td>dateDon</td>
					<td>#DateFormat(excelQuery.col_4, "yyyy-mm-dd")#  </td>
					</tr>
					<tr>
					<td>montant</td>
					<td>#excelQuery.col_5# - #LSParseCurrency(excelQuery.col_5)#  </td>
					</tr>
					<tr>
					<td>description</td>
					<td>#excelQuery.col_6#  </td>
					</tr>
					</table>
					
				<!--- J'UTILISE LSParseCurrency POUR FORMATER EN NOMBRE LES MONTANTS AVEC , POUR SEPARER LES MILLIERS --->
				<!--- 
				<CFQUERY NAME="ajoutcompte" DATASOURCE="#APPLICATION.DSN#" result="NeoDonateur">
					INSERT INTO  dons (compteID, dateDon, description, donateurID, montant)
				 																																																																																								
					VALUES (<CFQUERYPARAM VALUE="#getCompteID.compteID#" CFSQLTYPE="CF_SQL_INTEGER" >,
							<CFQUERYPARAM VALUE="#DateFormat(excelQuery.col_4, "yyyy-mm-dd")#" CFSQLTYPE="CF_SQL_DATE" >,
							<CFQUERYPARAM VALUE="#excelQuery.col_6#" CFSQLTYPE="CF_SQL_VARCHAR">,
							<CFQUERYPARAM VALUE="#getdonateurID.donateurID#" CFSQLTYPE="CF_SQL_INTEGER">,
							<CFQUERYPARAM VALUE="#LSParseCurrency(excelQuery.col_5)#" CFSQLTYPE="cf_sql_money">
							)
				</CFQUERY>
				 --->
					 
				</cfoutput>
				<cfset message = "Successful upload">
				<cffile action="DELETE" file=#document2#> 
		</CFIF>
	</CFTRANSACTION>

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
		"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		
			<title>DDR - Admin</title>
		</head>

		<body>

			<h2>TRANSFERT DONS</h2>

			<br />
			<br />
			<CFFORM ACTION="/migration/dons" METHOD="POST" NAME="dons" ENCTYPE="multipart/form-data">
			<input type="file" name="dons" id="dons" /> fichier Excel .xlsx
			<input type="submit" name="uploadexcel" id="uploadexcel" value="Upload" /> 
			</CFFORM>
			
			
		</body>
	</html>
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