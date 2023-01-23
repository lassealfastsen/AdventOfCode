$keys = @{
    "1.1" = 7
    "2.1" = 8
    "3.1" = 9
    "1.2" = 4
    "2.2" = 5
    "3.2" = 6
    "1.3" = 1
    "2.3" = 2
    "3.3" = 3
}

$key = @{
    x = 2
    y = 2
}



$pth = ".\2016\Day 2\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

while ($null -ne ($read = $reader.ReadLine())) {
    foreach ($char in $read.ToCharArray()) {
        switch ($char) {
            'U' { if ($key.y -lt 3) { $key.y++ } }
            'D' { if ($key.y -gt 1) { $key.y-- } }
            'L' { if ($key.x -gt 1) { $key.x-- } }
            'R' { if ($key.x -lt 3) { $key.x++ } }
        }
    }
    Write-Host $keys["$($key.x).$($key.y)"] -NoNewline
}

$reader.Close()
$reader.Dispose()
Write-Host