<#
    .SYNOPSIS
    Gets AD information about a group.

    .DESCRIPTION
    Gets AD information about a group.

    .PARAMETER Name
    The name of the group

    .OUTPUTS
    200:
        Description: A successful return code.
        Content:
            application/json: ADGroupResponse

    204:
        Description: No content.  The group was not found.

    500:
        Description: Internal server error.

    .NOTES
    ===========================================================================
     Created with:  Visual Studio Code
     Created on:    11/6/23
     Created by:    Sean.Sauve
     Organization:  SAUSS
     Filename:      Group.ps1
    ===========================================================================
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$Name
)
$ScriptBlock = {
    try {
        $Users = Get-ADUser -Filter { name -eq $Name } -Properties @('DisplayName', 'mail')
        $Users | Select-Object -Property @('DisplayName', 'mail')
    } catch {}
}
$NewPUDApiResponseParam = @{
    'ScriptBlock'            = $ScriptBlock
    'UseResponseBodyWrapper' = $true
}
$Response = $null
$Response = New-PUDApiResponse @NewPUDApiResponseParam
$Response.Response
