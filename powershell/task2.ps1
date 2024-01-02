$logPath = "C:\devops\powershell\apache_access.log"
$logData = Get-Content -Path $logPath

$start = Get-Date "12/Dec/2023 00:00:00"
$end = Get-Date "12/Dec/2023 23:59:59"

$total = 0
$urls = @{}
$codes = @{}

foreach ($entry in $logData) {
    if ($entry -match '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$') {
        $dateVal = [DateTime]::ParseExact($Matches[2], "dd/MMM/yyyy:HH:mm:ss zzz", [System.Globalization.CultureInfo]::InvariantCulture)
        $webUrl = $Matches[3]
        $status = [int]$Matches[4]

        if ($dateVal -ge $start -and $dateVal -le $end) {
            $total++
            
            if ($urls.ContainsKey($webUrl)) {
                $urls[$webUrl]++
            } else {
                $urls[$webUrl] = 1
            }

            if ($codes.ContainsKey($status)) {
                $codes[$status]++
            } else {
                $codes[$status] = 1
            }
        }
    }
}

Write-Host "Total Requests: $total"
Write-Host "Top URLs:" $urls | Sort-Object Value -Descending | ForEach-Object { Write-Host "$($_.Key): $($_.Value) times" }
Write-Host "Response Status Codes:"
$codes.GetEnumerator() | Sort-Object Name | ForEach-Object { Write-Host "$($_.Key): $($_.Value) times" }
