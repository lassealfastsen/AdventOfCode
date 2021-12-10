#Load Grid

$inputContent = Get-Content -LiteralPath '.\2021\Day 9\input.txt'

$grid = New-Object 'int[,]' $inputContent.Count, $inputContent[0].Length

$y = 0
foreach ($row in $inputContent) {
    $row = $row.ToCharArray()
    for ($x = 0; $x -lt $row.Count; $x++) {
        $grid[$y, $x] = [int]::parse($row[$x])
    }
    $y++
}

#Get Low Points

$lowpoints = @()

for ($y = 0; $y -lt $grid.GetLength(0); $y++) {
    for ($x = 0; $x -lt $grid.GetLength(1); $x++) {
        $l = 9
        $r = 9
        $u = 9
        $d = 9

        if ($x -gt 0) {
            $l = $grid[$y, ($x-1)]
        }
        if ($x -lt ($grid.GetLength(1)-1)) {
            $r = $grid[$y, ($x+1)]
        }
        if ($y -gt 0) {
            $u = $grid[($y-1),$x]
        }
        if ($y -lt ($grid.GetLength(0)-1)){
            $d = $grid[($y+1),$x]
        }

        if ($grid[$y,$x] -lt (@($u, $d, $l, $r) | Sort | Select -First 1)) {
           # Write-Host $grid[$y,$x] -ForegroundColor Yellow -NoNewline
            $lowpoints += "$x,$y"
        } else {
            #Write-Host $grid[$y,$x] -NoNewline
        }
    }
    #Write-Host
}

Function Get-BasinSize {
    Param(
        [Parameter(Mandatory=$true, Position=1)][string]$startPoint
    )

    
    $queue = @()
    $searched = @()
    $basinsize = 0
    $queue += $startPoint

    while ($queue.count -gt 0) {
    

        $x = [int]$queue[0].Split(',')[0]
        $y = [int]$queue[0].Split(',')[1]
    
        if ($grid[$y,$x] -lt 9) {
            $basinsize++
            #"$x,$y"
        }
        if ($queue.Count -eq 1) {$queue = @()} else {$queue = $queue[1..($queue.Length-1)]}
        $searched += "$x,$y"
    
        $l = 9
        $r = 9
        $u = 9
        $d = 9
    
    
        if ($x -gt 0) {
            $l = $grid[$y, ($x-1)]
        }
        if ($x -lt ($grid.GetLength(1)-1)) {
            $r = $grid[$y,($x+1)]
        }
        if ($y -gt 0) {
            $u = $grid[($y-1), $x]
        }
        if ($y -lt ($grid.GetLength(0)-1)) {
            $d = $grid[($y+1),$x]
        }
    
        if (($l -ne 9) -and ("$($x-1),$y" -notin $searched) -and ("$($x-1),$y" -notin $queue)) {
            $queue += "$($x-1),$y"
        }
        if (($r -ne 9) -and ("$($x+1),$y" -notin $searched) -and ("$($x+1),$y" -notin $queue)) {
            $queue += "$($x+1),$y"
        }
        if (($u -ne 9) -and ("$x,$($y-1)" -notin $searched) -and ("$x,$($y-1)" -notin $queue)) {
            $queue += "$x,$($y-1)"
        }
        if (($d -ne 9) -and ("$x,$($y+1)" -notin $searched) -and ("$x,$($y+1)" -notin $queue)) {
            $queue += "$x,$($y+1)"
        }
    }

    return $basinsize

}


$basins = @()

foreach ($lowpoint in $lowpoints) {
    $basins += Get-BasinSize $lowpoint
}

$answer = 1
$basins | Sort-Object -Descending | Select-Object -First 3 | % { $answer = ($answer * $_) }
$answer
