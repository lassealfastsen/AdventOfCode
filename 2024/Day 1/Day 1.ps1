$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2024\Day 1\input.txt')

$distance = 0

$num1 = @()
$num2 = @()

while ($null -ne ($read = $reader.ReadLine())) {
    $nums = [int[]]([Regex]::Matches($read, '[0-9]+').Value)

    $num1 += [int]::Parse($nums[0])
    $num2 += [int]::Parse($nums[1])
}

$reader.Close()
$reader.Dispose()

[array]::Sort($num1)
[array]::Sort($num2)

$occuranceCounts = $num2 | Group-Object

$similaritySCore = 0

for ($i = 0; $i -lt $num1.Count; $i++) {
    $distance += [Math]::Abs(($num1[$i] - $num2[$i]))

    $oidx = $occuranceCounts.Name.IndexOf("$($num1[$i])")

    if ($oidx -ge 0) {
        $similaritySCore += ($occuranceCounts[$oidx].Count * $num1[$i])
    }
}


Write-Host "Total Disance: " -NoNewline
Write-Host $distance -ForegroundColor Green

Write-Host "T0tal Similarity Score: " -NoNewline
Write-Host $similaritySCore -ForegroundColor Green