$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 6\input.txt')


$worksheet = @{}
$operations = @()
$xmax = 0

$p2Worksheet = @()



#P1
$ymax = 0
while ($null -ne ($read = $reader.ReadLine())) {

    $nums = [regex]::Matches($read, "(\d*)").Value | Where-Object { ($_ -ne "") }
    $ops = [regex]::Matches($read, "(\*|\+)").Value | Where-Object { ($_ -ne "") }

    
    if ($ops.Count -gt 0) {
        $operations = $ops
    }
    else {
        $p2Worksheet += $read
        $xmax = [math]::Max($xmax, $nums.Count - 1)
        for ($x = 0; $x -lt $nums.Count; $x++) {
            $gridKey = "$x,$ymax"
            $worksheet[$gridKey] = [PSCustomObject]@{
                Value = [int]$nums[$x]
                x     = $x
                $y    = $ymax
            }
            
        }
        $ymax++
    }


}

$reader.Close()
$reader.Dispose()


#Part 1
$sum = [bigint]0

for ($x = 0; $x -le $xmax; $x++) {
    $op = $operations[$x]
    $columnValue = $worksheet["$x,0"].Value
    for ($y = 1; $y -lt $ymax; $y++) {
        switch ($op) {
            '*' {
                $columnValue *= $worksheet["$x,$y"].Value
            }
            '+' {
                $columnValue += $worksheet["$x,$y"].Value
            }
        }
    }

    $sum += $columnValue
    #$columnValue
}

Write-Host "Part 1: $sum"

#Part 2

$p2Sum = [bigint]0
$p2WorksheetLength = $p2Worksheet[0].Length

$colIdx = 0

$cols = @()


for ($x = 0; $x -le $p2WorksheetLength; $x++) {
    $col = ""    
    for ($y = 0; $y -lt $p2Worksheet.Count; $y++) {
        $col = $col + $p2Worksheet[$y][$x]
    }

    if ($col -match "\d" -and $x -ne ($p2WorksheetLength)) {
        $cols += $col
    }
    else {
        ##NExt Column And Operator
        $p2Sum += ($cols -join " $($operations[$colIdx]) " | Invoke-Expression)
        $col = ""
        $cols = @()
        $colIdx++
    }
    <# Action that will repeat until the condition is met #>
}
#$p2Sum += ($cols -join " $($operations[$colIdx]) " | Invoke-Expression)

Write-Host "Part 2: $p2sum"