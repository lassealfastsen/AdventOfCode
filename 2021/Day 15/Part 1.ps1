function New-Edge ($From, $To, $Attributes, [switch]$AsObject) {
    $null = $PSBoundParameters.Remove('AsObject')
    $ht = [Hashtable]$PSBoundParameters
    if ($AsObject) {
        return [PSCustomObject]$ht
    }
    return $ht
}


function New-Node ($Name, $Attributes) {
    [Hashtable]$PSBoundParameters
}


$nodes = @{}
$pth = ".\2021\day 15\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$x = 0
$y = 0
while (($read = $reader.Readline()) -ne $null) { 
    for ($x = 0; $x -lt $read.Length; $x++) {
        $nodes["$x,$y"]  = [int]::Parse([char]$read[$x])
    }
    $y++
}

$ymax = $y-1
$xmax = $x-1


$reader.Close()
$reader.Dispose()


$distances = @{"0,0"=0}
$list = New-Object System.Collections.Generic.LinkedList[string]
$null = $list.AddFirst("0,0")

Function Get-Neighbors {
    Param(
        [Parameter(Position=1)][string]$Pos
    )

    $x = [int]$Pos.Split(',')[0]
    $y = [int]$Pos.Split(',')[1]

    $neighbors = @()

    if ($x -gt 0) {$neighbors += @{Source="$x,$y";Destination="$($x-1),$y";Distance=$nodes["$($x-1),$y"]}}
    if ($x -lt 9) {$neighbors += @{Source="$x,$y";Destination="$($x+1),$y";Distance=$nodes["$($x+1),$y"]}}
    if ($y -gt 0) {$neighbors += @{Source="$x,$y";Destination="$x,$($y-1)";Distance=$nodes["$x,$($y-1)"]}}
    if ($y -lt 9) {$neighbors += @{Source="$x,$y";Destination="$x,$($y+1)";Distance=$nodes["$x,$($y+1)"]}}

    Return $neighbors
}



while ($list.Count -gt 0) {
    $node = $list.First.Value
    $null = $list.RemoveFirst()
    $node
    $neighbours = Get-Neighbors $node

    $neighbours = $neighbours.where{($_.Destination -notin $distances.Keys)}
    foreach ($neighbour in $neighbours) {
        $distances[$neighbour.Destination] = ($distances.$node + $nodes.($neighbour.Destination))
        $null = $list.AddLast($neighbour.Destination)
    }
    $least = ($neighbours.GetEnumerator() | Sort-Object Distance | Select -First 1).Distance

}













### get-dijkstra.ps1
$INFINITY = [int]::MaxValue-1
function edge ([int] $weight, [string] $dest)
{
    @{weight = $weight; dest = $dest}
}

function Vertex( [object[]] $connections)
{
    @{
       connections = $connections; # An array of weighted arcs
       numconnect = $connections.length
       distance = $INFINITY
       isDead = $false
    }
}

function Dijkstra([object[]] $graph, [] $source)
{
    [int] $nodecount = $graph.length
    $graph[$source].distance = 0
    for($i = 0; $i -lt $nodecount; $i++) {
        $min = $INFINITY+1
        # find the unchecked node closest to the source
        for($j = 0; $j -lt $nodecount; $j++) {
            if(! $graph[$j].isDead -and $graph[$j].distance -lt $min) {
                $next = $j
                $min = $graph[$j].distance
            }
        }
        # check all paths from node 
        for($j = 0; $j -lt $graph[$next].numconnect; $j++)
        {
            if($graph[$graph[$next].connections[$j].dest].distance -gt
               $graph[$next].distance + $graph[$next].connections[$j].weight)
            {
                $graph[$graph[$next].connections[$j].dest].distance =
                    $graph[$next].distance + $graph[$next].connections[$j].weight
            }
        }
        $graph[$next].isDead = $true
    }
    for([int] $i = 0; $i -lt $nodecount; $i++) {
        "The distance between nodes {0} and {1} is {2}" -f
            $source, $i, $graph[$i].distance
    }
}
$graph = @()
###
### Here’s where we define the different vertexi
### each vertex is a collection of edges
### an edge has a weight and a destination
$graph += vertex (edge -w 0 -d "0,0"),(edge -w 1 -d "0,1"),(edge -w 6 -d "0,2")
$graph += vertex (edge -w 1 -d "1,0"),(edge -w 1 -d "0,1"),(edge -w 6 -d "0,2")
$graph += vertex (edge -w 0 -d "0,0"),(edge -w 1 -d "0,1"),(edge -w 6 -d "0,2")



Dijkstra $graph 2

### END SCRIPT


116
138
213







<#






$edges = @()

for ($x = 0; $x -lt $10; $x++) {
    for ($y = 0; $y -lt $10; $y++) {
        if ($x -gt 0) {$edges += (@{From="$x,$y";To="$($x-1),$y"}) }
        #if ($x -lt 10) {$edges += New-Edge -From "$x,$y" -To "$($x+1),$y"}
        #if ($y -gt 0) {$edges += New-Edge -From "$x,$y" -To "$($x-1),$y"}
        #if ($y -lt 10) {$edges += New-Edge -From "$x,$y" -To "$($x+1),$y"}
    }
}












$pth = ".\2021\day 15\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$list = @{}

$nodes = @{}


$x = 0
$y = 0
while (($read = $reader.Readline()) -ne $null) { 
    for ($x = 0; $x -lt $read.Length; $x++) {
        $list["$x,$y"] = [PSCustomObject]@{
            Value = [int]::MaxValue-1
            Visited = $false
        }
        $nodes["$x,$y"] = [int]::Parse([char]$read[$x])
    }
    $y++
}


$reader.Close()
$reader.Dispose()

Function Get-Neighbors {
    Param(
        [Parameter(Position=1)][string]$Pos
    )

    $x = [int]$Pos.Split(',')[0]
    $y = [int]$Pos.Split(',')[1]

    $neighbors = @()

    if ($x -gt 0) {$neighbors += "$($x-1),$y"}
    if ($x -lt $xmax) {$neighbors += "$($x+1),$y"}
    if ($y -gt 0) {$neighbors += "$x,$($y-1)"}
    if ($y -lt $ymax) {$neighbors += "$x,$($y+1)"}

    Return $neighbors
}



$list["0,0"].Value = 0
$list["0,0"].Visited = $true

$unvisited = ($list.GetEnumerator() | Where-Object {($_.Value.Visited -eq $false)}).Count


$current = "0,0"
$risk = 0
While ($unvisited -gt 0) {
    foreach ($neighbor in (Get-Neighbors $current) {
        if ( -not  $list[$neighbor].Visited ) {
            $risk = ($list[$current].Value + ($list[$current].Value)
        }
    }
}














$ymax = $y-1
$xmax = $y-1

$visited = @()



$current = "0,0"

#$queue = Get-Neighbors $current
$queue = @("0,0")

$risk = 0
while ($queue.Count -gt 0) {
    
    $current = $queue[0]
    $visited += $current
    
    $weights = @{}
    foreach ($neighbor in (Get-Neighbors $current | Where-Object {($_.Name -notin $visited)})) {
        $Weights[$neighbor]=($risk + $list[$neighbor])
    }

    $least = ($weights.GetEnumerator() | Sort-Object Value | Select -First 1).Value
    $leastcount = ($weights.GetEnumerator() | Where-Object {($_.Value -eq $least)}).Count
    if ($leastcount -gt 1) {
        $queue += $current = ($Weights.GetEnumerator() | Where-Object {($_.Value -eq $least)})[0]
        
    }

}

#>
