New-PSURole -Name 'Administrator' -Description 'Administrator' -Policy {
	#Can access all endpoints and documentation
    param (
        $User
    )
    $User.Identity.Name -like 'sean.sauve*'
}
New-PSURole -Name 'ContosoVendorAPI' -Description 'User' -Policy {
	#Can only access /api/ad/group endpoint and it's documentation
    param (
        $User
    )
    $User.Identity.Name -like 'test.sauve*'
}
