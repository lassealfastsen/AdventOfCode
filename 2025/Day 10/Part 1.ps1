$reader = New-Object System.IO.StreamReader('C:\git\AdventOfCode\2025\Day 10\input.txt')


$manpages = @()


while ($null -ne ($read = $reader.ReadLine())) { 
    $content = $read.Split(' ')
    


    $manpage = [PSCustomObject]@{
        lights              = $content[0].Replace('[', '').Replace(']', '').Replace('#', '.')
        desiredState        = $content[0].Replace('[', '').Replace(']', '')
        buttons             = [Collections.ArrayList]@()
        joltageRequirements = $content[-1]
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


foreach ($page in $manpages) {
    $queue = New-Object System.Collections.Queue

    foreach ($button in $page.buttons) {
        $null = $queue.Enqueue(
            [PSCustomObject]@{
                state      = $page.lights
                nextButton = $button
                presses    = 0
            }
        )
    }


    while ($queue.Count -gt 0) {

        $push = $queue.Dequeue()

        $state = $push.state.ToCharArray()
        foreach ($light in $push.nextButton) {
            switch ($state[$light]) {
                '.' { $state[$light] = '#' }
                '#' { $state[$light] = '.' }
            }
        
            #$push.state[$light] = !$push.state[$light]
        }
        $push.state = $state -join ''
        $push.presses++

        if ($push.state -eq $page.desiredState) {
            if ($push.presses -lt $page.leastpushes) {
                $page.leastpushes = $push.presses
            }
        }
        elseif ($push.state -notin $page.knownStates) {
            $page.knownStates += $push.state
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