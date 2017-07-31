function FILE_VERSION_CHK
{
    Param
    (
        [Parameter(Mandatory=$true)]
        $files,
        [Parameter(Mandatory=$true)]
        $files_path
    )

    foreach($file in $files) {
        (Get-ChildItem -File -path $files_path -include $file -Recurse -EA SilentlyContinue) `
        | foreach-object { " {0}`t {1}" -f $_.Name, `
        [System.Diagnostics.FileVersionInfo]::GetVersionInfo($_).FileVersion }     
    }
}
