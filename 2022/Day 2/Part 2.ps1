$map = @{
    'A'='Rock';
    'B'='Paper';
    'C'='Scissors'
}

$translated = @{
    'X'='lose';
    'Y'='draw';
    'Z'='win'
}

$pointtable=@{
    'Rock'=1;
    'Paper'=2;
    'Scissors'=3;
    'win'=6;
    'draw'=3;
    'lose'=0

}

$outcomes = @{
    'Rock'=@{win='Paper'; draw='Rock'; lose='Scissors'};
    'Paper'=@{win='Scissors'; draw='Paper'; lose='Rock'};
    'Scissors'=@{win='Rock'; draw='Scissors'; lose='Paper'};
    #'Rock Paper'=@{Result='Loss'; Points=0};
    #'Rock Scissors'=@{Result='Win'; Points=6};
    #'Paper Paper'=@{Result='Draw'; Points=3};
    #'Paper Rock'=@{Result='Win'; Points=6};
    #'Paper Scissors'=@{Result='Loss'; Points=0};
    #'Scissors Paper'=@{Result='Win'; Points=6};
    #'Scissors Rock'=@{Result='Loss'; Points=0};
    #'Scissors Scissors'=@{Result='Draw'; Points=3};
}


$pth = '.\2022\Day 2\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$points = 0
while ( ($read = $reader.ReadLine()) -ne $null)  {


    $opponent = $map[[String]$read[0]]

    $expected = "$($translated[[String]$read[2]])"

    $me = $outcomes[$opponent].$expected
    
    $points += $pointtable[$me]
    $points += $pointtable[$expected]

    #$map[[String]$translated[[String]$read[2]]]

    #$result = $outcomes["$me $opponent"]

    #$points += $result.Points
    #$points += $pointtable[$me]
}


$reader.Close()
$reader.Dispose()


$points