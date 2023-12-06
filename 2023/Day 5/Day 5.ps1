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
    Param($valuemaplist)


    $queue = $Script:seedRanges 
    $Script:seedRanges = [System.Collections.ArrayList]@()

    $valuemapcount = $valuemaplist.count
    $i = 0
    while ($queue.Count -gt 0 -and $i -lt $valuemapcount) {



        foreach ($valuemap in $valuemaplist) {
            if ($queue.Count -eq 0) { continue }
            $rng = $queue[0]
            $queue.RemoveAt(0)
            $i++


            if (($rng.rngStart -ge $valuemap.sourcestart) -and ($rng.rngEnd -le $valuemap.sourceend)) {
                #entire range can be modified
                [void]$Script:seedRanges.Add([PSCustomObject]@{
                        rngStart = [int64]($rng.rngStart + $valuemap.offset)
                        rngEnd   = [int64]($rng.rngEnd + $valuemap.offset)
                    })
                continue
            }
            elseif (($rng.rngStart -lt $valuemap.sourcestart) -and ($rng.rngEnd -ge $valuemap.sourcestart) -and ($rng.rngend -le $valuemap.sourceend)) {
                #range is partially within the map (left)

                [void]$queue.Add([PSCustomObject]@{
                        rngStart = [int64]($rng.rngStart)
                        rngEnd   = [int64]($valuemap.sourcestart - 1) 
                    }) #Before Map - Add to queue

                [void]$Script:seedRanges.Add([PSCustomObject]@{
                        rngStart = [int64]($valuemap.sourcestart + $valuemap.offset)
                        rngEnd   = [int64]($rng.rngEnd + $valuemap.offset)
                    }) #in Map
                continue
            }
            elseif (($rng.rngStart -ge $valuemap.sourcestart) -and ($rng.rngStart -lt $valuemap.sourceend) -and ($rng.rngEnd -gt $valuemap.sourceend)) {
                
                             
                #range is partially within the map (right)

                [void]$Script:seedRanges.Add([PSCustomObject]@{
                        rngStart = [int64]($rng.rngStart + $valuemap.offset)
                        rngEnd   = [int64]($valuemap.sourceend + $valuemap.offset)
                    })


                [void]$queue.Add([PSCustomObject]@{
                        rngStart = [int64]($valuemap.sourceend + 1)
                        rngEnd   = [int64]$rng.rngEnd
                    }) #After Map - add to queue
                continue
            }
            elseif (($rng.rngStart -lt $valuemap.sourcestart) -and ($rng.rngEnd -gt $valuemap.sourceend)) {
                [void]$queue.Add([PSCustomObject]@{
                        rngStart = [int64]$rng.rngStart
                        rngEnd   = [int64]($valuemap.sourcestart - 1)
                    }) #Before Map
            

                [void]$Script:seedRanges.Add([PSCustomObject]@{
                        rngStart = [int64]($valuemap.sourcestart + $valuemap.offset) 
                        rngEnd   = [int64]($valuemap.sourceend + $valuemap.offset)
                    })


                [void]$queue.Add([PSCustomObject]@{
                        rngStart = [int64]($valuemap.sourceend + 1)
                        rngEnd   = [int64]$rng.rngEnd
                    }) #After Map
                continue
            }
            else {
                [void]$queue.Add([PSCustomObject]@{
                        rngStart = [int64]($rng.rngStart) 
                        rngEnd   = [int64]($rng.rngEnd) 
                    })
                continue
            }

        }
    }

    while ($queue.Count -gt 0) {
        $rng = $queue[0]
        $queue.RemoveAt(0)
        [void]$Script:seedRanges.Add($rng)
    }

}

# $Script:seedRanges = [System.Collections.ArrayList]@()

# [void]$Script:seedRanges.Add([PSCustomObject]@{
#         rngStart = 82
#         rngEnd   = 82
#     })


Split-Ranges -valuemaplist ($categories["seed-to-soil map"].Ranges)

Split-Ranges -valuemaplist ($categories["soil-to-fertilizer map"].Ranges)

Split-Ranges -valuemaplist ($categories["fertilizer-to-water map"].Ranges)

Split-Ranges -valuemaplist ($categories["water-to-light map"].Ranges)

Split-Ranges -valuemaplist ($categories["light-to-temperature map"].Ranges)

Split-Ranges -valuemaplist ($categories["temperature-to-humidity map"].Ranges)

Split-Ranges -valuemaplist ($categories["humidity-to-location map"].Ranges)

$seedRanges

$seedRanges.rngStart | Sort-Object | Select-Object -First 1