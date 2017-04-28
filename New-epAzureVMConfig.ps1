# Building VMs in Azure for Fun and Profit

Login-AzureRMAccount

Select-AzureRmSubscription -SubscriptionId $env:AzureSubscriptionID

. .\New-epAzureVM.ps1




While (!($vnet)){
    $vnetName = Read-Host "What is the name of the Virtual Network you wish to use?: "
    $vnet = (Get-AzureRMVirtualNetwork | where{$_.Name -eq $vnetName})
    }

While (!($Cred)){
    $Cred = Get-Credential -Message "Enter new servers local admin details"
    }

[Array]$VM = @()
$done = $false
$i = 0
While ($done -eq $false){

    [String]$VMName = Read-Host "Enter VM Name[$i]: "
        If ($VMName){
            $vm += $VMName
            $i++
        
        } else {
            $done = $true
            }
    }

$vm | New-epAzureVM -VirtualNetwork $vnet -Credential $Cred -SKU '2012-R2-Datacenter' -ResourceGroup MultiVMTest