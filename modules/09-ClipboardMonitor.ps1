. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    Add-Type -AssemblyName PresentationCore
    $clipboard = [Windows.Clipboard]::GetText()
    Add-AuditResult -Category "Clipboard Monitor" `
                    -CheckName "Clipboard Content (Snapshot)" `
                    -Value ($clipboard.Substring(0, [Math]::Min(100, $clipboard.Length))) `
                    -Risk "Medium" `
                    -Justification "Clipboard content may reveal sensitive info." `
                    -Remediation "Disable clipboard sharing via GPO or monitor user activity." `
                    -ISO27001 "8.12" `
                    -NIST80053 "AC-6" `
                    -NISTCSF "PR.DS-5"
}
catch {
    Add-AuditResult -Category "Clipboard Monitor" `
                    -CheckName "Clipboard Content (Snapshot)" `
                    -Value "Error: $_" `
                    -Risk "Low" `
                    -Justification "Clipboard access denied or not available." `
                    -Remediation "Ensure clipboard access is allowed if needed." `
                    -ISO27001 "8.12" `
                    -NIST80053 "AC-6" `
                    -NISTCSF "PR.DS-5"
}