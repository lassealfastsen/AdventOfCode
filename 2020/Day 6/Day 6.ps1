$answers = Get-Content '.\2020\Day 6\input.txt' -Raw | Out-String

$groups = $answers.split( "`r`n`r`n")


#Part 1
$Counts = @()

foreach ($group in $groups) {
    $counts += (($group.Replace("`r", '').Replace("`n",'')).ToCharArray() | Select-Object -Unique).Count
}

$sum = 0
foreach ($count in $Counts) {
    $sum+=$count
}

Write-Host $sum





#Part 2

$Counts = @()

foreach ($group in $groups) {
    $count = 0
    $people = $group.Split("`n") | Where-Object {($_ -notlike "")}
    #if ($people.Count -eq 1) 
    #$distinctCharacters = [char]@()

    foreach ($char in (($group.Replace("`r", '').Replace("`n",'')).ToCharArray() | Select-Object -Unique)) {
        if ($char -eq "`r") {
            break
        }
        $isTrueForAll = $true
        foreach ($person in $people) {
            if ($person.ToCharArray() -notcontains $char) {
                $isTrueForAll = $false
                break
            }
        }
        if ($isTrueForAll) { $count++ }

    }

    $Counts += $count
}

$sum = 0
foreach ($count in $Counts) {
    $sum+=$count
}

Write-Host $sum