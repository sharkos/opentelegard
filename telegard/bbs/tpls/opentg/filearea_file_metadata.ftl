<#-- VALID TAGS FOR THIS TEMPLATE
Prefix = file.
  .id  .name  .tgfilearea_id  .owner_id  .approved_by  .uploaded_by  .enabled  .filename
  .description  .checksum  .version  .vendor  .license  .url  .size  .mtime  .created_at
  .modified_at
-->
   ${color.lightblue}Filename: ${color.lightcyan}${file.filename}
   ${color.lightblue}   Title: ${color.lightcyan}${file.name}
   ${color.lightblue} Version: ${color.lightcyan}${file.version}
   ${color.lightblue}  Vendor: ${color.lightcyan}${file.vendor}
   ${color.lightblue} License: ${color.lightcyan}${file.license}
   ${color.lightblue}     URL: ${color.lightcyan}${file.url}
   ${color.lightblue}FileSize: ${color.lightcyan}${file.size}
   ${color.lightblue}Checksum: ${color.lightcyan}${file.checksum}
   ${color.lightblue} Created: ${color.lightcyan}${file.created_at?string("EEE MMM dd HH:mm:ss")}
   ${color.lightblue}Modified: ${color.lightcyan}${file.modified_at?string("EEE MMM dd HH:mm:ss")}
   ${color.lightblue}FS MTime: ${color.lightcyan}${file.mtime?string("EEE MMM dd HH:mm:ss")}
   ${color.lightblue}   Owner: ${color.lightcyan}${file.owner_id}
   ${color.lightblue}Approver: ${color.lightcyan}${file.approved_by}
   ${color.lightblue}Uploader: ${color.lightcyan}${file.uploaded_by}
${color.lightblue}Description: ${color.white}${file.description}