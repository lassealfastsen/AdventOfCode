$pth = '.\2019\Day 2\input.txt'

$program = [int[]](Get-Content $pth).Split(',')

$stepsize = 4

$pos = 0

while ($program[$pos] -ne 99) {
    switch ($program[$pos]) {
        1 {
            $val = $program[$program[$pos+1]] + $program[$program[$pos+2]]
        }
        2 {  
            $val = $program[$program[$pos+1]] * $program[$program[$pos+2]]
        }
        Default {Write-Host "An Error Occurred"}
    }

    $program[$program[$pos+3]] = $val
    $pos += $stepsize
}

$program[0]