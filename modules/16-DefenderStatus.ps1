. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $status = Get-MpComputerStatus
    $enabled = $status.RealTimeProtectionEnabled

    if ($enabled) {
        $risk = "Low"
        $value = "Enabled"
    } else {
        $risk = "High"
        $value = "Disabled"
    }

    Add-AuditResult -Category "Defender" `
                    -CheckName "Real-Time Protection" `
                    -Value $value `
                    -Risk $risk `
                    -Justification "Real-time protection helps prevent active threats." `
                    -Remediation "Enable real-time protection via GPO or registry." `
                    -ISO27001 "5.10, 8.7" `
                    -NIST80053 "SI-3" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "Defender" `
                    -CheckName "Real-Time Protection" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not access Defender status." `
                    -Remediation "Check Defender service and script permissions." `
                    -ISO27001 "5.10" `
                    -NIST80053 "SI-3" `
                    -NISTCSF "PR.IP-1"
}
