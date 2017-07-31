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