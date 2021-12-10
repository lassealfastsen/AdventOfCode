$signals = Get-Content '.\2021\Day 8\input.txt'

$answer = 0


foreach ($signal in $signals) {
    


    $in = $signal.Split(' | ')[0].Split(' ')
    $out = $signal.Split(' | ')[1].Split(' ')

    
    $list = @{
        "0" = [char[]]@()
        "1" = ($in | Where-Object {($_.Length -eq 2)}).ToCharArray()
        "2" = [char[]]@()
        "3" = [char[]]@()
        "4" = ($in | Where-Object {($_.Length -eq 4)}).ToCharArray()
        "5" = [char[]]@()
        "6" = [char[]]@()
        "7" = ($in | Where-Object {($_.Length -eq 3)}).ToCharArray()
        "8" = ($in | Where-Object {($_.Length -eq 7)}).ToCharArray()
        "9" = [char[]]@()
    }

    $in = $in | Where-Object {($_.Length -eq 5) -or ($_.Length -eq 6)}


    #Find 9
    $list["9"] = ($in | Where-Object {($_.Length -eq 6) -and ((Compare-Object -ReferenceObject $list["4"] -DifferenceObject $_.ToCharArray()).Count -eq 2)}).ToCharArray()
    #Remove the "9" from the input
    $in = $in | Where-Object {($_ -ne ($list["9"] -join ''))}

    #Find 0
    $list["0"] = ($in | Where-Object {($_.Length -eq 6) -and ((Compare-Object -ReferenceObject $list["1"] -DifferenceObject ($_).ToCharArray()).Count -eq 4)}).ToCharArray()
    $in = $in | Where-Object {($_ -ne ($list["0"] -join ''))}

    #Find 6
    $list["6"] = ($in | Where-Object {($_.Length -eq 6)}).ToCharArray()
    $in = $in | Where-Object {($_ -ne ($list["6"] -join ''))}

    #Find 3
    $list["3"] = ($in | Where-Object {((Compare-Object -ReferenceObject $list["7"] -DifferenceObject ($_).ToCharArray()).Count -eq 2)}).ToCharArray()
    $in = $in | Where-Object {($_ -ne ($list["3"] -join ''))}


    $list["2"] = ($in | Where-Object {((Compare-Object -ReferenceObject $list["4"] -DifferenceObject ($_).ToCharArray() -ExcludeDifferent).Count -eq 2)}).ToCharArray()
    $list["5"] = ($in | Where-Object {((Compare-Object -ReferenceObject $list["4"] -DifferenceObject ($_).ToCharArray() -ExcludeDifferent).Count -eq 3)}).ToCharArray()



    #Format in a workable array
    $arr = @()
    for ($i = 0; $i -le 9; $i++) {
        $arr += [PSCustomObject]@{
            num = $i
            Chars = $list["$i"] | Sort-Object
        }
    }

    $v = ""

    foreach ($num in $out) {
        $num = (($num.ToCharArray() | Sort-Object) -join '')
        $v = "$($v)$(($arr | Where-Object {($_.Chars -join '') -eq $num}).num)"
    }

    $answer += [int]$v

}


$answer