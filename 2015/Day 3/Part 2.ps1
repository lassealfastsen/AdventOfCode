$pth = ".\2015\Day 3\input.txt"

$reader = New-Object System.IO.StreamReader($pth)


$arr = @()


$x = 0
$y = 0

$rx = 0
$ry = 0

$arr += [PSCustomObject]@{
    Pos = "$x,$y"
    Val = 1
}
#$arr[$x][$y]++
$rs = $false
$i = 1
while (($read = $reader.Read()) -gt 0) {
    #[char]$read

    if ($rs) {
        switch ([char]$read) {
            '^' { $ry-- }
            'v' { $ry++ }
            '>' { $rx++ }
            '<' { $rx-- }
        }

        if ($arr.Pos -contains "$rx,$ry") {
            ($arr | Where-Object {$_.Pos -eq "$rx,$ry"}).Val++
        } else {
            $arr += [PSCustomObject]@{
                Pos = "$rx,$ry"
                Val = 1
            }
        }
    } else {
        switch ([char]$read) {
            '^' { $y-- }
            'v' { $y++ }
            '>' { $x++ }
            '<' { $x-- }
        }
    
        if ($arr.Pos -contains "$x,$y") {
            ($arr | Where-Object {$_.Pos -eq "$x,$y"}).Val++
        } else {
            $arr += [PSCustomObject]@{
                Pos = "$x,$y"
                Val = 1
            }
        }
    }

    $rs = -not $rs
    
    $i
    $i++
}

$reader.Close()
$reader.Dispose()
