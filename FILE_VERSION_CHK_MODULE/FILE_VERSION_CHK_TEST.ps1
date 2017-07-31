Remove-Module -Name FILE_VERSION_CHK -Force -ErrorAction SilentlyContinue
Import-Module -Name ".\FILE_VERSION_CHK.psm1" -Force

Clear-Variable z_*
$files = @("kernel32.dll", "ntdll.dll", "gdi32.dll", "user32.dll")
$files_path = "C:\windows\system32\"

FILE_VERSION_CHK $files $files_path 