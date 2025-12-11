$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 10\input.txt')


$manpages = @()


while ($null -ne ($read = $reader.ReadLine())) { 
    $content = $read.Split(' ')
    


    $manpage = [PSCustomObject]@{
        state               = ($content[0].Replace('[', '').Replace(']', '') -replace '#', '0' -replace '.', '0').ToCharArray() -join ','
        buttons             = [Collections.ArrayList]@()
        joltageRequirements = [int[]]$content[-1].Replace('{', '').Replace('}', '').Split(',')
        #validPushes         = @()
        knownStates         = @()
        leastpushes         = [int]::MaxValue
    }

    # foreach ($light in $content[0].Replace('[', '').Replace(']', '').ToCharArray()) {
    #     $manpage.lights += 0
    #     $manpage.desiredState += ($light -eq '#')
    # }

    foreach ($button in $content[1..($content.Count - 2)]) {
        $manpage.buttons.Add([int[]]($button.Replace('(', '').Replace(')', '').Split(','))) | Out-Null
    }

    $manpages += $manpage
}

$reader.Close()
$reader.Dispose()



$c = 0

foreach ($page in $manpages) {
    $queue = New-Object System.Collections.Queue

    foreach ($button in $page.buttons) {
        $null = $queue.Enqueue(
            [PSCustomObject]@{
                state      = $page.state
                nextButton = $button
                presses    = 0
            }
        )
    }


    :q while ($queue.Count -gt 0) {

        $push = $queue.Dequeue()

        $state = [int[]]$push.state.split(',')
        foreach ($light in $push.nextButton) {
            $state[$light]++
            if ($state[$light] -gt $page.joltageRequirements[$light]) {
                continue q
            }
        }
        $push.state = $state -join ','
        $push.presses++


        if ($push.state -eq ($page.joltageRequirements -join ',')) {
            if ($push.presses -lt $page.leastpushes) {
                $page.leastpushes = $push.presses
                $queue.Clear()
            }
        }
        elseif ($push.state -notin $page.knownStates) {
            $page.knownStates += $push.state
            if ($push.presses -gt $c) { $c++; $c }
            foreach ($button in $page.buttons) {
                $null = $queue.Enqueue(
                    [PSCustomObject]@{
                        state      = $push.state
                        nextButton = $button
                        presses    = $push.presses
                    }
                )
            }
        }
    }
}


$manpages.leastpushes -join ' + ' | Invoke-Expression


