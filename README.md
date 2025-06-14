# Windows_EndPoint_Audit

**Windows_EndPoint_Audit** is a comprehensive PowerShell-based endpoint security auditing toolkit designed to help auditors, blue teamers, and IT administrators evaluate the security posture of Windows machines.

Inspired by the excellent [Seatbelt](https://github.com/GhostPack/Seatbelt) project by GhostPack, this tool offers modular and compliance-mapped auditing capabilities with both non-admin and admin privilege levels.

## 🔍 Features

- Modular checks across 26+ security and configuration areas
- Role-based privilege separation (Non-Admin & Admin modules)
- Outputs in both CSV and styled HTML formats
- Compliance mappings to ISO/IEC 27001:2022, NIST SP 800-53 Rev. 5, and NIST CSF
- Lightweight and OPSEC-safe execution

## 📁 Directory Structure

```
Windows_EndPoint_Audit/
│
├── AuditBelt.ps1                   # Main launcher script
├── modules/                        # Folder containing individual audit modules
├── utils/                          # Helper scripts for exporting results
└── README.md                       # This documentation
```

## 🚀 Usage

```powershell
# Launch with standard user mode
powershell -ExecutionPolicy Bypass -File .\AuditBelt.ps1

# If prompted, choose 'Y' to elevate for admin modules.
```

## 📊 Output

- CSV Report: Saved to `Documents\AuditBelt_Report_<timestamp>.csv`
- HTML Report: Saved to `Documents\AuditBelt_Report_<timestamp>.html`

---

## 📦 Modules Overview

| #  | Module Name                 | Description                                               | Privilege | Mapped Controls |
|----|-----------------------------|-----------------------------------------------------------|-----------|-----------------|
| 01 | UserAccess                  | Checks user privileges and guest/disabled accounts        | Non-Admin | ISO, NIST       |
| 02 | InstalledSoftware           | Lists installed applications                              | Non-Admin | ISO, NIST       |
| 03 | NetworkInfo                 | IP, gateway, interfaces info                              | Non-Admin | ISO, NIST       |
| 04 | DomainInfo                  | Domain/Workgroup membership                               | Non-Admin | ISO, NIST       |
| 05 | LocalGroups                 | Group membership for users                                | Non-Admin | ISO, NIST       |
| 06 | UptimeAndReboots            | System uptime and reboot logs                             | Non-Admin | ISO, NIST       |
| 07 | SystemInfo                  | Hostname, OS version, architecture                        | Non-Admin | ISO, NIST       |
| 08 | PowerShellPolicy            | Execution policy status                                   | Non-Admin | ISO, NIST       |
| 09 | SecurityToolsCheck         | Detect tools like Wireshark, nmap, etc.                   | Non-Admin | ISO, NIST       |
| 10 | RemoteDesktop               | RDP status, SMB shares                                    | Non-Admin | ISO, NIST       |
| 11 | AVStatus                   | Defender status                                            | Admin     | ISO, NIST       |
| 12 | Firewall                   | Windows Firewall profile states                           | Admin     | ISO, NIST       |
| 13 | BitLockerStatus            | BitLocker volume encryption status                        | Admin     | ISO, NIST       |
| 14 | DefenderRealtimeStatus     | Real-time protection of Defender                          | Admin     | ISO, NIST       |
| 15 | UACSettings                | User Access Control configuration                         | Admin     | ISO, NIST       |
| 16 | LSAProtection              | LSASS RunAsPPL check                                      | Admin     | ISO, NIST       |
| 17 | UnsignedDrivers            | Lists unsigned device drivers                             | Admin     | ISO, NIST       |
| 18 | KnownExploitableSoftware   | Detects software with known CVEs                          | Admin     | ISO, NIST       |
| 19 | LogKeywordScan             | Scans security logs for attacker tool signatures          | Admin     | ISO, NIST       |
| 20 | AutoRuns                   | Checks for auto-start entries                             | Admin     | ISO, NIST       |
| 21 | LSASecretsCheck            | Detects LSA secrets exposure risk                         | Admin     | ISO, NIST       |
| 22 | AdminAccountsCheck         | Enumerates users with admin privileges                    | Admin     | ISO, NIST       |
| 23 | AuditPolicyCheck           | Evaluates audit policies                                  | Admin     | ISO, NIST       |
| 24 | ScheduledTasksReview       | Lists suspicious or hidden scheduled tasks                | Admin     | ISO, NIST       |
| 25 | KnownExploitableSoftware   | Detects software like WinRAR, Java8 with CVEs             | Admin     | ISO, NIST       |
| 26 | EventLogKeywordScan        | Searches Event Logs for suspicious keywords               | Admin     | ISO, NIST       |

---

## 📷 Screenshots

![CSV Output](screenshots/sample_csv_output.png)
![HTML Report](screenshots/sample_html_output.png)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

> 🔍 **Disclaimer**: This tool is for authorized auditing and blue teaming only. Do not use it without permission.

## 🙏 Credits

- Inspired by [Seatbelt](https://github.com/GhostPack/Seatbelt) by GhostPack
- Built with 💻 by InfoSec auditors and GRC professionals