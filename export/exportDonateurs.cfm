<CFTRY>
	
	<CFSET VARIABLES.title_en = "EXPORT DONORS">
	<CFSET file_name_en = "#APPLICATION.Racine#/export/donateurs"> 
	<CFSET VARIABLES.title_fr = "EXPORT DONATEURS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/export/donateurs">
	
	<!--- <cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListeTous" returnvariable ="liste">
		<cfinvokeargument name="organismeID" value="136">
	</cfinvoke> --->
	
	<!DOCTYPE html>
	
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body>
			<cfheader name="Content-Disposition" value="filename=liste_donateurs.xls">

			<cfcontent type="application/msexcel;charset=windows-1252">
			
			<TABLE>
				<TR style="background-color:#000;color:#FFF;">
				
					<TD>DDR ID</TD>
					<TD>Numero</TD>
					<TD align="center">Actif</TD>
					<TD align="center">Nom</TD>
					<TD align="center">Prenom</TD>
					<TD align="center">T&eacute;l&eacute;phone R&eacute;sidence</TD>
					<TD align="center">T&eacute;l&eacute;phone Travail</TD>
					<TD align="center">T&eacute;l&eacute;phone Cell</TD>
					<TD align="center">Courriel</TD>
					<TD align="center">Adresse</TD>
					<TD align="center">Ville</TD>
					<TD align="center">Province</TD>
					<TD align="center">Code-Postal</TD>
				</TR>
				<!--- <cfoutput query="liste" >
				<TR>
					<TD>#donateurID#</TD>
					<TD>#numero#</TD>
					<TD align="center"><cfif actif>TRUE<cfelse>FALSE</cfif></TD>
					<TD align="center">#nom#</TD>
					<TD align="center">#prenom#</TD>
					<TD align="center">#tel_residence#</TD>
					<TD align="center">#tel_bureau#</TD>
					<TD align="center">#tel_cellulaire#</TD>
					<TD align="center">#courriel#</TD>
					<TD align="center">#adresse#</TD>
					<TD align="center">#ville#</TD>
					<TD align="center">#provinceID#</TD>
					<TD align="center">#code_postal#</TD>
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