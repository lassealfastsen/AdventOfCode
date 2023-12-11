Class Card {
    [char]$card
    [int]$value

    hidden $valuemap = @{
        '2' = 2
        '3' = 3
        '4' = 4
        '5' = 5
        '6' = 6
        '7' = 7
        '8' = 8
        '9' = 9
        'T' = 10
        'J' = 11
        'Q' = 12
        'K' = 13
        'A' = 14
    }


    Card([char]$char, [bool]$jokers) {
        if ($jokers) {
            $this.valuemap['J'] = 1
        }
        $this.card = $char
        $this.value = $this.valuemap["$char"]

    }

}



Class Hand {
    [Collections.Generic.List[Card]]$cards
    [int]$bid
    [string]$description
    [int]$strength
    [Card]$highcard
    [int]$card1val
    [int]$card2val
    [int]$card3val
    [int]$card4val
    [int]$card5val

    hidden [void] get_strength() {

    }

    Hand(
        [String]$cardstr,
        [int]$bid,
        [bool]$jokers
    ) {
        $this.cards = [Collections.Generic.List[Card]]::New()
        for ($i = 0; $i -lt $cardstr.Length; $i++) {
            $card = [Card]::new($cardstr[$i], $jokers)
            switch ($i) {
                0 { $this.card1val = $card.value }
                1 { $this.card2val = $card.value }
                2 { $this.card3val = $card.value }
                3 { $this.card4val = $card.value }
                4 { $this.card5val = $card.value }
                Default {}
            }
            $this.cards.Add($card)
        }
        $this.bid = $bid

        $this.highcard = $this.cards | Sort-Object value -Descending | Select-Object -First 1

        if ($jokers) {
            $maxcard = ($this.cards.value | Where-Object { ($_ -ne 1) } | Group-Object | Sort-Object Count, Name -Descending | Select-Object -First 1).Name
            $this.cards | Where-Object { ($_.card -eq 'J') } | ForEach-Object {
                $_.card = ($this.cards | Where-Object { ($_.value -eq $maxcard) } | Select-Object -First 1).Card
            }
        }

        if (($this.cards.card | Select-Object -Unique).Count -eq 1) {
            #All cards are the same so it must be Five of a Count
            $this.strength = 7
            $this.description = "Five of a kind"
        }
        elseif (($this.cards.card | Select-Object -Unique).Count -eq 2) {
            #2 kinds (4 of a kind or full house)
            $type = ($this.cards.card | Select-Object -Unique -First 1)

            $counts = $this.cards.card | Group-Object

            if ((($this.cards | Where-Object { ($_.card -eq $type) }).Count -in @(4, 1))) {
                $this.strength = 6
                $this.description = "Four of a Kind"
            }
            elseif ((($this.cards | Where-Object { ($_.card -eq $type) }).Count -in @(3, 2))) {
                $this.strength = 5
                $this.description = "Full house"
            }
        }
        elseif (($this.cards.card | Select-Object -Unique).Count -eq 3) {
            #must be 3 of a kind or two pairs
            $types = ($this.cards.card | Select-Object -Unique)

            if (((($this.cards | Where-Object { ($_.card -eq $types[0]) }).Count ) -eq 3) -or ((($this.cards | Where-Object { ($_.card -eq $types[1]) }).Count ) -eq 3) -or ((($this.cards | Where-Object { ($_.card -eq $types[2]) }).Count ) -eq 3) ) {
                $this.strength = 4
                $this.description = "Thee of a kind"
            }
            else {
                $this.strength = 3
                $this.description = "2 pair"
            }
        }
        elseif (($this.cards.card | Select-Object -Unique).Count -eq 4) {
            #must be 1 pair
            
            $this.strength = 2
            $this.description = "1 pair"
            
        }
        else {
            $this.strength = 1
            $this.description = "high card"
        }


    }


}

#$hand = [Hand]::new("AAAAA", 765)


# [Hand]::new("AAAAA", 765)
# [Hand]::new("AA8AA", 765)
# [Hand]::new("23332", 765)
# [Hand]::new("TTT98", 765)
# [Hand]::new("23432", 765)
# [Hand]::new("A23A4", 765)
# [Hand]::new("12345", 765)



#Part1

$pth = ".\2023\Day 7\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$hands = @()
while ($null -ne ($read = $reader.ReadLine())) {

    $hands += [Hand]::New($read.Split(' ')[0], $read.Split(' ')[1], $false)

}

$reader.Close()
$reader.Dispose()


$Hands = $hands | Sort-Object @{Expression = "strength"; Descending = $false }, @{Expression = "card1val"; Descending = $false }, @{Expression = "card2val"; Descending = $false }, @{Expression = "card3val"; Descending = $false }, @{Expression = "card4val"; Descending = $false }, @{Expression = "card5val"; Descending = $false }

$res = 0
for ($i = 0; $i -lt $Hands.count ; $i++) {
    $res += $hands[$i].bid * ($i + 1)
}

$res


#Part2
$pth = ".\2023\Day 7\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$hands = @()
while ($null -ne ($read = $reader.ReadLine())) {

    $hands += [Hand]::New($read.Split(' ')[0], $read.Split(' ')[1], $true)

}

$reader.Close()
$reader.Dispose()


$Hands = $hands | Sort-Object @{Expression = "strength"; Descending = $false }, @{Expression = "card1val"; Descending = $false }, @{Expression = "card2val"; Descending = $false }, @{Expression = "card3val"; Descending = $false }, @{Expression = "card4val"; Descending = $false }, @{Expression = "card5val"; Descending = $false }

$res = 0
for ($i = 0; $i -lt $Hands.count ; $i++) {
    $res += $hands[$i].bid * ($i + 1)
}

$res
