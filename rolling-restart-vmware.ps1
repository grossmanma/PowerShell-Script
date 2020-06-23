 
Add-PSSnapin VMware*

# Set vCenter and Cluster name 
$vCenterServer = "Vcenter Server"
$ClusterName =  "Cluster name"
 
##################
## Connect to infrastructure
##################
Connect-VIServer -Server $vCenterServer | Out-Null
 
##################
## Get Server Objects from the cluster
##################
# Get VMware Server Object based on name passed as arg
$ESXiServers = @(get-cluster $ClusterName | get-vmhost)
 
##################
## Reboot ESXi Server Function
## Puts an ESXI server in maintenance mode, reboots the server and the puts it back online
## Requires fully automated DRS and enough HA capacity to take a host off line
##################
Function RebootESXiServer ($CurrentServer) {
# Get Server name
$ServerName = $CurrentServer.Name
 
# Put server in maintenance mode
Write-Host "#### Rebooting $ServerName ####"
Write-Host "Entering Maintenance Mode"
Set-VMhost $CurrentServer -State maintenance -Evacuate | Out-Null
 
# Reboot blade
Write-Host "Rebooting"
Restart-VMHost $CurrentServer -confirm:$false | Out-Null
 
# Wait for Server to show as down
do {
sleep 15
$ServerState = (get-vmhost $ServerName).ConnectionState
}
while ($ServerState -ne "NotResponding")
Write-Host "$ServerName is Down"
 
# Wait for server to reboot
do {
sleep 60
$ServerState = (get-vmhost $ServerName).ConnectionState
Write-Host "Waiting for Reboot ..."
}
while ($ServerState -ne "Maintenance")
Write-Host "$ServerName is back up"
 
# Exit maintenance mode
Write-Host "Exiting Maintenance mode"
Set-VMhost $CurrentServer -State Connected | Out-Null
Write-Host "#### Reboot Complete####"
Write-Host ""
}
 
##################
## MAIN
##################
foreach ($ESXiServer in $ESXiServers) {
RebootESXiServer ($ESXiServer)
}
 
##################
## Cleanup
##################
# Close vCenter connection
Disconnect-VIServer -Server $vCenterServer -Confirm:$False
