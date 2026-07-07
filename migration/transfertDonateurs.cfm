<CFTRY>
	<!--- *** NE PAS OUBLIE D'INSCRIRE L'ORGANISMEID  *** --->

	<!--- MODELE EXCEL AVEC ENTETE--->
	<!--- 				
				1	donorid (Access inséré dans donateurs.donateurID_DDR1)
				2	numero
				3	actif
				4	nom
				5	prenom
				6	tel_residence
				7	tel_bureau
				8	tel_cellulaire
				9	courriel
				10	adresse
				11	ville
				12	provinceID
				13	code_postal
				
		 	--->
		
	<CFTRANSACTION>
		<CFIF isDefined('Form.uploadexcel')>
		
			<!--- AJOUT MANUEL --->
			
			<!--- <cfset organismeID = "310"> --->
			
		
			<CFFILE ACTION="UPLOAD" FILEFIELD="donateurs" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
				<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
			
				<cfset document2 = "#APPLICATION.Path#\temp\newdocument.#File.ClientFileExt#">
			
				<cffile action="COPY" source=#document1# destination=#document2#>
			
				<cffile action="DELETE" file=#document1#> 
			
				<cfspreadsheet action="read" src="#Application.Path#\temp\newdocument.xlsx" query="excelquery" sheet="1" >
				<!--- <cfdump var="#excelquery#"> --->
			
				<cfoutput query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
				
					<table style="border: solid 1px black;">
					<tr>
					<td>donorId</td>
					<td>#excelQuery.col_1#</td>
					</tr>
					<tr>
					<td>numero</td>
					<td>#excelQuery.col_2#</td>
					</tr>
					<tr>
					<td>actif</td>
					<td>#excelQuery.col_3#</td>
					</tr>
					<tr>
					<td>nom</td>
					<td>#excelQuery.col_4#  </td>
					</tr>
					<tr>
					<td>prenom</td>
					<td>#excelQuery.col_5#</td>
					</tr>
					<tr>
					<td>tel_residence</td>
					<td>#excelQuery.col_6#</td>
					</tr>
					<tr>
					<td>tel_bureau</td>
					<td>#excelQuery.col_7#</td>
					</tr>
					<tr>
					<td>tel_cellulaire</td>
					<td>#excelQuery.col_8#</td>
					</tr>
					<tr>
					<td>courriel</td>
					<td>#excelQuery.col_9#</td>
					</tr>
					<tr>
					<td>adresse</td>
					<td>#excelQuery.col_10#</td>
					</tr>
					<tr>
					<td>ville</td>
					<td>#excelQuery.col_11#</td>
					</tr>
					<tr>
					<td>provinceID</td>
					<td>#excelQuery.col_12#</td>
					</tr>
					<tr>
					<td>code_postal</td>
					<td>#excelQuery.col_13#</td>
					</tr>
					<!--- <tr>
					<td>notes</td>
					<td>#excelQuery.col_14#</td>
					</tr> --->
					</table>
				
					<!--- 					
					<CFQUERY NAME="ajoutdonateur" DATASOURCE="#APPLICATION.DSN#" result="NeoDonateur">
					INSERT INTO  donateurs (donateurID_DDR1, actif, adresse, code_postal, courriel, nom, <!--- notes, ---> numero, organismeID, prenom, provinceID, tel_bureau, tel_cellulaire, tel_residence, ville)
																																																																							
					VALUES (<CFQUERYPARAM VALUE="#excelQuery.col_1#" CFSQLTYPE="CF_SQL_INTEGER" >,
							<CFQUERYPARAM VALUE="#excelQuery.col_3#" CFSQLTYPE="CF_SQL_BIT">,
							<CFQUERYPARAM VALUE="#excelQuery.col_10#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_10 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_13#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_13 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_9#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_9 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_4#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_4 EQ ""#">,
							<!--- <CFQUERYPARAM VALUE="#excelQuery.col_14#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_14 EQ ""#">, --->
							<CFQUERYPARAM VALUE="#excelQuery.col_2#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_2 EQ ""#">,
							<CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER" >,
							<CFQUERYPARAM VALUE="#excelQuery.col_5#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_5 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_12#" CFSQLTYPE="CF_SQL_INTEGER" NULL="#excelQuery.col_12 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_7#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_7 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_8#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_8 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_6#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_6 EQ ""#">,
							<CFQUERYPARAM VALUE="#excelQuery.col_11#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_11 EQ ""#">
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

			<h2>TRANSFERT DONATEURS</h2>

			<br />
			<br />
			<CFFORM ACTION="/migration/donateurs" METHOD="POST" NAME="donateurs" ENCTYPE="multipart/form-data">
			<input type="file" name="donateurs" id="donateurs" /> fichier Excel .xlsx
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