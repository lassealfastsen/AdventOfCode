$code = "bgvyzdsv"


$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding

$i = 0

$validHash = $false

while (-not $validHash) {
    $i++
    #$i
    $hash = ([System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes("$($code)$($i)"))).Replace('-', ''))
    if ($hash -like '00000*') {
        $validHash = $true
        $i
    }
}





