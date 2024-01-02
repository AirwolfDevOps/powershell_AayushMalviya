 function Parse-LogFiles {
    param (
        [string]$logDirectory,
        [string]$outputDirectory
    )
 
    # Get all log files in the specified directory
    $logFiles = Get-ChildItem -Path $logDirectory -Filter *.log
 
    # Initialize variables to store data
    $totalRequests = 0
    $urlCounts = @{}
    $responseCodeCounts = @{}
    $responseTimes = @()
 
    # Process each log file
    foreach ($logFile in $logFiles) {
        $logContent = Get-Content $logFile.FullName
 
        foreach ($entry in $logContent) {
            # Assuming log entries are space-separated and contain timestamp, URL, and response code
            $regexPattern1 = '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$'
            if ($entry -match $regexpattern1) {
                # Extract information from the matched log entry
                #$timestamp = $matches[2]
                $url = $matches[3]
                $responseCode = $matches[4]
            }    
            # Process the data as needed
            $totalRequests++
            $urlCounts[$url]++
            $responseCodeCounts[$responseCode]++
 
            # Add logic to calculate response time for successful requests (status code 200)
            if ($responseCode -eq '200') {
                # Assuming response time is in the last field
                $responseTime = [double]$matches[-1]
                $responseTimes += $responseTime
            }
        }
    }
 
    # Calculate average response time
    $averageResponseTime = if ($responseTimes.Count -gt 0) { ($responseTimes | Measure-Object -Average).Average } else { 0 }
 
    # Generate a report
    $report = @"
Web Server Activity Report
--------------------------
 
Total Requests: $totalRequests
Average Response Time: $averageResponseTime milliseconds
 
Top Accessed URLs:
$($urlCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object { "  $($_.Key): $($_.Value) requests" })

Response Code Distribution:
$($responseCodeCounts.GetEnumerator() | Sort-Object Key | ForEach-Object { "  $($_.Key): $($_.Value) requests" })

"@
 
    # Save the report to a file
    $reportPath = Join-Path $outputDirectory "WebServerActivityReport.txt"
    $report | Out-File -FilePath $reportPath
 
    Write-Host "Report generated and saved to: $reportPath"
}
 
# Example usage
Parse-LogFiles -logDirectory "C:\devops\Task1\" -outputDirectory "C:\devops\Task1\"