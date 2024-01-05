#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    # Ask for privilege escalation
    whiptail --backtitle "Hardening as Code Project v1" --title "Privilege Escalation" --msgbox "This script requires root privileges. Please run as root." 10 60
    # Use pkuth to escalate privileges
    sudo "$0"
    exit
fi



MODULES_FILE="$(pwd)/modules.sh"
MODULES_DIR="$(pwd)/modules"
REPORTS_DIR="$(pwd)/reports"

source "$MODULES_FILE"

create_report() {
    local mode="$1"
    if [ ! -d "$REPORTS_DIR" ]; then
        mkdir "$REPORTS_DIR"
    fi
    report_file="$REPORTS_DIR/$(date +%Y-%m-%d_%H-%M-%S).txt"
    if ! command -v figlet &> /dev/null; then
        apt-get install -y figlet > /dev/null
    fi
    figlet -f slant "HaC" > "$report_file"
    echo "HaC Project v1" >> "$report_file"
    echo "Github: https://github.com/Eljakani/HaC" >> "$report_file"
    echo "Mode: $mode" >> "$report_file"
    echo "Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "$report_file"
    echo "----------------------------------------" >> "$report_file"
    echo "System Details:" >> "$report_file"
    echo " -> OS: $(lsb_release -si)" >> "$report_file"
    echo " -> Kernel: $(uname -r)" >> "$report_file"
    echo " -> Architecture: $(uname -m)" >> "$report_file"
    echo " -> Hostname: $(hostname)" >> "$report_file"
    echo " -> IP Address: $(hostname -I | awk '{print $1}')" >> "$report_file"
    echo "----------------------------------------" >> "$report_file"
    echo "Evaluation Results:" >> "$report_file"
    echo "$report_file"
}

confirm_exit() {
    if (whiptail --backtitle "Hardening as Code Project v1" --title "Confirm Exit" --yesno "Are you sure you want to exit?" 10 60) then
        log_warning "User cancelled"
        exit 1
    fi
}

log_warning() {
    echo "$(tput setaf 3)[WARN] $1 $(tput sgr0)"
}

log_error() {
    echo "$(tput setaf 1)[ERROR] $1 $(tput sgr0)"
}

log_success() {
    echo "$(tput setaf 2)[SUCCESS] $1 $(tput sgr0)"
}

main_menu() {
    system_details="System Details:\n - OS: $(lsb_release -si)\n - Kernel: $(uname -r)\n - Architecture: $(uname -m)\n - Hostname: $(hostname)\n - IP Address: $(hostname -I | awk '{print $1}')"
    mode=$(whiptail --backtitle "Hardening as Code Project v1 - @Eljakani" --title "Main Menu" --menu "$system_details\n\nChoose your option" 20 60 4 \
    "EV" "> Evaluate System" \
    "HA" "> Harden System"\
    "RUN" "> Run Selected Module"\
    "HELP" "> More Info on Modules" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus -eq 0 ]; then
        if [ "$mode" == "EV" ]; then
            # Evaluate system
            report_file=$(create_report "Evaluation")
            evaluate_system $report_file 
            echo "----------------------------------------"
            echo "Report saved to $report_file" 
            tail -n 5 "$report_file" 
            read -p "Do you want to see the full report in terminal? [y/n]: " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ""
                clear
                cat "$report_file"
            fi        
        elif [ "$mode" == "HA" ]; then
            # Harden system
            report_file=$(create_report "Hardening")
            harden_system $report_file 
            echo "----------------------------------------"
            echo "Report saved to $report_file"
            tail -n 5 "$report_file"
            read -p "Do you want to see the full report in terminal? [y/n]: " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo ""
                clear
                cat "$report_file"
            fi
        elif [ "$mode" == "RUN" ]; then
            modules_to_choose_from=()
           for module in "${!valid_modules[@]}"; do
                module_name=${valid_modules[$module]}
                module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2)
                modules_to_choose_from+=("$module_name" "$module_score")
            done
            module=$(whiptail --backtitle "Hardening as Code Project v1 - @Eljakani" --title "Run Module" --menu "Choose a module to run" 20 60 10 \
            "${modules_to_choose_from[@]}" 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus -eq 0 ]; then
                module_name="$module"
                module_path=$(echo "${modules[$module_name]}" | cut -d' ' -f1)
                module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2)
                if [ -f "$MODULES_DIR/$module_path.sh" ] && [ -x "$MODULES_DIR/$module_path.sh" ]; then
                    "$MODULES_DIR/$module_path.sh" "HA"
                    if [ $? -eq 0 ]; then
                        log_success "Module passed: $module_name ($module_score)"
                    else
                        log_error "Module failed: $module_name ($module_score)"
                    fi
                else
                    log_warning "Module not found: $module_name"
                fi
            else
                log_warning "User cancelled"
            fi
        elif [ "$mode" == "HELP" ]; then
           modules_to_choose_from=()
           for module in "${!valid_modules[@]}"; do
                module_name=${valid_modules[$module]}
                module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2)
                modules_to_choose_from+=("$module_name" "$module_score")
            done
            module=$(whiptail --backtitle "Hardening as Code Project v1 - @Eljakani" --title "More Info on Modules" --menu "Choose a module to get more info" 20 60 10 \
            "${modules_to_choose_from[@]}" 3>&1 1>&2 2>&3)
            exitstatus=$?
            if [ $exitstatus -eq 0 ]; then
                module_name="$module"
                module_path=$(echo "${modules[$module_name]}" | cut -d' ' -f1)
                module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2)
                if [ -f "$MODULES_DIR/$module_path.sh" ] && [ -x "$MODULES_DIR/$module_path.sh" ]; then
                    whiptail --backtitle "Hardening as Code Project v1 - @Eljakani" --title "Module Info" --msgbox "Module Name: $module_name\nModule Score: $module_score\nModule Path: $module_path.sh\n--------------------------------------\nDescription:\n$(eval "$MODULES_DIR/$module_path.sh" "HELP")" 20 60
                    main_menu
                else
                    log_warning "Module not found: $module_name"
                fi
            else
                log_warning "User cancelled"
            fi
        fi
    else
        log_warning "User cancelled"
    fi
}


evaluate_system() {
    mode="EV"
    accu_score=0
    success=0
    report_file="$1"
    for module in "${!valid_modules[@]}"; do
        module_name=${valid_modules[$module]}   
        module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2) 
        module_path=$(echo "${modules[$module_name]}" | cut -d' ' -f1)                                                          
        if [ -f "$MODULES_DIR/$module_path.sh" ] && [ -x "$MODULES_DIR/$module_path.sh" ]; then
            "$MODULES_DIR/$module_path.sh" "$mode"
            if [ $? -eq 0 ]; then
                accu_score=$((accu_score + module_score))
                success=$((success + 1))
                log_success "Module passed: $module_name ($module_score)"
                echo " + $module_name:      PASSED ($module_score)" >> "$report_file"
            else
                log_error "Module failed: $module_name ($module_score)"
                echo " - $module_name:      FAILED ($module_score)" >> "$report_file"
            fi
        else
            log_warning "Module not found: $module_name"
        fi
        sleep 0.2
    done
    score=$((accu_score * 100 / total_score))
    echo "----------------------------------------" >> "$report_file"
    echo "Evaluation Percentage: $score%" >> "$report_file"
    echo "Total Score: $accu_score/$total_score" >> "$report_file"
    echo "Modules Passed: $success" >> "$report_file"
    echo "Modules Failed: $((${#valid_modules[@]} - success))" >> "$report_file"
    echo "----------------------------------------" >> "$report_file"
}

harden_system() {
    mode="HA"
    accu_score=0
    success=0
    report_file="$1"
    for module in "${!valid_modules[@]}"; do
        module_name=${valid_modules[$module]}   
        module_score=$(echo "${modules[$module_name]}" | cut -d' ' -f2) 
        module_path=$(echo "${modules[$module_name]}" | cut -d' ' -f1)   
        if [ -f "$MODULES_DIR/$module_path.sh" ] && [ -x "$MODULES_DIR/$module_path.sh" ]; then
            "$MODULES_DIR/$module_path.sh" "EV"
            if [ $? -eq 0 ]; then
                accu_score=$((accu_score + module_score))
                success=$((success + 1))
                log_success "Module passed: $module_name ($module_score)"
                echo " + $module_name: PASSED ($module_score)" >> "$report_file"
            else 
                "$MODULES_DIR/$module_path.sh" "$mode"
                if [ $? -eq 0 ]; then
                    accu_score=$((accu_score + module_score))
                    success=$((success + 1))
                    log_success "Module Applied: $module_name ($module_score)"
                    echo " + $module_name:      APPLIED ($module_score)" >> "$report_file"
                else
                    log_error "Module failed: $module_name ($module_score)"
                    echo " - $module_name:      FAILED ($module_score)" >> "$report_file"
                fi
            fi
        else
            log_warning "Module not found: $module_name"
        fi
        sleep 0.2
    done
    score=$((accu_score * 100 / total_score))
    echo "----------------------------------------" >> "$report_file"
    echo "Hardening Percentage: $score%" >> "$report_file"
    echo "Total Score: $accu_score/$total_score" >> "$report_file"
    echo "Modules Applied: $success" >> "$report_file"
    echo "Modules Failed: $((${#valid_modules[@]} - success))" >> "$report_file"
    echo "----------------------------------------" >> "$report_file"
}

# Disclaimer
whiptail --backtitle "Hardening as Code Project v1" --title "Disclaimer" --msgbox "This script is provided as-is without warranty of any kind and is intended for educational purposes only. \n\nThe author will not be held liable for any damages arising from the use of this script. \n\nUse at your own risk. \n\nPress OK to continue.\n\nCredits: @Eljakani" 15 60


process_module() {
    local module_name="$1"
    local module_path=$(echo "$2" | cut -d' ' -f1)
    local module_score=$(echo "$2" | cut -d' ' -f2)
    if [ -f "$MODULES_DIR/$module_path.sh" ]; then
        chmod +x "$MODULES_DIR/$module_path.sh"
        valid_modules+=("$module_name")
        total_score=$((total_score + module_score))
    else
        log_warning "Module not found: $module_name"
    fi
    
}
valid_modules=()
total_score=0
for module in "${!modules[@]}"; do
    process_module "$module" "${modules[$module]}"
done
whiptail --backtitle "Hardening as Code Project v1" --title "Modules Loaded" --msgbox "Loaded $((${#valid_modules[@]} / 2)) modules" 10 60

main_menu