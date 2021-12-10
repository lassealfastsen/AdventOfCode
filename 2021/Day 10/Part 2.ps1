
Function Check-Line {
    Param(
        [Parameter(Mandatory=$true, Position=1)][String]$Line
    )
    $stack = ""
    $validMap = @{
        ')'='('
        ']'='['
        '}'='{'
        '>'='<'
    }

    $valid = $true
    $stack = ""
    :loop foreach ($char  in $line.ToCharArray()) {
        if ($char -in @('(', '[', '{', '<')) {$stack = "$($stack)$char"}
        else {
            #$stack.Substring($stack.Length-1)
            #$validMap["$char"]
            if ($stack.Substring($stack.Length-1) -ne $validMap["$char"]) {
                $valid = $false
                break :loop
            } else {
                $stack = $stack.Substring(0, $stack.Length-1)
            }
        }
    }

    return $valid
}

Function Get-LineEnding {
    Param(
        [Parameter(Mandatory=$true, Position=1)][String]$Line
    )

    $Map = @{
        '('=')'
        '['=']'
        '{'='}'
        '<'='>'
    }

    $stack = @()
    foreach ($char in $Line.ToCharArray()) {
        if ($char -in @('(', '[', '{', '<')) {
            $stack += $char
        } else {
            $stack = $stack[0..($stack.Length-2)]
        }
    }

    $Ending = ""
    for ($i = $stack.count-1; $i -ge 0; $i--) {
        $Ending = "$Ending$($Map["$($stack[$i])"])"
    }

    Return $Ending
}


$pth = '.\2021\day 10\input.txt'
$reader = New-Object System.IO.StreamReader($pth)
$scores = @()
while ($read = $reader.ReadLine()) {
    if (Check-Line $read) {
        $ending = Get-LineEnding $read
        $score = 0
        foreach ($char in $ending.ToCharArray()) {
            $score = $score*5
            switch ($char) {
                ')' { $score += 1}
                ']' { $score += 2}
                '}' { $score += 3}
                '>' { $score += 4}
            }
        }
        $scores += $score
    }
}
$reader.Close()
$reader.Dispose()

$scores = $scores | Sort-Object
$scores[([Math]::Round($scores.Count/2)-1)]

