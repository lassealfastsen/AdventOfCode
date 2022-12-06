$in = Get-Content '.\2022\Day 6\input.txt'

$found = $false
$pos = 13

while(!$found) {
    if (([char[]]$in.Substring($pos-13, 14) | Select-Object -Unique).Count -eq 14) {
        $found=$true
    }
    $pos++
}

$pos+1