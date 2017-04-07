#	2017-03-31, LeeJunHwan
#	include mypc_solo, EMS_integrate (x86/x64), driver version check
#	powershell Start-Process powershell_ISE -Verb runas
#	del alternative to remove-item -force -recurse(non-interactive option) and find file is get-childitem no write to full path
#	if ([System.IntPtr]::Size -eq 4) { "32-bit" } else { "64-bit" }

function OS_VER_CHK {
	if ([System.IntPtr]::Size -eq 4) { "32" } else { "64" }
}

$os_ver=OS_VER_CHK

if ($os_ver -eq 32) {
	$prg_path = (get-childitem env:"PROGRAMFILES").Value
}
else{
	$prg_path = (get-childitem env:"PROGRAMFILES(X86)").Value
}

#write-output $prg_path

function DRIVER_CHK{
#MYPCUI_EMS
#MYPCUI_ADMIN
#MYPCUI_EMS
#MYPCUI_SOLO
}

function TEST_CASE {
#MYPCUI_EMS
#MYPCUI_ADMIN
#MYPCUI_EMS
#MYPCUI_SOLO
}
<#
(Get-ChildItem "C:\Program Files (x86)\AhnLab\APC2\" -Include AhnRghNt.sys -Recurse).VersionInfo
(Get-ChildItem "C:\Program Files\AhnLab\APC2\" -Include AhnRghNt.sys -Recurse).VersionInfo
(Get-ChildItem "C:\Program Files\Common Files\AhnLab\" -Include Atamptnt.sys -Recurse).VersionInfo

Amoncdw7.sys 
amoncdw8.sys 
AmonHKnt.sys 
Atamptnt.sys 
APrMDrv.sys 
ApRMctl.dll 
MPCIDRV.sys
#>


fltmc unload AtamptNt_APCShield

Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\Policy Agent\"
Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\Policy Agent\"
Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\MyPC Agent\"
Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\MyPC Agent\"

Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\MyPC Admin 4.0\"
Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\MyPC Admin 4.0\"

Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnFlt2k.sys
Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnRghNt.sys
Remove-Item -Force -recurse  C:\Windows\System32\Drivers\CdmDrvNt.sys
Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnRec2k.sys
Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AMonCDW7.sys 
Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AMonCDW8.sys 

Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\Policy Admin 4.0\"
Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\Policy Admin 4.0\"
Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\Policy Admin 4.0\"

taskkill /f /IM pasvc.exe 
:echo "1"
taskkill /f /IM papd.exe 
taskkill /f /IM amagent.exe 
taskkill /f /IM patray.exe 
taskkill /f /IM AmMsgVW.exe 
taskkill /f /IM AmBlltn.exe
:echo "2"

taskkill /f /IM MYPCPaTray.exe
taskkill /f /IM MYPCPaSvc.exe
taskkill /f /IM MYPCSVC.exe
taskkill /f /IM MYPCSVCX64.EXE

taskkill /f /IM APCConsole.exe 

Remove-Item -Force -recurse "C:\Program Files\Common Files\AhnLab\APCShield\"

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AhnFlt2k" /f 
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AhnRec2k" /f 
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AhnRghNt" /f 
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\CdmDrvNt" /f 
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\ATamptNt_APCShield" /f 
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\APCShield" /f

reg delete "HKEY_LOCAL_MACHINE\Software\AhnLab\APC2\Policy Admin 4.0" /f 

reg delete "HKEY_LOCAL_MACHINE\Software\AhnLab\APC2\Policy Agent" /f 


reg delete "HKEY_LOCAL_MACHINE\Software\AhnLab\APC2\ProactiveDefense" /f 
reg delete "HKEY_LOCAL_MACHINE\Software\AhnLab\DynaUpdate" /f 
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ahnlab\APC2\Policy Agent" /f 
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ahnlab\APC2\ProactiveDefense" /f 
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ahnlab\DynaUpdate" /f 

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Ahnlab\APC2\MyPC Agent" /f

notepad "C:\Program Files (x86)\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"
notepad "C:\Program Files\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"
notepad "C:\Program Files (x86)\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"
notepad "C:\Program Files\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"

echo "complete"

(Get-ChildItem "C:\Program Files (x86)\AhnLab\APC2\" -Include AhnRghNt.sys -Recurse) | foreach-object { "{0}`t{1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion } # $_.FullName,
(Get-ChildItem "C:\Program Files\AhnLab\APC2\" -Include AhnRghNt.sys -Recurse) | foreach-object { "{0}`t{1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }
(Get-ChildItem "C:\Program Files\Common Files\AhnLab\" -Include Atamptnt.sys -Recurse) | foreach-object { "{0}`t{1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }

echo "complete"
echo "complete"
echo "complete"

