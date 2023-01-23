$keys = @{
    "1.1" = $null
    "2.1" = $null
    "3.1" = 'D'
    "4.1" = $null
    "5.1" = $null
    "1.2" = $null
    "2.2" = 'A'
    "3.2" = 'B'
    "4.2" = 'C'
    "5.2" = $null
    "1.3" = 5
    "2.3" = 6
    "3.3" = 7
    "4.3" = 6
    "5.3" = 9
    "1.4" = $null
    "2.4" = 2
    "3.4" = 3
    "4.4" = 4
    "5.4" = $null
    "1.5" = $null
    "2.5" = $null
    "3.5" = 1
    "4.5" = $null
    "5.5" = $null
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
            'U' { if ($null -ne $keys["$($key.x).$($key.y+1)"]) { $key.y++ } }
            'D' { if ($null -ne $keys["$($key.x).$($key.y-1)"]) { $key.y-- } }
            'L' { if ($null -ne $keys["$($key.x-1).$($key.y)"]) { $key.x-- } }
            'R' { if ($null -ne $keys["$($key.x+1).$($key.y)"]) { $key.x++ } }
        }
    }
    Write-Host $keys["$($key.x).$($key.y)"] -NoNewline
}

$reader.Close()
$reader.Dispose()
Write-Host