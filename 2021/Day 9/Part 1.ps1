$inputContent = Get-Content -LiteralPath '.\2021\Day 9\input.txt'


$grid = New-Object 'int[,]' $inputContent.Count, $inputContent[0].Length


$y = 0
foreach ($row in $inputContent) {
    $row = $row.ToCharArray()
    for ($x = 0; $x -lt $row.Count; $x++) {
        $grid[$y, $x] = [int]::parse($row[$x])
    }
    $y++
}

Function Get-Neighbors {
    Param(
        [Parameter(Mandatory=$true)][int]$x,
        [Parameter(Mandatory=$true)][int]$y
    )

    $left = 99
    $right =99
    $up = 99
    $down = 99

    if ($x -gt 0) {
        $left = $grid[$y, ($x-1)]
    }
    if ($x -lt $grid.GetLength(1)) {
        $right = $grid[$y,($x+1)]
    }
    if ($y -gt 0) {
        $up = $grid[($y-1), $x]
    }
    if ($y -lt $grid.GetLength(0)) {
        $down = $grid[($y+1), $x]
    }

    return @($up, $down, $left, $right)
}


$lowestcount = 0

$risklevels = @()

for ($x = 0; $x -lt $grid.GetLength(1); $x++) {
    for ($y = 0; $y -le  $grid.GetLength(0); $y++) {
        if ($grid[$y,$x] -lt (Get-Neighbors -x $x -y $y | Sort | Select -First 1)) {
            " - $($grid[$y,$x])"
            $risklevels += $grid[$y,$x]
        }
    }
}

($risklevels | Measure-Object -Sum).sum + ($risklevels | Measure-Object).Count