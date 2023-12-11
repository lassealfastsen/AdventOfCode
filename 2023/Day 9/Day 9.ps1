$pth = ".\2023\Day 9\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$histories = [Collections.Generic.List[int[]]]@()

while ($null -ne ($read = $reader.ReadLine())) {
    $histories.Add($read.Split(' '))
}

$reader.Close()
$reader.Dispose()


Function Extrapolate {
    Param(
        [int[]]$history,
        [switch]$part2
    )

    $work = [Collections.Generic.List[int[]]]@()
    if ($part2) {
        $new = @()

        for ($i = $history.Count-1; $i -ge 0; $i--) {
            $new += $history[$i]
        }
        $history = $new
    }
    $work.Add($history)

    while (($work[-1] | Where-Object { ($_ -ne 0) }).Count -gt 0) {
        $new = @()
        for ($i = 0; $i -lt $work[-1].Count - 1; $i++) {
            $new += ($work[-1][$i + 1] - $work[-1][$i])
        }

        #Write-Host $new -join ' '
        $work.Add($new)
    }

    

    for ($i = $work.Count - 2; $i -ge 0; $i--) {
        $work[$i] += $work[$i][-1] + $work[$i + 1][-1]
    }


    return $work[0][-1]

}


#    2    0     -2    -4    -6   -8   -10    -12    -14    -16    -18    -20    -22     -24     -26     -28      -30     -32    -34     -36

$result = 0
foreach ($hist in $histories) {
    $result += Extrapolate $hist
}

Write-Host "Part 1: $result"

$result = 0
foreach ($hist in $histories) {
    $result += Extrapolate $hist -part2
}
Write-Host "Part 2: $result"