function OS_VER_CHK {
    if ([System.IntPtr]::Size -eq 4) { "32" } else { "64" }
}
