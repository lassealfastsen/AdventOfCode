$pth = 'C:\Users\lal\OneDrive - Lyngsoe Systems\Documents\github\AdventOfCode\AdventOfCode\2021\Day 13\input.txt'

$reader = New-Object System.IO.StreamReader($pth)


$dots = @()

$dots = New-Object 'Collections.Generic.List[psobject]'
$instructions = @()
$dotsfound = $false


Function Fold-Horizontal ([int]$position) {
    $move = $dots | Where-Object {$_.y -gt $position}
    $dots = $dots | Where-Object {$_.y -lt $position}

    foreach ($dot in $move) {
        $dot.y = $position-($dot.y-$position)
        $dot.str = "$($dot.x),$($dot.y)"
        $dotstr = "$($dot.x),$($dot.y)"
        if ($dotstr -notin $dots.str) {
            $dots += $dot
        }
    }
}

Function Fold-Vertical ([int]$position) {
    $move = $dots | Where-Object {$_.x -gt $position}
    $dots = $dots | Where-Object {$_.x -lt $position}

    foreach ($dot in $move) {
        $dot.x = $position-($dot.x-$position)
        $dot.str = "$($dot.x),$($dot.y)"
        $dotstr = "$($dot.x),$($dot.y)"
        if ($dotstr -notin $dots.str) {
            $dots += $dot
        }
    }
}





while ( ($read = $reader.ReadLine()) -ne $null) {
    if ($read -like '') {
        $dotsfound = $true
    } elseif ($dotsfound) {
        $instructions += $read
    } else {
        $dots.Add([PSCustomObject]@{
            x = [int]$read.Split(',')[0]
            y = [int]$read.Split(',')[1]
            str = $read
        })
    }
}

$reader.Close()
$reader.Dispose()


foreach ($instruction in $instructions) {
    $instruction = $instruction.Replace('fold along ','')
    switch ($instruction.Split('=')[0]) {
        'y' { Fold-Horizontal -position $instruction.Split('=')[1]}
        'x' { Fold-Vertical -position $instruction.Split('=')[1]}
    }
}




$xmax = $dots.x | sort | select -last 1
$ymax = $dots.y | sort | select -last 1



for ($y = 0; $y -le $ymax; $y++) {
    for ($x = 0; $x -le $xmax; $x++) {
        if ("$x,$y" -in $dots.str) {
            Write-Host '#' -NoNewline
        } else {
            Write-Host '.' -NoNewline
        }
    }
    Write-Host    
}
