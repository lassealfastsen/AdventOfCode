$memory = Get-Content 'C:\git\AdventOfCode\2024\Day 3\input.txt' -Raw

$instructions = [regex]::Matches($memory, "mul\(\d+,\d+\)")

#Part 1

$result = 0
foreach ($instruction in $instructions.Value) {
    $numbers = [regex]::Matches($instruction, "\d+")
    $result += [int]::Parse($numbers[0]) * [int]::Parse($numbers[1])
}

$result


#Part 2
$conditions = [regex]::Matches($memory, "do\(\)|don't\(\)")

$result = 0

$doOp = $true
for ($i = 0; $i -lt $instructions.Count; $i++) {
    $iindex = $instructions[$i].Index
    if (($iindex -lt $conditions[0].Index) -or ($conditions | Where-Object { ($_.Index -lt $iindex) } | Select-Object -Last 1).Value -eq "do()") {
        $doOp = $true
    }
    else {
        $doOp = $false
    }

    if ($doOp) {
        $numbers = [regex]::Matches($instructions[$i], "\d+")
        $result += [int]::Parse($numbers[0]) * [int]::Parse($numbers[1])

    }
    
}


$result

