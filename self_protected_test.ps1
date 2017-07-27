######################################################################################################################################
#   Scripted by LeeJunHwan, 2017-03-31 ~                                                                                             #
#   Self-Protected Test Case for MYPC Admin(+Standalone) and MYPC Agent(+Standalone)                                                 #
#   Function Details: Support to x86 and x64, Drivers Version Check,                                                                 #
#                     Delete Registrys, Delete Files, Kill Processes, Encrypt to *.ini                                               #
#   Don't worry about error occured. Because, self-protected is on!                                                                  #
#   You should run powershell with administrator privilege.                                                                          #
#   You must run after manual-test for just verification.                                                                            #
#   First, You must command to 'Set-ExecutionPolicy ByPass -Force'                                                                   #
#                                                                                                                                    #
#   Base Path: ~\APC2\                                                                                                               #
#   MYPC_EMS_AGENT: Policy Agent                                                                                                     #
#   MYPC_EMS_ADMIN: Policy Admin 4.0                                                                                                 #
#   MYPC_STANDALONE_AGENT: MyPC Agent                                                                                                #
#   MYPC_STANDALONE_ADMIN: MyPC Admin 4.0                                                                                            #
#   COMMON_DIR: C:\Program Files\Common Files\AhnLab\APCShield                                                                       #
######################################################################################################################################

function OS_VER_CHK {
    if ([System.IntPtr]::Size -eq 4) { "32" } else { "64" }
}


function DRIVER_VERSION_CHK {
    write-output "[+] DRIVER_VERSION_CHK"    

    foreach($driver in $drivers) {
        (Get-ChildItem $mypc_path -Include $driver -Recurse -ErrorAction SilentlyContinue) | foreach-object { " {0}`t {1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }     
        (Get-ChildItem $common_path -Include $driver -Recurse -ErrorAction SilentlyContinue) | foreach-object { " {0}`t {1}" -f $_.Name, [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }     
    }
}


function DELETE_REGISTRY {  
    write-output "[+] DELETE_REGISTRY"

    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AhnFlt2k" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AhnRec2k" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AhnRghNt" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\CdmDrvNt" -Name * -ErrorAction SilentlyContinue 
    
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\ATamptNt_APCShield" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\APCShield" -Name * -ErrorAction SilentlyContinue

    Remove-ItemProperty -Path "HKLM:\Software\AhnLab\APC2\Policy Admin 4.0" -Name * -ErrorAction SilentlyContinue 

    Remove-ItemProperty -Path "HKLM:\Software\AhnLab\APC2\Policy Agent" -Name * -ErrorAction SilentlyContinue 


    Remove-ItemProperty -Path "HKLM:\Software\AhnLab\APC2\ProactiveDefense" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\Software\AhnLab\DynaUpdate" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Ahnlab\APC2\Policy Agent" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Ahnlab\APC2\ProactiveDefense" -Name * -ErrorAction SilentlyContinue 
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Ahnlab\DynaUpdate" -Name * -ErrorAction SilentlyContinue 

    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Ahnlab\APC2\MyPC Agent" -Name * -ErrorAction SilentlyContinue
   
}


function DELETE_FILE {
    write-output "[+] DELETE_FILE"

    $sys_env_path = (get-childitem env:"SYSTEMROOT").Value    
    $sys_path = write-output $sys_env_path"\System32\Drivers\"

    $a =(get-childitem env:"SYSTEMROOT").Value
    $b = write-output $a"\system32\dirvers\"

    $dir_names = "Policy Admin 4.0", "Policy Agent", "MyPC Admin 4.0", "MyPC Agent"
    
    $ErrorView = "CategoryView" 
    
    foreach ($dir_name in $dir_names) {
        Remove-Item -Force -recurse $mypc_path$dir_name -ErrorAction SilentlyContinue
    }
    
    $driver = ''
    foreach($driver in $drivers) {      
        Remove-Item -Force -recurse $sys_path$drvier -ErrorAction SilentlyContinue
    }
}


function KILL_PROCESS {
    write-output "[+] KILL_PROCESS"
    #EMS_PROCESS
    $ems_process = "pasvc", "papd", "amagent", "patray", "AmMsgVW", "AmBlltn"

    #MYPC_PROCESS
    $mypc_process = "MYPCPaTray", "MYPCPaSvc", "MYPCSVC", "MYPCSVCX64"

    #EMS_ADMIN_PROCESS(Sam MYPC_STANDALONE_ADMIN_PROCESS)
    $admin_process = "APCConsole"

    $total_process = $ems_process, $mypc_process, $admin_process

    foreach($process in $total_process) {
        stop-process -name $process -ErrorAction SilentlyContinue -force 
    }
}


function INI_ENCRYPT_CHK {
    write-output "[+] INI_ENCRYPT_CHK"
    #random *.ini, *.ahc file open with notepad

    notepad "C:\Program Files (x86)\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"
    notepad "C:\Program Files\AhnLab\APC2\Policy Agent\ahc\BldInfo.ini.ahc"
    notepad "C:\Program Files (x86)\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"
    notepad "C:\Program Files\AhnLab\APC2\MyPC Agent\ahc\BldInfo.ini.ahc"
}


function ATAMPTNT_UNLOAD {
    fltmc unload AtamptNt_APCShield
}


function FOR_MYPC_INSPECT_VULN_STATUS {
    start bcdedit.exe "/set {current} nx AlwaysOff"
    netsh advfirewall set  currentprofile state off
}


function NETWORK_DISCONNECTION_CHK {
    start iexplore google.com # for network-disconnection check
}


function PROCESS_TERMINATE {
    $msgBoxInput =  [System.Windows.MessageBox]::Show("Notepad and iexplore terminate?", "Notepad and iexplore terminate", "YesNo", "Question")

    switch  ($msgBoxInput) {
        "Yes" {
            Stop-Process -Name notepad -ErrorAction SilentlyContinue -force 
            Stop-Process -Name iexplore -ErrorAction SilentlyContinue -force 
        }
        "No" {
            # No operation
        }
    }
}


function ERROR_PRINT {
    write-output $error
}


#####################################################################
############################# MAIN ##################################
#####################################################################

write-output "[+] Self-Protected Veification Test Script Start !"

if (OS_VER_CHK -eq 32) {
    $prg_path = (get-childitem env:"PROGRAMFILES").Value
}
else {
    $prg_path = (get-childitem env:"PROGRAMFILES(X86)").Value
}

$mypc_path = write-output $prg_path"\AhnLab\APC2\"
$common_path = "C:\Program Files\Common Files\AhnLab\APCShield" 
$drivers = "AhnRghNt.sys", "Amoncdw7.sys", "amoncdw8.sys", "AmonHKnt.sys", "Atamptnt.sys", "APrMDrv.sys", "ApRMctl.dll", "MPCIDRV.sys"

ATAMPTNT_UNLOAD
DELETE_REGISTRY
DELETE_FILE
KILL_PROCESS
INI_ENCRYPT_CHK
FOR_MYPC_INSPECT_VULN_STATUS
DRIVER_VERSION_CHK
NETWORK_DISCONNECTION_CHK
PROCESS_TERMINATE

write-output "[+] Self-Protected Veification Test Complete !"