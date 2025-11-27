$Year = (Get-Date).ToString('yyyy')

if (-not (Test-Path ".\$Year")) {
    New-Item -ItemType Directory -Name $Year -Path ".\"
    New-Item -ItemType File -Name "Results $Year.md" -Path ".\$Year"
    Add-Content -LiteralPath .\README.md -Value "[$Year Results]($Year/Results%20$Year.md)"
    Add-Content -LiteralPath ".\$Year\Results $Year.md" -Value "# This is how it is going 🏅`n|**Day**|**Part 1**|**Part 2**|`n|--|:--:|:--:|"
}

for ($i = 1; $i -le 25; $i++) {
    New-Item -ItemType Directory -Name "Day $i" -Path ".\$Year"
    New-Item  -ItemType File -Name "Day $i.ps1" -Path ".\$Year\Day $i"
    New-Item  -ItemType File -Name "input.txt" -Path ".\$Year\Day $i"
    Add-Content -LiteralPath ".\$Year\Results $Year.md" -Value "|Day $i| :heavy_minus_sign: | :heavy_minus_sign: |"
}
