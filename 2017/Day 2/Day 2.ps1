$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2017\Day 2\input.txt')

$checksum = 0
$checksumEvenlyDivisible = 0
while ($null -ne ($read = $reader.ReadLine())) {
    $nums = [int[]]([Regex]::Matches($read, '[0-9]+').Value)

    $nums = $nums | Sort-Object -Descending

    $diff = ($nums[0] - $nums[-1])

    $checksum += $diff

    #Find Evenly divisible
    
    for ($i = 0; $i -lt $nums.Count; $i++) {
        for ($j = $i+1; $j -lt $nums.Count; $j++) {
            if (($nums[$i] / $nums[$j]) % 2 -in [int[]]@(0,1)) {
                $checksumEvenlyDivisible += ($nums[$i] / $nums[$j])
                $j = [int]::MaxValue
                $i = [int]::MaxValue
            }
        }
    }

}

$reader.Close()
$reader.Dispose()

Write-Host "Checksum: " -NoNewline
Write-Host $checksum -ForegroundColor Green

Write-Host "Checksum [evenly Divisible]: " -NoNewline
Write-Host $checksumEvenlyDivisible -ForegroundColor Green
