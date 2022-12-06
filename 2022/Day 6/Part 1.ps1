$in = Get-Content '.\2022\Day 6\input.txt'

$found = $false
$pos = 3

while(!$found) {
    if (([char[]]$in.Substring($pos-3, 4) | Select-Object -Unique).Count -eq 4) {
        $found=$true
    }
    $pos++
}

$pos