

${color.lightcyan?right_pad(20)}${bbs.name}'s Directory

<#if bbslist?has_content><#list bbslist as b>
${color.cyan}       BBS Name: ${color.darkgray}${b.id?string?right_pad(3)}: ${color.white}${b.bbsname}
${color.cyan}      Submitted: ${color.norm}${b.created?string("MM/dd/yyyy HH:mm")} by ${b.submitted_by}
${color.cyan}     Sysop Name: ${color.norm}${b.sysopname}
${color.cyan}   Homepage URL: ${color.brightblue}${b.homepage}
${color.cyan} Connection URL: ${color.brightgreen}${b.bbsurl}
${color.cyan}BBS Description: ${color.norm}${b.description}

</#list>${color.reset}</#if>

