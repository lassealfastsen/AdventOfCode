$pth = ".\2022\Day 16\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

$valves = @{}


while ($null -ne ($read = $reader.ReadLine())) {
    $valvename = $read.Substring(6, 2)
    $flow = [int]([regex]::Matches($read, "([0-9]+)")[0].Value)
    $nbrs = ($read -split 'valves ')[1] -split ', '

    $valves[$valvename] = @{
        name             = $valvename
        flowrate         = $flow
        pressurereleased = 0
        nbrs             = $nbrs
        open             = $false
    }
}

$reader.Close()
$reader.Dispose()


#Sort Tunnels by Max flow rate

# foreach ($valve in $valves.Keys) {
#     $valves[$valve].nbrs = $valves[$valve].nbrs | Sort-Object { $valves[$_].flowrate } -Descending
# }

#Start at AA and go 30 minutes

$currentValve = "AA"

for ($i = 0; $i -lt 30; $i++) {
    $remainingminutes = 30 - $i

    #$openvalves = ($valves.Keys | Where-Object { $valves[$_].open }) -join ','
    #Should the current valve be opened?

    
    #Change this so you only open if the current valve has greater flow than next open neighbor!!
    $maxflowatvalve = ($valves[$currentValve].flowrate * ($remainingminutes - 1 ))
    $flownbr = ($valves[$currentValve].nbrs | Where-Object { $valves[$_].open -eq $false } | Select-Object -First 1)
    $maxflowatnbr = ($valves[$flownbr].flowrate * ($remainingminutes - 2)) # 1 minute to travel + 1 minute to open
    if (!$valves[$currentValve].open -and $valves[$currentValve].flowrate -gt 0 -and ($maxflowatvalve -ge $maxflowatnbr)) {
        $valves[$currentValve].open = $true
        "Open $currentValve"
        $valves[$currentValve].pressurereleased = ($valves[$currentValve].flowrate * ($remainingminutes - 1))
        continue #Spend 1 minute
    }

    #Travel to the next Valve that is closed
   
    if (($valves[$currentValve].nbrs | Where-Object { $valves[$_].open -eq $false }).count -gt 0) {
        $next = ($valves[$currentValve].nbrs | Where-Object { $valves[$_].open -eq $false })
        if ($next.count -gt 0) {
            for ($j = 0; $j -lt $next.Count; $j++) {
                if (($valves[$next[$j]].nbrs | Where-Object { $valves[$_].open -eq $false }).count -gt 0) {
                    $next = $next[$j]
                    break
                }
            }
        }

        "$currentValve->$next"
        $currentValve = $next
    }
}

$valves.Values.pressurereleased | Measure-Object -Sum
