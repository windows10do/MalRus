# MalRus Antivirus for Termux

MalRus is a lightweight, Bash-based antivirus-style scanner designed for Android (via Termux).  
It scans common storage locations, flags suspicious files, quarantines them safely, and provides an interactive UI using the dialog package.

---

## Features

- Suspicious file detection  
  Flags files with risky extensions like `.exe`, `.scr`, `.bat`, `.sh`, `.bash`, `.tmp`, `.bin` or known bad hashes (EICAR test file included).

- Interactive UI  
  Uses Termux’s dialog package for menus, checklists, and message boxes.

- Virus Lab  
  Quarantines flagged files by renaming them to `do_not_run_nnn.ext` and moving them into `~/malrus_quarantine`.

- Full Scan  
  Crawls `/storage/emulated/0/`, `/sdcard/` (if present), `/storage/usb/` (if present), and `$HOME`.  
  Includes a checklist mode to select sources (SD card, USB, contacts, or all).

- Contacts Scan  
  Integrates with Termux’s content provider to detect suspicious contacts (e.g., names containing `spam`).

- Logging  
  All actions are logged with timestamps in `~/malrus_logs/scan.log`.

- Quarantine Management  
  View quarantined files directly from the menu.

---

## Installation

1. Install Termux and required packages:  
   `pkg install bash dialog git gh`

2. Clone the repository:  
   `gh repo clone windows10do/MalRus`  
   `cd MalRus`

3. Make the script executable:  
   `chmod +x malrus.sh`

4. (Optional) Install globally:  
   `mkdir -p ~/bin`  
   `cp malrus.sh ~/bin/malrus`  
   `echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc`  
   `source ~/.bashrc`

---

## Usage

Run MalRus:  
`bash malrus.sh`  
or, if installed globally:  
`malrus`

Menu options:  
1. Scan directory  
2. View last results  
3. Quit  
4. Virus Lab (quarantine flagged files)  
5. Full Scan (all storage)  
6. View log file  
7. View quarantine folder  
8. Full Scan Checklist  

---

## Quarantine & Restore

- Quarantined files are moved to `~/malrus_quarantine` and renamed `do_not_run_nnn.ext`.  
- You can inspect them safely or restore manually if needed.

---

## Notes

- Contacts scanning requires Termux permissions:  
  `termux-setup-storage`  
  `termux-content query contacts`

- Full scans may take several hours depending on storage size.  
- MalRus is a prototype utility — extend it with more signatures, smarter heuristics, or integration with ClamAV for production use.

---

## License

MIT License. Free to use, modify, and share.
