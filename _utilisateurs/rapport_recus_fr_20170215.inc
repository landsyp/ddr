				<cfdocument
					format="pdf"
					marginleft="0"
					marginright="0"
					margintop="0"
					marginbottom="0"
					unit="in"
					pageType="legal"
					localUrl="yes"
					>
			
					<cfoutput query="ListeDonateurs">
						<cfinvoke component="#APPLICATION.cfcRapports#" method = "RapportRecusMontant" returnvariable ="montantTotal">
							<cfinvokeargument name="annee" value="#annee#">
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
									www.cra-arc.gc.ca/bienfaisance</div>
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
									www.cra-arc.gc.ca/bienfaisance</div>
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
									www.cra-arc.gc.ca/bienfaisance</div>
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
									www.cra-arc.gc.ca/bienfaisance</div>
								</td>
							</tr>
						</table>
						<!--- <cfdocumentitem type="pagebreak" /> --->
						<cfset page++>
					</cfoutput>
				</cfdocument>