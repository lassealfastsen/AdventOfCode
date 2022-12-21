$pth = ".\2022\Day 21\input.txt"


$r1 = $null
$r2 = $null



$action = "^([a-z]){4}: ([a-z]){4} (\+|\-|\*|\/) ([a-z]){4}$"
$value = '^([a-z]){4}: \d{1,}$'



#Get file contents




Function Get-Input {
    Param(
        [Parameter(Mandatory = $true)][int64]$humn
    )

    $reader = New-Object System.IO.StreamReader($pth)

    $queue = New-Object System.Collections.Queue

    $data = @{}


    while ($null -ne ($read = $reader.ReadLine())) {
        if ('' -ne [regex]::Match($read, $value).Value) {
        
        
            $arr = $read.Split(' ')
            $name = $arr[0].Replace(':', '')
            $val = [Int64]$arr[1]

            if ($name -eq "humn") {
                $val = $humn
            }

            $data["$name"] = $val
        
        } else { #if ('' -ne [regex]::Match($read, $action).Value) 
            $arr = $read.Split(' ')
            $name = $arr[0].Replace(':', '')
            $val1 = $arr[1]
            $val2 = $arr[3]
            $action = $arr[2]

            if ($name -eq 'root') {
                $r1 = $val1
                $r2 = $val2
            } else {
                $queue.Enqueue(
                    @{
                        name   = $name
                        val1   = $val1
                        val2   = $val2
                        action = $action
                    }
                )
            }

        }
    }



    $reader.Close()
    $reader.Dispose()


    return @{
        queue = $queue
        data  = $data
        r1    = $r1
        r2    = $r2
    }
}



#Answer is between 3400000000001 and 3300000000001
#between 3352900000001 and 3352800000001
#3352887000001 and 3352886000001
#3352886130001 and 3352886140001
#3352886133901 and 3352886133801
$testval = 3352886133801

while ($true) {

    $obj = Get-Input -humn $testval

    #Process the queue until you know the value of R1 and R2
    Write-Host "Trying $testval" -NoNewline
    while ($null -eq $obj.data["$($obj.r1)"] -or $null -eq $obj.data["$($obj.r2)"]) {
        $item = $obj.queue.Dequeue()

        if ($null -ne $obj.data["$($item.val1)"]) {
            $item.val1 = [int64]$obj.data["$($item.val1)"]
        }
        if ($null -ne $obj.data["$($item.val2)"]) {
            $item.val2 = [int64]$obj.data["$($item.val2)"]
        }

        if (($item.val1 -match '\d') -and ($item.val2 -match '\d')) {
            if ($item.action -eq '/' -and $item.val2 -eq 0) {
                $obj.data["$($item.name)"] = 0 
            } else {
                $obj.data["$($item.name)"] = [int64](("$($item.val1) $($item.action) $($item.val2)") | Invoke-Expression)
            }
            
        } else {
            $obj.queue.Enqueue($item)
        }
    }

    Write-Host " - $($obj.data[$obj.r1]) - $($obj.data[$obj.r2]): $($obj.data[$obj.r1] - $obj.data[$obj.r2])"

    if ($obj.data[$obj.r1] -eq $obj.data[$obj.r2] ) {
        Write-Host "$testval is the right number!"
        break
    }

    $testval += 1
}