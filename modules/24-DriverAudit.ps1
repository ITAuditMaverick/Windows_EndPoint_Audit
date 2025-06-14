. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $drivers = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DriverProviderName -ne $null }
    $unsigned = $drivers | Where-Object { $_.IsSigned -eq $false } | Select-Object -ExpandProperty DeviceName

    if ($unsigned.Count -gt 0) {
        $risk = "High"
    } else {
        $risk = "Low"
    }

    Add-AuditResult -Category "Drivers" `
                    -CheckName "Unsigned Drivers" `
                    -Value ($unsigned -join ', ') `
                    -Risk $risk `
                    -Justification "Unsigned drivers may be malicious or untrusted." `
                    -Remediation "Remove or replace unsigned drivers." `
                    -ISO27001 "5.35" `
                    -NIST80053 "SI-7" `
                    -NISTCSF "PR.IP-1"
}
catch {
    Add-AuditResult -Category "Drivers" `
                    -CheckName "Unsigned Drivers" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Driver inspection failed." `
                    -Remediation "Verify WMI functionality and elevated rights." `
                    -ISO27001 "5.35" `
                    -NIST80053 "SI-7" `
                    -NISTCSF "PR.IP-1"
}
