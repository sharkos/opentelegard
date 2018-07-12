<#if timetoday?has_content>
You have logged ${timetoday}/${grouplimit} minutes today.
</#if>
<#if logintoday?has_content>
You have made ${logintoday} connections today
</#if>
Current time is ${curtime}
Your session will expire on: ${expires}.
You have ${timeremain} minutes remaining.
