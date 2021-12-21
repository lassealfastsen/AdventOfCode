$Global:Board = @{
    1 = 1
    2 = 2
    3 = 3
    4 = 4
    5 = 5
    6 = 6
    7 = 7
    8 = 8
    9 = 9
    10 = 10
}


Class die {
    [int]$value
    [int]$rolls

    die() {
        $this.value = 0
        $this.rolls = 0
    }

    [int]roll() {
        if ($this.value -eq 100) {$this.value = 0}
        $this.value++
        $this.rolls++
        return $this.value
    }
}


Class Player {
    [int]$position
    [int]$score

    Player([int]$StartPosition) {
        $this.position=$StartPosition
        $this.score=0
    }

    Move([int]$MoveCount){


        #$MoveCount = ($MoveCount % 10)
        #Write-Host "$($this.position) + $MoveCount = " -NoNewline

        $this.position += $MoveCount

        #Write-Host ($this.position) -NoNewline
        if ($this.position -gt 10) {$this.position = (($this.position) % 10)}
        if ($this.position -eq 0) {$this.position = 10}
        #Write-Host "  ($($this.position))"
        $this.score += $Global:Board[$this.position]
    }

    UpdateScore(){
        
    }
}



$die = [die]::New()
$player1 = [Player]::New(4)
$player2 = [Player]::New(10)

$p1 = $true
while (($player1.score -lt 1000) -and ($player2.score -lt 1000)) {

    $move = 0
    for ($i = 0; $i -lt 3; $i++) {
        $move += $die.roll()
    }

    if ($p1) {
        $player1.Move($move)
        #$player1.UpdateScore()
    } else {
        $player2.Move($move)
        $player2.UpdateScore()
    }

    $p1 = (-not $p1)
}


if ($player1.score -ge 1000) {
    $winner = $player1
    $loser = $player2
} else {
    $winner = $player2
    $loser = $player1
}

Write-Host ($loser.score * $die.rolls)
