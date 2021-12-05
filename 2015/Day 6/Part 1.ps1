$pth = ".\2015\Day 6\input.txt"
$reader = New-Object System.IO.StreamReader($pth)


$grid = New-Object 'bool[,]' 1000, 1000


While ($read = $reader.ReadLine()) {
    $instruction = ($read | Select-String -Pattern "turn on|turn off|toggle").Matches[0].Value
    $positions = ($read | Select-String -Pattern "(\d)+,(\d)+" -AllMatches).Matches
    $start = [int[]]$positions[0].Value.Split(',')
    $end = [int[]]$positions[1].Value.Split(',')

    switch ($instruction) {
        'turn on' { 
            for ($x = $start[0]; $x -le $end[0]; $x++) {
                for ($y = $start[1]; $y -le $end[1]; $y++) {
                    $grid[$x,$y] = $true
                }
            }
        }
        'turn off' {
            for ($x = $start[0]; $x -le $end[0]; $x++) {
                for ($y = $start[1]; $y -le $end[1]; $y++) {
                    $grid[$x,$y] = $false
                }
            }
        }
        'toggle' {
            for ($x = $start[0]; $x -le $end[0]; $x++) {
                for ($y = $start[1]; $y -le $end[1]; $y++) {
                    $grid[$x,$y] = -not $grid[$x,$y]
                }
            }
        }
    }
}

$reader.Close()
$reader.Dispose()

$cnt = 0
for ($x = 0; $x -lt 1000; $x++) {
    for ($y = 0; $y -lt 1000; $y++) {
        if ($grid[$x,$y]) {$cnt++}
    }
}

$cnt