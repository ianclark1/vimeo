<cfcomponent output="false">

<cfset variables.baseURL = "http://vimeo.com/api/">

<cffunction name="getEmbedCode" access="public" returnType="struct" output="false" hint="Gets Embed code">
	<cfargument name="videourl" type="string" required="true">
	<cfargument name="width" type="string" required="false" hint="The exact width of the video. Defaults to original size.">
	<cfargument name="maxwidth" type="string" required="false" hint="Same as width, but video will not exceed original size.">
	<cfargument name="byline" type="string" required="false" hint="Show the byline on the video. Defaults to true.">
	<cfargument name="title" type="string" required="false" hint="Show the title on the video. Defaults to true.">
	<cfargument name="portrait" type="string" required="false" hint="Show the user's portrait on the video. Defaults to true.">
	<cfargument name="color" type="string" required="false" hint="Specify the color of the video controls. ">

	<cfset var theURL = variables.baseURL & "oembed.xml?">
	<cfset var res = "">
	<cfset var packet = "">
	<cfset var result = "">
	<cfset var key = "">
	
	<cfset theURL = theURL & "url=#urlEncodedFormat(arguments.videourl)#">

	<cfif structKeyExists(arguments, "width")>
		<cfset theURL = theURL & "&width=#arguments.width#">
	</cfif>
	<cfif structKeyExists(arguments, "maxwidth")>
		<cfset theURL = theURL & "&maxwidth=#arguments.maxwidth#">
	</cfif>
	<cfif structKeyExists(arguments, "byline")>
		<cfset theURL = theURL & "&byline=#arguments.byline#">
	</cfif>
	<cfif structKeyExists(arguments, "title")>
		<cfset theURL = theURL & "&title=#arguments.title#">
	</cfif>
	<cfif structKeyExists(arguments, "portrait")>
		<cfset theURL = theURL & "&portrait=#arguments.portrait#">
	</cfif>
	<cfif structKeyExists(arguments, "color")>
		<cfset theURL = theURL & "&color=#urlEncodedFormat(arguments.color)#">
	</cfif>
	
	<cfhttp url="#theURL#" result="res">

	<!--- it looks like if an error occurs, nothing is returned in fileContent --->
	<cfif not isXML(res.fileContent)>
		<cfthrow message="Invalid response from Vimeo">
	</cfif>
	
	<cfset packet = xmlParse(res.fileContent)>

	<cfset result = structNew()>
	<cfloop item="key" collection="#packet.oembed#">
		<cfset result[key] = packet.oembed[key].xmlText>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="getGroupInfo" access="public" returnType="any" output="false" hint="Retrieves group based information.">
	<cfargument name="group" type="string" required="true" hint="Group">
	<cfargument name="info" type="string" required="false" default="clips" 
				hint="Type of info to get. One of: clips. Vimeo will be adding more soon.">

	<cfset var theURL = variables.baseURL & "group/" &  arguments.group & "/" & arguments.info & "/xml">
	<cfset var res = "">
	<cfset var packet = "">
	<cfset var result = "">
	<cfset var x = "">
	<cfset var clip = "">
	<cfset var c = "">
	
	<cfhttp url="#theURL#" result="res">

	<!--- it looks like if an error occurs, nothing is returned in fileContent --->
	<cfif not isXML(res.fileContent)>
		<cfthrow message="Invalid response from Vimeo">
	</cfif>
	
	<cfset packet = xmlParse(res.fileContent)>

		
	<!--- keeping the switch since, in theory, vimeo will add more info types. --->
	<cfswitch expression="#arguments.info#">
	
		<cfcase value="clips">
			<cfset result = queryNew("title,url,clip_id,caption,upload_date,thumbnail_small,thumbnail_medium,thumbnail_large,user_name,user_url,user_thumbnail_small,user_thumbnail_large,stats_number_of_likes,stats_number_of_plays,stats_number_of_comments,tags")>
			<cfif structKeyExists(packet.clips, "clip") and arrayLen(packet.clips.clip)>
				<cfloop index="x" from="1" to="#arrayLen(packet.clips.clip)#">
					<cfset clip = packet.clips.clip[x]>
					<cfset queryAddRow(result)>
					<cfloop index="c" list="#result.columnlist#">
						<cfset querySetCell(result, c, clip[c].xmlText)>
					</cfloop>
				</cfloop>
			</cfif>
			<cfreturn result>
		</cfcase>	

	</cfswitch>
	
	<cfreturn result>	
</cffunction>

<cffunction name="getUserInfo" access="public" returnType="any" output="false" hint="Retrieves user based information.">
	<cfargument name="username" type="string" required="true" hint="Username">
	<cfargument name="info" type="string" required="false" default="user_info" 
				hint="Type of info to get. One of: user_info,clips,subscriptions,contacts_like,contacts_clips,appears_in,all_user_clips">

	<cfset var theURL = variables.baseURL & arguments.username & "/" & arguments.info & "/xml">
	<cfset var res = "">
	<cfset var packet = "">
	<cfset var result = "">
	<cfset var key = "">
	<cfset var x = "">
	<cfset var clip = "">
	<cfset var c = "">
	
	<cfhttp url="#theURL#" result="res">

	<!--- it looks like if an error occurs, nothing is returned in fileContent --->
	<cfif not isXML(res.fileContent)>
		<cfthrow message="Invalid response from Vimeo">
	</cfif>
	
	<cfset packet = xmlParse(res.fileContent)>

	<cfswitch expression="#arguments.info#">
	
		<cfcase value="user_info">
			<cfset result = structNew()>
			<cfloop item="key" collection="#packet.users.user#">
				<cfset result[key] = packet.users.user[key].xmlText>
			</cfloop>
		</cfcase>

		<cfcase value="clips,subscriptions,contacts_like,contacts_clips,appears_in,all_user_clips">
			<cfset result = queryNew("title,url,clip_id,caption,upload_date,thumbnail_small,thumbnail_medium,thumbnail_large,user_name,user_url,user_thumbnail_small,user_thumbnail_large,stats_number_of_likes,stats_number_of_plays,stats_number_of_comments,tags")>
			<cfif structKeyExists(packet.clips, "clip") and arrayLen(packet.clips.clip)>
				<cfloop index="x" from="1" to="#arrayLen(packet.clips.clip)#">
					<cfset clip = packet.clips.clip[x]>
					<cfset queryAddRow(result)>
					<cfloop index="c" list="#result.columnlist#">
						<cfset querySetCell(result, c, clip[c].xmlText)>
					</cfloop>
				</cfloop>
			</cfif>
			<cfreturn result>
		</cfcase>	

	</cfswitch>
	
	<cfreturn result>	
</cffunction>

</cfcomponent>