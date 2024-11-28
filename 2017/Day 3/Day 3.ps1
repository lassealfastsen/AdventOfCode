$square = 361527

$xmin = 0
$xmax = 0
$ymin = 0
$ymax = 0

$pos = [PSCustomObject]@{
    sumval = 1
    val    = 1
    x      = 0
    y      = 0
}

$dir = 'r'

$list = @{}
$list["0,0"] = $pos.psobject.Copy()
$notfound = $true
while ($pos.val -lt $square) {
    $pos.sumval = 0
    switch ($dir) {
        'r' { 
            $pos.x += 1
            if ($pos.x -gt $xmax) {
                $xmax += 1
                $dir = 'u'
            }
        }
        'u' {
            $pos.y += 1
            if ($pos.y -gt $ymax) {
                $ymax += 1
                $dir = 'l'
            }
        }
        'l' {
            $pos.x -= 1
            if ($pos.x -lt $xmin) {
                $xmin -= 1
                $dir = 'd'
            }
        }
        'd' {
            $pos.y -= 1
            if ($pos.y -lt $ymin) {
                $ymin -= 1
                $dir = 'r'
            }
        }
    }
    $pos.val += 1
    if ($notfound) {
        if ($null -ne $list["$($pos.x-1),$($pos.y)"]) {
            #Left
            $pos.sumval += $list["$($pos.x-1),$($pos.y)"].sumval
        }
        if ($null -ne $list["$($pos.x),$($pos.y-1)"]) {
            #Below
            $pos.sumval += $list["$($pos.x),$($pos.y-1)"].sumval
        }
        if ($null -ne $list["$($pos.x+1),$($pos.y)"]) {
            #Right
            $pos.sumval += $list["$($pos.x+1),$($pos.y)"].sumval
        }
        if ($null -ne $list["$($pos.x),$($pos.y+1)"]) {
            #Above
            $pos.sumval += $list["$($pos.x),$($pos.y+1)"].sumval
        }

        if ($null -ne $list["$($pos.x-1),$($pos.y+1)"]) {
            #Left Diagonal Up
            $pos.sumval += $list["$($pos.x-1),$($pos.y+1)"].sumval
        }
        if ($null -ne $list["$($pos.x-1),$($pos.y-1)"]) {
            #Left Diagonal Down
            $pos.sumval += $list["$($pos.x-1),$($pos.y-1)"].sumval
        }
        if ($null -ne $list["$($pos.x+1),$($pos.y+1)"]) {
            #Right Diagonal Up
            $pos.sumval += $list["$($pos.x+1),$($pos.y+1)"].sumval
        }
        if ($null -ne $list["$($pos.x+1),$($pos.y-1)"]) {
            #Right Diagonal Down
            $pos.sumval += $list["$($pos.x+1),$($pos.y-1)"].sumval
        }
        $list["$($pos.x),$($pos.y)"] = $pos.psobject.Copy()
        if ($pos.sumval -gt $square) {
            $distance = [math]::Abs($pos.x) + [math]::Abs($pos.y)

            Write-Host "Part 2 Value: " -NoNewline
            Write-Host $pos.sumval -ForegroundColor Green
            $notfound = $false
        }
    }

    #Write-Host "$($pos.x),$($pos.y) = $($pos.sumval)"

}


$distance = [math]::Abs($pos.x) + [math]::Abs($pos.y)

Write-Host "Part 1 Steps: " -NoNewline
Write-Host $distance -ForegroundColor Green