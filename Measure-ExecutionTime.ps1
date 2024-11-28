$scriptfile = $args[0]
if ($args[1] -notlike '') {$runs = $args[1]} else {$runs = 100}

Write-Host "Testing Script '$scriptfile' $runs times"


$times = @()
for ($i = 1; $i -le $runs; $i++) {
    $time = (Measure-Command {& $scriptfile}).TotalMilliseconds
    $times += $time
    Write-Host "$i - $time ms"
}

$sum = 0
$times | ForEach-Object { $sum += $_}

$avg = ($sum / $runs)

$min = $times | Sort-Object | Select-Object -First 1
$max = $times | Sort-Object -Descending | Select-Object -First 1

"min: $min"
"max: $max"
"avg: $avg"