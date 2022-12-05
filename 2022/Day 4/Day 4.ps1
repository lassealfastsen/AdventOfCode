$pth = '.\2022\Day 4\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$fullyContained = 0
$overlapping = 0

while ( ($read = $reader.ReadLine()) -ne $null)  {

    $elf1 = ($read.Split(',')[0]).Split('-')
    #$elf1 = $elf1.Split('-')
    $elf1 = $elf1[0]..$elf1[1]


    $elf2 = ($read.Split(',')[1]).Split('-')
    #$elf2 = $elf2.Split('-')
    $elf2 = $elf2[0]..$elf2[1]
    
    $overlap = Compare-Object -ReferenceObject $elf1 -DifferenceObject $elf2 -IncludeEqual -ExcludeDifferent

    if ($null -ne $overlap) {
        $overlapping++
        #$overlap.Count
        #$elf2.
        $cnt = ($overlap | Measure-Object).Count
        if (($cnt -eq $elf1.count)) {
            $fullyContained++
        } elseif ($cnt -eq $elf2.Count) {
            $fullyContained++
        }
    }
}

Write-Host "$fullyContained Fully Contained - $overlapping Overlapping"

$reader.Close()
$reader.Dispose()