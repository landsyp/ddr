		<cfmail to="#Trim(Form.courriel)#" attributeCollection="#APPLICATION.emailAttributeCollection#" subject="DDR" type="HTML">	
			<CFIF Session.langue EQ "fr">		
				<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
				<html>
				<head>
					<title>DDR - Codes d'accès</title>
				</head>
				<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" bgcolor="##FFFFFF" >
					<TABLE ALIGN="center" STYLE="width: 660px; border: thin solid ##224049;">
						<TR>
							<TD ALIGN="center" STYLE="background-color:##224049; "><img src="#APPLICATION.Racine#/images/logo-96x96.png" alt="Logo - DDR"></TD>
						</TR>
						<TR>
							<TD><HR></TD>
						</TR>
						<TR>
							<TD STYLE="padding:10px;">
								<CFOUTPUT>
									#infos.prenom# #infos.nom#,<br><br>
									Vous pouvez acc&eacute;der &agrave; votre compte DDR (#infos.organisme#) avec votre courriel <b>#infos.courriel#</b> et votre mot de passe <b>#mdp#</b>.<br>
									
									Si vous &eacute;prouvez des difficult&eacute;s, veuillez communiquer avec #APPLICATION.CourrielInfo#
								</CFOUTPUT>
							</TD>
						</TR>
					</TABLE>
					<TABLE  ALIGN="center"  STYLE="width: 660px;">
						<TR>
							<td align="center" style="font-size: 11px;">	
							<CFOUTPUT>
							CQOC - DDR <A HREF="#APPLICATION.Racine#" STYLE="color:##224049;">#APPLICATION.Racine#</A>
							</CFOUTPUT> 
							</td>
						</TR>
					</TABLE>
				</body>
				</html>
			<CFELSE>
				<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
				<html>
				<head>
					<title>DDR - Access code</title>
				</head>
				<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" offset="0" bgcolor="##FFFFFF" >
					<TABLE ALIGN="center" STYLE="width: 660px; border: thin solid ##224049;">
						<TR>
							<TD ALIGN="center" STYLE="background-color:##224049; "><img src="#APPLICATION.Racine#/images/logo-96x96.png" alt="Logo - DDR"></TD>
						</TR>
						<TR>
							<TD><HR></TD>
						</TR>
						<TR>
							<TD STYLE="padding:10px;">
								<CFOUTPUT>
									#infos.prenom# #infos.nom#,<br><br>
									You can log in your DDR account (#infos.organisme#) with your email address <b>#infos.courriel#</b> and your password <b>#mdp#</b>.<br>
									
									If you experience difficulties, contact us at #APPLICATION.CourrielInfo#
								</CFOUTPUT>
							</TD>
						</TR>
					</TABLE>
					<TABLE  ALIGN="center"  STYLE="width: 660px;">
						<TR>
							<td align="center" style="font-size: 11px;">	
							<CFOUTPUT>
							CQOC - DDR <A HREF="#APPLICATION.Racine#" STYLE="color:##224049;">#APPLICATION.Racine#</A>
							</CFOUTPUT> 
							</td>
						</TR>
					</TABLE>
				</body>
				</html>
			</CFIF>
		</CFMAIL>