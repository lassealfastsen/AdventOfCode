$pth = '.\2022\Day 3\input.txt'

$reader = New-Object System.IO.StreamReader($pth)


$priorities = @{
    'a'=1
    'b'=2
    'c'=3
    'd'=4
    'e'=5
    'f'=6
    'g'=7
    'h'=8
    'i'=9
    'j'=10
    'k'=11
    'l'=12
    'm'=13
    'n'=14
    'o'=15
    'p'=16
    'q'=17
    'r'=18
    's'=19
    't'=20
    'u'=21
    'v'=22
    'w'=23
    'x'=24
    'y'=25
    'z'=26
}

$result = 0


while ( ($read = $reader.ReadLine()) -ne $null)  {

    $common = ''

    $a = $read.Substring(0, ($read.Length/2))
    $b = $read.Substring(($read.Length/2), ($read.Length/2))

    $pos = 0
    while ($common -eq '') {
        if ($b -clike "*$($a[$pos])*") {
            $common = $a[$pos]
        }
        $pos+=1
    }
    
    $priority = $priorities[[string]$common]
    if ($common -cmatch "[A-Z]") {
        $priority += 26
    }

    $result += $priority

    #Write-Host "$common - $priority"
}


$result

$reader.Close()
$reader.Dispose()