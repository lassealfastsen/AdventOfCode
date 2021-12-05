$pth = ".\2015\Day 1\input.txt"
$reader = New-Object System.IO.StreamReader($pth)

$floor = 0
While (($char = $reader.Read()) -gt 0){
    switch ([char]$char) {
        '(' { $floor++ }
        ')' { $floor-- }
    }
}

$floor


$reader.Close()
$reader.Dispose()
