


#$initString = "NNCB"
$initString = "BSONBHNSSCFPSFOPHKPK"



$pairs = @()
$letters = @()
$instructions = @()


Get-Content -LiteralPath '.\2021\Day 14\input.txt' | ForEach-Object {
    $instructions += [PSCustomObject]@{
        pair = $_.Split(' -> ')[0]
        char = $_.Split(' -> ')[1]
    }   
    if ($letters.letter -notcontains $_.Split(' -> ')[1]) {
        $letters += [PSCustomObject]@{
            letter = $_.Split(' -> ')[1]
            cnt = 0
        }
    }

    if ($pairs.pair -notcontains $_.Split(' -> ')[0]) {
        $pairs += [PSCustomObject]@{
            Pair = $_.Split(' -> ')[0]
            Cnt = 0
        }
    }
}





for ($i = 0; $i -lt $initString.Length-1; $i++) {
    ($pairs | Where-Object {($_.Pair -eq $initString.Substring($i,2))}).Cnt++
}
for ($i = 0; $i -lt $initString.Length; $i++) {
    ($letters | Where-Object {($_.letter -eq $initString[$i])}).Cnt++
}


$iterations = 10 # Part 1
$iterations = 40 # Part 2
for ($i=0; $i -lt $iterations; $i++) {
    #$i
    $tmp = $pairs | Where-Object {($_.Cnt -gt 0)} | ConvertTo-Json | ConvertFrom-Json



    foreach ($pair in $tmp) {

        $cnt = $pair.Cnt
        $instruction = $instructions | Where-Object {($_.pair -eq $pair.pair)}

        
        ($pairs | Where-Object {($_.pair -eq $pair.pair)}).Cnt -= $Cnt
        ($pairs | Where-Object {($_.pair -eq "$($pair.pair[0])$($instruction.char)" )}).Cnt += $Cnt
        ($pairs | Where-Object {($_.pair -eq "$($instruction.char)$($pair.pair[1])" )}).Cnt += $Cnt

        ($letters | Where-Object {($_.letter -eq $instruction.char)}).Cnt += $cnt


    }
}

#$pairs
$least = ($letters | Sort Cnt | Select -First 1).Cnt
$most = ($letters | Sort Cnt | Select -last 1).Cnt

Write-Host ([String]::Format("{0} - {1} = {2}", $most, $least, ($most-$least)))




# $queue = $pairs | Where-Object {($_.Cnt -gt 0)}

# foreach ($pair in $queue ) {
#     if ($pair.pair -in $instructions.pair) {
#         $letter = $instructions | Where-Object {$_.pair -eq $pair.Pair}
        

#     }
# }



# BBBBBBBBBBB
# CCCCC
# NNNNN
# HHHH
<#













        if ($instructions.pair -contains $pair.pair) {
            for ($paircount = 0; $paircount -lt $pair.Cnt; $paircount++) {
                ($pairs | Where-Object {($_.pair -eq $pair.pair)}).cnt--
        
                $char = ($instructions | Where-Object {$_.pair -eq $pair.pair}).char
                
                $newpairs = $("$($pair.pair[0])$char", "$char$($pair.pair[1])")
            
                foreach ($newpair in $newpairs) {
                    if ($pairs.pair -contains $newpair) {
                        ($pairs | Where-Object {($_.pair -eq $newpair)}).Cnt++
                    } else {
                        $pairs += [PSCustomObject]@{
                            Pair = $newpair
                            Cnt = 1
                        }
                    }
                }
            
                if ($letters.letter -contains $char) {
                    ($letters | Where-Object {$_.letter -eq $char}).Cnt++
                } else {
                    $letters += [PSCustomObject]@{
                        letter = $char
                        cnt = 1
                    }
                }
            }
        }



$iterations = 3
for ($i=0; $i -lt $iterations; $i++) {

    $workingpairs = $pairs

    foreach ($instruction in $instructions | Where-Object {($_.Split(' -> ')[0] -in $pairs.Pair)}) {
        $pair = $instruction.Split(' -> ')[0]
        $char = $instruction.Split(' -> ')[1]
    
        #$mods = @()
        if (($pairs | Where-Object {($_.Cnt -gt 0)}).Pair -contains $pair) {
            ($pairs | Where-Object {($_.Pair -eq $pair)}).Cnt--
            $n1 = "$($pair[0])$char"
            if ($pairs.Pair -contains $n1) {
                ($pairs | Where-Object {($_.Pair -eq $n1)}).Cnt++
            } else {
                $pairs += [PSCustomObject]@{
                    Pair = $n1
                    Cnt = 1
                }
            }
            $n2 = "$char$($pair[1])"
            if ($pairs.Pair -contains $n2) {
                ($pairs | Where-Object {($_.Pair -eq $n2)}).Cnt++
            } else {
                $pairs += [PSCustomObject]@{
                    Pair = $n2
                    Cnt = 1
                }
            }
    
            if ($letters.letter -contains $char) {
                ($letters | Where-Object {($_.letter -eq $char)}).cnt++
            } else {
                $letters += [PSCustomObject]@{
                    letter = $char
                    cnt = 1
                }
            }
        }
    }
}


CCCCC

$letters

<#

NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB

[Math]::Round(($pairs | Where-Object {$_.Pair -match 'N'}).Cnt / 2) + (($pairs | Where-Object {($_.Pair -eq 'NN')}).Count * 2) + 1
[Math]::Round(($pairs | Where-Object {$_.Pair -match 'C'}).Cnt / 2) + (($pairs | Where-Object {($_.Pair -eq 'CC')}).Count * 2)
[Math]::Round(($pairs | Where-Object {$_.Pair -match 'B'}).Cnt / 2) + (($pairs | Where-Object {($_.Pair -eq 'BB')}).Count * 2) +1
[Math]::Round(($pairs | Where-Object {$_.Pair -match 'H'}).Cnt / 2)


([Math]::Round((( | Measure-Object -Sum).Sum / 2))
([Math]::Round((($pairs | Where-Object {$_.Pair -match 'C'}).Count | Measure-Object -Sum).Sum / 2))
((($pairs | Where-Object {$_.Pair -match 'B'}).Count | Measure-Object -Sum).Sum * 2) - 1




[Math]::Round((($pairs | Where-Object {$_.Pair -match 'N'}).Cnt | Measure-Object -Sum).Sum / 2)
([Math]::Round((($pairs | Where-Object {($_.Pair -ne 'BB') -and ($_.Pair -match 'B')}).Cnt | Measure-Object -Sum).Sum / 2) -1) + (($pairs | Where-Object {($_.Pair -eq 'BB')}).Cnt)
[Math]::Round((($pairs | Where-Object {$_.Pair -match 'C'}).Cnt | Measure-Object -Sum).Sum / 2)
[Math]::Round((($pairs | Where-Object {$_.Pair -match 'H'}).Cnt | Measure-Object -Sum).Sum / 2)


($pairs | Where-Object {($_.Pair -ne 'BB') -and ($_.Pair -match 'B')}).Cnt

#>


#>