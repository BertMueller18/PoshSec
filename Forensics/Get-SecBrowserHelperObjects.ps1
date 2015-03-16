﻿function Get-SecBrowserHelperObjects 
{
  [CmdletBinding()]
  param()

  begin{
    Write-Verbose -Message 'Connecting to HKEY_CLASSES_ROOT'
    $null = New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR

    Write-Verbose -Message 'Creating array to hold Browser Helper Objects'
    $items = @{}
  }

  process{
    Write-Verbose -Message 'Getting registry values for the Browser Helper Objects key.'
    $Key = Get-SecRegistryProperties -Key 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects'
    Write-Verbose -Message 'Getting Registry Class IDs'
    $BHOs = $Key | Select-Object -Property PSChildName
    
    Write-Verbose -Message 'Going through all possible browser helper objects.'
    foreach ($bho in $BHOs) 
    {
      Write-Verbose -Message 'Creating PS Object'
      $obj = New-Object -TypeName PSObject
      Write-Verbose -Message "Setting CLSID to $($bho.PSChildName)"
      Add-Member -InputObject $obj -MemberType NoteProperty -Name 'CLSID' -Value $bho.PSChildName
      
      Write-Verbose -Message 'Pushing current console location to stack.'
      Push-Location
      Write-Verbose -Message 'Changing location to HKCR:\CLSID'
      Set-Location -Path 'HKCR:\CLSID'
      Write-Verbose -Message 'Setting Name to name of browser helper object.'
      Add-Member -InputObject $obj -MemberType NoteProperty -Name 'Name' -Value $(Get-Item -Path $bho.PSChildName |
        Get-ItemProperty |
      Select-Object -ExpandProperty '(default)')
      Write-Verbose -Message 'Setting console back to original location.'
      Pop-Location

      Write-Verbose -Message 'Writing Browser Helper Object'
      Write-Output -InputObject $obj
    }
  }
  end {
    Write-Verbose -Message 'Removing HKCR Drive.'
    $null = Remove-PSDrive -Name HKCR
  }
  <#
    .SYNOPSIS
    This function gets Internet Explorer browser helper objects installed on a system.
    Author: Matthew Johnson (@mwjcomputing)
    Project: PoshSec/Forensics
    License: BSD-3
    Required Dependencies: None
    Optional Dependencies: None
    .DESCRIPTION
    Get-SecBrowserHelperObjects returns the browser helper objects installed on a system.
    .INPUTS
    None
    .OUTPUTS
    PSObject
    .EXAMPLE
    Get-SecBrowserHelperObjects
    .NOTE
    This function is part of the PoshSec PowerShell Module's Forensics submodule.
    .LINK
    http://www.poshsec.com/
    .LINK
    https://github.com/PoshSec
  #>
}
