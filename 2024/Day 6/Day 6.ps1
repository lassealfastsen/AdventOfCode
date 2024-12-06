$content = Get-Content 'C:\git\AdventOfCode\2024\Day 6\input.txt'

$xmax = ($content[0].Length)
$ymax = $content.Count

$obstacles = New-Object 'object[,]' $xmax, $ymax

$path = New-Object 'object[,]' $xmax, $ymax

$padding = 1

$pos = @{
    x   = $null
    y   = $null
    dir = 'u'
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
            if ($obstacles[$x, $y]) {
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
    $path[$pos.x, $pos.y] = 1
    #Print-Path
    switch ($pos.dir) {
        'u' {
            if (($obstacles[$pos.x, ($pos.y - 1)]) -and ($pos.y -gt 0)) {
                $pos.dir = 'r'
            }
            else {
                $pos.y--
            }
            continue
        }
        'r' {
            if (($obstacles[($pos.x + 1), ($pos.y)]) -and ($pos.x -lt $xmax)) {
                $pos.dir = 'd'
            }
            else {
                $pos.x++
            } 
            continue
        }
        'd' {
            if (($obstacles[$pos.x, ($pos.y + 1)]) -and ($pos.y -lt $ymax)) {
                $pos.dir = 'l'
            }
            else {
                $pos.y++
            }
            continue
        }
        'l' {
            if (($obstacles[($pos.x - 1), ($pos.y)]) -and ($pos.x -gt 0)) {
                $pos.dir = 'u'
            }
            else {
                $pos.x--
            }
            continue
        }
    }
    #Write-Host "$($pos.x),$($pos.y)"
    

    
    #Start-Sleep -Milliseconds 50
}

$q = 0
while (($pos.x -ge 0) -and ($pos.x -lt $xmax) -and ($pos.y -ge 0) -and ($pos.y -lt $ymax)) {
    Move-Step
    $q++
    if (($q % 50 -eq 0) -and (($path | Measure-Object -Sum).Sum -ge 5200)) {
        Print-Path
        Write-Host "$($pos.x),$($pos.y) - $($pos.dir) - $(($path | Measure-Object -Sum).Sum)"
    }
}

($path | Measure-Object -Sum)


