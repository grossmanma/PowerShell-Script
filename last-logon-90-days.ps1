# Defining Target Path  
$TargetOU   =  "add target OU"  
# Defining Time
$last = (get-date).adddays(-1)
Get-ADComputer -properties * -filter {(lastlogondate -notlike "*" -OR lastlogondate -le $last) -AND (passwordlastset -le $last) }  |
select-object name, SAMaccountname, passwordExpired, PasswordNeverExpires, logoncount, whenCreated, lastlogondate, PasswordLastSet, lastlogontimestamp  | export-csv .\lastlogon.csv -NoTypeInformation 




