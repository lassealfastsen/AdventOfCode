$head = @{
    x = 0
    y = 0
}

$tail = @{
    pos   = "0,0"
    steps = [string[]]@()
}


$pth = '.\2022\Day 9\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

while ($null -ne ($read = $reader.ReadLine())) {
    
    $direction = $read.Split(' ')[0]
    $steps = [int]$read.Split(' ')[1]

    switch ($direction) {
        'R' { 
            for ($i = 0; $i -lt $steps; $i++) {
                $head.x++
                #should the tail Move?
                $x = $head.x
                $y = $head.y
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
                if ($tail.pos -notin $touchingpositions) {
                    $tail.steps += $tail.pos
                    $tail.pos = "$($x-1),$y"
                }
            }
        }
        'L' { 
            for ($i = 0; $i -lt $steps; $i++) {
                $head.x--
                #should the tail Move?
                $x = $head.x
                $y = $head.y
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
                if ($tail.pos -notin $touchingpositions) {
                    $tail.steps += $tail.pos
                    $tail.pos = "$($x+1),$y"
                }
            }
        }
        'U' {
            for ($i = 0; $i -lt $steps; $i++) {
                $head.y++
                #should the tail Move?
                $x = $head.x
                $y = $head.y
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
                if ($tail.pos -notin $touchingpositions) {
                    $tail.steps += $tail.pos
                    $tail.pos = "$x,$($y-1)"
                }
            }
        }
        'D' {
            for ($i = 0; $i -lt $steps; $i++) {
                $head.y--
                #should the tail Move?
                $x = $head.x
                $y = $head.y
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
                if ($tail.pos -notin $touchingpositions) {
                    $tail.steps += $tail.pos
                    $tail.pos = "$x,$($y+1)"
                }
            }
        }
        Default { Write-Host "?????" }
    }
}
($tail.steps | select -Unique).Count + 1



$reader.Close()
$reader.Dispose()