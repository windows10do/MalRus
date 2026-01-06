# MalRus Antivirus for Termux

MalRus is a lightweight, Bash-based antivirus-style scanner designed for Android (via Termux).  
It scans common storage locations, flags suspicious files, quarantines them safely, and provides an interactive UI using the `dialog` package.

---

## Features

- Suspicious file detection  
- Interactive UI with `dialog`  
- Virus Lab quarantine system  
- Full Scan with checklist (SD card, USB, contacts, all)  
- Contacts scan via Termux `content` provider  
- Logging system with timestamps  
- Quarantine management  

---

## Installation

> [!TIP]
> 
> Make sure Termux has storage permissions enabled before running MalRus.

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

> [!IMPORTANT]
> 
> Full scans may take several hours depending on storage size. Run them when your device is idle.

---

## Quarantine & Restore

- Quarantined files are moved to `~/malrus_quarantine` and renamed `do_not_run_nnn.ext`.  
- You can inspect them safely or restore manually if needed.

> [!CAUTION]
> 
> Restoring quarantined files may re‑introduce malware. Only restore if you are certain the file is safe.

---

## Notes

> [!NOTE]
> 
> MalRus is experimental and intended for educational use. It is **not** a replacement for a professional antivirus engine.

> [!CAUTION]
> 
> Contacts scanning requires Termux permissions. Without them, MalRus cannot access your contacts.

> [!TIP]
> 
> Example command to run a full scan with checklist:  
> `bash malrus.sh` → choose option 8 → tick “Do all”

> [!NOTE]
> 
> If you see “No suspicious files found” after a scan, your storage is clean.

> [!WARNING]
> 
> If MalRus cannot access `/storage/usb`, ensure your USB drive is mounted properly.

> [!TIP]
> 
> Want to extend MalRus? Add more suspicious file signatures in the `SUSPICIOUS_EXT` array.

> [!NOTE]
> 
> Contributions are welcome — fork the repo and submit pull requests.

---

## License

MIT License. Free to use, modify, and share.
