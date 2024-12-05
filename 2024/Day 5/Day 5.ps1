$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2024\Day 5\input.txt')

$rules = @()

$printQueue = @()

$rulesprocessed = $false
while ($null -ne ($read = $reader.ReadLine())) {
    if ($read -like "") {
        $rulesprocessed = $true
        continue
    }

    if (-not $rulesprocessed) {
        $rule = [PSCustomObject]@{
            first = [int]::Parse($read.Split('|')[0])
            last  = [int]::Parse($read.Split('|')[1])
        }
        $rules += $rule
    }
    else {
        $printQueue += $read
    }
}

$reader.Close()
$reader.Dispose()


Function Check-PrintOrder {
    Param(
        [Parameter()][string]$print
    )

    $pages = $print.Split(',')

    for ($i = 0; $i -lt $pages.Count; $i++) {
        if ($rules.first -contains $pages[$i]) {
            for ($j = $i - 1; $j -ge 0; $j--) {
                #Check all pages before are not in conflicting rules
                if (($rules | Where-Object { $_.first -eq $pages[$i] }).last -contains $pages[$j]) {

                    return $false
                }
            }
        }
        elseif ($rules.last -contains $pages[$i]) {
            #Check all pages after are not in conflicting rules
            for ($j = $i + 1; $j -lt $pages.Count; $j++) {
                if (($rules | Where-Object { $_.last -eq $pages[$i] }).first -contains $pages[$j]) {
                    return $false
                }
            }
        }
    }

    return $true

}


Function Fix-PrintOrder {
    Param(
        [Parameter()][string]$print
    )

    $pages = $print.Split(',')

    $history = @()

    $q = ""

    :check while (-not (Check-PrintOrder -print $print)) {
        #Write-Host  $print
        if ($history -contains $q) {
            Write-Host $print -foregroundColor Red
        }
        else {
            #Write-Host $print -foregroundColor Green
        }
        for ($i = 0; $i -lt $pages.Count; $i++) {
            if ($rules.first -contains $pages[$i]) {
                for ($j = $i - 1; $j -ge 0; $j--) {
                    #Check all pages before are not in conflicting rules
                    if (($rules | Where-Object { $_.first -eq $pages[$i] }).last -contains $pages[$j]) {

                        #Move Value Left 1
                        if ($i -eq 1) {
                            $before = $()
                        }
                        else {
                            $before = $pages[0..($i - 2)]                        
                        }
                        
                        $after = [int[]]$pages[$i] + $pages[$i - 1] + $pages[($i + 1)..$pages.Length]
                        $pages = [int[]]$before + [int[]]$after
                        $print = $pages -join ','
                        $history += $print
                        #continue check
                    }
                }
            }
            elseif ($rules.last -contains $pages[$i]) {
                #Check all pages after are not in conflicting rules
                for ($j = $i + 1; $j -lt $pages.Count; $j++) {
                    if (($rules | Where-Object { $_.last -eq $pages[$i] }).first -contains $pages[$j]) {
                        #Move Value Right 1
                        $before = $pages[0..($i - 1)] + $pages[$i + 1]
                        $after = [int[]]$pages[$i] + $pages[($i + 2)..$pages.Length]
                        $pages = $before + $after
                        $print = $pages -join ','
                        $history += $print
                        #continue check
                    }
                }
            }
        }
    }

    return $pages

}




$invalidmiddles = 0
$middles = 0
$a = 0
foreach ($print in $printQueue) {
    if (Check-PrintOrder -print $print) {
        $arr = $print.Split(',')
        $middles += $arr[(($arr.Count - 1) / 2)]
    }
    else {
        $arr = Fix-PrintOrder -print $print
        $invalidmiddles += $arr[(($arr.Count - 1) / 2)]
    }
    $a
    $a++
}

$middles
$invalidmiddles
