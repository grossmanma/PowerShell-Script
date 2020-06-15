 
 foreach($user in Get-Content C:\Source\users.txt){
 Get-ADObject -Filter {sAMAccountName -eq $user} -includeDeletedObjects | Restore-ADObject -NewName $user
 $userid = Get-ADUser $user
 Set-ADAccountPassword -Identity $userid -reset -newpassword (ConvertTo-SecureString -AsPlainText "change me!1" -Force) 
 Set-aduser $userid -changepasswordatlogon $true
 Enable-ADAccount -Identity $userid
 $user
 pause

 }



 $user = "User "
Get-ADObject -Filter {sAMAccountName -eq $user} -includeDeletedObjects | Restore-ADObject -NewName $user
$userid = Get-ADUser $user
Set-ADAccountPassword -Identity $userid -reset -newpassword (ConvertTo-SecureString -AsPlainText "Yulista2019.!CT" -Force) 
 Set-aduser $userid -changepasswordatlogon $false
Enable-ADAccount -Identity $userid
$user
 

