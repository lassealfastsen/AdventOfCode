$pth = '.\2022\Day 10\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$cycle = 0
$x = 1

$line = ""

while ($null -ne ($read = $reader.ReadLine())) {
    $cyclelength = 1
    for ($i = 0; $i -lt $cyclelength; $i++) {
        


        if ($cycle % 40 -eq 0) {
            Write-Host $line
            $line = ""
        }

        #Sprite is x +- 1
        $sprite = (($x - 1)..($x + 1))
        $pixel = $line.Length
        
        if ( $pixel -in $sprite ) { #The sprite is visible!
            $line = "$line#"
        } else {
            $line = "$line "
        }

        switch ($read) {
            "noop" { 
                $cycle++
            }
            Default {       
                if ($i -eq 0) {
                    $cyclelength ++ #addx takes 2 cycles to complete    
                } else {
                    $op = $read.Split(' ')[1]
                    $x += $op
                    
                }

                $cycle++
            }
        }



    }

    
}

#draw the final line
Write-Host $line

$reader.Close()
$reader.Dispose()