# Format date 
$DateStamp = get-date -uformat "%Y-%m-%d@%H-%M-%S" 
#set archive path Directory  
$archiveP  = ".\archive" 
#set dat format for output files 
$timestamp = Get-Date -Format o | foreach {$_ -replace ":", "."}
#get current date 
$Now = Get-Date  
$timespan = New-Timespan –Days 90 # Disable computer object that have not login # days
$dtimestamp = New-Timespan –Days 180 # Delete computer object that have not login # days
$computers = Search-ADAccount -ComputersOnly –AccountInactive –TimeSpan $timespan | Where {$_.DistinguishedName -notlike "*,OU=DELETE 90 DAYS,*"} # change OU= to the path in your AD
$Dcomputers = Search-ADAccount -ComputersOnly –AccountInactive –TimeSpan $timespan | Where {$_.DistinguishedName -like "*,OU=DELETE 90 DAYS,*"} # change OU= to the path in your AD
#define amount of days to keep backups 
$Days = "90" 
#define LastWriteTime parameter based on $Days 
$LastWrite = $Now.AddDays(-$Days) 
#get files based on lastwrite filter and specified folder and delete computer older than 90 Days 
$Chkarchive = Get-Childitem $archiveP -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}  
foreach ($File in $Chkarchive)  
    { 
    if ($File -ne $NULL)
            { 

            Remove-Item -Path $file.fullname -Force -Confirm:$false
}}
foreach($dcomputer in $dcomputers){
 $data = Get-ADComputer $dcomputer -properties * 
 if($data.OperatingSystem -like "*Windows Server*"){
 Get-ADComputer $dcomputer -properties * | select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,OperatingSystem  | Export-Csv   .\archive\$DateStamp-SRV180.csv  -NoTypeInformation -Append
 }
 else{
 Get-ADComputer $dcomputer -properties * | select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,OperatingSystem  | Export-Csv   .\archive\$DateStamp-NONSRV180.csv  -NoTypeInformation -Append
     # delete object out of AD
     Get-ADComputer $_ | Remove-ADComputer   -Confirm:$false     
 }}

 
 
 
             #sending email with output files 
if(test-path "C:\script\archive\$DateStamp-NONSRV180.csv" ){
        #Write-Host "this is a test"
$fromaddress = "donotreply@yourdomain.com""  

$toaddress = "someone@yourdomain.com"  

$Subject = "Yulista.us Computer account that need to be delete from AD  Report"  

$attachment = "C:\script\archive\$DateStamp-SRV180.csv" 
$attachment1 = "C:\script\archive\$DateStamp-NONSRV180.csv" 

  

$smtpserver = "SMTP Relay"  


####################################  


$message = new-object System.Net.Mail.MailMessage  

$message.From = $fromaddress  

$message.To.Add($toaddress)  

$message.Subject = $Subject  

$message.Body = "Attached is the Computer account that need to be delete from AD on domain. Please review." 

$attach = new-object Net.Mail.Attachment($attachment)  

$message.Attachments.Add($attach)  

$attach = new-object Net.Mail.Attachment($attachment1)  

$message.Attachments.Add($attach)  

$smtp = new-object Net.Mail.SmtpClient($smtpserver)  

$smtp.Send($message)  
      

       
        }




foreach($computer in $computers){
 $data = Get-ADComputer $computer -properties * 
 if($data.OperatingSystem -like "Windows Server*"){
 Get-ADComputer $computer -properties * | select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,OperatingSystem  | Export-Csv   .\archive\$DateStamp-YUL-SRV90.csv  -NoTypeInformation -Append
 }
 else{
 Get-ADComputer $computer -properties * | select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,OperatingSystem  | Export-Csv   .\archive\$DateStamp-YUL-NONSRV90.csv  -NoTypeInformation -Append
 Set-ADComputer $computer -Description "computer was disable by inactive script $DateStamp "
 Disable-ADAccount $computer
 Get-ADComputer $computer | Move-ADObject  -TargetPath 'OU=DELETE 90 DAYS,DC=Yulista,DC=us' # change OU= to the path in your AD
#define amount of days to keep backups 
 }

 
 
 }


 #sending email with output files 

$fromaddress = "donotreply@yourdomain.com""  

$toaddress = "someone@yourdomain.com""  

$Subject = " Inactive Computer Report"  

$attachment = "C:\script\archive\$DateStamp-NONSRV90.csv" 
$attachment1 = "C:\script\archive\$DateStamp-SRV90.csv" 

  

$smtpserver = "SMTP Relay"  


####################################  


$message = new-object System.Net.Mail.MailMessage  

$message.From = $fromaddress  

$message.To.Add($toaddress)  

$message.Subject = $Subject  

$message.Body = "Attached is the inactive computer account log. Please review." 

$attach = new-object Net.Mail.Attachment($attachment)  

$message.Attachments.Add($attach)  

$attach = new-object Net.Mail.Attachment($attachment1)  

$message.Attachments.Add($attach)  

$smtp = new-object Net.Mail.SmtpClient($smtpserver)  

$smtp.Send($message)        
