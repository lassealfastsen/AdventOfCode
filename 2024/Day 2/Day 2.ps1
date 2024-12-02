$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2024\Day 2\input.txt')

$reports = [System.Collections.ArrayList]::new()


while ($null -ne ($read = $reader.ReadLine())) {
    $nums = [int[]]([Regex]::Matches($read, '[0-9]+').Value)

    $reports.Add($nums) | Out-Null
}

$reader.Close()
$reader.Dispose()


Function Check-ReportValidity {
    Param(
        [Parameter()][int[]]$report
    )

    $ops = ""

    for ($i = 0; $i -lt $report.Count - 1; $i++) {
        if ([math]::Abs($report[$i] - $report[$i + 1]) -notin @(1, 2, 3)) {
            return $false
        }
        if ($report[$i] -gt $report[$i + 1]) {
            $ops += '-'
        }
        else {
            $ops += '+'
        }
    }

    if ($ops.Contains('-') -and $ops.Contains('+')) {
        return $false
    }

    return $true
}


$validReportCount = 0

foreach ($report in $reports) {
    if (Check-ReportValidity -report $report) {
        $validReportCount++
    }
}


Write-Host "valid Reports: " -NoNewline
Write-Host $validReportCount -ForegroundColor Green

$validReportCount = 0

:nextRep foreach ($report in $reports) {
    $ercnt = 0

    if (-not (Check-ReportValidity -report $report)) {
        $ercnt++
        $alReport = [System.Collections.ArrayList]$report
        for ($i = 0; $i -lt $report.Length; $i++) {
            $rep = $alReport.Clone()
            $rep.RemoveAt($i)
            $rep = $rep.ToArray()
            if (Check-ReportValidity -report $rep) {
                $validReportCount++
                continue nextRep
            }
        }
    }
    else {
        $validReportCount++
    }
    



}

Write-Host "valid Reports: " -NoNewline
Write-Host $validReportCount -ForegroundColor Green