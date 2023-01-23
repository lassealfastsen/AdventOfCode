$directions = (Get-Content ('.\2016\Day 1\input.txt')).Split(', ')



$currentPos = @{
    x = 0
    y = 0
    r = 0
}


$visited = @()
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
    for ($i = 0; $i -lt $steps; $i++) {
        $visited += "$($currentPos.x),$($currentPos.y)"
        switch ($currentPos.r) {
            0 { $currentPos.y += 1 } 
            90 { $currentPos.x += 1 }
            180 { $currentPos.y -= 1 } 
            270 { $currentPos.x -= 1 }
        }
        if ($visited -contains "$($currentPos.x),$($currentPos.y)") {
            Write-Host "Bunny: $($currentPos.x),$($currentPos.y)"
        }
    }
   
    

    #"$dir : $($currentPos.x),$($currentPos.y) $([Math]::Abs($currentPos.x) + [Math]::Abs($currentPos.y))"
}

[Math]::Abs($currentPos.x) + [Math]::Abs($currentPos.y)