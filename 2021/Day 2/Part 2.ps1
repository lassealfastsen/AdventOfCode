#$directions = Get-Content '.\2021\Day 2\input.txt'

$directions = ".\2021\day 2\input.txt"


$reader = New-Object System.IO.StreamReader($directions)

[int]$aim = 0
[int]$pos = 0
[int]$depth = 0

while ( $read = $reader.ReadLine()) {

    $dir = $read.Split(' ')
    switch ($dir[0]) {
        'down' { $aim+=[int]$dir[1] }
        'up' { $aim-=[int]$dir[1] }
        'forward' { 
            $pos+=[int]$dir[1] 
            $depth += ([int]$dir[1] * $aim)
        }
        Default {}
    }
}

$reader.Close()
$reader.Dispose()


#Write-Host ($pos * $depth)