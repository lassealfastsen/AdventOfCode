[int[]]$lines = Get-Content '.\2021\Day 1\Input.txt'

[int[]]$sums = @()



for ($i = 2; $i -lt $lines.Count; $i++) {
    $sums += $lines[$i]+$lines[$i-1]+$lines[$i-2]
}

$increases = 0

for ($i = 1; $i -le $sums.Count; $i++) {
    if ($sums[$i] -gt $sums[$i-1]) {
        $increases++
    }
}


$increases