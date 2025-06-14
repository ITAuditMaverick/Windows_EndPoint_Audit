. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    $pplStatus = Get-ItemProperty -Path $regPath -Name "RunAsPPL" -ErrorAction SilentlyContinue
    $isProtected = if ($pplStatus.RunAsPPL -eq 1) { "Enabled" } else { "Disabled" }

    if ($isProtected -eq "Disabled") {
        $risk = "High"
    } else {
        $risk = "Low"
    }

    Add-AuditResult -Category "LSASS Protection" `
                    -CheckName "RunAsPPL Status" `
                    -Value $isProtected `
                    -Risk $risk `
                    -Justification "LSASS memory protection prevents credential dumping." `
                    -Remediation "Enable RunAsPPL to harden credential access." `
                    -ISO27001 "8.10" `
                    -NIST80053 "SC-28" `
                    -NISTCSF "PR.DS-5"
}
catch {
    Add-AuditResult -Category "LSASS Protection" `
                    -CheckName "RunAsPPL Status" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Could not determine LSASS protection." `
                    -Remediation "Check registry access and privilege level." `
                    -ISO27001 "8.10" `
                    -NIST80053 "SC-28" `
                    -NISTCSF "PR.DS-5"
}
