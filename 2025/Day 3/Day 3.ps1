$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 3\input.txt')

$joltSum1 = 0
# $joltSum2 = [bigint]0

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


    #     for ($i = 999999999999; $i -gt 111111111111; $i--) {
    #         #if ([regex]::Match($read, "(($($i.ToString()[0])).*($($i.ToString()[1])).*($($i.ToString()[2])).*($($i.ToString()[3])).*($($i.ToString()[4])).*($($i.ToString()[5])).*($($i.ToString()[6])).*($($i.ToString()[7])).*($($i.ToString()[8])).*($($i.ToString()[9])).*($($i.ToString()[10])).*($($i.ToString()[11])))").Success) {
    #         $regex = "((" + ($i.ToString().ToCharArray() -join ').*(') + "))"
    #         if ([regex]::Match($read, $regex).Success) {
    #             $joltSum2 += $i
    #             #$i
    #             break
    #         }
    #     }

}

$joltSum1


$reader.Close()
$reader.Dispose()






#P2 Rework
$reader = New-Object System.IO.StreamReader('C:\Temp\AoC\AdventOfCode\2025\Day 3\input.txt')



$joltSum = [bigint]0
#P1
while ($null -ne ($read = $reader.ReadLine())) {

    

    :outer for ($c1 = 9; $c1 -ge 1; $c1--) {
        if ([regex]::match($read, "$c1[1-9]{11}").Success) {
            for ($c2 = 9; $c2 -ge 1; $c2--) {
                if ([regex]::match($read, "$($c1).*$($c2)[1-9]{10}").Success) {
                    for ($c3 = 9; $c3 -ge 1; $c3--) {
                        if ([regex]::match($read, "$($c1).*$($c2).*$($c3)[1-9]{9}").Success) {
                            for ($c4 = 9; $c4 -ge 1; $c4--) {
                                if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4)[1-9]{8}").Success) {
                                    for ($c5 = 9; $c5 -ge 1; $c5--) {
                                        if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5)[1-9]{7}").Success) {
                                            for ($c6 = 9; $c6 -ge 1; $c6--) {
                                                if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6)[1-9]{6}").Success) {
                                                    for ($c7 = 9; $c7 -ge 1; $c7--) {
                                                        if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7)[1-9]{5}").Success) {
                                                            for ($c8 = 9; $c8 -ge 1; $c8--) {
                                                                if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7).*$($c8)[1-9]{4}")) {
                                                                    for ($c9 = 9; $c9 -ge 1; $c9--) {
                                                                        if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7).*$($c8).*$($c9)[1-9]{3}").Success) {
                                                                            for ($c10 = 9; $c10 -ge 1; $c10--) {
                                                                                if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7).*$($c8).*$($c9).*$($c10)[1-9]{2}").Success) {
                                                                                    for ($c11 = 9; $c11 -ge 1; $c11--) {
                                                                                        if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7).*$($c8).*$($c9).*$($c10).*$($c11)[1-9]{1}").Success) {
                                                                                            for ($c12 = 9; $c12 -ge 1; $c12--) {
                                                                                                if ([regex]::match($read, "$($c1).*$($c2).*$($c3).*$($c4).*$($c5).*$($c6).*$($c7).*$($c8).*$($c9).*$($c10).*$($c11).*$($c12)").Success) {
                                                                                                    #Largest number!
                                                                                                    $joltSum += [bigint]::Parse("$c1$c2$c3$c4$c5$c6$c7$c8$c9$c10$c11$c12") ###############################################################################
                                                                                                    [bigint]::Parse("$c1$c2$c3$c4$c5$c6$c7$c8$c9$c10$c11$c12") ###########################################################################################
                                                                                                    break outer
                                                                                                } ####################################################################################################################################
                                                                                            }  
                                                                                        } ####################################################################################################################################
                                                                                    }  
                                                                                } ###########################################################################################################################
                                                                            }                    
                                                                        } ##################################################################################################################
                                                                    }
                                                                } #########################################################################################################
                                                            }
                                                        } ##################################################################################################
                                                    }
                                                } #############################################################################################
                                            }
                                        } #########################################################################################
                                    }
                                } ####################################################################################
                            }
                        } ###################################################################
                    }
                } ##############################################################
            }
        } #########################################################
    }



}

$joltSum

$reader.Close()
$reader.Dispose()




###Below is CoPilot's solution for Part 2
###It is more efficient and elegant than my brute-force nested loops above
$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 3\input.txt')

$joltSum = [bigint]0

function Get-MaxSubsequenceNumber {
    param(
        [string]$line,
        [int]$length
    )

    $n = $line.Length
    if ($n -lt $length) { return $null }

    # precompute non-zero counts from each position to the end (for digits 1-9)
    $nonZeroCountsFromEnd = New-Object int[] ($n + 1)
    $nonZeroCountsFromEnd[$n] = 0
    for ($i = $n - 1; $i -ge 0; $i--) {
        $nonZeroCountsFromEnd[$i] = $nonZeroCountsFromEnd[$i + 1] + ([int]($line[$i] -ne '0'))
    }

    $pos = -1
    $result = New-Object System.Collections.Generic.List[string]

    for ($k = 0; $k -lt $length; $k++) {
        $placed = $false
        $remainingNeeded = $length - ($k + 1)
        for ($d = 9; $d -ge 1; $d--) {
            $dChar = $d.ToString()
            $idx = $line.IndexOf($dChar, $pos + 1)
            if ($idx -ge 0) {
                $availableAfter = $nonZeroCountsFromEnd[$idx + 1]
                if ($availableAfter -ge $remainingNeeded) {
                    $result.Add($dChar)
                    $pos = $idx
                    $placed = $true
                    break
                }
            }
        }
        if (-not $placed) { return $null }
    }

    return -join $result
}

while ($null -ne ($read = $reader.ReadLine())) {
    $numStr = Get-MaxSubsequenceNumber -line $read -length 12
    if ($numStr) {
        $joltSum += [bigint]::Parse($numStr)
    }
}

$joltSum

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

