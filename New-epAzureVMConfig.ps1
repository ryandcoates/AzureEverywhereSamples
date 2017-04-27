function New-epAzureVMConfig {
    [Cmdletbinding()]
    Param(
        [Parameter(
            ValueFromPipeline=$True,
            Mandatory=$True)]
        [String]
        $VMName,

        [Parameter()]
        [String]
        $ResourceGroup = $VMName,
        
        [Parameter()]
        [ValidateSet("westus","eastus","centralus")] 
        [String]
        $Location = "westus",

        [Parameter(Mandatory=$True)]
        [ValidateSet("2016-Datacenter","2012-R2-Datacenter")]
        [String]
        $SKU,

        [Parameter()]
        [Microsoft.Azure.Commands.Network.Models.PSVirtualNetwork]
        $VirtualNetwork,

        [Parameter()]
        [PSCredential]$Credential
    )

    $Output = @{
        VMName = $VMName
        Location = $Location
        ResourceGroup = $ResourceGroup
        Sku = $SKU
    
    }

    $Output
}