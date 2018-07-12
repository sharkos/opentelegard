
${color.lightcyan?right_pad(30)}Listing of Message Areas

${color.blue}Area  Name                       Description                               Type
${color.darkgray}----  -------------------------  ---------------------------------------- ---------
<#if areas?has_content><#list areas as a>
${color.green}${a.id?string?right_pad(5)} ${color.brightblue}${a.name?upper_case?right_pad(26)} ${color.brightyellow}${a.description?right_pad(40)?substring(0,40)} ${color.brightcyan}<#if a.network == false>LOCAL<#elseif a.network == true>NETWORK<#else>error</#if>
</#list>${color.reset}</#if>