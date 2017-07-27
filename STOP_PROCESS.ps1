function STOP_PROCESS ($process_name) {
    try {
        write-host "[+] try"
        stop-process -name $process_name -force -EA Stop #-PassThru  #-ErrorAction SilentlyContinue
    }
    catch {
        write-host "[+] catch"
        #write-host $_.exception
        $b = $error
        
        $b = $b | findstr "CloseError"
        
        
        if ($b -match "CloseError" ) {
            write-host "[" $process_name "]" "is Access Denied"
        }
    }
    finally {
        write-host "[+] finally" 
        $error.clear()
        #continue
    }
}

STOP_PROCESS("idle")
#stop-process -name idle -force 