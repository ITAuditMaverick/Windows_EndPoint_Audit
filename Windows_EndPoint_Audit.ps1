param ([switch]$AdminMode)

$script:AuditResults = @()

# Set base paths
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulesPath = Join-Path $scriptPath "modules"
$utilsPath = Join-Path $scriptPath "utils"
$reportPath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "AuditBelt"
New-Item -ItemType Directory -Path $reportPath -Force | Out-Null

# Load Add-AuditResult function
. "$utilsPath\Add-AuditResult.ps1"

# Define full list of modules (01 to 26)
$allModules = @(Get-ChildItem -Path $modulesPath -Filter *.ps1 | Sort-Object Name | ForEach-Object { $_.BaseName })

# Separate admin modules (11-26)
$adminModules = $allModules | Where-Object { $_ -match "^(1[1-9]|2[0-6])-" }
$nonAdminModules = $allModules | Where-Object { $_ -match "^(0[1-9]|10)-" }

# Function to run a list of modules
function Run-Modules {
    param ([string[]]$ModuleList)
    foreach ($mod in $ModuleList) {
        $path = "$modulesPath\$mod.ps1"
        if (Test-Path $path) {
            Write-Host "RUN: $mod"
            try {
                . $path
            } catch {
                Write-Host "ERROR running ${mod}:`n$_" -ForegroundColor Red
            }
        } else {
            Write-Warning "Missing module: $mod"
        }
    }
}

# --- Non-admin path ---
if (-not $AdminMode) {
    Run-Modules -ModuleList $nonAdminModules

    # Ask to elevate
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        $answer = Read-Host "Do you want to run advanced checks that require admin privileges? (Y/N)"
        if ($answer -match '^[Yy]') {
            $tempPath = "$env:TEMP\AuditBelt_NonAdmin.json"
            $AuditResults | ConvertTo-Json -Depth 5 | Out-File -Encoding UTF8 -FilePath $tempPath
            Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -AdminMode"
            exit
        }
    }
}

# --- Admin mode: restore old results and run admin modules ---
$tempFile = "$env:TEMP\AuditBelt_NonAdmin.json"
if ($AdminMode -and (Test-Path $tempFile)) {
    $loaded = Get-Content $tempFile | ConvertFrom-Json
    $AuditResults += $loaded
    Remove-Item $tempFile -Force
}

if ($AdminMode) {
    Run-Modules -ModuleList $adminModules
}

# Export results
$dateStr = Get-Date -Format "yyyyMMdd_HHmmss"
$hostName = $env:COMPUTERNAME
$userName = $env:USERNAME
$csvPath = Join-Path $reportPath "AuditBelt_Report_${dateStr}_${hostName}_${userName}.csv"
$htmlPath = $csvPath.Replace(".csv", ".html")

$AuditResults | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
$AuditResults | ConvertTo-Html -Property Category, CheckName, Value, RiskRating, Justification, RecommendedRemediation, ISO27001, NIST80053, NISTCSF `
    -Title "AuditBelt Report - $hostName" | Out-File $htmlPath

Write-Host ""
Write-Host "DONE: Audit complete."
Write-Host "- CSV Report: $csvPath"
Write-Host "- HTML Report: $htmlPath"

if ($AdminMode) {
    Start-Sleep -Seconds 5
}