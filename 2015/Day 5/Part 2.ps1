$naughty = @()
$nice = @()

Function Check-NiceString{
    Param(
        [Parameter(Mandatory=$true, Position=1)]$str
    )

    return (
        ($str -match "(.)(.).*\1\2") `
        -and ($str -notmatch "(.)\1\1") `
        -and ($str -match "(.).\1")   
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