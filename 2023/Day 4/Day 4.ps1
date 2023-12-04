#Part 1
$pth = '.\2023\Day 4\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$totalscore = 0

while ($null -ne ($read = $reader.ReadLine())) {
    $card = $read.Split(':')[0]
    $mycard = $read.Split('|')[1]
    $winners = $read.Split('|')[0].Split(':')[1]

    $mycard = [Regex]::matches($mycard, '([0-9])+').Value
    $winners = [Regex]::matches($winners, '([0-9])+').Value

    $score = 0

    foreach ($num in $mycard) {
        if ($winners -contains $num) {
            if ($score -gt 0) {
                $score *= 2
            }
            else {
                $score++
            }
        }
    }
    
    #Write-Host "$card - $score"
    $totalscore += $score
}
Write-Host "----------------"
Write-Host "Part 1:"
$totalscore
Write-Host "----------------"


$reader.Close()
$reader.Dispose()



#Part 2
$pth = '.\2023\Day 4\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$cards = @()

$totalscore = 0

while ($null -ne ($read = $reader.ReadLine())) {
    $card = $read.Split(':')[0]
    $mycard = $read.Split('|')[1]
    $winners = $read.Split('|')[0].Split(':')[1]

    $mycard = [Regex]::matches($mycard, '([0-9])+').Value
    $winners = [Regex]::matches($winners, '([0-9])+').Value

    $cards += @{
        Card    = $card
        Numbers = $mycard
        Winners = $winners
        Amount  = 1
    }
}


$reader.Close()
$reader.Dispose()

for ($i = 0; $i -lt $cards.Count; $i++) {
    $card = $cards[$i]
    $count = $card.Amount
    #Write-Host "$($card.Card) - $count"
    $wins = ((Compare-Object -ReferenceObject $card.Numbers -DifferenceObject $card.Winners -IncludeEqual | Where-Object { ($_.SideIndicator -eq '==') }) | Measure-Object).Count
    if ($wins -gt 0) {
        for ($j = 1; $j -le $wins; $j++) {
            $cards[$i + $j].Amount += $count
        }
    }
}


Write-Host "Part 2:"
($cards.Amount | Measure-Object -Sum).Sum
Write-Host "----------------"





