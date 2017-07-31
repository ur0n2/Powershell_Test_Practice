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


function DELETE_REGISTRYS {  
    write-output "[+] DELETE_REGISTRYS"

    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\AhnFlt2k")
    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\AhnRec2k")
    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\AhnRghNt")
    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\CdmDrvNt")
    
    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\ATamptNt_APCShield")
    DELETE_REGISTRY("HKLM:\SYSTEM\CurrentControlSet\Services\APCShield")

    DELETE_REGISTRY("HKLM:\Software\AhnLab\APC2\Policy Admin 4.0")

    DELETE_REGISTRY("HKLM:\Software\AhnLab\APC2\Policy Agent")


    DELETE_REGISTRY("HKLM:\Software\AhnLab\APC2\ProactiveDefense")
    DELETE_REGISTRY("HKLM:\Software\AhnLab\DynaUpdate")
    DELETE_REGISTRY("HKLM:\SOFTWARE\WOW6432Node\Ahnlab\APC2\Policy Agent")
    DELETE_REGISTRY("HKLM:\SOFTWARE\WOW6432Node\Ahnlab\APC2\ProactiveDefense")
    DELETE_REGISTRY("HKLM:\SOFTWARE\WOW6432Node\Ahnlab\DynaUpdate")

    DELETE_REGISTRY("HKLM:\SOFTWARE\Ahnlab\APC2\MyPC Agent")
}


function DELETE_FILES {
    write-output "[+] DELETE_FILES"

    $sys_env_path = (get-childitem env:"SYSTEMROOT").Value    
    $sys_path = write-output $sys_env_path"\System32\Drivers\"

    $a =(get-childitem env:"SYSTEMROOT").Value
    $b = write-output $a"\system32\dirvers\"

    $dir_names = "Policy Admin 4.0", "Policy Agent", "MyPC Admin 4.0", "MyPC Agent"
    
    $ErrorView = "CategoryView" 
    
    foreach ($dir_name in $dir_names) {
        DELETE_FILE($mypc_path$dir_name)
    }
    
    $driver = ''
    foreach($driver in $drivers) {      
        DELETE_FILE($sys_path$drvier)
    }
}


function KILL_PROCESSES {
    write-output "[+] KILL_PROCESSES"
    #EMS_PROCESS
    $ems_process = "pasvc", "papd", "amagent", "patray", "AmMsgVW", "AmBlltn"

    #MYPC_PROCESS
    $mypc_process = "MYPCPaTray", "MYPCPaSvc", "MYPCSVC", "MYPCSVCX64"

    #EMS_ADMIN_PROCESS(Sam MYPC_STANDALONE_ADMIN_PROCESS)
    $admin_process = "APCConsole"

    $total_process = $ems_process, $mypc_process, $admin_process

    foreach($process in $total_process) {
        STOP_PROCESS($process)
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
    $msgBoxInput =  [System.Windows.MessageBox]::Show("Notepad and iexplore terminate?", "¸»ÇØ Yes or No", "YesNo", "Question")

    switch  ($msgBoxInput) {
        "Yes" {
            STOP_PROCESS(notepad)
            STOP_PROCESS(iexplore)
        }
        "No" {
            # No operation
        }
    }
}


function ERROR_PRINT {
    write-output $error
}


function MAIN {
    write-output "[+] Self-Protected Veification Test Script Start !"

    Import-Module -Name ".\STOP_PROCESS.psm1" -Force
    Import-Module -Name ".\DELETE_FILE.psm1" -Force
    Import-Module -Name ".\DELETE_REGISTRY.psm1" -Force

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
    DELETE_REGISTRYS
    DELETE_FILES
    KILL_PROCESSES
    INI_ENCRYPT_CHK
    FOR_MYPC_INSPECT_VULN_STATUS
    DRIVER_VERSION_CHK
    NETWORK_DISCONNECTION_CHK
    PROCESS_TERMINATE

    write-output "[+] Self-Protected Veification Test Complete !"
}


#####################################################################
############################# MAIN ##################################
#####################################################################

MAIN