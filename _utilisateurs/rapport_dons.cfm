<CFTRY>

	<cfset newLocal = SetLocale("French (Canadian)")>

	<CFSET VARIABLES.title_en = "DDR GIFTS REPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-gifts">
	<CFSET VARIABLES.title_fr = "DDR RAPPORT DONS DETAILLE">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-dons">
	
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
	<CFParam name="grouperpar" default="date">
	<CFParam name="groupes" default="plusieurs">
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
		
		<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportDons" returnvariable ="ListeDons">
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
		<cfset groupes=Form.groupes>
		<cfset date=Form.date>
		<cfset dateDebut=Form.dateDebut>
		<cfset dateFin=Form.dateFin>
		<cfset donateurs=Form.donateurs>
		<cfset debut=Form.debut>
		<cfset fin=Form.fin>
		<CFIF isDefined('Form.confidentiel')>
			<cfset confidentiel="True">
		<CFELSE>
			<cfset confidentiel="False">
		</CFIF>
		<!--- <cfset typeexport=Form.typeexport> --->
		<CFIF session.langue EQ "fr">
			<cfswitch expression="#grouperpar#">
				<cfcase value="date">
					<cfset TitreRapport="RAPPORT DES DONS PAR DATE">
					<CFSET VARIABLES.groupement = "datedon">
				</cfcase>
				<cfcase value="compte">
					<cfset TitreRapport="RAPPORT DES DONS PAR COMPTE">
					<CFSET VARIABLES.groupement  = "Nocompte">
				</cfcase>
				<cfcase value="donateur">
					<cfset TitreRapport="RAPPORT DES DONS PAR DONATEUR">
					<CFSET VARIABLES.groupement  = "nomComplet">
				</cfcase>
				<cfcase value="numero">
					<cfset TitreRapport="RAPPORT DES DONS PAR NO. DONATEUR">
					<CFSET VARIABLES.groupement  = "numero">
				</cfcase>
				<cfcase value="methode">
					<cfset TitreRapport="RAPPORT DES DONS PAR METHODE DE PAIEMENT">
					<CFSET VARIABLES.groupement  = "methode">
				</cfcase>
			</cfswitch>
		<CFELSE>
			<cfswitch expression="#grouperpar#">
				<cfcase value="date">
					<cfset TitreRapport="GIFTS' REPORT BY DATE">
					<CFSET VARIABLES.groupement = "datedon">
				</cfcase>
				<cfcase value="compte">
					<cfset TitreRapport="GIFTS' REPORT BY ACCOUNT">
					<CFSET VARIABLES.groupement  = "Nocompte">
				</cfcase>
				<cfcase value="donateur">
					<cfset TitreRapport="GIFTS' REPORT BY DONOR">
					<CFSET VARIABLES.groupement  = "nomComplet">
				</cfcase>
				<cfcase value="numero">
					<cfset TitreRapport="GIFTS' REPORT BY DONOR NO.">
					<CFSET VARIABLES.groupement  = "numero">
				</cfcase>
				<cfcase value="methode">
					<cfset TitreRapport="GIFTS' REPORT BY PAYMENT METHOD">
					<CFSET VARIABLES.groupement  = "methode">
				</cfcase>
			</cfswitch>
		</CFIF>
		
		<cfdocument format="pdf"  overwrite="true" localURL="true">

			<cfdocumentitem type="header">
				<style>
					.BlocEntete{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 14px;
						font-weight: normal;
						background-color: #DDD;
						border-bottom:1px solid #AAA;
					}
				</style>
				<table border=0 cellpadding=2 cellspacing=0 width="100%">
					<THEAD>
						<TH  CLASS="BlocEntete"><br><cfoutput>#TitreRapport#</cfoutput></TH>
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
						border-bottom:1px solid #AAA;
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
					.BlocGroupe{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 12px;
						font-weight: bold;
					}
					.BlocSousEntete{
						font-family:Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 10px;
						
						background-color: #EEE;
						text-align:center;
					}
					.BlocSousEntete td {
						padding:1px;
						border-bottom:1px solid #CCC;
						border-top:1px solid #CCC;
					}
					.BlocSousGroupe{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 10px ;
						font-weight: bold;
						font-style: italic;
					}
					
					.BlocCorps{
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						font-size: 10px;
						font-weight: normal;
						vertical-align:top;
					}
				</style>
				
				<cfset grandTotal=0>
				<cfset grandTotalSansRecu=0>
				<cfset grandTotalAvecRecu=0>
				<!--- <CFIF session.langue EQ "fr"> --->

					<table WIDTH="100%" >
						<cfoutput query="ListeDons" GROUP="#VARIABLES.groupement#">
							<cfswitch expression="#grouperpar#"> 
								<cfcase value="date">
								<tr class="BlocGroupe">
									<td COLSPAN="7">#DateFormat(datedon, "yyyy-mm-dd")#</td>
								</tr>
								</cfcase>
								<cfcase value="compte">
									<tr class="BlocGroupe">
										<td COLSPAN="7">#compte# (#NoCompte# )</td>
									</tr>
								</cfcase> 
								<cfcase value="donateur">
									<tr class="BlocGroupe">
										<td COLSPAN="7"><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF> (#numero#)</td>
									</tr>
								</cfcase>
								<cfcase value="numero">
									<tr class="BlocGroupe">
										<td COLSPAN="7">#Numero# <cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF> </td>
									</tr>
								</cfcase>
								<cfcase value="methode">
									<tr class="BlocGroupe">
										<td COLSPAN="7">
											<CFIF methode EQ "">
												<CFIF session.langue EQ "fr">
													non sp&eacute;cifi&eacute;e
												<CFELSE>
													unspecified
												</CFIF>
											<CFELSE>
												#methode#
											</CFIF>
										</td>
									</tr>
								</cfcase>
								<cfdefaultcase>
									<tr class="BlocGroupe">
										<td COLSPAN="7">#DateFormat(datedon, "yyyy-mm-dd")#</td>
									</tr>
								</cfdefaultcase> 
							</cfswitch>
							
							<!--- 
							ORDONNANCEMENT DES COLONNES EN FONCTION DU GROUPEMENT DEMANDE
							
							GROUPEMENT 
							Date :			Donateur	Compte		Description		Mode paiement	Montant
							Compte :		Date		Donateur	Description		Mode paiement	Montant
							Nom donateur :	Date		Compte		Description		Mode paiement	Montant
							No donateur :	Date		Compte		Description		Mode paiement	Montant
							Mode paiement :	Date		Donateur	Compte			Description		Montant
							--->
							
							<tr class="BlocSousEntete">
								<!--- COLONNES 1-2 --->
								<CFIF grouperpar EQ "date">
									<td colspan="2"><CFIF session.langue EQ "fr">Donateur<CFELSE>Donor</CFIF></td>
								<CFELSE>
									<td colspan="2">Date</td>
								</CFIF>
								<!--- COLONNES 3-4 --->
								<CFIF grouperpar EQ "compte" OR grouperpar EQ  "methode">
									<td colspan="2"><CFIF session.langue EQ "fr">Donateur<CFELSE>Donor</CFIF></td>
								<CFELSE>
									<td colspan="2"><CFIF session.langue EQ "fr">Compte<CFELSE>Account</CFIF></td>
								</CFIF>
								<!--- COLONNES 5 --->
								<CFIF grouperpar EQ "methode">
									<td><CFIF session.langue EQ "fr">Compte<CFELSE>Account</CFIF></td>
								<CFELSE>
									<td>Description</td>
								</CFIF>
								<!--- COLONNES 6 --->
								<CFIF grouperpar EQ "methode">
									<td>Description</td>
								<CFELSE>
									<td><CFIF session.langue EQ "fr">M&eacute;thode paiement<CFELSE>Form of Payment </CFIF>
								</CFIF>
								<!--- <td><CFIF session.langue EQ "fr">Mode paiement<CFELSE>Form of Payment </CFIF></td> --->
								<!--- COLONNES 7 --->
								<td><CFIF session.langue EQ "fr">Montant<CFELSE>Amount</CFIF></td>
							</tr>
							<cfset total=0>
							<CFOUTPUT GROUP="donRecu">
								<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
									<td colspan="7">
										<CFIF session.langue EQ "fr">
											<cfif donRecu>Dons avec re&ccedil;u d'imp&ocirc;t<cfelse>Dons sans re&ccedil;u d'imp&ocirc;t</cfif>
										<CFELSE>
											<cfif donRecu>Gifts with receipts<cfelse>Gifts without receipts</cfif>
										</CFIF>
									</td>
								</tr>
								<cfset soustotal=0>
								<CFOUTPUT>
									<cfset soustotal=soustotal+montant>
									<cfset total=total+montant>
									<cfset grandTotal=grandTotal+montant>
									<cfif donRecu>
										<cfset grandTotalAvecRecu=grandTotalAvecRecu+montant>
									<cfelse>
										<cfset grandTotalSansRecu=grandTotalSansRecu+montant>
									</cfif>
									<tr STYLE="line-height:20px;" CLASS="BlocCorps">
										<!--- COLONNES 1-2 --->
										<CFIF grouperpar EQ "date">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
										<CFELSE>
											<td colspan="2">#DateFormat(datedon, "yyyy-mm-dd")#</td>
										</CFIF>
										<!--- COLONNES 3-4 --->
										<CFIF grouperpar EQ "compte" OR grouperpar EQ  "methode">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
										<CFELSE>
											<td >#Nocompte#</td>
											<td >#compte#</td>
										</CFIF>
										<!--- COLONNES 5 --->
										<CFIF grouperpar EQ "methode">
											<td>#Nocompte# - #compte#</td>
										<CFELSE>
											<td>#description#</td>
										</CFIF>
										<!--- COLONNES 6 --->
										<CFIF grouperpar EQ "methode">
											<td>#description#</td>
										<CFELSE>
											<td>#methode#</td>
										</CFIF>
										<!--- <td>#description#</td>
										<td>#methode#</td> --->
										<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
									</tr>
								</CFOUTPUT>
								<!--- <tr>
									<td colspan="7" STYLE="border-top: solid 1px ##DDD;"></td>
								</tr> --->
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Sous-total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(soustotal)#</td>
								</tr>
							</CFOUTPUT>
							<tr STYLE="line-height:30px;" CLASS="BlocCorps">
								<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
								<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
							</tr>
							<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
						</CFOUTPUT>
						<tr>
							<td colspan="7" STYLE="border-top: solid 1px ##DDD;"></td>
						</tr> 
						<tr CLASS="BlocCorps">
							<td colspan="6" STYLE="text-align:right; font-weight:bold; ">
								<CFIF session.langue EQ "fr">
									Grand Total des dons sans re&ccedil;u d'imp&ocirc;t
								<CFELSE>
									Grand Total of gifts without receipts
								</CFIF>
							</td>
							<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotalSansRecu)#</CFOUTPUT></td>
						</tr>
						<tr CLASS="BlocCorps">
							<td colspan="6" STYLE="text-align:right; font-weight:bold; ">
								<CFIF session.langue EQ "fr">
									Grand Total des dons avec re&ccedil;u d'imp&ocirc;t
								<CFELSE>
									Grand Total of gifts with receipts
								</CFIF>
							</td>
							<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotalAvecRecu)#</CFOUTPUT></td>
						</tr>
						<tr CLASS="BlocCorps">
							<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
							<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
						</tr>
					</table> 

					<!--- 
					<CFIF grouperpar EQ "date">		
				
						<table WIDTH="100%" >
							<cfoutput query="ListeDons" GROUP="datedon">
								<tr class="BlocGroupe">
									<td COLSPAN="7">#DateFormat(datedon, "yyyy-mm-dd")#</td>
								</tr>
								<tr class="BlocSousEntete">
									<td colspan="2">Donateur</td>
									<td colspan="2">Compte</td>
									<td>Description</td>
									<td>Mode paiement</td>
									<td>Montant</td>
								</tr>
								<cfset total=0>
								<CFOUTPUT GROUP="donRecu">
									<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
										<td colspan="7"><cfif donRecu>Dons avec re&ccedil;us d'imp&ocirc;t<cfelse>Dons sans re&ccedil;us d'imp&ocirc;t</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;" CLASS="BlocCorps">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
											<td >#Nocompte#</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
									<tr>
										<td colspan="7" STYLE="border-top: solid 1px ##DDD;"></td>
									</tr>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
								<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "compte">
						<table WIDTH="100%" >
							<cfoutput query="ListeDons" GROUP="Nocompte">
								<cfset total=0>
								<tr class="BlocGroupe">
									<td COLSPAN="7">#NoCompte# #compte#</td>
								</tr>
								<tr class="BlocSousEntete">
									<td colspan="2">Donateur</td>
									<td colspan="2">Compte</td>
									<td>Description</td>
									<td>Mode paiement</td>
									<td>Montant</td>
								</tr>
								<CFOUTPUT GROUP="donRecu">
									<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
										<td colspan="7"><cfif donRecu>Dons avec re&ccedil;us d'imp&ocirc;t<cfelse>Dons sans re&ccedil;us d'imp&ocirc;t</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;" CLASS="BlocCorps">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
											<td >#Nocompte#</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
									<tr>
										<td colspan="7" STYLE="border-top: solid 1px ##DDD;"></td>
									</tr>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
								<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "donateur">
					
						<table WIDTH="100%">
							<cfoutput query="ListeDons" GROUP="nomComplet">
								<cfset total=0>
								<tr class="BlocGroupe">
									<td COLSPAN="7"><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF> </td>
								</tr>
								<tr class="BlocSousEntete">
									<td colspan="2">Donateur</td>
									<td colspan="2">Compte</td>
									<td>Description</td>
									<td>Mode paiement</td>
									<td>Montant</td>
								</tr>
								<CFOUTPUT GROUP="donRecu" >
									<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
										<td colspan="7"><cfif donRecu>Dons avec re&ccedil;us d'imp&ocirc;t<cfelse>Dons sans re&ccedil;us d'imp&ocirc;t</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;" CLASS="BlocCorps">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
											<td >#Nocompte#</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
									<tr>
										<td colspan="7" STYLE="border-top: solid 1px ##DDD;"></td>
									</tr>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
								<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "numero"><!--- GROUPE PAR NUMERO DONATEUR --->
						<table WIDTH="100%">
							<cfoutput query="ListeDons" GROUP="numero">
								<cfset total=0>
								<tr class="BlocGroupe">
									<td COLSPAN="7">#Numero#</td>
								</tr>
								<tr class="BlocSousEntete">
									<td colspan="2">Donateur</td>
									<td colspan="2">Compte</td>
									<td>Description</td>
									<td>Mode paiement</td>
									<td>Montant</td>
								</tr>
								
								<CFOUTPUT GROUP="donRecu">
									<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
										<td colspan="7"><cfif donRecu>Dons avec re&ccedil;us d'imp&ocirc;t<cfelse>Dons sans re&ccedil;us d'imp&ocirc;t</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;" CLASS="BlocCorps">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
											<td >#Nocompte#</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
								<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					
					<CFELSEIF grouperpar EQ "methode"><!--- GROUPE PAR MODE --->
						<table WIDTH="100%">
							<cfoutput query="ListeDons" GROUP="methode">
								<cfset total=0>
								<tr class="BlocGroupe">
									<td COLSPAN="7"><CFIF methode EQ "">Mode de paiement non sp&eacute;cifi&eacute;e<CFELSE>#methode#</CFIF></td>
								</tr>
								<tr class="BlocSousEntete">
									<td colspan="2">Donateur</td>
									<td colspan="2">Compte</td>
									<td>Description</td>
									<td>Mode paiement</td>
									<td>Montant</td>
								</tr>
								<CFOUTPUT GROUP="donRecu">
									<tr STYLE="line-height:20px;" CLASS="BlocSousGroupe">
										<td colspan="7"><cfif donRecu>Dons avec re&ccedil;us d'imp&ocirc;t<cfelse>Dons sans re&ccedil;us d'imp&ocirc;t</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;" CLASS="BlocCorps">
											<td>#numero#</td>
											<td><cfif NOT confidentiel>#nom#<cfif prenom NEQ "">, #prenom#</cfif><CFELSE>*****</CFIF></td>
											<td >#Nocompte#</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;" CLASS="BlocCorps">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">Grand Total</td>
								<td STYLE="text-align:right; font-weight:bold; "><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					</CFIF>  --->
				<!--- <CFELSE>
					<CFIF grouperpar EQ "date">		
					
						
					
					
					
				
						<table WIDTH="100%" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="datedon">
								<cfset total=0>
								<tr>
									<td COLSPAN="8" STYLE="font-weight:bold; ">#DateFormat(datedon, "yyyy-mm-dd")#</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Donor's Name</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Account</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Description</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Payment Method</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">Amount</td>
								</tr>
								<CFOUTPUT GROUP="recu">
									<tr STYLE="line-height:20px;">
										<td colspan="8" STYLE="font-style: italic;"><cfif recu>Gifts with receipts<cfelse>Gifts without receipts</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td STYLE="text-align:right;">#numero#&nbsp;</td>
											<td><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
											<td STYLE="text-align:right;">#Nocompte#&nbsp;</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
									
								</CFOUTPUT>
								
								<tr STYLE="line-height:30px;">
									<td colspan="7" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							
							<tr CLASS="BlocCorps">
								<td colspan="7" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "compte">
					
						<table WIDTH="100%" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="Nocompte">
								<cfset total=0>
								<tr>
									<td STYLE="font-weight:bold; ">#NoCompte#</td>
									<td COLSPAN="6" STYLE="font-weight:bold; ">#compte#</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Donor's Name</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Date</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Description</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Payment Method</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">Amount</td>
								</tr>
								<CFOUTPUT GROUP="recu">
									<tr STYLE="line-height:20px;">
										<td colspan="7" STYLE="font-style: italic;"><cfif recu>Gifts with recceipts<cfelse>Gifts without receipts</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td STYLE="text-align:right;">#numero#&nbsp;</td>
											<td><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
											<td >#DateFormat(datedon, "yyyy-mm-dd")#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "donateur">
						<table WIDTH="100%" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="nom">
								<cfset total=0>
								<tr>
									<td STYLE="font-weight:bold; ">#Numero#</td>
									<td COLSPAN="6" STYLE="font-weight:bold; "><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									
									<td STYLE="font-weight:bold; text-decoration: underline;">Date</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Account</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Description</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Payment Method</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">Amount</td>
								</tr>
								<CFOUTPUT GROUP="recu">
									<tr STYLE="line-height:20px;">
										<td colspan="7" STYLE="font-style: italic;"><cfif recu>Gifts with receipts<cfelse>Gifts without receipts</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td >#DateFormat(datedon, "yyyy-mm-dd")#</td>
											<td STYLE="text-align:right;">#Nocompte#&nbsp;</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSEIF grouperpar EQ "numero"><!--- GROUPE PAR NUMERO DONATEUR --->
					
						<table WIDTH="100%" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="numero">
								<cfset total=0>
								<tr>
									<td STYLE="font-weight:bold; ">#Numero#</td>
									<td COLSPAN="6" STYLE="font-weight:bold; "><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									
									<td STYLE="font-weight:bold; text-decoration: underline;">Date</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Account</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Description</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Payment Method</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">Amount</td>
								</tr>
								<CFOUTPUT GROUP="recu">
									<tr STYLE="line-height:20px;">
										<td colspan="7" STYLE="font-style: italic;"><cfif recu>Gifts with receipts<cfelse>Gifts without receipts</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td >#DateFormat(datedon, "yyyy-mm-dd")#</td>
											<td STYLE="text-align:right;">#Nocompte#&nbsp;</td>
											<td >#compte#</td>
											<td>#description#</td>
											<td>#methode#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="6" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="6" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					<CFELSE><!--- GROUPE PAR METHODE --->
					
						<table WIDTH="100%" CLASS="BlocCorps">
							<cfoutput query="ListeDons" GROUP="methode">
								<cfset total=0>
								<tr>
									<td COLSPAN="8" STYLE="font-weight:bold; "><CFIF methode EQ "">Payment method not specified<CFELSE>#methode#</CFIF></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Donor's Name</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Date</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">##&nbsp;</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Account</td>
									<td STYLE="font-weight:bold; text-decoration: underline;">Description</td>
									<td STYLE="font-weight:bold; text-decoration: underline;text-align:right;">Amount</td>
								</tr>
								<CFOUTPUT GROUP="recu">
									<tr STYLE="line-height:20px;">
										<td colspan="8" STYLE="font-style: italic;"><cfif recu>Gifts with receipts<cfelse>Gifts without receipts</cfif></td>
									</tr>
									<CFOUTPUT>
										<cfset total=total+montant>
										<cfset grandTotal=grandTotal+montant>
										<tr STYLE="line-height:20px;">
											<td>&nbsp;</td>
											<td STYLE="text-align:right;">#numero#&nbsp;</td>
											<td><cfif NOT confidentiel>#nom#, #prenom#<CFELSE>*****</CFIF></td>
											<td >#DateFormat(datedon, "yyyy-mm-dd")#</td>
											<td STYLE="text-align:right;">#Nocompte#&nbsp;</td>
											<td>#compte#</td>
											<td>#description#</td>
											<td STYLE="text-align:right;">#LSCurrencyFormat(montant)#</td>
										</tr>
									</CFOUTPUT>
								</CFOUTPUT>
								<tr STYLE="line-height:30px;">
									<td colspan="7" STYLE="font-weight:bold;text-align:right;">Total</td>
									<td STYLE="text-align:right;border-bottom: solid 1px  black;border-top:1px solid black;font-weight:bold;">#LSCurrencyFormat(total)#</td>
								</tr>
								<cfif groupes EQ "un"><tr><td><cfdocumentitem type="pagebreak"></cfdocumentitem></td></tr></CFIF>
							</CFOUTPUT>
							<tr CLASS="BlocCorps">
								<td colspan="7" STYLE="text-align:right; font-weight:bold; ">GRAND TOTAL</td>
								<td STYLE="text-align:right; font-weight:bold; font-size:12px;"><CFOUTPUT>#LSCurrencyFormat(grandTotal)#</CFOUTPUT></td>
							</tr>
						</table>
					</CFIF>
				</CFIF> --->
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
									<strong>RAPPORT DE DONS D&Eacute;TAILL&Eacute;</strong>
								<CFELSE>
									<strong>DETAILED GIFTS' REPORT</strong>
								</CFIF>
							</div>
        				</div>
        				
						<div class="w-form">
							<!--- LIEN VERS LES TUTORIELS --->
							<CFIF session.langue EQ "fr">
								<button style="background-color: white;" onClick="showHideTut()">
									<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutoriel.png">
								</button>
								<div id="videoTut" style="display: none;">
									<iframe width="90%" height="400" src="https://www.youtube.com/embed/hV57lDcwSF8?si=UNkZ9gLMmlOKIoeC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
								</div>
							<CFELSE>
								<button style="background-color: white;" onClick="showHideTut()">
									<img width="100" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/images/tutorial.png">
								</button>
								<div id="videoTut" style="display: none;">
									<iframe width="90%" height="400" src="https://www.youtube.com/embed/4GFgmdr4qRY?si=P7lJ8pVapTmNW6i_" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
								</div>
							</CFIF>
							
							<CFIF session.langue EQ "fr">
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_fr#" METHOD="POST">
							
									<div class="blocradiobuttons">
									<label class="labeldechamp" for="numdonateur">Grouper par</label>
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="date" checked="#grouperpar EQ 'date'#">
											<label class="w-form-label" for="grouperpardate">Date</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="compte" checked="#grouperpar EQ 'compte'#">
											<label class="w-form-label" for="grouperparcompte">Compte</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="donateur" checked="#grouperpar EQ 'donateur'#">
											<label class="w-form-label" for="grouperpardonateur">Donateur (nom)</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="numero" checked="#grouperpar EQ 'numero'#">
											<label class="w-form-label" for="grouperpardonateurNo">Donateur (no.)</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="methode" checked="#grouperpar EQ 'methode'#">
											<label class="w-form-label" for="grouperparmethode">M&eacute;thode de paiement</label>
										</div>
									</div>
									</div>
									<div class="blocradiobuttons">
									<label class="labeldechamp" for="numdonateur">Groupes par page</label>
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="groupes" id="groupes" name="groupes" type="radio" value="un" checked="#groupes EQ 'un'#">
											<label class="w-form-label" for="groupesun">Un</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="groupes" id="groupes" name="groupes" type="radio" value="plusieurs" checked="#groupes EQ 'plusieurs'#">
											<label class="w-form-label" for="groupesplusieurs">Plusieurs</label>
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
												<label class="w-form-label" for="dateperiode">S&eacute;lectionner une p&eacute;riode</label>
											</div>
										</div>
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
											<label class="w-form-label" for="donateursselection">S&eacute;lectionner les donateurs</label>
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
									<cfinput class="w-button boutonvalider" data-wait="Pr&eacute;paration du rapport en cours" name="rapport" type="submit" formtarget="_blank" value="Générer le rapport" wait="Préparation du rapport en cours">
									</div>
								</CFFORM>
							<CFELSE>
								<CFFORM data-name="Report Form" id="report-form" name="report-form" ACTION="#file_name_en#" METHOD="POST">
									
									<div class="blocradiobuttons">
									<label class="labeldechamp" for="numdonateur">Group by</label>
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="date" checked="#grouperpar EQ 'date'#">
											<label class="w-form-label" for="grouperpardate">Date</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="compte" checked="#grouperpar EQ 'compte'#">
											<label class="w-form-label" for="grouperparcompte">Account</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="donateur" checked="#grouperpar EQ 'donateur'#">
											<label class="w-form-label" for="grouperpardonateur">Donor (name)</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="numero" checked="#grouperpar EQ 'numero'#">
											<label class="w-form-label" for="grouperpardonateurNo">Donor (no.)</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="grouperpar" id="grouperpar" name="grouperpar" type="radio" value="methode" checked="#grouperpar EQ 'methode'#">
											<label class="w-form-label" for="grouperparmethode">Payment Method</label>
										</div>
									</div>
									</div>
									<div class="blocradiobuttons">
									<label class="labeldechamp" for="numdonateur">Groups per page</label>
									<div class="containerradiobuttons">
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="groupes" id="groupes" name="groupes" type="radio" value="un" checked="#groupes EQ 'un'#">
											<label class="w-form-label" for="groupesun">One</label>
										</div>
										<div class="w-radio champradiobutton">
											<cfinput class="w-radio-input" data-name="groupes" id="groupes" name="groupes" type="radio" value="plusieurs" checked="#groupes EQ 'plusieurs'#">
											<label class="w-form-label" for="groupesplusieurs">Multiple</label>
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
	
	<script type='text/javascript'>
		function showHideTut() {
        var x = document.getElementById("videoTut");
        if (x.style.display === "none") {
            x.style.display = "block";
        } else {
            x.style.display = "none";
            y.style.display = "block";
        }
    }
	</script>
	
	<CFCATCH>
		
		<CFINCLUDE TEMPLATE="../_envoi_erreur.inc"> 
				<CFIF Session.langue EQ "fr">
					<CFLOCATION URL="#APPLICATION.Racine#/fr/erreur" ADDTOKEN="NO">
				<CFELSE>
					<CFLOCATION URL="#APPLICATION.Racine#/en/error" ADDTOKEN="NO">
				</CFIF> 
	
	<!--- <cfoutput>
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
	</cfoutput> --->
	</CFCATCH>
</CFTRY>