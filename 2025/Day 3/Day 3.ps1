$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 3\input.txt')

$joltSum1 = 0
$joltSum2 = [bigint]0

$c = 0
#P1
while ($null -ne ($read = $reader.ReadLine())) {
    $c++
    $c
    for ($i = 99; $i -gt 11; $i--) {
        if ([regex]::Match($read, "(($($i.ToString()[0])).*($($i.ToString()[1])))").Success) {
            $joltSum1 += $i
            #$i
            break
        }
    }


    for ($i = 999999999999; $i -gt 111111111111; $i--) {
        #if ([regex]::Match($read, "(($($i.ToString()[0])).*($($i.ToString()[1])).*($($i.ToString()[2])).*($($i.ToString()[3])).*($($i.ToString()[4])).*($($i.ToString()[5])).*($($i.ToString()[6])).*($($i.ToString()[7])).*($($i.ToString()[8])).*($($i.ToString()[9])).*($($i.ToString()[10])).*($($i.ToString()[11])))").Success) {
        $regex = "((" + ($i.ToString().ToCharArray() -join ').*(') + "))"
        if ([regex]::Match($read, $regex).Success) {
            $joltSum2 += $i
            #$i
            break
        }
    }

}

$joltSum1
$joltSum2

$reader.Close()
$reader.Dispose()



# while ($null -ne ($read = $reader.ReadLine())) {

#     $biggestJolts = $read.ToCharArray() | Sort-Object -Descending | Select-Object -First 2


#     $placements = [regex]::matches($read, "([$($biggestJolts -join '')])")

#     #Try Biggest Value first
#     $firstBiggest = $placements | Where-Object { ($_.Value -eq $biggestJolts[0]) } | Sort-Object Index | Select-Object -First 1
#     $firstSmallest = $placements | Where-Object { ($_.Value -eq $biggestJolts[1]) } | Sort-Object Index | Select-Object -First 1
#     $lastBiggest = $placements | Where-Object { ($_.Value -eq $biggestJolts[0]) } | Sort-Object Index | Select-Object -First 1
#     $lastSmallest = $placements | Where-Object { ($_.Value -eq $biggestJolts[1]) } | Sort-Object Index | Select-Object -First 1


#     #Try for big-big
#     if (($placements | Where-Object { ($_.Value -eq $biggestJolts[0]) }).Count -ge 2) {
#         $joltSum += [int]::Parse("$($biggestJolts[0])$($biggestJolts[0])")
#         [int]::Parse("$($biggestJolts[0])$($biggestJolts[0])")
#     }
#     elseif ($lastSmallest.Index -gt $firstBiggest.Index) {
#         $joltSum += [int]::Parse("$($biggestJolts[0])$($biggestJolts[1])")
#         [int]::Parse("$($biggestJolts[0])$($biggestJolts[1])")
#     }
#     elseif ($lastBiggest.Index -gt $firstSmallest.Index) {
#         $joltSum += [int]::Parse("$($biggestJolts[1])$($biggestJolts[0])")
#         [int]::Parse("$($biggestJolts[1])$($biggestJolts[0])")
#     }
#     elseif (($placements | Where-Object { ($_.Value -eq $biggestJolts[1]) }).Count -ge 2) {
#         $joltSum += [int]::Parse("$($biggestJolts[1])$($biggestJolts[1])")
#         [int]::Parse("$($biggestJolts[1])$($biggestJolts[1])")
#     }
#     else {
#         Write-Host "NOOOOOOO - $read"
#     }

# }


[regex]::Match("987654321111111", "((8).*(9))")

