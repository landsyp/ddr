<CFTRY>
	<!--- *** NE PAS OUBLIE D'INSCRIRE L'ORGANISMEID  *** --->

	<!--- MODELE EXCEL AVEC ENTETE--->
	<!--- 				
			1	accountid (Access inséré dans comptes.DDR1_ID)
			2	noCompte
			3	nom
			4	recu
		--->

	<CFTRANSACTION>
		<CFIF isDefined('Form.uploadexcel')>
		
			<!--- AJOUT MANUEL --->
			<!--- <cfset organismeID = "310"> --->
		
			<CFFILE ACTION="UPLOAD" FILEFIELD="comptes" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
				<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
			
				<cfset document2 = "#APPLICATION.Path#\temp\newdocument.#File.ClientFileExt#">
			
				<cffile action="COPY" source=#document1# destination=#document2#>
			
				<cffile action="DELETE" file=#document1#> 
			
				<cfspreadsheet action="read" src="#Application.Path#\temp\newdocument.xlsx" query="excelquery" sheet="1" >
				<!--- <cfdump var="#excelquery#"> --->
			
				<cfoutput query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
				
					<table style="border: solid 1px black;">
					<tr>
					<td>accountid</td>
					<td>#excelQuery.col_1#</td>
					</tr>
					<tr>
					<td>noCompte</td>
					<td>#excelQuery.col_2#</td>
					</tr>
					<tr>
					<td>nom</td>
					<td>#excelQuery.col_3#</td>
					</tr>
					<tr>
					<td>recu</td>
					<td>#excelQuery.col_4#  </td>
					</tr>
					</table>
					
					<!--- <CFQUERY NAME="ajoutcompte" DATASOURCE="#APPLICATION.DSN#" >
					INSERT INTO  comptes (compteID_DDR1, organismeID, noCompte, nom, recu)																																																							
					VALUES (<CFQUERYPARAM VALUE="#excelQuery.col_1#" CFSQLTYPE="CF_SQL_INTEGER" >,
							<CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER" >,
							<CFQUERYPARAM VALUE="#excelQuery.col_2#" CFSQLTYPE="CF_SQL_INTEGER">,
							<CFQUERYPARAM VALUE="#excelQuery.col_3#" CFSQLTYPE="CF_SQL_VARCHAR">,
							<CFQUERYPARAM VALUE="#excelQuery.col_4#" CFSQLTYPE="CF_SQL_BIT">)
					</CFQUERY> --->
					
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

			<h2>TRANSFERT COMPTES</h2>

			<br />
			<br />
			<CFFORM ACTION="/migration/comptes" METHOD="POST" NAME="comptes" ENCTYPE="multipart/form-data">
			<input type="file" name="comptes" id="comptes" /> fichier Excel .xlsx
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