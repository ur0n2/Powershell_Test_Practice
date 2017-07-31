Remove-Module -Name PROCESS_RUNNING_CHK -Force -ErrorAction SilentlyContinue
Import-Module -Name .\PROCESS_RUNNING_CHK.psm1 -Force

Get-Help PROCESS_RUNNING_CHK -Detailed

$ProcessList = @("explorer", "notepad", "cal*") 

# Print for certain processes in current running processes list
PROCESS_RUNNING_CHK $ProcessList 1 0

# Accumulate to running processes list until the stop this script
#PROCESS_RUNNING_CHK $ProcessList 1 1