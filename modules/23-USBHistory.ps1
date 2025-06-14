. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $usbDevices = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\" -ErrorAction SilentlyContinue
    $usbList = $usbDevices.PSChildName
    Add-AuditResult -Category "USB History" `
                    -CheckName "Mounted USB Devices" `
                    -Value ($usbList -join ', ') `
                    -Risk "Medium" `
                    -Justification "USB devices could be used for unauthorized data transfer." `
                    -Remediation "Disable USB ports or implement device control policies." `
                    -ISO27001 "8.11, 8.12" `
                    -NIST80053 "MP-7" `
                    -NISTCSF "PR.DS-3"
}
catch {
    Add-AuditResult -Category "USB History" `
                    -CheckName "Mounted USB Devices" `
                    -Value "Error: $_" `
                    -Risk "Low" `
                    -Justification "Could not retrieve USB history." `
                    -Remediation "Ensure access to registry paths or use alternate tools." `
                    -ISO27001 "8.11" `
                    -NIST80053 "MP-7" `
                    -NISTCSF "PR.DS-3"
}