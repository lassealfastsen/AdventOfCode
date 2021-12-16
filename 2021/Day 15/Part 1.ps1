


$nodes = @{}
#
$pth = ".\2021\day 15\input.txt"


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

$ymax = $y-1
$xmax = $x-1


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
    #$cnt
    $node = $nodes[$list.First.Value]
    #if ($node.node -eq "$($xmax-1),$($ymax-1)") { break }
    $nodes[$node.Node].Visited = $true
    $null = $list.RemoveFirst()

    $neighbours = Get-Neighbors $node.node



    #$neighbours = $neighbours.where{($_.Destination -notin $distances.Keys)}
    $next = $null

    

    foreach ($neighbour in $neighbours | Sort-Object Weight, Destination) {
        #if ($nodes["$xmax,$ymax"].Distance -lt [int]::MaxValue-1) {$nodes["$xmax,$ymax"]}
        # if ($node.node -eq "$xmax,$ymax") { 
        #     $nodes["$xmax,$ymax"].Distance
        # }
        if (($node.Distance + $neighbour.Weight -lt $nodes[$neighbour.Destination].Distance) -and ($nodes[$neighbour.Destination].Visited -eq $false)) {
            $nodes[$neighbour.Destination].Distance = $node.Distance + $neighbour.Weight
            $null = $list.AddLast($neighbour.Destination)
        }      
    }


     $arr = @()
     $list  | ForEach-Object {
         $arr += $nodes[$_]
     }
     $list = New-Object System.Collections.Generic.LinkedList[String]
     $arr | Sort-Object Distance | ForEach-Object {
         $null = $list.AddLast($_.Node)
         #$_.Node
     }
     #$arr.Count
    #$list = $list.GetEnumerator() | Sort-Object

}

$nodes["$xmax,$ymax"].Distance
#The answer is too high for some reason exactly the value of the Leas Weight Neibour of the destination don't know if this will work for part 2 :S
#($nodes["$xmax,$ymax"].Distance - ((Get-Neighbors "$xmax,$ymax").Weight | Sort | Select -First 1))
