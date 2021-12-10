$signals = Get-Content '.\2021\Day 8\input.txt'


$cnt = 0
foreach ($signal in $signals) {
    $signal.Split(' | ')[1].Split(' ') | ForEach-Object {
        if (
            ($_.Length -eq 2) `
            -or ($_.Length -eq 3) `
            -or ($_.Length -eq 4) `
            -or ($_.Length -eq 7) 
        ) {$cnt++}
    }
}

$cnt