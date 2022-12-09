
$pth = '.\2022\Day 8\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$ymax = -1
$xmax = 0

$trees = @{}


while ($null -ne ($read = $reader.ReadLine())) {
    $ymax++
    if ($read.Length -gt $xmax) { $xmax = $read.Length - 1 }
    for ($i = 0; $i -lt $read.Length; $i++) {
        $trees["$i-$ymax"] = [PSCustomObject]@{
            Height    = [int]"$($read[$i])"
            N_Visible = $false
            S_Visible = $false
            E_Visible = $false
            W_Visible = $false
            Visible   = $false
        }
    }
    
}

$reader.Close()
$reader.Dispose()


#Process Tree Visibility



for ($y = 0; $y -le $ymax; $y++) {
    for ($x = 0; $x -le $xmax; $x++) {
        #VisiblefromW
        if ($x -eq 0) {
            $trees["$x-$y"].W_Visible = $true
            $trees["$x-$y"].Visible = $true
        } elseif ($x -eq $xmax) {
            $trees["$x-$y"].E_Visible = $true
            $trees["$x-$y"].Visible = $true
        } elseif ($y -eq 0) {
            $trees["$x-$y"].N_Visible = $true
            $trees["$x-$y"].Visible = $true
        } elseif ($y -eq $ymax) {
            $trees["$x-$y"].S_Visible = $true
            $trees["$x-$y"].Visible = $true
        } else {
            while ( -not $trees["$x-$y"].Visible) {
                #Go Left (Visible from West)
                for ($i = $x - 1; $i -ge 0; $i--) { 
                    #$highestfromeast = $false
                    # If the tree on the left is visible and lower than this one, this must also be visible
                    if (($trees["$i-$y"].W_Visible) -and ($trees["$i-$y"].Height -lt $trees["$x-$y"].Height)) {
                        $trees["$x-$y"].W_Visible = $true
                        $trees["$x-$y"].Visible = $true
                        Break
                    } elseif ($trees["$i-$y"].Height -ge $trees["$x-$y"].Height) {
                        #Not visible breakt the while loop
                        break
                    }
                    if ($i -eq 0) {
                        $trees["$x-$y"].W_Visible = $true
                        $trees["$x-$y"].Visible = $true
                    }
                }


                #Go right (Visible from East)
                for ($i = $x + 1; $i -le $xmax; $i++) { 
                    #$highestfromeast = $false
                    # If the tree on the left is visible and lower than this one, this must also be visible
                    if (($trees["$i-$y"].E_Visible) -and ($trees["$i-$y"].Height -lt $trees["$x-$y"].Height)) {
                        $trees["$x-$y"].E_Visible = $true
                        $trees["$x-$y"].Visible = $true
                        Break
                    } elseif ($trees["$i-$y"].Height -ge $trees["$x-$y"].Height) {
                        #Not visible breakt the while loop
                        break
                    }
                    if ($i -eq $xmax) {
                        $trees["$x-$y"].E_Visible = $true
                        $trees["$x-$y"].Visible = $true
                    }
                }

                #Go up (Visible from North)
                for ($i = $y - 1; $i -ge 0; $i--) { 
                    #$highestfromeast = $false
                    # If the tree on the left is visible and lower than this one, this must also be visible
                    if (($trees["$x-$i"].N_Visible) -and ($trees["$x-$i"].Height -lt $trees["$x-$y"].Height)) {
                        $trees["$x-$y"].N_Visible = $true
                        $trees["$x-$y"].Visible = $true
                        Break
                    } elseif ($trees["$x-$i"].Height -ge $trees["$x-$y"].Height) {
                        #Not visible breakt the while loop
                        break
                    }
                    if ($i -eq 0) {
                        $trees["$x-$y"].N_Visible = $true
                        $trees["$x-$y"].Visible = $true
                    }
                }

                #Go down (Visible from South)
                for ($i = $y + 1; $i -le $ymax; $i++) { 
                    #$highestfromeast = $false
                    # If the tree on the left is visible and lower than this one, this must also be visible
                    if (($trees["$x-$i"].S_Visible) -and ($trees["$x-$i"].Height -lt $trees["$x-$y"].Height)) {
                        $trees["$x-$y"].S_Visible = $true
                        $trees["$x-$y"].Visible = $true
                        Break
                    } elseif ($trees["$x-$i"].Height -ge $trees["$x-$y"].Height) {
                        #Not visible breakt the while loop
                        break
                    }
                    if ($i -eq $ymax) {
                        $trees["$x-$y"].S_Visible = $true
                        $trees["$x-$y"].Visible = $true
                    }
                }


                break #break to avoid infinite loops
            }
        }
    }
}

#($trees.Values.Visible | Where-Object { ($_ -eq $true) }).Count
($trees.Values | Where-Object { $_.Visible -eq $true }).Count # Where-Object { ($_.Visible) } | Measure-Object