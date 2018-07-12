
            ${color.lightcyan}Editing User Account Data ${color.darkgray}(${color.brightyellow}${user.login}${color.darkgray})
${color.white}
 ${color.brightmagenta}E${color.blue}) ${color.brightblue}Email       : ${color.brightcyan}<#if user.email?has_content>${user.email}</#if>
 ${color.brightmagenta}F${color.blue}) ${color.brightblue}First Name  : ${color.brightcyan}${user.firstname?right_pad(25)}  ${color.brightmagenta}L${color.blue}) ${color.brightblue}Last Name: ${color.brightcyan}${user.lastname}
 ${color.brightmagenta}C${color.blue}) ${color.brightblue}City        : ${color.brightcyan}${user.city?right_pad(25)     }  ${color.brightmagenta}S${color.blue}) ${color.brightblue}State    : ${color.brightcyan}${user.state}
<#if signup.ask_postal == true > ${color.brightmagenta}Z${color.blue}) ${color.brightblue}Postal Code : ${color.brightcyan}<#if user.postal?has_content>${user.postal?right_pad(25)}</#if><#else>${color.reset?right_pad(52)}</#if><#if signup.ask_country == true> ${color.brightmagenta}Y${color.blue}) ${color.brightblue}Country  : ${color.brightcyan}<#if user.country?has_content>${user.country}</#if></#if>
<#if signup.ask_address == true> ${color.brightmagenta}D${color.blue}) ${color.brightblue}Address 1   : ${color.brightcyan}<#if user.address1?has_content>${user.address1}</#if>
 ${color.brightmagenta}D${color.blue}) ${color.brightblue}Address 2   : ${color.brightcyan}<#if user.address2?has_content>${user.address2}</#if></#if>
 ${color.brightmagenta}Q${color.blue}) ${color.brightblue}PasswordHint: ${color.brightcyan}${user.pwhint_question}
 ${color.brightmagenta}A${color.blue}) ${color.brightblue}Hint Answer : ${color.brightcyan}${user.pwhint_answer}

 ${color.brightmagenta}X${color.blue}) ${color.brightblue}Save Changes & Quit     ${color.brightmagenta}.${color.blue}) ${color.brightblue}Abandon Changes & Quit
