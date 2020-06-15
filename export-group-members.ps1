
foreach ($sam in Get-ADGroupMember -Identity "Application Access - DMS"){

$upn = $sam.SamAccountName

 "$upn;" | out-file .\output.txt -Append

}