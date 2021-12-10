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

$gridsize = $grid.GetLength(0)

for ($y = 0; $y -lt $gridsize; $y++) {
    for ($x = 0; $x -lt $gridsize; $x++) {

        $val = $grid[$y,$x]

        if (
            (($x -eq 0) -or ($val -lt $grid[$y,($x-1)])) `
            -and (($x -eq $gridsize) -or ($val -lt $grid[$y,($x+1)])) `
            -and (($y -eq 0) -or ($val -lt $grid[($y-1),$x])) `
            -and (($y -eq $gridsize) -or ($val -lt $grid[($y+1),$x]))
        ) {
            $lowpoints += "$x,$y"
        }
    }
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
   
        
        $basinsize++
        
        if ($queue.Count -eq 1) {$queue = @()} else {$queue = $queue[1..($queue.Length-1)]}
        $searched += "$x,$y"
    

        if (
            (($x -gt 0) -and ("$($x-1),$y" -notin $searched) -and ("$($x-1),$y" -notin $queue) -and ($grid[$y,($x-1)] -ne 9))
        ) { $queue += "$($x-1),$y" }
    
        if (
            (($x -lt $gridsize-1) -and ("$($x+1),$y" -notin $searched) -and ("$($x+1),$y" -notin $queue) -and ($grid[$y,($x+1)] -ne 9))
        ) { $queue += "$($x+1),$y" }

        if (
            (($y -gt 0) -and ("$x,$($y-1)" -notin $searched) -and ("$x,$($y-1)" -notin $queue) -and ($grid[($y-1),$x] -ne 9))
        ) { $queue += "$x,$($y-1)" }
        
        if (
            (($y -lt $gridsize-1) -and ("$x,$($y+1)" -notin $searched) -and ("$x,$($y+1)" -notin $queue) -and ($grid[($y+1),$x] -ne 9))
        ) { $queue += "$x,$($y+1)" }
    }

    return $basinsize

}

#Get-BasinSize $lowpoints[0]

 $basins = @()
 foreach ($lowpoint in $lowpoints) {
     $basins += Get-BasinSize $lowpoint
 }
 $answer = 1
 $basins | Sort-Object -Descending | Select-Object -First 3 | ForEach-Object { $answer = ($answer * $_) }
 $answer