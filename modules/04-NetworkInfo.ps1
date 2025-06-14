. "$PSScriptRoot\\..\\utils\\Add-AuditResult.ps1"

try {
    Write-Host "Collecting Network Information..." -ForegroundColor Cyan

    $ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
        $_.IPAddress -ne $null -and $_.ValidLifetime -gt 0
    }

    if ($ipAddresses) {
        foreach ($ip in $ipAddresses) {
            $value = "Interface: $($ip.InterfaceAlias); IP: $($ip.IPAddress); Index: $($ip.InterfaceIndex); Prefix: $($ip.PrefixLength);"
            Add-AuditResult -Category "Network Info" `
                            -CheckName "Interface $($ip.InterfaceAlias)" `
                            -Value $value `
                            -Risk "Low" `
                            -Justification "Active IPv4 address found on $($ip.InterfaceAlias)." `
                            -Remediation "None required unless misconfigured." `
                            -ISO27001 "8.20" `
                            -NIST80053 "SC-7" `
                            -NISTCSF "PR.AC-4"
        }
    } else {
        Add-AuditResult -Category "Network Info" `
                        -CheckName "Active IPv4 Interfaces" `
                        -Value "None found" `
                        -Risk "Medium" `
                        -Justification "No active IPv4 address detected." `
                        -Remediation "Verify network configuration." `
                        -ISO27001 "8.20" `
                        -NIST80053 "SC-7" `
                        -NISTCSF "PR.AC-4"
    }

    # Optional: summarize adapter info in HTML report
    $adapters = Get-NetAdapter | Select-Object Name, Status, MacAddress, InterfaceDescription
    $adapterSummary = ($adapters | ForEach-Object { "$($_.Name) - $($_.Status) - $($_.MacAddress)" }) -join "; "
    Add-AuditResult -Category "Network Info" `
                    -CheckName "Network Interfaces Summary" `
                    -Value $adapterSummary `
                    -Risk "Low" `
                    -Justification "Interface list helps identify physical/logical connectivity." `
                    -Remediation "Check for unused/disabled adapters." `
                    -ISO27001 "8.20" `
                    -NIST80053 "CM-8" `
                    -NISTCSF "ID.AM-1"
}
catch {
    Add-AuditResult -Category "Network Info" `
                    -CheckName "Network Configuration" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Error retrieving network configuration." `
                    -Remediation "Ensure PowerShell network cmdlets are supported on this system." `
                    -ISO27001 "8.20" `
                    -NIST80053 "SC-7" `
                    -NISTCSF "PR.AC-4"
}
