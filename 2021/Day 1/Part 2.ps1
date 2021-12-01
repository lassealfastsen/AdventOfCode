[int[]]$lines = Get-Content '.\2021\Day 1\Input.txt'

#[int[]]$sums = @()


$increases = 0


for ($i = 3; $i -lt $lines.Count; $i++) {
    $suma = $lines[$i-1]+$lines[$i-2]+$lines[$i-3]
    $sumb = $lines[$i]+$lines[$i-1]+$lines[$i-2]
    if ($sumb -gt $suma) {$increases++}
}


# for ($i = 1; $i -le $sums.Count; $i++) {
#     if ($sums[$i] -gt $sums[$i-1]) {
#         $increases++
#     }
# }


$increases