# $reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 7\input.txt')

# Class Beam {
#     [int]$initX
#     [int]$initY
#     [int]$x
#     [int]$y
#     [int]$length
#     [bool]$stopped

#     Beam ([int]$x, [int]$y) {
#         $this.initX = $x
#         $this.initY = $y
#         $this.x = $x
#         $this.y = $y
#         $this.length = 0
#         $this.stopped = $false
#     }
# }

# $sx = 0
# $sy = 0

# $beams = @()
# $manifolds = @()


# $grid = @{}


# #P1
# $ymax = 0

# while ($null -ne ($read = $reader.ReadLine())) { 
#     $xmax = $read.Length
#     for ($x = 0; $x -lt $read.Length; $x++) {
#         $gridKey = "$x,$ymax"
#         $grid[$gridKey] = $read[$x]
#         if ($read[$x] -eq "S") {
#             $beams += [Beam]::new($x, $ymax)
#             $sx = $x
#             $sy = $ymax
#         }
#         elseif ($read[$x] -eq "^") {
#             $manifolds += [PSCustomObject]@{
#                 x = $x
#                 y = $ymax
#             }
#         }
#     }

#     $ymax++
# }

# $reader.Close()
# $reader.Dispose()





# #Process beams
# while ($beams.Where( { -not $_.stopped }).Count -gt 0) {
#     foreach ($beam in $beams.Where( { -not $_.stopped })) {

#         #COntinue down until stopped

#         while ( -not $beam.stopped ) {
#             $nextY = $beam.y + 1
#             if ($nextY -ge $ymax) {
#                 $beam.stopped = $true
#                 continue
#             }
            

#             $nextPosKey = "$($beam.x),$nextY"
#             $nextPosValue = $grid[$nextPosKey]
#             switch ($nextPosValue) {

#                 "^" {
#                     $beam.stopped = $true
#                     $manifoldHits++
#                     if ((($beams | Where-Object { $_.initX -eq ($beam.x - 1) -and $_.initY -eq $nextY }).Count -eq 0) -and ($grid["$($beam.x - 1),$nextY"] -ne "|")) {
#                         $beams += [Beam]::new(($beam.x - 1 ), $nextY)
#                         $grid["$($beam.x - 1),$nextY"] = "|"
#                     }
#                     if ((($beams | Where-Object { $_.initX -eq ($beam.x + 1) -and $_.initY -eq $nextY }).Count -eq 0) -and ($grid["$($beam.x + 1),$nextY"] -ne "|")) {
#                         $beams += [Beam]::new(($beam.x + 1 ), $nextY)
#                         $grid["$($beam.x + 1),$nextY"] = "|"
#                     }
#                 }
#                 default {
#                     $grid[$nextPosKey] = "|"
#                     $beam.y = $nextY
#                     $beam.length++
#                 }
#             }
#         }

#         # for ($y = 0; $y -lt $ymax; $y++) {
#         #     for ($x = 0; $x -lt $xmax; $x++) {
#         #         $key = "$x,$y"
#         #         Write-Host -NoNewline $grid[$key]
#         #     }
#         #     Write-Host ""
#         # }

#         # Write-Host "---------------------"
#         # Write-Host "---------------------"
#         # Write-Host "---------------------"

#     }
# }

# $manifoldHits = 0


# foreach ($manifold in $manifolds) {
#     if ($grid["$($manifold.x),$($manifold.y - 1)"] -eq "|") {
#         $manifoldHits++
#     }
# }

# $manifoldHits




# #Part 2


# $timelineCount = 0
# $queue = New-Object System.Collections.ArrayList
# # start at the S location
# $queue.Add([PSCustomObject]@{ x = $sx; y = $sy }) | Out-Null

# while ($queue.Count -gt 0) {
#     $p = $queue[0]; $queue.RemoveAt(0)
#     $cx = $p.x
#     $cy = $p.y

#     while ($true) {
#         $ny = $cy + 1
#         if ($ny -ge $ymax) {
#             # particle exits manifold — one finished timeline
#             $timelineCount++
#             break
#         }

#         $key = "$cx,$ny"
#         $ch = $grid[$key]

#         if ($ch -eq '^') {
#             # split into two independent timelines (left and right)
#             $lx = $cx - 1
#             $rx = $cx + 1

#             if ($lx -lt 0 -or $lx -ge $xmax) {
#                 $timelineCount++
#             }
#             else {
#                 $queue.Add([PSCustomObject]@{ x = $lx; y = $ny }) | Out-Null
#             }

#             if ($rx -lt 0 -or $rx -ge $xmax) {
#                 $timelineCount++
#             }
#             else {
#                 $queue.Add([PSCustomObject]@{ x = $rx; y = $ny }) | Out-Null
#             }

#             # current branch stops at the splitter (children continue)
#             break
#         }
#         else {
#             # continue straight down
#             $cy = $ny
#         }
#     }
# }

# $timelineCount

# solve.ps1
# PowerShell translation of the provided Python script.
# Functions: Part1, Part2, and Main.
# Reads the file `data` in the current directory.

function Part1 {
    param(
        [int] $start,
        [System.Collections.Generic.List[System.Collections.Generic.HashSet[int]]] $splitters
    )
    $splits = 0
    $beam = [System.Collections.Generic.HashSet[int]]::new()
    $null = $beam.Add($start)

    foreach ($rowSplitters in $splitters) {
        # Collect intersection snapshot: those splitters that are currently in the beam
        $intersect = @()
        foreach ($s in $rowSplitters) {
            if ($beam.Contains($s)) { $intersect += $s }
        }

        foreach ($splitter in $intersect) {
            $beam.Remove($splitter) | Out-Null
            $beam.Add($splitter - 1) | Out-Null
            $beam.Add($splitter + 1) | Out-Null
            $splits++
        }
    }

    return $splits
}

function Part2 {
    param(
        [int] $start,
        [System.Collections.Generic.List[System.Collections.Generic.HashSet[int]]] $splitters
    )
    # beam as position -> count (long)
    $beam = @{}
    $beam[$start] = 1L

    foreach ($rowSplitters in $splitters) {
        # Snapshot of current beam keys
        $keys = $beam.Keys
        $intersect = @()
        foreach ($s in $rowSplitters) {
            if ($keys -contains $s) { $intersect += $s }
        }

        foreach ($splitter in $intersect) {
            $count = [long] $beam[$splitter]
            if ($count -eq 0) { continue }

            $left = $splitter - 1
            $right = $splitter + 1

            if ($beam.ContainsKey($left)) {
                $beam[$left] = [long] $beam[$left] + $count
            }
            else {
                $beam[$left] = $count
            }

            if ($beam.ContainsKey($right)) {
                $beam[$right] = [long] $beam[$right] + $count
            }
            else {
                $beam[$right] = $count
            }

            # The splitter's beam is consumed/split
            $beam[$splitter] = 0
        }
    }

    # Sum total counts in beam
    $total = 0L
    foreach ($v in $beam.Values) { $total += [long] $v }
    return $total
}

$path = "C:\git\AdventOfCode\2025\Day 7\input.txt"

$data = Get-Content -Raw -Path $path

# Robustly split into lines handling both CRLF and LF-only
$lines = [regex]::Split($data, "\r?\n")

if ($lines.Length -eq 0) {
    Write-Error "Data file is empty."
    return 1
}

$firstRow = $lines[0]
$rows = $lines[1..($lines.Length - 1)]

# Find start index (first 'S')
$start = $firstRow.IndexOf('S')


# Build list of HashSet[int] for each row of splitters ('^' positions)
$splitters = [System.Collections.Generic.List[System.Collections.Generic.HashSet[int]]]::new()
foreach ($row in $rows) {
    $hs = [System.Collections.Generic.HashSet[int]]::new()
    for ($i = 0; $i -lt $row.Length; $i++) {
        if ($row[$i] -eq '^') { $null = $hs.Add($i) }
    }
    $splitters.Add($hs)
}

# ==== PART 1 ====
$part1Result = Part1 -start $start -splitters $splitters
Write-Output $part1Result

# ==== PART 2 ====
$part2Result = Part2 -start $start -splitters $splitters
Write-Output $part2Result

