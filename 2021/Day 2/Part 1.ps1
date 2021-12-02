#$directions = Get-Content '.\2021\Day 2\input.txt'

$directions = ".\2021\day 2\input.txt"


$reader = New-Object System.IO.StreamReader($directions)

[int]$x = 0
[int]$z = 0

while ( $read = $reader.ReadLine()) {

    $dir = $read.Split(' ')
    switch ($dir[0]) {
        'down' { $z+=[int]$dir[1] }
        'up' { $z-=[int]$dir[1] }
        'forward' { $x+=[int]$dir[1] }
        Default {}
    }
}

$reader.Close()
$reader.Dispose()


#Write-Host ($x * $z)