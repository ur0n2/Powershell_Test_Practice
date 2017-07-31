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