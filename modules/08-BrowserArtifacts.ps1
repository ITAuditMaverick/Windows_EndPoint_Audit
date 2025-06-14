. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $chromeExtPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions"
    if (Test-Path $chromeExtPath) {
        $exts = Get-ChildItem $chromeExtPath -Recurse -Directory | Select-Object -ExpandProperty Name
        Add-AuditResult -Category "Browser Artifacts" `
                        -CheckName "Chrome Extensions" `
                        -Value ($exts -join ', ') `
                        -Risk "Medium" `
                        -Justification "Potential for data exfiltration or misuse through browser extensions." `
                        -Remediation "Review and restrict unauthorized extensions." `
                        -ISO27001 "5.11" `
                        -NIST80053 "SI-4" `
                        -NISTCSF "PR.DS-5"
    }
    else {
        Add-AuditResult -Category "Browser Artifacts" `
                        -CheckName "Chrome Extensions" `
                        -Value "Not Found" `
                        -Risk "Low" `
                        -Justification "Chrome path not found, assuming not in use." `
                        -Remediation "None required unless Chrome is used corporately." `
                        -ISO27001 "5.11" `
                        -NIST80053 "SI-4" `
                        -NISTCSF "PR.DS-5"
    }
}
catch {
    Add-AuditResult -Category "Browser Artifacts" `
                    -CheckName "Chrome Extensions" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not scan for browser extensions." `
                    -Remediation "Review browser configuration and permissions." `
                    -ISO27001 "5.11" `
                    -NIST80053 "SI-4" `
                    -NISTCSF "PR.DS-5"
}