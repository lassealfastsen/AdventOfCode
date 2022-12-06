Function Move-Cargo {
    Param(
        [Parameter(Mandatory=$true)][int]$from,
        [Parameter(Mandatory=$true)][int]$to,
        [Parameter(Mandatory=$true)][int]$amount
    )

    $crates = $stacks[$from].Substring(($stacks[$from].Length-$amount),($amount))
    $stacks[$from] = $stacks[$from].Substring(0,$stacks[$from].Length-$amount)
    $stacks[$to] = "$($stacks[$to])$crates"

}

$stacks = @{}

$pth = '.\2022\Day 5\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$stacksparsed = $false
while (!$stacksparsed) {
    $read = $reader.ReadLine() # Read a line
    if ($read -eq '') { #If the line is empty the stacks are parsed
        $stacksparsed = $true
    }
    else {
        if ($read[1] -ne '1') { # Only if the line is not the stack descriptor line
            for ($i = 1; $i -lt $read.Length; $i+=4) {
                if ($read[$i] -ne ' ') {
                    #Got a crate here
                    $stacknum = [int][Math]::Ceiling($i/4)
                    $stacks[$stacknum]=[string]"$($read[$i])$($stacks[$stacknum])"
                } 
            }
        }
    }
}

while ( $null -ne ($read = $reader.ReadLine()))  {
    $readarr = $read.Split(' ')
    $moveamount = $readarr[1]
    $movefrom = $readarr[3]
    $moveto = $readarr[5]

    Move-Cargo -from $movefrom -to $moveto -amount $moveamount
}

foreach ($stack in $stacks.Keys | Sort-Object) {
    $cargo = $stacks[$stack]
    Write-Host $cargo.Substring(($cargo.Length-1),1) -NoNewline
}
Write-Host

$reader.Close()
$reader.Dispose()