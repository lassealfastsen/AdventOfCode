$reader = New-Object System.IO.StreamReader('C:\Temp\AoC\AdventOfCode\2025\Day 10\input.txt')




$manpages = @()




while ($null -ne ($read = $reader.ReadLine())) { 
    $content = $read.Split(' ')
    


    $manpage = [PSCustomObject]@{
        lights              = @()
        desiredState        = @()
        buttons             = [Collections.ArrayList]@()
        joltageRequirements = $content[-1]
        validPushes         = @()
        knownStates         = @()
    }

    foreach ($light in $content[0].Replace('[', '').Replace(']', '').ToCharArray()) {
        $manpage.lights += $false
        $manpage.desiredState += ($light -eq '#')
    }

    foreach ($button in $content[1..($content.Count - 2)]) {
        $manpage.buttons.Add($button.Replace('(', '').Replace(')', '').Split(','))
    }

    $manpages += $manpage
}

$reader.Close()
$reader.Dispose()


$page = $manpages[0]

$queue = New-Object System.Collections.Queue

foreach ($button in $page.buttons) {
    $null = $queue.Add(

        [PSCustomObject]@{
            state     = $lights
            nexButton = $button
        }
    )
}



