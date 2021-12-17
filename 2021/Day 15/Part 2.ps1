


$nodes = @{}
#
$pth = ".\2021\day 15\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

#Build The Grid from the input in a 2-dimentional array.

$grid = New-Object 'int[,]' (100*5), (100*5)

$y=0
while (($read = $reader.readline()) -ne $null) {
    for ($x =0; $x -lt $read.Length; $x++) {
        $grid[$x, $y] = [int]::Parse([char]$read[$x])
    }
    $y++
}

$reader.Close()
$reader.Dispose()


#Generate the first column

for ($i = 1; $i -lt 5; $i++) {
    for ($y = 0; $y -lt 100; $y++) {
        for ($x = 0; $x -lt 100; $x++) {
            $val = $grid[$x,$y] + $i
            if ($val -gt 9) {$val -=9}
            $grid[$x, ($y+($i*100))] = $val
        }
    }
}



#Now Generate the remaining columns

for ($y = 0; $y -lt $grid.GetLength(0); $y++) {
    for ($i = 1; $i -lt 5; $i++) {
        for ($x = 0; $x -lt 100; $x++) {
            $val = $grid[$x,$y] + $i
            if ($val -gt 9) {$val -= 9}
            $grid[($x+($i*100)),$y]=$val
        }        
    }
}



#Generate the list so we can work with it..

for ($x = 0; $x -lt $grid.GetLength(0); $x++) {
    for ($y = 0; $y -lt $grid.GetLength(1); $y++) {
        $nodes["$x,$y"] = @{
            node = "$x,$y"
            Weight=$grid[$x,$y]
            Visited=$false
            distance=[int]::MaxValue-1
        }
    }
}



$ymax = $grid.GetLength(1)
$xmax = $grid.GetLength(0)



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
    $cnt++
    if ($cnt % 1000 -eq 0) {Write-Host $cnt}
    $least = $list.First.Value
    $item = $list.First
    while (($item = $item.Next) -ne $null) {
        if ($nodes[$item.Value].Distance -lt $nodes[$least].Distance) {
            $least = $item.Value
        }
    }
    #Select the Least Distance Node
    $node = $nodes[$least]

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

$nodes["$($xmax-1),$($ymax-1)"].Distance
