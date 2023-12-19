#!/bin/bash

CONFIG_FILE="./config_modules"
MODULES_DIR="./modules"
# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    #ask for privilege escalation
    whiptail --backtitle "Hardening as Code Project v1" --title "Privilege Escalation" --msgbox "This script requires root privileges. Please run as root." 10 60
    # use pkuth to escalate privileges
    sudo "$0"
    exit

fi


log_warning() {
    echo "$(tput setaf 3)[WARN] $1 $(tput sgr0)"
}
log_error() {
    echo "$(tput setaf 1)[ERROR] $1 $(tput sgr0)"
}
main_menu() {
    system_details="System Details:\n - OS: $(lsb_release -si)\n - Kernel: $(uname -r)\n - Architecture: $(uname -m)\n - Hostname: $(hostname)\n - IP Address: $(hostname -I | awk '{print $1}')"
    mode=$(whiptail --backtitle "Hardening as Code Project v1 - @Eljakani" --title "Main Menu" --menu "$system_details\n\nChoose your option" 20 60 4 \
    "EV" "> Evaluate System" \
    "HA" "> Harden System"\
    "HELP" "> More Info on Modules" 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus -eq 0 ]; then
    if [ "$mode" == "EV" ]; then
        # evaluate system
        evaluate_system
        main_menu
    elif [ "$mode" == "HA" ]; then
        # harden system
        harden_system
        main_menu
    elif [ "$mode" == "HELP" ]; then
        # Show all modules as menu and show description of selected module
        module=$(whiptail --title "Select Module" --menu "Choose your option" 15 60 4 \
        "${modules[@]}" 3>&1 1>&2 2>&3)
        exitstatus=$?
        if [ $exitstatus -eq 0 ]; then
            description=$(./modules/$module.sh "HELP")
            whiptail --backtitle "Hardening as Code Project v1" --title "Module Description" --msgbox "$description" 15 60
            main_menu
        else
            log_warning "User cancelled"
        fi
    else
        log_error "Invalid mode"
    fi
else
    log_warning "User cancelled"
fi
}

evaluate_system() {
    local title="Evaluating System"
    local description="Please wait while evaluating system..."
    local progress=0

    mode="EV"
    accu_score=0
    success=0
    #iterate over modules and execute them with appropriate mode, if module exits with 0, add score to total score
    for (( i=0; i<${#modules[@]}; i+=2 )); do
        module_name=${modules[$i]}
        module_score=${modules[$i+1]}
        if [ -f "$MODULES_DIR/$module_name.sh" ] && [ -x "$MODULES_DIR/$module_name.sh" ]; then
            "$MODULES_DIR/$module_name.sh" "$mode"
            if [ $? -eq 0 ]; then
                accu_score=$((accu_score + module_score))
                success=$((success + 1))
            fi
        else
            log_warning "Module not found: $module_name"
        fi
        sleep 0.5
        progress=$(((i + 1) * 100 / ${#modules[@]}))
        echo $module_name 
        echo $progress | whiptail --gauge "$description" 10 50 $progress
    done
    score=$((accu_score * 100 / totale_score))
    
    whiptail --backtitle "Hardening as Code Project v1" --title "Evaluation Report" --msgbox "Evaluation Report:\n\nScore: $score%\n - Successful Checks: $success\n - Failed Checks: $((${#modules[@]} / 2 - success))" 15 60
}

harden_system() {
    sleep 5
    report="Hardening Report:\n - Successful hardening steps\n - Errors encountered during hardening"
    score=90 
}


# Disclaimer
whiptail --backtitle "Hardening as Code Project v1" --title "Disclaimer" --msgbox "This script is provided as-is without warranty of any kind and is intended for educational purposes only. \n\nThe author will not be held liable for any damages arising from the use of this script. \n\nUse at your own risk. \n\nPress OK to continue.\n\nCredits: @Eljakani" 15 60

# Load All Modules
modules=()
totale_score=0
progress=0
total_modules=$(wc -l < "$CONFIG_FILE")

while IFS= read -r line || [[ -n "$line" ]]; do
    module_name=$(echo "$line" | cut -d' ' -f1)
    module_score=$(echo "$line" | cut -d' ' -f2)

    if [ -z "$module_score" ]; then
        module_score=2
        log_warning "Module score not provided for: $module_name. Setting default score to 2."
    fi

    if [ -f "$MODULES_DIR/$module_name.sh" ] && [ -x "$MODULES_DIR/$module_name.sh" ]; then
        modules+=("$module_name" "$module_score")
        totale_score=$((totale_score + module_score))
    elif [ -f "$MODULES_DIR/$module_name.sh" ] && [ ! -x "$MODULES_DIR/$module_name.sh" ]; then
        log_warning "Module not executable: $module_name, changing permissions..."
        chmod +x "$MODULES_DIR/$module_name.sh"
        modules+=("$module_name" "$module_score")
        totale_score=$((totale_score + module_score))
    else
        log_warning "Module not found or not executable: $module_name"
    fi

    progress=$((progress + 1))
    echo $((progress * 100 / total_modules)) | whiptail --gauge "Loading Modules..." 10 50 $((progress * 100 / total_modules))
    sleep 0.5
done < "$CONFIG_FILE"


# Number of modules
whiptail --backtitle "Hardening as Code Project v1" --title "Modules Loaded" --msgbox "Loaded $((${#modules[@]} / 2)) modules" 10 60

main_menu