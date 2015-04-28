
<cfset vimeo = createObject("component", "vimeo")>

<cfdump var="#vimeo.getUserInfo('user607528')#" label="Default, user_info">

<cfdump var="#vimeo.getUserInfo('thedamfam','clips')#" label="Clips" top="3">

<cfdump var="#vimeo.getUserInfo('thedamfam','subscriptions')#" label="Subscriptions" top="3">

<cfdump var="#vimeo.getUserInfo('thedamfam','contacts_like')#" label="Contacts_Like" top="3">

<cfdump var="#vimeo.getUserInfo('thedamfam','contacts_clips')#" label="Contacts_Clips" top="3">

<cfdump var="#vimeo.getUserInfo('thedamfam','appears_in')#" label="Appears_In" top="3">

<cfdump var="#vimeo.getUserInfo('thedamfam','all_user_clips')#" label="All_User_Clips" top="3">

<cfdump var="#vimeo.getGroupInfo('TLSM4Beginners','clips')#" label="getGroupInfo" top="3">
