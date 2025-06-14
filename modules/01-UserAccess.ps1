. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $admins = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name
    Add-AuditResult -Category "User Access Control" `
                    -CheckName "Local Administrators" `
                    -Value ($admins -join ', ') `
                    -Risk "Medium" `
                    -Justification "Too many local admins increase the risk of privilege abuse." `
                    -Remediation "Restrict admin group to essential personnel." `
                    -ISO27001 "5.18, 6.1.2" `
                    -NIST80053 "AC-2, AC-6" `
                    -NISTCSF "PR.AC-1"
}
catch {
    Add-AuditResult -Category "User Access Control" `
                    -CheckName "Local Administrators" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Failed to retrieve local admin users." `
                    -Remediation "Check script permissions and PowerShell version." `
                    -ISO27001 "5.18" `
                    -NIST80053 "AC-2" `
                    -NISTCSF "PR.AC-1"
}