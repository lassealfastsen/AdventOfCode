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

$targetY = 2000000

$gridWidth = $xmax - $xmin
$gridHeight = $ymax - $ymin

$xOffset = [Math]::Abs($xmin) #Get Absolute value of xmin for the line array
$line = [Array]::CreateInstance([int64], $gridWidth + $xOffset)


$idx = 1
$sensorCount = $sensors.Count


foreach ($Sensor in $sensors) {
    Write-Progress -Activity "Mapping" -Status "Filling $idx" -PercentComplete ([Math]::Round(($idx / $SensorCount) * 100))
    #do we ned to process this sensor?
    $absDiff = [math]::Abs($Sensor.sy - $targetY)
    $dist = $Sensor.ManDist - $absDiff
    if ($dist -gt 0) { #We need to fill a line
        foreach ($x in ($Sensor.sx - $dist)..($Sensor.sx + $dist)) {
            $line[$x + $xOffset] = 3 # 3 = Covered Area
        }
    } elseif ($dist -eq $y) { #we are just touching the line with the bottom point of the coverage area!
        $line[$Sensor.sx + $xOffset] = 3 # 3 = Covered Area
    }


    # fill in the beacons and signals to the line
    if ($Sensor.sy -eq $targetY) {
        $line[$Sensor.sx + $xOffset] = 1 # 1 = Sensor
    }
    if ($Sensor.by -eq $targetY) {
        $line[$Sensor.bx + $xOffset] = 2 # 2 = Beacon
    }
    $idx++
}

foreach ($Sensor in $sensors) {

}

$line | Where-Object { $_ -eq 3 } | Measure-Object


#5543957 too high (husk lige at sætte TargetY til det rigtige :P)
#4502208
