. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName
    $names = ($apps | Where-Object { $_.DisplayName }) | ForEach-Object { $_.DisplayName } | Sort-Object
    Add-AuditResult -Category "Software Inventory" `
                    -CheckName "Installed Software" `
                    -Value ($names -join '; ') `
                    -Risk "Low" `
                    -Justification "Installed software list retrieved for inventory and risk assessment." `
                    -Remediation "Periodically review software inventory." `
                    -ISO27001 "5.36, 8.9" `
                    -NIST80053 "CM-8" `
                    -NISTCSF "ID.AM-1"
}
catch {
    Add-AuditResult -Category "Software Inventory" `
                    -CheckName "Installed Software" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Failed to get installed software list." `
                    -Remediation "Check registry access rights and execution context." `
                    -ISO27001 "5.36" `
                    -NIST80053 "CM-8" `
                    -NISTCSF "ID.AM-1"
}