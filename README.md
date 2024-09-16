# Ransomware Simulation Script

Welcome to the **Ransomware Simulation** project! This PowerShell script is designed to simulate the behavior of ransomware in a controlled, virtual environment. It mimics basic ransomware techniques like file encryption (content reversal), renaming files, persistence mechanisms, and leaving a ransom note on the user's desktop. This tool is intended for educational purposes, testing, and research on cybersecurity solutions like endpoint detection and response (EDR) tools.

## ⚠️ Disclaimer ⚠️

**Important: This simulation is to be executed in a secure and isolated virtual machine (VM) environment only. Running this script on a physical machine or within a production network is strictly prohibited.**

We take no responsibility for any damage, data loss, or disruptions that may occur as a result of running this simulation. It is your responsibility to ensure the simulation is executed in a safe environment.

## Features

- **Simulated File Encryption**: Files in the `Documents` directory (including hidden files and subdirectories) are "encrypted" by reversing their content and renaming them with random strings and a `.enc` extension.
  
- **Ransom Note**: A ransom note is generated on the user's desktop, mimicking the behavior of real-world ransomware.

- **Persistence Techniques**: The script implements common persistence techniques, including:
  - **Registry Run Keys (T1547.001)**: A registry entry is added to ensure persistence.
  - **Startup Folder (T1547.001)**: A payload is dropped in the startup folder to run at user login.
  - **Scheduled Task (T1053)**: A scheduled task is created to maintain persistence even after system reboots.

- **Hidden Files and Directories**: The script also targets hidden files and directories within the `Documents` folder, simulating a more thorough ransomware attack.

## Requirements

- **PowerShell 5.0+**
- **Administrator Privileges**: The script requires PowerShell to be run with admin rights to create registry entries, scheduled tasks, and modify files in restricted directories.

## Usage Instructions

1. Clone or download this repository to your isolated virtual machine.
   
2. Open PowerShell as **Administrator**:
   - Right-click the Start Menu and select **Windows PowerShell (Admin)**.
  
   - Run the script:

powershell

    ./CanaryCrypt.ps1

    Review the disclaimer and type **I AGREE** to confirm that you are executing the simulation in a safe, controlled environment.

    Observe the encryption simulation, file renaming, and creation of persistence mechanisms.

Important Notes

    Virtual Machine Only: Ensure you are running this in a fully isolated virtual machine to avoid any unintended disruptions.
    Monitoring Tools: Use cybersecurity monitoring tools (such as EDR solutions, or similar) to observe the changes made by the script, which could trigger alerts.
    Restoration: The script does not provide automatic file restoration. Make sure you have backups of any files used in the simulation environment.

Contribution

Feel free to fork this repository, make modifications, or report any issues. This project is intended for educational purposes and should be treated with responsibility.



