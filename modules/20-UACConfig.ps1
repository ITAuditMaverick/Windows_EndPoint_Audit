. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $uac = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System"
    $value = $uac.ConsentPromptBehaviorAdmin

    if ($value -eq 0) {
        $risk = "High"
    } else {
        $risk = "Low"
    }

    Add-AuditResult -Category "UAC Configuration" `
                    -CheckName "Consent Prompt Behavior" `
                    -Value $value `
                    -Risk $risk `
                    -Justification "UAC settings affect privilege elevation and security prompts." `
                    -Remediation "Ensure UAC settings are aligned with organizational security policy." `
                    -ISO27001 "5.15, 8.7" `
                    -NIST80053 "AC-6" `
                    -NISTCSF "PR.AC-1"
}
catch {
    Add-AuditResult -Category "UAC Configuration" `
                    -CheckName "Consent Prompt Behavior" `
                    -Value "Error: $_" `
                    -Risk "Medium" `
                    -Justification "Unable to access UAC registry settings." `
                    -Remediation "Run script with administrative privileges." `
                    -ISO27001 "5.15" `
                    -NIST80053 "AC-6" `
                    -NISTCSF "PR.AC-1"
}
