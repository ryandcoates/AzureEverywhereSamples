<#
function New-epAzureVM {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $ResourceGroup,
        
        [Parameter()]
        [String]
        $Location = "westus",

        [Parameter(
            ValueFromPipeline=$True,
            Mandatory=$True)]
        [String[]]
        $VMName,

        [Parameter(
            Mandatory=$True)]
        [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork]
        $VirtualNetwork,

        [Parameter(
            Mandatory=$True)]
        [PSCredential]$Credential
    )
}
#>

#If ($Location -eq $null){}
    $Location = "westus"

#If ($ResourceGroup -eq $null){}
    $ResourceGroup = (New-AzureRmResourceGroup Test3 -location $Location).ResourceGroupName
    `
$VMName = "TestVM3"
$NicName = $VMName +"-NIC0"
$vnet = Get-AzureRMVirtualNetwork -ResourceGroupName "TestNetworkRG" -name "TestNetwork"
$cred = Get-Credential

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroup -Location $Location `
-SubnetId $vnet.Subnets[0].Id

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $VMName -VMSize Standard_DS2 | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName $VMName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer `
                        -Offer WindowsServer `
                        -Skus 2016-Datacenter `
                        -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id | `
Set-AzureRMVMBootDiagnostics -Disable

New-AzureRmVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vmConfig

