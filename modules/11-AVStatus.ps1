. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $status = Get-MpComputerStatus
    if ($status.AntivirusEnabled) {
    $avState = "Enabled"
    } else {
    $avState = "Disabled"
    }
    Add-AuditResult -Category "AV Status" `
                    -CheckName "Defender Antivirus Status" `
                    -Value $avState `
                    -Risk (if ($avState -eq "Disabled") { "High" } else { "Low" }) `
                    -Justification "Antivirus state impacts real-time protection." `
                    -Remediation "Ensure Defender or another AV is enabled and up to date." `
                    -ISO27001 "5.10, 8.7" `
                    -NIST80053 "SI-3" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "AV Status" `
                    -CheckName "Defender Antivirus Status" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Unable to determine AV state." `
                    -Remediation "Validate script runs as admin and Windows Defender is installed." `
                    -ISO27001 "5.10" `
                    -NIST80053 "SI-3" `
                    -NISTCSF "PR.IP-1"
}