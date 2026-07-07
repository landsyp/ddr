<!--- ################################################################# --->				
<!--- 						CFHTMLTOPDF DIV							--->						
<!--- ################################################################# --->
		
		<cfoutput query="renvoiInfo">
			<cfset recuinfo = donateurID & "-" & dateDebut & "-" & dateFin>
			<cfset recupath = GetDirectoryFromPath(GetCurrentTemplatePath()) & "..\temp\r-" & recuinfo & "-g-" & envoitimestamp & ".pdf">
			<cfhtmltopdf 
				pagetype="letter" 
				orientation="portrait" 
				unit="cm" 
				saveAsName="tax_receipt"
				marginLeft="0" 
				margintop="0" 
				marginright="0"
				marginbottom="0"
				destination = "#recupath#"
				>
				
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
				
				<cfset top = 0><!--- PREMIERE PAGE TOP:0MM; --->
				<div style="position:relative; top:#top#mm; left:0mm; width:216mm;height:279mm;">
					<!--- RECU DONATEUR --->
					<div  class="title" style="position:absolute; top:5mm; left:5mm;">
						OFFICIAL RECEIPT FOR INCOME TAX PURPOSES (Donor)<br>
					</div>
					<div  class="text" style="position:absolute; top:10mm; left:5mm;">
						<strong>#encodeForHTML(organisme.organisme)#</strong><br>
						#encodeForHTML(organisme.adresse)#, #encodeForHTML(organisme.ville)# (#organisme.province#) #organisme.code_postal#<br>
						#organisme.telephone#
					</div>
					<div  class="text" style="position:absolute; top:5mm; right:8mm;">
						<img src="file:///#APPLICATION.Path#\images\NoRecu.png" >
					</div>
					<div  class="number" style="position:absolute; top:9mm; right:11mm;color:red;">
						e-#noRecu#
					</div>
					<div  class="title" style="position:absolute; top:37mm; right:45mm;text-align:right;">
						TOTAL GIFTS AMOUNT:<br>
						FOR THE YEAR: 
					</div>
					<div  class="title" style="position:absolute; top:37mm; right:8mm;text-align:right;">
						<!--- max 16 caracteres : 000 000 000,00 $ --->
						<cfset asterisques = 16-Len(LSCurrencyFormat(montant))>
						<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montant)#</strong><br>
						<strong>#annee#</strong>
					</div>
					<div  class="small" style="position:absolute; top:52mm; left:20mm;font-weight:bold;">
						Donor ##: #numero#
					</div>
					<div  class="text" style="position:absolute; top:62mm; left:20mm;">
						#encodeForHTML(prenom)# #encodeForHTML(nom)#<br>
						#encodeForHTML(adresse)#<br>
						#encodeForHTML(ville)# (#province#)<br>
						#code_postal# 
					</div>
					<div  class="text" style="position:absolute; top:50mm; right:8mm;">
						<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
							<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
						</CFIF> 
					</div>
					<div  class="text" style="position:absolute; top:75mm; right:8mm;text-align:right;">
						Person in charge: #encodeForHTML(organisme.responsable)#<br>
						Reg No: #organisme.enregistrement#
					</div>
					<div  class="small" style="position:absolute; top:92mm; left:5mm;">
						Generated on #DateFormat(Now(),"yyyy-mm-dd")# - Issued in #encodeForHTML(organisme.ville)#, #organisme.province#
					</div>
					<div  class="small" style="position:absolute; top:89mm; right:8mm;text-align:right;">
						Canada Revenue Agency<br>
						canada.ca/charities-giving
					</div>
					<div style="position:absolute; top:98.6mm; left:0mm; width:216mm;">
						<!--- <hr style="border: 0; height: 1px; background: ##333;"> --->
						<hr style="border: 1px dashed ##333;">
					</div>
					<!--- RECU PROVINCIAL --->
					<div  class="title" style="position:absolute; top:106mm; left:5mm;">
						OFFICIAL RECEIPT FOR INCOME TAX PURPOSES (Provincial)<br>
					</div>
					<div  class="text" style="position:absolute; top:111mm; left:5mm;">
						<strong>#encodeForHTML(organisme.organisme)#</strong><br>
						#encodeForHTML(organisme.adresse)#, #encodeForHTML(organisme.ville)# (#organisme.province#) #organisme.code_postal#<br>
						#organisme.telephone#
					</div>
					<div  class="text" style="position:absolute; top:106mm; right:8mm;">
						<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
					</div>
					<div  class="number" style="position:absolute; top:110mm; right:11mm;color:red;">
						e-#noRecu#
					</div>
					<div  class="title" style="position:absolute; top:130mm; right:45mm;text-align:right;">
						TOTAL GIFTS AMOUNT:<br>
						FOR THE YEAR: 
					</div>
					<div  class="title" style="position:absolute; top:130mm; right:8mm;text-align:right;">
						<!--- max 16 caracteres : 000 000 000,00 $ --->
						<cfset asterisques = 16-Len(LSCurrencyFormat(montant))>
						<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montant)#</strong><br>
						<strong>#annee#</strong>
					</div>
					<div  class="small" style="position:absolute; top:140mm; left:20mm;font-weight:bold;">
						Donor ##: #numero#
					</div>
					<div  class="text" style="position:absolute; top:150mm; left:20mm;">
						#encodeForHTML(prenom)# #encodeForHTML(nom)#<br>
						#encodeForHTML(adresse)#<br>
						#encodeForHTML(ville)# (#province#)<br>
						#code_postal# 
					</div>
					<div  class="text" style="position:absolute; top:146mm; right:8mm;">
						<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
							<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
						</CFIF> 
					</div>
					<div  class="text" style="position:absolute; top:163mm; right:8mm;text-align:right;">
						Person in charge: #encodeForHTML(organisme.responsable)#<br>
						Reg No: #organisme.enregistrement#
					</div>
					<div  class="small" style="position:absolute; top:176mm; left:5mm;">
						Generated on #DateFormat(Now(),"yyyy-mm-dd")# - Issued in #encodeForHTML(organisme.ville)#, #organisme.province#
					</div>
					<div  class="small" style="position:absolute; top:175mm; right:8mm;text-align:right;">
						Canada Revenue Agency<br>
						canada.ca/charities-giving
					</div>
					<div style="position:absolute; top:182.5mm; left:0mm; width:216mm;">
						<!--- <hr style="border: 0; height: 1px; background: ##333;"> --->
						<hr style="border: 1px dashed ##333;">
					</div>
					<!--- RECU FEDERAL --->
					<div  class="title" style="position:absolute; top:188mm; left:5mm;">
						OFFICIAL RECEIPT FOR INCOME TAX PURPOSES (Federal)<br>
					</div>
					<div  class="text" style="position:absolute; top:193mm; left:5mm;">
						<strong>#encodeForHTML(organisme.organisme)#</strong><br>
						#encodeForHTML(organisme.adresse)#, #encodeForHTML(organisme.ville)# (#organisme.province#) #organisme.code_postal#<br>
						#organisme.telephone#
					</div>
					<div  class="text" style="position:absolute; top:188mm; right:8mm;">
						<img src="file:///#APPLICATION.Path#\images\NoRecu.png"  style="height:56px;">
					</div>
					<div  class="number" style="position:absolute; top:190mm; right:11mm;color:red;">
						e-#noRecu#
					</div>
					<div  class="title" style="position:absolute; top:210mm; right:45mm;text-align:right;">
						TOTAL GIFTS AMOUNT:<br>
						FOR THE YEAR: 
					</div>
					<div  class="title" style="position:absolute; top:210mm; right:8mm;text-align:right;">
						<!--- max 16 caracteres : 000 000 000,00 $ --->
						<cfset asterisques = 16-Len(LSCurrencyFormat(montant))>
						<cfloop index="etoiles" from="1" to="#asterisques#">*</cfloop><strong>#LSCurrencyFormat(montant)#</strong><br>
						<strong>#annee#</strong>
					</div>
					<div  class="small" style="position:absolute; top:223mm; left:20mm;font-weight:bold;">
						Donor ##: #numero#
					</div>
					<div  class="text" style="position:absolute; top:233mm; left:20mm;">
						#encodeForHTML(prenom)# #encodeForHTML(nom)#<br>
						#encodeForHTML(adresse)#<br>
						#encodeForHTML(ville)# (#province#)<br>
						#code_postal# 
					</div>
					<div  class="text" style="position:absolute; top:228mm; right:8mm;">
						<CFIF FileExists('#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#')>
							<img src="file:///#APPLICATION.Path#\_utilisateurs\signatures\#Session.utilisateur.organismeID#.#organisme.signatureExt#" height="50" ><br><br>
						</CFIF> 
					</div>
					<div  class="text" style="position:absolute; top:245mm; right:8mm;text-align:right;">
						Person in charge: #encodeForHTML(organisme.responsable)#<br>
						Reg No: #organisme.enregistrement#
					</div>
					<div  class="small" style="position:absolute; top:259mm; left:5mm;">
						Generated on #DateFormat(Now(),"yyyy-mm-dd")# - Issued in #encodeForHTML(organisme.ville)#, #organisme.province#
					</div>
					<div  class="small" style="position:absolute; top:256mm; right:8mm;text-align:right;">
						Canada Revenue Agency<br>
						canada.ca/charities-giving
					</div>
				</div>
			</cfhtmltopdf>
			<cfset mailsubject = "Receipt for income tax purposes issued by " & organisme.organisme & " for donor " & prenom & " " & nom & " - " & dateDebut & " to " & dateFin>
			
			<!--- SI L'ORGANISME A INSCRIT UNE ADRESSE COURRIEL POUR LES REPLY --->
			<CFIF organisme.reponse_courriel NEQ "">
				<cfmail attributeCollection="#APPLICATION.emailAttributeCollectionResend#" to="#courriel#" replyto="#organisme.reponse_courriel#" subject="#mailsubject#" type="text/html">
					<cfmailparam file="#recupath#" disposition="attachment" type="application/PDF" remove="true">
					<cfmailparam name="envoicode" value="#envoicode#">
					<cfmailparam name="envoidonateurid" value="#donateurID#">
					#messagecourriel#
				</cfmail>
			<CFELSE>
				<cfmail attributeCollection="#APPLICATION.emailAttributeCollectionResend#" to="#courriel#" subject="#mailsubject#" type="text/html">
					<cfmailparam file="#recupath#" disposition="attachment" type="application/PDF" remove="true">
					<cfmailparam name="envoicode" value="#envoicode#">
					<cfmailparam name="envoidonateurid" value="#donateurID#">
					#messagecourriel#
				</cfmail>
			</CFIF>
		
		</cfoutput>

