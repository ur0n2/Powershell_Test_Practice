Remove-Module -Name function_test -Force -ea SilentlyContinue
Remove-Module -Name Get-PE -Force -ea SilentlyContinue


Import-Module -Name .\function_test.psm1 -Force
Import-Module -Name .\Get-PE.psm1 -Force
echo123("Powershell module test - ur0n2")

#(gci $env:windir\system32 -ea SilentlyContinue) | Get-PE
(gci $env:windir -ea SilentlyContinue) | Get-PE .ini
add2 2 3
whoareu
Get-Process | Where-Object { process_2 e }
get-help add2 -detailed
1,2,4 | Get-PipelineBeginEnd 

#https://4sysops.com/archives/the-powershell-function-parameters-data-types-return-values/
