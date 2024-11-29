function Check-Passphrase {
    param (
        [Parameter(Mandatory = $true)][String]$passphrase,
        [Parameter()][Switch]$allowAnagrams
    )
    
    $arr = $passphrase.Split(' ')

    if ($allowAnagrams) {
        $groups = $arr | Group-Object


        if (($null -eq ($groups | Where-Object { ($_.COunt -gt 1) }))) {
            return $true
        }
        else {
            return $false
        }
    }
    else {
        for ($i = 0; $i -lt $arr.Count; $i++) {
            [char[]]$val1 = $arr[$i].ToCharArray()
            [array]::Sort($val1)
            $s1 = [string]::new($val1)
            for ($j = 1; $j -lt $arr.Count; $j++) {
                [char[]]$val2 = $arr[(($i + $j) % $arr.Count)].ToCharArray()
                [array]::Sort($val2)
                $s2 = [string]::new($val2)

                if ($s1 -eq $s2) {
                    return $false
                }
            }            
        }
        return $true
    }    

}


$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2017\Day 4\input.txt')

#Part 1
$validPassphrases1 = @()
$validPassphrases2 = @()

while ($null -ne ($read = $reader.ReadLine())) {
    if (Check-Passphrase -passphrase $read -allowAnagrams) {
        $validPassphrases1 += $read
        #Write-Host $read -ForegroundColor Green
    }
    if (Check-Passphrase -passphrase $read) {
        $validPassphrases2 += $read
    }
    
}

$reader.Close()
$reader.Dispose()

Write-Host "Part 1 - valid phrases: " -NoNewline
Write-Host $validPassphrases1.Count -ForegroundColor Green
Write-Host "Part 2 - valid phrases: " -NoNewline
Write-Host $validPassphrases2.Count -ForegroundColor Green