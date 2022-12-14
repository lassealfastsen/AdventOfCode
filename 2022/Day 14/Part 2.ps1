$pth = ".\2022\Day 14\input.txt"

$in = Get-Content $pth

$cave = @{}


$sandstart = @{x = 500; y = -1 }

foreach ($line in $in) {
    $positions = $line.Split(' -> ')
    $start = @{
        x = [int]$positions[0].Split(',')[0]
        y = [int]$positions[0].Split(',')[1]
    }
    for ($i = 1; $i -lt $positions.Count; $i++) {
        $px = [int]$positions[$i].split(',')[0]
        $py = [int]$positions[$i].split(',')[1]

        if ($py -ne $start.y) {
            $arr = @($py, $start.y) | Sort-Object
            for ($j = $arr[0]; $j -le $arr[1]; $j++) {
                $cave["$px,$j"] = @{x = $px; y = $j; val = '#' }
            }
        } else {
            $arr = @($px, $start.x) | Sort-Object
            for ($j = $arr[0]; $j -le $arr[1]; $j++) {
                $cave["$j,$py"] = @{x = $j; y = $py; val = '#' }
            }
        }
        $start = @{
            x = $px
            y = $py
        }
    }
}

$ymax = $cave.Values.y | Sort-Object -Descending | Select-Object -First 1

$ymax += 1

$OOB = $false
while (!$OOB) {

    #Pour Sand.

    $sandpos = @{x = $sandstart.x; y = $sandstart.y + 1 }


    while ($true) {

        if ($sandpos.y -eq $ymax) { #on the floor so it cant fall further...
            $cave["$($sandpos.x),$($sandpos.y)"] = @{x = $sandpos.x; y = $sandpos.y; val = 'o' }
            break
        }

        if ($null -eq $cave["$($sandpos.x),$($sandpos.y+1)"].val) {
            $sandpos.y++
            continue
        }

        #DL
        if ($null -eq $cave["$($sandpos.x-1),$($sandpos.y+1)"].val) {
            $sandpos.y++
            $sandpos.x--
            continue
        }
        #DR
        if ($null -eq $cave["$($sandpos.x+1),$($sandpos.y+1)"].val) {
            $sandpos.y++
            $sandpos.x++
            continue
        }
        

        $cave["$($sandpos.x),$($sandpos.y)"] = @{x = $sandpos.x; y = $sandpos.y; val = 'o' }
        if ($sandpos.y -eq $sandstart.y + 1) {
            $OOB = $true
        }
        break
    }    
}

($cave.Values | Where-Object { ($_.val -eq 'o') }).Count
