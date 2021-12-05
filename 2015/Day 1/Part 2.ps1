$pth = ".\2015\Day 1\input.txt"
$reader = New-Object System.IO.StreamReader($pth)

$floor = 0
$i = 1

While (($char = $reader.Read()) -gt 0){
    switch ([char]$char) {
        '(' { $floor++ }
        ')' { $floor-- }
    }
    if ($floor -eq -1) {
        Write-Host $i
        break
    }
    $i++
}


$reader.Close()
$reader.Dispose()
