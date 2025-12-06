#Load Grid
$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 4\input.txt')

$grid = @{}

$y = 0



while ($null -ne ($read = $reader.ReadLine())) {

    for ($x = 0; $x -lt $read.Length; $x++) {
        $grid["$($x),$($y)"] = $read[$x]
    }
    $y++
}

$reader.Close()
$reader.Dispose()




Function Get-AccessibleRolls {

    $accessibleRolls = @()
    foreach ($key in $grid.Keys | Where-Object { $grid[$_] -eq '@' }) {
        $coords = $key.Split(',')
        $x = [int]$coords[0]
        $y = [int]$coords[1]
        $cell = $grid["$($x),$($y)"]

        $neigbours = @(
            $grid["$($x-1),$($y)"],
            $grid["$($x+1),$($y)"],
            $grid["$($x),$($y-1)"],
            $grid["$($x),$($y+1)"],
            $grid["$($x-1),$($y-1)"],
            $grid["$($x-1),$($y+1)"],
            $grid["$($x+1),$($y-1)"],
            $grid["$($x+1),$($y+1)"]
        )

        if (($neigbours | Where-Object { $_ -eq '@' } | Measure-Object).Count -lt 4) {
            $accessibleRolls += "$($x),$($y)"
        }
    }

    return $accessibleRolls
}

$totalAccessibleRolls = 0


while (($rolls = Get-AccessibleRolls).Count -gt 0) {
    $rolls.Count | Write-Host -ForegroundColor Yellow
    $lastResult = $rolls.Count
    $totalAccessibleRolls += $rolls.Count

    foreach ($roll in $rolls) {
        $coords = $roll.Split(',')
        $x = [int]$coords[0]
        $y = [int]$coords[1]
        $grid["$($x),$($y)"] = '.'
    }
    
}


$totalAccessibleRolls | Write-Host -ForegroundColor Green






# if ($cell -eq '0') {
#     $accessibleRolls += ,@($x, $y)
# }