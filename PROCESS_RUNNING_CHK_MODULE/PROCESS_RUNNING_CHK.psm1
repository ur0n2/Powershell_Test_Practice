function PROCESS_RUNNING_CHK {
    <#
    .Synopsis
    실행중인 프로세스 체크 함수
    
    .Description
    옵션에 따라서 현재 실행중인 특정 프로세스 리스트를 출력한다.

    .Parameter Role
    [string]$ProcessList: 특정 프로세스 리스트
    [int]$seconds: 프로세스 리스트 스캔 주기(초)
    [int]$accumulation: 현재 프로세스 리스트 누적 여부
                        0: Print for certain processes in current running processes list
                        1: Accumulate to running processes list until the stop this script

    .Example
    PROCESS_RUNNING_CHK $ProcessList 0.5 0
    
    설명 - 스크립트 실행 중 calc, notepad 종료
    -----------   
    [+] Running Process List: [calc] [explorer] [notepad]
    [+] Running Process List: [explorer] [notepad]
    [+] Running Process List: [explorer] 
    ...
    ...
    

    PS C:\>PROCESS_RUNNING_CHK $ProcessList 1 1
    
    설명 - 스크립트 실행 중 calc, notepad 실행
    -----------
    [+] Running Process List: [explorer]
    [+] Running Process List: [explorer] [notepad]
    [+] Running Process List: [calc] [explorer] [notepad]
    ...
    ...

     
    .Link
    https://github.com/ur0n2/Powershell__Script_for_SW_Testing

    #>
    param (
        [object]$ProcessList, #Array Object
        [int]$seconds,
        [int]$accumulation
    )
    
    $FoundedList = @("")



    do {
	    $ProcessesFound = Get-Process $ProcessList -ErrorAction SilentlyContinue
	    if ($ProcessesFound) {		        
            if ($accumulation -eq 0) {
                $FoundedList = foreach($i in $ProcessesFound) { "[" + $i.name + "]" } #Accumulation is 0
            }
            else {
                $FoundedList += foreach($i in $ProcessesFound) { "[" + $i.name + "]" } #Accumulation os 1
            }
            $FoundedList = ($FoundedList | sort -unique)
            write-host "[+] Running Process List:" $FoundedList 
		    Start-Sleep -s $seconds
	    }
    } while (1)
}