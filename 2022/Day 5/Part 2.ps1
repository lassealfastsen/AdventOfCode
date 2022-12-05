# $stacks = @{
#     1='ZN'
#     2='MCD'
#     3='P'
# }

$stacks = @{
    1='HBVWNMLP'
    2='MQH'
    3='NDBGFQML'
    4='ZTFQMWG'
    5='MTHP'
    6='CBMJDHGT'
    7='MNBFVR'
    8='PLHMRGS'
    9='PDBCN'
}


# [P]     [L]         [T]            
# [L]     [M] [G]     [G]     [S]    
# [M]     [Q] [W]     [H] [R] [G]    
# [N]     [F] [M]     [D] [V] [R] [N]
# [W]     [G] [Q] [P] [J] [F] [M] [C]
# [V] [H] [B] [F] [H] [M] [B] [H] [B]
# [B] [Q] [D] [T] [T] [B] [N] [L] [D]
# [H] [M] [N] [Z] [M] [C] [M] [P] [P]
#  1   2   3   4   5   6   7   8   9 



Function Move-Cargo {
    Param(
        [Parameter(Mandatory=$true)][int]$from,
        [Parameter(Mandatory=$true)][int]$to,
        [Parameter(Mandatory=$true)][int]$amount
    )

    #for ($i = 0; $i -lt $amount; $i++) {

        $crates = $stacks[$from].Substring(($stacks[$from].Length-$amount),($amount))
        $stacks[$from] = $stacks[$from].Substring(0,$stacks[$from].Length-$amount)
        $stacks[$to] = "$($stacks[$to])$crates"
    #}
}

$pth = '.\2022\Day 5\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

while ( ($read = $reader.ReadLine()) -ne $null)  {
    $readarr = $read.Split(' ')
    $moveamount = $readarr[1]
    $movefrom = $readarr[3]
    $moveto = $readarr[5]

    Move-Cargo -from $movefrom -to $moveto -amount $moveamount
}

foreach ($stack in $stacks.Keys | Sort-Object) {
    $cargo = $stacks[$stack]
    #Write-Host $stacks[$stack].Value.Substring(($stack.Length-1),($stack.Length))
    Write-Host $cargo.Substring(($cargo.Length-1),1) -NoNewline
}
Write-Host

$reader.Close()
$reader.Dispose()

# $from = $movefrom
# $to = $moveto
# $amount = $moveamount