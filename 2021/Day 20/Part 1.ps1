
class image {
    [System.Collections.Generic.LinkedList[String]]$litPixels
    [int]$xmin
    [int]$xmax
    [int]$ymin
    [int]$ymax
    [bool]$infinty

    image (
        [System.Collections.Generic.LinkedList[String]]$listOfLitPixels
    ) {
        $this.xmin = 0
        $this.xmax = 0
        $this.ymin = 0
        $this.ymax = 0
        $this.infinty = $false

        foreach ($item in $listOfLitPixels) {
            $x = $item.Split(',')[0]
            $y = $item.Split(',')[1]

            if ($x -lt $this.xmin) {$this.xmin = $x}
            if ($x -gt $this.xmax) {$this.xmax = $x}
            if ($y -lt $this.ymin) {$this.ymin = $x}
            if ($y -gt $this.ymax) {$this.ymax = $x}
        }

        $this.litPixels = $listOfLitPixels
    }

    image (
        [System.Collections.Generic.LinkedList[String]]$listOfLitPixels,
        [int]$xmin,
        [int]$xmax,
        [int]$ymin,
        [int]$ymax
        #[bool]$infinty
    
    ) {
        $this.xmin = $xmin
        $this.xmax = $xmax
        $this.ymin = $ymin
        $this.ymax = $ymax
        $this.litPixels = $listOfLitPixels
        #$this.infinity = $infinty
    }

    Enhance([string]$enhancementAlgoritm) {
        
        $referenceImage = [image]::New($this.litPixels, $this.xmin, $this.xmax, $this.ymin, $this.xmax)

        if ($this.infinty -and ($enhancementAlgoritm[0] -eq '#')) {
            $referenceImage.Pad()
        }
        
        $this.xmin--
        $this.xmax++
        $this.ymin--
        $this.ymax++
        $this.litPixels = New-Object 'System.Collections.Generic.LinkedList[String]'

        for ($y = $this.ymin; $y -le $this.ymax; $y++) {
            for ($x = $this.xmin; $x -le $this.xmax; $x++) {

                $num = ""

                if ("$($x-1),$($y-1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x),$($y-1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x+1),$($y-1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}

                if ("$($x-1),$($y)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x),$($y)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x+1),$($y)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}

                if ("$($x-1),$($y+1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x),$($y+1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}
                if ("$($x+1),$($y+1)" -in $referenceImage.litPixels) {$num += "1"} else {$num += "0"}

                if ($enhancementAlgoritm[(([Convert]::ToInt32($num, 2)))] -eq '#' ) {$this.litPixels.AddLast("$x,$y")}

                
                
                #Write-Host "$x,$y - $num"

            }
        }
        $this.infinty = (-not $this.infinty)
    }


    Pad() {
        for ($x = ($this.xmin-2); $x -le ($this.xmax+2); $x++) {
            $null = $this.litPixels.AddLast("$x,$($this.ymin-1)")
            $null = $this.litPixels.AddLast("$x,$($this.ymin-2)")
            $null = $this.litPixels.AddLast("$x,$($this.ymax+1)")
            $null = $this.litPixels.AddLast("$x,$($this.ymax+2)")
        }
        for ($y = $this.xmin; $y -le $this.ymax; $y++) {
            $null = $this.litPixels.AddLast("$($this.xmin-1),$y")
            $null = $this.litPixels.AddLast("$($this.xmin-2),$y")
            $null = $this.litPixels.AddLast("$($this.xmax+1),$y")
            $null = $this.litPixels.AddLast("$($this.xmax+2),$y")
        }
    }

}


<#
# class image {
#     $litPixels
#     [int]$xmin
#     [int]$xmax
#     [int]$ymin
#     [int]$ymax
#     [bool]$infinty

#     image (
#         [System.Collections.Generic.LinkedList[String]]$listOfLitPixels
#     ) {
#         $this.xmin = 0
#         $this.xmax = 0
#         $this.ymin = 0
#         $this.ymax = 0
#         $this.infinty = $false
#         $this.litPixels = @{}

#         foreach ($item in $listOfLitPixels) {
#             $x = $item.Split(',')[0]
#             $y = $item.Split(',')[1]

#             if ($x -lt $this.xmin) {$this.xmin = $x}
#             if ($x -gt $this.xmax) {$this.xmax = $x}
#             if ($y -lt $this.ymin) {$this.ymin = $x}
#             if ($y -gt $this.ymax) {$this.ymax = $x}

#             $this.litPixels["$item"] = 1
#         }



#         #$this.litPixels = $listOfLitPixels
#     }

#     image (
#         [hashtable]$listOfLitPixels,
#         [int]$xmin,
#         [int]$xmax,
#         [int]$ymin,
#         [int]$ymax
#         #[bool]$infinty
    
#     ) {
#         $this.xmin = $xmin
#         $this.xmax = $xmax
#         $this.ymin = $ymin
#         $this.ymax = $ymax
#         $this.litPixels = $listOfLitPixels
#         #$this.infinity = $infinty
#     }

#     Enhance([string]$enhancementAlgoritm) {

#         $referenceImage = [image]::New($this.litPixels, $this.xmin, $this.xmax, $this.ymin, $this.xmax)

#         if ($this.infinty) {
#             $referenceImage.Pad()
#         }
        
#         $this.xmin--
#         $this.xmax++
#         $this.ymin--
#         $this.ymax++
#         $this.litPixels = @{}#New-Object 'System.Collections.Generic.LinkedList[String]'

#         for ($y = $this.ymin; $y -le $this.ymax; $y++) {
#             for ($x = $this.xmin; $x -le $this.xmax; $x++) {

#                 $num = ""

#                 if ($null -ne $referenceImage["$($x-1),$($y-1)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x),$($y-1)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x+1),$($y-1)"]) {$num += "1"} else {$num += "0"}

#                 if ($null -ne $referenceImage["$($x-1),$($y)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x),$($y)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x+1),$($y)"]) {$num += "1"} else {$num += "0"}

#                 if ($null -ne $referenceImage["$($x-1),$($y+1)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x),$($y+1)"]) {$num += "1"} else {$num += "0"}
#                 if ($null -ne $referenceImage["$($x+1),$($y+1)"]) {$num += "1"} else {$num += "0"}

#                 if ($enhancementAlgoritm[(([Convert]::ToInt32($num, 2)))] -eq '#' ) {$this.litPixels["$x,$y"] = 1}

                
                
#                 #Write-Host "$x,$y - $num"

#             }
#         }
#         $this.infinty = (-not $this.infinty)
#     }


#     Pad() {
#         for ($x = ($this.xmin-2); $x -le ($this.xmax+2); $x++) {
#             $this.litPixels["$x,$($this.ymin-1)"] = 1
#             $this.litPixels["$x,$($this.ymin-2)"] = 1
#             $this.litPixels["$x,$($this.ymax+1)"] = 1
#             $this.litPixels["$x,$($this.ymax+2)"] = 1
#         }
#         for ($y = $this.xmin; $y -le $this.ymax; $y++) {
#             $this.litPixels["$($this.xmin-1),$y"]
#             $this.litPixels["$($this.xmin-2),$y"]
#             $this.litPixels["$($this.xmax+1),$y"]
#             $this.litPixels["$($this.xmax+2),$y"]
#         }
#     }

# }

#>

$pth = "C:\Users\lal\OneDrive - Lyngsoe Systems\Documents\github\AdventOfCode\AdventOfCode\2021\day 20\input.txt"
$reader = New-Object System.IO.StreamReader($pth)


$enhancementAlgoritm = $reader.ReadLine()
$reader.ReadLine()

$list = New-Object 'System.Collections.Generic.LinkedList[String]'
$y = 0
while ($null -ne ($read = $reader.ReadLine())) {
    for ($x=0; $x -lt $read.Length; $x++) {
        if ($read[$x] -eq '#') {
            $null = $list.AddLast("$x,$y")
        }
    }
    $y++
}

$reader.Close()
$reader.Dispose()


[image]$image=[image]($list)

$image.Enhance($enhancementAlgoritm)
$image.litPixels.Count

$image.Enhance($enhancementAlgoritm)

$image.litPixels.Count



# 0,-1
# 1,-1
# 3,-1
# 4,-1
# -1,0
# 2,0
# 4,0
# -1,1
# 0,1
# 2,1
# 5,1
# -1,2
# 0,2
# 1,2
# 2,2
# 5,2
# 0,3
# 3,3
# 4,3
# 1,4
# 2,4
# 5,4
# 2,5
# 4,5





# $str = ""

# for ($y=$image.xmin; $y -le $image.xmax; $y++) {
#     for ($x = $image.xmin; $x -le $image.xmax; $x++) {
#         if ($null -ne $image.litPixels["$x,$y"]) {
#             Write-Host "#" -NoNewline
#             $str = "$str#"
#         } else {
#             Write-Host '.' -NoNewline
#             $str = "$str."
#         }
#     }
#     Write-Host
#     $str += "`r`n"
# }


# $str | Set-Clipboard