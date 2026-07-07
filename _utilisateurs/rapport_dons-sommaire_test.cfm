<CFTRY>
	<CFIF session.langue EQ "fr">
		<cfset newLocal = SetLocale("French (Canadian)")>
	</CFIF>
	
	<CFSET VARIABLES.title_en = "DDR GIFTS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-gifts-summary/test">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT DONS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-dons-sommaire/test">
	
	<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateursListe" returnvariable ="tousDonateurs">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
	</cfinvoke>
	<CFQUERY NAME="premier" dbtype="query">
		SELECT  Min(numero) as debut 
 		FROM tousDonateurs
	</CFQUERY>
	<CFQUERY NAME="dernier" dbtype="query">
		SELECT  Max(numero) as fin 
 		FROM tousDonateurs
	</CFQUERY>

	
	<!--- <CFParam name="typerapport" default="detaille"> --->
	<CFParam name="grouperpar" default="mois-date"> 
	<CFParam name="date" default="toutes">
	<CFParam name="dateDebut" default="">
	<CFParam name="dateFin" default="">
	<CFParam name="donateurs" default="tous">
	<CFParam name="debut" default="#premier.debut#">
	<CFParam name="fin" default="#dernier.fin#">
	<CFParam name="confidentiel" default="False">
	<CFParam name="typeexport" default="pdf">
	
	
	
	
	<CFIF isDefined('Form.rapport')>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "InfosOrganisme" returnvariable ="organisme">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		</cfinvoke>
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportDonsSommaire" returnvariable ="ListeDons">
			<cfinvokeargument name="langue" value="#session.langue#">
			<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			<cfinvokeargument name="grouperpar" value="#Form.grouperpar#">
			<cfinvokeargument name="date" value="#Form.date#">
			<cfinvokeargument name="dateDebut" value="#Form.dateDebut#">
			<cfinvokeargument name="dateFin" value="#Form.dateFin#">
			<cfinvokeargument name="donateurs" value="#Form.donateurs#">
			<cfinvokeargument name="debut" value="#Form.debut#">
			<cfinvokeargument name="fin" value="#Form.fin#">
		</cfinvoke>		
		
		
		<!--- <cfset typerapport=Form.typerapport> --->
		<cfset grouperpar=Form.grouperpar>
		<cfset date=Form.date>
		<cfset dateDebut=Form.dateDebut>
		<cfset dateFin=Form.dateFin>
		<cfset donateurs=Form.donateurs>
		<cfset debut=Form.debut>
		<cfset fin=Form.fin>
		<CFIF structKeyExists(Form, 'confidentiel')>
			<cfset confidentiel="True">
		<CFELSE>
			<cfset confidentiel="False">
		</CFIF>
		
		<CFIF Form.dateDebut EQ "">
			<!--- PREMIER DON DE L'ORGANISME --->
			<CFQUERY NAME="PremierDon" DATASOURCE="#APPLICATION.DSN#">
			SELECT TOP (1) d.datedon
			FROM dons AS d
				INNER JOIN donateurs AS dr ON d.donateurID = dr.donateurID
			WHERE dr.organismeID = 	<CFQUERYPARAM VALUE="#Session.utilisateur.organismeID#" CFSQLTYPE="CF_SQL_INTEGER">
			ORDER BY datedon
			</CFQUERY>
			<CFSET dateDe = DateFormat(PremierDon.dateDon, "yyyy-mm-dd")>
		<CFELSE>
			<CFSET dateDe = DateFormat(Form.dateDebut, "yyyy-mm-dd")> 
		</CFIF>
		<CFIF Form.dateFin EQ "">
			<CFSET dateA = DateFormat(Now(), "yyyy-mm-dd")>
		<CFELSE>
			<CFSET dateA = DateFormat(Form.dateFin, "yyyy-mm-dd")>
		</CFIF>
		
		
		<!--- <cfset typeexport=Form.typeexport> --->
		<CFIF session.langue EQ "fr">
			<cfswitch expression="#grouperpar#">
				<cfcase value="mois-date"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/MOIS/DATE"></cfcase>
				<cfcase value="mois-compte"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/MOIS/COMPTE"></cfcase>
				<cfcase value="mois-donateur"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/MOIS/DONATEUR"></cfcase>
				<cfcase value="mois-methode"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/MOIS/METHODE DE PAIEMENT"></cfcase>
				<cfcase value="annee-date"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/DATE"></cfcase>
				<cfcase value="annee-compte"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/COMPTE"></cfcase>  
				<cfcase value="annee-donateur"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/DONATEUR"></cfcase>
				<cfcase value="annee-methode"><cfset TitreRapport="RAPPORT DES DONS PAR ANNÉE/METHODE DE PAIEMENT"></cfcase>
			</cfswitch>
		<CFELSE>
			<cfswitch expression="#grouperpar#">
				<cfcase value="mois-date"><cfset TitreRapport="GIFTS' REPORT BY YEAR/MONTH/DATE"></cfcase>
				<cfcase value="mois-compte"><cfset TitreRapport="GIFTS' REPORT BY YEAR/MONTH/ACCOUNT"></cfcase>
				<cfcase value="mois-donateur"><cfset TitreRapport="GIFTS' REPORT BY YEAR/MONTH/DONOR"></cfcase>
				<cfcase value="mois-methode"><cfset TitreRapport="GIFTS' REPORT BY YEAR/MONTH/PAYMENT METHOD"></cfcase>
				<cfcase value="annee-date"><cfset TitreRapport="GIFTS' REPORT BY YEAR/DATE"></cfcase>
				<cfcase value="annee-compte"><cfset TitreRapport="GIFTS' REPORT BY YEAR/ACCOUNT"></cfcase>
				<cfcase value="annee-donateur"><cfset TitreRapport="GIFTS' REPORT BY YEAR/DONOR"></cfcase>
				<cfcase value="annee-methode"><cfset TitreRapport="GIFTS' REPORT BY YEAR/PAYMENT METHOD"></cfcase>
			</cfswitch>
		</CFIF> 
		
		<!--- <cfdocument
					format="pdf"
					marginleft="0"
					marginright="0"
					margintop="0"
					marginbottom="0"
					unit="in"
					pageType="letter"
					localUrl="yes"
					> --->
		<cfdocument format="pdf"  overwrite="true" localURL="true">

			<cfdocumentitem type="header">
				<style>
					.BlocEntete{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 14px;
						font-weight: normal;
						background-color: #DDDDDD;
						border-bottom:1px solid black;
					}
				</style>
				<table border=0 cellpadding=2 cellspacing=0 width="100%">
					<THEAD>
						<TH  CLASS="BlocEntete">
						<cfoutput>#TitreRapport#
						<br><CFIF session.langue EQ "fr">Du<cfelse>From</cfif> #DateFormat(dateDe, "yyyy-mm-dd")# <CFIF session.langue EQ "fr">au<cfelse>to</cfif> #DateFormat(dateA,"yyyy-mm-dd")#
						</cfoutput>
						</TH>
					</THEAD>
				</table> 
			</cfdocumentitem>
			<cfdocumentitem type="footer">
				<style>
					.BlocPiedDePage{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 10px;
						font-weight: normal;
						background-color: #DDDDDD;
						border-bottom:1px solid black;
					}
				</style>
				<table border=0 cellpadding=2 cellspacing=0 width="100%" CLASS="BlocPiedDePage">
					<tr >
						<td><cfoutput>#DateFormat(Now(),"yyyy-mm-dd")#</cfoutput></td>
						<td align="center"><cfoutput>#organisme.organisme#</cfoutput></td>
						<td align="right">Page <cfoutput>#cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
					</tr>
				</table>
			</cfdocumentitem>
			<cfdocumentsection>
				<style>
					.BlocCorps{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 12px;
						font-weight: normal;
					}
				</style>
				
				<cfset grandTotal=0>
				<CFIF session.langue EQ "fr">
					<!--- GROUPER PAR ANNEE/DATE --->
					<CFIF grouperpar EQ "annee-date">		
				
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="datedon">
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#datedon#&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
							</cfoutput>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table> 
					<!--- GROUPER PAR ANNEE/NO DE COMPTE --->
					<CFELSEIF grouperpar EQ "annee-compte">
					
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="noCompte"> 
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#noCompte# #compte#&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/DONATEUR --->
					<CFELSEIF grouperpar EQ "annee-donateur" >
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="numero"> 
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#numero# <cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF>&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td>
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/METHODE DE PAIEMENT --->
					<CFELSEIF grouperpar EQ "annee-methode" > 
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
			
								<CFOUTPUT GROUP="methode">
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;"><CFIF methode EQ "">Méthode de paiement non spécifiée<CFELSE>#methode#</CFIF>&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0> 
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/MOIS/DATE --->
					<CFELSEIF grouperpar EQ "mois-date">		
				
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)#</td>
									</tr>
									<CFOUTPUT GROUP="datedon">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#datedon#&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</cfoutput>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/MOIS/NO DE COMPTE --->
					<CFELSEIF grouperpar EQ "mois-compte">
					
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="noCompte">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#noCompte# #compte#&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR NO DE DONATEUR --->
					<CFELSEIF grouperpar EQ "mois-donateur" >
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="numero">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant> 
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#numero# <cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF>&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR METHODE DE PAIEMENT --->
					<CFELSEIF grouperpar EQ "mois-methode" > 
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="methode">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;"><CFIF methode EQ "">Méthode de paiement non spécifiée<CFELSE>#methode#</CFIF>&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					</CFIF>
				<CFELSE>
					<!--- GROUPER PAR ANNEE/DATE --->
					<CFIF grouperpar EQ "annee-date">		
				
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="datedon">
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant> 
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#datedon#&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
							</cfoutput>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table> 
					<!--- GROUPER PAR ANNEE/NO DE COMPTE --->
					<CFELSEIF grouperpar EQ "annee-compte">
					
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="noCompte"> 
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#noCompte# #compte#&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/DONATEUR --->
					<CFELSEIF grouperpar EQ "annee-donateur" >
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
								<CFOUTPUT GROUP="numero"> 
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;">#numero# <cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF>&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0>
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td>
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR ANNEE/METHODE DE PAIEMENT --->
					<CFELSEIF grouperpar EQ "annee-methode" > 
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfset totalDate=0>
								<cfset totalAnnee=0>
			
								<CFOUTPUT GROUP="methode">
									<cfoutput>
										<cfset totalDate=totalDate+montant>
										<cfset totalAnnee=totalAnnee+montant>
										<cfset grandTotal=grandTotal+montant>
									</cfoutput>
									<tr STYLE="line-height:20px;">
										<td>&nbsp;</td>
										<td style="width:70%;"><CFIF methode EQ "">Payment method not specified<CFELSE>#methode#</CFIF>&nbsp;</td>
											
										<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
									</tr>
									<cfset totalDate=0> 
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalAnnee)#</td> 
								</tr>
								
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR DATE --->
					<CFELSEIF grouperpar EQ "mois-date">		
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="datedon">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#datedon#&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR NO DE COMPTE --->
					<CFELSEIF grouperpar EQ "mois-compte">
					
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="noCompte">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#noCompte# #compte#&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR NO DE DONATEUR --->
					<CFELSEIF grouperpar EQ "mois-donateur" >
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="numero">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;">#numero# <cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF>&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<!--- GROUPER PAR METHODE DE PAIEMENT --->
					<CFELSEIF grouperpar EQ "mois-methode" > 
						<table WIDTH="100%" border="0" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="year">
								<tr>
									<td COLSPAN="3" STYLE="font-weight:bold;border-bottom:solid 1px ##000;padding:4px; ">#year#</td>
								</tr>
								<cfoutput GROUP="month">
									<cfset totalDate=0>
									<cfset totalMois=0>
									<cfset YourDate = CreateDate(#Year#, #month#, 1)>
			
									<tr>
										<td COLSPAN="3" STYLE="font-weight:bold; ">#MonthAsString(Month)# #year#</td>
									</tr>
									<CFOUTPUT GROUP="methode">
										<cfoutput>
											<cfset totalDate=totalDate+montant>
											<cfset totalMois=totalMois+montant>
											<cfset grandTotal=grandTotal+montant>
										</cfoutput>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td style="width:70%;"><CFIF methode EQ "">Payment method not specified<CFELSE>#methode#</CFIF>&nbsp;</td>
												
											<td STYLE="text-align:right;">#LSCurrencyFormat(totalDate)#</td>
										</tr>
										<cfset totalDate=0>
									</CFOUTPUT>
									
									<tr STYLE="line-height:30px;">
										<td colspan="2" STYLE="font-weight:bold;text-align:right;">Total</td>
										<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(totalMois)#</td>
									</tr>
								</CFOUTPUT>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="2" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					</CFIF>
				</CFIF>
			</cfdocumentsection>
			
		</cfdocument>
		
	</CFIF>
	
	<!DOCTYPE html>
	<!-- This site was created in Webflow. http://www.webflow.com-->
	<!-- Last Published: Thu Jun 16 2016 16:27:16 GMT+0000 (UTC) -->
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="5731981ac809f1bc5f09caa4">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
			<SCRIPT LANGUAGE="javascript">
			function CopieValeur(champ1,champ2)
				{
					document.getElementById(champ2).value = document.getElementById(champ1).value;
				}
			</SCRIPT>
			<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
			<script src="https://code.jquery.com/ui/1.12.0/jquery-ui.js"></script>
			<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
			<CFIF session.langue EQ "en">
				<script>
					$( function() {
						$( "#dateDebut" ).datepicker({ dateFormat: 'yy-mm-dd' });
						$( "#dateFin" ).datepicker({ dateFormat: 'yy-mm-dd' });
					} );
				</script>
			<CFELSE>
				<script>
					$( function() {
						$("#dateDebut" ).datepicker({ 
						altField: "#datepicker",
						closeText: 'Fermer',
						prevText: 'Précédent',
						nextText: 'Suivant',
						currentText: 'Aujourd\'hui',
						monthNames: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
						monthNamesShort: ['Janv.', 'Févr.', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil.', 'Août', 'Sept.', 'Oct.', 'Nov.', 'Déc.'],
						dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
						dayNamesShort: ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'],
						dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
						weekHeader: 'Sem.',
						dateFormat: 'yy-mm-dd'
						});
						
						$( "#dateFin" ).datepicker({ 
						altField: "#datepicker",
						closeText: 'Fermer',
						prevText: 'Précédent',
						nextText: 'Suivant',
						currentText: 'Aujourd\'hui',
						monthNames: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
						monthNamesShort: ['Janv.', 'Févr.', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil.', 'Août', 'Sept.', 'Oct.', 'Nov.', 'Déc.'],
						dayNames: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
						dayNamesShort: ['Dim.', 'Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.'],
						dayNamesMin: ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
						weekHeader: 'Sem.',
						dateFormat: 'yy-mm-dd'
						});
					});
				</script>
				
			</CFIF>
			
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
	
			<!--- <div class="w-section sectionsousheader">
							<div class="w-container containersousheader">
				 				<div class="wrappersousheader">
				 					<CFIF session.langue EQ "fr">
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Rapports &gt; Rapport de dons</h3>
									<CFELSE>
										<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Reports &gt; Gifts Report</h3>
									</CFIF>
				 				</div>
							</div>
						</div> --->
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-rapports.inc">
				
				<div class="w-container containerprincipal">
					<div class="blocfondblanc">
						<div class="containertyperapport">
							<div class="titretyperapport">
								<CFIF session.langue EQ "fr">
									<strong>RAPPORT DE DONS (SOMMAIRE)</strong>
								<CFELSE>
									<strong>GIFTS' REPORT (SUMMARY)</strong>
								</CFIF>
							</div>
        				</div>
        				
						<div class="w-form">
							<CFIF session.langue EQ "fr">
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_fr#" METHOD="POST">
									
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Grouper par Année</label> 
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-date" checked="#grouperpar EQ 'annee-date'#">
												<label class="w-form-label" for="grouperpardate">Date</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-compte" checked="#grouperpar EQ 'annee-compte'#">
												<label class="w-form-label" for="grouperparcompte">Compte</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-donateur" checked="#grouperpar EQ 'annee-donateur'#">
												<label class="w-form-label" for="grouperpardonateur">Donateur</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-methode" checked="#grouperpar EQ 'annee-methode'#">
												<label class="w-form-label" for="grouperparmethode">Méthode de paiement</label>
											</div>
										</div>
									</div>
									
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Grouper par Année/Mois</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-date" checked="#grouperpar EQ 'mois-date'#">
												<label class="w-form-label" for="grouperpardate">Date</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-compte" checked="#grouperpar EQ 'mois-compte'#"> 
												<label class="w-form-label" for="grouperparcompte">Compte</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-donateur" checked="#grouperpar EQ 'mois-donateur'#">
												<label class="w-form-label" for="grouperpardonateur">Donateur</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-methode" checked="#grouperpar EQ 'mois-methode'#">
												<label class="w-form-label" for="grouperparmethode">Méthode de paiement</label>
											</div>
										</div>
									</div>
								
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Date</label>
										<div class="selectionneurdate">
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-date">
												<cfinput class="w-radio-input" data-name="date" id="date" name="date" type="radio" value="toutes" checked="#date EQ 'toutes'#">
												<label class="w-form-label" for="datetoutes">Toutes</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-date">
												<cfinput class="w-radio-input" data-ix="montrer-la-date" data-name="date" id="date" name="date" type="radio" value="periode" checked="#date EQ 'periode'#">
												<label class="w-form-label" for="dateperiode">Sélectionner une période</label>
											</div>
										</div>
										<!--- <div class="selectionperiode" data-ix="display-none-on-load">
											<label class="labeldechamp" for="email">De :</label>
											<div class="w-embed champtexte">
												<CFinput type="datefield" value="#DateFormat(dateDebut, "yyyy-mm-dd")#" name="dateDebut" mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  style="margin:0;padding:0;"/>
											</div>
											<label class="labeldechamp" for="email">&Agrave; :</label>
											<div class="w-embed champtexte">
												<!--- <cfinput type="datefield" name="date" style="margin:0;padding:0;"> --->
												<CFinput type="datefield" value="#DateFormat(dateFin, "yyyy-mm-dd")#" name="dateFin" mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  style="margin:0;padding:0;"/>
											</div>
										</div> --->
										<div class="selectionperiode" data-ix="display-none-on-load">
											<label class="labeldechamp" for="email" style="margin:0px 10px;">De </label>
											<div class="w-embed champtexte">
												<input type="text" value="<cfoutput>#DateFormat(dateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}" style="margin:0;margin-right:10px;width:140px;"/> 
											</div>
											<a href="##" ONCLICK="CopieValeur('dateDebut','dateFin')"><img  src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/flecheD.png"  TITLE="copier" style="height:25px;"></a>&nbsp;
											<label class="labeldechamp" for="email" style="margin:0px 10px;">&Agrave;</label>
											<div class="w-embed champtexte">
												<input type="text" value="<cfoutput>#DateFormat(dateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Veuillez entrer la date sous format aaaaa-mm-jj ')" onchange="try{setCustomValidity('')}catch(e){}" style="margin:0;padding:0;width:140px;"/> 
											</div>
										</div>
									</div>
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Donateurs</label>
										<div class="selectionneurdate">
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-selection-des-donateurs">
												<cfinput class="w-radio-input" data-ix="cacher-la-selection-des-donateurs" data-name="donateurs" id="donateurs" name="donateurs" type="radio" value="tous" checked="#donateurs EQ 'tous'#">
												<label class="w-form-label" for="donateurstous">Tous</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-selection-de-donateurs">
												<cfinput class="w-radio-input" data-ix="montrer-la-selection-de-donateurs" data-name="donateurs" id="donateurs" name="donateurs" type="radio" value="selection" checked="#donateurs EQ 'selection'#">
												<label class="w-form-label" for="donateursselection">Sélectionner les donateurs</label>
											</div>
										</div>
										<div class="selectionnumdonateurs" data-ix="display-none-on-load-2">
											<label class="labeldechamp" for="Debut">De :</label>
											<input class="w-input champnumdonateur" data-name="Debut #" id="Debut" maxlength="256" name="Debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>">
											<label class="labeldechamp" for="Fin">&Agrave; :</label>
											<input class="w-input champnumdonateur" data-name="Fin #" id="Fin" maxlength="256" name="Fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>">
										</div>
									</div>
									
									<div class="bloccheckbox">
										<div class="w-checkbox w-clearfix">
											<cfinput class="w-checkbox-input" data-name="confidentiel" id="confidentiel" name="confidentiel" checked="#confidentiel EQ 'True'#" type="checkbox">
											<label class="w-form-label petittextegris" for="Confidentialt">Cacher le nom des donateurs</label>
										</div>
									</div>

									<div class="blocchamp blocchamppleinelargeur">
									<cfinput class="w-button boutonvalider" data-wait="Préparation du rapport en cours" name="rapport" type="submit" formtarget="_blank" value="Générer le rapport" wait="Préparation du rapport en cours">
									</div>
								</CFFORM>
							<CFELSE>
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_en#" METHOD="POST">
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Group by Year</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-date" checked="#grouperpar EQ 'annee-date'#">
												<label class="w-form-label" for="grouperpardate">Date</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-compte" checked="#grouperpar EQ 'annee-compte'#">
												<label class="w-form-label" for="grouperparcompte">Account</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-donateur" checked="#grouperpar EQ 'annee-donateur'#">
												<label class="w-form-label" for="grouperparcompte">Donor</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="annee-methode" checked="#grouperpar EQ 'annee-methode'#">
												<label class="w-form-label" for="grouperparmethode">Payment Method</label>
											</div>
										</div> 
									</div>
									
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Group by Year/Month</label>
										<div class="containerradiobuttons">
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-date" checked="#grouperpar EQ 'mois-date'#">
												<label class="w-form-label" for="grouperpardate">Date</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-compte" checked="#grouperpar EQ 'mois-compte'#">
												<label class="w-form-label" for="grouperparcompte">Account</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-donateur" checked="#grouperpar EQ 'mois-donateur'#">
												<label class="w-form-label" for="grouperparcompte">Donor</label>
											</div>
											<div class="w-radio champradiobutton">
												<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="mois-methode" checked="#grouperpar EQ 'mois-methode'#">
												<label class="w-form-label" for="grouperparmethode">Payment Method</label>
											</div>
										</div>
									</div>
									
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Date</label>
										<div class="selectionneurdate">
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-date">
												<cfinput class="w-radio-input" data-name="date" id="date" name="date" type="radio" value="toutes" checked="#date EQ 'toutes'#">
												<label class="w-form-label" for="datetoutes">All</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-date"> 
												<cfinput class="w-radio-input" data-ix="montrer-la-date" data-name="date" id="date" name="date" type="radio" value="periode" checked="#date EQ 'periode'#">
												<label class="w-form-label" for="dateperiode">Select period</label>
											</div>
										</div>
										<!--- <div class="selectionperiode" data-ix="display-none-on-load">
											<label class="labeldechamp" for="email">From :</label>
											<div class="w-embed champtexte">
												<CFinput type="datefield" value="#DateFormat(dateDebut, "yyyy-mm-dd")#" name="dateDebut" mask="yyyy-mm-dd" placeholder="yyyy-mm-dd"  style="margin:0;padding:0;"/>
											</div>
											<label class="labeldechamp" for="email">To :</label>
											<div class="w-embed champtexte">
												<!--- <cfinput type="datefield" name="date" style="margin:0;padding:0;"> --->
												<CFinput type="datefield" value="#DateFormat(dateFin, "yyyy-mm-dd")#" name="dateFin" mask="yyyy-mm-dd" placeholder="yyyy-mm-dd"  style="margin:0;padding:0;"/>
											</div>
										</div> --->
										<div class="selectionperiode" data-ix="display-none-on-load">
											<label class="labeldechamp" for="email" style="margin:0px 10px;">From </label>
											<div class="w-embed champtexte">
												<input type="text" value="<cfoutput>#DateFormat(dateDebut, "yyyy-mm-dd")#</cfoutput>" name="dateDebut" id="dateDebut"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Date should have aaaaa-mm-jj format')" onchange="try{setCustomValidity('')}catch(e){}" style="margin:0;margin-right:10px;width:140px;"/> 
											</div>
											<a href="##" ONCLICK="CopieValeur('dateDebut','dateFin')"><img  src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/flecheD.png"  TITLE="Copy" style="height:25px;"></a>
											<label class="labeldechamp" for="email" style="margin:0px 10px;">To </label>
											<div class="w-embed champtexte">
												<input type="text" value="<cfoutput>#DateFormat(dateFin, "yyyy-mm-dd")#</cfoutput>" name="dateFin" id="dateFin"  mask="yyyy-mm-dd" placeholder="aaaa-mm-jj"  pattern="(?:19|20)[0-9]{2}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-9])|(?:(?!02)(?:0[1-9]|1[0-2])-(?:30))|(?:(?:0[13578]|1[02])-31))" oninvalid="setCustomValidity('Date should have aaaaa-mm-jj format')" onchange="try{setCustomValidity('')}catch(e){}" style="margin:0;padding:0;width:140px;"/> 
											</div>
										</div>
									</div>
									<div class="blocradiobuttons">
										<label class="labeldechamp" for="numdonateur">Donors</label>
										<div class="selectionneurdate">
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="cacher-la-selection-des-donateurs">
												<cfinput class="w-radio-input" data-ix="cacher-la-selection-des-donateurs" data-name="donateurs" id="donateurs" name="donateurs" type="radio" value="tous" checked="#donateurs EQ 'tous'#">
												<label class="w-form-label" for="donateurstous">All</label>
											</div>
											<div class="w-radio champradiobutton radiobuttonpadding" data-ix="montrer-la-selection-de-donateurs">
												<cfinput class="w-radio-input" data-ix="montrer-la-selection-de-donateurs" data-name="donateurs" id="donateurs" name="donateurs" type="radio" value="selection" checked="#donateurs EQ 'selection'#">
												<label class="w-form-label" for="donateursselection">Select donors</label>
											</div>
										</div>
										<div class="selectionnumdonateurs" data-ix="display-none-on-load-2">
											<label class="labeldechamp" for="Debut">From :</label>
											<input class="w-input champnumdonateur" data-name="Debut #" id="Debut" maxlength="256" name="Debut" placeholder="# donateur" required="required" type="text" value="<cfoutput>#debut#</cfoutput>">
											<label class="labeldechamp" for="Fin">To :</label>
											<input class="w-input champnumdonateur" data-name="Fin #" id="Fin" maxlength="256" name="Fin" placeholder="# donateur" required="required" type="text" value="<cfoutput>#fin#</cfoutput>">
										</div>
									</div>
									<div class="bloccheckbox">
										<div class="w-checkbox w-clearfix">
											<cfinput class="w-checkbox-input" data-name="confidentiel" id="confidentiel" name="confidentiel" checked="#confidentiel EQ 'True'#" type="checkbox">
											<label class="w-form-label petittextegris" for="Confidentialt">Hide donors' name</label>
										</div>
									</div>
									<!--- <div class="blocradiobuttons">
										<div class="containerradiobuttons">
											<div class="w-radio w-clearfix champradiobutton">
												<CFinput class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="pdf" checked="#typeexport EQ 'pdf'#">
												<label class="w-form-label petittextegris" for="pdf">Export PDF</label>
											</div>
											<div class="w-radio w-clearfix champradiobutton">
												<CFinput class="w-radio-input" data-name="typeexport" id="typeexport" name="typeexport" type="radio" value="excel" checked="#typeexport EQ 'excel'#">
												<label class="w-form-label petittextegris" for="excel">Export Excel</label>
											</div>
										</div>
									</div> --->
									<div class="blocchamp blocchamppleinelargeur">
									<cfinput class="w-button boutonvalider" data-wait="Report is being processed" name="rapport" type="submit" formtarget="_blank" value="Display report" wait="Report is being processed">
									</div>
								</CFFORM>
							</CFIF>
						</div>
      			</div>
    			</div>
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<!--- <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script> --->
			<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
			<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
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