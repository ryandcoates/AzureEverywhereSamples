function New-epAzureVM {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $ResourceGroup,
        
        [Parameter()]
        [String]
        $Location = "westus",

        [Parameter(Mandatory=$True, ValueFromPipeline=$True)]
        [String[]]
        $VMName,

        [Parameter()]
        [ValidateSet("2016-Datacenter","2012-R2-Datacenter")]
        [String]
        $SKU,

        [Parameter(Mandatory=$True)]
        [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork]
        $VirtualNetwork,

        [Parameter()]
        [PSCredential]$Credential
    )

    PROCESS{
        ForEach ($vm in $vmname){
            If (!($ResourceGroup)){
                $ResourceGroup = (New-AzureRmResourceGroup $vm -location $Location).ResourceGroupName
            } else {
                $ResourceGroup = (New-AzureRMResourceGroup $ResourceGroup -Location $Location).ResourceGroupName
            }

    
            If (!($Credential)){
                $Credential = Get-Credential -Message "Provide Credentials for the new servers local admin account"
                }

            If (!($VirtualNetwork)){
        
                }

            $NicName = $VM +"-NIC0"
            #$vnet = Get-AzureRMVirtualNetwork -ResourceGroupName "TestNetworkRG" -name "TestNetwork"
            #$cred = Get-Credential

            # Create a virtual network card and associate with public IP address and NSG
            $nic = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroup -Location $Location `
            -SubnetId $vnet.Subnets[0].Id

            # Create a virtual machine configuration
            $vmConfig = New-AzureRmVMConfig -VMName $vm -VMSize Standard_DS2 | `
            Set-AzureRmVMOperatingSystem -Windows -ComputerName $vm -Credential $Credential | `
            Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer `
                                    -Offer WindowsServer `
                                    -Skus $SKU `
                                    -Version latest | `
            Add-AzureRmVMNetworkInterface -Id $nic.Id | `
            Set-AzureRMVMBootDiagnostics -Disable

            New-AzureRmVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vmConfig
        }
    }
}
