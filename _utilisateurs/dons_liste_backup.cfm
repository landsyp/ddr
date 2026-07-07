<CFTRY>
	
	<cfset anneeCourante = DatePart("yyyy", Now())>
	
	<CFParam name="Session.dateDonDebut" default="#anneeCourante#-01-01">
	<CFParam name="Session.dateDonFin" default="#DateFormat(Now(), "yyyy-mm-dd")#">
	<CFParam name="Session.numero" default="">
	<CFParam name="Session.noCompte" default="">
	<CFParam name="Session.montant" default="">
	<CFParam name="Session.description" default="">
	<CFPARAM name="Session.message" default="">
	<CFParam name="URL.page" default="1">
	
	<CFParam name="URL.tri" default="dateD">
	
	<CFSET VARIABLES.title_en = "DDR GIFT LIST">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/gifts-list/sort-#URL.tri#/page-#URL.page#">
	<CFSET VARIABLES.title_fr = "DDR LISTE DONS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/liste-des-dons/tri-#URL.tri#/page-#URL.page#">
	
	<CFIF StructKeyExists(URL, 'supprimerDID')>
		<cfinvoke component="#APPLICATION.cfcDons#" method ="donSupprimer" returnvariable ="message">
			<cfinvokeargument name="donID" value="#URL.supprimerDID#">
		</cfinvoke>
	</CFIF>
	
	<CFIF StructKeyExists(Form, 'filtre')>
		<CFIF len(Form.dateDon) EQ 10 AND len(Form.dateDonFin) EQ 10>
			<cfset URL.page = 1>
			<cfset Session.dateDonDebut = Form.dateDon>
			<cfset Session.dateDonFin = Form.dateDonFin>
			<cfset Session.numero = Form.numero>
			<cfset Session.noCompte = Form.noCompte>
			<cfset Session.montant = Form.montant>
			<cfset Session.description = Trim(Form.description)>
			<CFSET session.message = "">
		<CFELSE>
			<CFIF len(Form.dateDon) NEQ 10>
				<CFSET session.message = "Date de début non valide #Form.dateDon#. Elle a été remplacée par la date de début par défaut.<BR>">
				<CFSET Session.dateDonDebut = "#anneeCourante#-01-01">
			</CFIF>
			<CFIF len(Form.dateDonFin) NEQ 10>
				<CFSET session.message = Session.message&"Date de fin non valide #Form.dateDonFin#. Elle a été remplacée par la date de fin par défaut.<BR>">
				<CFSET Session.dateDonFin = "#DateFormat(Now(), "yyyy-mm-dd")#">
			</CFIF>
		</CFIF>
		<!---
		<cfset URL.page = 1>
		<cfset Session.dateDonDebut = Form.dateDon>
		<cfset Session.dateDonFin = Form.dateDonFin>
		<cfset Session.numero = Form.numero>
		<cfset Session.noCompte = Form.noCompte>
		<cfset Session.montant = Form.montant>
		<cfset Session.description = Trim(Form.description)>
		--->
	</CFIF> 

	<cfinvoke component="#APPLICATION.cfcDons#" method = "donsListe" returnvariable ="liste">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDon" value="#Session.dateDonDebut#">
		<cfinvokeargument name="dateDonFin" value="#Session.dateDonFin#">
		<cfinvokeargument name="langue" value="#URL.langue#">
		<cfinvokeargument name="numero" value="#Session.numero#">
		<cfinvokeargument name="noCompte" value="#Session.noCompte#">
		<cfinvokeargument name="montant" value="#Session.montant#">
		<cfinvokeargument name="description" value="#Session.description#">
		<cfinvokeargument name="tri" value="#URL.tri#">
	</cfinvoke>
	<cfinvoke component="#APPLICATION.cfcDons#" method = "donsTotal" returnvariable ="total">
		<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
		<cfinvokeargument name="dateDon" value="#Session.dateDonDebut#">
		<cfinvokeargument name="dateDonFin" value="#Session.dateDonFin#">
		<cfinvokeargument name="numero" value="#Session.numero#">
		<cfinvokeargument name="noCompte" value="#Session.noCompte#">
		<cfinvokeargument name="montant" value="#Session.montant#">
		<cfinvokeargument name="description" value="#Session.description#">
	</cfinvoke>
	
	<cfset donsParPage = 50>
	<cfset premierDon = ((URL.page-1)*donsParPage)+1>
	<cfset nbrePages = Ceiling(liste.recordcount/donsParPage)>
	<!--- <cfoutput>#nbrePages#</cfoutput> --->

	<CFIF StructKeyExists(URL, 'excel')>
		<cfheader name="Content-Disposition" value="inline; filename=liste_dons.xls"> 
		 <cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet; charset=windows-1252">
		<html xmlns:o="urn:schemas-microsoft-com:office:office"
			xmlns:x="urn:schemas-microsoft-com:office:excel"
			xmlns="http://www.w3.org/TR/REC-html40">
		<body>
			<table cellpadding=2 cellspacing=0 WIDTH="100%" CLASS="BlocCorps">
				<THEAD>
					<CFIF session.langue EQ "fr">
						<TH CLASS="BlocEntete">Date</TH>
						<TH CLASS="BlocEntete">No. donateur</TH>
						<TH CLASS="BlocEntete">Donateur Nom</TH>
						<TH CLASS="BlocEntete">Compte</TH>
						<TH CLASS="BlocEntete">Méthode</TH>
						<TH CLASS="BlocEntete">Description</TH>
						<TH CLASS="BlocEntete">Montant</TH>
					<CFELSE>
						<TH CLASS="BlocEntete">Date</TH>
						<TH CLASS="BlocEntete">Donor no.</TH>
						<TH CLASS="BlocEntete">Donor Name</TH>
						<TH CLASS="BlocEntete">Account</TH>
						<TH CLASS="BlocEntete">Method</TH>
						<TH CLASS="BlocEntete">Description</TH>
						<TH CLASS="BlocEntete">Amount</TH>
					</CFIF>
				</THEAD>
				<CFSET total = 0>
				<cfoutput query="liste" >
					<tr STYLE="line-height:20px;">
						<td>#DateFormat(dateDon, "yyyy-mm-dd")#</td>
						<td>#numero#</td>
						<td>#nom#<CFIF prenom NEQ "">, #prenom#</CFIF></td>
						<td>#noCompte# - #libelleCompte#</td>
						<td>#methode#</td>
						<td>#description#</td>
						<td>#trim(numberFormat(montant,'__.00'))#</td>
					</tr>
					<CFSET total = total+montant>
				</cfoutput>	
					<tr STYLE="line-height:20px;">
						<td></td>
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
				
				<SCRIPT LANGUAGE="javascript">
					function blocking(nr)
					{
						if (document.layers)
						{
							current = (document.layers[nr].display == 'none') ? 'block' : 'none';
							document.layers[nr].display = current;
						}
						else if (document.all)
						{
							current = (document.all[nr].style.display == 'none') ? 'block' : 'none';
							document.all[nr].style.display = current;
						}
						else if (document.getElementById)
						{
							vista = (document.getElementById(nr).style.display == 'none') ? 'block' : 'none';
							document.getElementById(nr).style.display = vista;
						}
					}
					// -->
				</SCRIPT>
				
			</head>

			<body>
				<CFINCLUDE TEMPLATe="_menu.inc">
				
				<CFINCLUDE TEMPLATe="_organisme.inc">
				
				<!--- 
				<div class="w-section sectionsousheader">
					<div class="w-container containersousheader">
						<div class="wrappersousheader">
							<CFIF session.langue EQ "fr">
								<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Dons &gt; Liste des dons</h3>
							<CFELSE>
								<h3 class="headingbreadcrumb"><a href="#APPLICATION.Racine#/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Gifts &gt; Gifts' List</h3>
							</CFIF>
						</div>
					</div>
				</div> --->
				
				
				<div class="w-section sectioncontenuprincipal">
				
					<CFINCLUDE TEMPLATe="_sous-menu-dons.inc">
				
					<!--- <CFIF session.langue EQ "fr">
												
								<cfoutput query="liste">
									#dateDon# #numero# #prenom# #nom# #noCompte# #libelleCompte# #montant#  <cfif verouille>Verouillé<CFELSE><a href="#APPLICATION.Racine#/fr/secure/editer-don-#donID#">Editer</a></CFIF> <a href="#APPLICATION.Racine#/fr/secure/supprimer-don-#donID#">Supprimer</a><br> 
								</cfoutput>
							<CFELSE>
								<a href="#APPLICATION.Racine#/en/secure/add-gift">Add gift</a><br>
								<cfoutput query="liste">
									#dateDon# #numero# #prenom# #nom# #noCompte# #libelleCompte# #montant#  <a href="#APPLICATION.Racine#/en/secure/edit-gift-#donID#">Edit</a> <a href="#APPLICATION.Racine#/en/secure/delete-gift-#donID#">Archive</a><br> 
										
								</cfoutput>
							</CFIF> --->
					<CFIF session.langue EQ "fr">
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<CFIF isDefined('URL.supprimerDID')> 
									<div class="blocsucces">
										<div>Le don a été supprimé</div>
									</div>
								</CFIF>
								<div class="containerselectionneur">
									<cfoutput>
										<CFIF session.message NEQ ""> 
											<SPAN style="color:red;">#session.message#</SPAN>
										</CFIF>
										#liste.recordcount#</cfoutput> dons totalisant <cfoutput>#DollarFormat(total.total)#
									</cfoutput>
									<!--- <cfoutput>#liste.recordcount#</cfoutput> dons totalisant <cfoutput>#DollarFormat(total.total)#</cfoutput> --->
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/liste-des-dons-excel">Exporter vers Excel<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="exporter vers Excel"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_fr#" METHOD="POST">
											<label class="labelselection" for="Num-de-don">Date de :</label>
											<div class="w-embed champselection champselectiondate" style="width:125px;">
												<cfinput type="date" name="dateDon" value="#Session.datedonDebut#" style="margin:0;padding:0;"> 
											</div>
											<label class="labelselection" for="Num-de-don">Date fin :</label>
											<div class="w-embed champselection champselectiondate" style="width:125px;">
												<cfinput type="date" name="dateDonFin" value="#Session.datedonFin#" style="margin:0;padding:0;"> 
											</div>
											<!--- <label class="labelselection" for="Num-de-don"># donateur :</label> --->
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" placeholder="# donateur" style="width:70px;" pattern="[0-9]+" oninvalid="setCustomValidity('Le # donateur doit correspondre à une valeur numérique')" onchange="try{setCustomValidity('')}catch(e){}">
											<!--- <label class="labelselection" for="Num-de-don"># compte :</label> --->
											<input class="w-input champselection" data-name="No du compte" id="noCompte" maxlength=50" name="noCompte" value="<cfoutput>#Session.noCompte#</cfoutput>"  type="text" placeholder="# compte" style="width:70px;" pattern="[0-9]+" oninvalid="setCustomValidity('Le # compte doit correspondre à une valeur numérique')" onchange="try{setCustomValidity('')}catch(e){}">
											<!--- <label class="labelselection" for="Num-de-don">Montant :</label> --->
											<input class="w-input champselection" data-name="Montant du don" id="montant" maxlength="256" name="montant" type="text" placeholder="montant" style="width:70px;" value="<cfoutput>#Session.montant#</cfoutput>"  pattern="-?(0\.((0[1-9]{1})|-?([1-9]{1}([0-9]{1})?)))|-?(([1-9]+[0-9]*)(\.([0-9]{1,2}))?)" oninvalid="setCustomValidity('Veuillez entrer un montant valide (sans signe de $ ou ,)')" onchange="try{setCustomValidity('')}catch(e){}">
											<input class="w-input champselection" data-name="Description" id="description" maxlength=50" name="description" value="<cfoutput>#Session.description#</cfoutput>"  type="text" placeholder="description" style="width:75px;" >
											<cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Filtrer" name="filtre" >
										</cfform>
									</div>
								</div><!--- <div class="containerselectionneur"> --->
								
								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#/fr/secure/liste-des-dons/tri-#URL.tri#/page-#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
									</a>
									</cfloop>
								</div>
								
								<div class="lignedetableau headertableau">
									<div class="itemligne itemdate">
										<strong>Date </strong> &nbsp;
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-dateA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-dateD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong># Donateur</strong>&nbsp;
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-donateurA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-donateurD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong># Compte</strong>&nbsp;
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-compteA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-compteD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Montant</strong>&nbsp;
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-donA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-donD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Méthode</strong>&nbsp;
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-methodeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/fr/secure/liste-des-dons/tri-methodeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne"><strong>Description</strong></div>
									<div class="editerligne"></div>
								</div>
								<cfoutput query="liste" startRow=#premierDon# maxrows=#donsParPage#>
									<div class="lignedetableau">	
										<div class="itemligne itemdate"> #dateDon#</div>
										<div class="itemligne">###numero# - #nom#<CFIF prenom NEQ "">, #prenom#</CFIF> </div>
										<div class="itemligne">###noCompte# - #libelleCompte#</div>
										<div class="itemligne">#DollarFormat(montant)# #organisme.devise#</div>
										<div class="itemligne">#methode#</div>
										<div class="itemligne">#description#</div>
										<div class="editerligne">
											<CFIF not verouille OR Session.utilisateur.statut EQ 0>
												<a class="w-inline-block lientableau" href="#APPLICATION.Racine#/fr/secure/editer-don-#donID#"><img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-pencil-4.svg" width="14" TITLE="Editer">
												</a>
												<a class="w-inline-block lientableau" href="##" onClick="blocking('#donID#'); return false;"><img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Supprimer">
												</a>
											<CFELSE>
												<img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-lock-1.svg" width="14" TITLE="Verrouillé">
											</CFIF>
										</div>
									</div>
									<CFIF not verouille  OR Session.utilisateur.statut EQ 0>
										<div class="lignesuppressiondon" id="#donID#" style="display: none">
											<div class="texteblanc">Confirmez-vous la supression du don de #DollarFormat(montant)# de  #prenom# #nom# ?</div><a class="w-button boutonsupression" href="#APPLICATION.Racine#/fr/secure/supprimer-don-#donID#">OUI</a><a class="w-button boutonsupression" data-ix="hide-delete-message" href="##">NON</a>
										</div>
									</CFIF>
								</cfoutput>
							
								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#/fr/secure/liste-des-dons/tri-#URL.tri#/page-#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
									</a>
									</cfloop>
								</div>
							</div>
						</div><!--- <div class="w-container containerprincipal"> --->
					<CFELSE> 
						<div class="w-container containerprincipal">
							<div class="blockfondblancpageinterne">
								<CFIF isDefined('URL.supprimerDID')>
									<div class="blocsucces">
										<div>The gift has been deleted</div>
									</div>
								</CFIF>
								<div class="containerselectionneur">
									<cfoutput>#liste.recordcount#</cfoutput> gifts totaling <cfoutput>#DollarFormat(total.total)#</cfoutput>
									<div style="float:right;margin-right:20px;font-size:10pt;"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/gift-lists-excel">Export to Excel<IMG SRC="/images/excel_download.png" STYLE="height:30px;" title="export to Excel"></a></div>
									<div class="w-form wrapperformulaire">
										<cfform class="formulaireselection" data-name="Sort Form" id="sort-form" name="sort-form" ACTION="#file_name_en#" METHOD="POST">
											<label class="labelselection" for="Num-de-don">Beginning Date:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateDon" value="#Session.datedonDebut#" style="margin:0;padding:0;">
											</div>
											<label class="labelselection" for="Num-de-don">End Date:</label>
											<div class="w-embed champselection champselectiondate">
												<cfinput type="date" name="dateDonFin" value="#Session.datedonFin#" style="margin:0;padding:0;">
											</div>
											<!--- <label class="labelselection" for="Num-de-don">Donor #:</label> --->
											<input class="w-input champselection" data-name="No de don" id="numero" maxlength=50" name="numero" value="<cfoutput>#Session.numero#</cfoutput>"  type="text" placeholder="Donor #" style="width:70px;" pattern="[0-9]+" oninvalid="setCustomValidity('The Donor # should be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
											<!--- <label class="labelselection" for="Num-de-don">Account #:</label> --->
											<input class="w-input champselection" data-name="No du compte" id="noCompte" maxlength=50" name="noCompte" value="<cfoutput>#Session.noCompte#</cfoutput>"  type="text" placeholder="Account #" style="width:70px;" pattern="[0-9]+" oninvalid="setCustomValidity('The Account # should be a numeric value')" onchange="try{setCustomValidity('')}catch(e){}">
											<!--- <label class="labelselection" for="Num-de-don">Amount :</label> --->
											<input class="w-input champselection" data-name="Montant du don" id="montant" maxlength="256" name="montant" type="text" placeholder="Amount" style="width:70px;" value="<CFOUTPUT>#Session.montant#</CFOUTPUT>"  pattern="-?(0\.((0[1-9]{1})|-?([1-9]{1}([0-9]{1})?)))|-?(([1-9]+[0-9]*)(\.([0-9]{1,2}))?)" oninvalid="setCustomValidity('Enter a valid amount without dollar sign $ or ,')" onchange="try{setCustomValidity('')}catch(e){}">
											<input class="w-input champselection" data-name="Description" id="description" maxlength=50" name="description" value="<cfoutput>#Session.description#</cfoutput>"  type="text" placeholder="description" style="width:75px;" >
											<cfinput class="w-button boutonselectionneur" data-wait="Please wait ..." type="submit" value="Filter" name="filtre" >
                                            <cfinput class="w-button boutonselectionneur" data-wait="Veuillez attendre ..." type="submit" value="Initialiser" name="initialiser" >
										</cfform>
									</div>
								</div><!--- <div class="containerselectionneur"> --->
								
								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#/en/secure/gifts-list/sort-#URL.tri#/page-#page#</cfoutput>">
										<div class="numeropage" <cfif page EQ URL.page>STYLE="font-size:18px;font-weight:bold;"</CFIF>><cfoutput>#page#</cfoutput></div>
									</a>
									</cfloop>
								</div>
								
								<div class="lignedetableau headertableau">
									<div class="itemligne itemdate">
										<strong>Date</strong>&nbsp;
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-dateA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-dateD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Donor #</strong>&nbsp;
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-donateurA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-donateurD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Account #</strong>&nbsp;
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-compteA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-compteD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Amount</strong>&nbsp;
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-donA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-donD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne">
										<strong>Method</strong>&nbsp;
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-methodeA/page-1"><img  src="https://solution-ddr.com/images/tri_asc.png" STYLE="height:5px;"></a>
										<a href="https://solution-ddr.com/en/secure/gifts-list/sort-methodeD/page-1"><img  src="https://solution-ddr.com/images/tri_des.png" STYLE="height:5px;"></a>
									</div>
									<div class="itemligne"><strong>Description</strong></div>
									<div class="editerligne"></div>
								</div>
								<cfoutput query="liste" startRow=#premierDon# maxrows=#donsParPage#>
									<div class="lignedetableau">
										<div class="itemligne itemdate">#dateDon#</div>
										<div class="itemligne">###numero# - #nom#<CFIF prenom NEQ "">, #prenom#</CFIF></div>
										<div class="itemligne">###noCompte# - #libelleCompte#</div>
										<div class="itemligne">#DollarFormat(montant)# #organisme.devise#</div>
										<div class="itemligne">#methode#</div>
										<div class="itemligne">#Description#</div>
										<div class="editerligne">
											<CFIF not verouille  OR Session.utilisateur.statut EQ 0>
												<a class="w-inline-block lientableau" href="#APPLICATION.Racine#/en/secure/edit-gift-#donID#"><img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-pencil-4.svg" width="14" TITLE="Edit">
												</a>
												<a class="w-inline-block lientableau" href="##" onClick="blocking('#donID#'); return false;"><img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-x-mark-1.svg" width="14" TITLE="Delete">
												</a>
											<CFELSE>
												<img class="iconetableau" src="#APPLICATION.Racine#/images/iconmonstr-lock-1.svg" width="14">
											</CFIF>
										</div>
									</div>
									<CFIF not verouille  OR Session.utilisateur.statut EQ 0> 
										<div class="lignesuppressiondon" id="#donID#" style="display: none">
											<div class="texteblanc">Confirm deletion of gift #DollarFormat(montant)# from  #prenom# #nom# ?</div><a class="w-button boutonsupression" href="#APPLICATION.Racine#/en/secure/delete-gift-#donID#">YES</a><a class="w-button boutonsupression" data-ix="hide-delete-message" href="##">NO</a>
										</div>
									</CFIF>
								</cfoutput>
							
								<div class="blockpagination">
									<cfloop index="page" from="1" to="#nbrePages#">
									<a class="w-inline-block blocklienpagination" href="<cfoutput>#APPLICATION.Racine#/en/secure/gifts-list/sort-#URL.tri#/page-#page#</cfoutput>">
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