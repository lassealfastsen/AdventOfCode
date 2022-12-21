$pth = ".\2022\Day 21\input.txt"

$reader = New-Object System.IO.StreamReader($pth)

$queue = New-Object System.Collections.Queue

$data = @{}

$action = "^([a-z]){4}: ([a-z]){4} (\+|\-|\*|\/) ([a-z]){4}$"
$value = '^([a-z]){4}: \d{1,}$'

#Get file contents
while ($null -ne ($read = $reader.ReadLine())) {
    if ('' -ne [regex]::Match($read, $value).Value) {
        $arr = $read.Split(' ')
        $name = $arr[0].Replace(':', '')
        $val = [Int64]$arr[1]

        $data["$name"] = $val
    } else { #if ('' -ne [regex]::Match($read, $action).Value) 
        $arr = $read.Split(' ')
        $name = $arr[0].Replace(':', '')
        $val1 = $arr[1]
        $val2 = $arr[3]
        $action = $arr[2]

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

$reader.Close()
$reader.Dispose()


#Process the queue until you know the value of Root

while ($null -eq $data["root"]) {
    $item = $queue.Dequeue()

    if ($null -ne $data["$($item.val1)"]) {
        $item.val1 = [int64]$data["$($item.val1)"]
    }
    if ($null -ne $data["$($item.val2)"]) {
        $item.val2 = [int64]$data["$($item.val2)"]
    }

    if (([bool]($item.val1 -as [int64])) -and ([bool]($item.val2 -as [int64]))) {
        $data["$($item.name)"] = [int64](("$($item.val1) $($item.action) $($item.val2)") | Invoke-Expression)
    } else {
        $queue.Enqueue($item)
    }

}

$data["root"]