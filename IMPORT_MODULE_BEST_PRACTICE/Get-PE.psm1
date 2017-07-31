filter Get-PE
{
     param($extension = ('.exe', '.dll', '.sys', '.scr', '.com')
     )
     
     $_ | Where-Object {  $extension -contains $_.Extension} 
}
