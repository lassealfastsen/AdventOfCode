
$pth = '.\2022\Day 8\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$ymax = -1
$xmax = 0

$trees = @{}


while ($null -ne ($read = $reader.ReadLine())) {
    $ymax++
    $xmax = $read.Length - 1
    #if ($length -gt $xmax) { $xmax = $read.Length - 1 }
    for ($i = 0; $i -le $xmax; $i++) {
        $trees["$i-$ymax"] = [PSCustomObject]@{
            Height = [int]"$($read[$i])"
            Score  = 0
        }
    }
    
}

$reader.Close()
$reader.Dispose()




#Process Tree Visibility

for ($y = 0; $y -le $ymax; $y++) {
    for ($x = 0; $x -le $xmax; $x++) {

        $E = 0
        $W = 0
        $N = 0
        $S = 0

        $tree = $trees["$x-$y"].Height

        #Go Left (West)
        if ($x -gt 0) {
            for ($i = $x - 1; $i -ge 0; $i--) { 
                $W++
                if ($trees["$i-$y"].Height -ge $tree) {
                    Break
                }
            }
        }
        
        #Go right (East)
        if ($x -lt $xmax) {
            for ($i = $x + 1; $i -le $xmax; $i++) { 
                $E++
                if ($trees["$i-$y"].Height -ge $tree) {
                    Break
                }
            }
        }

        #Go up (North)
        if ($y -gt 0) {
            for ($i = $y - 1; $i -ge 0; $i--) { 
                $N++
                if ($trees["$x-$i"].Height -ge $tree) {
                    Break
                }
            }
        }

        #Go down (South)
        if ($y -lt $ymax) {
            for ($i = $y + 1; $i -le $ymax; $i++) { 
                $S++
                if ($trees["$x-$i"].Height -ge $tree) {
                    Break
                }

            }
        }
        #Write-Host "$x-$y"
        $trees["$x-$y"].Score = ($N * $S * $E * $W)
    }
}

$trees.Values.Score | Sort-Object -Descending | select -First 1

