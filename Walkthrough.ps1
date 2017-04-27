#https://github.com/ryandcoates/azureeverywheresamples

# Need to login to Azure
Login-AzureRMAccount

# Make sure correct subscription is selected
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionId ''


# Make a VM!
.\New-epAzureVM.ps1