function STOP_PROCESS ($process_name) {    
    try {
        stop-process -Name $process_name -EA Stop -Force
    }
    catch { 
        if ($Global:Error | findstr /i /c:"CloseError" /c:"액세스가" /c:"PermissionDenied" ) {
            write-host "[" $process_name "]" "is Access Denied"
        }
    }
    finally {
        $Global:Error.clear()
        $Global:ErrorActionPreference = "Continue"
    }
}
