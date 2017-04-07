#   LeeJunHwan, 2017-03-31
#   Used to: powershell Start-Process powershell_ISE -Verb runas 
#   Self-Protected Test Case for MYPC Admin(+Solo), MYPC Agent(+Solo)
#   Detail Function: Support to x86, x64, Driver Version Check, Delete Registry, Delete File, Kill Process, Encrypt to *.ini 
#   error result is correct. Because of Self-Protected is ON!
#   run with powershell Start-Process powershell -Verb runas
#AhnRghNt.sys OR Amoncdw7.sys OR amoncdw8.sys OR AmonHKnt.sys OR Atamptnt.sys OR APrMDrv.sys OR ApRMctl.dll OR MPCIDRV.sys
function OS_VER_CHK {
    if ([System.IntPtr]::Size -eq 4) { "32" } else { "64" }
}


#write-output $prg_path

<#
~\APC2\
#MYPC_EMS_AGENT: Policy Agent
#MYPC_EMS_ADMIN: Policy Admin 4.0
#MYPC_SOLO_AGENT: MyPC Agent
#MYPC_SOLO_ADMIN: MyPC Admin 4.0

#COMMON_DIR: C:\Program Files\Common Files\AhnLab\APCShield

#>

function DRIVER_VERSION_CHK{
    <#
    ~\APC2\
    #MYPC_EMS_AGENT: Policy Agent
    #MYPC_EMS_ADMIN: Policy Admin 4.0
    #MYPC_SOLO_AGENT: MyPC Agent
    #MYPC_SOLO_ADMIN: MyPC Admin 4.0
    #>
    write-output "* DRIVER_VERSION_CHK"    

    foreach($driver in $drivers){
        (Get-ChildItem $mypc_path -Include $driver -Recurse) | foreach-object { "{0}`t{1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }     
        (Get-ChildItem $common_path -Include $driver -Recurse) | foreach-object { "{0}`t{1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }     
    }
}

function DELETE_REGISTRY{
    write-output "* DELETE_REGISTRY"
        try {
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

   
        }
        catch [System.Management.Automation.ActionPreferenceStopException], [RemoteException] {            
            write-output "registry try is catch"
        }

}

function DELETE_FILE{
    write-output "* DELETE_FILE"

    $sys_env_path = (get-childitem env:"SYSTEMROOT").Value    
    $sys_path = write-output $sys_env_path"\System32\Drivers\"

    $a =(get-childitem env:"SYSTEMROOT").Value
    $b = write-output $a"\system32\dirvers\"

    #$mypc_path
    $dir_names = "Policy Admin 4.0", "Policy Agent", "MyPC Admin 4.0", "MyPC Agent"
    
    $ErrorView = "CategoryView" 
    
    foreach ($dir_name in $dir_names){
        #write-output $mypc_path$dir_name
        try{
            Remove-Item -Force -recurse $mypc_path$dir_name
        }
        catch [System.Management.Automation.ActionPreferenceStopException] {           # [System.ArgumentException] [System.Management.Automation.PSInvalidOperationException] [System.Management.Automation.ItemNotFoundException]  
            write-output "first try is catch" #Permission denied error
           # write-output $ErrorActionPreference
           # write-output $ErrorView
           # $error[0] | format-list -property "Exception" -force

        }
    }

    $driver = '' #already used iterator
    foreach($driver in $drivers){        
        write-output $sys_path$driver
        try{
            Remove-Item -Force -recurse $sys_path$drvier
        }
        catch [System.Management.Automation.ActionPreferenceStopException] {            
            write-output "second try is catch"
        }
    }

    <#
    
    #EMS ADMIN
    Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\Policy Admin 4.0\"
    Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\Policy Admin 4.0\"    

    #EMS AGENT
    Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\Policy Agent\"
    Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\Policy Agent\"

    #MYPC SOLO ADMIN
    Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\MyPC Admin 4.0\"
    Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\MyPC Admin 4.0\"
    
    #MYPC SOLO AGENT
    Remove-Item -Force -recurse "C:\Program Files\AhnLab\APC2\MyPC Agent\"
    Remove-Item -Force -recurse "C:\Program Files (x86)\AhnLab\APC2\MyPC Agent\"
    
    #COMMON SHIELD DIRECTORY
    Remove-Item -Force -recurse "C:\Program Files\Common Files\AhnLab\APCShield\"

    #SELF PROTECTED DRIVERS
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnFlt2k.sys
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnRghNt.sys
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\CdmDrvNt.sys
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AhnRec2k.sys
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AMonCDW7.sys 
    Remove-Item -Force -recurse  C:\Windows\System32\Drivers\AMonCDW8.sys 

    #>
}

function KILL_PROCESS{
    # Get-WmiObject win32_process |?{$_.getowner().user -eq "Dave"} |%{$_.Terminate()}
    write-output "* KILL_PROCESS"

    <#
    #EMS_PROCESS
    taskkill /f /IM pasvc.exe 
    taskkill /f /IM papd.exe 
    taskkill /f /IM amagent.exe 
    taskkill /f /IM patray.exe 
    taskkill /f /IM AmMsgVW.exe 
    taskkill /f /IM AmBlltn.exe

    #MYPC_PROCESS
    taskkill /f /IM MYPCPaTray.exe
    taskkill /f /IM MYPCPaSvc.exe
    taskkill /f /IM MYPCSVC.exe
    taskkill /f /IM MYPCSVCX64.EXE

    #EMS_ADMIN_PROCESS(Sam MYPC_SOLO_ADMIN_PROCESS)
    taskkill /f /IM APCConsole.exe 
    #>

    #EMS_PROCESS
    $ems_process = "pasvc", "papd", "amagent", "patray", "AmMsgVW", "AmBlltn"

    #MYPC_PROCESS
    $mypc_process = "MYPCPaTray", "MYPCPaSvc", "MYPCSVC", "MYPCSVCX64"

    #EMS_ADMIN_PROCESS(Sam MYPC_SOLO_ADMIN_PROCESS)
    $admin_process = "APCConsole"

    $total_process = $ems_process, $mypc_process, $admin_process

    foreach($process in $total_process){
        #write-output $process 
        stop-process -name $process -force
    }
}

function INI_ENCRYPT_CHK{
    write-output "* INI_ENCRYPT_CHK"
    #random 3 file open with notepad
    #*.ini, *.ahc
    notepad "C:\Program Files (x86)\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"
    #$mypc_path
    notepad "C:\Program Files\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"

    notepad "C:\Program Files (x86)\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"
    notepad "C:\Program Files\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"

}

#MAIN
$os_ver = OS_VER_CHK

if ($os_ver -eq 32) {
    $prg_path = (get-childitem env:"PROGRAMFILES").Value
}
else{
    $prg_path = (get-childitem env:"PROGRAMFILES(X86)").Value
}

$mypc_path = write-output $prg_path"\AhnLab\APC2\"
$common_path = "C:\Program Files\Common Files\AhnLab\APCShield" #do not divide into x86/x64
$drivers = "AhnRghNt.sys", "Amoncdw7.sys", "amoncdw8.sys", "AmonHKnt.sys", "Atamptnt.sys", "APrMDrv.sys", "ApRMctl.dll", "MPCIDRV.sys"

fltmc unload AtamptNt_APCShield

DRIVER_VERSION_CHK
DELETE_REGISTRY
DELETE_FILE
KILL_PROCESS
INI_ENCRYPT_CHK

start bcdedit.exe "/set {current} nx AlwaysOff"
netsh advfirewall set  currentprofile state off
start iexplore google.com
DRIVER_VERSION_CHK
echo "* Complete"

#todo: error handling?댁꽌 ?뚯씪??젣?????꾨┛?툄 
#ini 寃쎈줈 泥섎━ 湲고? 媛덈Т由?

<#

System.Management.Automation.ActionPreferenceStopException
 get-help about_preference_variables | more

get-help about_commonparameters

get-help about_aoutomatic_variables

여기서 remove-item과 같은 시스템 리소스 삭제를 할경우에 -confirm의 기본 옵션을 줄 수 있는데 그때 에러시 생성되는 에러의 자동변수를 확인할 수 있음 이때 permission denied는 UnautohorizedAccessException으로 예외가 발생하는데 try...catch에서 catch가 actionpreferencestopexception으로 핸들링 해야 함. 콘솔이 멈춰버린 경우라 서...? -> operationstopped상태의 카테고리라서 

하지만 기본 에러내용에서는 actionpreferencestopexception을 확인할 수 없으므로 공통파라미터나 자동변수에서 찾아봐야겠음

remove-item "C:\Program Files\AhnLab\APC2\MyPC Admin 4.0\AhnI2.dll"

카테고리가 stop이라서 ㅁctionpreferencestopexception이라는 enum형 action list가 있나봄 msdn

보통의 try..catch는 system.io.ioexception 이나 system.net.webexception, 

오류유형(category)를 봐야함 

Windows PowerShell SDK의 
        "ErrorCategoryInfo class(ErrorCategoryInfo 클래스)"를

#>