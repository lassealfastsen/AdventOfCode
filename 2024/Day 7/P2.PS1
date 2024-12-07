# prog202407.ps1
# file created 2024-Dec-07 07:08
# https://adventofcode.com/2024/day/07

function Get-Data {
    param($datafile)
    <#
    .SYNOPSIS
    Read input into [target, [numbers]]
    #>
    $lines = Get-Content $datafile

    $data = @()
    foreach ($line in $lines) {
        $parts = $line -split ':'
        $target = [bigint]$parts[0].Trim()
        $nums = $parts[1].Trim() -split '\s+' | ForEach-Object { [bigint]$_ }
        $data += , @($target, $nums)
    }
    return $data
}

function Combine {
    param($num1, $num2)
    <#
    .SYNOPSIS
    Combine the digits of num1 and num2
    #>
    return [bigint]("$num1$num2")
}

function Test-CanUncombine {
    param($num1, $num2)
    <#
    .SYNOPSIS
    Return true if num1 ends with num2
    Example: (156, 6) can be uncombined to 15
    #>
    if ($num1 -eq $num2 -or $num1 -eq - $num2) {
        return $false
    }
    return ("$num1").EndsWith("$num2")
}

function Uncombine {
    param($num1, $num2)
    <#
    .SYNOPSIS
    If str(num1) ends with str(num2), return num1 with that part removed
    #>
    if (-not (Test-CanUncombine $num1 $num2)) {
        throw "Cannot uncombine $num1 and $num2"
    }
    return [bigint]("$num1".Substring(0, "$num1".Length - "$num2".Length))
}

function Get-Ways2Reach {
    param($target, $numbers, $pt2 = $false)
    <#
    .SYNOPSIS
    Count the number of ways for these numbers to reach the target
    For part 2, set pt2=$true to include the '||' operator
    #>
    $nums = $numbers.Clone()
    $x = $nums[-1]
    $nums = $nums[0..($nums.Length - 2)]
    $count = 0

    if ($nums.Length -eq 1) {
        if ($nums[0] * $x -eq $target) { $count++ }
        if ($nums[0] + $x -eq $target) { $count++ }
        if ($pt2 -and (Combine $nums[0] $x) -eq $target) { $count++ }
        return $count
    }

    if ($target % $x -eq 0) {
        $count += Get-Ways2Reach ($target / $x) $nums $pt2
    }
    if ($pt2 -and (Test-CanUncombine $target $x)) {
        $count += Get-Ways2Reach (Uncombine $target $x) $nums $pt2
    }
    $count += Get-Ways2Reach ($target - $x) $nums $pt2
    return $count
}

$data = Get-Data "C:\git\AdventOfCode\2024\Day 7\input.txt"
#Write-Host "Part 1: $(Solve-Part1 $data)"
$p1 = 0
(($data | Where-Object { ((Get-Ways2Reach $_[0] $_[1]) -gt 0) } )) | % {
    $p1 += $_[0]
}

$p2 = 0
(($data | Where-Object { ((Get-Ways2Reach $_[0] $_[1] $true) -gt 0) } )) | % {
    $p2 += $_[0]
}

$p1
$p2
