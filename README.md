# HaC
<p align="center">
  <img src="https://hac.surge.sh/HaC.png" alt="HaC Logo"/>
</p>
## Overview

This Linux hardening script is designed to enhance the security of a Linux system by implementing recommendations from the ANSSI (Agence nationale de la sécurité des systèmes d'information) V2 guidelines. The script follows a modular structure, with each security recommendation represented as a separate module.

## Project Structure

The project structure is organized as follows:

- **`modules/` Directory:** Contains individual modules, each addressing specific security recommendations. Each module has its own bash script (`*.sh`) with functions for hardening, evaluation, and help.

- **`modules.sh` File:** Central configuration file mapping each module to its score and path. This file is sourced in the main script (`run.sh`) for dynamic module loading.

- **`run.sh` Script:** The main script that orchestrates the execution of module functions. It handles scoring, report generation, and the overall project workflow.

- **`reports/` Directory:** Intended for storing generated reports on the hardening status of the server.

# Modules

 - Each module is designed to address a specific ANSSI recommendation.
 - Modules are modular, allowing for easy addition or removal.
 - Module scripts follow a consistent structure with hardening, evaluation, and help functions.

## Usage

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Eljakani/HaC.git
   cd HaC ```

## Review Modules:

Explore the modules/ directory to understand each module's purpose and functionality.

## Configure Modules:

Update the modules.sh file with module scores and paths.

## Run the Script:

Execute the main script to initiate the hardening process.
```bash
   sudo ./run.sh
```
## Review Reports:

Generated reports can be found in the reports/ directory.

## Disclaimer

This script is provided as-is and should be tested in a controlled environment before applying to production systems.
