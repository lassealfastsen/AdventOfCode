$pth = ".\2015\Day 3\input.txt"

$reader = New-Object System.IO.StreamReader($pth)


$arr = @()


$x = 0
$y = 0

$arr += [PSCustomObject]@{
    Pos = "$x,$y"
    Val = 1
}
#$arr[$x][$y]++
$i = 1
while (($read = $reader.Read()) -gt 0) {
    #[char]$read
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
    $i
    $i++
}

$reader.Close()
$reader.Dispose()
