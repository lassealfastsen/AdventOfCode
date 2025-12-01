$reader = New-Object System.IO.StreamReader('C:\Temp\AoC\AdventOfCode\2025\Day 1\input.txt')


$counter = 0
$counter1 = 0
$wholerotations = 0 
#$counter2 = 0
$pos = 50

while ($null -ne ($read = $reader.ReadLine())) {
    $regex = ([regex]::Match($read, "([LR])([0-9].*)"))
    $dir = $regex.Groups[1].Value
    $amount = [int]$regex.Groups[2].Value
    
    $wholerotations += [Math]::Floor($amount / 100)
    $amount %= 100

    switch ($dir) {
        'L' {
            if ($pos -ne 0 -and $amount -gt $pos) {
                $counter++
            }

            $pos = (100 + ($pos - $amount)) % 100
        }
        'R' {
            if ($amount -gt (100 - $pos)) {
                $counter++
            }
            $pos = ($pos + $amount) % 100
        }
    }
    if ($pos -in @(0, 100)) {
        $counter1++
        $counter++
    }

}
Write-Host "Part 1: $counter1" -ForegroundColor Green
Write-Host "Part 2: $counter + $wholerotations = $($counter+$wholerotations)" -ForegroundColor Green

$reader.Close()
$reader.Dispose()
