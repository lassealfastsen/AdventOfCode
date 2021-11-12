$Year = (Get-Date).ToString('yyyy')

if (-not (Test-Path ".\$Year")) {
    New-Item -ItemType Directory -Name $Year -Path ".\"
}

for ($i = 1; $i -le 25; $i++) {
    New-Item -ItemType Directory -Name "Day $i" -Path ".\$Year"
}
