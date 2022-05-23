<#
.Synopsis
Detect_ServerlessLAPS.ps1

.DESCRIPTION
* Checks if LAPS Admin User is present
    * If Admin user is present checks if it has password set in the last 15 days (Schedule)
    * If it's not present or the password is not changed in the last 15 days

.NOTES
Created: 26/05/2021
Version: 1.0

Updated: na
Version: na

Author - Alexander Karlsson

Disclaimer:
This script is provided 'AS IS' with no warranties, confers no rights and
is not supported by the author.

#>

# Assets
$Now  = [datetime]::Now
$From = [datetime]::Now.AddDays(-5)
$To   = [datetime]::Now.AddDays(5)

# Compare
## Now between From and To?
$Now -gt $From -and $Now -lt $To

# Variables
$SlapsUser       = 'ALP-Admin'
$TimeSchedule    = [DateTime]::Now.AddDays((-15))


# Check if User exists.
If(Get-LocalUser -Name $SlapsUser -ErrorAction SilentlyContinue) {
    Write-Output "User: $SlapsUser exists"
    $CurrentPasswordSet = [datetime](Get-LocalUser -Name $SlapsUser | Select-Object -ExpandProperty PasswordLastSet)
    Write-Output "$CurrentPasswordSet"
    If($CurrentPasswordSet -le $TimeSchedule) {
        Write-Output "User is present but the password has not been changed since $TimeSchedule. Remediation is needed."
        Exit 1
    }
    Else {
        Write-Output "$SlapsUser exists and password was already run in the last 15 days. No remediation needed."
        Exit 0
    }
}
Else{
    Write-Output "$SlapsUser is not present, will need remediation."
    Exit 1
} 