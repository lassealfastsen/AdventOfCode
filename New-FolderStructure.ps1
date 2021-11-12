$Year = (Get-Date).ToString('yyyy')

if (-not (Test-Path ".\$Year")) {
    New-Item -ItemType Directory -Name $Year -Path ".\"
    New-Item -ItemType File -Name "Results $Year.md" -Path ".\$Year"
    Add-Content -LiteralPath ".\$Year\Results $Year.md" -Value "|Day|Part 1|Part 2|
    |--|--|--|"
}

for ($i = 1; $i -le 25; $i++) {
    New-Item -ItemType Directory -Name "Day $i" -Path ".\$Year"
    New-Item  -ItemType File -Name "Day $i.ps1" -Path ".\$Year\Day $i"
    Add-Content -LiteralPath ".\$Year\Results $Year.md" -Value "|Day $i| | |"
}


New-Item -ItemType Directory -Name "Test" | New-Item -ItemType File -Name "Hello.txt"