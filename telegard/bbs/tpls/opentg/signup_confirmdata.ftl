
${color.darkgray}--------------------------------------------------------------------------
                 ${color.lightblue}Confirm / Edit User Account Signup Data
${color.darkgray}--------------------------------------------------------------------------
${color.white}
 ${color.brightmagenta}U${color.blue}) ${color.brightblue}Login Alias : ${color.brightcyan}${login}
 ${color.brightmagenta}E${color.blue}) ${color.brightblue}Email       : ${color.brightcyan}${email}
 ${color.brightmagenta}F${color.blue}) ${color.brightblue}First Name  : ${color.brightcyan}${firstname?right_pad(25)}  ${color.brightmagenta}L${color.blue}) ${color.brightblue}Last Name: ${color.brightcyan}${lastname}
 ${color.brightmagenta}C${color.blue}) ${color.brightblue}City        : ${color.brightcyan}${city?right_pad(25)     }  ${color.brightmagenta}S${color.blue}) ${color.brightblue}State    : ${color.brightcyan}${state}
<#if postal?has_content>
 ${color.brightmagenta}Z${color.blue}) ${color.brightblue}Postal Code : ${color.brightcyan}${postal?right_pad(25)}</#if><#if country?has_content>  ${color.brightmagenta}Y${color.blue}) ${color.brightblue}Country  : ${color.brightcyan}${country}
</#if>
<#if address1?has_content>
 ${color.brightmagenta}D${color.blue}) ${color.brightblue}Address 1   : ${color.brightcyan}${address1}
</#if>
<#if address2?has_content>
 ${color.brightmagenta}D${color.blue}) ${color.brightblue}Address 2   : ${color.brightcyan}${address2}
</#if>
<#if bday?has_content> ${color.brightmagenta}B${color.blue}) ${color.brightblue}Birthdate   : ${color.brightcyan}${bday?right_pad(25)}</#if><#if gender?has_content>  ${color.brightmagenta}G${color.blue}) ${color.brightblue}Gender   : ${color.brightcyan}${gender}</#if>
 ${color.brightmagenta}P${color.blue}) ${color.brightblue}Password    : ${color.darkgray}<not shown>
 ${color.brightmagenta}Q${color.blue}) ${color.brightblue}PasswordHint: ${color.brightcyan}${pwhint_question}
 ${color.brightmagenta}A${color.blue}) ${color.brightblue}Hint Answer : ${color.brightcyan}${pwhint_answer}
<#if custom1?has_content> ${color.brightmagenta}1${color.blue}) ${color.brightblue}Question 1  : ${color.brightcyan}${custom1}</#if>
<#if custom2?has_content> ${color.brightmagenta}2${color.blue}) ${color.brightblue}Question 2  : ${color.brightcyan}${custom2}</#if>
<#if custom3?has_content> ${color.brightmagenta}3${color.blue}) ${color.brightblue}Question 3  : ${color.brightcyan}${custom3}</#if>
 ${color.brightmagenta}X${color.blue}) ${color.brightblue}Save & Create Account
  