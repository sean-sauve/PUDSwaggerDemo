Set-PSUAuthenticationMethod -Disabled -ScriptBlock {
    param (
        [PSCredential]$Credential
    )
    New-PSUAuthenticationResult -UserName $Credential.UserName -Success -Claims {
        (Get-ADUser -Identity $Credential.UserName -Properties memberof).memberof | Get-ADGroup | Select-Object -ExpandProperty name | ForEach-Object {
            New-PSUAuthorizationClaim -Type 'Role' -Value $_
        }
    }
}
