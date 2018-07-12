
            ${color.lightcyan}${user.login}'s Preferences
${color.white}
 ${color.brightmagenta}C${color.blue}) ${color.brightblue}Terminal Colors: ${color.brightcyan}${user.pref_term_color?string}
 ${color.brightmagenta}H${color.blue}) ${color.brightblue}Terminal Height: ${color.brightcyan}<#if user.pref_term_height?has_content>${user.pref_term_height?string}</#if>
 ${color.brightmagenta}W${color.blue}) ${color.brightblue}Terminal Width : ${color.brightcyan}<#if user.pref_term_width?has_content>${user.pref_term_width?string}</#if>
 ${color.brightmagenta}P${color.blue}) ${color.brightblue}Terminal Pager : ${color.brightcyan}${user.pref_term_pager?string}
 ${color.brightmagenta}M${color.blue}) ${color.brightblue}Display Menus  : ${color.brightcyan}${user.pref_show_menus?string}
 ${color.brightmagenta}F${color.blue}) ${color.brightblue}Use Fast Logon : ${color.brightcyan}${user.pref_fastlogin?string}
 ${color.brightmagenta}E${color.blue}) ${color.brightblue}Default Editor : ${color.brightcyan}${user.pref_editor?string}
 ${color.brightmagenta}X${color.blue}) ${color.brightblue}Save Changes & Quit     ${color.brightmagenta}.${color.blue}) ${color.brightblue}Abandon Changes & Quit
