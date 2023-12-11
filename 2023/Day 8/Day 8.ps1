$pth = ".\2023\Day 8\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$instructions = $reader.ReadLine()

$nodes = @{}

while ($null -ne ($read = $reader.ReadLine())) {
    if ($read -like "*=*") {
        
        $nodedesc = ([Regex]::Matches($read, "[A-z]{3}")).Value

        $nodes[$nodedesc[0]] = [PSCustomObject]@{
            L = $nodedesc[1]
            R = $nodedesc[2]
        }
    }
}

$reader.Close()
$reader.Dispose()



$start = "AAA"
$cur = $start
$steps = 0


while ($cur -ne "ZZZ") {
    $instr = $instructions[($steps % $instructions.Length)]
    $steps++
    
    $cur = $nodes[$cur]."$instr"
}

Write-Host "Part 1: $steps"



#Part 2

$pth = "C:\Temp\GIT\AdventOfCode\2023\Day 8\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$instructions = $reader.ReadLine()

$nodes = @{}

while ($null -ne ($read = $reader.ReadLine())) {
    if ($read -like "*=*") {
        
        $nodedesc = ([Regex]::Matches($read, "[1-z]{3}")).Value

        $nodes[$nodedesc[0]] = [PSCustomObject]@{
            L = $nodedesc[1]
            R = $nodedesc[2]
        }
    }
}

$reader.Close()
$reader.Dispose()


$curs = $nodes.Keys | Where-Object { ($_ -like "*A") }
#$curs = $nodes.Keys | Where-Object { ($_ -like "*Z") }

$lengths = @()

foreach ($cur in $curs) {
    $init = $cur
    $steps = 0
    while (($cur -notlike "*Z")) {
        $instr = $instructions[($steps % $instructions.Length)]
        $cur = $nodes[$cur]."$instr"

        $steps++
    }
    $lengths += $steps
}


for ($s = 0; $s -lt $lengths.Length - 1; $s++) {
    $greater = [Math]::Max($lengths[$s], $lengths[$s + 1])
    $currMul = $greater

    while (($currMul % $lengths[$s] -ne 0) -or ($currMul % $lengths[$s + 1] -ne 0)) {
        $currMul += $greater
    }

    $lengths[$s + 1] = $currMul
}

Write-Host "Part 2: $($lengths[-1])"


