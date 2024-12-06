$content = Get-Content 'C:\git\AdventOfCode\2024\Day 6\input.txt'

$xmax = ($content[0].Length)
$ymax = $content.Count

$obstacles = New-Object 'object[,]' $xmax, $ymax




$path = New-Object 'object[,]' $xmax, $ymax

$padding = 1

$pos = @{
    x      = $null
    y      = $null
    dir    = 'u'
    looped = $false
    exited = $false
}


for ($y = 0; $y -lt $ymax; $y++) {
    for ($x = 0; $x -lt $xmax; $x++) {
        if ($content[$y][$x] -eq '#') {
            #Write-Host "$x,$y"
            $obstacles[$x, $y] = $true
        }
        elseif ($content[$y][$x] -eq '^') {
            $pos.x = $x
            $pos.y = $y
        }
    }
}

#$path[$pos.x, $pos.y] = 1

function Print-Path {
    for ($y = 0; $y -lt $ymax; $y++) {
        for ($x = 0; $x -lt $xmax; $x++) {
            if ($obstaclePos.x -eq $x -and $obstaclePos.y -eq $y) {
                Write-Host 'O' -ForegroundColor DarkYellow  -NoNewline
            }
            elseif ($obstacles[$x, $y]) {
                Write-Host '#' -ForegroundColor Red -NoNewline
            }
            elseif ($path[$x, $y] -eq 1) {
                Write-Host 'X' -ForegroundColor Green -NoNewline
            }
            elseif ($pos.x -eq $x -and $pos.y -eq $y) {
                Write-Host '#' -ForegroundColor Magenta -NoNewline -BackgroundColor Magenta
            }
            else {
                Write-Host '-' -NoNewline
            }
        }
        Write-Host

    }

    Write-Host ""
}

#Print-Path

#

Function Move-Step {
    Param(
        [Parameter()][switch]$Part1
    )
    $part2 = (-not $part1)
    $path[$pos.x, $pos.y] = 1
    switch ($pos.dir) {
        'u' {
            if (($obstacles[$pos.x, ($pos.y - 1)]) -and ($pos.y -gt 0)) {
                
                if ($part2 -and ($script:obstacleHits[$pos.x, $pos.y] -eq $pos.dir) -or ($script:obstacleHits[$pos.x, $pos.y] -eq 'r')) {
                    $pos.looped = $true
                }
                $script:obstacleHits[$pos.x, $pos.y] = $pos.dir   
                $pos.dir = 'r'
                continue
            }
            else {
                $pos.y--
                if ($part1) { $script:part1Length++ }
            }
            continue
        }
        'r' {
            if (($obstacles[($pos.x + 1), ($pos.y)]) -and ($pos.x -lt $xmax)) {
                if ($part2 -and ($script:obstacleHits[$pos.x, $pos.y] -eq $pos.dir) -or ($script:obstacleHits[$pos.x, $pos.y] -eq 'd')) {
                    $pos.looped = $true
                }
                $script:obstacleHits[$pos.x, $pos.y] = $pos.dir
                $pos.dir = 'd'
                continue
            }
            else {
                $pos.x++
                if ($part1) { $script:part1Length++ }
            } 
            continue
        }
        'd' {
            if (($obstacles[$pos.x, ($pos.y + 1)]) -and ($pos.y -lt $ymax)) {
                if ($part2 -and ($script:obstacleHits[$pos.x, $pos.y] -eq $pos.dir) -or ($script:obstacleHits[$pos.x, $pos.y] -eq 'l')) {
                    $pos.looped = $true
                }
                $script:obstacleHits[$pos.x, $pos.y] = $pos.dir
                $pos.dir = 'l'
                continue
            }
            else {
                $pos.y++
                if ($part1) { $script:part1Length++ }
            }
            continue
        }
        'l' {
            if (($obstacles[($pos.x - 1), ($pos.y)]) -and ($pos.x -gt 0)) {
                if ($part2 -and ($script:obstacleHits[$pos.x, $pos.y] -eq $pos.dir) -or ($script:obstacleHits[$pos.x, $pos.y] -eq 'u')) {
                    $pos.looped = $true
                }
                $script:obstacleHits[$pos.x, $pos.y] = $pos.dir
                $pos.dir = 'u'
                continue
            }
            else {
                $pos.x--
                if ($part1) { $script:part1Length++ }
            }
            continue
        }
    }

    if (-not (($pos.x -ge 0) -and ($pos.x -lt $xmax) -and ($pos.y -ge 0) -and ($pos.y -lt $ymax))) {
        $pos.exited = $true
    }
}


#Save Starting Position
$startPos = $pos.Clone()


#Part 1
$script:part1Length = 0
#while (($pos.x -ge 0) -and ($pos.x -lt $xmax) -and ($pos.y -ge 0) -and ($pos.y -lt $ymax)) {
while (-not $pos.exited) {
    Move-Step -Part1
}

($path | Measure-Object -Sum).Sum
#$script:part1Length

#Print-Path

$possibleLocations = @()

$steps = 0
$obstaclePos = @{
    x = $null
    y = $null
}
#Part 2
$retries = 0
$alloptionstried = $false
#while ($steps -lt ($script:part1Length * 4)) {

#Fuck it i'm brute forcing.


for ($x = 0; $x -lt $xmax; $x++) {
    for ($y = 0; $y -lt $ymax; $y++) {
        $pos = $startPos.Clone()
        $script:obstacleHits = New-Object 'object[,]' $xmax, $ymax
        $path = New-Object 'object[,]' $xmax, $ymax

        if ($obstacles[$x, $y]) {
            continue
        }

        $obstacles[$x, $y] = $true

        while (-not ($pos.exited -or $pos.looped)) {
            Move-Step
        }
        if ($pos.looped) {
            if ($possibleLocations -notcontains "$x,$y") {
                $possibleLocations += "$x,$y"
            }
            Write-Host $possibleLocations[-1]
        }
        $obstacles[$x, $y] = $false
    }
}


# while (-not $alloptionstried) {
#     try {
#         $pos = $startPos.Clone()
#         $script:obstacleHits = New-Object 'object[,]' $xmax, $ymax
#         $path = New-Object 'object[,]' $xmax, $ymax
#         for ($i = 0; $i -lt $steps; $i++) {
#             #Move until you obstacle must be placed
#             Move-Step
#         }
#         #Move a step if X=0 and dir=lor Y=0 and dir=u to avoid index looping
#         while (($pos.x -eq 0 -and $pos.dir -eq 'l') -or ($pos.y -eq 0 -and $pos.dir -eq 'u')) {
#             Move-Step
#         }
#         switch ($pos.dir) {
#             'u' { if (-not ($obstacles[$pos.x, ($pos.y - 1)])) { $obstacles[$pos.x, ($pos.y - 1)] = $true ; $obstaclePos.x = $pos.x; $obstaclePos.y = $pos.y - 1 } }
#             'r' { if (-not ($obstacles[($pos.x + 1), $pos.y])) { $obstacles[($pos.x + 1), $pos.y] = $true ; $obstaclePos.x = $pos.x + 1; $obstaclePos.y = $pos.y } }
#             'd' { if (-not ($obstacles[$pos.x, ($pos.y + 1)])) { $obstacles[$pos.x, ($pos.y + 1)] = $true ; $obstaclePos.x = $pos.x; $obstaclePos.y = $pos.y + 1 } }
#             'l' { if (-not ($obstacles[($pos.x - 1), $pos.y])) { $obstacles[($pos.x - 1), $pos.y] = $true ; $obstaclePos.x = $pos.x - 1; $obstaclePos.y = $pos.y } }
#         }

#         #if ($possibleLocations -contains "$($obstaclePos.x),$($obstaclePos.y)") {
            
#         #Write-Host "$($obstaclePos.x),$($obstaclePos.y)" -ForegroundColor Yellow
            
#         #Print-Path
#         #Read-Host
#         #$steps++
#         #continue
#         #}

#         $q = 0


#         if ($pos.looped) {
#             if ($possibleLocations -notcontains "$($obstaclePos.x),$($obstaclePos.y)") {
#                 $possibleLocations += "$($obstaclePos.x),$($obstaclePos.y)"
#             }
#             Write-Host $possibleLocations[-1]
#         }


#         #Remove-Obstacle

#         #Print-Path
#         $obstacles[$obstaclePos.x, $obstaclePos.y] = $false
#         $steps++
#         #Read-Host
#     }
#     catch {
#         if ($retries -lt 1) {
#             Write-Host ($possibleLocations.Count) -ForegroundColor Yellow
#             $retries++
#         }
#         else {
#             $alloptionstried = $true
#         }
        
#     }
# }


Write-Host ($possibleLocations.Count)