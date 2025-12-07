
#$reader = New-Object System.IO.StreamReader("C:\Temp\GIT\AdventOfCode\2018\Day 2\sample.txt")
$reader = New-Object System.IO.StreamReader("C:\git\AdventOfCode\2018\Day 2\part1.txt")


$strings = @()


while ( ($read = $reader.ReadLine()) -ne $null) {
    $strings += $read
}


$reader.Close()
$reader.Dispose()

$matchfound = $false
for ($i = 0; $i -lt $strings.Count; $i++) {
    for ($j = $i + 1; $j -lt $strings.Count; $j++) {
        $str1 = $strings[$i].ToCharArray()
        $str2 = $strings[$j].ToCharArray()
        $diffs = 0
        $commonChars = ""
        for ($k = 0; $k -lt $str1.Count; $k++) {
            if ($str1[$k] -ne $str2[$k]) {
                $diffs++
            }
            else {
                $commonChars += $str1[$k]
            }
            if ($diffs -gt 1) { break }
        }
        if ($diffs -eq 1) {
            Write-Host "Match found between '$($strings[$i])' and '$($strings[$j])'"
            Write-Host "Common characters: $commonChars"
            $matchfound = $true
            break
        }
    }
    if ($matchfound) { break }
}

