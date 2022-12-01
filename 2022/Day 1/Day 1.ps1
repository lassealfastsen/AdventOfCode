

class Elf {
    [int]$fruitNo
    [int]$totalCalories
}


$pth = '.\2022\Day 1\input.txt'




$reader = New-Object System.IO.StreamReader($pth)

$Elfs = [Elf[]]@()

$ELF = [Elf]::new()
while ( ($read = $reader.ReadLine()) -ne $null)  {
    if ($read -like '') {
        $Elfs += $ELF
        $ELF = [Elf]::new()
    } else {
        $ELF.fruitNo++
        $ELF.totalCalories += [int]$read
    }
}


$reader.Close()
$reader.Dispose()


#Part 1

$p1 =($ELFS | Sort-Object totalCalories -Descending | Select -First 1).totalCalories

Write-Host "The Elf carrying the most Calories has $p1 Calories"

#Part 2
$p2 = ($ELFS | Sort-Object totalCalories -Descending | Select -First 3 | Measure-Object -Property totalCalories -Sum).Sum
Write-Host "The 3 Elves carrying the most Calories has $p2 Calories in total"
