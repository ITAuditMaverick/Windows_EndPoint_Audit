. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $netstat = netstat -ano | Select-String "LISTENING"
    Add-AuditResult -Category "Open Ports" `
                    -CheckName "Listening Ports (TCP)" `
                    -Value ($netstat -join '; ') `
                    -Risk "Medium" `
                    -Justification "Listening services expose the system to potential remote access." `
                    -Remediation "Close unused ports and monitor known services." `
                    -ISO27001 "8.20" `
                    -NIST80053 "SC-7" `
                    -NISTCSF "PR.PT-3"
}
catch {
    Add-AuditResult -Category "Open Ports" `
                    -CheckName "Listening Ports (TCP)" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Failed to gather open ports." `
                    -Remediation "Ensure 'netstat' is accessible in environment." `
                    -ISO27001 "8.20" `
                    -NIST80053 "SC-7" `
                    -NISTCSF "PR.PT-3"
}