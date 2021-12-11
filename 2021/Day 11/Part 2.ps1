$inputContent = Get-Content -LiteralPath '.\2021\Day 11\input.txt'


$grid = New-Object 'int[,]' $inputContent.Count, $inputContent[0].Length


$y = 0
foreach ($row in $inputContent) {
    $row = $row.ToCharArray()
    for ($x = 0; $x -lt $row.Count; $x++) {
        $grid[$y, $x] = [int]::parse($row[$x])
    }
    $y++
}


$gridsize = 10
$stepcount = 1
#counter for flashes
$flashes = 0

$run = $true

while ($run) {
    
    #Write-Host ("$stepcount $(($grid | Measure-Object -Sum).Sum)")
    if (($grid | Measure-Object -Sum).Sum -eq 0) {
        #The step before is the answer
        Write-Host ($stepcount-1)
        $run = $false
    }

    $queue = @()
    $processed = @()



    #Increase all by 1 and add to queue if relevant
    for ($x = 0; $x -lt $gridsize; $x++) {
        for ($y = 0; $y -lt $gridsize; $y++) {
            $grid[$y,$x]++
            if ($grid[$y,$x] -gt 9) {
                $queue += "$x,$y"
            }
        }
    }
    

    #FLash and update queue until empty

    while ($queue.count -gt 0) {
        
        $x = [int]$queue[0].Split(',')[0]
        $y = [int]$queue[0].Split(',')[1]

        #Set current to 0 and add to processed and remove from queue
        $grid[$y,$x]=0
        if ($queue.Count -eq 1) {$queue = @()} else {$queue = $queue[1..($queue.Length-1)]}
        $processed += "$x,$y"
        $flashes++

        #increase to the left if present in the grid
        #add left to queue if relevant (if we are not at x0 and left has not been processed/queued and left i gt 9)
        #(x- y)
        if ((($x -gt 0) -and ("$($x-1),$y" -notin $queue) -and ("$($x-1),$y" -notin $processed))) {
            $grid[$y,($x-1)]++
            if ($grid[$y,($x-1)] -gt 9) {
                $queue += "$($x-1),$y"
            }
            
        }

        #diagonal up left (x- y-)
        if ((($x -gt 0) -and ($y -gt 0) -and ("$($x-1),$($y-1)" -notin $queue) -and ("$($x-1),$($y-1)" -notin $processed))) {
            $grid[($y-1),($x-1)]++
            if ($grid[($y-1),($x-1)] -gt 9) {
                $queue += "$($x-1),$($y-1)"
            }
        }

        #above (x y-)
        if (($y -gt 0) -and ("$x,$($y-1)" -notin $queue) -and ("$x,$($y-1)" -notin $processed)) {
            $grid[($y-1),$x]++
            if ($grid[($y-1),$x] -gt 9) {
                $queue += "$x,$($y-1)"
            }
        }

        #diagonal Up right (x+ y-)
        if ((($x -lt ($gridsize-1)) -and ($y -gt 0) -and ("$($x+1),$($y-1)" -notin $queue) -and ("$($x+1),$($y-1)" -notin $processed))) {
            $grid[($y-1),($x+1)]++
            if ($grid[($y-1),($x+1)] -gt 9) {
                $queue += "$($x+1),$($y-1)"
            }
        }

        #Right (x+ y)
        if ((($x -lt ($gridsize-1)) -and ("$($x+1),$y" -notin $queue) -and ("$($x+1),$y" -notin $processed))) {
            $grid[$y,($x+1)]++
            if (($grid[$y,($x+1)] -gt 9)) {
                $queue += "$($x+1),$y"
            }
        }

        #diagonal down right (x+ y+)
        if ((($x -lt ($gridsize-1)) -and ($y -lt $gridsize-1) -and ("$($x+1),$($y+1)" -notin $queue) -and ("$($x+1),$($y+1)" -notin $processed))) {
            $grid[($y+1),($x+1)]++
            if (($grid[($y+1),($x+1)] -gt 9)) {
                $queue += "$($x+1),$($y+1)"
            }
        }

        #below (x+ y)
        if (($y -lt ($gridsize-1)) -and ("$x,$($y+1)" -notin $queue) -and ("$x,$($y+1)" -notin $processed)) {
            $grid[($y+1),$x]++
            if ($grid[($y+1),$x] -gt 9) {
                $queue += "$x,$($y+1)"
            }
        }

        #diagonal down left (x- y+)
        if ((($x -gt 0) -and ($y -lt $gridsize-1) -and ("$($x-1),$($y+1)" -notin $queue) -and ("$($x-1),$($y+1)" -notin $processed))) {
            $grid[($y+1),($x-1)]++
            if ($grid[($y+1),($x-1)] -gt 9) {
                $queue += "$($x-1),$($y+1)"
            }
        }

    }


    foreach ($pos in $processed) {
        $posx = $pos.split(',')[0]
        $posy = $pos.split(',')[1]
        $grid[$posy,$posx]=0
    }

    $stepcount++
}


# for ($y = 0; $y -lt $gridsize; $y++) {
#     for ($x = 0; $x -lt $gridsize; $x++) {
#         Write-Host $grid[$y,$x] -NoNewline
#     }
#     Write-Host
# }


#Writeout
