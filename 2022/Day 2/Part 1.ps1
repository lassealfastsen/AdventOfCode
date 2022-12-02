$map = @{
    'A'='Rock';
    'B'='Paper';
    'C'='Scissors'
}

$translated = @{
    'X'='A';
    'Y'='B';
    'Z'='C'
}

$pointtable=@{
    'Rock'=1;
    'Paper'=2;
    'Scissors'=3
}

$outcomes = @{
    'Rock Rock'=@{Result='Draw'; Points=3};
    'Rock Paper'=@{Result='Loss'; Points=0};
    'Rock Scissors'=@{Result='Win'; Points=6};
    'Paper Paper'=@{Result='Draw'; Points=3};
    'Paper Rock'=@{Result='Win'; Points=6};
    'Paper Scissors'=@{Result='Loss'; Points=0};
    'Scissors Paper'=@{Result='Win'; Points=6};
    'Scissors Rock'=@{Result='Loss'; Points=0};
    'Scissors Scissors'=@{Result='Draw'; Points=3};
}


$pth = '.\2022\Day 2\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$points = 0
while ( ($read = $reader.ReadLine()) -ne $null)  {
    $opponent = $map[[String]$read[0]]
    $me = $map[[String]$translated[[String]$read[2]]]

    $result = $outcomes["$me $opponent"]

    $points += $result.Points
    $points += $pointtable[$me]
}


$reader.Close()
$reader.Dispose()


$points