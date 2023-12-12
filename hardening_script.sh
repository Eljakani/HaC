#!/bin/bash

# Function to perform system evaluation
evaluate_system() {
    score=75 
    whiptail --msgbox "System Evaluation Score: $score" 10 30
}

# Function to perform system hardening
harden_system() {
    report="Hardening Report:\n - Successful hardening steps\n - Errors encountered during hardening"
    score=90  
    whiptail --msgbox "$report\n\nFinal System Score: $score" 10 50
}

# Display a menu using whiptail for mode selection
mode_selection=$(whiptail --menu "Choose a mode:" 12 40 2 \
    "Evaluate" "Evaluation mode" \
    "Harden" "Hardening mode" 3>&1 1>&2 2>&3)

case "$mode_selection" in
    "Evaluate")
        echo "Running in Evaluation mode..."
        evaluate_system
        ;;
    "Harden")
        echo "Running in Hardening mode..."
        harden_system
        ;;
    *)
        echo "Script canceled."
        exit 1
        ;;
esac
