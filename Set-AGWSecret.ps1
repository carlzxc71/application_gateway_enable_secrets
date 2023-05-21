param(
    [string]$rg = "",
    [string]$application_gw = "",
    [string]$uid = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/MyManagedIdentity",
    [string]$keyvault = "",
    [string]$certificate_name = ""
)

# Get the Application Gateway we want to modify
$appgw = Get-AzApplicationGateway -Name $application_gw -ResourceGroupName $rg

# Specify the resource id to the user assigned managed identity - This can be found by going to the properties of the managed identity
Set-AzApplicationGatewayIdentity -ApplicationGateway $appgw -UserAssignedIdentityId $uid

# Get the secret ID from Key Vault
$secret = Get-AzKeyVaultSecret -VaultName $keyvault -Name $certificate_name
$secretId = $secret.Id.Replace($secret.Version, "") # Remove the secret version so AppGW will use the latest version in future syncs

# Specify the secret ID from Key Vault 
Add-AzApplicationGatewaySslCertificate -KeyVaultSecretId $secretId -ApplicationGateway $appgw -Name $secret.Name

# Commit the changes to the Application Gateway
Set-AzApplicationGateway -ApplicationGateway $appgw