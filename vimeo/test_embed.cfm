<cfset videourl = "http://www.vimeo.com/1330769">

<cfset vimeo = createObject("component", "vimeo")>

<cfset embed = vimeo.getEmbedCode(videourl)>
<cfdump var="#embed#">

<p>

<cfoutput>#embed.html#</cfoutput>

<p>

<cfset embed = vimeo.getEmbedCode(videourl=videourl,color="##00ff00")>
<cfoutput>#embed.html#</cfoutput>
