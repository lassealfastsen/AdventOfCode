class vent {
    [int]$xstart
    [int]$xend
    [int]$ystart
    [int]$yend

    vent([string]$ventdescription) {
        $arr = $ventdescription.Split(' -> ')
        $arrstart = $arr[0].Split(',')
        $arrend = $arr[1].Split(',')

        $arrx = [int[]]@($arrstart[0], $arrend[0]) | Sort-Object
        $arry = [int[]]@($arrstart[1], $arrend[1]) | Sort-Object
        

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
        for ($i = $vent.ystart; $i -le $vent.yend; $i++) {
            $grid[$vent.xstart, $i]++
        }
    } elseif ($vent.ystart -eq $vent.yend) {
        for ($i = $vent.xstart; $i -le $vent.xend; $i++) {
            $grid[$i, $vent.ystart]++
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

