$pth = '.\2022\Day 11\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$monkeys = @()


$monkey = @{
    Monkey      = $null
    items       = $null
    op          = $null
    opval       = $null
    testval     = $null
    truemonkey  = $null
    falsemonkey = $null
    inspections = 0
}

while ($null -ne ($read = $reader.ReadLine())) {
    if ($read.Length -eq 0) {
        $monkeys += @{
            Monkey      = $monkeys.Count
            items       = $monkey.items
            op          = $monkey.op
            opval       = $monkey.opval
            testval     = $monkey.testval
            truemonkey  = $monkey.truemonkey
            falsemonkey = $monkey.falsemonkey
            inspections = 0
        }
        continue
    } elseif ($read[0] -eq 'M') { continue }

    switch ($read[2]) {
        'S' {
            $monkey.items = [bigint[]](($read -split ": ")[1] -split ", ")
        }
        'O' {
            $monkey.op = ($read -split "old ")[1].Split(' ')[0]
            $monkey.opval = (($read -split "old ")[1].Split(' ')[1])
        }
        'T' {
            $monkey.testval = [int]($read -split "by ")[1]
        }
        ' ' {
            switch ($read[7]) {
                't' { 
                    $monkey.truemonkey = [int]($read -split "monkey ")[1]
                }
                'f' {
                    $monkey.falsemonkey = [int]($read -split "monkey ")[1]
                }
            }    
        }
    }

}
$monkeys += @{
    Monkey      = $monkeys.Count
    items       = $monkey.items
    op          = $monkey.op
    opval       = $monkey.opval
    testval     = $monkey.testval
    truemonkey  = $monkey.truemonkey
    falsemonkey = $monkey.falsemonkey
    inspections = 0
}

$reader.Close()
$reader.Dispose()


$LCM = $monkeys.testval -join '*' | Invoke-Expression


for ($round = 0; $round -lt 10000; $round++) {
    #Write-Host $round
    for ($i = 0; $i -lt $monkeys.Count; $i++) {
        $monkey = $monkeys[$i]
        #Write-Host " - $($monkey.Monkey)"
        for ($j = 0; $j -lt $monkeys[$i].items.Count; $j++) {
            switch ($monkey.op) { #do Operation
                "*" { 
                    if ($monkey.opval -eq "old") {
                        $monkeys[$i].items[$j] *= $monkeys[$i].items[$j]
                    } else {
                        $monkeys[$i].items[$j] *= $monkey.opval
                    }
                    
                }
                "+" {
                    if ($monkey.opval -eq "old") {
                        $monkeys[$i].items[$j] += $monkeys[$i].items[$j]
                    } else {
                        $monkeys[$i].items[$j] += $monkey.opval
                    }
                }
            }

            #Bored
            #$monkeys[$i].items[$j]
            #$monkeys[$i].items[$j] = [Math]::floor($monkeys[$i].items[$j] / 3)

            $monkeys[$i].items[$j] = ($monkeys[$i].items[$j] % $LCM)

            switch (($monkeys[$i].items[$j] % $monkey.testval) -eq 0) {
                $true { $monkeys[$monkey.truemonkey].items += $monkeys[$i].items[$j] }
                $false { $monkeys[$monkey.falsemonkey].items += $monkeys[$i].items[$j] }
            }

            $monkeys[$i].inspections++
        }
        $monkeys[$i].items = @()
    }
}

($monkeys.inspections | Sort-Object)[-1, -2] -join '*' | Invoke-Expression

