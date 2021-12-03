$gamma = ("000010111101").ToCharArray()
$epsilon = ("111101000010").ToCharArray()

$pth = ".\2021\Day 3\input.txt"




$O2 = $MyArrayList = [System.Collections.ArrayList]@()

$reader = New-Object System.IO.StreamReader($pth)

while ( $read = $reader.ReadLine()) {
    [void]$O2.Add($read.ToCharArray())
}

$CO2 = $O2


for ($i = 0; $i -lt $O2[0].Count; $i++) {

    $count = 0
    for ($ii = 0; $ii -lt $o2.Count; $ii++) {
        if ($o2[$ii][$i] -eq '1') {$count++}
    }

    if ($count -ge $O2.Count/2) {
        $O2 = $O2 | Where-Object{($_[$i] -eq '1')}    
    } else {
        $O2 = $O2 | Where-Object{($_[$i] -eq '0')}   
    }
}

for ($i = 0; $i -lt $CO2[0].Count-1; $i++) {

    $count = 0
    for ($ii = 0; $ii -lt $CO2.Count; $ii++) {
        if ($CO2[$ii][$i] -eq '1') {$count++}
    }

    if ($count -lt $CO2.Count/2) {
        $CO2 = $CO2 | Where-Object{($_[$i] -eq '1')}    
    } else {
        $CO2 = $CO2 | Where-Object{($_[$i] -eq '0')}   
    }
}


Write ([Convert]::ToInt32(($O2 -join ''),2) * [Convert]::ToInt32(($CO2 -join ''),2))

$reader.Close()
$reader.Dispose()