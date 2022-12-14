# You climb the hill and again try contacting the Elves. However, you instead receive a signal you 
# weren't expecting: a distress signal.

# Your handheld device must still not be working properly; the packets from the distress signal got 
# decoded out of order. You'll need to re-order the list of received packets (your puzzle input) 
# to decode the message.

# Your list consists of pairs of packets; pairs are separated by a blank line. You need to identify 
# how many pairs of packets are in the right order.

# For example:

# [1,1,3,1,1]
# [1,1,5,1,1]

# [[1],[2,3,4]]
# [[1],4]

# [9]
# [[8,7,6]]

# [[4,4],4,4]
# [[4,4],4,4,4]

# [7,7,7,7]
# [7,7,7]

# []
# [3]

# [[[]]]
# [[]]

# [1,[2,[3,[4,[5,6,7]]]],8,9]
# [1,[2,[3,[4,[5,6,0]]]],8,9]

# Packet data consists of lists and integers. Each list starts with [, ends with ], and contains 
# zero or more comma-separated values (either integers or other lists). Each packet is always a list
# and appears on its own line.

# When comparing two values, the first value is called left and the second value is called right. 

# Then:
# - If both values are integers, the lower integer should come first. If the left integer is lower 
#   than the right integer, the inputs are in the right order. If the left integer is higher than 
#   the right integer, the inputs are not in the right order. Otherwise, the inputs are the same 
#   integer; continue checking the next part of the input.
# - If both values are lists, compare the first value of each list, then the second value, and so 
#   on. If the left list runs out of items first, the inputs are in the right order. If the right 
#   list runs out of items first, the inputs are not in the right order. If the lists are the same 
#   length and no comparison makes a decision about the order, continue checking the next part of 
#   the input.
# - If exactly one value is an integer, convert the integer to a list which contains that integer as
#   its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the 
#   right value to [2] (a list containing 2); the result is then found by instead comparing [0,0,0] 
#   and [2].

# Using these rules, you can determine which of the pairs in the example are in the right order:

# == Pair 1 ==
# - Compare [1,1,3,1,1] vs [1,1,5,1,1]
#   - Compare 1 vs 1
#   - Compare 1 vs 1
#   - Compare 3 vs 5
#     - Left side is smaller, so inputs are in the right order

# == Pair 2 ==
# - Compare [[1],[2,3,4]] vs [[1],4]
#   - Compare [1] vs [1]
#     - Compare 1 vs 1
#   - Compare [2,3,4] vs 4
#     - Mixed types; convert right to [4] and retry comparison
#     - Compare [2,3,4] vs [4]
#       - Compare 2 vs 4
#         - Left side is smaller, so inputs are in the right order

# == Pair 3 ==
# - Compare [9] vs [[8,7,6]]
#   - Compare 9 vs [8,7,6]
#     - Mixed types; convert left to [9] and retry comparison
#     - Compare [9] vs [8,7,6]
#       - Compare 9 vs 8
#         - Right side is smaller, so inputs are not in the right order

# == Pair 4 ==
# - Compare [[4,4],4,4] vs [[4,4],4,4,4]
#   - Compare [4,4] vs [4,4]
#     - Compare 4 vs 4
#     - Compare 4 vs 4
#   - Compare 4 vs 4
#   - Compare 4 vs 4
#   - Left side ran out of items, so inputs are in the right order

# == Pair 5 ==
# - Compare [7,7,7,7] vs [7,7,7]
#   - Compare 7 vs 7
#   - Compare 7 vs 7
#   - Compare 7 vs 7
#   - Right side ran out of items, so inputs are not in the right order

# == Pair 6 ==
# - Compare [] vs [3]
#   - Left side ran out of items, so inputs are in the right order

# == Pair 7 ==
# - Compare [[[]]] vs [[]]
#   - Compare [[]] vs []
#     - Right side ran out of items, so inputs are not in the right order

# == Pair 8 ==
# - Compare [1,[2,[3,[4,[5,6,7]]]],8,9] vs [1,[2,[3,[4,[5,6,0]]]],8,9]
#   - Compare 1 vs 1
#   - Compare [2,[3,[4,[5,6,7]]]] vs [2,[3,[4,[5,6,0]]]]
#     - Compare 2 vs 2
#     - Compare [3,[4,[5,6,7]]] vs [3,[4,[5,6,0]]]
#       - Compare 3 vs 3
#       - Compare [4,[5,6,7]] vs [4,[5,6,0]]
#         - Compare 4 vs 4
#         - Compare [5,6,7] vs [5,6,0]
#           - Compare 5 vs 5
#           - Compare 6 vs 6
#           - Compare 7 vs 0
#             - Right side is smaller, so inputs are not in the right order

# What are the indices of the pairs that are already in the right order? (The first pair has index 
# 1, the second pair has index 2, and so on.) 

# In the above example, the pairs in the right order are 1, 2, 4, and 6; the sum of these indices 
# is 13.

# Determine which pairs of packets are already in the right order. 

# What is the sum of the indices of those pairs?

class List {
    hidden [string] $IndentChar = '  '
    [List] $Parent
    [System.Collections.ArrayList] $Children

    List() {
        $this.Children = [System.Collections.ArrayList]::new()
    }

    [void] SetParent([List] $Parent) {
        $this.Parent = $Parent
    }

    [List] GetParent() {
        return $this.Parent
    }

    [void] AddChild([psobject] $Child) {
        $this.Children.Add($Child) | Out-Null
    }

    [String] Print([int32] $IndentLevel) {
        $SB = [System.Text.StringBuilder]::new()
        $SB.AppendLine("$($this.IndentChar * $IndentLevel)[") | Out-Null
        foreach ($Child in $this.Children) {
            if ($Child -is [int32]) {
                $SB.AppendLine("$($this.IndentChar * ($IndentLevel+1))$Child") | Out-Null
            } elseif ($Child -is [List]) {
                $SB.AppendLine($Child.Print($IndentLevel + 1)) | Out-Null
            }
        }
        $SB.Append("$($this.IndentChar * $IndentLevel)]") | Out-Null
        return $Sb.ToString()
    }

    [String] ToString() {
        return $this.Print(0)
    }

}

function ParsePacket {
    [OutputType([List])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [String]
        $Packet
    )
    $CurrentList = $null
    $DigitAccumulator = [System.Text.StringBuilder]::new()

    # Parse the input character by character. Ensuring a 
    # reference is kept to the first list created so it can
    # be returned
    foreach ($Char in $Packet.ToCharArray()) {
        switch ($Char) {
            '[' { 
                # Push a new list
                $NewList = [List]::new()
                $NewList.SetParent($CurrentList)
                if ($null -ne $CurrentList) {
                    $CurrentList.AddChild($NewList)
                }
                $CurrentList = $NewList
            }
            ']' {
                # Pop the current list
                # If the accumulated digits is not empty
                # push it onto the current list and clear it
                if ($DigitAccumulator.Length -gt 0) {
                    $Number = $DigitAccumulator.ToString() -as [int32]
                    $DigitAccumulator.Clear() | Out-Null
                    $CurrentList.AddChild($Number)
                }
                if ($null -ne $CurrentList.GetParent()) {
                    $CurrentList = $CurrentList.GetParent()
                }
            }
            ',' {
                # If the accumulated digits is not empty
                # push it onto the current list and clear it
                if ($DigitAccumulator.Length -gt 0) {
                    $Number = $DigitAccumulator.ToString() -as [int32]
                    $DigitAccumulator.Clear() | Out-Null
                    $CurrentList.AddChild($Number)
                }
            }
            { $PSItem -in [char]'0'..[char]'9' } {
                # If the number is between 0 and 9, add to
                # the digit accumulator
                $DigitAccumulator.Append($Char) | Out-Null
            }
            Default {}
        }
    }
    if ($DigitAccumulator.Length -gt 0) {
        $Number = $DigitAccumulator.ToString() -as [int32]
        $DigitAccumulator.Clear() | Out-Null
        $CurrentList.AddChild($Number)
    }
    return $CurrentList
}

enum Decision {
    InOrder
    OutOfOrder
    KeepChecking
}

function CompareLists {
    [OutputType([Decision])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [psobject]
        $LeftSide,
        [Parameter(Mandatory, Position = 1)]
        [psobject]
        $RightSide
    )
    # - If both values are integers, the lower integer should come first. If the left integer is lower 
    #   than the right integer, the inputs are in the right order. If the left integer is higher than 
    #   the right integer, the inputs are not in the right order. Otherwise, the inputs are the same 
    #   integer; continue checking the next part of the input.
    if ($LeftSide -is [int32] -and $RightSide -is [int32]) {
        if ($LeftSide -eq $RightSide) {
            return [Decision]::KeepChecking
        }
        if ($LeftSide -lt $RightSide) {
            return [Decision]::InOrder
        }
        return [Decision]::OutOfOrder
    }

    # - If exactly one value is an integer, convert the integer to a list which contains that integer as
    #   its only value, then retry the comparison. For example, if comparing [0,0,0] and 2, convert the 
    #   right value to [2] (a list containing 2); the result is then found by instead comparing [0,0,0] 
    #   and [2].
    if ($LeftSide -is [int32] -and $RightSide -is [List]) {
        $LeftSideAsList = [List]::new()
        $LeftSideAsList.AddChild($LeftSide)
        return CompareLists $LeftSideAsList $RightSide
    }

    if ($LeftSide -is [List] -and $RightSide -is [int32]) {
        $RightSideAsList = [List]::new()
        $RightSideAsList.AddChild($RightSide)
        return CompareLists $LeftSide $RightSideAsList
    }

    # - If both values are lists, compare the first value of each list, then the second value, and so 
    #   on. If the left list runs out of items first, the inputs are in the right order. If the right 
    #   list runs out of items first, the inputs are not in the right order. If the lists are the same 
    #   length and no comparison makes a decision about the order, continue checking the next part of 
    #   the input.
    if ($LeftSide -is [List] -and $RightSide -is [List]) {
        $i = 0
        $Decision = [Decision]::KeepChecking
        do {
            if ($null -eq $LeftSide.Children[$i] -and
                $null -ne $RightSide.Children[$i]) {
                return [Decision]::InOrder
            }
            if ($null -ne $LeftSide.Children[$i] -and
                $null -eq $RightSide.Children[$i]) {
                return [Decision]::OutOfOrder
            }
            if ($null -eq $LeftSide.Children[$i] -and
                $null -eq $RightSide.Children[$i]) {
                return [Decision]::KeepChecking
            }
            $Decision = CompareLists $LeftSide.Children[$i] $RightSide.Children[$i]
            $i++
        } while (
            $Decision -eq [Decision]::KeepChecking -and
            $i -lt $LeftSide.Children.Count -and
            $i -lt $RightSide.Children.Count
        )
        if ($Decision -ne [Decision]::KeepChecking) {
            return $Decision
        }
        if ($LeftSide.Children.Count -eq $RightSide.Children.Count) {
            return [Decision]::KeepChecking
        }
        if ($LeftSide.Children.Count -lt $RightSide.Children.Count) {
            return [Decision]::InOrder
        } else {
            return [Decision]::OutOfOrder
        }
    }
}

# Import data and remove blank lines
$ReceivedPackets = Get-Content '.\2022\Day 13\input.txt' | Where-Object { ($_ -notlike '') }
#$ReceivedPackets = (. "$PSScriptRoot\Inputs.ps1") -notlike ''

$PacketPairs = @()

for ($i = 0; $i -lt $ReceivedPackets.Count - 1; $i += 2) {
    $Pair = [PSCustomObject]@{
        Index   = ([Math]::Floor($i / 2) -as [int32]) + 1
        Packet1 = ParsePacket $ReceivedPackets[$i]
        Packet2 = ParsePacket $ReceivedPackets[$i + 1]
        Order   = $null
    }
    $Pair.Order = CompareLists $Pair.Packet1 $Pair.Packet2
    $PacketPairs += $Pair
}

$Sum = $PacketPairs | Where-Object Order -EQ 'InOrder' | 
Measure-Object -Property Index -Sum | Select-Object -Expand Sum

Write-Host "The sum of the indices of those pairs is '$Sum'"

 ($PacketPairs | Where-Object Order -EQ 'InOrder').Index | Set-Clipboard


<#


$pth = '.\2022\Day 13\input.txt'

$nl = [System.Environment]::NewLine
$in = ((Get-Content $pth) | Out-String) -split "$nl$nl"


function Compare-Packets {
    param (
        [Parameter(Mandatory=$true)][String]$left,
        [Parameter(Mandatory = $true)][String]$right
    )

    #Convert to from JSON
    $left = $left | ConvertFrom-Json
    $right = $right | ConvertFrom-Json


    if ($left[0] -is [int] -and $right[0] -is [int]) {

    }
    
}



for ($i = 1; $i -le $in.Count; $i++) {
    $items = $in[$i - 1].split("`n")
    


}

#>