#Part 1

$pth = ".\2023\Day 5\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$seeds = @()

$categories = @{}



while ($null -ne ($read = $reader.ReadLine())) {

    If ($read -like 'seeds:*') {
        $seeds = ($read.Split(':')[1]).TrimStart().TrimEnd().Split(' ')
    }
    elseif ($read -like '*:') {
        $category = $read.Split(':')[0]
        #$category
        $categories[$category] = [PSCustomObject]@{
            Ranges = @()
        }
    }
    elseif ($read -like "") {

    }
    else {
        $values = $read.Split(' ')
        $destinationstart = [long]::Parse($values[0])
        $sourcerangestart = [long]::Parse($values[1])
        $length = [long]::Parse($values[2])
        #for ($i = 0; $i -lt $length; $i++) {
        $categories[$category].Ranges += [PSCustomObject]@{
            sourcestart = $sourcerangestart
            sourceend   = $sourcerangestart + $length - 1
            offset      = $destinationstart - $sourcerangestart
        }
        #}
    }

}

$reader.Close()
$reader.Dispose()


function Seed-ToLocation {
    param (
        [long]$seed
    )
    
    $dest = $seed

    foreach ($valuemap in ($categories["seed-to-soil map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["soil-to-fertilizer map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["fertilizer-to-water map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    

    foreach ($valuemap in ($categories["water-to-light map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    
    foreach ($valuemap in ($categories["light-to-temperature map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    

    foreach ($valuemap in ($categories["temperature-to-humidity map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["humidity-to-location map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    #$dest
    return [long]::Parse($dest)
}

#Seed-ToLocation -seed 14



$lowest = [long]::MaxValue
foreach ($seed in $seeds) {
    
    $location = Seed-ToLocation -seed ([long]::parse($seed))

    
    #$seed
    #$location
    if ($location -lt $lowest) { $lowest = $location }
}

$lowest



#PArt 2
#Must be a smart way to do it...
#there are 2.504.127.863 seeds to process
#Answer is probably 50716416 based on stolen C# solution
#1273791167
#830057911

$pth = "C:\Temp\Git\AdventOfCode\2023\Day 5\input.txt"


$reader = New-Object System.IO.StreamReader($pth)

$seeds = @()

$categories = @{}


$q = 0
while ($null -ne ($read = $reader.ReadLine())) {

    If ($read -like 'seeds:*') {
        $seedranges = ($read.Split(':')[1]).TrimStart().TrimEnd().Split(' ')
        
        
        for ($i = 0; $i -lt $seedranges.Count; $i++) {
            if ($i % 2 -eq 1) {
                $length = [long]::parse($seedranges[$i])
                while ($j -lt $length) {
                    $seeds += $start + $j
                    $q++
                    if ($q % 10000 -eq 0) {
                        $q
                    }
                    $j++
                }
                #for ($j = 0; $j -lt $length; $j++) {

                #}
            }
            else {
                $start = [long]::parse($seedranges[$i])
            }
        }
    }
    elseif ($read -like '*:') {
        $category = $read.Split(':')[0]
        #$category
        $categories[$category] = [PSCustomObject]@{
            Ranges = @()
        }
    }
    elseif ($read -like "") {

    }
    else {
        $values = $read.Split(' ')
        $destinationstart = [long]::Parse($values[0])
        $sourcerangestart = [long]::Parse($values[1])
        $length = [long]::Parse($values[2])
        #for ($i = 0; $i -lt $length; $i++) {
        $categories[$category].Ranges += [PSCustomObject]@{
            sourcestart = $sourcerangestart
            sourceend   = $sourcerangestart + $length - 1
            offset      = $destinationstart - $sourcerangestart
        }
        #}
    }

}

$reader.Close()
$reader.Dispose()


function Seed-ToLocation {
    param (
        [long]$seed
    )
    
    $dest = $seed

    foreach ($valuemap in ($categories["seed-to-soil map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["soil-to-fertilizer map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["fertilizer-to-water map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    

    foreach ($valuemap in ($categories["water-to-light map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    
    foreach ($valuemap in ($categories["light-to-temperature map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 
    

    foreach ($valuemap in ($categories["temperature-to-humidity map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    foreach ($valuemap in ($categories["humidity-to-location map"].Ranges)) {
        if (($dest -ge $valuemap.sourcestart) -and ($dest -le $valuemap.sourceend)) {
            $dest += $valuemap.offset
            break
        }
    } 

    #$dest
    return [long]::Parse($dest)
}

#Seed-ToLocation -seed 14



$lowest = [long]::MaxValue
foreach ($seed in $seeds) {
    
    $location = Seed-ToLocation -seed ([long]::parse($seed))

    
    #$seed
    #$location
    if ($location -lt $lowest) { $lowest = $location }
}

$lowest




