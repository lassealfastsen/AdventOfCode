class Seat {
    [int]$Row
    [int]$Column
    [int]$SeatID

    Seat(
        [string]$SeatCode
    ){
        $rowCode = ($SeatCode.Substring(0,7)).ToCharArray()
        $columnCode = ($SeatCode.Substring(7,3)).ToCharArray()

        $rowmin = 0
        $rowmax = 127

        for ($i = 0; $i -lt $rowCode.Count; $i++) {
            if ($i -eq $rowCode.Count-1) {
                switch ($rowCode[$i]) {
                    'F' { $this.Row =$rowmin }
                    'B' { $this.Row = $rowmax }
                }
            } else {

                $diff = [Math]::Round(($rowmax-$rowmin)/2)

                switch ($rowCode[$i]) {
                    'F' { $rowmax-= $diff}
                    'B' { $rowmin+=$diff}
                }
            }
        }

        $columnmin = 0
        $columnmax = 7

        for ($i = 0; $i -lt $columnCode.Count; $i++) {
            if ($i -eq $columnCode.Count-1) {
                switch ($columnCode[$i]) {
                    'R' { $this.Column = $columnmax }
                    'L' { $this.Column = $columnmin }
                }
            } else {

                $diff = [Math]::Round(($columnmax-$columnmin)/2)

                switch ($columnCode[$i]) {
                    'R' { $columnmin += $diff}
                    'L' { $columnmax -= $diff}
                }
            }
        }


        $this.SeatID = (($this.Row * 8) + $this.Column)

    }
}



$rawInput = Get-Content '.\2020\Day 5\input.txt' -Raw

$boardingPasses = $rawInput.Split("`r`n")

$Seats = [Seat[]]@()

foreach ($boardingPass in $boardingPasses) {
    $Seats += [Seat]($boardingPass)
}

#Part1 Answer

Write-Host "The Largest SeatID is '$(($Seats | Sort-Object SeatID -Descending | Select-Object -First 1).SeatId)'"



#Part2

$Seats = $Seats | Sort-Object SeatID


$val = ($Seats | Sort-Object SeatID)[0].SeatID
#$max = ($Seats | Sort-Object SeatID -Descending)[0].SeatID

for ($i = 1; $i -lt $Seats.Count; $i++) {
    if ($Seats[$i].SeatID -eq $val+2) {
        Write-Host ("Your Seat ID is: '" + ([int]($Seats[$i].SeatID)-1) +"'")
    } else {
        $val++
    }
}

