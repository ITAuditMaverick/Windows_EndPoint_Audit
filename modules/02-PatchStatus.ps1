. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $lastUpdate = (Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 1).InstalledOn
    Add-AuditResult -Category "Patch Management" `
                    -CheckName "Last Installed Update" `
                    -Value "$lastUpdate" `
                    -Risk "Low" `
                    -Justification "System is receiving patches." `
                    -Remediation "Ensure updates are automatic and verified monthly." `
                    -ISO27001 "8.28, 8.29" `
                    -NIST80053 "SI-2" `
                    -NISTCSF "PR.IP-12"
}
catch {
    Add-AuditResult -Category "Patch Management" `
                    -CheckName "Last Installed Update" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Could not fetch update status." `
                    -Remediation "Verify that Windows Update and WMI are functioning." `
                    -ISO27001 "8.29" `
                    -NIST80053 "SI-2" `
                    -NISTCSF "PR.IP-12"
}