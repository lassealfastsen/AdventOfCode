#Part 1
$pth = '.\2023\Day 2\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$limits = @{
    'red'   = 12
    'green' = 13
    'blue'  = 14
}

$validgames = @()
$i = 1
while ($null -ne ($read = $reader.ReadLine())) {

    $read = $read.Split(':')[1].Trim()

    $validgame = $true
    $sets = $read.Split(';')
    foreach ($set in $sets) {
        $cubes = $set.Split(',').Trim()
        foreach ($cube in $cubes) {
            $color = $cube.Split(' ')[1]
            $amount = [int]::Parse($cube.Split(' ')[0])

            if ($limits[$color] -lt $amount) {
                $validgame = $false
            }
        }
    }

    if ($validgame) {
        $validgames += $i
        Write-Host $read -ForegroundColor Green
    }
    else {
        Write-Host $read -ForegroundColor Red
    }
    $i++

}

$reader.Close()
$reader.Dispose()

Write-Host "Part 1:"
$validgames -join ' + ' | Invoke-Expression
Write-Host "----------------"


#Part 2
$pth = '.\2023\Day 2\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$games = @()
while ($null -ne ($read = $reader.ReadLine())) {

    $read = $read.Split(':')[1].Trim()

    $mincubes = @{
        'red'   = 0
        'green' = 0
        'blue'  = 0
    }

    $sets = $read.Split(';')
    foreach ($set in $sets) {
        $cubes = $set.Split(',').Trim()
        foreach ($cube in $cubes) {
            $color = $cube.Split(' ')[1]
            $amount = [int]::Parse($cube.Split(' ')[0])

            if ($mincubes[$color] -lt $amount) {
                $mincubes[$color] = $amount
            }
        }
    }


    $pow = $mincubes.Values -join '*' | Invoke-Expression

    $games += $pow

}

$reader.Close()
$reader.Dispose()

Write-Host "Part 1:"
$games -join ' + ' | Invoke-Expression
Write-Host "----------------"
