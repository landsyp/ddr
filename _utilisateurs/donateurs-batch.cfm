<!--- EXCEL AVEC ENTETES--->
<!--- 	
		TEMPLATE FR					TEMPLATE EN			 
		1	# Donateur				1	Donor # 			
		2	Nom ou organimse 		2	Organization or Last Name		
		3	Prénom					3 	First Name
		4  	Adresse					4	Address
		5  	Ville					5	City
		6	Code Postal				6	Postal Code
		7	Province				7	Province	
		8	Courriel				8	Email
		9	Téléphone				9	Telephone
		10	Cellulaire				10	Cell
 --->
<CFTRY>
	
	<CFSET VARIABLES.title_en = "DDR DONORS IMPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/donors-batch-import">
	<CFSET VARIABLES.title_fr = "DDR IMPORT DE DONATEURS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/import-donateurs-lot">
	
	<CFParam name="organismeID" default="#Session.utilisateur.organismeID#">
	
	<cfset Session.message = "">
	<cfset Session.messageEchec = "">
	
	<!--- TELECHARGEMENT --->
	<CFIF isDefined('Form.importDonateurs')>
		<CFIF len(Form.NouveauxDonateurs) GT 6>
			
			<CFSET Rejects = ArrayNew(2)>
			<CFFILE ACTION="UPLOAD" FILEFIELD="NouveauxDonateurs" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
			<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
		
			<cfset document2 = "#APPLICATION.Path#\temp\NouveauxDonateurs.#File.ClientFileExt#">
			
			<cffile action="COPY" source=#document1# destination=#document2#>
			
			<cffile action="DELETE" file=#document1#> 
			
			<cfspreadsheet action="read" src="#Application.Path#\temp\NouveauxDonateurs.xlsx" query="excelquery" sheet="1" >
			
			<CFSET row =1>
			<CFSET reject = 1>
		
			<CFOUTPUT query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
		
				<!--- EVITER INSCRIPTION DE LIGNE VIDE --->
				<CFIF excelquery.col_2 NEQ "" OR excelquery.col_4 NEQ "">
					<!--- #excelquery.col_1#, #excelquery.col_2#,#excelquery.col_3#,#excelquery.col_4#,#excelquery.col_5# --->
					<!--- SI UNE DONNEE MANQUANTE --->
					<CFIF excelquery.col_2 EQ "" OR excelquery.col_4 EQ "" OR excelquery.col_7 EQ "">
						<!--- &nbsp;erreur<br>  --->
						<CFSET Rejects[reject][1] = row >
							<CFSET Rejects[reject][2] = excelquery.col_1&"|"&excelquery.col_2&"|"&excelquery.col_3&"|"&excelquery.col_4&"|"&excelquery.col_5 >
							<CFIF session.langue EQ "fr">
								<CFSET Rejects[reject][3] = "Le nom, l'adresse et la province sont obligatoires.">
							<CFELSE>
								<CFSET Rejects[reject][3] = "Name, address and province are mandatory.">
							</CFIF>
							<CFSET reject++>
					<CFELSE>
						<!--- &nbsp;ok<br>  --->
						
						<!--- SI LE NUMERO DE DONATEUR N'EST PAS INSCRIT ON LE GENERE --->
						<CFIF excelquery.col_1 EQ "" OR NOT isNumeric(excelquery.col_1)>
							<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "ProchainNoDonateur" returnvariable ="numero">
								<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
							</cfinvoke>
						<CFELSE>
							<CFSET numero = excelquery.col_1>
						</CFIF>
						<!--- #numero#<br> --->
						<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "TrouvreProvinceID" returnvariable ="provinceID">
							<cfinvokeargument name="abreviation" value="#excelquery.col_7#">
						</cfinvoke>
						
						
						<cfinvoke component="#APPLICATION.cfcDonateurs#" method = "donateurAjoutBatch" returnvariable ="did">
							<cfinvokeargument name="actif" value="True">
							<cfinvokeargument name="adresse" value="#excelquery.col_4#">
							<cfinvokeargument name="code_postal" value="#Ucase(excelquery.col_6)#">
							<cfinvokeargument name="courriel" value="#excelquery.col_8#">
							<cfinvokeargument name="membre" value="False">
							<cfinvokeargument name="nom" value="#excelquery.col_2#">
							<cfinvokeargument name="numero" value="#numero#">
							<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
							<cfinvokeargument name="prenom" value="#excelquery.col_3#">
							<cfinvokeargument name="provinceID" value="#provinceID#">
							<cfinvokeargument name="recu" value="True">
							<cfinvokeargument name="tel_cellulaire" value="#excelquery.col_10#">
							<cfinvokeargument name="tel_residence" value="#excelquery.col_9#">
							<cfinvokeargument name="ville" value="#excelquery.col_5#">
						</cfinvoke>
						
					</CFIF>

				</CFIF>
				
				<CFSET row++>
			</CFOUTPUT>
		</CFIF>
	</CFIF>
	

	
	<!DOCTYPE HTML >
	<html data-wf-site="5718896fb6f10eb45d8c7872" data-wf-page="571e1ada86c1049c4c1021f7">
		<head>
			<CFINCLUDE TEMPLATe="../_head.inc">
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-donateurs.inc">
	
  				<div class="w-container containerprincipal">
  					
	 				<div class="blocfondblanc" style="padding: 20px 0px 20px 0px;">
						
	 					<div class="containertyperapport">
							<div class="titretyperapport">
								<CFIF session.langue EQ "fr">
									<strong>IMPORT DE DONATEURS EN LOT</strong>
								<CFELSE>
									<strong>DONORS BATCH IMPORT</strong>
								</CFIF>
							</div>
        				</div>
	 					
						<div class="w-form">
							<CFIF session.langue EQ "fr">
		  						<cfform class="blocformulaireajouterdon" data-name="Gifts Form" ACTION="#file_name_fr#" id="dons-form" name="dons-form" METHOD="POST" ENCTYPE="multipart/form-data">
									En utilisant le gabarit Excel disponible ci-dessous, <br>vous pouvez effectuer un import de plusieurs donateurs &agrave; la fois.<BR> 
									Suivre les 3 &eacute;tapes.
            					<!--- POUR AFFICHER MISE EN GARDE --->
            					<CFIF NOT isDefined('Form.importDonateurs') AND Session.utilisateur.supraAdmin>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec" STYLE="margin-top:0px;">
												<div>Assurez-vous d'avoir s&eacute;lectionn&eacute; le bon organisme.</div>
											</div>
										</div>
								<!--- FORMULAIRE SOUMIS --->
								<CFELSEIF isDefined('Form.importDonateurs')>
									<!--- UN FICHIER A ETE TELECHARGE --->
									<CFIF len(Form.NouveauxDonateurs) GTE 6>
										<!--- AU MOINS UNE ERREUR --->
										<CFIF ArrayLen(Rejects) GTE 1>
											<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec">
												<div>Op&eacute;ration termin&eacute;e mais <CFOUTPUT>#ArrayLen(Rejects)#</CFOUTPUT> entr&eacute;e<CFIF ArrayLen(Rejects) EQ 1> a &eacute;t&eacute; rejet&eacute;e<CFELSE>s ont &eacute;t&eacute; rejet&eacute;es.</CFIF></div>
											</div>
										
											<div class="lignedetableau headertableau" STYLE="margin:0px;">
													<div class="itemligne" ><strong>Rang&eacute;e</strong></div>
													<div class="itemligne"><strong>Donn&eacute;es</strong></div>
													<div class="itemligne"><strong>Raison du rejet</strong></div>
												</div>
									
												<CFLOOP INDEX="row" FROM="1" TO="#ArrayLen(Rejects)#">
													<div class="lignedetableau">
														<CFOUTPUT>
														<div class="itemligne">#Rejects[row][1]#</div>
														<div class="itemligne">#Rejects[row][2]#</div>
														<div class="itemligne">#Rejects[row][3]#</div>
														</CFOUTPUT>
													</div>
												</CFLOOP>
											</div>
										<!--- PAS D'ERREUR --->
										<CFELSE>
											<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
												<div class="blocsucces">
													<div>Op&eacute;ration r&eacute;ussie</div>
												</div>
											</div>
										</CFIF>
									<CFELSE>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec">
												<div>Aucun fichier Excel n'a &eacute;t&eacute; s&eacute;lectionn&eacute;.</div>
											</div>
										</div>
									</CFIF>
								</CFIF>

            					<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									1&egrave;re &Eacute;TAPE<br>
	 									<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="button" value="Télécharger le gabarit Excel" onclick="window.location.href='/gabarits/gabarit_donateurs_FR.xlsx'"> 
	 								</div>
	 								<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									2&egrave;me &Eacute;TAPE<br><br>
	 									Entrer les donateurs dans le gabarit Excel et sauvegarder le document.
	 								</div>
            					
			 						<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							3&egrave;me &Eacute;TAPE<br>
			 							<input type="button" id="loadFileExcel" value="Récupérer le gabarit Excel" onclick="document.getElementById('NouveauxDonateurs').click();" class="w-button boutonvalider"/>
									<input type="file" style="display:none;" id="NouveauxDonateurs" name="NouveauxDonateurs"/>
										<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="importDonateurs" type="submit" value="Importer les donateurs dans DDR">	
									</div>
								</cfform>
							<CFELSE>
								<cfform class="blocformulaireajouterdon" data-name="Gifts Form" ACTION="#file_name_en#" id="dons-form" name="dons-form" METHOD="POST" ENCTYPE="multipart/form-data">
								Using the Excel template available on this page, <br>you can import multiple donors in one operation.<BR> 
									Follow the 3 steps.
            					<!--- POUR AFFICHER MISE EN GARDE --->
            					<CFIF NOT isDefined('Form.importDonateurs') AND Session.utilisateur.supraAdmin>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec" STYLE="margin-top:0px;">
												<div>Make sure you have selected the right organization.</div>
											</div>
										</div>
									<!--- FORMULAIRE SOUMIS --->
									<CFELSEIF isDefined('Form.importDonateurs')>
										<!--- UN FICHIER A ETE TELECHARGE --->
										<CFIF len(Form.NouveauxDonateurs) GTE 6>
											<!--- AU MOINS UNE ERREUR --->
											<CFIF ArrayLen(Rejects) GTE 1>
												<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
              									<div class="blocechec">
                									<div>Operation completed but <CFOUTPUT>#ArrayLen(Rejects)#</CFOUTPUT> <CFIF ArrayLen(Rejects) EQ 1>entry has been rejected<CFELSE>entries have been rejected.</CFIF></div>
              									</div>
            								
            									<div class="lignedetableau headertableau" STYLE="margin:0px;">
		 												<div class="itemligne" ><strong>Row</strong></div>
		 												<div class="itemligne"><strong>Entry</strong></div>
		 												<div class="itemligne"><strong>Reason of rejection</strong></div>
	  												</div>
            							
													<CFLOOP INDEX="row" FROM="1" TO="#ArrayLen(Rejects)#">
														<div class="lignedetableau">
															<CFOUTPUT>
															<div class="itemligne">#Rejects[row][1]#</div>
															<div class="itemligne">#Rejects[row][2]#</div>
															<div class="itemligne">#Rejects[row][3]#</div>
															</CFOUTPUT>
														</div>
													</CFLOOP>
												</div>
											<!--- PAS D'ERREUR --->
											<CFELSE>
												<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
													<div class="blocsucces">
														<div>Operation completed successfully</div>
													</div>
												</div>
											</CFIF>
										<CFELSE>
											<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
												<div class="blocechec">
													<div>No Excel file has been selected.</div>
												</div>
											</div>
										</CFIF>
									</CFIF>

            					<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									1st STEP<br>
	 									<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="button" value="Download the Excel Template" onclick="window.location.href='/gabarits/gabarit_donateurs_EN.xlsx'"> 
	 								</div>
	 								<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									2nd STEP<br><br>
	 									Enter donors in the Excel template and save the document.
	 								</div>
            					
			 						<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							3rd STEP<br>
			 							<input type="button" id="loadFileExcel" value="Browse your computer for the Excel template" onclick="document.getElementById('NouveauxDonateurs').click();" class="w-button boutonvalider"/>
									<input type="file" style="display:none;" id="NouveauxDonateurs" name="NouveauxDonateurs"/>
										<input class="w-button boutonvalider" data-wait="Pleas wait..." name="importDonateurs" type="submit" value="Import donors in DDR">	
									</div>
								</cfform>
							</CFIF>
	 					</div><!--- <div class="w-form"> --->
  					</div><!--- <div class="blocfondblanc"> --->
				</div><!--- <div class="w-container containerprincipal"> --->
			</div><!--- <div class="w-section sectioncontenuprincipal"> --->
			<CFINCLUDE TEMPLATe="../_footer.inc">
		
			<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
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