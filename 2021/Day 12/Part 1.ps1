$pathinput = Get-Content -LiteralPath '.\2021\Day 12\input.txt'


$directions = @()

foreach ($line in $pathinput) {
    $directions += $line
}


$queue = @()
$paths = @()

foreach ($startPoint in ($directions | Where-Object {($_ -like "start*")})) {
    $queue += $startPoint
}

while ($queue.Count -gt 0) {
    
    $currentpath = $queue[0]
    if ($currentpath -like "*-end") {$paths+=$currentPath}
    else {
        $currentLocation = $currentpath.split('-')[-1]
        $next = ($directions | Where-Object {(($_ -clike "$currentLocation-*") -or ($_ -clike "*-$currentLocation"))}).Split('-') | Where-Object {($_ -cnotlike "*$currentLocation*") -and ($_ -ne ("start"))}

        foreach ($step in $next) {
            if (($step -cmatch "^[A-Z]*$") -or (($step -cmatch "^[a-z]*$") -and ($currentpath -cnotlike "*-$step"))) {
                $queue += "$currentPath-$step"
            }
        }
    }

    if ($queue.Count -eq 1) {$queue = @()} else {$queue = $queue[1..($queue.Length-1)]}
}





















$inputContent = Get-Content -LiteralPath '.\2021\Day 12\input.txt'
#$inputContent = Get-Content -LiteralPath input_example1.txt
#$inputContent = Get-Content -LiteralPath input_example2.txt
#$inputContent = Get-Content -LiteralPath input_example3.txt

$queue = [System.Collections.Generic.List[string]]::new()
$paths = [System.Collections.Generic.List[string]]::new()

foreach($startPath in $inputContent | Where-Object { $_ -like "*start*" }) { $queue.Add("start-$($startPath.Replace('start','').Replace('-',''))") }

while($queue) {

    $currentPath = $queue[0]

    if($currentPath -like "*-end") { $paths.Add($currentPath) }
    else {

        $currentLocation = $currentPath.Split("-")[-1]
        $nextSteps = ($inputContent | Where-Object { ($_ -clike "$currentLocation-*") -or ($_ -clike "*-$currentLocation") }).Split("-") | Where-Object { ($_ -cnotlike "*$currentLocation*") -and ($_ -ne "start") }

        foreach($step in $nextSteps) {

            if(($step -cmatch "^[A-Z]*$") -or (($step -cmatch "^[a-z]*$") -and ($currentPath -cnotlike "*-$step*"))) { $queue.Add("$currentPath-$step") }
        }
    }

    $queue.RemoveAt(0)
}

Write-Host "There are $($paths.Count) paths through the cave system."