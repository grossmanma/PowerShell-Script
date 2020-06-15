$computername = $env:computername
$computer = "$computername$"
$glist = "MBAM-EXEMPT"
            [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
         $a = new-object -comobject wscript.shell
$members = Get-ADGroupMember -Identity $glist -Recursive | Select -ExpandProperty SamAccountName
If ($members -contains $computer -or $members -eq $null) {
exit
}
$software = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*).displayName -like "MDOP MBAM"
If (-Not $software) {
exit
}
$status = manage-bde -status 
$status | out-file .\Protect.txt
$string = get-content -Path .\Protect.txt
if($string -contains "    Protection Status:    Protection On"){
$output = "true"
}else {
$output = "false"
}
if($string -contains "Percentage Encrypted: 0.0%"){
$output1 = "true"
}else {
$output1 = "false"
}

if($output -eq "false" -and $output1 -eq "True" ){
$date = Get-Date
"MBAM is being enable $date" 
manage-bde -on C: #-encryptionmethod Aes256
#Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes256
$a.popup('Your Computer is Out of Compliance! Your Computer is being encrypted and will restart in 8 hours')
sleep -Seconds 14400 
$a.popup('Your Computer is being encrypted and will restart in 4 hours')
sleep -Seconds 7200
$a.popup('Your Computer is being encrypted and will restart in 2 hours')
sleep -Seconds 5400
$a.popup('Your Computer is being encrypted and will restart in 30 minutes')
sleep -Seconds 900
$a.popup('Your Computer is being encrypted and will restart in 15 minutes.')
sleep -Seconds 600
$a.popup('Your Computer is being encrypted and will restart in 5 minutes. Please save all your work and logoff')
sleep -Seconds 300
shutdown -r -f -t 60 } 
