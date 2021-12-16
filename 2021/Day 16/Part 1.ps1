Function To-Binary ([String]$Hex) {
    $conversion = @{
        '0' = '0000'
        '1' = '0001'
        '2' = '0010'
        '3' = '0011'
        '4' = '0100'
        '5' = '0101'
        '6' = '0110'
        '7' = '0111'
        '8' = '1000'
        '9' = '1001'
        'A' = '1010'
        'B' = '1011'
        'C' = '1100'
        'D' = '1101'
        'E' = '1110'
        'F' = '1111' 
    }

    $str = ""
    foreach ($char in $Hex.ToCharArray()) {
        $str = [String]::Format("{0}{1}", $str, $conversion["$char"])
    }

    return $str
}


Class Packet {
    [int]$version
    [int]$type
    [string]$value
    [Packet[]]$subpackets

    Packet ([string]$binary) {
        $this.version = [Convert]::ToInt32(("0" + $binary.Substring(0,3)),2)
        $this.type = [Convert]::ToInt32(("0" + $binary.Substring(3,3)),2)
        
        if ($this.type -eq 4) {
            #Literal
            $i = 6
            $val = ""
            $last = $false
            
            while ($i -gt 0) {
                $group = $binary.Substring($i,5) 
                $val = "$val$($group.Substring(1,4))"
                $i+=5
                if ($group[0] -eq '0') {
                    $i = 0
                }
            }
            
            #$vals += "$vals$([Convert]::ToInt32($group.Substring(1,4)))"
            
            $this.value = [Convert]::ToInt32($val, 2)
        } else {
            #Operator
            if ($binary.Substring(6,1) -eq '0') {
                #15bit
                $length = [Convert]::ToInt32($binary.Substring(7,15), 2)
                
                $this.subpackets += $binary.Substring(22,11)
                $this.subpackets += $binary.Substring(33,($length-11))
            } else {
                #11 bit
                $numpackets = [Convert]::ToInt32($binary.Substring(7,11), 2)
                $start = 18
                for ($i = 0; $i -lt $numpackets; $i++) {
                    $this.subpackets += ([Packet]($binary.Substring($start,11)))
                    $Start += 11
                }
            }
        }
    }
}

#$packet = [Packet](To-Binary -Hex "D2FE28")

#$packet = [Packet](To-Binary -Hex "38006F45291200")

[Packet](To-Binary -Hex "EE00D40C823060")

00111000000000000110111101000101001010010001001000000000
00111000000000000110111101000101001010010001001000000000
#To-Binary -Hex "D2FE28"

# 110100101111111000101000
# 110100101111111000101000

# [COnvert]::ToInt32("0111", 2)
# [COnvert]::ToDecimal([COnvert]::ToInt32("0111", 2))

# [Convert]::ToInt32('011111100101', 2)




<#

01000000010101000001110110010000000010101110110111000000000110101000100000000000001000011001000111111110001011110100010111010001000000000110101000101111110000100011100010001101001001111000110101000110010100111110001110010001000000000010000011110010111000101111001111100010010011000000000001111110110011010111101010111010011010100010000000001110011011101000000000010111111110010010110010010011010011001111101000001110010100101001000010110101011010011100111000001111010010111010010100011000000000100001001111011001011000111100000000001101110001000000000000010000101010000111100100000101101000001001000000000000001000011011000011010110001001001100001101000110000000001001000001100111001001011111111111001111010110010111010010010001110001100000000010001100000000011011000000000000010000100010001100110100001001001000100010100010000000001111010000110111100011001001000110011000010000000001101110000111001100010001101000001100000010000000001111100110000000001111110001001000100001111111000101001100110000000001110010001010111100010110101000100000000100000000001000011101000100100110000011011100011101010011000000000100001011000000000100101001010101110001100100110111011110011111100101101010110110011011001101100001000000001001000001111010000000001001100000000000001000010101000100111110001110010100001101100000000000000100001100100010010111000001101010001110101100101100001100000100000000000100001111001100001110110001100000000010101101000000000011010011110010100100101110001101001100101001001011100011011111000011000001100000000010110011001001011010010101000001110110010111100101100000011011100011100001001011010100100100110000000110000000001000111010000000001001010001010110100110001110001010011100111010001000100110000000001001110011011010010111011000000000100110001000000000110101000111001110000101000100010101000001000000000111101000101111110001011011100010101011001101111110110111110111001101010011110101110000000010100010010111101001010010100010001101001010011001110110001001110010100110101010100110011100101010110101010001000110001000000001001111010110010010111111000101101111101000000000110111000000000000000001000010001000010111110001100100100001110110000000000000100001110100011100101000010101010000110101001100000000010100100111110010100111010000000001010010010010101100110011010010010101100110011110010101101000001101100010000000010000110010101111101010110001111001100110010101110010000110010010000011101001101111001110111001111101101000001100110011100101111101111010100000001111100100000000010000000001001111001010001100110110001001010010111001110001001000101000110100101111000011011100011100111101111010101010000100000000010101010111100000000000100000000100101110001000010010011000001001001000111101110001001100001001001000000000110101001010011001111011001110101100001010110001001101111111000000000101111001101110000110010010000110010111001111100010000000001011111001101000000000010111100010011001001100001001010011011100101010101110101100100011011110101001110000011000000000100111110000000001011100001100101011011111111100111100011011111110010001110010101101111111110011110001101111111001001011001111111011000001110011000000000101101001101111100100111011011000110011101100010010111000000000010101001010000100100100101111101110100111000101011100000000000001001011001001000101000100100110111101101110000100011110010111000000000110011001101111011110110111001110010110001001001001110101110000010000000000100111111010010111101111100111111011110011001100001111000100100110110111110011100000010111001101010100111111111100100000100110011100011011101101010100000000100101000100001100100000000011011110001000110111111010000000001001110010101111101100010100111011001101111111100101011111011000101001110110011011110000000000000001101001110100111110010010010010101100100110010110011110001000011001000111001001011111001001010011111111010001001101000100000000001111100110110101110100110000000001001010010001100100100010011010000000001010010010111110101011011000111101111111000111110111010010010111110000111001101000000000001000001111001101010111011000011000110001110001011001001000000000110010101110110000000001001110010010111011110001000010100100101110111100010001011001110010011101001111000110101010000000000111100010010000001000100110001010110000110101000111000110000010001010011100100001100000100010100101001000100110010100101000111110000110000000001000110011111010011011101000000000101111001001110101111000100010010010001100011001011111001101100001000000000110011000100111010011001110101010011010100001100111100101001110010110001010101001011110010110111101111001110011111100110100100101000101111000100000000010001101001001111101001000100111100011101110001100001100010010001001101100111101001000000011001101101101000000001100001011110000000000101101111101001000000010101100100000100000001010000111110110000000100101101111011100000000001010001000000010000010110000000000000111011110000101000000000011000101000000000011010100000000010110101010001000000001001111100101010000000000101100010000000000101000110000000000100101100000000010100111010000000000000111101111001000000000010011111000010000000000110010010010101100010111001010000000000111110000111101001100000000010011100110111000111000011001101010000000000101111101100101101010010100010000101001111110011010011000100000000000111010101100100100101001010010100110111010011000010101111000001110100100000000001010111001001010001010010100010111101001000101110000

#>