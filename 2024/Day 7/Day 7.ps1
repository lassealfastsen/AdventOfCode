Function Get-options {
    $lst = @('+', '*')  # Define the list with elements 'a' and 'b'
    $result = @()  # Initialize an empty array to store results

    # # Use nested loops to generate combinations of x, y, and z
    # foreach ($x in $lst) {
    #     foreach ($y in $lst) {
    #         foreach ($z in $lst) {
    #             $result += $x + $y + $z  # Concatenate x, y, and z and add to the result array
    #         }
    #     }
    # }

    foreach ($a in $lst) {
        foreach ($c in $lst) {
            foreach ($d in $lst) {
                foreach ($e in $lst) {
                    foreach ($f in $lst) {
                        foreach ($g in $lst) {
                            foreach ($h in $lst) {
                                foreach ($i in $lst) {
                                    foreach ($j in $lst) {
                                        foreach ($k in $lst) {
                                            foreach ($l in $lst) {
                                                foreach ($m in $lst) {
                                                    foreach ($n in $lst) {
                                                        foreach ($o in $lst) {
                                                            foreach ($p in $lst) {
                                                                $result += [string]::Concat($a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $m, $n, $o, $p)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    # Output the result
    $result
}



function Get-Permutations {
    [CmdletBinding()]
    param (
        [string] $prefix,
        [string] $word
    )
    if ([string]::IsNullOrEmpty($word)) {
        #Write-Host $prefix -ForegroundColor Green
        Add-Content -Path 'C:\git\AdventOfCode\2024\Day 7\tst.txt' -Value $prefix
    }
    else {
        for ($i = 0; $i -lt $word.Length; $i++) {
            $char = $word[$i]
            $newPrefix = $prefix + $char
            $newWord = $word.Substring(0, $i) + $word.Substring($i + 1)
            #Write-Output("Character: {0} - Prefix: {1} - Word {2}" -f $char, $newPrefix, $newWord)
            Get-Permutations -prefix $newPrefix -word $newWord
        }
    }
}

#Get-Permutations -prefix "" -word $word

$calibrationEqueations = Get-Content 'C:\git\AdventOfCode\2024\Day 7\input.txt'

#$opOrders = Get-options
$opOrders = Get-Content "C:\git\AdventOfCode\2024\Day 7\ops.txt"

[bigint]$validTargetSum = 0
$total = $calibrationEqueations.Count
$num = 1

$invalidEquations = @()

:calibration foreach ($calibrationEqueation in $calibrationEqueations) {
    Write-Host "$num/$total - $calibrationEqueation" -NoNewline
    $target = [bigint]::Parse($calibrationEqueation.split(':')[0])
    $numbers = ([regex]::Matches($calibrationEqueation.split(':')[1], "\d+")).Value
    $originalNumbers = $numbers.Clone()
    :op foreach ($opOrder in $opOrders) {
        $numbers = $originalNumbers.Clone()
        $result = [bigint]::Parse($numbers[0])
        for ($i = 1; $i -lt $numbers.Count; $i++) {
            switch ($opOrder[$i - 1]) {
                '+' {
                    $result += $numbers[$i]
                    continue
                }
                '*' {
                    $result *= $numbers[$i]
                    continue
                }
                '|' {
                    $numbers[$i] = [bigint]::Parse("$($numbers[$i])$($numbers[$i+1])")
                    $numbers[$i + 1] = 0
                }

            }
            if ($result -gt $target) {
                continue op #current order is too high
            }
        }
        if ($result -eq $target) {
            Write-Host " Valid" -ForegroundColor Green
            $validTargetSum += $target
            continue calibration
        }
    }
    $invalidEquations += $calibrationEqueation
    Write-Host " Invalid" -ForegroundColor Red
    $num++
}

$validTargetSum

#Part 2 no worky here....
#mUST BE REDONE FROM SCRATCH SOMEDAY...
#https://www.reddit.com/r/adventofcode/comments/1h949fp/am_i_just_stupid/
#[bigint]$p2targetsum = 0
#
#foreach ($invalidEquation in $invalidEquations) {
#    $target = [bigint]::Parse($invalidEquation.split(':')[0])
#    $numbers = ([regex]::Matches($invalidEquation.split(':')[1], "\d+")).Value
#    $ogNumbers = $numbers.Clone()
#    
#
#    for ($i = 0; $i -lt $numbers.count - 1; $i++) {
#        $res = 0
#        $numbers = $ogNumbers.Clone()
#        $permutation = @()
#        for ($j = 0; $j -lt $i; $j++) {
#
#            #:op foreach ($opOrder in $opOrders) {
#            $result = [bigint]::Parse($numbers[0])
#            #for ($i = 1; $i -lt $numbers.Count; $i++) {
#            switch ($opOrder[$i - 1]) {
#                '+' {
#                    $result += [bigint]::Parse($numbers[$i])
#                    continue
#                }
#                '*' {
#                    $result *= [bigint]::Parse($numbers[$i])
#                    continue
#                }
#            }
#            if ($result -gt $target) {
#                continue op #current order is too high
#            }
#            #}
#        }
#    }
#
#    if ($k -gt 0) {
#        $permutation += $numbers[0..($i - 1)]
#    }
#    $permutation += (@([bigint]::Parse("$($numbers[$i])$($numbers[$i+1])")) + $numbers[($i + 2)..$numbers.Count])
#    Write-Host "$permutation" -NoNewline
#
#    if ($permutation.Count -eq 1 -and $permutation[0] -eq $target) {
#        Write-Host " Valid" -ForegroundColor Green
#        $p2targetsum += $target
#    }
#    elseif ($permutation.Count -gt 1) {
#            
#        #$target = [bigint]::Parse($permutation.split(':')[0])
#        $numbers = $permutation
#        :op foreach ($opOrder in $opOrders) {
#            $result = [bigint]::Parse($permutation[0])
#            for ($i = 1; $i -lt $permutation.Count; $i++) {
#                switch ($opOrder[$i - 1]) {
#                    '+' {
#                        $result += [bigint]::Parse($permutation[$i])
#                        continue
#                    }
#                    '*' {
#                        $result *= [bigint]::Parse($permutation[$i])
#                        continue
#                    }
#                }
#                if ($result -gt $target) {
#                    continue op #current order is too high
#                }
#            }
#            if ($result -eq $target) {
#                Write-Host " Valid" -ForegroundColor Green
#                $p2targetsum += $target
#                $i = [int]::MaxValue
#            }
#        }
#        Write-Host " Invalid" -ForegroundColor Red
#    }
#    else {
#        Write-Host " Invalid" -ForegroundColor Red
#    }
#        
#}
#
#
## $possiblePermutations = [System.Collections.ArrayList]::new()
## for ($i = 0; $i -lt $numbers.count - 1; $i++) {
##     $permutation = @()
##     if ($i -gt 0) {
##         $permutation += $numbers[0..($i - 1)]
##     }
##     $permutation += (@([bigint]::Parse("$($numbers[$i])$($numbers[$i+1])")) + $numbers[($i + 2)..$numbers.Count])
##     $possiblePermutations.Add($permutation) | Out-Null
## }
#
## if ($possiblePermutations.Count -eq 1 -and $possiblePermutations[0] -eq $target) {
##     Write-Host ($possiblePermutations[0] -join ' ') -NoNewline
##     Write-Host " Valid" -ForegroundColor Green
##     $p2targetsum += $target
## }
## elseif ($possiblePermutations.Count -gt 1) {
##     :calibration foreach ($permutation in $possiblePermutations) {
##         Write-Host "$permutation" -NoNewline
##         #$target = [bigint]::Parse($permutation.split(':')[0])
##         $numbers = $permutation
##         :op foreach ($opOrder in $opOrders) {
##             $result = [bigint]::Parse($numbers[0])
##             for ($i = 1; $i -lt $numbers.Count; $i++) {
##                 switch ($opOrder[$i - 1]) {
##                     '+' {
##                         $result += [bigint]::Parse($numbers[$i])
##                         continue
##                     }
##                     '*' {
##                         $result *= [bigint]::Parse($numbers[$i])
##                         continue
##                     }
##                 }
##                 if ($result -gt $target) {
##                     continue op #current order is too high
##                 }
##             }
##             if ($result -eq $target) {
##                 Write-Host " Valid" -ForegroundColor Green
##                 $p2targetsum += $target
##                 break calibration
##             }
##         }
##         Write-Host " Invalid" -ForegroundColor Red
##     }
## }
#
##}
#
#$validTargetSum + $p2targetsum
#