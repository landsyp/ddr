<CFTRY>
	
	<CFSET VARIABLES.title_en = "DDR CHARITY LIST">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/admin-charities-list-excel"> 
	<CFSET VARIABLES.title_fr = "DDR LISTE DES ORGANISMES">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/admin-liste-organismes-excel">
	
	<cfinvoke component="#APPLICATION.cfcAdmin#" method = "organismesExternesListe" returnvariable ="liste"/>
	
	<!DOCTYPE html>
	
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body>
			<cfheader name="Content-Disposition" value="filename=liste_organismes.xls">

			<cfcontent type="application/msexcel;charset=windows-1252">
			<CFIF session.langue EQ "fr">
				<TABLE>
					<TR style="background-color:#000;color:#FFF;">
						<TD>Organisme</TD>
						<TD align="center">Membre</TD>
						<TD align="center">Date de fin de licence</TD>
						<TD align="center">Responsable</TD>
						<TD align="center">Courriel</TD>
						<TD align="center">T&eacute;l&eacute;phone</TD>
					</TR>
					<cfoutput query="liste" >
					<TR>
						<TD>#organisme#</TD>
						<TD align="center"><cfif membre>oui<cfelse>non</cfif></TD>
						<TD align="center">#DateFormat(date_fin_licence,"yyyy-mm-dd")#</TD>
						<TD align="center">#responsable#</TD>
						<TD align="center">#responsable_courriel#</TD>
						<TD align="center">#telephone#</TD>
					</TR>
					</cfoutput>
				</TABLE>	
			<CFELSE>
				<TABLE>
					<TR style="background-color:#000;color:#FFF;">
						<TD>Charity</TD>
						<TD align="center">Member</TD>
						<TD align="center">End of license date</TD>
						<TD align="center">Person in charge</TD>
						<TD align="center">Email</TD>
						<TD align="center">Telephone</TD>
					</TR>
					<cfoutput query="liste" >
					<TR>
						<TD>#organisme#</TD>
						<TD align="center"><cfif membre>yes<cfelse>no</cfif></TD>
						<TD align="center">#DateFormat(date_fin_licence,"yyyy-mm-dd")#</TD>
						<TD align="center">#responsable#</TD>
						<TD align="center">#responsable_courriel#</TD>
						<TD align="center">#telephone#</TD>
					</TR>
					</cfoutput>
				</TABLE>	

			</CFIF>
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