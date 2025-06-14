. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $tasks = Get-ScheduledTask | Where-Object {$_.State -eq "Ready" -or $_.State -eq "Running"} | Select-Object -ExpandProperty TaskName
    Add-AuditResult -Category "Scheduled Tasks" `
                    -CheckName "Auto-running Scheduled Tasks" `
                    -Value ($tasks -join ', ') `
                    -Risk "Medium" `
                    -Justification "Scheduled tasks can be used for persistence or privilege escalation." `
                    -Remediation "Review and validate all scheduled tasks for legitimacy." `
                    -ISO27001 "5.10, 8.15" `
                    -NIST80053 "SI-4" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "Scheduled Tasks" `
                    -CheckName "Auto-running Scheduled Tasks" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Failed to enumerate scheduled tasks." `
                    -Remediation "Verify task scheduler access permissions." `
                    -ISO27001 "5.10" `
                    -NIST80053 "SI-4" `
                    -NISTCSF "PR.IP-1"
}