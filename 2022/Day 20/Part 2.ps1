$pth = ".\2022\Day 20\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

$queue = New-Object System.Collections.Queue

$data = New-Object System.Collections.ArrayList

$map = @{}

$decryptionKey = 811589153



while ($null -ne ($read = $reader.ReadLine())) {
    $guid = (New-Guid).Guid
    $queue.Enqueue(
        @{
            GUID = $guid
            val  = [int]$read * $decryptionKey
        }
    )

    $map["$guid"] = @{
        val  = [int]$read * $decryptionKey
        GUID = $guid
    }

    $data.Add($guid) | Out-Null
}

$reader.Close()
$reader.Dispose()

Function Write-Values {
    foreach ($item in $data) {
        Write-Host "$($map[$item].val)," -NoNewline
    }
    Write-Host ""
}

$qcnt = $queue.Count - 1
$cnt = 0
while ($queue.Count -gt 0) {
    $item = $queue.Dequeue()
    if ($cnt -lt (10 - 1) * $qcnt) {
        $queue.Enqueue($item)
    }
    if ($item.val -eq 0) {
        continue
    }
    $index = $data.IndexOf($item.GUID)

    $data.Remove($item.GUID)
    $newpos = $index + $item.val


    if ($newpos -lt 0) {
        $newpos = $data.Count - ([MAth]::Abs($newpos) % $data.Count)
    } elseif ($newpos -gt $data.Count) {
        $newpos = ($newpos % $data.Count)
    }

    if ($newpos -eq 0) {
        $newval = $data[0..($data.Count)] + @([String]$item.GUID)
        #$newval = @([String]$item.GUID) + $data[0..($data.Count)]
    } elseif ($newpos -eq $data.Count) {
        $newval = $data[0..($data.Count)] + @([String]$item.GUID)
    } else {
        $newval = $data[0..($newpos - 1)] + [String]$item.GUID + $data[$newpos..($data.Count)]
    }
    
    $data = New-Object System.Collections.ArrayList($null)
    $data.AddRange($newval)
    $cnt++
    #Write-Values
}

#Write-Values

#$map | Where-Object { (Value -EQ 0) }
#Find relevant values


$index0 = $data.IndexOf(($map.Values | Where-Object { ($_.val -eq 0) }).GUID)

$index1000 = (($index0 + 1000) % $data.Count) 
$index2000 = (($index0 + 2000) % $data.Count) 
$index3000 = (($index0 + 3000) % $data.Count) 



$map[$data[$index1000]].val + $map[$data[$index2000]].val + $map[$data[$index3000]].val
#   Write-Values




# #Init
# 811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612
# 811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612

# #1
# 0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153
# 0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153
# 0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153

# #2
# 0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153
# 0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153

# #7
# 0, -2434767459, 2434767459, 1623178306, -1623178306, 811589153, 3246356612
# 0, -2434767459, 2434767459, 1623178306, -1623178306, 811589153, 3246356612

# #10
# 0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153
# 0, -2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153