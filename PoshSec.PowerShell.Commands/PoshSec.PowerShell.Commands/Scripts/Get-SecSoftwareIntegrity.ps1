function Get-SecSoftwareIntegrity
{
    <#
    .Synopsis
        Baselines the installed software to an XML file.
    .Description
        Baselines the installed software to an XML file.
        
        CSIS 20 Critical Security Controls for Effective Cyber Defense excerpt:
		Devise a list of authorized software that is required in the enterprise for each type of system, including servers, workstations, and laptops of various kinds and uses. This list should be tied to file integrity checking software to validate that the software 
    .Example
        Get-InstalledSoftware
    .Link
        https://github.com/organizations/PoshSec
    #>

	[string]$computer = Get-Content env:ComputerName
	[string]$filename = Get-DateISO8601 -Prefix ".\$computer-Integrity" -Suffix ".xml"
	Get-SecFileIntegrity | Export-Clixml -Path $filename
    
    if(-NOT(Test-Path ".\$computer-Integrity-Baseline.xml"))
    {
	    Rename-Item $filename "$computer-Integrity-Baseline.xml"
   	    Write-Warning "The baseline file for this computer has been created, please run this script again."
        Invoke-Expression $MyInvocation.MyCommand
	    
    }

	
}
