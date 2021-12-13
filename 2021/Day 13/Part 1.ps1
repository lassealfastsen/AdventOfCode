$pth = 'C:\Users\lal\OneDrive - Lyngsoe Systems\Documents\github\AdventOfCode\AdventOfCode\2021\Day 13\input.txt'

$reader = New-Object System.IO.StreamReader($pth)


$dots = @()

$dots = New-Object 'Collections.Generic.List[psobject]'
$instructions = @()
$dotsfound = $false


Function Fold-Horizontal ([int]$position) {
    $move = $dots | Where-Object {$_.y -gt $position}
    $dots = $dots | Where-Object {$_.y -lt $position}

    foreach ($dot in $move) {
        $dot.y = $position-($dot.y-$position)
        $dot.str = "$($dot.x),$($dot.y)"
        $dotstr = "$($dot.x),$($dot.y)"
        if ($dotstr -notin $dots.str) {
            $dots += $dot
        }
    }
}

Function Fold-Vertical ([int]$position) {
    $move = $dots | Where-Object {$_.x -gt $position}
    $dots = $dots | Where-Object {$_.x -lt $position}

    foreach ($dot in $move) {
        $dot.x = $position-($dot.x-$position)
        $dot.str = "$($dot.x),$($dot.y)"
        $dotstr = "$($dot.x),$($dot.y)"
        if ($dotstr -notin $dots.str) {
            $dots += $dot
        }
    }
}





while ( ($read = $reader.ReadLine()) -ne $null) {
    if ($read -like '') {
        $dotsfound = $true
    } elseif ($dotsfound) {
        $instructions += $read
    } else {
        $dots.Add([PSCustomObject]@{
            x = [int]$read.Split(',')[0]
            y = [int]$read.Split(',')[1]
            str = $read
        })
    }
}

$reader.Close()
$reader.Dispose()


$instruction = $instructions[0].Replace('fold along ','')
switch ($instruction.Split('=')[0]) {
    'y' { Fold-Horizontal -position $instruction.Split('=')[1]}
    'x' { Fold-Vertical -position $instruction.Split('=')[1]}
}


($dots.str | Select -Unique).count

<#

#Create grid

$Global:paper = New-Object 'char[,]' (($dots.y | Sort | Select -last 1)+1), (($dots.x | Sort | Select -last 1)+1)

for ($y = 0; $y -lt $Global:paper.GetLength(0); $y++) {
    #$y
    for ($x = 0; $x -lt $Global:paper.GetLength(1); $x++) {
        $Global:paper[$y,$x] = '.'
    }
}

foreach ($dot in $dots) {
    $Global:paper[$dot.y,$dot.x]='#'
}

#Writeout



Function Fold-Paper {
    Param(
        [Parameter(Mandatory=$true)][Validateset("Horizontal", "Vertical")][String]$direction,
        [Parameter(Mandatory=$true,Position=2)][int]$position
    )

    $Global:paperLines = $Global:paper.GetLength(0)
    $Global:paperColumns = $Global:paper.GetLength(1)
    switch ($direction) {
        "Horizontal" {
            if ((($Global:paper.GetLength(0)-1) / 2) -eq $position) {
                #Fold in half
                for ($y = 0; $y -lt $position; $y++) {
                    $opposite = (($Global:paperLines-1) - $y)

                    for ($x = 0; $x -lt $Global:paperColumns; $x++) {
                        if ($Global:paper[$opposite,$x] -eq '#') {
                            $Global:paper[$y,$x]='#'
                        }
                    }
                }
            }

            #Remove from pos and down
            $newlinecount = (($Global:paperLines-1)-$position)

            $newpaper = New-Object 'char[,]' $newlinecount, $Global:paperColumns
            for ($y = 0; $y -lt $newpaper.GetLength(0); $y++) {
                for ($x = 0; $x -lt $Global:paperColumns; $x++) {
                    $newpaper[$y,$x] = $Global:paper[$y,$x]
                }
            }
        }
        "Vertical" {
            if ((($Global:paper.GetLength(1)-1) / 2) -eq $position) {
                #Fold in half
                for ($x = 0; $x -lt $position; $x++) {
                    $opposite = (($Global:papercolumns-1) - $x)

                    for ($y = 0; $y -lt $Global:paperLines-1; $y++) {
                        if ($Global:paper[$y,$opposite] -eq '#') {
                            $Global:paper[$y,$x]='#'
                        }
                    }
                }
            }

            $newcolumncount = (($Global:papercolumns-1)-$position)

            $newpaper = New-Object 'char[,]' $Global:paperLines, $newcolumncount
            for ($y = 0; $y -lt $newcolumncount; $y++) {
                for ($x = 0; $x -lt $newpaper.GetLength(1); $x++) {
                    $newpaper[$y,$x] = $Global:paper[$y,$x]
                }
            }

        }
    }


    $Global:paper = $newpaper
}


$giantstr = ""
for ($y = 0; $y -lt $Global:paper.GetLength(0); $y++) {
    for ($x = 0; $x -lt $Global:paper.GetLength(1); $x++) {
        $giantstr += $Global:paper[$y,$x]
    }
    $giantstr += "`r`n"
}

$instruction = [string[]]$instructions[0]

#foreach ($instruction in $instructions) {
    $instruction = $instruction.Replace('fold along ','')
    switch ($instruction.Split('=')[0]) {
        'y' { Fold-Paper -direction Horizontal -position $instruction.Split('=')[1]}
        'x' { Fold-Paper -direction Vertical -position $instruction.Split('=')[1]}
    }
#}



($Global:paper | Where-Object {($_ -eq '#')} | Measure-Object).Count


#>