#!/bin/bash

# =====================================================================================
# AUTO-UPDATE
# Linux operating system update script
# =====================================================================================

# --- GESTION DE LA LANGUE ---
if [[ "$LANG" == fr* ]]; then
	MSG_START="Démarrage du script de mise à jour..."
	MSG_ROOT_ERR="[ERREUR] Ce script doit être exécuté en ROOT."
	MSG_ROOT_HELP="Relance avec :"
	MSG_ROOT_OK="Droit administrateur vérifiés."
	MSG_DETECT_OS="Détection du gestionnaire de paquets..."
	MSG_FOUND_DNF="[OK] Système basé sur RedHat/Fedora détecté (DNF)."
	MSG_FOUND_APT="[OK] Système basé sur Debian/Ubuntu détecté (APT)."
	MSG_FOUND_PACAMN="[OK] Système basé sur Arch Linux détecté (Pacman)."
	MSG_ERROR_OS="[ERREUR] Aucun gestionnaire de paquets compatibles trouvé (APT, DNF, Pacman)."
else
	MSG_START="Starting update script..."
	MSG_ROOT_ERR="[ERROR] This script must be run as ROOT."
	MSG_ROOT_HELP="Rerun with:"
	MSG_ROOT_OK="Administrator privileges verified."
	MSG_DETECT_OS="Detecting package manager..."
	MSG_FOUND_DNF="[OK] RadHat/Fedora based system detected (DNF)"
	MSG_FOUND_APT="[OK] Debian/Ubuntu based system detected (APT)"
	MSG_FOUND_PACMAN="[OK] Arch Linux based system detected (Pacman)"
	MSG_ERR_OS="[ERROR] No compatible package manager found (APT, DNF, Pacman)."
fi

# --- DEFINITON DES COULEURS ---
GREEN='\033[1;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'  # Reset

# --- BANNIERE ---
echo -e "${GREEN}"
echo -e "  █████╗ ██╗   ██╗████████╗ ██████╗       ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗"
echo -e " ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗      ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝"
echo -e " ███████║██║   ██║   ██║   ██║   ██║█████╗██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  "
echo -e " ██╔══██║██║   ██║   ██║   ██║   ██║╚════╝██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  "
echo -e " ██║  ██║╚██████╔╝   ██║   ╚██████╔╝      ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗"
echo -e " ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝        ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝"
echo -e "${NC}"
echo -e "${CYAN}${MSG_START}${NC}"
echo -e "-----------------------------------------------------------------------------------"

# --- VERIFICATION DES DROITS ROOT ---
if [ "$EUID" -ne 0 ]; then
	echo -e "${RED}${MSG_ROOT_ERR}${NC}"
	echo -e #${MSG_ROOT_HELP} ${CYAN}sudo ./auto-update.sh${NC}"
	exit 1
fi

echo -e "${GREEN}[OK]${NC} ${MSG_ROOT_OK}"

# --- DETECTION DE LA DISTRIBUTION ---
echo -e "\n${CYAN}${MSG_DETECT_OS}${NC}"

if command -v dnf &> /dev/null; then
	PM="dnf"
	echo -e "${GREEN}${MSG_FOUND_DNF}${NC}"
elif command -v apt-get &> /dev/null; then
	PM="apt"
	echo -e "${GREEN}${MSG_FOUND_APT}${NC}"
elif command -v pacman &> /dev/null; then
	PM="pacman"
	echo -e "${GREEN}${MSG_FOUND_PACMAN}${NC}"
else
	echo -e "${RED}${MSG_ERR_OS}${NC}"
	exit 1
fi

echo -e "-------------------------------------------------------------------------------------"
