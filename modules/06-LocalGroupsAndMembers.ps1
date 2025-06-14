. "$PSScriptRoot\..\utils\Add-AuditResult.ps1"

try {
    $groups = Get-LocalGroup | Select-Object -ExpandProperty Name
    foreach ($group in $groups) {
        $members = (Get-LocalGroupMember -Group $group | Select-Object -ExpandProperty Name) -join ', '
        Add-AuditResult -Category "Local Groups" `
                        -CheckName "$group Members" `
                        -Value "$members" `
                        -Risk "Low" `
                        -Justification "Group membership data retrieved." `
                        -Remediation "Review group memberships for excessive privileges." `
                        -ISO27001 "5.18" `
                        -NIST80053 "AC-2" `
                        -NISTCSF "PR.AC-4"
    }
}
catch {
    Add-AuditResult -Category "Local Groups" `
                    -CheckName "Local Group Enumeration" `
                    -Value "Error: $_" `
                    -Risk "High" `
                    -Justification "Failed to retrieve group membership." `
                    -Remediation "Verify access to group information." `
                    -ISO27001 "5.18" `
                    -NIST80053 "AC-2" `
                    -NISTCSF "PR.AC-4"
}