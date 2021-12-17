$Target = @{
    xmin = 175
    xmax = 227
    ymin = -79
    ymax = -134
}

# $Target = @{
#     xmin = 20
#     xmax = 30
#     ymin = -5
#     ymax = -10
# }



Function Simulate-path {
    Param(
        [Parameter(Position=1)][int]$xstart,
        [Parameter(Position=2)][int]$ystart,
        [Parameter(Position=3)][int]$vectorx,
        [Parameter(Position=4)][int]$vectory
    )

    $posx = $xstart
    $posy = $ystart
    $currentvextorx = $vectorx
    $currentvextory = $vectory
    $hit = $false
    $maxy = 0
    while (
        (($posx -le $Target.xmax) -and ($posy -ge $Target.ymax) -and (-not $hit))
    ) {
        $posx += $currentvextorx
        $posy += $currentvextory
        $currentvextory--
        if ($currentvextorx -gt 0) {$currentvextorx--}
        if ($posy -gt $maxy) {$maxy = $posy}
        if (($posx -ge $Target.xmin) -and ($posx -le $Target.xmax) -and ($posy -ge $Target.ymax) -and ($posy -le $Target.ymin)) {
            $hit = $true
        }
    }


    return @{
        LastPosition = @{
            Posx = $posx
            Posy = $posy
        }
        Vector = @{
            vectorx = $vectorx
            vectory = $vectory
        }
        MaxHeight = $maxy
        Hit = $hit

    }
}

$paths = @()


for ($x = 0; $x -le $Target.xmax; $x++) {
    for ($y = ($Target.ymax*-1); ($y -gt ($Target.ymax -1)); $y--) {
        #"$x, $y"
        $paths += (Simulate-path 0 0 $x $y)
    }
}


#Part 1
($paths | Where-Object {($_.Hit)} | Sort-Object MaxHeight -Descending | Select-Object -First 1).MaxHeight

#Part 2
($paths | Where-Object {($_.Hit)}).Count

