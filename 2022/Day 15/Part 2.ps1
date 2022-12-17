$pth = ".\2022\Day 15\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

$sensors = @()

$xmin = [int]::MaxValue
$xmax = [int]::MinValue

$ymin = [int]::MaxValue
$ymax = [int]::MinValue

while ($null -ne ($read = $reader.ReadLine())) {
    $vals = [regex]::Matches($read, "((-)?[0-9]+)")

    $Sensor = @{
        sx      = [int64]$vals[0].Value
        sy      = [int64]$vals[1].Value
        bx      = [int64]$vals[2].Value
        by      = [int64]$vals[3].Value
        ManDist = 0
    }
    
    #Get Manhattan dist from densor to beacon
    $Sensor.ManDist = [Math]::Abs($Sensor.sx - $Sensor.bx) + [Math]::Abs($Sensor.sy - $Sensor.by)

    $sensors += $Sensor

    $xmax = [Math]::Max($Sensor.sx + $sensor.ManDist, $xmax)
    $xmin = [Math]::Min($Sensor.sx - $sensor.ManDist, $xmin)
    $ymax = [Math]::Max($Sensor.sy + $sensor.ManDist, $ymax)
    $ymin = [Math]::Min($Sensor.sy - $sensor.ManDist, $ymin)
}

$reader.Close()
$reader.Dispose()


#Part 2
$CurrentPoint = @(0, 2204480)
#$CurrentPoint = @(0, 0)
:Outer while ($true) {
    $CoveredBy = $null
    :Inner foreach ($Sensor in $Sensors) {
        if ($Sensor.ManDist -ge ([Math]::Abs($Sensor.sx - $CurrentPoint[0]) + [Math]::Abs($Sensor.sy - $CurrentPoint[1]))) {
            $CoveredBy = $Sensor
            break Inner
        }
    }
    if ($null -eq $CoveredBy) {
        break Outer
    }
    $YDist = [Math]::Abs($CoveredBy.sy - $CurrentPoint[1])
    $XDist = [Math]::Abs($CoveredBy.sx - $CurrentPoint[0])
    $SkipBy = $CoveredBy.ManDist - ($YDist + $XDist) + 1
    if ($CurrentPoint[0] + $SkipBy -gt 4000000) {
        $CurrentPoint[0] = 0
        $CurrentPoint[1]++
        Write-Host "$($CurrentPoint[1])"
    } else {
        $CurrentPoint[0] += $SkipBy
    }
    #Write-Host "$($CurrentPoint[0], $CurrentPoint[1])"
}

Write-Host "$($CurrentPoint[0]*4000000 + $CurrentPoint[1])"

#The correct point is 3446137,3204480 