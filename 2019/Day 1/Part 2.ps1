Function Get-FuelConsumption {
    Param(
        [Parameter(Mandatory=$true)][int]$mass
    )

    $result = ([Math]::Truncate($mass/3)) - 2
    $mass = $result
    while ($mass -gt 0) {
        $additionalFuel = ([Math]::Truncate($mass/3)) - 2
        if ($additionalFuel -gt 0) {
            $mass = $additionalFuel
            $result += $additionalFuel
        } else {
            $mass=0
        }
    }
    

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