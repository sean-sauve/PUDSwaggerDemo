New-PSUEndpointDocumentation -Name 'User' -Description 'User API' -Authentication -Role @('Administrator') -Url '/docs/user' -Definition {
    [Documentation()]
    class ADUserResponse {
        [string]$DisplayName
        [string]$Mail
    }
}
New-PSUEndpointDocumentation -Name 'Group' -Description 'Group API' -Authentication -Role @('Administrator', 'ContosoVendorAPI') -Url '/docs/group' -Definition {
    [Documentation()]
    class ADGroupResponse {
        [string]$DisplayName
        [string]$Mail
    }
}
