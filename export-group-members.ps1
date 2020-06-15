
foreach ($sam in Get-ADGroupMember -Identity "AD-group"){

$upn = $sam.SamAccountName

 "$upn;" | out-file .\output.txt -Append

}
