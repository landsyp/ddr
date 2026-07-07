<CFTRY>
	<cfset anneeCourante = DatePart("yyyy", Now())>
	<CFParam name="Session.DateDe" default="#anneeCourante#-01-01">
	<CFParam name="Session.DateA" default="#DateFormat(Now(), "yyyy-mm-dd")#">
	<CFParam name="Session.numero" default="">
	<CFParam name="URL.page" default="1">
	<CFIF StructKeyExists(URL,'tri')>
		<cfset Session.tri = URL.tri>
	<CFELSE>
		<cfset Session.tri = "">
	</CFIF>
	
	<CFSET VARIABLES.title_en = "DDR INFO ON PDF PRINTS">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/report-pdf-printing"> 
	<CFSET VARIABLES.title_fr = "DDR INFO SUR IMPRESSIONS PDF">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/rapport-impression-pdf">
	
	<cfset newLocal = SetLocale("English (Canadian)")>
	
	<CFIF StructKeyExists(Form, 'filtre')>
		<cfset Session.dateDe = Form.dateDe>
		<cfset Session.dateA = Form.dateA>
		<cfset Session.numero = Form.numero>
	</CFIF> 
	
	<cfinvoke component="#APPLICATION.cfcRecus#" method = "recusDistinctInfo" returnvariable ="recusInfo">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDebut" value="#Session.dateDe#">
		<cfinvokeargument name="dateFin" value="#session.dateA#">
		<cfinvokeargument name="numero" value="#session.numero#">
		<cfinvokeargument name="tri" value="#Session.tri#">
	</cfinvoke>
	
	<cfset donateursParPage = 50>
	<cfset premierDonateur = ((URL.page-1)*donateursParPage)+1>
	<cfset nbrePages = Ceiling(recusInfo.recordcount/donateursParPage)>
	
	<CFIF StructKeyExists(URL, 'excel')>
		<cfheader name="Content-Disposition" value="inline; filename=recus.xls"> 
		<!--- <cfcontent type="application/msexcel; charset=windows-1252"> --->
		 <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; charset=windows-1252">
		<html xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns="http://www.w3.org/TR/REC-html40">
		<body>
			<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
				<THEAD>
					<CFIF session.langue EQ "fr">
						<!--- <TH CLASS="BlocEntete">Date création</TH> --->
						<TH CLASS="BlocEntete">Début période</TH>
						<TH CLASS="BlocEntete">Fin période</TH>
						<TH CLASS="BlocEntete">No. donateur</TH>
						<TH CLASS="BlocEntete">Nom</TH>
						<TH CLASS="BlocEntete">Prénom</TH>
						<TH CLASS="BlocEntete">Montant</TH>
					<CFELSE>
						<!--- <TH CLASS="BlocEntete">Date creation</TH> --->
						<TH CLASS="BlocEntete">From</TH>
						<TH CLASS="BlocEntete">To</TH>
						<TH CLASS="BlocEntete">Donor no.</TH>
						<TH CLASS="BlocEntete">Last Name</TH>
						<TH CLASS="BlocEntete">First Name</TH>
						<TH CLASS="BlocEntete">Amount</TH>
					</CFIF>
				</THEAD>
				<CFSET total = 0>
				<cfoutput query="recusInfo">
					<tr STYLE="line-height:20px;">
						<!--- <td>#DateFormat(recusInfo.dateCreation, "yyyy-mm-dd")#</td> --->
						<td>#DateFormat(recusInfo.dateDebut, "yyyy-mm-dd")#</td>
						<td>#DateFormat(recusInfo.dateFin, "yyyy-mm-dd")#</td>
						<td>#recusInfo.numero#</td>
						<td>#recusInfo.nom#</td>
						<td>#recusInfo.prenom#</td>
						<!--- <td>#DecimalFormat(recusInfo.montant)#</td> --->
						<td>#trim(numberFormat(recusInfo.montant,'__.00'))#</td>
					</tr>
					<CFSET total = total+recusInfo.montant>
				</cfoutput>	
					<tr STYLE="line-height:20px;">
						<!--- <td></td> --->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td style="text-align:right;"><strong>Total</strong></td>
						<td><strong><cfoutput>#DecimalFormat(total)#</cfoutput></strong></td>
					</tr>
			</table>
		</body>
		</html>
	<CFELSE>
	
		<!DOCTYPE HTML >
		<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
			<head>
				<CFINCLUDE TEMPLATe="../_head.inc">
			</head>

			<body>
				<CFINCLUDE TEMPLATe="_menu.inc">
				
				<CFINCLUDE TEMPLATe="_organisme.inc">
				
				<div class="w-section sectioncontenuprincipal">
				
					<CFINCLUDE TEMPLATe="_sous-menu-generateur-recus.inc">

					<CFIF session.langue EQ "fr">
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<div class="containertyperapport">
									<div class="titretyperapport">
										<strong>RAPPORT IMPRESSION</strong>
										<span style="font-size:10pt;color:red;"><BR>*** Pour les reçus pdf produits depuis le 6 mars 2020 ***</span> 
									</div>
								</div>
								
								<div class="containerselectionneur">
									<cfoutput>#recusInfo.recordcount#</cfoutput> reçus pdf produits
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/rapport-impression-excel">Exporter vers Excel<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="exporter vers Excel"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST">
											<label class="labelselection" for="Num-de-don">Date début :</label>
											<div class="w-embed champselection champselectiondate"> 
												<cfinput type="date" name="dateDe" value="#Session.datede#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don">Date fin :</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateA" value="#Session.dateA#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don"># donateur :</label>
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('Le # donateur doit correspondre &agrave; une valeur numérique')" onchange="try{setCustomValidity('')}catch(e){}">
											<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >
										</cfform>
									</div>
								</div>
								
								<div class="lignedetableau headertableau">
									<!--- <div class="itemligne"><strong>Date création</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-dateCreationA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-dateCreationD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div> --->
									<div class="itemligne"><strong>Date début</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-dateDeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-dateDeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Date Fin</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-dateAA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-dateAD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne" STYLE="display:inline;"><strong>No. donateur</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Nom, Prénom</strong> <a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_fr#</CFOUTPUT>/tri-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Montant</strong></div>
								</div>
								<cfoutput query="recusInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
									<div class="lignedetableau">
										<!--- <div class="itemligne">#DateFormat(recusInfo.dateCreation, "yyyy-mm-dd")# #timeFormat(recusInfo.dateCreation, "HH:mm:ss")#</div> --->
										<div class="itemligne">#DateFormat(recusInfo.dateDebut, "yyyy-mm-dd")#</div>
										<div class="itemligne">#DateFormat(recusInfo.dateFin, "yyyy-mm-dd")#</div>
										<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-donateur-#recusInfo.donateurID#">## #recusInfo.numero#</a></div>
										<div class="itemligne">#recusInfo.nom#<CFIF recusInfo.prenom NEQ "">, #recusInfo.prenom#</CFIF></div>
										<div class="itemligne">#LSCurrencyFormat(recusInfo.montant)#</div>
									</div>
								</cfoutput>

								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#file_name_fr#</cfoutput>/page-<cfoutput>#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
									</a>
									</cfloop>
								</div>
							</div>
						</div><!--- <div class="w-container containerprincipal"> --->
					<CFELSE>
						
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<div class="containertyperapport">
									<div class="titretyperapport">
										<strong>PRINTING REPORT</strong>
										<span style="font-size:10pt;color:red;"><BR>*** For pdf receipts produced since March 6, 2020 ***</span> 
									</div>
								</div>
								
								<div class="containerselectionneur">
									<cfoutput>#recusInfo.recordcount#</cfoutput> pdf receipts produced
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/report-excel-printing">Export to Excel<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="export to Excel"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
											<label class="labelselection" for="Num-de-don">From:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateDe" value="#Session.datede#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don">To:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateA" value="#Session.dateA#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don"># donor :</label>
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" pattern="[0-9]+" oninvalid="setCustomValidity('The donor # must be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
											
											<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >
										</cfform>
									</div>
								</div>

								<!--- <div class="lignedetableau headertableau">
									<div class="itemligne"><strong>Date Sent</strong> <a href="<cfoutput>#file_name_fr#</cfoutput>/tri-dateEnvoiA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/tri-dateEnvoiD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne" STYLE="display:inline;"><strong>Donor #</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Name</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Email</strong></div>
									<div class="itemligne"><strong>Status</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-statutA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-statutD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
								</div> --->
								
								<div class="lignedetableau headertableau">
									<!--- <div class="itemligne"><strong>Date création</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-dateCreationA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-dateCreationD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div> --->
									<div class="itemligne"><strong>From</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-dateDeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-dateDeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>To</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-dateAA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-dateAD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne" STYLE="display:inline;"><strong>Donor #</strong> <a href="<cfoutput>#file_name_en#</cfoutput>/sort-numeroA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-numeroD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Name</strong> <a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a><a href="<cfoutput>#file_name_en#</CFOUTPUT>/sort-nomD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a></div>
									<div class="itemligne"><strong>Amount</strong></div>
								</div>
								
								
								<cfoutput query="recusInfo" startRow=#premierDonateur# maxrows=#donateursParPage#>
									<div class="lignedetableau">
										<!--- <div class="itemligne">#DateFormat(recusInfo.dateCreation, "yyyy-mm-dd")# #timeFormat(recusInfo.dateCreation, "mm:ss")#</div> --->
										<div class="itemligne">#DateFormat(recusInfo.dateDebut, "yyyy-mm-dd")#</div>
										<div class="itemligne">#DateFormat(recusInfo.dateFin, "yyyy-mm-dd")#</div>
										<div class="itemligne"><a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-donor-#recusInfo.donateurID#">## #recusInfo.numero#</a></div>
										<div class="itemligne">#recusInfo.nom#<CFIF recusInfo.prenom NEQ "">, #recusInfo.prenom#</CFIF></div>
										<div class="itemligne">#LSCurrencyFormat(recusInfo.montant)#</div>
									</div>
									
								</cfoutput>

								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#file_name_en#</cfoutput>/page-<cfoutput>#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
									</a>
									</cfloop>
								</div>
							</div>
						</div><!--- <div class="w-container containerprincipal"> --->
					</CFIF>
				</div><!--- <div class="w-section sectioncontenuprincipal"> --->
				<CFINCLUDE TEMPLATe="../_footer.inc">
			
				<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
				<script type="text/javascript" src="<cfoutput>#APPLICATION.Racine#</cfoutput>/js/webflow.js"></script>
				<!--[if lte IE 9]><script src="https://cdnjs.cloudflare.com/ajax/libs/placeholders/3.0.2/placeholders.min.js"></script><![endif]-->
			</body>
		</html>
	</CFIF>
	
	
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
		</cfoutput>  --->
			
	</CFCATCH>
</CFTRY>