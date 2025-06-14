. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $services = Get-CimInstance -ClassName Win32_Service | Where-Object { $_.StartMode -eq "Auto" }
    $serviceNames = $services | Select-Object -ExpandProperty Name
    Add-AuditResult -Category "Startup Services" `
                    -CheckName "Auto-start Services" `
                    -Value ($serviceNames -join ', ') `
                    -Risk "Medium" `
                    -Justification "Unnecessary auto-start services increase attack surface." `
                    -Remediation "Disable unused or unverified auto-run services." `
                    -ISO27001 "5.10, 5.35" `
                    -NIST80053 "CM-7" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "Startup Services" `
                    -CheckName "Auto-start Services" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Startup services enumeration failed." `
                    -Remediation "Verify WMI service and CIM access." `
                    -ISO27001 "5.10" `
                    -NIST80053 "CM-7" `
                    -NISTCSF "PR.IP-1"
}