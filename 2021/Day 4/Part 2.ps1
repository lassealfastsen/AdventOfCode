$Order = (Get-Content -Path '.\2021\Day 4\order.txt' ).Split(',')
$Boardpth = '.\2021\Day 4\boards.txt'


class Board {
    [System.Collections.ArrayList]$rows
}

$reader = New-Object System.IO.StreamReader($Boardpth)

[Board[]]$Boards = @()

$brd = New-Object -TypeName Board
$brd.rows = @()
while ( ($read = $reader.ReadLine()) -ne $null) {
    if ($read -like '') {
        $Boards += $brd
        $brd = New-Object -TypeName Board
        $brd.rows = @()
    } else {
        $arr = $read.Replace('  ', ' ').Split(' ')
        $arr = $arr | Where-Object {($_ -notlike '')}
        $brd.rows.Add($arr)
    }
}
$Boards += $brd

$reader.Close()
$reader.Dispose()




Function Check-Bingo {
    Param(
        [Parameter(Mandatory=$true, Position=1)]$Board
    )

    #Vertical
    foreach ($row in $Board.rows) {
        if ((($row | Where-Object {($_ -match "^x(\d)*")}).Count -eq $row.Count)) {
            return $true
        }
    }

    #horizontal
    for ($i = 0; $i -lt $Board.rows.Count; $i++) {
        $cnt = 0
        foreach ($row in $Board.rows) {
            if ($row[$i] -match "^x(\d)*") {$cnt++}
        }
        if ($cnt -eq $Board.rows.Count) {
            return $true
        }

    }
    return $false
}



$cnt = 1

$sums = @()

foreach ($num in $Order) {
    for ($bi = 0; $bi -lt $Boards.Count; $bi++) {
        for ($ri = 0; $ri -lt $Boards[$bi].rows.Count; $ri++) {
            for ($ni = 0; $ni -lt $Boards[$bi].rows[$ri].Count; $ni++) {
                #Write-Host "$($Boards[$bi].rows[$ri][$ni]) -- $num"
                if (($Boards[$bi].rows[$ri][$ni]) -eq [string]$num) {
                    $Boards[$bi].rows[$ri][$ni] = "x$($Boards[$bi].rows[$ri][$ni])"
                }
            }
        }
    }

    foreach ($Board in $Boards) {
        if (Check-Bingo $Board) {
            $sum = 0
            foreach ($row in $Board.rows) {
                foreach ($n in  $row) {
                    if ($n -notlike "x*") {
                        $sum += [int] $n
                    }
                }
            }
            
            $sums += [PSCustomObject]@{
                count = $cnt
                num = $num
                sum = $sum
            }
            $boards = $Boards | Where-Object {( $_ -ne $Board )}
            
        }
    }
    $cnt ++
}


($sums | Select-Object -Last 1) | Select @{Name='Answer';Expression={[int]$_.num * [int]$_.sum}}