#Part 1
$pth = '.\2023\Day 1\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$numbers = @()


while ($null -ne ($read = $reader.ReadLine())) {
    $nums = "$([Regex]::Matches($read, '[0-9]').Value -join '')"

    $numbers += [int]::Parse("$($nums[0])$($nums[-1])")

}

$reader.Close()
$reader.Dispose()

Write-Host "Part 1:"
$numbers -join ' + ' | Invoke-Expression
Write-Host "----------------"


#Part 2
$pth = '.\2023\Day 1\input.txt'

$numtrans = @{
    'one'   = 1
    'two'   = 2
    'three' = 3
    'four'  = 4
    'five'  = 5
    'six'   = 6
    'seven' = 7
    'eight' = 8
    'nine'  = 9
    '1'     = 1
    '2'     = 2
    '3'     = 3
    '4'     = 4
    '5'     = 5
    '6'     = 6
    '7'     = 7
    '8'     = 8
    '9'     = 9
}

$reader = New-Object System.IO.StreamReader($pth)

$numbers = @()


$res = @()

while ($null -ne ($read = $reader.ReadLine())) {

    $a = [regex]::Matches($read, '([0-9]|one|two|three|four|five|six|seven|eight|nine)').Value
    $b = [regex]::Matches($read, '([0-9]|one|two|three|four|five|six|seven|eight|nine)', 'RightToLeft').Value


    if ($a.Count -gt 1) {
        $a = $a[0]
    }
    if ($b.Count -gt 1) {
        $b = $b[0]
    }

    $numbers += "$($numtrans["$($a)"])$($numtrans["$($b)"])"

}

$reader.Close()
$reader.Dispose()

Write-Host "Part 2:"
$numbers -join ' + ' | Invoke-Expression
Write-Host "----------------"

