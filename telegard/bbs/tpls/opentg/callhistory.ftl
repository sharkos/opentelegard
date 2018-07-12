
${color.lightcyan?right_pad(30)}${title}

${color.blue}User             Login Time                Logout Time
${color.darkgray}---------------- ------------------------- ------------------
<#if callers?has_content><#list callers as c>
${color.lightblue}${c.alias?right_pad(16)} ${color.red}${c.time_login?datetime?string?right_pad(25)} <#if c.time_logout?has_content>${c.time_logout?datetime}</#if>
</#list>${color.reset}</#if>