class vent {
    [int]$xstart
    [int]$xend
    [int]$ystart
    [int]$yend

    vent([string]$ventdescription) {
        $arr = $ventdescription.Split(' -> ')
        $arrstart = $arr[0].Split(',')
        $arrend = $arr[1].Split(',')

        $arrx = [int[]]@($arrstart[0], $arrend[0]) #| Sort-Object
        $arry = [int[]]@($arrstart[1], $arrend[1]) #| Sort-Object
        

        $this.xstart = $arrx[0]
        $this.xend = $arrx[1]
        $this.ystart = $arry[0]
        $this.yend = $arry[1]
    }
}

$grid = New-Object 'int[,]' 1000, 1000

$pth = ".\2021\Day 5\input.txt"
$reader = New-Object System.IO.StreamReader($pth)

$q = 1
while (($read = $reader.ReadLine())) {
    [vent]$vent = [Vent]::New($read)
    $q
    $q++

    if (($vent.xstart -eq $vent.xend)) {
        if ($vent.yend -gt $vent.ystart) {
            for ($i = $vent.ystart; $i -le $vent.yend; $i++) {
                $grid[$vent.xstart, $i]++
            }
        } else {
            for ($i = $vent.ystart; $i -ge $vent.yend; $i--) {
                $grid[$vent.xstart, $i]++
            }
        }
    } elseif ($vent.ystart -eq $vent.yend) {
        if ($vent.xend -gt $vent.xstart) {
            for ($i = $vent.xstart; $i -le $vent.xend; $i++) {
                $grid[$i, $vent.ystart]++
            }
        } else {
            for ($i = $vent.xstart; $i -ge $vent.xend; $i--) {
                $grid[$i, $vent.ystart]++
            } 
        }
    } else {
        $xdif = $vent.xend-$vent.xstart
        $ydif = $vent.yend-$vent.ystart

        if ($xdif -gt 0 -and $ydif -gt 0) {
            $y = $vent.ystart
            for ($x = $vent.xstart; $x -le $vent.xend; $x++) {
                $grid[$x, $y]++
                #"$x, $y"
                $y++
            }
            #UL->LR
        } elseif ($xdif -lt 0 -and $ydif -lt 0) {
            #LR->UL
            $y = $vent.ystart
            for ($x = $vent.xstart; $x -ge $vent.xend; $x--) {
                $grid[$x,$y]++
                $y--
            }
        } elseif ($xdif -gt 0 -and $ydif -lt 0) {
            #LL->UR
            $y=$vent.ystart
            for ($x = $vent.xstart; $x -le $vent.xend; $x++) {
                $grid[$x,$y]++
                $y--
            }
        } elseif ($xdif -lt 0 -and $ydif -gt 0) {
            #UR-LL
            $y = $vent.ystart
            for ($x = $vent.xstart; $x -ge $vent.xend; $x--) {
                $grid[$x,$y]++
                $y++
            }
        }
    }
}

$reader.Close()
$reader.Dispose()

$cnt = 0
for ($x = 0; $x -lt 1000; $x++) {
    for ($y = 0; $y -lt 1000; $y++) {
        if ($grid[$x,$y] -gt 1) {$cnt++}
    }
}
$cnt
#($grid | Where-Object {($_ -gt 1)}).count



#  for ($y = 0; $y -lt 10; $y++) {
#      for ($x = 0; $x -lt 10; $x++) {
#          Write-Host $grid[$x, $y] -NoNewline
#      }
#      Write-Host ""
#  }