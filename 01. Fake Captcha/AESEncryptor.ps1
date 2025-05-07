param (
    [string]$PlainTextPath = "payload.txt",
    [string]$Key = "0p53x.St34lth#21",
    [string]$IV_Hex = "0102030405060708090A0B0C0D0E0F10"
)

# Convert key dan IV
$keyBytes = [Text.Encoding]::UTF8.GetBytes($Key)
$ivBytes = @()
for ($i = 0; $i -lt $IV_Hex.Length; $i += 2) {
    $ivBytes += [Convert]::ToByte($IV_Hex.Substring($i, 2), 16)
}

# Baca isi plaintext dari file
$plainText = Get-Content $PlainTextPath -Raw
$plainBytes = [Text.Encoding]::UTF8.GetBytes($plainText)

# Setup AES
$aes = [System.Security.Cryptography.Aes]::Create()
$aes.Mode = "CBC"
$aes.Padding = "PKCS7"
$aes.KeySize = 128
$aes.Key = $keyBytes
$aes.IV = $ivBytes

# Enkripsi
$encryptor = $aes.CreateEncryptor()
$ms = New-Object System.IO.MemoryStream
$cs = New-Object System.Security.Cryptography.CryptoStream($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
$cs.Write($plainBytes, 0, $plainBytes.Length)
$cs.Close()

# Output base64
$encrypted = $ms.ToArray()
$base64 = [Convert]::ToBase64String($encrypted)
Write-Host "`n🔐 Encrypted Base64 Output:"
Write-Host $base64
