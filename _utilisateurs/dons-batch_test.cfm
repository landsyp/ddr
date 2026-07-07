<!--- EXCEL AVEC ENTETES--->
<!--- 	
		TEMPLATE FR					TEMPLATE EN			 
		1	Date don				1	Date of gift 			
		2	# Donateur				2	Donor #		
		3  # Compte					3 	Account #
		4  Montant					4	Amount
		5  Description				5	Description		
		6  Méthode paiement			6	Payment Method
		7  MethodDonID				7	MethodDonID
 --->
 <cfsetting RequestTimeout = "600">
<CFTRY>
	
	<CFSET VARIABLES.title_en = "DDR GIFTS IMPORT">
	<CFSET file_name_en = "#APPLICATION.Racine#/en/secure/gifts-batch-import-test">
	<CFSET VARIABLES.title_fr = "DDR IMPORT DE DONS">
	<CFSET file_name_fr = "#APPLICATION.Racine#/fr/secure/import-dons-lot-test">
	
	<CFParam name="organismeID" default="#Session.utilisateur.organismeID#">
	
	<cfset Session.message = "">
	<cfset Session.messageEchec = "">
	
	<!--- TELECHARGEMENT --->
	<CFIF isDefined('Form.importDons')>
		<CFIF len(Form.NouveauxDons) GT 6>
			
			<CFSET Rejects = ArrayNew(2)>
			<CFFILE ACTION="UPLOAD" FILEFIELD="NouveauxDons" DESTINATION="#Application.Path#\temp" NAMECONFLICT="OVERWRITE" >
			<cfset document1 = "#Application.Path#\temp\#file.serverfile#">
		
			<cfset document2 = "#APPLICATION.Path#\temp\nouveauxDons.#File.ClientFileExt#">
			
			<cffile action="COPY" source=#document1# destination=#document2#>
			
			<cffile action="DELETE" file=#document1#> 
			
			<cfspreadsheet action="read" src="#Application.Path#\temp\nouveauxDons.xlsx" query="excelquery" sheet="1" >
			
			<CFSET row =1>
			<CFSET reject = 1>
		
			<CFOUTPUT query="excelquery"  startrow="2"  maxrows="#excelquery.recordcount#"> 
		
				<!--- EVITER INSCRIPTION DE LIGNE VIDE --->
				<CFIF excelquery.col_1 NEQ "" OR excelquery.col_2 NEQ "" OR excelquery.col_3 NEQ "" OR excelquery.col_4 NEQ "" >
					<!--- #excelquery.col_1#, #excelquery.col_2#,#excelquery.col_3#,#excelquery.col_4#,#excelquery.col_5# --->
					<!--- SI UNE DONNEE MANQUANTE --->
					<CFIF excelquery.col_1 EQ "" OR excelquery.col_2 EQ "" OR excelquery.col_3 EQ "" OR excelquery.col_4 EQ "" >
						<!--- &nbsp;erreur<br> --->
						<CFSET Rejects[reject][1] = row >
							<CFSET Rejects[reject][2] = excelquery.col_1&"|"&excelquery.col_2&"|"&excelquery.col_3&"|"&excelquery.col_4&"|"&excelquery.col_5 >
							<CFIF session.langue EQ "fr">
								<CFSET Rejects[reject][3] = "Données manquantes pour ce don">
							<CFELSE>
								<CFSET Rejects[reject][3] = "Missing info for this gift">
							</CFIF>
							<CFSET reject++>
					<CFELSE><!--- 
						 ---><br>
						<cfinvoke component="#APPLICATION.cfcDons#" method = "donAjout" returnvariable ="did">
							<cfinvokeargument name="dateDon" value="#excelquery.col_1#">
							<cfinvokeargument name="description" value="#excelquery.col_5#">
							<cfinvokeargument name="montant" value="#excelquery.col_4#">
							<cfinvokeargument name="noCompte" value="#excelquery.col_3#">
							<cfinvokeargument name="numero" value="#excelquery.col_2#">
							<cfinvokeargument name="methodeDonID" value="#excelquery.col_7#">
							<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
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
            <style>
                /* Background overlay */
                .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0; top: 0;
                width: 100%; height: 100%;
                background: rgba(0,0,0,0.5);
                }

                /* Modal box */
                .modal-content {
                background: white;
                margin: 10% auto;
                padding: 20px;
                width: 600px;
                border-radius: 8px;
                text-align: center;
                }

                /* Close button */
                .close {
                float: right;
                cursor: pointer;
                font-size: 20px;
                }

                table {
                border-collapse: collapse;
                width: 100%;
                }

                tr:nth-child(even) {
                background-color: #f2f2f2;
                }

                tr:nth-child(odd) {
                background-color: #ffffff;
                }
            </style>
		</head>

		<body> 
	
			<CFINCLUDE TEMPLATe="_menu.inc">
			
			<CFINCLUDE TEMPLATe="_organisme.inc">
			
			<!--- <div class="w-section sectionsousheader">
						<div class="w-container containersousheader">
							<div class="wrappersousheader">
								<CFIF session.langue EQ "fr">
									<h3 class="headingbreadcrumb">
										<a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/fr/secure/accueil" style="color:#00b9ff;text-decoration:none;">Accueil</a> &gt; Dons &gt; Import de dons (excel)</h3>
								<CFELSE>
									<h3 class="headingbreadcrumb"><a href="<cfoutput>#APPLICATION.Racine#</cfoutput>/en/secure/home" style="color:#00b9ff;text-decoration:none;">Home</a> &gt; Gifts &gt; Gifts Batch Import (excel)</h3>
								</CFIF>
							</div>
						</div>
					</div> --->
	
			<div class="w-section sectioncontenuprincipal">
			
				<CFINCLUDE TEMPLATe="_sous-menu-dons.inc">
	
  				<div class="w-container containerprincipal">
  					
	 				<div class="blocfondblanc" style="padding: 20px 0px 20px 0px;">
						
	 					<div class="containertyperapport">
							<div class="titretyperapport">
								<CFIF session.langue EQ "fr">
									<strong>IMPORT DE DONS EN LOT<br>Suivre les 4 étapes</strong>
								<CFELSE>
									<strong>GIFTS BATCH IMPORT<br>Follow the 4 steps  </strong>
								</CFIF>
							</div>
        				</div>
	 					
						<div class="w-form">
							<CFIF session.langue EQ "fr">
		  						<cfform class="blocformulaireajouterdon" data-name="Gifts Form" ACTION="#file_name_fr#" id="dons-form" name="dons-form" METHOD="POST" ENCTYPE="multipart/form-data">
									<!--- En utilisant le gabarit Excel disponible ci-dessous, <br>vous pouvez effectuer un import de plusieurs dons &agrave; la fois.<BR>  --->
									<!--- Suivre les <strong>3 étapes</strong>. --->
            					<!--- POUR AFFICHER MISE EN GARDE --->
            					<CFIF NOT structKeyExists(Form, 'importDons') AND Session.utilisateur.supraAdmin>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec" STYLE="margin-top:0px;">
												<div>Assurez-vous d'avoir sélectionné le bon organisme.</div>
											</div>
										</div>
								<!--- FORMULAIRE SOUMIS --->
								<CFELSEIF StructKeyExists(Form, 'importDons')>
									<!--- UN FICHIER A ETE TELECHARGE --->
									<CFIF len(Form.NouveauxDons) GTE 6>
										<!--- AU MOINS UNE ERREUR --->
										<CFIF ArrayLen(Rejects) GTE 1>
											<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec">
												<div>Opération terminée mais <CFOUTPUT>#ArrayLen(Rejects)#</CFOUTPUT> entrée<CFIF ArrayLen(Rejects) EQ 1> a été rejetée<CFELSE>s ont été rejetées.</CFIF></div>
											</div>
										
											<div class="lignedetableau headertableau" STYLE="margin:0px;">
													<div class="itemligne" ><strong>Rangée</strong></div>
													<div class="itemligne"><strong>Données</strong></div>
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
													<div>Opération réussie</div>
												</div>
											</div>
										</CFIF>
									<CFELSE>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec">
												<div>Aucun fichier Excel n'a été sélectionné.</div>
											</div>
										</div>
									</CFIF>
								</CFIF>

            					<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									<strong>1ère ÉTAPE</strong><br>
	 									<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="button" value="Téléchargez le gabarit Excel" onclick="window.location.href='/gabarits/gabarit_dons2_FR.xlsx'"> 
                                        <br>
                                        <span style="color:red;"> <em><strong></strong><strong>ATTENTION</strong> : la colonne <strong>"Méthode de paiement"</strong> a été ajoutée au gabarit (2026-03-30)</em></span>
                                        <br>
                                        <a href="##" onclick="openModal()">Consultez la liste des valeurs de méthode de paiement reconnues par DDR2</a>
                                        <div id="myModal" class="modal">
                                            <div class="modal-content">
                                                <span class="close" onclick="closeModal()">&times;</span>
                                                <h3>Méthodes de paiement</h3>
                                                <TABLE ALIGN="center" STYLE="width: 500px; border: thin solid #224049 !important;">
                                                    
                                                    <tr><td>Comptant</td></tr>
                                                    <tr><td>Chèque</td></tr>
                                                    <tr><td>Carte de crédit</td></tr>
                                                    <tr><td>Virement bancaire</td></tr>
                                                    <tr><td>Prélèvement pré-autorisé</td></tr>
                                                    <tr><td>Interac</td></tr>
                                                    <tr><td>PaypPal</td></tr>
                                                    <tr><td>PayPal Giving Fund</td></tr>
                                                    <tr><td>Square</td></tr>
                                                    <tr><td>Stripe</td></tr>
                                                    <tr><td>CanaDon</td></tr>
                                                    <tr><td>Autre</td></tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
	 								<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									<strong>2ème ÉTAPE</strong><br>
	 									Entrer les dons dans le gabarit Excel et sauvegardez-le<br>
										<span style="color:red;"> <em>*** Ne pas modifier la structure du gabarit (ajout ou suppression de colonnes) ***</em></span>
	 								</div>
            					
			 						<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							<strong>3ème ÉTAPE</strong><br>
			 							<input type="button" id="loadFileExcel" value="Récupérer votre gabarit Excel sauvegardé" onclick="document.getElementById('NouveauxDons').click();" class="w-button boutonvalider"/>
									    <input type="file" style="display:none;" id="NouveauxDons" name="NouveauxDons"/>
										<!--- <input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="importDons" type="submit" value="Téléverser votre gabarit Excel dans DDR">	 --->
									</div>
                                    <div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							<strong>4ème ÉTAPE</strong><br>
			 							<!--- <input type="button" id="loadFileExcel" value="Récupérer votre gabarit Excel sauvegardé" onclick="document.getElementById('NouveauxDons').click();" class="w-button boutonvalider"/>
									    <input type="file" style="display:none;" id="NouveauxDons" name="NouveauxDons"/> --->
										<input class="w-button boutonvalider" data-wait="Veuillez patienter..." name="importDons" type="submit" value="Téléverser votre gabarit Excel dans DDR2">	
									</div>
								</cfform>
							<CFELSE>
								<cfform class="blocformulaireajouterdon" data-name="Gifts Form" ACTION="#file_name_en#" id="dons-form" name="dons-form" METHOD="POST" ENCTYPE="multipart/form-data">
									
            					<!--- POUR AFFICHER MISE EN GARDE --->
            					<CFIF NOT isDefined('Form.importDons') AND Session.utilisateur.supraAdmin>
										<div class="blocchamp blocchamppleinelargeur" STYLE="min-height:0px;">
											<div class="blocechec" STYLE="margin-top:0px;">
												<div>Make sure you have selected the right organization.</div>
											</div>
										</div>
									<!--- FORMULAIRE SOUMIS --->
									<CFELSEIF isDefined('Form.importDons')>
										<!--- UN FICHIER A ETE TELECHARGE --->
										<CFIF len(Form.NouveauxDons) GTE 6>
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
	 									<strong>1st STEP</strong><br>
	 									<input class="w-button boutonvalider" data-wait="Please wait..." name="ajout" type="button" value="Download the Excel Template" onclick="window.location.href='/gabarits/gabarit_dons2_EN.xlsx'"> 
                                        <br>
                                        <span style="color:red;"> <em><strong></strong><strong>ATTENTION</strong> : column <strong>"Payment method"</strong> has been added to template (2026-03-30)</em></span>
                                        <br>
                                        <a href="##" onclick="openModal()">View the list of payment method values supported by DDR2</a>
                                        <div id="myModal" class="modal">
                                            <div class="modal-content">
                                                <span class="close" onclick="closeModal()">&times;</span>
                                                <h3>Payment Method</h3>
                                                <TABLE ALIGN="center" STYLE="width: 500px; border: thin solid #224049 !important;">
                                                    
                                                    <tr><td>Cash</td></tr>
                                                    <tr><td>Check</td></tr>
                                                    <tr><td>Credit Card</td></tr>
                                                    <tr><td>Bank transfer</td></tr>
                                                    <tr><td>Pre-authorized debit</td></tr>
                                                    <tr><td>Interac</td></tr>
                                                    <tr><td>PaypPal</td></tr>
                                                    <tr><td>PayPal Giving Fund</td></tr>
                                                    <tr><td>Square</td></tr>
                                                    <tr><td>Stripe</td></tr>
                                                    <tr><td>CanaDon</td></tr>
                                                    <tr><td>Other</td></tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
	 								<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
	 									<strong>2nd STEP</strong><br>
	 									Enter gifts in the Excel template and save the document.<br>
										<span style="color:red;"> Don't modify the structure of the template (add or remove columns)</span>
	 								</div>
			 						<div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							<strong>3rd STEP</strong><br>
			 							<input type="button" id="loadFileExcel" value="Browse your computer for the Excel template saved document" onclick="document.getElementById('NouveauxDons').click();" class="w-button boutonvalider"/>
									    <input type="file" style="display:none;" id="NouveauxDons" name="NouveauxDons"/>
										<!--- <input class="w-button boutonvalider" data-wait="Pleas wait..." name="importDons" type="submit" value="Importer gifts in DDR">	 --->
									</div>
                                    <div class="blocchamp blocchamppleinelargeur" style="border-style: solid;border-width: 1px;border-color: rgba(55, 55, 55, .15);">
			 							<strong>4rth STEP</strong><br>
			 							<!--- <input type="button" id="loadFileExcel" value="Browse your computer for the Excel template" onclick="document.getElementById('NouveauxDons').click();" class="w-button boutonvalider"/>
									    <input type="file" style="display:none;" id="NouveauxDons" name="NouveauxDons"/> --->
										<input class="w-button boutonvalider" data-wait="Pleas wait..." name="importDons" type="submit" value="Upload gifts in DDR2">	
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

            <script>
                function openModal() {
                    document.getElementById("myModal").style.display = "block";
                }

                function closeModal() {
                    document.getElementById("myModal").style.display = "none";
                }

                // Close when clicking outside
                window.onclick = function(event) {
                    const modal = document.getElementById("myModal");
                    if (event.target === modal) {
                        modal.style.display = "none";
                    }
                }
            </script>
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