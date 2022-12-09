$head = @{
    x = 0
    y = 0
}

$tails = @(
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
    @{pos = "0,0"; steps = [string[]]@() }
)

#$tail = }


$pth = '.\2022\Day 9\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

while ($null -ne ($read = $reader.ReadLine())) {
    
    $direction = $read.Split(' ')[0]
    $steps = [int]$read.Split(' ')[1]

    switch ($direction) {
        'R' { 
            for ($i = 0; $i -lt $steps; $i++) {
                $head.x++
                $t0change = $null
                #should the next tail Move?
                for ($t = 0; $t -lt $tails.count; $t++) {
                    if ($t -eq 0) {
                        $x = $head.x
                        $y = $head.y
                    } else {
                        $cord = [int[]]$tails[$t - 1].pos.Split(',')
                        $x = $cord[0]
                        $y = $cord[1]
                    }
                    
                    $touchingpositions = @(
                        "$($x-1),$($y-1)"
                        "$x,$($y-1)"
                        "$($x+1),$($y-1)"
                        "$($x+1),$y"
                        "$($x+1),$($y+1)"
                        "$x,$($y+1)"
                        "$($x-1),$($y+1)"
                        "$($x-1),$y"
                        "$x,$y"
                    )
                    if ($tails[$t].pos -notin $touchingpositions) {
                        
                        if ($t -eq 0) {
                            $current = [int]$tails[$t].pos.Split(',')
                            $tails[$t].steps += $tails[$t].pos
                            $tails[$t].pos = "$($x-1),$y"
                            $difx = $current[0] + $tails[$T].pos.Split(',')[0]
                            $difY = $current[1] + $tails[$T].pos.Split(',')[1]
                            $t0change = @{difx = [int]$difx; dify = [int]$dify }
                        } else {
                            $tails[$t].steps += $tails[$t].pos
                            $tail = $tails[$t].pos
                            $tails[$t].pos = ("$($tail.Split(',')[0]+$t0change.difx),$($tail.Split(',')[1]+$t0change.dify)")
                        }  
                    }    
                }
                
            }
        }
        'L' { 
            for ($i = 0; $i -lt $steps; $i++) {
                $head.x--
                #should the next tail Move?
                for ($t = 0; $t -lt $tails.count; $t++) {
                    if ($t -eq 0) {
                        $x = $head.x
                        $y = $head.y
                    } else {
                        $cord = [int[]]$tails[$t - 1].pos.Split(',')
                        $x = $cord[0]
                        $y = $cord[1]
                    }
                    
                    $touchingpositions = @(
                        "$($x-1),$($y-1)"
                        "$x,$($y-1)"
                        "$($x+1),$($y-1)"
                        "$($x+1),$y"
                        "$($x+1),$($y+1)"
                        "$x,$($y+1)"
                        "$($x-1),$($y+1)"
                        "$($x-1),$y"
                        "$x,$y"
                    )
                    if ($tails[$t].pos -notin $touchingpositions) {

                        if ($t -eq 0) {
                            $current = [int]$tails[$t].pos.Split(',')
                            $tails[$t].steps += $tails[$t].pos
                            $tails[$t].pos = "$($x+1),$y"
                            $difx = $current[0] + $tails[$T].pos.Split(',')[0]
                            $difY = $current[1] + $tails[$T].pos.Split(',')[1]
                            $t0change = @{difx = [int]$difx; dify = [int]$dify }
                        } else {
                            $tails[$t].steps += $tails[$t].pos
                            $tail = $tails[$t].pos
                            $tails[$t].pos = ("$($tail.Split(',')[0]+$t0change.difx),$($tail.Split(',')[1]+$t0change.dify)")
                        }  

                    }    
                }
            }
        }
        'U' {
            for ($i = 0; $i -lt $steps; $i++) {
                $head.y++
                #should the next tail Move?
                for ($t = 0; $t -lt $tails.count; $t++) {
                    if ($t -eq 0) {
                        $x = $head.x
                        $y = $head.y
                    } else {
                        $cord = [int[]]$tails[$t - 1].pos.Split(',')
                        $x = $cord[0]
                        $y = $cord[1]
                    }
                    
                    $touchingpositions = @(
                        "$($x-1),$($y-1)"
                        "$x,$($y-1)"
                        "$($x+1),$($y-1)"
                        "$($x+1),$y"
                        "$($x+1),$($y+1)"
                        "$x,$($y+1)"
                        "$($x-1),$($y+1)"
                        "$($x-1),$y"
                        "$x,$y"
                    )
                    if ($tails[$t].pos -notin $touchingpositions) {
                        if ($t -eq 0) {
                            [int]$current = $tails[$t].pos.Split(',')
                            $tails[$t].steps += $tails[$t].pos
                            $tails[$t].pos = "$x,$($y-1)"
                            $difx = $current[0] + $tails[$T].pos.Split(',')[0]
                            $difY = $current[1] + $tails[$T].pos.Split(',')[1]
                            $t0change = @{difx = [int]$difx; dify = [int]$dify }
                        } else {
                            $tails[$t].steps += $tails[$t].pos
                            $tail = $tails[$t].pos
                            $tails[$t].pos = ("$($tail.Split(',')[0]+$t0change.difx),$($tail.Split(',')[1]+$t0change.dify)")
                        }  


                    }    
                }
            }
        }
        'D' {
            for ($i = 0; $i -lt $steps; $i++) {
                $head.y--
                #should the next tail Move?
                for ($t = 0; $t -lt $tails.count; $t++) {
                    if ($t -eq 0) {
                        $x = $head.x
                        $y = $head.y
                    } else {
                        $cord = [int[]]$tails[$t - 1].pos.Split(',')
                        $x = $cord[0]
                        $y = $cord[1]
                    }
                    
                    $touchingpositions = @(
                        "$($x-1),$($y-1)"
                        "$x,$($y-1)"
                        "$($x+1),$($y-1)"
                        "$($x+1),$y"
                        "$($x+1),$($y+1)"
                        "$x,$($y+1)"
                        "$($x-1),$($y+1)"
                        "$($x-1),$y"
                        "$x,$y"
                    )
                    if ($tails[$t].pos -notin $touchingpositions) {

                        if ($t -eq 0) {
                            [int]$current = $tails[$t].pos.Split(',')
                            $tails[$t].steps += $tails[$t].pos
                            $tails[$t].pos = "$x,$($y+1)"
                            $difx = $current[0] + $tails[$T].pos.Split(',')[0]
                            $difY = $current[1] + $tails[$T].pos.Split(',')[1]
                            $t0change = @{difx = [int]$difx; dify = [int]$dify }
                        } else {
                            $tails[$t].steps += $tails[$t].pos
                            $tail = $tails[$t].pos
                            $tails[$t].pos = ("$($tail.Split(',')[0]+$t0change.difx),$($tail.Split(',')[1]+$t0change.dify)")
                        }  

                    }    
                }
            }
        }
        Default { Write-Host "?????" }
    }
}

$last = $tails.count - 1
($tails[$last].steps | select -Unique).Count + 1


$reader.Close()
$reader.Dispose()