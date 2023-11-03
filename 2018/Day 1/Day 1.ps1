$pth = '.\2018\Day 1\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$in = Get-Content $pth

$frequency = 0
$part1 = $null
$history = @{}
$duplicate = $false

Function Re-read {
    
}


while (!$duplicate) {
    foreach ($line in $in) {
        $history[$frequency] = 1
        #Write-Host "$frequency $read = " -NoNewline

        $frequency += $line
        if ($history[$frequency] -eq 1) {
            $duplicate = $true
            Write-Host "Part 2: $frequency"
            break
        }
    }

    if ($null -eq $part1) {
        Write-Host "Part 1: $frequency"
        $part1 = $frequency
    }

}



