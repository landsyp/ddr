<cfset dumpfilepath = GetDirectoryFromPath( GetCurrentTemplatePath() ) & "\receipt-email.log">

<!---
<cfdump var="start of new dump at #now()#" label="now()" output="#dumpfilepath#">
<cfdump var="#GetHttpRequestData()#" label="GetHttpResponseData()" output="#dumpfilepath#">
--->

<cfset envoiCode = "">
<cfset envoiDonateurID = "">
<cfset envoiStatut = "">

<cftry>
	<cfif NOT CGI.HTTP_USER_AGENT EQ "Amazon Simple Notification Service Agent">
		<cfthrow message="AWS SNS Invalid Response Info" detail="#now()# - CGI.HTTP_USER_AGENT is not Amazon Simple Notification Service Agent: #CGI.HTTP_USER_AGENT#">
	<cfelse>
		<cfset httpRequestData = getHTTPRequestData()>
		<cfset contentJSON = httpRequestData.content>
		<cfset content = deserializeJSON(contentJSON)>
		<cfif NOT structKeyExists(content, "topicArn")>
			<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - content does not have the key: topicArn">
		<cfelse>
			<cfif content.topicArn NEQ "arn:aws:sns:us-east-1:953621362233:solution-ddr-receipt"
			AND content.topicArn NEQ "arn:aws:sns:us-east-1:953621362233:solution-ddr-reply">
				<cfthrow message="AWS SNS Invalid Response Info" detail="#now()# - content.topicArn is not arn:aws:sns:us-east-1:953621362233:solution-ddr-receipt and is not arn:aws:sns:us-east-1:953621362233:solution-ddr-reply. content.topicArn is : #content.topicArn#">
			<cfelseif content.topicArn EQ "arn:aws:sns:us-east-1:953621362233:solution-ddr-receipt">
				<!--- solution-ddr-receipt is for responses to the email sent to users with their receipt --->

				<cfset contentMessage = deserializeJSON(content.message)> <!--- content.message is in JSON format --->
				<!--- <cfdump var="#contentMessage#" label="contentMessage" output="#dumpfilepath#"> --->
				<cfif NOT structKeyExists(contentMessage, "mail")>
					<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage does not have the key: mail">
				<cfelse>
					<cfif NOT structKeyExists(contentMessage.mail, "headers")>
						<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage.mail does not have the key: headers">
					<cfelse>
						<cfif NOT isArray(contentMessage.mail.headers)>
							<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage.mail.headers is not an array">
						<cfelse>
							<cfloop from="1" to="#arrayLen(contentMessage.mail.headers)#" index="i">
								<cfset mailheader = contentMessage.mail.headers[i]>
								<cfif isStruct(mailheader) AND mailheader.name EQ "envoicode">
									<cfset envoiCode = mailheader.value>
								<cfelseif isStruct(mailheader) AND mailheader.name EQ "envoidonateurid">
									<cfset envoiDonateurID = mailheader.value>
								</cfif>
							</cfloop>
							<cfif envoiCode EQ "">
								<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - The contentMessage.mail.headers array does not have a struct element with the key envoiCode">
							</cfif>
							<cfif envoiDonateurID EQ "">
								<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - The contentMessage.mail.headers array does not have a struct element with the key envoiDonateurID">
							</cfif>
						</cfif>
					</cfif>
				</cfif>
				<cfif NOT structKeyExists(contentMessage, "notificationType")>
					<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage does not have the key: notificationType">
				<cfelse>
					<cfswitch expression="#contentMessage.notificationType#">
						<cfcase value="Delivery"><cfset envoiStatut = "2-livre"></cfcase>
						<cfcase value="Bounce"><cfset envoiStatut = "3-rejete"></cfcase>
						<cfcase value="Complaint"><cfset envoiStatut = "4-spam"></cfcase>
					</cfswitch>
					<cfif envoiStatut EQ "">
						<cfthrow message="AWS SNS Invalid Response Info" detail="#now()# - contentMessage.notificationType is not a recognized value: #contentMessage.notificationType#">
					</cfif>
				</cfif>
			<cfelse>
				<!--- solution-ddr-reply is for responses to the email sent to user with his receipt --->
				<cfset contentMessage = deserializeJSON(content.message)> <!--- content.message is in JSON format --->
				<cfdump var="#contentMessage#" label="contentMessage" output="#dumpfilepath#"> 
				<cfif NOT structKeyExists(contentMessage, "mail")>
					<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage does not have the key: mail">
				<cfelse>
					<cfif NOT structKeyExists(contentMessage.mail, "headers")>
						<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage.mail does not have the key: headers">
					<cfelse>
						<cfif NOT isArray(contentMessage.mail.headers)>
							<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage.mail.headers is not an array">
						<cfelse>
							<cfloop from="1" to="#arrayLen(contentMessage.mail.headers)#" index="i">
								<cfset mailheader = contentMessage.mail.headers[i]>
								<cfif isStruct(mailheader) AND mailheader.name EQ "envoicode">
									<cfset envoiCode = mailheader.value>
								<cfelseif isStruct(mailheader) AND mailheader.name EQ "envoidonateurid">
									<cfset envoiDonateurID = mailheader.value>
								</cfif>
							</cfloop>
							<cfif envoiCode EQ "">
								<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - The contentMessage.mail.headers array does not have a struct element with the key envoiCode">
							</cfif>
							<cfif envoiDonateurID EQ "">
								<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - The contentMessage.mail.headers array does not have a struct element with the key envoiDonateurID">
							</cfif>
						</cfif> 
					</cfif>
				</cfif>
				<cfif NOT structKeyExists(contentMessage, "notificationType")>
					<cfthrow message="AWS SNS Missing Response Info" detail="#now()# - contentMessage does not have the key: notificationType">
				<cfelse>
					<cfswitch expression="#contentMessage.notificationType#">
						<cfcase value="Delivery"><cfset envoiStatut = "2-livre"></cfcase>
						<cfcase value="Bounce"><cfset envoiStatut = "3-rejete"></cfcase>
						<cfcase value="Complaint"><cfset envoiStatut = "4-spam"></cfcase>
					</cfswitch>
					<cfif envoiStatut EQ "">
						<cfthrow message="AWS SNS Invalid Response Info" detail="#now()# - contentMessage.notificationType is not a recognized value: #contentMessage.notificationType#">
					</cfif>
				</cfif>

			</cfif>
		</cfif>
	</cfif>
 
    <CFQUERY NAME="donateursListe" DATASOURCE="#APPLICATION.DSN#">
        UPDATE envois
            SET statut = <CFQUERYPARAM VALUE="#envoiStatut#" CFSQLTYPE="CF_SQL_VARCHAR">
            WHERE envoiCode	=	<CFQUERYPARAM VALUE="#envoiCode#" CFSQLTYPE="CF_SQL_VARCHAR">
            AND donateurID	=	<CFQUERYPARAM VALUE="#envoiDonateurID#" CFSQLTYPE="CF_SQL_INTEGER">
    </CFQUERY>

    <cfcatch>
        <cfdump var="#cfcatch#" label="cfcatch" output="#dumpfilepath#">
    </cfcatch>
</cftry>
