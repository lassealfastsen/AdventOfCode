$naughty = @()
$nice = @()

Function Check-NiceString{
    Param(
        [Parameter(Mandatory=$true, Position=1)]$str
    )

    return (
        ($str -match ".*[aeiou].*[aeiou].*[aeiou].*") `
        -and ($str -match "(.)\1") `
        -and ($str -notmatch "ab|cd|pq|xy")   
    )
}

$pth = ".\2015\Day 5\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

while ($read = $reader.ReadLine()) {
    if (Check-NiceString $read){
        $nice += $read
    } else {
        $naughty += $read
    }
}

$reader.Close()
$reader.Dispose()


$nice.count