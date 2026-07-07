<CFIF Session.langue EQ "fr">
	<div class="w-section footer">
		<div class="w-container containerfooter">
			<div class="textefooter">
				<a href="http://www.cqoc.org" target="_blank">Conseil Qu&eacute;b&eacute;cois des Organismes Chr&eacute;tiens</a>.<br>
				Suite 106, 5425 Boulevard Laurier O, Saint-Hyacinthe, QC J2S 3V6<br>
				(450) 778-7177<br>
				<a target="_blank" href="mailto:info@cqoc.org">info@cqoc.org</a><br>
				Copyright <cfoutput>#DatePart("yyyy", Now())#</cfoutput> &copy; CQOC. Tous droits r&eacute;serv&eacute;s.
				<div style="text-align:center;"><a href="/fr/conditions-utilisation" target="_blank">Conditions d'utilisation</div>
			</div>
		</div>
	</div>
<CFELSE>
	<div class="w-section footer">
		<div class="w-container containerfooter">
			<div class="textefooter">
				<a href="http://www.cqoc.org" target="_blank">Quebec Council of Christian Charities</a>.<br>
				Suite 106, 5425 Boulevard Laurier O, Saint-Hyacinthe, QC J2S 3V6<br>
				(450) 778-7177<br>
				<a target="_blank" href="mailto:info@cqoc.org">info@cqoc.org</a><br>
				Copyright <cfoutput>#DatePart("yyyy", Now())#</cfoutput> &copy; QCCC. All rights reserved.
				<div style="text-align:center;"><a href="/en/terms-of-use" target="_blank">Terms of Use</div>	
			</div>
		</div>
	</div>
</CFIF>