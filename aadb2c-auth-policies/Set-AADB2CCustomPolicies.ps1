[Cmdletbinding()]
Param(
    [Parameter(Mandatory = $true)][string]$ClientID,
    [Parameter(Mandatory = $true)][string]$ClientSecret,
    [Parameter(Mandatory = $true)][string]$TenantId
)

function Get-AccessToken {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)][string]$ClientID,
        [Parameter(Mandatory = $true)][string]$ClientSecret,
        [Parameter(Mandatory = $true)][string]$TenantId
    )
    
    try {
        $body = @{
            grant_type    = "client_credentials";
            scope         = "https://graph.microsoft.com/.default";
            client_id     = $ClientID;
            client_secret = $ClientSecret
        }
    
        $response = Invoke-RestMethod -Uri https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token -Method Post -Body $body
        
        return $response.access_token
    }
    catch {
        $_
        exit
    }
}

$token = Get-AccessToken -ClientID $ClientID -ClientSecret $ClientSecret -TenantId $TenantId
