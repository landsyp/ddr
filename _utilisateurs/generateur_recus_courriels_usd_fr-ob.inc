<!--- ################################################################# --->				
<!--- 						CFHTMLTOPDF DIV							--->						
<!--- ################################################################# --->

                <cfoutput query="ListeDonateurs" >
					<cfset recuinfo = ListeDonateurs.donateurID & "-" & dateDebut & "-" & dateFin>
					<cfset recupath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "..\temp\r-" & recuinfo & "-g-" & envoitimestamp & ".pdf">
                    <cfhtmltopdf 
                        pagetype="legal" 
                        orientation="portrait" 
                        unit="cm" 
                        saveAsName="recus_impot"
                        marginLeft="0" 
                        margintop="0" 
                        marginright="0"
                        marginbottom="0"
						destination = "#recupath#">
                        
                        <style>
                            div.verySmall {
                            font: 7pt Arial;
                            line-height: 12pt;
                            }
                            div.small {
                            font: 8pt Arial;
                            line-height: 10pt;
                            }
                            div.text {
                            font: 10pt Arial;
                            line-height: 14pt;
                            }
                            div.title {
                            font: 11pt Arial;
                            line-height: 14pt;
                            }
                            div.number {
                            font: 15pt Arial;
                            }
                        </style>
                        
                        <!--- <CFSET topValue = 0> --->
                        <cfset top = 0><!--- PREMIERE PAGE TOP:0MM; --->
						<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusMontantDates" returnvariable ="montantTotal">
							<cfinvokeargument name="dateDebut" value="#dateDebut#">
							<cfinvokeargument name="dateFin" value="#dateFin#">
							<cfinvokeargument name="donateurID" value="#donateurID#">
						</cfinvoke>	
						<!--- <div style="position:relative; top:#topValue#mm; left:0mm; width:216mm;height:347mm;border-top:solid 1px black;border-bottom:solid 1px red;"> --->
						<div style="position:relative; top:#top#mm; left:0mm; width:216mm;height:348mm;">
							<!--- RECU DONATEUR --->
							<div  class="title" style="position:absolute; top:5mm; left:5mm;">
								<!--- RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Donateur)<br> --->
							</div>
							<div  class="text" style="position:absolute; top:10mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:5mm; right:8mm;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png" >
							</div>
							<!--- <div  class="number" style="position:absolute; top:9mm; right:11mm;color:red;">
								12738
							</div> --->
							<div  class="title" style="position:absolute; top:37mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:37mm; right:8mm;text-align:right;">
								<!--- max 16 caracteres : 0 000 000,00 $ US --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#</strong>&nbsp;US<br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:52mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:62mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:50mm; right:8mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:75mm; right:8mm;text-align:right;">
								Signataire autoris&eacute; : #organisme.responsable#<br>
								No Enrg #organisme.enregistrement# USA #organisme.enregistrement_us#
							</div>
							<div  class="small" style="position:absolute; top:92mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:89mm; right:8mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<!--- <div style="position:absolute; top:98.6mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div>  --->
							<!--- RECU PROVINCIAL --->
							<div  class="title" style="position:absolute; top:106mm; left:5mm;">
								<!--- RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Provincial) ---><br>
							</div>
							<div  class="text" style="position:absolute; top:111mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:106mm; right:8mm;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<!--- <div  class="number" style="position:absolute; top:110mm; right:11mm;color:red;">
								12738
							</div> --->
							<div  class="title" style="position:absolute; top:130mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:130mm; right:8mm;text-align:right;">
								<!--- max 16 caracteres : 0 000 000,00 $ US --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#&nbsp;US</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:140mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:150mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:146mm; right:8mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:163mm; right:8mm;text-align:right;">
								Signataire autoris&eacute; : #organisme.responsable#<br>
								No Enrg #organisme.enregistrement# USA #organisme.enregistrement_us#
							</div>
							<div  class="small" style="position:absolute; top:176mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:175mm; right:8mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<!--- <div style="position:absolute; top:182.5mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div> --->
							<!--- RECU FEDERAL --->
							<div  class="title" style="position:absolute; top:188mm; left:5mm;">
								<!--- RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (F&eacute;d&eacute;ral) ---><br>
							</div>
							<div  class="text" style="position:absolute; top:193mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:188mm; right:8mm;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<!--- <div  class="number" style="position:absolute; top:190mm; right:11mm;color:red;">
								12738
							</div> --->
							<div  class="title" style="position:absolute; top:210mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:210mm; right:8mm;text-align:right;">
								<!--- max 16 caracteres : 0 000 000,00 $ US--->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#&nbsp;US</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:223mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:233mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:228mm; right:8mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:245mm; right:8mm;text-align:right;">
								Signataire autoris&eacute; : #organisme.responsable#<br>
								No Enrg #organisme.enregistrement# USA #organisme.enregistrement_us#
							</div>
							<div  class="small" style="position:absolute; top:259mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:256mm; right:8mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons 
							</div>
							<!--- <div style="position:absolute; top:263mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div> --->
							<!--- RECU ORGANISME --->
							<div  class="title" style="position:absolute; top:270mm; left:5mm;">
								<!--- RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Organisme) ---><br>
							</div>
							<div  class="text" style="position:absolute; top:275mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:268mm; right:8mm;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<!--- <div  class="number" style="position:absolute; top:271mm; right:11mm;color:red;">
								12738
							</div> --->
							<div  class="title" style="position:absolute; top:291mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:291mm; right:8mm;text-align:right;">
								<!--- max 16 caracteres : 0 000 000,00 $ US --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#&nbsp;US</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:302mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:312mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:309mm; right:8mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:326mm; right:8mm;text-align:right;">
								Signataire autoris&eacute; : #organisme.responsable#<br>
								No Enrg #organisme.enregistrement# USA #organisme.enregistrement_us#
							</div>
							<div  class="small" style="position:absolute; top:340mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:338mm; right:8mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
						</div>
						<cfhtmltopdfitem type="pagebreak" />
						
						<!--- <CFSET topValue = topValue+359.045> --->
						<CFSET top=2>
                    </cfhtmltopdf>
					<cfset mailsubject = "Reçu d'impôts - " & ListeDonateurs.prenom & " " & ListeDonateurs.nom & " - " & dateDebut & " à " & dateFin>

					<cfmail attributeCollection="#APPLICATION.emailAttributeCollection#" to="#ListeDonateurs.courriel#" subject="#mailsubject#" type="text/html">
						<cfmailparam file="#recupath#" disposition="attachment" type="application/PDF" remove="true">
						<cfmailparam name="envoicode" value="#envoitimestamp#">
						<cfmailparam name="envoidonateurid" value="#ListeDonateurs.donateurID#">
						#messagecourriel#
					</cfmail>
                </cfoutput>

<!--- ################################################################# --->				
<!--- 						CFDOCUMENT DIV								--->
<!--- GENERATION DU PDF BEAUCOUP TROP LENT								--->						
<!--- ################################################################# --->


				<!--- 
				<cfdocument 
					format="pdf" 
					pagetype="legal" 
					orientation="portrait" 
					fontEmbed="false" 
					unit="cm" 
					localUrl="true" 
					saveAsName="recus_impot"
					marginLeft="0" 
					margintop="0" 
					marginright="0"
					marginbottom="0">
				
					<style>
						div.verySmall {
						  font: 7pt Arial;
						  line-height: 12pt;
						}
						div.small {
						  font: 8pt Arial;
						  line-height: 10pt;
						}
						div.text {
						  font: 10pt Arial;
						  line-height: 14pt;
						}
						div.title {
						  font: 11pt Arial;
						  line-height: 14pt;
						}
						div.number {
						  font: 18pt Arial;
						}
					</style>
					<CFSET topValue = 0>
					<cfoutput query="ListeDonateurs" maxrows="10">
						<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusMontantDates" returnvariable ="montantTotal">
							<cfinvokeargument name="dateDebut" value="#dateDebut#">
							<cfinvokeargument name="dateFin" value="#dateFin#">
							<cfinvokeargument name="donateurID" value="#donateurID#">
						</cfinvoke>	
					
						<div style="position:relative; top:#topValue#mm; left:0mm; width:216mm;">
							<!--- RECU DONATEUR --->
							<div  class="title" style="position:absolute; top:5mm; left:5mm;">
								RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Donateur)<br>
							</div>
							<div  class="text" style="position:absolute; top:10mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:5mm; left:177mm;text-align:right;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  >
							</div>
							<div  class="number" style="position:absolute; top:9mm; right:11mm;color:red;">
								12738
							</div>
							<div  class="title" style="position:absolute; top:37mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:37mm; right:5mm;text-align:right;">
								<!--- max 16 caracteres : 000 000 000,00 $ --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:52mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:62mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:50mm; right:5mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:75mm; right:5mm;text-align:right;">
								Responsable : #organisme.responsable#<br>
								No Enrg : #organisme.enregistrement#
							</div>
							<div  class="small" style="position:absolute; top:92mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:89mm; right:5mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<div style="position:absolute; top:98.6mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div> 
							<!--- RECU PROVINCIAL --->
							<div  class="title" style="position:absolute; top:105mm; left:5mm;">
								RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Provincial)<br>
							</div>
							<div  class="text" style="position:absolute; top:110mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:106mm; left:177mm;text-align:right;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<div  class="number" style="position:absolute; top:110mm; right:11mm;color:red;">
								12738
							</div>
							<div  class="title" style="position:absolute; top:132mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:132mm; right:5mm;text-align:right;">
								<!--- max 16 caracteres : 000 000 000,00 $ --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:142mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:152mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:148mm; right:5mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:165mm; right:5mm;text-align:right;">
								Responsable : #organisme.responsable#<br>
								No Enrg : #organisme.enregistrement#
							</div>
							<div  class="small" style="position:absolute; top:178mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:177mm; right:5mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<div style="position:absolute; top:182.5mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div>
							<!--- RECU FEDERAL --->
							<div  class="title" style="position:absolute; top:188mm; left:5mm;">
								RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (F&eacute;d&eacute;ral)<br>
							</div>
							<div  class="text" style="position:absolute; top:193mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:188mm; left:177mm;text-align:right;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<div  class="number" style="position:absolute; top:191mm; right:11mm;color:red;">
								12738
							</div>
							<div  class="title" style="position:absolute; top:211mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:211mm; right:5mm;text-align:right;">
								<!--- max 16 caracteres : 000 000 000,00 $ --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:224mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:234mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:229mm; right:5mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:246mm; right:5mm;text-align:right;">
								Responsable : #organisme.responsable#<br>
								No Enrg : #organisme.enregistrement#
							</div>
							<div  class="small" style="position:absolute; top:260mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:257mm; right:5mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<div style="position:absolute; top:263.5mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div>
							<!--- RECU ORGANISME --->
<div  class="title" style="position:absolute; top:270mm; left:5mm;">
								RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (F&eacute;d&eacute;ral)<br>
							</div>
							<div  class="text" style="position:absolute; top:275mm; left:5mm;">
								<strong>#organisme.organisme#</strong><br>
								#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
								#organisme.telephone#
							</div>
							<div  class="text" style="position:absolute; top:270mm; left:177mm;text-align:right;">
								<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
							</div>
							<div  class="number" style="position:absolute; top:273mm; right:11mm;color:red;">
								12738
							</div>
							<div  class="title" style="position:absolute; top:293mm; right:45mm;text-align:right;">
								MONTANT TOTAL DES DONS :<br>
								POUR L'ANN&Eacute;E : 
							</div>
							<div  class="title" style="position:absolute; top:293mm; right:5mm;text-align:right;">
								<!--- max 16 caracteres : 000 000 000,00 $ --->
								<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
								<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montantTotal)#</strong><br>
								<strong>#annee#</strong>
							</div>
							<div  class="small" style="position:absolute; top:304mm; left:20mm;font-weight:bold;">
								## de donateur : #numero#
							</div>
							<div  class="text" style="position:absolute; top:314mm; left:20mm;">
								#prenom# #nom#<br>
								#adresse#<br>
								#ville# (#province#)<br>
								#code_postal# 
							</div>
							<div  class="text" style="position:absolute; top:311mm; right:5mm;">
								<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
									<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
								</CFIF> 
							</div>
							<div  class="text" style="position:absolute; top:328mm; right:5mm;text-align:right;">
								Responsable : #organisme.responsable#<br>
								No Enrg : #organisme.enregistrement#
							</div>
							<div  class="small" style="position:absolute; top:342mm; left:5mm;">
								Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#
							</div>
							<div  class="small" style="position:absolute; top:340mm; right:5mm;text-align:right;">
								Agence du revenu du Canada<br>
								canada.ca/organismes-bienfaisance-dons
							</div>
							<!--- <div style="position:absolute; top:182.5mm; left:0mm; width:216mm;">
								<hr style="border: 0; height: 1px; background: ##333;">
							</div> --->
						</div>
						<!--- <div style="page-break-before:always">&nbsp;</div>  --->
						
						<!--- 363.5 --->
						<CFSET topValue = topValue+363.18>
						
					</cfoutput>
						
				</cfdocument>
				 --->
				
				
<!--- ################################################################# --->				
<!--- 						CFDOCUMENT TABLE							--->		
<!--- 	DIFFICULTE A CONTROLER L'ALIGNEMENT AVEC LA TABLE				--->				
<!--- ################################################################# --->					
				<!--- 	
				<cfdocument 
					format="pdf" 
					pagetype="legal" 
					orientation="portrait" 
					fontEmbed="true" 
					unit="in" 
					localUrl="true" 
					saveAsName="recus_impot"
					marginLeft="0" 
					margintop="0" 
					marginright="0"
					marginbottom="0">
			
					<cfoutput query="ListeDonateurs" >
						<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusMontantDates" returnvariable ="montantTotal">
							<cfinvokeargument name="dateDebut" value="#dateDebut#">
							<cfinvokeargument name="dateFin" value="#dateFin#">
							<cfinvokeargument name="donateurID" value="#donateurID#">
						</cfinvoke>	
						<!--- largeur: 7.875" hauteur: 4" --->
						<CFIF page GT 1><br STYLE="line-height:75%"></CFIF>
						<table cellpadding="0" cellspacing="0" width="100%" border=0 >
							<tr>
								<td rowspan="2"  colspan="3" valign="top" STYLE="line-height:140%;">
									RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Donateur)<br>
									<div STYLE="font-size: 85%;font-weight:bold;">#organisme.organisme#</div>
									<div STYLE="font-size: 85%;">#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
									#organisme.telephone#<br><br></div>
								</td>
								<td  rowspan="2">&nbsp;</td>
								<td STYLE="vertical-align:top;text-align:right;" >
									<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  >
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;</td>
								<td STYLE="width:300px;">&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;width:300px;font-size:95%;">
									MONTANT TOTAL DES DONS :<br>
									POUR L'ANN&Eacute;E :
								</td>
								<td STYLE="text-align:right;width:144px;">
									<!--- max 16 caracteres : 000 000 000,00 $ --->
									<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
									<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><b>#LSCurrencyFormat(montantTotal)#</b><br>
									<b>#annee#</b>
								</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;&nbsp;</td>
								<td colspan="2"><br>
									<div STYLE="font-size: 80%;font-weight:bold;">## de donateur : #numero#</div><br>
									<div STYLE="font-size: 100%;">
										#prenom# #nom#<br>
										#adresse#<br>
										#ville# (#province#)<br>
										#code_postal# <br><br>
									</div>
								</td>
								<td colspan="2" STYLE="text-align:right;vertical-align:top;"> <br><br>
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
								
										<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
									</CFIF>
									<div STYLE="font-size: 90%;line-height:140%;">Responsable : #organisme.responsable#<br>
									No Enrg : #organisme.enregistrement#</div>
								</td>
							</tr>
							<tr>
								<td colspan="2" STYLE="font-size: 75%;">
									<div STYLE="padding-top: 10px;">Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#</div>
								</td>
								<td >&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;vertical-align:top;font-size: 70%;">
									<div STYLE="padding-top: 10px;">Agence du revenu du Canada<br>
									canada.ca/organismes-bienfaisance-dons</div>
								</td>
							</tr>
						</table>
						<br>
						<!--- largeur: 7.875" hauteur: 3.25" --->
						<table cellpadding="0" cellspacing="0" width="100%" border=0 >
							<tr>
								<td rowspan="2"  colspan="3" valign="top" STYLE="line-height:140%;">
									RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Provincial)<br>
									<div STYLE="font-size: 85%;font-weight:bold;">#organisme.organisme#</div>
									<div STYLE="font-size: 85%;">#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
									#organisme.telephone#<br></div>
								</td>
								<td  rowspan="2">&nbsp;</td>
								<td STYLE="vertical-align:top;text-align:right;" >
									<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  >
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;</td>
								<td STYLE="width:300px;">&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;width:300px;font-size:95%;">
									MONTANT TOTAL DES DONS :<br>
									POUR L'ANN&Eacute;E :
								</td>
								<td STYLE="text-align:right;width:144px;">
									<!--- max 16 caracteres : 000 000 000,00 $ --->
									<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
									<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><b>#LSCurrencyFormat(montantTotal)#</b><br>
									<b>#annee#</b>
								</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;&nbsp;</td>
								<td colspan="2">
									<div STYLE="font-size: 80%;font-weight:bold;">## de donateur : #numero#</div><br>
									<div STYLE="font-size: 100%;">
										#prenom# #nom#<br>
										#adresse#<br>
										#ville# (#province#)<br>
										#code_postal# <br><br>
									</div>
								</td>
								<td colspan="2" STYLE="text-align:right;vertical-align:top;">
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
								
										<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
									</CFIF>
									<div STYLE="font-size: 90%;line-height:140%;">Responsable : #organisme.responsable#<br>
									No Enrg : #organisme.enregistrement#</div>
								</td>
							</tr>
							<tr>
								<td colspan="2" STYLE="font-size: 75%;">
									<div STYLE="padding-top: 2px;">Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#</div>
								</td>
								<td >&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;font-size: 70%;">
									<div STYLE="padding-top: 2px;">Agence du revenu du Canada<br>
									canada.ca/organismes-bienfaisance-dons</div>
								</td>
							</tr>
						</table>
						<br>
						<!--- largeur: 7.875" hauteur: 3.125" --->
						<table cellpadding="0" cellspacing="0" width="100%" border=0 >
							<tr>
								<td rowspan="2"  colspan="3" valign="top" STYLE="line-height:140%;">
									RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (F&eacute;d&eacute;ral)<br>
									<div STYLE="font-size: 85%;font-weight:bold;">#organisme.organisme#</div>
									<div STYLE="font-size: 85%;">#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
									#organisme.telephone#<br></div>
								</td>
								<td  rowspan="2">&nbsp;</td>
								<td STYLE="vertical-align:top;text-align:right;" >
									<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  >
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;</td>
								<td STYLE="width:300px;">&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;width:300px;font-size:95%;">
									MONTANT TOTAL DES DONS :<br>
									POUR L'ANN&Eacute;E :
								</td>
								<td STYLE="text-align:right;width:144px;">
									<!--- max 16 caracteres : 000 000 000,00 $ --->
									<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
									<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><b>#LSCurrencyFormat(montantTotal)#</b><br>
									<b>#annee#</b>
								</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;&nbsp;</td>
								<td colspan="2">
									<div STYLE="font-size: 80%;font-weight:bold;">## de donateur : #numero#</div><br>
									<div STYLE="font-size: 100%;">
										#prenom# #nom#<br>
										#adresse#<br>
										#ville# (#province#)<br>
										#code_postal# <br>
									</div>
								</td>
								<td colspan="2" STYLE="text-align:right;vertical-align:top;">
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
								
										<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
									</CFIF>
									<div STYLE="font-size: 90%;line-height:140%;">Responsable : #organisme.responsable#<br>
									No Enrg : #organisme.enregistrement#</div>
								</td>
							</tr>
							<tr>
								<td colspan="2" STYLE="font-size: 75%;">
									<div STYLE="padding-top: 2px;">Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#</div>
								</td>
								<td >&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;font-size: 70%;">
									<div STYLE="padding-top: 2px;"><br>Agence du revenu du Canada<br>
									canada.ca/organismes-bienfaisance-dons</div>
								</td>
							</tr>
						</table>
						<br>
						<!--- largeur: 7.875" hauteur: 3.625" --->
						<table cellpadding="0" cellspacing="0" width="100%" border=0 >
							<tr>
								<td rowspan="2"  colspan="3" valign="top" STYLE="line-height:140%;">
									RE&Ccedil;U OFFICIEL AUX FINS DE L'IMP&Ocirc;T SUR LE REVENU (Organisme)<br>
									<div STYLE="font-size: 85%;font-weight:bold;">#organisme.organisme#</div>
									<div STYLE="font-size: 85%;">#organisme.adresse#, #organisme.ville# (#organisme.province#) #organisme.code_postal#<br>
									#organisme.telephone#<br></div>
								</td>
								<td  rowspan="2">&nbsp;</td>
								<td STYLE="vertical-align:top;text-align:right;" >
									<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  >
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;</td>
								<td STYLE="width:300px;">&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;width:300px;font-size:95%;">
									MONTANT TOTAL DES DONS :<br>
									POUR L'ANN&Eacute;E :
								</td>
								<td STYLE="text-align:right;width:144px;">
									<!--- max 16 caracteres : 000 000 000,00 $ --->
									<cfset asterisques = 16-Len(LSCurrencyFormat(montantTotal))>
									<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><b>#LSCurrencyFormat(montantTotal)#</b><br>
									<b>#annee#</b>
								</td>
							</tr>
							<tr>
								<td STYLE="width:60px;">&nbsp;&nbsp;</td>
								<td colspan="2">
									<div STYLE="font-size: 80%;font-weight:bold;">## de donateur : #numero#</div><br>
									<div STYLE="font-size: 100%;">
										#prenom# #nom#<br>
										#adresse#<br>
										#ville# (#province#)<br>
										#code_postal# <br><br>
									</div>
								</td>
								<td colspan="2" STYLE="text-align:right;vertical-align:top;">
									<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
								
										<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
									</CFIF>
									<div STYLE="font-size: 90%;line-height:140%;">Responsable : #organisme.responsable#<br>
									No Enrg : #organisme.enregistrement#</div>
								</td>
							</tr>
							<tr>
								<td colspan="2" STYLE="font-size: 75%;">
									<div STYLE="padding-top: 0px;">Imprim&eacute; le : #DateFormat(Now(),"yyyy-mm-dd")#</div>
								</td>
								<td >&nbsp;</td>
								<td colspan="2" STYLE="text-align:right;font-size: 70%;">
									<div STYLE="padding-top: 0px;">Agence du revenu du Canada<br>
									canada.ca/organismes-bienfaisance-dons</div>
								</td>
							</tr>
						</table>
						<!--- <cfdocumentitem type="pagebreak" /> --->
						<cfset page++>
					</cfoutput>
				</cfdocument>
				--->