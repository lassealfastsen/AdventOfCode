#Part 1
$pth = '.\2023\Day 3\input.txt'

$reader = New-Object System.IO.StreamReader($pth)


$grid = @{}


$y = 0
$xmax = 0
$ymax = 0
while ($null -ne ($read = $reader.ReadLine())) {
    if ($y -gt $ymax) { $ymax = $y }
    $xmax = $read.Length - 1

    for ($x = 0; $x -lt $read.Length; $x++) {
        $grid["$($x),$($y)"] = $read[$x]
    }
    $y++
}


#pad the grid...
$y = -1
for ($x = -1; $x -le $xmax + 1; $x++) {
    $grid["$($x),$y"] = '.'
}
$y = $ymax + 1
for ($x = -1; $x -le $xmax + 1; $x++) {
    $grid["$($x),$y"] = '.'
}

$x = -1
for ($y = -1; $y -le $ymax + 1; $y++) {
    $grid["$($x),$y"] = '.'
}
$x = $xmax + 1
for ($y = -1; $y -le $ymax + 1; $y++) {
    $grid["$($x),$y"] = '.'
}




$reader.Close()
$reader.Dispose()


#loop the lines

function Get-Neighbours {
    param (
        [int]$x,
        [int]$y
    )
    
    return @(
        "$($x-1),$($y-1)",
        "$($x),$($y-1)",
        "$($x+1),$($y-1)",
        "$($x+1),$($y)",
        "$($x+1),$($y+1)",
        "$($x),$($y+1)",
        "$($x-1),$($y+1)",
        "$($x-1),$($y)"
    )
}

$nums = 0

for ($y = 0; $y -le $ymax; $y++) {

    for ($x = 0; $x -le $xmax; $x++) {
        if ($grid["$($x),$($y)"] -match '[0-9]') {
            $num = "$($grid["$($x),$($y)"])"
            $validnum = $false
            while ($true) {
                
                $next = $grid["$($x),$($y)"]
                if ($next -notmatch '[0-9]') {
                    break
                } 

                $num = "$($num)$($next)" 
                foreach ($neighbour in (Get-Neighbours -x $x -y $y)) {
                    if ($grid[$neighbour] -notmatch '(\.|[0-9])') { $validnum = $true }
                }    
                $x++
            }

            if ($validnum) { 
                #$num.Substring(1)
                #Fucked up above fo i had to check the same number twice (easy fix, ignore the first char of each number :D)
                $nums += [int]::Parse($num.Substring(1)) 
            }
        }
        
    }
}


Write-Host "Part 1:"
$nums 
Write-Host "----------------"


##############PArt 2

#Find all the Gear symbols.

#cannot get where-object to work...
##$grid | Where-Object { ($_.Value -eq "*" ) }
$gears = @()
foreach ($key in $grid.Keys) {
    if ($grid[$key] -match '\*') {
        $gears += [PSCustomObject]@{
            key          = $key
            adjacantnums = @()
        }
    }
}

function complete-number {
    Param(
        $startpos
    )
    
    
    
    $px = [int]::Parse($startpos.split(',')[0])
    $py = [int]::Parse($startpos.split(',')[1])

    $positions = @(
        "$($px),$($py)"
    )
    $val = "$($grid["$($px),$($py)"])"
    while ($true) {
        #Search Left 
        $px--
        if ($grid["$($px),$($py)"] -match '[0-9]') {
            $val = "$($grid["$($px),$($py)"])$($val)"
            $positions += "$($px),$($py)"
        }
        else {
            break
        }
    }

    $px = [int]::Parse($startpos.split(',')[0])
    while ($true) {
        #search right
        
        $px++
        if ($grid["$($px),$($py)"] -match '[0-9]') {
            $val = "$($val)$($grid["$($px),$($py)"])"
            $positions += "$($px),$($py)"
        }
        else {
            break
        }
    }

    return @{
        Value     = $val 
        Positions = $positions
    }
}




for ($g = 0; $g -lt $gears.Count; $g++) {
    $ignorelist = @()
    $gear = $gears[$g]
    foreach ($neighbour in (Get-Neighbours -x $gear.key.split(',')[0] -y $gear.key.split(',')[1])) {
        
        if ($grid[$neighbour] -match '[0-9]' -and $neighbour -notin $ignorelist) {
            $num = complete-number $neighbour
            $gears[$g].adjacantnums += $num.Value
            $ignorelist += $num.Positions

        }
    }
}


$totalratio = 0

$gears | Where-Object { ($_.adjacantnums.Count -eq 2) } | ForEach-Object {
    $totalratio += ($_.adjacantnums -join '*' | Invoke-Expression)
}

Write-Host "Part 2:"
$totalratio
Write-Host "----------------"