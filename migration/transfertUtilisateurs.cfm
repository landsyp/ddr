<!--- *** NE PAS OUBLIE D'INSCRIRE L'ORGANISMEID ET LA LANGUE *** --->

<!--- MODELE EXCEL AVEC ENTETE--->
<!--- 				
			1	userid (Access non utilisé)
			2	nom
			3	prenom
			4	nom_usager
			5	mot_de_passe
			6	admin
		 --->

<CFTRANSACTION>
	<CFIF isDefined('Form.uploadexcel')>
		
		<!--- AJOUT MANUEL --->
		<!--- <cfset organismeID = "289"> --->
		<cfset langue = "EN">
		
		<CFFILE ACTION="UPLOAD" FILEFIELD="utilisateurs" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
			<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
			
			<cfset document2 = "#APPLICATION.Path#\temp\newdocument.#File.ClientFileExt#">
			
			<cffile action="COPY" source=#document1# destination=#document2#>
			
			<cffile action="DELETE" file=#document1#> 
			
			<cfspreadsheet action="read" src="#Application.Path#\temp\newdocument.xlsx" query="excelquery" sheet="1" >
			<!--- <cfdump var="#excelquery#"> --->
			
			<cfoutput query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
				userid:	#excelQuery.col_1#<br />
				nom:	#excelQuery.col_2#<br />
				prenom:	#excelQuery.col_3#<br />
				nom_usager	#excelQuery.col_4#<br />
				mot_de_passe:	#excelQuery.col_5#<br />
				admin:	#excelQuery.col_6#<br />
				<hr />
				
				<cfset LaCle=generateSecretKey("AES")>
				<cfset mdpEncrypte = encrypt(excelQuery.col_5, LaCle, "AES", "Base64")>
				<!--- 
				<CFQUERY NAME="ajoutUtilisateurs" DATASOURCE="#APPLICATION.DSN#" result="NeoUtilisateur">
				INSERT INTO  utilisateurs (admin, langue, mot_de_passe, nom, nom_usager, organismeID, prenom)
																				
				VALUES (<CFQUERYPARAM VALUE="#excelQuery.col_6#" CFSQLTYPE="CF_SQL_BIT">,
						<CFQUERYPARAM VALUE="#langue#" CFSQLTYPE="CF_SQL_VARCHAR" >,
						<CFQUERYPARAM VALUE="#mdpEncrypte#" CFSQLTYPE="CF_SQL_VARCHAR" >,
						<CFQUERYPARAM VALUE="#excelQuery.col_2#" CFSQLTYPE="CF_SQL_VARCHAR" >,
						<CFQUERYPARAM VALUE="#excelQuery.col_4#" CFSQLTYPE="CF_SQL_VARCHAR" NULL="#excelQuery.col_4 EQ ""#">,
						<CFQUERYPARAM VALUE="#organismeID#" CFSQLTYPE="CF_SQL_INTEGER" >,
						<CFQUERYPARAM VALUE="#excelQuery.col_3#" CFSQLTYPE="CF_SQL_VARCHAR" >)
				</CFQUERY>
				<cfset utilisateurID = NeoUtilisateur.IDENTITYCOL>
				<CFQUERY NAME="trousseAjout" DATASOURCE="#APPLICATION.DSN#" >
				INSERT INTO trousses (utilisateurID, trousse)
				VALUES (<CFQUERYPARAM VALUE="#utilisateurID#" CFSQLTYPE="CF_SQL_INTEGER" >,
						<CFQUERYPARAM VALUE="#LaCle#" CFSQLTYPE="CF_SQL_VARCHAR" maxlength="50">)
				</CFQUERY>
				 --->		
			</cfoutput>
			<cfset message = "Successful upload">
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

		<h2>TRANSFERT UTILISATEURS</h2>

		<br />
		<br />
		<CFFORM ACTION="/migration/utilisateurs" METHOD="POST" NAME="utilisateurs" ENCTYPE="multipart/form-data">
		<input type="file" name="utilisateurs" id="utilisateurs" /> fichier Excel .xlsx
		<input type="submit" name="uploadexcel" id="uploadexcel" value="Upload" /> 
		</CFFORM>
			
			
	</body>
</html>