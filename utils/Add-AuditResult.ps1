function Add-AuditResult {
    param (
        [string]$Category,
        [string]$CheckName,
        [string]$Value,
        [string]$Risk,
        [string]$Justification,
        [string]$Remediation,
        [string]$ISO27001,
        [string]$NIST80053,
        [string]$NISTCSF
    )

    $script:AuditResults += [PSCustomObject]@{
        Category               = $Category
        CheckName              = $CheckName
        Value                  = $Value
        RiskRating             = $Risk
        Justification          = $Justification
        RecommendedRemediation= $Remediation
        ISO27001               = $ISO27001
        NIST80053              = $NIST80053
        NISTCSF                = $NISTCSF
    }
}