function Get-AvgResponse {
    param (
        [string]$filePath
    )

    $content = Get-Content -Path $filePath
    $times = @()

    foreach ($entry in $content) {
        $pattern = '(^\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$'

        if ($entry -match $pattern) {
            $code = $matches[4]

            if ($code -eq '200') {
                $time = $matches[5]
                Write-Host "Response Time: $time"
                $times += $time
            }
        }
    }

    $avgTime = if ($times.Count -gt 0) { ($times | Measure-Object -Average).Average } else { 0 }
    Write-Host "Avg Time: $avgTime"
}

Get-AvgResponse -filePath "C:\devops\Task1\apache_access.log"
