
${color.lightcyan?right_pad(30)}Files in ${areaname}

${color.blue}File ID   Filename/Short Description                        Size(b)
${color.darkgray}--------  ------------------------------------------------  --------
<#if files?has_content><#list files as f>
${color.green}${f.id?string?right_pad(9)} ${color.white}${f.filename?right_pad(49)} ${color.brightyellow}${f.size}
${color.brightyellow?right_pad(19)}${f.name}
</#list>${color.reset}</#if>