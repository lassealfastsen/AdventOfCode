
$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2017\Day 6\input.txt')

$in = $reader.ReadToEnd()

$reader.Close()
$reader.Dispose()

$banks = [int[]]([Regex]::Matches($in, '[0-9]+').Value)

$cycle = 1
$history = @()


while ($true) {
    $history += ($banks -join ' ')
    $val = ($banks | Sort-Object -Descending)[0]

    $i = $banks.IndexOf($val)
    $banks[$i] = 0

    while ($val -gt 0) {
        $i++
        $banks[($i % ($banks.Count))]++
        $val--
    }



    $cycle++
    if ($history -contains ($banks -join ' ')) {
        break
    }
}

Write-Host $cycle

$target = ($banks -join ' ')
$cycle = 1
while ($true) {
    $val = ($banks | Sort-Object -Descending)[0]

    $i = $banks.IndexOf($val)
    $banks[$i] = 0

    while ($val -gt 0) {
        $i++
        $banks[($i % ($banks.Count))]++
        $val--
    }

    if (($banks -join ' ') -eq $target) {
        break
    }

    $cycle++
}

Write-Host $cycle