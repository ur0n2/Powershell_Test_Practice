function echo123
{
    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [String]$text
    )
    write-host "[echo123]"
    Write-Host $text
}

function add2{
    <#
    .Synopsis
    덧셈 함수(Practice for About Comment Based Help)
    
    .Description
    첫번째 인자와 두번째 인자를 더한다.

    .Parameter Role
    첫번째 인자, 두번째 인자

    .Example
    add2 2 5
    7

    설명
    -----------
    2 + 5 = 7
    
        
    .Link
    https://github.com/ur0n2

    #>
    $args[0] + $args[1]
}


function whoareu{
    param (
        [string]$first = 'unknown',
        [string]$last = 'lee',
        [int]$age = 26
    )
    Write-Output "$last, $first : $age"    
}


function process_2
{    
    param([string]$first)    
    $_.processname -like "$first*"    
}

#https://technet.microsoft.com/ko-kr/library/hh847829.aspx
function Get-PipelineBeginEnd 
{
    begin {"Begin: The input is $input"}
    end {"End:   The input is $input" }
}