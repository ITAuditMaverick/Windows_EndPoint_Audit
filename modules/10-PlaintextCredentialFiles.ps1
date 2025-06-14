. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $keywords = "*password*", "*creds*", "*secret*"
    $paths = @("$env:USERPROFILE\Documents", "$env:USERPROFILE\Desktop")
    $matches = foreach ($path in $paths) {
        Get-ChildItem -Path $path -Recurse -Include $keywords -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
    }
    Add-AuditResult -Category "Credentials" `
                    -CheckName "Plaintext Credential Files" `
                    -Value ($matches -join '; ') `
                    -Risk "High" `
                    -Justification "Sensitive files found in user-accessible locations." `
                    -Remediation "Enforce encryption and discourage storing credentials in plaintext." `
                    -ISO27001 "8.12, 8.9" `
                    -NIST80053 "AC-6, SC-12" `
                    -NISTCSF "PR.DS-1"
}
catch {
    Add-AuditResult -Category "Credentials" `
                    -CheckName "Plaintext Credential Files" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Search error encountered." `
                    -Remediation "Ensure script has access rights for scanning user directories." `
                    -ISO27001 "8.9" `
                    -NIST80053 "AC-6" `
                    -NISTCSF "PR.DS-1"
}