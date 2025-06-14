. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $keywords = @("mimikatz", "psexec", "remoteaccess")
    $logs = Get-WinEvent -LogName Security -MaxEvents 100 -ErrorAction SilentlyContinue

    $hits = foreach ($log in $logs) {
        foreach ($keyword in $keywords) {
            if ($log.Message -match [regex]::Escape($keyword)) {
                $log
                break
            }
        }
    }

    $count = $hits.Count
    $calculatedRisk = if ($count -gt 0) { "High" } else { "Low" }

    Add-AuditResult -Category "Log Analysis" `
                    -CheckName "Keyword Hunt (Security Log)" `
                    -Value "$count suspicious entries" `
                    -Risk $calculatedRisk `
                    -Justification "Security log contained keywords commonly linked to post-exploitation or admin tools." `
                    -Remediation "Review logs for potential misuse of powerful tools and unauthorized access." `
                    -ISO27001 "5.10, 8.15" `
                    -NIST80053 "AU-6" `
                    -NISTCSF "DE.AE-5"
}
catch {
    Add-AuditResult -Category "Log Analysis" `
                    -CheckName "Keyword Hunt (Security Log)" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Failed to parse or read security logs." `
                    -Remediation "Ensure script is run with necessary permissions to read event logs." `
                    -ISO27001 "5.10" `
                    -NIST80053 "AU-6" `
                    -NISTCSF "DE.AE-5"
}
