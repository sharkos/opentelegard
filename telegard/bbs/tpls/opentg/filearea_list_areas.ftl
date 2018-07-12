
${color.lightcyan?right_pad(30)}Listing of File Areas

${color.blue}Area  Name                       Description
${color.darkgray}----  -------------------------  --------------------------------------------------
<#if areas?has_content><#list areas as a>
${color.green}${a.id?string?right_pad(5)} ${color.brightyellow}${a.name?capitalize?right_pad(26)} ${color.yellow}${a.description}
</#list>${color.reset}</#if>