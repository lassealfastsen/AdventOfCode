$reader = New-Object System.IO.StreamReader('.\AdventOfCode\2025\Day 1\input.txt')


$counter = 0
#$counter2 = 0
$pos = 50

while ($null -ne ($read = $reader.ReadLine())) {
    $regex = ([regex]::Match($read, "([LR])([0-9].*)"))
    $dir = $regex.Groups[1].Value
    $amount = [int]$regex.Groups[2].Value
    switch ($dir) {
        'L' {
            $pos -= $amount
        }
        'R' {
            $pos += $amount
        }
    }

    if ($pos -gt 100) {
        $pos = $pos % 100
    }
    elseif ($pos -lt 0) {
        $pos = 100 - ([Math]::Abs($pos) % 100)
    } if ($pos -eq 0 -or $pos -eq 100) { $counter++ }

}

Write-Host "Part 1: $counter" -ForegroundColor Green

$reader.Close()
$reader.Dispose()



#Brute forcing part 2 cause i am lazy

$reader = New-Object System.IO.StreamReader('.\AdventOfCode\2025\Day 1\input.txt')


$counter = 0
#$counter2 = 0
$pos = 50

while ($null -ne ($read = $reader.ReadLine())) {
    $regex = ([regex]::Match($read, "([LR])([0-9].*)"))
    $dir = $regex.Groups[1].Value
    $amount = [int]$regex.Groups[2].Value
    switch ($dir) {
        'L' {
            $mod = -1
        }
        'R' {
            $mod = 1
        }
    }

    while ($amount -gt 0) {
        $pos += $mod
        if ($pos -eq 100) {
            $pos = 0
            $counter++
        }
        elseif ($pos -eq 0) {
            $counter++
        }
        elseif ($pos -eq -1) {
            $pos = 99
        }
        $amount--
    }
}

Write-Host "Part 2: $counter" -ForegroundColor Green

$reader.Close()
$reader.Dispose()
