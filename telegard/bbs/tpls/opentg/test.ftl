<#-- jirb calls for testing these:

t = Tgtemplate::Template.new('test.ftl')
ta = ["one", "two", "three"]
ch = [{"name"=>"array0"}, {"name"=>"array1"}, {"name"=>"array2"}]
t.render({"name"=>"test", "ta"=> ta, "ch"=>ch })

-->

${name}

This is a simple array
<#list ta as a>
 Item =  ${a}
</#list>

This is a complex array where each item is a hash
<#list ch as c>
 ${c.name}
</#list>

This is the Sequel Dataset array of hashs, where has keys are symbols
<#list sd as s>
 ${s[':id']}  ${s[':name']}
</#list>
