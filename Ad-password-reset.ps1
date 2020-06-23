# Password Settings
 $PasswordLength = 8
 $password = “”
# Set Password Character Strings
 $Set0 = "abcdefghijklmnpqrstuvwxyz".ToCharArray()
 $Set1 = "123456789".ToCharArray()
 $Set2 = "ABCDEFGHIJKLMNPQRSTUVWXYZ".ToCharArray()
 $Set3 = "!$%".ToCharArray()

#Build Password on Length Variable
 do{

$password += $set0 | Get-Random;
 $password += $set1 | Get-Random;
 $password += $set2 | Get-Random;
 $password += $set3 | Get-Random;
 }
 until ($password.Length -eq $passwordlength)
 # Convert to Secure String
 $pwd = convertto-securestring $password -asplaintext -force
 # Display Password
 $password

Import-Module Activedirectory -Cmdlet Get-ADUser,Set-ADUser,Set-ADAccountPassword,Enable-ADAccount

Set-ADAccountPassword $user -NewPassword $password -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon 
