Import-Module $PSScriptRoot\..\poshsec.psd1

Describe 'PoshSec Module Load' {
  It 'There should be 64 commands.' {
    $Commands = @(Get-Command -Module 'PoshSec' | Select-Object -ExpandProperty Name)
    $Commands.Count | Should Be 64
  }
}
