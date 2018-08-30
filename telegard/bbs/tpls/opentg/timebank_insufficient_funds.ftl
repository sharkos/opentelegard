${color.lighred}Insufficent time available to complete this transaction.
${color.norm}Requested: ${color.white}<#if amount?has_content>${amount?string}</#if>
${color.norm}Available: ${color.white}<#if balance?has_content>${balance?string}</#if>
${color.norm}