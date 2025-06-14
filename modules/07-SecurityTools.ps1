. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $keywords = @("wireshark", "processhacker", "metasploit", "nmap", "fiddler")
    $installed = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -and ($keywords | Where-Object { $_ -and $_.ToLower() -in $_.DisplayName.ToLower() })
        } |
        Select-Object -ExpandProperty DisplayName

    $value = if ($installed) { $installed -join ', ' } else { "None Detected" }

    Add-AuditResult -Category "Security Tools" `
                    -CheckName "Potential Hacking/Debug Tools" `
                    -Value $value `
                    -Risk (if ($installed.Count -gt 0) { "Medium" } else { "Low" }) `
                    -Justification "Presence of known tools may indicate potential misuse or post-exploitation activity." `
                    -Remediation "Verify legitimate use or remove unauthorized tools." `
                    -ISO27001 "5.10, 5.35" `
                    -NIST80053 "CM-7" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "Security Tools" `
                    -CheckName "Tool Detection" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not query installed tools." `
                    -Remediation "Run script as administrator and ensure registry access." `
                    -ISO27001 "5.10" `
                    -NIST80053 "CM-7" `
                    -NISTCSF "PR.IP-1"
}
