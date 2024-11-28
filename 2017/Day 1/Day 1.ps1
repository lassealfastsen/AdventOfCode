function Get-CaptchaResult {
    param (
        [switch]$part2,
        [string]$captcha
    )

    $arr = $captcha.ToCharArray()

    #Add first char to the end to make it "circular"
    #$arr += $arr[0]

    $sum = 0
    $offset = 1
    if ($part2) {$offset = $arr.Count/2}


    for ($i = 0; $i -lt $arr.Count; $i++) {
        
        $n = (($i+$offset) % ($arr.Length))
        if ($arr[$i] -eq $arr[$n]) {
            $sum += [int]::Parse($arr[$i])
        }
    }

    return $sum
    
}

Push-Location '.\2017\Day 1'
$inCaptcha = Get-Content ".\input.txt" -Raw
Pop-Location


$part1Result = Get-CaptchaResult -captcha $inCaptcha
$part2Result = Get-CaptchaResult -captcha $inCaptcha -part2

Write-Host "Part 1: " -NoNewline
Write-Host $part1Result -ForegroundColor Green

Write-Host "Part 2: " -NoNewline
Write-Host $part2Result -ForegroundColor Green