$idRanges = (Get-Content '.\AdventOfCode\2025\Day 2\input.txt').Split(',')

$p1InvalidIdSum = [bigint]0
$p2InvalidIdSum = [bigint]0

foreach ($idRange in $idRanges) {
    Write-Host $idRange -ForeGroundColor Cyan -NoNewLine
    $start = [bigint]$idRange.Split('-')[0]
    $end = [bigint]$idRange.Split('-')[1]

    for ($i = $start; $i -le $end; ($i += 1)) {
        $str = [string]$i
        
        #part 1
        #uneven lengths can not be invalid for part 1

        #if ($str.Length -ge 2) {
        if (([regex]::Matches($str, $str[0])).Count -eq $str.Length) {
            if ($str.Length -ge 2) { $p2InvalidIdSum += $i }
            if ($str.Length % 2 -eq 0) {
                $p1InvalidIdSum += $i
            }
            Write-Host "*" -ForeGroundColor Red -NoNewLine
            #Write-Host $i -ForegroundColor Red
        }

        else {
            switch ($str.Length % 2) {
                0 {
                    if (($str.Length) % 2 -eq 0) {
                        $firstHalf = $str.Substring(0, (($str.Length / 2)))
                        $secondHalf = $str.Substring((($str.Length / 2)), (($str.Length / 2)))

                        if ($firstHalf -eq $secondHalf) {
                            Write-Host "*" -ForegroundColor Red -NoNewline
                            $p1InvalidIdSum += $i
                        }
                        #break
                    }
                    $maxLength = $str.Length / 2
                    for ($j = 2; $j -le $maxLength; $j += 1) {
                        if ((([regex]::Matches($str, $str.Substring(0, $j))).Count * $j) -eq $str.Length) {
                            $p2InvalidIdSum += $i
                            # if ($str.Length / $j -eq 2) {
                            #     $p1InvalidIdSum += $i
                            # }
                            Write-Host "*" -ForeGroundColor Red -NoNewLine
                            #Write-Host $i -ForegroundColor Red
                            break
                        }
                    }
                }
                1 {
                    #uneven Lenght numbers must be in uneven length subparts
                    $maxLength = $str.Length / 3
                    for ($j = 3; $j -le $maxLength; $j += 2) {
                        if ((([regex]::Matches($str, $str.Substring(0, $j))).Count * $j) -eq $str.Length) {
                            $p2InvalidIdSum += $i
                            Write-Host "*" -ForeGroundColor Red -NoNewLine
                            #Write-Host $i -ForegroundColor Red
                            break
                        }
                    }
                }
            }
        }
    }
    Write-Host ""
    #}
}

Write-Host "Part 1: $p1InvalidIdSum" -ForegroundColor Green
Write-Host "Part 2: $p2InvalidIdSum" -ForegroundColor Green

#p2 45283684600 too high --- Exclude single-digit numbers in part 2 only :S

#This should be possible to optimize by skipping if P1 is invalid, so is part 2, but i can't seem to get that to work.