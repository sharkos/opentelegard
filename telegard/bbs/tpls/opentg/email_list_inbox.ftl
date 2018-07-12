
${color.lightcyan?right_pad(30)}Email Inbox

${color.blue}MsgNum   Subject                          From                 Received
${color.darkgray}-------- -------------------------------  -------------------- ----------------
<#if emails?has_content><#list emails as e>
${color.green}${e.id?string?right_pad(9)} ${color.white}${e.subject?substring(0, 30)?right_pad(31)} ${color.brightyellow}${e.from?substring(0,19)?right_pad(20)} ${color.gray}${e.received?string("MM/dd/yyyy HH:mm")}
</#list>${color.reset}</#if>