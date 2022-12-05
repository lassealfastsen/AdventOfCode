$pth = '.\2019\Day 2\input.txt'

$Global:init = [int[]](Get-Content $pth).Split(',')


Function Calculate {
    Param(
        [Parameter(Mandatory=$true, Position=1)][int]$noun,
        [Parameter(Mandatory=$true, Position=2)][int]$verb
    )

    $program = [int[]](Get-Content '.\2019\Day 2\input.txt').Split(',')
    $program[1] = $noun
    $program[2] = $verb

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

    return $program[0]
}


$boundmin = 0
$boundmax = 99

$verb = $boundmin-1
$noun = $boundmin

$result = 0
$expected = 19690720
#$expected = 5098658 #12 + 2
while ($result -ne $expected) {
    $verb++
    if ($verb -gt $boundmax) {
        $noun++
        $verb = $boundmin
    }
    $result = Calculate $noun $verb
}


$noun
$verb
(100 * $noun + $verb)


