$pth = ".\2015\Day 2\input.txt"
$reader = New-Object System.IO.StreamReader($pth)

$ribbon = 0
While (($ln = $reader.ReadLine()) -ne $null) {
    $measurements = [int[]]$ln.Split('x') | Sort-Object
    $ribbon += (
        (2*$measurements[0]) +
        (2*$measurements[1]) +
        ($measurements[0]*$measurements[1]*$measurements[2])
    )
}

$ribbon


$reader.Close()
$reader.Dispose()
