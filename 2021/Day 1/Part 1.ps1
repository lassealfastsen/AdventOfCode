[int[]]$lines = Get-Content '.\2021\Day 1\Input.txt'


$increases = 0

for ($i = 1; $i -le ($lines | Measure-Object).Count; $i++) {
    if ([int]$lines[$i] -gt [int]$lines[$i-1]) {
        $increases++
    }
}

$increases