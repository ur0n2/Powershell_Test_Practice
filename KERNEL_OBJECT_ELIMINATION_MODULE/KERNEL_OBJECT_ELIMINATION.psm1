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


function DELETE_FILE ($file_name) {
    try {
        Remove-Item -Path $file_name -Recurse -EA Stop -Force
    }
    catch { 
        if ($Global:Error | findstr /i /c:"CloseError" /c:"액세스가" /c:"PermissionDenied" ) {
            write-host "[" $file_name "]" "is Access Denied"
        }
    }
    finally {
        $Global:Error.clear()
        $Global:ErrorActionPreference = "Continue"
    }
}


function DELETE_REGISTRY ($registry_path) {
    try {
        Remove-ItemProperty -Path $registry_path -Name * -EA Stop -Force        
    }
    catch { 
        if ($Global:Error | findstr /i /c:"CloseError" /c:"액세스가" /c:"PermissionDenied" ) {
            write-host "[" $registry_path "]" "is Access Denied"
        }
    }
    finally {
        $Global:Error.clear()
        $Global:ErrorActionPreference = "Continue"
    }
}