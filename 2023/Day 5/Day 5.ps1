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
#Answer is 50716416 based on stolen C# solution
#According to the subreddit my strategy is correct, but i cannot get it to work
<#

Pseudo Code:

Get Seed Ranges and save them in a list.

Get conversion maps in the format of
-Source Start
-Source End
-Offset


Process each of the map sections like so
for all Seed Ranges find out if it is contained in the map

If entirely contained: apply the offset value for the map to the existing range.

If Partially contained: split the range into 2 or 3 smaller ranges (Before, Within & After the map) Apply the offset to the range contained

After processing all of the maps sort the Seed Ranges by the lowest start value

it works on the Sample input i even checked after each individual map, but for my real input it gives me a way too low value.

Well it worked on the sample input until i messed with it..

now it is FUBAR, i give up.

correct answer is 50716416 my code returns 12950548

Maybe i need to complete my maps so no value is unmodified.

#>


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
        $destinationstart = [int64]::Parse($values[0])
        $sourcerangestart = [int64]::Parse($values[1])
        $length = [int64]::Parse($values[2])
        #for ($i = 0; $i -lt $length; $i++) {
        $categories[$category].Ranges += [PSCustomObject]@{
            sourcestart = [int64]$sourcerangestart
            sourceend   = [int64]($sourcerangestart + $length - 1)
            offset      = [int64]($destinationstart - $sourcerangestart)
        }
        #}
    }

}

$reader.Close()
$reader.Dispose()

#Generate Seed Ranges



$Script:seedRanges = [System.Collections.ArrayList]@()

for ($i = 0; $i -lt $seeds.Count; $i += 2) {
    $rngStart = [int64]$seeds[$i]
    $rngEnd = ($rngStart + [int64]$seeds[($i + 1)])
    [void]$Script:seedRanges.Add([PSCustomObject]@{
            rngStart = [int64]$rngStart
            rngEnd   = [int64]$rngEnd
        })
}








Function Split-Ranges {
    Param(
        $maps,
        $ranges
    )

    
    foreach ($range in $ranges) {
        
        :maps foreach ($map in $maps) {
            


        }

    }

    while ($newRanges.Count -gt 0) {
        $rng = $newRanges[0]
        $newRanges.RemoveAt(0)
        $ranges.add($rng)
    }


    return $ranges

}


Function Split-Range {
    Param(
        $maps,
        $range
    )
    $newRanges = [System.Collections.ArrayList]@()
    $man = $false
    foreach ($map in $maps) {
        if ($range.rngStart -ge $map.sourcestart -and $range.rngend -le $map.sourceend) {
            [void]$newRanges.Add([PSCustomObject]@{
                    rngStart = [int64]($range.rngStart + $map.offset)
                    rngEnd   = [int64]($range.rngEnd + $map.offset)
                })
            $man = $true
            break
        }
        elseif ($range.rngStart -lt $range.sourcestart -and $range.rngend -ge $map.sourcestart -and $range.rngEnd -le $map.sourceend) {
            #Left
            $range.rngEnd = ($map.sourcestart - 1)

            #processed
            [void]$newRanges.Add([PSCustomObject]@{
                    rngStart = [int64]($map.sourcestart + $map.offset)
                    rngEnd   = [int64]($range.rngEnd + $map.offset)
                })
            $man = $true
        }
        elseif ($range.rngStart -ge $map.sourcestart -and $range.rngStart -lt $map.sourceend -and $range.rngend -gt $map.sourceend) {
                
            [void]$newRanges.Add([PSCustomObject]@{
                    rngStart = [int64]($map.sourcestart + $map.offset)
                    rngEnd   = [int64]($range.rngEnd + $map.offset)
                })

            #right
            $range.rngStart = ($map.sourceend + 1)
            $man = $true
        }
    }

    if (-not $man) {
        [void]$newRanges.Add($range)
    }
    return $newRanges
}

$Script:seedRanges = [System.Collections.ArrayList]@()
[void]$Script:seedRanges.Add([PSCustomObject]@{
        rngStart = 82
        rngEnd   = 82
    })

$seedRanges = Split-Range -range $seedRanges[0] -maps ($categories["seed-to-soil map"].Ranges) 
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["soil-to-fertilizer map"].Ranges)
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["fertilizer-to-water map"].Ranges)
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["water-to-light map"].Ranges)
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["light-to-temperature map"].Ranges)
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["temperature-to-humidity map"].Ranges)
$seedRanges
$seedRanges = Split-Range -range $seedRanges[0] -valuemaplist ($categories["humidity-to-location map"].Ranges)





# Function Split-Ranges {
#     Param($valuemaplist)


#     $queue = $Script:seedRanges 
#     $Script:

#     $valuemapcount = $valuemaplist.count
#     $i = 0
#     while ($queue.Count -gt 0 -and $i -lt $valuemapcount) {



#         foreach ($valuemap in $valuemaplist) {
#             if ($queue.Count -eq 0) { continue }
#             $rng = $queue[0]
#             $queue.RemoveAt(0)
#             $i++


#             if (($rng.rngStart -ge $valuemap.sourcestart) -and ($rng.rngEnd -le $valuemap.sourceend)) {
#                 #entire range can be modified
#                 [void]$Script:seedRanges.Add([PSCustomObject]@{
#                         rngStart = [int64]($rng.rngStart + $valuemap.offset)
#                         rngEnd   = [int64]($rng.rngEnd + $valuemap.offset)
#                     })
#                 continue
#             }
#             elseif (($rng.rngStart -lt $valuemap.sourcestart) -and ($rng.rngEnd -ge $valuemap.sourcestart) -and ($rng.rngend -le $valuemap.sourceend)) {
#                 #range is partially within the map (left)

#                 [void]$queue.Add([PSCustomObject]@{
#                         rngStart = [int64]($rng.rngStart)
#                         rngEnd   = [int64]($valuemap.sourcestart - 1) 
#                     }) #Before Map - Add to queue

#                 [void]$Script:seedRanges.Add([PSCustomObject]@{
#                         rngStart = [int64]($valuemap.sourcestart + $valuemap.offset)
#                         rngEnd   = [int64]($rng.rngEnd + $valuemap.offset)
#                     }) #in Map
#                 continue
#             }
#             elseif (($rng.rngStart -ge $valuemap.sourcestart) -and ($rng.rngStart -lt $valuemap.sourceend) -and ($rng.rngEnd -gt $valuemap.sourceend)) {
                
                             
#                 #range is partially within the map (right)

#                 [void]$Script:seedRanges.Add([PSCustomObject]@{
#                         rngStart = [int64]($rng.rngStart + $valuemap.offset)
#                         rngEnd   = [int64]($valuemap.sourceend + $valuemap.offset)
#                     })


#                 [void]$queue.Add([PSCustomObject]@{
#                         rngStart = [int64]($valuemap.sourceend + 1)
#                         rngEnd   = [int64]$rng.rngEnd
#                     }) #After Map - add to queue
#                 continue
#             }
#             elseif (($rng.rngStart -lt $valuemap.sourcestart) -and ($rng.rngEnd -gt $valuemap.sourceend)) {
#                 [void]$queue.Add([PSCustomObject]@{
#                         rngStart = [int64]$rng.rngStart
#                         rngEnd   = [int64]($valuemap.sourcestart - 1)
#                     }) #Before Map
            

#                 [void]$Script:seedRanges.Add([PSCustomObject]@{
#                         rngStart = [int64]($valuemap.sourcestart + $valuemap.offset) 
#                         rngEnd   = [int64]($valuemap.sourceend + $valuemap.offset)
#                     })


#                 [void]$queue.Add([PSCustomObject]@{
#                         rngStart = [int64]($valuemap.sourceend + 1)
#                         rngEnd   = [int64]$rng.rngEnd
#                     }) #After Map
#                 continue
#             }
#             else {
#                 [void]$queue.Add([PSCustomObject]@{
#                         rngStart = [int64]($rng.rngStart) 
#                         rngEnd   = [int64]($rng.rngEnd) 
#                     })
#                 continue
#             }

#         }
#     }

#     while ($queue.Count -gt 0) {
#         $rng = $queue[0]
#         $queue.RemoveAt(0)
#         [void]$Script:seedRanges.Add($rng)
#     }

# }


Split-Ranges -valuemaplist ($categories["seed-to-soil map"].Ranges)

Split-Ranges -valuemaplist ($categories["soil-to-fertilizer map"].Ranges)

Split-Ranges -valuemaplist ($categories["fertilizer-to-water map"].Ranges)

Split-Ranges -valuemaplist ($categories["water-to-light map"].Ranges)

Split-Ranges -valuemaplist ($categories["light-to-temperature map"].Ranges)

Split-Ranges -valuemaplist ($categories["temperature-to-humidity map"].Ranges)

Split-Ranges -valuemaplist ($categories["humidity-to-location map"].Ranges)

$seedRanges

$seedRanges.rngStart | Sort-Object | Select-Object -First 1





















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
        $destinationstart = [int64]::Parse($values[0])
        $sourcerangestart = [int64]::Parse($values[1])
        $length = [int64]::Parse($values[2])
        #for ($i = 0; $i -lt $length; $i++) {
        $categories[$category].Ranges += [PSCustomObject]@{
            sourcestart = [int64]$sourcerangestart
            sourceend   = [int64]($sourcerangestart + $length - 1)
            offset      = [int64]($destinationstart - $sourcerangestart)
        }
        #}
    }

}

$reader.Close()
$reader.Dispose()

#Generate Seed Ranges



$Script:seedRanges = [System.Collections.ArrayList]@()

for ($i = 0; $i -lt $seeds.Count; $i += 2) {
    $rngStart = [int64]$seeds[$i]
    $rngEnd = ($rngStart + [int64]$seeds[($i + 1)])
    [void]$Script:seedRanges.Add([PSCustomObject]@{
            rngStart = [int64]$rngStart
            rngEnd   = [int64]$rngEnd
        })
}







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


#skip 10000 at a time to get a starting point
$lowest = [long]::MaxValue
$loweseed = $null
foreach ($seedrange in $Script:seedRanges) {


    for ($i = $seedrange.rngStart; $i -le $seedrange.rngEnd; $i += 10000) {
        $location = Seed-ToLocation -seed ([long]::parse($i))
        if ($location -lt $lowest) { 
            $lowest = $location
            $loweseed = $i
            Write-Host "$i - $location"
        }
    }
}


#Somewhere areound seed 3894944590
#Process well before and after the starting point


$lowest = [long]::MaxValue
$loweseed = $null
for ($i = [long](3894944590 - 50000); $i -lt [long](3894944590 + 50000); $i++) {
    $location = Seed-ToLocation -seed ([long]::parse($i))
    if ($location -lt $lowest) { 
        $lowest = $location
        $loweseed = $i
        Write-Host "$i - $location"
    }
}

#Seed 3894936731 is the right one, gives 50716416 