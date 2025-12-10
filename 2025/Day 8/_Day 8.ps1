Class Circuit {
    [JunctionBox[]]$JunctionBoxes
    [guid]$ID

    [int]$Count

    [guid[]]$containedIDs

    Circuit() {
        $this.JunctionBoxes = @()
        $this.containedIDs = @()
        $this.ID = (New-Guid).Guid
    }

    [void]Add([JunctionBox]$JB) {
        $this.JunctionBoxes += $JB
        $this.containedIDs += $JB.ID
        $this.Count = ($this.containedIDs | Select-Object -Unique).Count
    }

}


Class JunctionBox {
    [guid]$ID
    [int]$x
    [int]$y
    [int]$z
    [bool]$inCircuit
    [guid]$circuitID
    [guid[]]$circuits
    [int]$connections 
    [int]$nearestNeibourDistance = [int]::MaxValue
    [JunctionBox]$nearestNeighbour

    
    JunctionBox ($X, $Y, $Z) {
        $this.ID = (New-Guid).Guid
        $this.x = $X
        $this.y = $Y
        $this.z = $Z
        $this.inCircuit = $false
        $this.circuits = @()
        $this.connections = 0
    }

    hidden [int]GetDistance([JunctionBox]$JB) {
        $dx = [Math]::Pow($this.x - $JB.x, 2)
        $dy = [Math]::Pow($this.y - $JB.y, 2)
        $dz = [Math]::Pow($this.z - $JB.z, 2)

        $dist = [Math]::Sqrt($dx + $dy + $dz)

        return $dist
    }

    [void]FindNearestNeighbour([JunctionBox[]]$Neighbours) {
        $this.nearestNeibourDistance = [int]::MaxValue
        foreach ($Neighbour in $Neighbours) {
            
            if ((Compare-Object $this.circuits $Neighbour.circuits -ExcludeDifferent).Count -gt 0) {
                $dist = [int]::MaxValue
            }
            elseif (([guid]::Empty -eq $this.circuitID) -or (($this.circuitID -ne $Neighbour.circuitID))) {
                $dist = $this.GetDistance($Neighbour)    
            }
            else {
                $dist = [int]::MaxValue
            }
            if ($dist -lt $this.nearestNeibourDistance) {
                $this.nearestNeibourDistance = $dist
                $this.nearestNeighbour = $Neighbour
            }
        }
    }
}


[Circuit[]]$Circuits = @()
[JunctionBox[]]$JunctionBoxes = @()



$reader = New-Object System.IO.StreamReader('C:\Temp\AoC\AdventOfCode\2025\Day 8\input.txt')

while ($null -ne ($read = $reader.ReadLine())) {

    $JunctionBoxes += [JunctionBox]::new(($read.Split(',')[0]), ($read.Split(',')[1]), ($read.Split(',')[2]))
}

$reader.Close()
$reader.Dispose()




# foreach ($JunctionBox in $JunctionBoxes) {
#     $JunctionBox.FindNearestNeighbour(($JunctionBoxes | Where-Object { ($_.Id -ne $JunctionBox.ID) }))
# }

# $JunctionBoxes = $JunctionBoxes | Sort-Object nearestNeibourDistance

$JunctionBoxes | ft ID, x, y, z, nearestNeibourDistance, circuits

# $c = [Circuit]::new()
# $c.Add($JunctionBoxes[0])
# $c.Add($JunctionBoxes[1])
# $Circuits += $c
# $JunctionBoxes[0].inCircuit = $true
# $JunctionBoxes[0].circuitID = $c.ID
# $JunctionBoxes[1].inCircuit = $true
# $JunctionBoxes[1].circuitID = $c.ID


while (($JunctionBoxes.connections | Measure-Object -Sum).Sum -lt 10) {

    #}
    #for ($i = 0; $i -le 10; $i++) {
    foreach ($JunctionBox in $JunctionBoxes) {
        $JunctionBox.FindNearestNeighbour(($JunctionBoxes | Where-Object { ($_.Id -ne $JunctionBox.ID) }))
    }
    
    $JunctionBoxes = $JunctionBoxes | Sort-Object nearestNeibourDistance
    

    $currentJB = $JunctionBoxes[0]
    $Neighbour = $JunctionBoxes | Where-Object { $_.ID -eq $currentJB.nearestNeighbour.ID }

    if ($currentJB.circuits.count -eq 0 -and $Neighbour.circuits.Count -eq 0) {
   
        $c = [Circuit]::new()
        $c.Add($currentJB)
        $c.Add($Neighbour)
        $Circuits += $c

        $currentJB.circuits += $c.ID
        $Neighbour.circuits += $c.ID
        #$currentJB.circuitID = $c.ID
        $currentJB.inCircuit = $true
        #$Neighbour.circuitID = $c.ID
        $Neighbour.inCircuit = $true
    }
    else {
        if ($currentJB.inCircuit) {
            ($Circuits | Where-Object { ($_.ID -in $currentJB.circuits) }).Add($Neighbour)
            $Neighbour.circuits += $currentJB.circuits[0]
            $Neighbour.inCircuit = $true
        }
        else {
            ($Circuits | Where-Object { ($_.ID -in $Neighbour.circuits) }).Add($currentJB)
            $currentJB.circuits += $Neighbour.circuits[0]
            $currentJB.inCircuit = $true
        }    

    }
    $currentJB.connections++
    $JunctionBoxes | ft ID, x, y, z, nearestNeibourDistance, circuits
}






$circuitCount = 0

foreach ($Circuit in $Circuits) {
    $circuitCount += $Circuit.Count

}



$JunctionBoxes | ft






