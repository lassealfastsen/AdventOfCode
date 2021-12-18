


$nodes = @{}
#
$pth = "C:\Users\lal\OneDrive - Lyngsoe Systems\Documents\github\AdventOfCode\AdventOfCode\2021\day 15\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$x = 0
$y = 0
while (($read = $reader.Readline()) -ne $null) { 
    for ($x = 0; $x -lt $read.Length; $x++) {
        $nodes["$x,$y"] = @{
            node = "$x,$y"
            Weight=[int]::Parse([char]$read[$x])
            Visited=$false
            distance=[int]::MaxValue-1
        }
    }
    $y++
}

$ymax = $y
$xmax = $x


$reader.Close()
$reader.Dispose()





Function Get-Neighbors {
    Param(
        [Parameter(Position=1)][string]$Pos
    )

    $x = [int]$Pos.Split(',')[0]
    $y = [int]$Pos.Split(',')[1]

    $neighbors = @()

    if ($y -gt 0) {$neighbors += @{Source="$x,$y";Destination="$x,$($y-1)";Weight=($nodes["$x,$($y-1)"].Weight)}}
    if ($y -lt $ymax) {$neighbors += @{Source="$x,$y";Destination="$x,$($y+1)";Weight=($nodes["$x,$($y+1)"].Weight)}}
    if ($x -gt 0) {$neighbors += @{Source="$x,$y";Destination="$($x-1),$y";Weight=($nodes["$($x-1),$y"].Weight)}}
    if ($x -lt $xmax) {$neighbors += @{Source="$x,$y";Destination="$($x+1),$y";Weight=($nodes["$($x+1),$y"].Weight)}}


    Return $neighbors
}


$list = New-Object System.Collections.Generic.LinkedList[String]

# $list.Add("$xmax,$ymax")
# $nodes["$xmax,$ymax"].distance=0
$list.Add("0,0")
$nodes["0,0"].distance=0

$cost = 0
$cnt = 0
while ($list.Count -gt 0) {
    #$node.node
    #$cnt++
    #if ($cnt % 1000 -eq 0) {Write-Host $cnt}
    if ($nodes["$($xmax),$($ymax)"].Visited) { break :loop }
    $least = $list.First.Value
    $item = $list.First
    while (($item = $item.Next) -ne $null) {
        if ($nodes[$item.Value].Distance -lt $nodes[$least].Distance) {
            $least = $item.Value
        }
    }
    #Select the Least Distance Node
    $node = $nodes[$least]

    if ($least -eq "$xmax,$ymax") { break :loop }

    #set the node Visited to avoid ending up here again
    $nodes[$node.Node].Visited = $true

    #Remove the node from the queue
    $null = $list.Remove($least)

    #Get a list of Neigbours
    $neighbours = Get-Neighbors $node.node

    

    foreach ($neighbour in $neighbours) { #| Sort-Object Weight, Destination
        #If the Neighbours Distance is reduced compared to itself in the nodes list Reduce the value and add it to the queue
        if (($node.Distance + $neighbour.Weight -lt $nodes[$neighbour.Destination].Distance) -and ($nodes[$neighbour.Destination].Visited -eq $false)) {
            $nodes[$neighbour.Destination].Distance = $node.Distance + $neighbour.Weight
            $null = $list.AddLast($neighbour.Destination)
        }      
    }
}


$nodes["$($xmax-1),$($ymax-1)"].DIstance
#$nodes["$xmax,$ymax"].Distance
