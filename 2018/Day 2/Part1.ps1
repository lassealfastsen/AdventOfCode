
#$reader = New-Object System.IO.StreamReader("C:\Temp\GIT\AdventOfCode\2018\Day 2\sample.txt")
$reader = New-Object System.IO.StreamReader("C:\Temp\GIT\AdventOfCode\2018\Day 2\part1.txt")

$has2 = 0
$has3 = 0

while ( ($read = $reader.ReadLine()) -ne $null) {
    $chars = $read.ToCharArray()
    $two = $false
    $three = $false
    foreach ($char in ($chars | Select-Object -Unique)) {

        $cnt = ($chars | Where-Object { ($_ -eq $char) }).Count
        if ($cnt -eq 2 -and -not $two) { $has2++; $two = $true }
        if ($cnt -eq 3 -and -not $three) { $has3++; $three = $true }
    }
}


$reader.Close()
$reader.Dispose()


Write-Host "$has2 * $has3 = $($has2 * $has3)"