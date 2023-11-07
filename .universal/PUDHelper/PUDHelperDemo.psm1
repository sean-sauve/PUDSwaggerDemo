<#
	.NOTES
	===========================================================================
	 Created on:   	1 December 2022
	 Created by:   	Sean Sauve
	 Organization: 	SAUSS
	===========================================================================
	.DESCRIPTION
	A module containing functions to help PowerShell Universal and dashboards
#>
$PublicFolders = @(
	'API'
)
$PrivateFolders = @()
$PublicFunctions = foreach ($Folder in $PublicFolders) {
	$Files = @()
	$Files = Get-ChildItem -Name "$PSScriptRoot\$Folder\*.ps1"
	foreach ($File in $Files) {
		$FunctionName = [IO.Path]::GetFileNameWithoutExtension($File)
		. "$PSScriptRoot\$Folder\$FunctionName"
		$FunctionName
	}
}
$PrivateFolders = @()
foreach ($Folder in $PrivateFolders) {
	$Files = @()
	$Files = Get-ChildItem -Name "$PSScriptRoot\$Folder\*.ps1"
	foreach ($File in $Files) {
		$FunctionName = [IO.Path]::GetFileNameWithoutExtension($File)
		. "$PSScriptRoot\$Folder\$FunctionName"
	}
}
Export-ModuleMember -Function $PublicFunctions -Alias * -Cmdlet *
