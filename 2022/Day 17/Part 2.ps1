$rocktypes = [System.Collections.Queue]::new()
$rocktypes.Enqueue('-')
$rocktypes.Enqueue('+')
$rocktypes.Enqueue('L')
$rocktypes.Enqueue('I')
$rocktypes.Enqueue('#')


Function Get-Rock {

    Param(
        [Parameter()][int]$initheight = 0
    )
    $rock = $rocktypes.Dequeue()
    $rocktypes.Enqueue($rock)

    $posx = 3
    $posy = $initheight + 4
    switch ($rock) {
        '-' { 
            return @{
                x            = $posx
                y            = $posy
                positions    = @("0,0", "1,0", "2,0", "3,0")
                bottoms      = @("0,-1", "1,-1", "2,-1", "3,-1")
                topOffset    = 0
                bottomOffset = 0
                rightOffset  = 3
            }
        }
        '+' {

            return @{
                x            = $posx
                y            = $posy + 1
                positions    = @("0,0", "1,0", "1,1", "1,-1", "2,0")
                bottoms      = @("0,-1", "1,-2", "2,-1")
                topOffset    = 1
                bottomOffset = 1 
                rightOffset  = 2
            }

        }
        'L' {
            return @{
                x            = $posx
                y            = $posy
                positions    = @("0,0", "1,0", "2,0", "2,1", "2,2")
                bottoms      = @("0,-1", "1,-1", "2,-1")
                topOffset    = 2
                bottomOffset = 0
                rightOffset  = 2
            }
        }
        'I' {
            return @{
                x            = $posx
                y            = $posy
                positions    = @("0,0", "0,1", "0,2", "0,3")
                bottoms      = @("0,-1")
                topOffset    = 3
                bottomOffset = 0
                rightOffset  = 0 
            }
        }
        '#' {
            return @{
                x            = $posx
                y            = $posy
                positions    = ("0,0", "0,1", "1,0", "1,1")
                bottoms      = @("0,-1", "1,-1")
                topOffset    = 1
                bottomOffset = 0
                rightOffset  = 1
            }
        }
    }
    return $rock
}


$pth = "C:\Users\lal\OneDrive - Lyngsoe Systems\Scripts\AdventOfCode\2022\day 17\input.txt"
$winds = [System.Collections.Queue]::new()

$reader = [System.IO.StreamReader]::new($pth)

while (-1 -ne ($read = $reader.Read())) {
    $winds.Enqueue([char]$read)
}

$reader.Close()
$reader.Dispose()

Function Get-Wind {
    $wind = $winds.Dequeue()
    $winds.Enqueue($wind)

    return $wind
}

$occupiedPositions = @{}

#$targetRocks = 2022
$targetRocks = 1000000000000
$rocksAtRest = 0
$topRock = 0
$drop = $false

$rock = Get-Rock

$increaselog = ""


while ($rocksAtRest -lt $targetRocks) {
    
    switch ($drop) {
        $true { 
            #Can move?
            $hit = $false
            $rock.bottoms | ForEach-Object {
                $offset = [int[]]$_.split(',')
                if (($rock.y + $offset[1] -eq 0) -or ($occupiedPositions["$($rock.x + $offset[0]),$($rock.y+$offset[1])"] -eq "#")) {
                    $hit = $true
                }
            }
            if ($hit) {
                #at rest
                $rocksAtRest++
                $rock.positions | ForEach-Object {
                    $offset = [int[]]$_.split(',')
                    $occupiedPositions["$($rock.x + $offset[0]),$($rock.y+$offset[1])"] = "#"
                }

                #$c = $toprock
                $topRock = [math]::Max($rock.y + $rock.topOffset, $topRock)
                # $increase = $toprock-$c
                # $increaselog = "$increaselog+$increase"
                $rock = Get-Rock $topRock
                [System.GC]::Collect()
                #if ($rocksAtRest % 1000 -eq 0) { "$rocksAtRest - $topRock" }
                "$rocksAtRest - $topRock"
                #$rocksAtRest
            } else {
                $rock.y--
            }
        }
        $false {
            switch (Get-Wind) {
                '<' { 
                    if ($rock.x -gt 1) {
                        $hit = $false
                        $rock.positions | ForEach-Object {
                            $pos = $_.split(',')
                            if ($occupiedPositions["$(($rock.x-1) + $pos[0]),$($rock.y + $pos[1])"] -eq '#') {
                                $hit = $true
                            }                            
                        }
                        if (!$hit) {
                            $rock.x--
                        }
                    }
                }
                '>' {
                    if ($rock.x + $rock.rightOffset -le 6) {
                        $hit = $false
                        $rock.positions | ForEach-Object {
                            $pos = $_.split(',')
                            if ($occupiedPositions["$(($rock.x+1) + $pos[0]),$($rock.y + $pos[1])"] -eq '#') {
                                $hit = $true
                            }                            
                        }
                        if (!$hit) {
                            $rock.x++
                        }
                        
                    }
                }
            }
        }
    }

    
    $drop = !$drop
}

$topRock


#Part 2
# 1523947368421 too high
# 1523615217391 too high
# 1523615167391 too high
# 1523615160391 too high
# 1523615160371 too high

# 1523615160362 Juuuust right :)

# 1523615160361 too low
# 1523615160291 too low
# 1523615157391 too low
# 1523615117391 too low

# 1523315217391 Not the right answer.....
# 656273684991 Not the right answer.....