Class JunctionBox {
    [int]$x
    [int]$y
    [int]$z
    [guid]$id = [guid]::NewGuid()
    [guid]$circuitId
    [JunctionBox[]]$DirectNeighbors = @()
    [bool]$connected = $false
    [int]$nearestNeighborDistance = [int]::MaxValue
    [JunctionBox]$nearestNeighbor = $null
    JunctionBox ([int]$x, [int]$y, [int]$z) {
        $this.x = $x
        $this.y = $y
        $this.z = $z
    }



    [void]GetNearestNeighbor([JunctionBox[]]$allBoxes) {
        $this.nearestNeighborDistance = [int]::MaxValue

        foreach ($box in $allBoxes) {
            if (($box.id -ne $this.id) -and (($this.circuitId -eq [guid]::Empty) -or ($box.id -notin $this.DirectNeighbors.ID -and $box.circuitId -ne $this.circuitId))) {
                $d = [Math]::sqrt( [Math]::Pow(($this.x - $box.x), 2) + [Math]::Pow(($this.y - $box.y), 2) + [Math]::Pow(($this.z - $box.z), 2) )
                if ($d -lt $this.nearestNeighborDistance) {
                    $dist = $d
                    $this.nearestNeighbor = $box
                    $this.nearestNeighborDistance = $d
                }
            }
        }

    }
}


class Circuit {
    [guid]$id = [guid]::NewGuid()
    [JunctionBox[]]$Global:boxes = @()
    hidden [int]$c = $($this | Add-Member ScriptProperty 'Count' `
        {
            # get
            return $this.boxes.Count
        })
}


$reader = New-Object System.IO.StreamReader("C:\git\AdventOfCode\2025\Day 8\input.txt")

[JunctionBox[]]$Global:boxes = @()
[Circuit[]]$circuits = @()


while ( ($read = $reader.ReadLine()) -ne $null) {
    $parts = $read -split ","
    $box = [JunctionBox]::new([int]$parts[0], [int]$parts[1], [int]$parts[2])
    $Global:boxes += $box
}

$reader.Close()
$reader.Dispose()

foreach ($box in $Global:boxes) {
    $box.GetNearestNeighbor($Global:boxes)
}

$i = 1
$p1 = 0
while ($Global:boxes.Where{ $_.connected -eq $false }.Count -gt 0) {
    $i++
    #for ($i = 1; $i -lt 1000; $i++) {
    Write-Host "---- Iteration $i ----`n"

    foreach ($box in ($Global:boxes | Where-Object { $_.connected -eq $true })) {
        $box.GetNearestNeighbor($Global:boxes)
    }

    $Global:boxes = $Global:boxes | Sort-Object -Property nearestNeighborDistance
    #$Global:boxes | ft x, y, z, id, nearestNeighborDistance, circuitId, connected 
    

    if ($Global:boxes[0].connected -eq $false -and $Global:boxes[0].nearestNeighbor.connected -eq $false) {
        $circuit = [Circuit]::new()
        $circuit.boxes += $Global:boxes[0]
        $circuit.boxes += $Global:boxes[0].nearestNeighbor
        $circuits += $circuit


        $Global:boxes[0].circuitId = $circuit.id
        $Global:boxes[0].connected = $true
        
        $Global:boxes[0].DirectNeighbors += $Global:boxes[0].nearestNeighbor
        $Global:boxes | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.id } | ForEach-Object {
            $_.DirectNeighbors += $Global:boxes[0]
            $_.circuitId = $circuit.id
            $_.connected = $true
           
        }


    }
    elseif ($Global:boxes[0].connected -eq $true -and $Global:boxes[0].nearestNeighbor.connected -eq $false) {
        $circuit = $circuits | Where-Object { $_.id -eq $Global:boxes[0].circuitId }
        $circuit.boxes += $Global:boxes[0].nearestNeighbor

        $Global:boxes[0].DirectNeighbors += $Global:boxes[0].nearestNeighbor
        
        $Global:boxes | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.id } | ForEach-Object {
            $_.DirectNeighbors += $Global:boxes[0]
            $_.circuitId = $circuit.id
            $_.connected = $true
            #$_.GetNearestNeighbor($Global:boxes)
        }
    }
    elseif ($Global:boxes[0].connected -eq $false -and $Global:boxes[0].nearestNeighbor.connected -eq $true) {
        $circuit = $circuits | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.circuitId }
        $circuit.boxes += $Global:boxes[0]

        $Global:boxes[0].circuitId = $circuit.id
        $Global:boxes[0].connected = $true
        $Global:boxes[0].DirectNeighbors += $Global:boxes[0].nearestNeighbor
        #$Global:boxes[0].GetNearestNeighbor($Global:boxes)
        $Global:boxes | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.id } | ForEach-Object {
            $_.DirectNeighbors += $Global:boxes[0]
            #$_.GetNearestNeighbor($Global:boxes)
        }
    }
    else {
        #both connected
        $circuit1 = $circuits | Where-Object { $_.id -eq $Global:boxes[0].circuitId }
        $circuit2 = $circuits | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.circuitId }

        if ($circuit1.id -ne $circuit2.id) {
            $circuit1.boxes += $circuit2.boxes
            foreach ($b in $circuit2.boxes) {
                $b.circuitId = $circuit1.id
            }
            $circuits = $circuits | Where-Object { $_.id -ne $circuit2.id }

            $Global:boxes[0].DirectNeighbors += $Global:boxes[0].nearestNeighbor
            #$Global:boxes[0].GetNearestNeighbor($Global:boxes)
            $Global:boxes | Where-Object { $_.id -eq $Global:boxes[0].nearestNeighbor.id } | ForEach-Object {
                $_.DirectNeighbors += $Global:boxes[0]
                #$_.GetNearestNeighbor($Global:boxes)
            }
        }
    }


    # $Global:boxes | Where-Object { $_.DirectNeighbors.ID -contains $Global:boxes[0].id } | ForEach-Object {
    #     $_.GetNearestNeighbor($Global:boxes)
    # }
    # $Global:boxes | Where-Object { $_.DirectNeighbors.ID -contains $Global:boxes[0].nearestNeighbor.id } | ForEach-Object {
    #     $_.GetNearestNeighbor($Global:boxes)
    # }

    if ($i -eq 1000) {
        $p1 = ($circuits | Sort-Object -Property Count -Descending | Select-Object -ExpandProperty Count -First 3 ) -join " * " | Invoke-Expression
    }

    Write-Host "P1: $p1"
}


#Doesn't work always gives 1000, but it works for the sample input