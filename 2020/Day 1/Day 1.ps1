# $expenseReport = @(
#     1721,
#     979,
#     366,
#     299,
#     675,
#     1456
# )

#Part 1
$expenseReport = [int[]](Import-Csv '.\2020\Day 1\expenseReport.csv').Expense

#Find the numbers that sum to 2020
foreach ($num in $expenseReport) {
    $remainder = 2020-[int]$num
    if ($expenseReport -contains $remainder) {
        Write-Host "the Numbers are $num and $remainder"
        Write-HOst "The answer is $($num * $remainder)"
        break
    }
}



#Part 2
:loop foreach ($num in $expenseReport) {
    $sumRemainders = 2020-[int]$num
    foreach ($remainder1 in ($expenseReport | Where-Object {($_ -ne $num)})) {
        $remainder2 = $sumRemainders-$remainder1
        if ($expenseReport -contains $remainder2) {
            Write-Host "The correct numbers are $num, $remainder1 and $remainder2"
            Write-Host "The answer is $($num*$remainder1*$remainder2)"
            break loop
        }
    }
}
