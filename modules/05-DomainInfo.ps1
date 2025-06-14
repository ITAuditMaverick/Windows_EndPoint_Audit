. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    Add-AuditResult -Category "Domain Info" `
                    -CheckName "Domain Membership" `
                    -Value "$domain" `
                    -Risk "Low" `
                    -Justification "Domain-joined system confirms directory management." `
                    -Remediation "Ensure domain group policies are applied." `
                    -ISO27001 "5.7" `
                    -NIST80053 "AC-2" `
                    -NISTCSF "PR.AC-1"
}
catch {
    Add-AuditResult -Category "Domain Info" `
                    -CheckName "Domain Membership" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not determine domain status." `
                    -Remediation "Verify system domain join and WMI service." `
                    -ISO27001 "5.7" `
                    -NIST80053 "AC-2" `
                    -NISTCSF "PR.AC-1"
}