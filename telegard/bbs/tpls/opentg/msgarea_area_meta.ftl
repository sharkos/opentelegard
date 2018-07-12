
     ${color.lightblue}Area ID: ${color.lightyellow}${area.id?string?right_pad(10)}  ${color.lightblue}Type: ${color.lightyellow}<#if area.network == false>LOCAL<#elseif area.network == true>NETWORK<#else>unknown</#if>
     ${color.lightblue}   Name: ${color.white}${area.name}
     ${color.lightblue}Created: ${color.lightcyan}${area.created?string("EEE MMM dd HH:mm:ss")}
<#if network?has_content>
${color.lightblue}Network Name: ${color.lightcyan}${network.name}
${color.lightblue}Network Type: ${color.lightcyan}${network.protocol?capitalize}
${color.lightblue}Network Node: ${color.lightcyan}<#if network.protocol == 'telegard'>${network.tgnet_node}<#elseif network.protocol == 'fidonet'>${network.fidonet_node}<#elseif network.protocol == 'wwivnet'>${network.wwivnet_node}</#if>
${color.lightblue}   Last Sync: ${color.lightcyan}<#if network.sync?has_content>${network.sync}<#else>Never</#if>
</#if>
${color.lightblue} Description: ${color.reset}${area.description}
