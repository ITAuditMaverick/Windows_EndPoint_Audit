. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $rdpStatus = (Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server").fDenyTSConnections
    $smbShares = Get-SmbShare | Select-Object -ExpandProperty Name

    # Fixing inline if usage
    if ($rdpStatus -eq 0) {
        $rdpValue = "Yes"
        $rdpRisk = "Medium"
    } else {
        $rdpValue = "No"
        $rdpRisk = "Low"
    }

    Add-AuditResult -Category "Remote Access" `
                    -CheckName "RDP Enabled" `
                    -Value $rdpValue `
                    -Risk $rdpRisk `
                    -Justification "RDP access increases remote attack surface." `
                    -Remediation "Restrict RDP using firewall and VPN tunneling." `
                    -ISO27001 "5.15, 5.10" `
                    -NIST80053 "AC-17" `
                    -NISTCSF "PR.AC-3"

    $shareList = if ($smbShares) { $smbShares -join ', ' } else { "No shares found" }

    Add-AuditResult -Category "Remote Access" `
                    -CheckName "SMB Shares" `
                    -Value $shareList `
                    -Risk "Medium" `
                    -Justification "Open shares may expose data to unauthorized users." `
                    -Remediation "Limit access and audit shared folders periodically." `
                    -ISO27001 "8.12, 8.9" `
                    -NIST80053 "AC-6, SC-28" `
                    -NISTCSF "PR.DS-1"
}
catch {
    Add-AuditResult -Category "Remote Access" `
                    -CheckName "SMB / RDP" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Could not determine RDP/SMB configuration." `
                    -Remediation "Run as admin and ensure PowerShell remoting is enabled." `
                    -ISO27001 "5.10" `
                    -NIST80053 "AC-17" `
                    -NISTCSF "PR.AC-3"
}
