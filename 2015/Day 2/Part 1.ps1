$pth = ".\2015\Day 2\input.txt"
$reader = New-Object System.IO.StreamReader($pth)

$sqfeet = 0
While (($ln = $reader.ReadLine()) -ne $null) {
    $measurements = [int[]]$ln.Split('x') | Sort-Object
    $sqfeet += (
        (2*$measurements[0]*$measurements[1]) +
        (2*$measurements[1]*$measurements[2]) +
        (2*$measurements[2]*$measurements[0]) +
        ($measurements[0] * $measurements[1])
    )
}

$sqfeet


$reader.Close()
$reader.Dispose()
