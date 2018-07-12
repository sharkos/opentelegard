${color.darkgray}------------------------------------------------------------
${color.lightcyan}Users
${color.darkgray}------------------------------------------------------------
<#list users as u>
${color.lightblue}${u.login}  ${color.white}- ${color.yellow}${u.firstname} ${u.lastname} from ${u.city},${u.state}
</#list>
${color.darkgray}------------------------------------------------------------
${color.lightcyan}Groups
${color.darkgray}------------------------------------------------------------
<#list groups as g>
${color.lightblue}${g.name} ${color.white}- ${color.yellow}${g.sysopnote}
</#list>${color.reset}