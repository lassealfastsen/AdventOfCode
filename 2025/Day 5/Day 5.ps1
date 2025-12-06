$list = Get-Content "C:\git\AdventOfCode\2025\Day 5\input.txt" -Raw




$freshIngredientRanges = ($list.Split("$([System.Environment]::NewLine)$([System.Environment]::NewLine)")[0]).Split("$([System.Environment]::NewLine)") | Where-Object { $_ -ne '' }

$ingredients = ($list.Split("$([System.Environment]::NewLine)$([System.Environment]::NewLine)")[1]).Split("$([System.Environment]::NewLine)") | Where-Object { $_ -ne '' }

$spoiledIngredients = 0
$freshIngredients = 0


foreach ($ingredient in $ingredients) {
    $spoiled = $true
    foreach ($range in $freshIngredientRanges) {
        $min = [bigint]$range.Split('-')[0]
        $max = [bigint]$range.Split('-')[1]

        if ([bigint]$ingredient -ge $min -and [bigint]$ingredient -le $max) {
            $spoiled = $false
            break
        }
    }
    if ($spoiled) {
        Write-Host "Spoiled ingredient found: $ingredient" -ForegroundColor Red
        $spoiledIngredients++
    }
    else {
        $freshingredients++
    }
}

Write-Host "Fresh ingredients: $freshIngredients" -ForegroundColor Green
Write-Host "Spoiled ingredients: $spoiledIngredients" -ForegroundColor Red


$mergedIngredientIntervals = @()
$freshIngredientRanges = $freshIngredientRanges | Sort-Object {
    [bigint]$_.Split('-')[0]
}
foreach ($range in $freshIngredientRanges) {
    $min = [bigint]$range.Split('-')[0]
    $max = [bigint]$range.Split('-')[1]

    $merged = $false
    for ($i = 0; $i -lt $mergedIngredientIntervals.Count; $i++) {
        $currentRange = $mergedIngredientIntervals[$i]
        if (!($max -lt $currentRange.Min - 1 -or $min -gt $currentRange.Max + 1)) {
            # Ranges overlap or are adjacent, merge them
            $newMin = [bigint]::Min($currentRange.Min, $min)
            $newMax = [bigint]::Max($currentRange.Max, $max)
            $mergedIngredientIntervals[$i] = [PSCustomObject]@{ Min = $newMin; Max = $newMax }
            $merged = $true
            break
        }
    }
    if (-not $merged) {
        $mergedIngredientIntervals += [PSCustomObject]@{ Min = $min; Max = $max }
    }
}

$totalFreshIngredients = 0
foreach ($interval in $mergedIngredientIntervals) {
    $totalFreshIngredients += ($interval.Max - $interval.Min + 1)
}




Write-Host "Total Fresh ingredient IDs: $totalFreshIngredients" -ForegroundColor Green