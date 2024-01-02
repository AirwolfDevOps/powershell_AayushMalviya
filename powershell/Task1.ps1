$logDir = "C:\devops\powershell"
$logFiles = Get-ChildItem -Path $logDir -Filter *.logs

foreach ($file in $logFiles) {
    Write-Host "Analyzing file: $($file.FullName)"
    $content = Get-Content -Path $file.FullName

    foreach ($entry in $content) {
        if ($entry -match '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$') {
            $time = $matches[2]
            $webUrl = $matches[3]
            $code = $matches[4]
            Write-Host "Time: $time, URL: $webUrl, Code: $code"
        }
        elseif ($entry -match '^\[([^\]]+)\] \[([^\]]+)\] \[pid (\d+)\] (.+)$') {
            $time = $matches[1]
            $id = $matches[3]
            $msg = $matches[4]
            Write-Host "Time: $time, ID: $id, Message: $msg"
        }
        elseif ($entry -match '^(\w{3} \d{2} \d{2}:\d{2}:\d{2}) (\S+) (\w+)\[(\d+)\]: \((\S+)\) CMD \((.+)\)$') {
            $time = $matches[1]
            $host = $matches[2]
            $id = $matches[4]
            Write-Host "Time: $time, Host: $host, ID: $id"
        }
    }
}

Write-Host "Processing finished."
