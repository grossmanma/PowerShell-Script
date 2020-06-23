# connect to Azure 
Connect-AzureRmAccount
Select-AzureRmSubscription –SubscriptionName 'Your Subscription Name'

#select RGS and VM
$rgName = 'Resource Group'
$vmName = 'VM Name'
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName

#If VM is running stop it
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName

# change the OS disk Size 
$disk= Get-AzureRmDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$disk.DiskSizeGB = 250 # new Size in GB
Update-AzureRmDisk -ResourceGroupName $rgName -Disk $disk -DiskName $disk.Name

#start VM
Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName