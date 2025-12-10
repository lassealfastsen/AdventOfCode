$reader = New-Object System.IO.StreamReader("C:\git\AdventOfCode\2025\Day 9\input.txt")

$grid = @()

$y = 0
while ( ($read = $reader.ReadLine()) -ne $null) {

    
    #for ($x = 0; $x -lt $read.Length; $x++) {
    $grid += [PSCustomObject]@{
        x         = [int]$read.split(',')[0]
        y         = [int]$read.split(',')[1]
        #color     = if ($read[$x] -eq "#") { "red" } else { "white" }
        maxCanvas = 0
    }
    #}
    #$y++
}

$reader.Close()
$reader.Dispose()



foreach ($point in $grid ) {
    #| Where-Object { $_.color -eq 'red' }) {
    $neighbors = $grid | Where-Object { 
        (("$($_.x),$($_.y)" ) -ne ("$($point.x),$($point.y)") )# -and ($_.color -eq 'red'))
    }

    #Write-Host $neighbors.Count " neighbors found for point ($($point.x), $($point.y))"
    foreach ($neighbor in $neighbors) {
        $canvasSize = [bigint]((([math]::Abs($neighbor.x) - $point.x) + 1) * (([Math]::Abs($neighbor.y - $point.y)) + 1))

        #$canvasSize = [Math]::Sqrt( [Math]::Pow( ([Math]::Abs($neighbor.x - $point.x)), 2) + [Math]::Pow( ([Math]::Abs($neighbor.y - $point.y)), 2) )
        if ($canvasSize -gt $point.maxCanvas) {
            $point.maxCanvas = $canvasSize
        }
    }
}




#P2


#Write Vertical Bounds
$Bounds = @{}
$Borders = [System.Collections.ArrayList]::new()
$i = 0
foreach ($point in $grid ) {
    $i++
    Write-Host "$i/$($grid.Count)"
    $dirs = @(
        'L',
        'R',
        'U',
        'D'

    )

    foreach ($dir in $dirs) {
        switch ($dir) {
            'U' {
                $neighbor = $grid | Where-Object { $_.x -eq $point.x -and $_.y -lt $point.y } | Sort-Object -Property y -Descending | Select-Object -First 1
                if ($neighbor.Count -gt 0) {
                    for ($y = $point.y; $y -gt $neighbor.y; $y--) {
                        $Bounds["$($point.x),$($y)"] = "#"
                        $null = $Borders.Add([PSCustomObject]@{
                                x = [int]$point.x
                                y = [int]$y
                            })
                    }
                }
            }
            'D' {
                $neighbor = $grid | Where-Object { $_.x -eq $point.x -and $_.y -gt $point.y } | Sort-Object -Property y | Select-Object -First 1
                if ($neighbor.Count -gt 0) {
                    for ($y = $point.y; $y -lt $neighbor.y; $y++) {
                        $Bounds["$($point.x),$($y)"] = "#"
                        $null = $Borders.Add([PSCustomObject]@{
                                x = [int]$point.x
                                y = [int]$y
                            })
                    }

                }
            }
            'L' {
                $neighbor = $grid | Where-Object { $_.y -eq $point.y -and $_.x -lt $point.x } | Sort-Object -Property x -Descending | Select-Object -First 1
                if ($neighbor.Count -gt 0) {
                    for ($x = $point.x; $x -gt $neighbor.x; $x--) {
                        $Bounds["$($x),$($point.y)"] = "#"
                        $null = $Borders.Add([PSCustomObject]@{
                                x = [int]$x
                                y = [int]$point.y
                            })
                    }
                }
            }
            'R' {
                $neighbor = $grid | Where-Object { $_.y -eq $point.y -and $_.x -gt $point.x } | Sort-Object -Property x | Select-Object -First 1
                if ($neighbor.Count -gt 0) {
                    for ($x = $point.x; $x -lt $neighbor.x; $x++) {
                        $Bounds["$($x),$($point.y)"] = "#"
                        $null = $Borders.Add([PSCustomObject]@{
                                x = [int]$x
                                y = [int]$point.y
                            })
                    }
                }
            }
        }
    }
}
















# $finishedGrid = @{}
# $minX = ($grid | Measure-Object -Property x -Minimum).Minimum - 2
# $maxX = ($grid | Measure-Object -Property x -Maximum).Maximum + 2
# $minY = ($grid | Measure-Object -Property y -Minimum).Minimum - 1
# $maxY = ($grid | Measure-Object -Property y -Maximum).Maximum + 1 



# $finishedGrid = $Bounds.Clone()
# #$finishedGrid.Count
# Function FillBoundary {
#     Param(
#         [int]$x,
#         [int]$y
#     )
#     #$finishedGrid.Count

#     $queue = New-Object System.Collections.Queue
#     $queue.Enqueue(@{x = $x; y = $y })

#     while ($queue.Count -gt 0) {
#         if (((GEt-Date).ToString('ss') -eq 0)) {
#             $queue.Count
#         }
#         $obj = $queue.Dequeue()
#         if ($finishedGrid["$($obj.x),$($obj.y)"] -ne '#') {
#             $finishedGrid["$($obj.x),$($obj.y)"] = '#'
#             $queue.Enqueue(@{x = ($obj.x + 1); y = $obj.y })
#             $queue.Enqueue(@{x = ($obj.x - 1); y = $obj.y })
#             $queue.Enqueue(@{x = $obj.x; y = ($obj.y + 1) })
#             $queue.Enqueue(@{x = $obj.x; y = ($obj.y - 1) })
#             # $queue.Enqueue(@{x = $x; y = $y })
#             # $queue.Enqueue(@{x = $x; y = $y })
#             # $queue.Enqueue(@{x = $x; y = $y })
            
#         }
#     }

#     # if ($finishedGrid["$x,$y"] -ne '#') {
#     #     $finishedGrid["$x,$y"] = '#'
#     #     FillBoundary -x($x + 1) -y $y
#     #     FillBoundary -x($x - 1) -y $y
#     #     FillBoundary -x $x -y ($y + 1)
#     #     FillBoundary -x $x -y ($y - 1) 
#     # }
# }


#Write-Host "Filling..."
#$startPos = $grid | Sort-Object y, x | Select-Object -First 1
#FillBoundary -x ($startPos.x + 1) -y ($startPos.y + 1)
#Write-Host "Filled"

###


# $Borders = @()
# foreach ($Border in $Bounds.Keys) {
#     $null = $Borders.Add([PSCustomObject]@{
#             x = [int]$Border.split(',')[0]
#             y = [int]$Border.split(',')[1]
#         }
#     }



$i = 0
foreach ($point in $grid ) {
    $i++
    Write-Host "$i/$($grid.Count)"
    $point.maxCanvas = 0
    #| Where-Object { $_.color -eq 'red' }) {
    $neighbors = $grid | Where-Object { 
        (("$($_.x),$($_.y)" ) -ne ("$($point.x),$($point.y)") )# -and ($_.color -eq 'red'))
    }

    #Write-Host $neighbors.Count " neighbors found for point ($($point.x), $($point.y))"
    :n foreach ($neighbor in $neighbors) {
        

        #Check Canvas is fully contained

        $xmax = [math]::Max($point.x, $neighbor.x) - 1
        $ymax = [math]::Max($point.y, $neighbor.y) - 1


        $xmin = [math]::Min($point.x, $neighbor.x) + 1
        $ymin = [math]::Min($point.y, $neighbor.y) + 1

        if (($Borders | Where-Object { 
                    (($_.x -eq $xmin) -and (($_.y -ge $ymin) -and ($_.y -le $ymax))) -or 
                    (($_.x -eq $xmax) -and (($_.y -ge $ymin) -and ($_.y -le $ymax))) -or 
                    (($_.y -eq $ymin) -and (($_.x -ge $xmin) -and ($_.x -le $xmax))) -or 
                    (($_.y -eq $ymax) -and (($_.x -ge $xmin) -and ($_.x -le $xmax)))
                } ).Count -eq 0) {
            #Must be valid
            $canvasSize = [bigint]((([math]::Abs($neighbor.x) - $point.x) + 1) * (([Math]::Abs($neighbor.y - $point.y)) + 1))
            if ($canvasSize -gt $point.maxCanvas) {

                $point.maxCanvas = $canvasSize
            }
        }
           
    }
}

$grid | Sort maxCanvas -Descending  | Select-Object -Skip 200 -First 50

$grid | Sort maxCanvas | Select-Object -Last 1 | ForEach-Object {
    Write-Host "Largest Canvas Size: $($_.maxCanvas) at point ($($_.x), $($_.y))"
} 

# correct! 1574684850

#Not Right 3560646980
#Not Right 3800580628



#too high 4007704506
#too high 4109787684


# for ($y = $minY; $y -le $maxY; $y++) {
#     $l = ""
#     for ($x = $minX; $x -le $maxX; $x++) {
#         if ($Bounds.ContainsKey("$x,$y")) {
#             $l += "#"
#         }
#         else {
#             $l += '.'
#         }
#     }
#     Write-Host $l
# }




















# $i = 0
# foreach ($point in $grid ) {
#     $i++
#     Write-Host "$i/$($grid.Count)"
#     $point.maxCanvas = 0
#     #| Where-Object { $_.color -eq 'red' }) {
#     $neighbors = $grid | Where-Object { 
#         (("$($_.x),$($_.y)" ) -ne ("$($point.x),$($point.y)") )# -and ($_.color -eq 'red'))
#     }

#     #Write-Host $neighbors.Count " neighbors found for point ($($point.x), $($point.y))"
#     :n foreach ($neighbor in $neighbors) {
        

#         #Check Canvas is fully contained
#         $xmax = [math]::Max($point.x, $neighbor.x) - 1
#         $ymax = [math]::Max($point.y, $neighbor.y) - 1
#         $xmin = [math]::Min($point.x, $neighbor.x) + 1
#         $ymin = [math]::Min($point.y, $neighbor.y) + 1
#         Write-Host "$xmin -> $xmax"
#         for ($x = $xmin; $x -le $xmax; $x++) {
#             if (( $Bounds.ContainsKey("$x,$ymin")) -or ($Bounds.ContainsKey("$x,$ymax"))) {
#                 continue n         
#             }
#         }
#         Write-Host "$ymin -> $ymax"
#         for ($y = $ymin; $y -le $ymax; $y++) {
#             if (( $Bounds.ContainsKey("$xmin,$y")) -or ( $Bounds.ContainsKey("$xmax,$y"))) {
#                 continue n         
#             }
#         }

#         #Must be valid
#         $canvasSize = [bigint]((([math]::Abs($neighbor.x) - $point.x) + 1) * (([Math]::Abs($neighbor.y - $point.y)) + 1))
#         if ($canvasSize -gt $point.maxCanvas) {

#             $point.maxCanvas = $canvasSize
#         }
#     }
# }

$grid | Sort maxCanvas | Select-Object -Last 1 |  ForEach-Object {
    Write-Host "Largest Canvas Size: $($_.maxCanvas) at point ($($_.x), $($_.y))"
} 
