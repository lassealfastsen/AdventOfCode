#Part 1
$pth = ".\2023\Day 6\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$times = [regex]::Matches($reader.ReadLine(), "(\d)+").Value
$distances = [regex]::Matches($reader.ReadLine(), "(\d)+").Value
$wins = @()


$reader.Close()
$reader.Dispose()



for ($i = 0; $i -lt $times.Count; $i++) {
    $win = 0
    for ($j = 1; $j -lt $times[$i]; $j++) {
        
        $speed = $j
        $dist = ($speed * ($times[$i] - $j))
        if ([int]$distances[$i] -lt [int]$dist) { $win++ }
    }

    $wins += $win
}

$wins -join '*' | Invoke-Expression



#Part 2

$pth = ".\2023\Day 6\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$time = [long]([regex]::Matches($reader.ReadLine(), "(\d)+").Value -join '')
$distance = [long]([regex]::Matches($reader.ReadLine(), "(\d)+").Value -join '')
$wins = 0


$reader.Close()
$reader.Dispose()




for ($j = 1; $j -lt $time; $j++) {
        
    $speed = $j
    $dist = ($speed * ($time - $j))
    if ([long]$distance -lt [long]$dist) { $wins++ }
    #if ($j % 10000 -eq 0) { $j }
}

$wins

