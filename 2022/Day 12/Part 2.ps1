$pth = 'C:\Users\lal\OneDrive - Lyngsoe Systems\Scripts\AdventOfCode\2022\Day 12\input.txt'

$in = Get-Content -Path $pth
$xmax = $in[0].Length - 1
$ymax = $in.count - 1

$difNbrs = '[[-1,0],[0,-1],[0,1],[1,0]]' | ConvertFrom-Json

$map = [Collections.Generic.Dictionary[string, hashtable]]::new()

for ($y = 0; $y -le $ymax; $y++) {
    for ($x = 0; $x -le $xmax; $x++) {
        
        $key = "$x,$y"
        $height = $in[$y][$x]

        if ($height -ceq 'E') {
            $height = [char]'z'
            $startpos = $key
        } elseif ($height -ceq 'S') {
            $height = [char]'z'
            $endpos = $key
        }

        $nbrs = foreach ($dif in $difNbrs) {
            
            $nx = $x + $dif[0]
            $ny = $y + $dif[1]

            if ($nx -lt 0 -or $nx -gt $xmax -or $ny -lt 0 -or $ny -gt $ymax) {
                #Out of the grid, skip
                continue
            }

            $nh = $in[$ny][$nx]
            if ($nh -ceq 'S') { $nh = [char]'a' }
            elseif ($nh -ceq 'E') { $nh = [char]'z' }
            $diff = $height - $nh
            if ($diff -le 1) {
                "$nx,$ny"
            }
        }


        $map[$key] = @{
            key    = $key
            height = $height
            nbrs   = $nbrs
            dist   = [int]::MaxValue
        }
    }
}


$pq = [Collections.Generic.PriorityQueue[PSObject, int]]::new()
$start = $map[$startpos]
$start.dist = 0
$pq.Enqueue($start, $start.dist)


$seen = @{}

while ($pq.Count -gt 0) {

    $u = $pq.Dequeue()



    if ($u.height -eq 'a') {

        $u.dist
        break
    }


    if ($seen.ContainsKey($u.key)) {

        continue
    }
    $seen[$u.key] = 1


    foreach ($vKey in $u.nbrs) {
        $v = $map[$vKey]
        $newDist = $u.dist + 1
        if ($newDist -lt $v.dist) {
            $v.dist = $newDist
            $pq.Enqueue($v, $v.dist)
        }
    }
}