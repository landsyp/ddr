			<cfinvoke component="#APPLICATION.cfcAdmin#" method = "OrganismeInfos" returnvariable ="Organisme">
				<cfinvokeargument name="organismeID" value="#Session.utilisateur.organismeID#">
			</cfinvoke>

			<!--- <CFIF dateDiff("d", Now(), organisme.date_fin_licence) LTE 30>
				<CFSET couleur = "red">
			<CFELSE>
				<CFSET couleur = "black">
			</CFIF> --->
			
			<div class="w-section sectionsousheader">
				<div class="w-container containersousheader">
	 				<div class="wrappersousheader">
						<h3 class="headingbreadcrumb">
							<span CLASS="organisme"><cfoutput>#Session.utilisateur.organisme#</cfoutput>
								<CFIF Organisme.date_fin_licence NEQ "">
									  | 
									<CFIF session.langue EQ "fr">
										<CFIF dateDiff("d", Now(), organisme.date_fin_licence) LTE 30>
											<span style="font-size:10px;color:red;">Date fin de licence : <cfoutput query="organisme">#DateFormat(date_fin_licence, "yyyy/mm/dd")#</cfoutput> <a href="mailto:info@cqoc.org">Veuillez communiquer avec nous pour renouveler votre licence</a></span>	
										<CFELSE>
											<span style="font-size:10px;color:black;">Date fin de licence : <cfoutput query="organisme">#DateFormat(date_fin_licence, "yyyy/mm/dd")#</cfoutput></span>
										</CFIF>
									<CFELSE>
										<CFIF dateDiff("d", Now(), organisme.date_fin_licence) LTE 30>
											<span style="font-size:10px;color:red;">Date end of license : <cfoutput query="organisme">#DateFormat(date_fin_licence, "yyyy/mm/dd")#</cfoutput> <a href="mailto:info@cqoc.org">Please contact us to renew your license</a></span>
										<CFELSE>
											<span style="font-size:10px;color:black;">Date fin de licence : <cfoutput query="organisme">#DateFormat(date_fin_licence, "yyyy/mm/dd")#</cfoutput></span>
										</CFIF>
									</CFIF>
								</CFIF>
							</span>
							
							<cfoutput>#Session.utilisateur.prenom# #Session.utilisateur.nom#</cfoutput>
							
						</h3>
	 				</div>
  				</div>
			</div>