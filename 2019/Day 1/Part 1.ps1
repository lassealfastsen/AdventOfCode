Function Get-FuelConsumption {
    Param(
        [Parameter(Mandatory=$true)][int]$mass
    )

    $result = ([Math]::Truncate($mass/3)) - 2

    return $result
}


$pth = '.\2019\Day 1\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$totalFuel = 0

while ( ($read = $reader.ReadLine()) -ne $null)  {
    $totalFuel += Get-FuelConsumption $read
}


$totalFuel

$reader.Close()
$reader.Dispose()