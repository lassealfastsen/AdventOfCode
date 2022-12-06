$pth = '.\2022\Day 6\input.txt'

$in = Get-Content $pth

$found = $false
$pos = 13

while(!$found) {
    if (([char[]]$in.Substring($pos-13, 14) | Select -Unique).Count -eq 14) {
        $found=$true
    } else {
        $pos++
    }
}

$pos+1
