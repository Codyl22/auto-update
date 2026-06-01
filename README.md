# auto-update
Linux operating system update script


A robust, intelligent, and interactive Bash script designed to automatically update your Linux distributions (Fedora, Ubuntu/Debian, Arch Linux) as well as your universal packages (Flatpak, Snap).

---

##  Features

* ** Automatic Bilingual Support:** Automatically and silently detects your system language (French/English) right at startup.
* ** Root Security:** Instantly verifies administrator privileges before executing any commands.
* ** Self-Update:** The script checks GitHub to see if a newer version is available. If so, it updates and restarts itself automatically!
* ** Universal Detection:** Automatically identifies your package manager (`dnf`, `apt`, or `pacman`).
* ** Interactive Mode:** Lists all available updates and lets the user choose whether to confirm or cancel.
* ** Modern Apps:** Seamlessly detects and updates **Flatpak** and **Snap** environments if they are installed on the system.

---

##  Installation & Usage

### 1. Clone the repository
```bash
git clone [https://github.com/Codyl22/YOUR_REPO_NAME.git](https://github.com/Codyl22/YOUR_REPO_NAME.git)
cd YOUR_REPO_NAME

### 2. Make the script excecutable
```bash
chmod +x auto-update.sh

### 3. Run the script
To excetute the script with the required administrative privileges :
```bash
sudo ./auto-update.sh

## Project Struture
auto-update.sh : The main Bash script containing all the logic
README.md : The documentation you are currenty reading.

## How It Works Under the Hood
Privileges: The script ensures that the user ID ($EUID) equals 0.

Self-Update: It performs a silent git fetch and compares the LOCAL and REMOTE hashes. If a difference is found, it pulls the new code and uses exec to restart itself.

Distribution: It checks for the presence of package manager binaries using command -v.

Updates: It triggers the standard update command for your OS, intentionally omitting the auto-validation flag to leave full control to the user.
