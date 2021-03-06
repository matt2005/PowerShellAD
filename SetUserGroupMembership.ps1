#REQUIRES -Version 2.0

<# 
.SYNOPSIS  
	Add or Remove users from groups defined in a CSV file

.DESCRIPTION  
	Add or Remove users from groups defined in a CSV file

	The CSV file format is as follows:

	UserName,Group
	MyUserExample,MyADGroupExample
	MyUserExample,MyADGroupExample2
	MyUserExample2,MyADGroupExample
	MyUserExample3,MyADGroupExample2

.PARAMETER file
	Name of the CSV file specifying the users and groups (required)

.PARAMETER action
	The action to perform:

		add - Adds the user to the specified group (default)
		remove - Remove the user for the specified group

.NOTES  
    File Name      : SetUserGroupMembership.ps1
    Author         : Allan Scullion
    Prerequisite   : PowerShell V2, ActiveDirectory module

.EXAMPLE  
    .\SetUserGroupMembership.ps1 -file Test.csv -action add

.EXAMPLE    
    .\SetUserGroupMembership.ps1 -file Test.csv -action remove
#>

param (
	[parameter(Mandatory=$true)]
	[alias("f")]
    [string]$file = $(throw "-file is required."),
	[parameter(Mandatory=$false)]
	[alias("a")]
    [string]$action = "add"
)

if (Test-Path $file) {

	$dataSource = Import-Csv $file

	foreach($dataRecord in $dataSource)
	{
		$user = $dataRecord.UserName
		$group = $dataRecord.Group

		if ($action -eq "remove") 
		{
			Write-Host "Removing $user from $group"
			Remove-ADGroupMember -Confirm:$false -Identity $group -Member $user
		} 
		else 
		{
			Write-Host "Adding $user to $group"
			Add-ADGroupMember -Confirm:$false -Identity $group -Member $user
		}
	}
} 
else 
{
	Write-Host "ERROR:$file does not exist."
}
