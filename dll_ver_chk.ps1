#####################################################################
#   Scripted by LeeJunHwan, 2017-07-19 ~                            #
#   You should run powershell with administrator privilege.         #
#   You must run after manual-test for just verification.           #
#   First, You must command to 'Set-ExecutionPolicy ByPass -Force'  #
#####################################################################


function PROCESS_RUNNING_CHK {
    write-output "[+] PROCESS_RUNNING_CHK"

    $ProcessList = @(
	    "MYPC*", "PaTray", "PaSvc", "SVYVIEWER", "shieldstart", "PRVCCMD.EXE", "PRVCDRM.EXE", "PRVCMAN.EXE", `
        "PRVCSCAN.EXE", "PRVCSVC.EXE", "PRVCTOAST.EXE", "PRVCTOOLS.EXE", "PRVCUI.EXE", "PRVCZIP2.EXE", "APrM", `
        "PrvcMon", "PrvcPrtsc", "PrvcSession", "PrvcWmCmd", "PrvcOver", "PrvcWM"
    )

    $FoundedList = @("")

    do {
	    $ProcessesFound = Get-Process $ProcessList -ErrorAction SilentlyContinue
	    if ($ProcessesFound) {		        
            $FoundedList += foreach($i in $ProcessesFound) { $i.name }
            $FoundedList = ($FoundedList | sort -unique)
            write-host "Runned Process List:" $FoundedList 
		    Start-Sleep -m 500
	    }
    } while (1)
}


function MAIN {
    Import-Module -Name ".\STOP_PROCESS.psm1" -Force
    Import-Module -Name ".\DELETE_FILE.psm1" -Force
    Import-Module -Name ".\DELETE_REGISTRY.psm1" -Force

    write-output "[+] Start verify testing for Ahi2*.dll(in perf-test) !"
    
    $os_ver = OS_VER_CHK

    if ($os_ver -eq 32) {
        $prg_path = (get-childitem env:"PROGRAMFILES").Value
    }
    else {
        $prg_path = (get-childitem env:"PROGRAMFILES(X86)").Value
    }

    $mypc_path = write-output $prg_path"\AhnLab\APC2\"
    $common_path = "C:\Program Files\Common Files\AhnLab\APCShield" 
    $drivers = "AhnI2.dll", "AhnI2X64.dll", "PrvcBiz.dll", "PrvcBizx64.dll" 
    #"AhnRghNt.sys", "Amoncdw7.sys", "amoncdw8.sys", "AmonHKnt.sys", "Atamptnt.sys", "APrMDrv.sys", "ApRMctl.dll", "MPCIDRV.sys"


    DRIVER_VERSION_CHK
    PROCESS_RUNNING_CHK

    write-output "[+] Verify Testing for Ahi2*.dll(in perf-test) Complete !"
}


#####################################################################
############################# MAIN ##################################
#####################################################################

MAIN