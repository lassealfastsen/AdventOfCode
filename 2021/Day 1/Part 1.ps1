[int[]]$lines = Get-Content '.\2021\Day 1\Input.txt'


$increases = 0

for ($i = 1; $i -le $lines.Count; $i++) {
    if ($lines[$i] -gt $lines[$i-1]) {
        $increases++
    }
}

$increases