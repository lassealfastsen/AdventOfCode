$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2024\Day 4\input.txt')

$grid = @{}

$y = 0


while ($null -ne ($read = $reader.ReadLine())) {
    $xmax = $read.Length - 1
    for ($x = 0; $x -lt $read.Length; $x++) {
        $grid["$x,$y"] = $read[$x]
    }
    $y++;
}

$reader.Close()
$reader.Dispose()


$ymax = $y - 1

#Part 1

$count = 0
for ($x = 0; $x -le $xmax; $x++) {
    for ($y = 0; $y -le $ymax; $y++) {
        if ($grid["$x,$y"] -eq 'X') {            
            #Right
            if (($grid["$($x+1),$y"] -eq "M") -and ($grid["$($x+2),$y"] -eq "A") -and ($grid["$($x+3),$y"] -eq "S")) { $count++ } #XMAS

            #Left
            if (($grid["$($x-1),$y"] -eq "M") -and ($grid["$($x-2),$y"] -eq "A") -and ($grid["$($x-3),$y"] -eq "S")) { $count++ } #SAMX

            #Down
            if (($grid["$x,$($y+1)"] -eq "M") -and ($grid["$x,$($y+2)"] -eq "A") -and ($grid["$x,$($y+3)"] -eq "S")) { $count++ } #XMAS

            #Up
            if (($grid["$x,$($y-1)"] -eq "M") -and ($grid["$x,$($y-2)"] -eq "A") -and ($grid["$x,$($y-3)"] -eq "S")) { $count++ } #SAMX

            #DownRight
            if (($grid["$($x+1),$($y+1)"] -eq "M") -and ($grid["$($x+2),$($y+2)"] -eq "A") -and ($grid["$($x+3),$($y+3)"] -eq "S")) { $count++ } #XMAS
            #UpLeft
            if (($grid["$($x-1),$($y-1)"] -eq "M") -and ($grid["$($x-2),$($y-2)"] -eq "A") -and ($grid["$($x-3),$($y-3)"] -eq "S")) { $count++ } #SAMX

            #DownLeft
            if (($grid["$($x-1),$($y+1)"] -eq "M") -and ($grid["$($x-2),$($y+2)"] -eq "A") -and ($grid["$($x-3),$($y+3)"] -eq "S")) { $count++ } #XMAS
            #UpRight
            if (($grid["$($x+1),$($y-1)"] -eq "M") -and ($grid["$($x+2),$($y-2)"] -eq "A") -and ($grid["$($x+3),$($y-3)"] -eq "S")) { $count++ } #SAMX
        }
    }
}


$count

$p2count = 0
for ($x = 0; $x -le $xmax; $x++) {
    for ($y = 0; $y -le $ymax; $y++) {
        if ($grid["$x,$y"] -eq 'A') {            

            #   M		M
            #   	A
            #   S		S

            if (($grid["$($x - 1),$($y - 1)"] -eq 'M') -and ($grid["$($x + 1),$($y - 1)"] -eq 'M') -and ($grid["$($x - 1),$($y + 1)"] -eq 'S') -and ($grid["$($x + 1),$($y + 1)"] -eq 'S')) {
                $p2count++
            }


            #   S		S
            #   	A
            #   M		M

            elseif (($grid["$($x - 1),$($y - 1)"] -eq 'S') -and ($grid["$($x + 1),$($y - 1)"] -eq 'S') -and ($grid["$($x - 1),$($y + 1)"] -eq 'M') -and ($grid["$($x + 1),$($y + 1)"] -eq 'M')) {
                $p2count++
            }

            #   M		S
            #   	A
            #   M		S

            elseif (($grid["$($x - 1),$($y - 1)"] -eq 'M') -and ($grid["$($x + 1),$($y - 1)"] -eq 'S') -and ($grid["$($x - 1),$($y + 1)"] -eq 'M') -and ($grid["$($x + 1),$($y + 1)"] -eq 'S')) {
                $p2count++
            }

            #   S		M
            #   	A
            #   S		M

            elseif (($grid["$($x - 1),$($y - 1)"] -eq 'S') -and ($grid["$($x + 1),$($y - 1)"] -eq 'M') -and ($grid["$($x - 1),$($y + 1)"] -eq 'S') -and ($grid["$($x + 1),$($y + 1)"] -eq 'M')) {
                $p2count++
            }

        }
    }
}

$p2count