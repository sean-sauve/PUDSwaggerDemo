<#
    .SYNOPSIS
    Gets AD information about a user.

    .DESCRIPTION
    Gets AD information about a user.

    .PARAMETER UserPrincipalName
    The user's AD UserPrincipalName.

    .OUTPUTS
    200:
        Description: A successful return code.
        Content:
            application/json: ADUserResponse

    204:
        Description: No content.  The user was not found.

    500:
        Description: Internal server error.

    .NOTES
    ===========================================================================
     Created with:  Visual Studio Code
     Created on:    11/6/23
     Created by:    Sean.Sauve
     Organization:  SAUSS
     Filename:      User.ps1
    ===========================================================================
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)
$ScriptBlock = {
    try {
        $Users = Get-ADUser -Filter { userPrincipalName -eq $UserPrincipalName } -Properties @('DisplayName', 'mail')
        $Users | Select-Object -Property @('DisplayName', 'mail')
    } catch {}
}
$NewPUDApiResponseParam = @{
    'ScriptBlock'            = $ScriptBlock
    'UseResponseBodyWrapper' = $true
}
$Response = $null
$Response = New-PUDDemoApiResponse @NewPUDApiResponseParam
$Response.Response
