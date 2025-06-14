. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $events = Get-WinEvent -LogName Security -MaxEvents 50 | Where-Object { $_.Id -in 4625, 4672 }
    $summary = $events | Group-Object Id | ForEach-Object { "$($_.Name): $($_.Count)" }
    Add-AuditResult -Category "Event Logs" `
                    -CheckName "Security Event Summary" `
                    -Value ($summary -join '; ') `
                    -Risk "Medium" `
                    -Justification "Failed logins or privilege use can indicate attacks." `
                    -Remediation "Monitor and investigate high-frequency event IDs." `
                    -ISO27001 "5.10, 8.15" `
                    -NIST80053 "AU-6" `
                    -NISTCSF "DE.AE-3"
}
catch {
    Add-AuditResult -Category "Event Logs" `
                    -CheckName "Security Event Summary" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not access event logs." `
                    -Remediation "Ensure audit logging and PowerShell access rights." `
                    -ISO27001 "5.10" `
                    -NIST80053 "AU-6" `
                    -NISTCSF "DE.AE-3"
}