. "$PSScriptRoot\\..\\utils\\Add-AuditResult.ps1"

try {
    $profiles = Get-NetFirewallProfile

    foreach ($profile in $profiles) {
        if ($profile.Enabled -eq $false) {
            $risk = "High"
        } else {
            $risk = "Low"
        }
        $value = "Enabled: $($profile.Enabled)"

        Add-AuditResult -Category "Firewall" `
                        -CheckName "$($profile.Name) Profile Status" `
                        -Value $value `
                        -Risk $risk `
                        -Justification "Firewall helps protect against unauthorized access." `
                        -Remediation "Ensure all firewall profiles are enabled and configured properly." `
                        -ISO27001 "8.20" `
                        -NIST80053 "SC-7" `
                        -NISTCSF "PR.PT-3"
    }
}
catch {
    Add-AuditResult -Category "Firewall" `
                    -CheckName "Firewall Profile Check" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Failed to retrieve firewall configuration." `
                    -Remediation "Run script as administrator with network module access." `
                    -ISO27001 "8.20" `
                    -NIST80053 "SC-7" `
                    -NISTCSF "PR.PT-3"
}