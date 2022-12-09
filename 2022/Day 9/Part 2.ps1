#$tail = }

$knots = @(
    @{ x = 0; y = 0 } #0 - Head
    @{ x = 0; y = 0 } #1
    @{ x = 0; y = 0 } #2
    @{ x = 0; y = 0 } #3
    @{ x = 0; y = 0 } #4
    @{ x = 0; y = 0 } #5
    @{ x = 0; y = 0 } #6
    @{ x = 0; y = 0 } #7
    @{ x = 0; y = 0 } #8
    @{ x = 0; y = 0 } #9
)

$lastKnot = $knots.Count - 1

$tailPositions = @{}

$pth = '.\2022\Day 9\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

while ($null -ne ($read = $reader.ReadLine())) {
    
    $amount = $read.Split(' ')[1]
    for ($j = 0; $j -lt $amount; $j++) {

        #Move Head
        switch ($read[0]) {
            'R' { $knots[0].x++ }
            'L' { $knots[0].x-- }
            'U' { $knots[0].y++ }
            'D' { $knots[0].y-- }
            Default { "Error in Input" }
        }

        
        
        #Process each subsequent knot.
        for ($i = 1; $i -lt $knots.Count; $i++) {
            

            #Get dif pos from previous knot
            $difX = $knots[$i - 1].x - $knots[$i].x
            $difY = $knots[$i - 1].y - $knots[$i].y

            switch ($difX) {
                2 { 
                    $knots[$i].x += 1
                    if ($difY -in -1..1) { $knots[$i].y += $difY }
                }
                -2 { 
                    $knots[$i].x -= 1
                    if ($difY -in -1..1) { $knots[$i].y += $difY }
                }
            }

            switch ($difY) {
                2 { 
                    $knots[$i].y += 1
                    if ($difX -in -1..1) { $knots[$i].x += $difX }
                }
                -2 { 
                    $knots[$i].y -= 1
                    if ($difX -in -1..1) { $knots[$i].x += $difX }
                }
            }

            #Save Position of the last knot if not already there
            $tailPositions["$($knots[$lastKnot].x),$($knots[$lastKnot].y)"] = 1
        }
    }
}

$tailPositions.Keys.Count

$reader.Close()
$reader.Dispose()