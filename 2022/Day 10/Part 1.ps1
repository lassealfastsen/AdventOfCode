$pth = '.\2022\Day 10\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$cycle = 1
$x = 1

$signal = 0
while ($null -ne ($read = $reader.ReadLine())) {
    $cyclelength = 1
    for ($i = 0; $i -lt $cyclelength; $i++) {
        
        if ($cycle -eq 20) {
            $signal += $cycle * $x
        } elseif ((($cycle - 20) % 40) -eq 0) {
            $signal += $cycle * $x
        }
        Write-Host "$cycle : $x"
        switch ($read) {
            "noop" { 
                $cycle++
            }
            Default {       
                if ($i -eq 0) {
                    $cyclelength ++ #addx takes 2 cycles to complete    
                    #$cycle++
                } else {
                    $op = $read.Split(' ')[1]
                    $x += $op
                    
                }
                $cycle++
            }
        }
    }

    
}

#Write-Host "$cycle - $x"
$signal

$reader.Close()
$reader.Dispose()