<CFTRY>
	
	<CFSET VARIABLES.title_en = "EXPORT GIFTS">
	<CFSET file_name_en = "#APPLICATION.Racine#/export/dons"> 
	<CFSET VARIABLES.title_fr = "EXPORT DONS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/export/dons">
	
	<!--- <cfinvoke component="#APPLICATION.cfcDons#" method = "donsListeTous" returnvariable ="liste">
		<cfinvokeargument name="organismeID" value="136">
	</cfinvoke> --->
	
	<!DOCTYPE html>
	
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body>
			<cfheader name="Content-Disposition" value="filename=liste_dons.xls">

			<cfcontent type="application/msexcel;charset=windows-1252">
			
			<TABLE>
				<TR style="background-color:#000;color:#FFF;">
					<TD>DDR ID</TD>
					<TD align="center">donateurID</TD>
					<TD align="center">compteID</TD>
					<TD align="center">Date</TD>
					<TD align="center">Montant</TD>
					<TD align="center">Description</TD>
				</TR>
				<!--- <cfoutput query="liste">
				<TR>
					<TD>#donID#</TD>
					<TD align="center">#donateurID#</TD>
					<TD align="center">#compteID#</TD>
					<TD align="center">#DateFormat(dateDon, "yyyy-mm-dd")#</TD>
					<TD align="center">#montant#</TD>
					<TD align="center">#description#</TD>
				</TR>
				</cfoutput> --->
			</TABLE>	
			
		</body>
	</html>
	<CFCATCH>
		
		<!--- <CFINCLUDE TEMPLATE="../_envoi_erreur.inc"> 
				<CFIF Session.langue EQ "fr">
					<CFLOCATION URL="#APPLICATION.Racine#/fr/erreur" ADDTOKEN="NO">
				<CFELSE>
					<CFLOCATION URL="#APPLICATION.Racine#/en/error" ADDTOKEN="NO">
				</CFIF> --->
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