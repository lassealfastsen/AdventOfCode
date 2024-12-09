$diskContentMap = Get-Content 'C:\git\AdventOfCode\2024\Day 9\input.txt' -Raw

$diskContent = @()

$id = 0
$diskIndex = 0

$blocks = @()
$availableSpaces = @()
for ($i = 0; $i -le $diskContentMap.Length - 1; $i += 2) {
    Write-Progress -PercentComplete (($i / $diskContentMap.Length) * 100) -Activity "Loading Disk Content"
    
    
    $length = [int]::Parse($diskContentMap[$i])

    $blocks += [PSCustomObject]@{
        id     = $id
        index  = $diskIndex
        spaces = $length
    }


    if (($i + 1) -lt $diskContentMap.Length) {
        $freeSpace = [int]::Parse($diskContentMap[$i + 1])
    }
    else { $freeSpace = 0 }
    
    
    for ($j = 0; $j -lt $length; $j++) {
        $diskContent += $id
        $diskIndex++
    }

    $availableSpaces += [PSCustomObject]@{
        index  = $diskIndex
        spaces = $freeSpace
    }

    for ($j = 0; $j -lt $freeSpace; $j++) {
        $diskContent += $null
        $diskIndex++
    }

    $id++
}
Write-Progress -Completed -Activity "Loading Disk Content"

# for ($i = 0; $i -lt $diskContent.Count; $i++) {
#     if ($null -eq $diskContent[$i]) {
#         Write-Host '.' -NoNewline
#     }
#     else {
#         Write-Host $diskContent[$i] -NoNewline
#     }
# }
# Write-Host


$p2DiskContent = $diskContent.Clone()

while ($diskContent -contains $null) {
    $idx = $diskContent.IndexOf($null)
    $val = $diskContent[-1]
    if ($val -ne $null) {
        Write-Host "$val->$idx"
        $diskContent[$idx] = $val
    }
    $diskContent = $diskContent[0..($diskContent.Length - 2)]
}


$p1value = 0
for ($i = 0; $i -lt $diskContent.Count; $i++) {
    Write-Host "$i/$($diskContent.Count)"
    $p1value += ($i * $diskContent[$i])
}

Write-Host "Part 1 $p1value"


foreach ($block in ($blocks | Sort-Object id -Descending)) {
    # for ($i = 0; $i -lt $p2diskContent.Count; $i++) {
    #     if ($null -eq $p2diskContent[$i]) {
    #         Write-Host '.' -NoNewline
    #     }
    #     else {
    #         Write-Host $p2diskContent[$i] -NoNewline
    #     }
    # }
    # Write-Host
    $firstAvailableSpace = $availableSpaces | Where-Object { (($_.spaces -ge $block.spaces) -and ($_.index -lt $block.index)) } | Select-Object -First 1

    if ($null -ne $firstAvailableSpace) {
        Write-Host "$($block.id): $($block.index)->$($firstAvailableSpace.index)"
        for ($i = $firstAvailableSpace.index; $i -lt ($firstAvailableSpace.index + $block.spaces); $i++) {
            $p2DiskContent[$i] = $block.id
        }
        for ($i = $block.index; $i -lt ($block.index + $block.spaces); $i++) {
            $p2DiskContent[$i] = $null
        }
        $firstAvailableSpace.index += $block.spaces
        $firstAvailableSpace.spaces -= $block.spaces

    }
    else {
        Write-Host "$($block.id) Cannot move" -ForegroundColor Red
    }
}

$p2value = 0
for ($i = 0; $i -lt $p2diskContent.Count; $i++) {
    Write-Host "$i/$($p2diskContent.Count)"
    $p2value += ($i * $p2diskContent[$i])
}

Write-Host "Part 2 $p2value"

