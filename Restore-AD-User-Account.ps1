 # restore a list of users. if you need to create the list you can do Get-ADObject -Filter {sAMAccountName -eq $user} -includeDeletedObjects | select SamAccountName | out-file -filepath "C:\Source\users.txt" -Append
 foreach($user in Get-Content C:\Source\users.txt){
 Get-ADObject -Filter {sAMAccountName -eq $user} -includeDeletedObjects | Restore-ADObject -NewName $user
 $userid = Get-ADUser $user
 Set-ADAccountPassword -Identity $userid -reset -newpassword (ConvertTo-SecureString -AsPlainText "change me!1" -Force) 
 Set-aduser $userid -changepasswordatlogon $true
 Enable-ADAccount -Identity $userid
 $user
 pause

 }


#Restore one user you most know the SamAccountName
 $user = "User "
Get-ADObject -Filter {sAMAccountName -eq $user} -includeDeletedObjects | Restore-ADObject -NewName $user
$userid = Get-ADUser $user
Set-ADAccountPassword -Identity $userid -reset -newpassword (ConvertTo-SecureString -AsPlainText "Yulista2019.!CT" -Force) 
 Set-aduser $userid -changepasswordatlogon $false
Enable-ADAccount -Identity $userid
$user
 

