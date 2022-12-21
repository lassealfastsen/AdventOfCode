$pth = ".\2022\Day 15\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

$beacons = @()
$sensors = @()

$xmin = [int]::MaxValue
$xmax = [int]::MinValue

$ymin = [int]::MaxValue
$ymax = [int]::MinValue

while ($null -ne ($read = $reader.ReadLine())) {
    $vals = [regex]::Matches($read, "((-)?[0-9]+)")

    $sensors += @{
        x = [int]$vals[0].Value
        y = [int]$vals[1].Value
    }
    
    $beacons += @{
        x = [int]$vals[2].Value
        y = [int]$vals[3].Value
    }

    if ([int]$vals[0].Value -gt $xmax) {
        $xmax = [int]$vals[0].Value
    }
    if ([int]$vals[0].Value -lt $xmin) {
        $xmin = [int]$vals[0].Value
    }
    if ([int]$vals[1].Value -gt $ymax) {
        $ymax = [int]$vals[1].Value
    }
    if ([int]$vals[1].Value -lt $ymin) {
        $ymin = [int]$vals[1].Value
    }

    if ([int]$vals[2].Value -gt $xmax) {
        $xmax = [int]$vals[2].Value
    }
    if ([int]$vals[2].Value -lt $xmin) {
        $xmin = [int]$vals[2].Value
    }
    if ([int]$vals[3].Value -gt $ymax) {
        $ymax = [int]$vals[3].Value
    }
    if ([int]$vals[3].Value -lt $ymin) {
        $ymin = [int]$vals[3].Value
    }
}

$reader.Close()
$reader.Dispose()

$grid = @{}

#17663348759611#

$q = 1
#Create Grid
for ($x = $xmin; $x -le $xmax; $x++) {
    for ($y = $ymin; $y -le $ymax; $y++) {
        $grid["$x,$y"] = @{
            x    = $x
            y    = $y
            type = $null
        }

        if (($q % 10000) -eq 0 ) {
            "$q - 17663348759611"
        }
        $q++
    }
}


foreach ($beacon in $beacons) {
    $grid["$($beacon.x),$($beacon.y)"].type = "Beacon"
}


foreach ($sensor in $sensors) {
    $grid["$($sensor.x),$($sensor.y)"].type = "Signal"
}


#Draw zones
$s = 1
foreach ($sensor in $sensors) {

    #"$s / 26"
    $beaconhit = $false
    $offset = 1
    while (!$beaconhit) {
        #Draw around..
        $top = @{
            x = $sensor.x
            y = $sensor.y + $offset
        }

        $vectorlength = $offset + 1


        $directions = @('DR', 'DL', 'UL, UR')
        $x = $top.x
        $y = $top.y
        foreach ($dir in $directions) {
            switch ($dir) {
                'DR' { 
                    $xop = 1
                    $yop = -1
                }
                'DL' {
                    $xop = -1
                    $yop = -1
                }
                'UL' {
                    $xop = -1
                    $yop = 1
                }
                'UR' {
                    $xop = 1
                    $yop = 1
                }
            }

            for ($i = 0; $i -lt $vectorlength; $i++) {
                $x += $xop
                $y += $yop

                if ($x -ge $xmin -and $x -le $xmax -and $y -ge $ymin -and $y -le $ymax) {
                    if ($grid["$x,$y"].type -eq "Beacon") { 
                        $beaconhit = $true
                    } else {
                        $grid["$x,$y"].type = "#"
                    }
                }

            }
            
        }

        # #Top to Right:
        # for ($i = 0; $i -lt $vectorlength; $i++) {
        #     $x = $top.x + $i # R
        #     $y = $top.y - $i # D

        #     if ($grid["$x,$y"].type -eq "Beacon") { 
        #         $beaconhit = $true
        #     } else {
        #         $grid["$x,$y"].type = "#"
        #     }
        # }

        # #Right to Bottom:
        # for ($i = 0; $i -lt $vectorlength; $i++) {
        #     $x = $top.x - $i # L
        #     $y = $top.y - $i # D

        #     if ($grid["$x,$y"].type -eq "Beacon") { 
        #         $beaconhit = $true
        #     } else {
        #         $grid["$x,$y"].type = "#"
        #     }
        # }

        # #Bottom to Left:
        # for ($i = 0; $i -lt $vectorlength; $i++) {
        #     $x = $top.x - $i # L
        #     $y = $top.y + $i # U

        #     if ($grid["$x,$y"].type -eq "Beacon") { 
        #         $beaconhit = $true
        #     } else {
        #         $grid["$x,$y"].type = "#"
        #     }
        # }

        # #Left to top:
        # for ($i = 0; $i -lt $vectorlength; $i++) {
        #     $x = $top.x - $i # L
        #     $y = $top.y + $i # U

        #     if ($grid["$x,$y"].type -eq "Beacon") { 
        #         $beaconhit = $true
        #     } else {
        #         $grid["$x,$y"].type = "#"
        #     }
        # }     
        #$offset
        $offset++
        
    }

}


#$grid.Values | Where-Object ({$_.type -eq "Signal"})
#$xmin


#$grid = New-Object 'int[,]' ($xmax - $xmin), ($ymax-$ymin)

($grid.Values | Where-Object { ($_.y -eq 10) -and ($_.type -eq '#') }).Count

