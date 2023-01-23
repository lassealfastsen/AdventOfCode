$directions = (Get-Content ('.\2016\Day 1\input.txt')).Split(', ')

$currentPos = @{
    x = 0
    y = 0
    r = 0
}

foreach ($dir in $directions) {
    $rotate = $dir[0]
    switch ($rotate) {
        'R' { $currentPos.r += 90 }
        'L' { $currentPos.r -= 90 }
    }

    if ($currentPos.r -gt 270) { $currentPos.r = 0 }
    if ($currentPos.r -lt 0) { $currentPos.r = 270 }

    $steps = [int]$dir.Substring(1, $dir.Length - 1)
    #$Steps
    switch ($currentPos.r) {
        0 { $currentPos.y += $steps } 
        90 { $currentPos.x += $steps }
        #-90 { $currentPos.x -= $steps }
        180 { $currentPos.y -= $steps } 
        #-180 { $currentPos.y += $steps } 
        270 { $currentPos.x -= $steps }
        #-270 { $currentPos.x += $steps }
    }
    #"$dir : $($currentPos.x),$($currentPos.y) $([Math]::Abs($currentPos.x) + [Math]::Abs($currentPos.y))"
}

[Math]::Abs($currentPos.x) + [Math]::Abs($currentPos.y)