
${color.lightcyan?right_pad(26)}Listing ${areaname}

${color.blue}MsgID  From              Subject                                    Date
${color.darkgray}-----  ----------------  ------------------------------------------ ----------
<#if msgs?has_content><#list msgs as m>
${color.green}${m.id?string?right_pad(6)} ${color.brightblue}${m.from?upper_case?right_pad(17)} ${color.brightyellow}${m.subject?right_pad(42)?substring(0,42)} ${color.brightcyan}${m.composed?string("MM/dd/yyyy")}
</#list>${color.reset}</#if>