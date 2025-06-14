. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $policy = AuditPol /get /category:* | Out-String
    Add-AuditResult -Category "Audit Policy" `
                    -CheckName "Audit Policy Settings" `
                    -Value ($policy.Substring(0, [Math]::Min(300, $policy.Length))) `
                    -Risk "Medium" `
                    -Justification "Audit policy provides logs for accountability and detection." `
                    -Remediation "Configure audit policy as per organization's incident monitoring guidelines." `
                    -ISO27001 "5.10, 8.15" `
                    -NIST80053 "AU-2, AU-12" `
                    -NISTCSF "DE.AE-3"
}
catch {
    Add-AuditResult -Category "Audit Policy" `
                    -CheckName "Audit Policy Settings" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Audit policy could not be retrieved." `
                    -Remediation "Ensure access to 'AuditPol' tool and admin rights." `
                    -ISO27001 "5.10" `
                    -NIST80053 "AU-2" `
                    -NISTCSF "DE.AE-3"
}