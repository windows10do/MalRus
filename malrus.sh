#!/data/data/com.termux/files/usr/bin/bash
# MalRus - Antivirus-style scanner with dialog UI, logging, quarantine, full scan checklist, and contacts scan

LOGDIR="$HOME/malrus_logs"
LOGFILE="$LOGDIR/scan.log"
QUARANTINE="$HOME/malrus_quarantine"

mkdir -p "$LOGDIR" "$QUARANTINE"

SUSPICIOUS_EXT=("exe" "scr" "bat" "sh" "bash" "tmp" "bin")
BAD_HASHES=("44d88612fea8a8f36de82e1278abb02f") # EICAR test file MD5

RESULTS=""
COUNT=1

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOGFILE"
}

scan_file() {
    local file="$1"
    local md5
    md5=$(md5sum "$file" 2>/dev/null | awk '{print $1}')

    for bad in "${BAD_HASHES[@]}"; do
        if [[ "$md5" == "$bad" ]]; then
            RESULTS+=$'\n'"[MalRus] Known malware detected: $file"
            log "Known malware detected: $file"
            return
        fi
    done

    for ext in "${SUSPICIOUS_EXT[@]}"; do
        if [[ "$file" == *.$ext ]]; then
            RESULTS+=$'\n'"[MalRus] Suspicious file type: $file"
            log "Suspicious file type: $file"
            return
        fi
    done
}

scan_dir() {
    local dir="$1"
    find "$dir" -type f 2>/dev/null | while read -r file; do
        scan_file "$file"
    done
}

virus_lab() {
    local dir="$1"
    local renamed=""
    find "$dir" -type f 2>/dev/null | while read -r file; do
        local md5
        md5=$(md5sum "$file" 2>/dev/null | awk '{print $1}')
        local flagged=false

        for bad in "${BAD_HASHES[@]}"; do
            [[ "$md5" == "$bad" ]] && flagged=true
        done
        for ext in "${SUSPICIOUS_EXT[@]}"; do
            [[ "$file" == *.$ext ]] && flagged=true
        done

        if [[ "$flagged" == true ]]; then
            local baseext="${file##*.}"
            local newname="$QUARANTINE/do_not_run_${COUNT}.${baseext}"
            mv "$file" "$newname" 2>/dev/null
            renamed+=$'\n'"Quarantined: $file -> $newname"
            log "Virus Lab quarantined: $file -> $newname"
            COUNT=$((COUNT+1))
        fi
    done

    if [[ -z "$renamed" ]]; then
        dialog --msgbox "Virus Lab: No files quarantined." 8 50
    else
        dialog --msgbox "Virus Lab results:\n$renamed" 20 70
    fi
}

scan_contacts() {
    log "Scanning contacts for spam..."
    local contacts
    contacts=$(termux-content query contacts 2>/dev/null)

    if [[ -z "$contacts" ]]; then
        RESULTS+=$'\n'"[MalRus] No contacts found or permission denied."
        log "Contacts scan failed (no data)."
        return
    fi

    # Look for suspicious entries (names containing 'spam')
    local flagged=""
    flagged=$(echo "$contacts" | grep -i "spam")

    if [[ -n "$flagged" ]]; then
        RESULTS+=$'\n'"[MalRus] Suspicious contacts detected:\n$flagged"
        log "Suspicious contacts detected."
    else
        RESULTS+=$'\n'"[MalRus] No suspicious contacts found."
        log "Contacts scan clean."
    fi
}

full_scan_checklist() {
    CHOICES=$(dialog --stdout --checklist "Select sources to scan:" 15 60 5 \
        1 "Scan from SD card" off \
        2 "Scan spam contacts from Contacts" off \
        3 "Scan from USB" off \
        4 "Do all" off)

    RESULTS=""
    log "Starting full scan checklist..."

    for choice in $CHOICES; do
        case $choice in
            1)
                [[ -d "/sdcard" ]] && { log "Scanning /sdcard"; scan_dir "/sdcard"; }
                ;;
            2)
                scan_contacts
                ;;
            3)
                [[ -d "/storage/usb" ]] && { log "Scanning /storage/usb"; scan_dir "/storage/usb"; }
                ;;
            4)
                log "Do all selected"
                scan_dir "/storage/emulated/0/"
                [[ -d "/sdcard" ]] && scan_dir "/sdcard"
                [[ -d "/storage/usb" ]] && scan_dir "/storage/usb"
                scan_dir "$HOME"
                scan_contacts
                ;;
        esac
    done

    log "Full scan checklist complete."
    if [[ -z "$RESULTS" ]]; then
        dialog --msgbox "Checklist scan complete. No suspicious files found." 8 50
    else
        dialog --msgbox "Checklist scan results:\n$RESULTS" 20 70
    fi
}

while true; do
    CHOICE=$(dialog --stdout --title "MalRus Antivirus" --menu "Choose an option:" 18 60 8 \
        1 "Scan directory" \
        2 "View last results" \
        3 "Quit" \
        4 "Virus Lab (quarantine flagged files)" \
        5 "Full Scan (all storage)" \
        6 "View log file" \
        7 "View quarantine folder" \
        8 "Full Scan Checklist")

    case $CHOICE in
        1)
            DIR=$(dialog --stdout --title "Scan" --inputbox "Enter directory to scan:" 8 40)
            if [[ -n "$DIR" ]]; then
                RESULTS=""
                log "Scanning directory: $DIR"
                scan_dir "$DIR"
                if [[ -z "$RESULTS" ]]; then
                    dialog --msgbox "Scan complete. No suspicious files found." 8 50
                else
                    dialog --msgbox "Scan results:\n$RESULTS" 20 70
                fi
                log "Scan finished for: $DIR"
            fi
            ;;
        2)
            if [[ -z "$RESULTS" ]]; then
                dialog --msgbox "No results yet. Run a scan first." 8 50
            else
                dialog --msgbox "Last results:\n$RESULTS" 20 70
            fi
            ;;
        3)
            clear
            exit 0
            ;;
        4)
            DIR=$(dialog --stdout --title "Virus Lab" --inputbox "Enter directory to process:" 8 40)
            if [[ -n "$DIR" ]]; then
                log "Virus Lab processing: $DIR"
                virus_lab "$DIR"
                log "Virus Lab finished for: $DIR"
            fi
            ;;
        5)
            dialog --msgbox "Starting full scan. This may take several hours..." 8 50
            RESULTS=""
            log "Starting full scan..."
            scan_dir "/storage/emulated/0/"
            [[ -d "/sdcard" ]] && scan_dir "/sdcard"
            [[ -d "/storage/usb" ]] && scan_dir "/storage/usb"
            scan_dir "$HOME"
            scan_contacts
            log "Full scan complete."
            if [[ -z "$RESULTS" ]]; then
                dialog --msgbox "Full scan complete. No suspicious files found." 8 50
            else
                dialog --msgbox "Full scan results:\n$RESULTS" 20 70
            fi
            ;;
        6)
            if [[ -s "$LOGFILE" ]]; then
                dialog --textbox "$LOGFILE" 20 70
            else
                dialog --msgbox "Log file is empty." 8 50
            fi
            ;;
        7)
            if [[ -d "$QUARANTINE" ]]; then
                ls "$QUARANTINE" > /tmp/malrus_quarantine.txt
                dialog --textbox /tmp/malrus_quarantine.txt 20 70
            else
                dialog --msgbox "Quarantine folder is empty." 8 50
            fi
            ;;
        8)
            full_scan_checklist
            ;;
    esac
done
