$instructions = @()

$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2017\Day 5\input.txt')


while ($null -ne ($read = $reader.ReadLine())) {
    $instructions += [int]::Parse($read)
}

$reader.Close()
$reader.Dispose()


$idx = $instructions[0]
$steps = 0

while (($idx -ge 0 -and ($idx -le $instructions.Length - 1))) {
    $offset = $instructions[$idx]
    $instructions[$idx]++
    $steps++
    $idx += $offset
}

Write-Host $steps



$instructions = @()

$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2017\Day 5\input.txt')


while ($null -ne ($read = $reader.ReadLine())) {
    $instructions += [int]::Parse($read)
}

$reader.Close()
$reader.Dispose()


$idx = $instructions[0]
$steps = 0

while (($idx -ge 0 -and ($idx -le $instructions.Length - 1))) {


    $offset = $instructions[$idx]
    if ($offset -ge 3) {
        $instructions[$idx]-- 
    }
    else { $instructions[$idx]++ }
        
    $steps++
    $idx += $offset
}

Write-Host $steps
