$paths = @{}

$pth = '.\2022\Day 7\input.txt'

$reader = New-Object System.IO.StreamReader($pth)

$currentPath = '/'

while ($null -ne ($read = $reader.ReadLine())) {
    if ($read[0] -eq '$') {
        #This is a command
        switch ($read.split(' ')[1]) {
            "cd" {
                switch ($read.split(' ')[2]) {
                    ".." {  
                        #Go Up One Level
                        $currentPath = $currentPath.Split('/')
                        $currentPath = $currentPath | Select-Object -First ($currentPath.Count - 2)
                        $currentPath = "$($currentPath -join '/')/"
                    }
                    "/" {  
                        $currentPath = "/"
                    }
                    Default {  
                        #Go a level down
                        $currentPath = "$currentPath$($read.split(' ')[2])/"
                    }
                }
            }
            "ls" { }#Do nothing }
            Default {
                Write-Host "Shouldnt happen :/"
            }
        }
    }
    elseif ($read.Substring(0, 3) -eq 'dir') {
        #List contencts (don't do anything here)
    }
    else {
        # this is a file
        if ($paths.Keys -contains $currentPath) {
            $paths[$currentPath] += ([int]$read.Split(' ')[0])
        }
        else {
            $paths[$currentPath] = ([int]$read.Split(' ')[0])
        }
        
        if ($currentPath -ne "/") {
            $parent = $currentPath
            while (($parent = "$(($parent.Split('/') | Select-Object -First ($parent.Split('/').Count - 2)) -join '/')/") -ne "/") {
                $paths[$parent] += ([int]$read.Split(' ')[0])
            }
            $paths[$parent] += ([int]$read.Split(' ')[0])
        }
    }
}

($paths.Values | Where-Object {($_ -lt 100000)} | Measure-Object -Sum).Sum


$reader.Close()
$reader.Dispose()