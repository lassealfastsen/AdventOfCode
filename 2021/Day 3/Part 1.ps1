

$pth = ".\2021\Day 3\input.txt"




$report = $MyArrayList = [System.Collections.ArrayList]@()


$reader = New-Object System.IO.StreamReader($pth)

while ( $read = $reader.ReadLine()) {
    [void]$report.Add($read.ToCharArray())
}

$gamma = ""
$epsilon = ""

$current = 0

while ($current -lt $report[0].Length) {
    $count = 0
    for ($i = 0; $i -lt $report.Count; $i++) {
        if ($report[$i][$current] -eq '1') { $count++ }
    }
    if ($count -gt ($report.COunt/2)) {
        $gamma = "$($gamma)1"
        $epsilon = "$($epsilon)0"
    } else {
        $gamma = "$($gamma)0"
        $epsilon = "$($epsilon)1"
    }

    $current++
}

Write ([Convert]::ToInt32($gamma,2) * [Convert]::ToInt32($epsilon,2))

$reader.Close()
$reader.Dispose()
