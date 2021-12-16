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

static IEnumerable<string> Split(string str, int chunkSize)
{
    return Enumerable.Range(0, str.Length / chunkSize)
        .Select(i => str.Substring(i * chunkSize, chunkSize));
}


Class Packet {
    [int]$version
    [int]$type
    [string]$value

    Packet ([string]$binary) {
        $this.version = [Convert]::ToInt32(("0" + $binary.Substring(0,3)),2)
        $this.type = [Convert]::ToInt32(("0" + $binary.Substring(3,3)),2)
        
    }
}


To-Binary -Hex "D2FE28"

110100101111111000101000
110100101111111000101000


