<!--- <CFTRY> --->
	
	<cfset joursAvantEcheance30 = "30">
	<cfset joursAvantEcheance15 = "15">

	<cfquery name="alertes" datasource="charity" > 
		Select o.*, p.abreviation
		FROM organismes AS o
		LEFT JOIN provinces AS p ON o.provinceID = p.provinceID
		WHERE interne = <CFQUERYPARAM VALUE="False" CFSQLTYPE="CF_SQL_BIT">
		AND		organismeID NOT IN (0,2)
		AND (DATEDIFF(day,#Now()#,date_fin_licence)=#joursAvantEcheance30# OR DATEDIFF(day,#Now()#,date_fin_licence)=#joursAvantEcheance15#)
	</cfquery>  
	
	<CFIF alertes.recordcount NEQ 0>
		<img src="https://charity-solutions.ca/images/charity-logo_fr.png" alt="Logo - Charity"><br>
		<CFIF alertes.recordcount EQ 1>
			<h2>La license de l'organisme suivant expirera dans trente jours.</h2>
		<CFELSE>
			<h2>La license des organismes suivants expirera dans trente jours.</h2>
		</CFIF>
		<CFOUTPUT QUERY="alertes" >
			Non de l'organisme : #organisme#<br>
			Adresse : #adresse#<br>
			Ville : #ville#<br>
			Province : #abreviation#<br>
			Code-postal : #code_postal#<br>
			
			Responsable : #responsable#<br>
			T&eacute;l&eacute;phone : #telephone#<br>		
			Responsable courriel : #responsable_courriel#<br>
			Date d'expiration : #DateFormat(date_fin_licence, "yyy-mm-dd")#<hr>
			
		</CFOUTPUT>
	
		<cfmail to="info@charity-solutions.ca"  from="francois@c-touche.com" subject="Charity - Licenses bientôt à échéance" type="HTML">	
			<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
			<html>
			<head>
				<title>Solutions Charit&eacute; - Licenses bient&ocirc;t &agrave; &eacute;ch&eacute;ance </title>
			</head>
			<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" bgcolor='##FFFFFF' >
				<TABLE ALIGN="center" STYLE="width: 660px; border: thin solid ##209b60;">
					<TR>
						<TD ALIGN="center"><img src="https://charity-solutions.ca/images/charity-logo_fr.png" alt="Solutions Charité"></TD>
					</TR>
					<TR>
						<TD><HR></TD>
					</TR>
					<TR>
						<TD>
							<CFIF alertes.recordcount EQ 1>
								<h2>La license de l'organisme suivant expirera dans trente jours.</h2>
							<CFELSE>
								<h2>La license des organismes suivants expirera dans trente jours.</h2>
							</CFIF>
						</TD>
					<CFLOOP QUERY="alertes" >
					<TR>
						<TD STYLE="background-color: ##E2E2DC;padding:10px;">
							Non de l'organisme : #organisme#<br>
							Adresse : #adresse#<br>
							Ville : #ville#<br>
							Province : #abreviation#<br>
							Code-postal : #code_postal#<br>
		
							Responsable : #responsable#<br>
							T&eacute;l&eacute;phone : #telephone#<br>		
							Responsable courriel : #responsable_courriel#<br>
							Date d'expiration : #DateFormat(date_fin_licence, "yyyy-mm-dd")#<hr>
						</TD>
						</CFLOOP>
					</TR>
				</TABLE>
				<TABLE CELLPADDING="8" ALIGN="center"  STYLE="width: 660px;">
					<TR>
						<td align="center" style="font-size: 11px;">	
						Solutions Charit&eacute; <A HREF="https://charity-solutions.ca" STYLE="color:WindowFrame;">https://charity-solutions.ca</A> 
						</td>
					</TR>
				</TABLE>
			</body>
			</html>
		</CFMAIL>
	</CFIF>		

	<!--- <CFCATCH type="Any">
		<cfoutput>
		#DateFormat(now(),"DD MMMM, YYYY")# #TimeFormat(now(),"(HH:MM:SS)")#<br>
		Une erreur est survenue sur DDR
		<BR>
		
		<cfif IsDefined('cfcatch')> Message : #cfcatch.Message#<BR></CFIF>
		
		<cfif IsDefined('cfcatch')><cfdump var="#cfcatch#" label="cfcatch"></cfif>
		<HR>
		<cfdump var="#Form#" label="Variables de type Form">
		<HR>
		<cfdump var="#URL#" label="Variables de type URL">
		<HR>
		<cfdump var="#session#" label="Variables de type session">
	</cfoutput>
	</CFCATCH>

</CFTRY> --->