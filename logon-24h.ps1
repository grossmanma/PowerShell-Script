# Defining Time
$last = (get-date).adddays(-1)
Get-ADuser -properties * -filter {(lastlogondate -ge $last ) -or (DistinguishedName -notlike "*Service Accounts*") }  |
select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet,DistinguishedName  | export-csv c:\list\lastlogon.csv -NoTypeInformation 

Send-MailMessage -Attachments C:\list\lastlogon.csv -Subject "users who have login in the last 24 hrs." -To Someone@yourdomain.com -From noreply@yourdomain.com -SmtpServer smtp.yourdomain.com 