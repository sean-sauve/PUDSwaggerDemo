New-PSUEndpoint -Url "/api/ad/User" -Description "Get AD user" -Method @('GET') -Authentication -Role @('Administrator') -Path "Endpoints\ad\User.ps1" -Tag "User" -Documentation "User"
New-PSUEndpoint -Url "/api/ad/Group" -Description "Get AD group" -Method @('GET') -Authentication -Role @('Administrator', 'ContosoVendorAPI') -Path "Endpoints\ad\Group.ps1" -Tag "Group" -Documentation "Group"
