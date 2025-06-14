. "$PSScriptRoot\\..\\utils\\Add-AuditResult.ps1"

try {
    $bitlocker = Get-BitLockerVolume

    foreach ($vol in $bitlocker) {
        $protection = $vol.ProtectionStatus

        # Normalize ProtectionStatus (it may be numeric or descriptive string depending on system)
        if ($protection -eq 0 -or $protection -eq "Off") {
            $risk = "High"
        } else {
            $risk = "Low"
        }

        $value = "Encryption: $protection"

        Add-AuditResult -Category "BitLocker" `
                        -CheckName "BitLocker Status ($($vol.MountPoint))" `
                        -Value $value `
                        -Risk $risk `
                        -Justification "Disk encryption prevents data leakage on lost or stolen devices." `
                        -Remediation "Enable BitLocker with TPM support and recovery key management." `
                        -ISO27001 "8.10" `
                        -NIST80053 "SC-12, SC-28" `
                        -NISTCSF "PR.DS-1"
    }
}
catch {
    Add-AuditResult -Category "BitLocker" `
                    -CheckName "BitLocker Status" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Failed to determine BitLocker status." `
                    -Remediation "Verify TPM and BitLocker availability and permissions." `
                    -ISO27001 "8.10" `
                    -NIST80053 "SC-12" `
                    -NISTCSF "PR.DS-1"
}
