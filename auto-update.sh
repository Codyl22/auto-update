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
	MSG_UPDATE_START="Préparation de la mise à jour des paquets..."
	MSG_UPDATE_DONE="[OK] Opération terminée !"
	MSG_FLATPAK_START="Vérification des mises à jour Flatpak..."
	MSG_SNAP_START="Vérification des mises à jour Snap..."
	MSG_FLATPAK_NO="Flatpak : Non intsallé sur ce système."
	MSG_SNAP_NO="Snap : Non installé sur ce système."
	MSG_SELF_CHECK="Vérification des mises à jour du script..."
	MSG_SELF_NEW="[INFO] Une nouvelle version du script est disponible. Mise à jour en cours..."
	MSG_SELF_OK="[OK] Le script est déjà à jour."
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
	MSG_UPDATE_START="Preparing package updates..."
	MSG_UPDATE_DONE="[OK] Operation completed!"
	MSG_FLATPAK_START="Checking for Flatpak updates..."
	MSG_SNAP_START="Checking for Snap updates..."
	MSG_FLATPAK_NO="Flatpak : Not installed on this system."
	MSG_SNAP_NO="Snap : Not installed on this system."
	MSG_SELF_CHECK="Checking for script updates..."
	MSG_SELF_NEW="[INFO] A new version of the script is available. Updating..."
	MSG_SELF_OK="[OK] The script is already up to date."
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

# --- MISE A JOUR DU SCRIPT ---
echo -e "${CYAN}${MSG_SELF_CHECK}${NC}"

git fetch origin main &> /dev/null # Récupération de l'état du dépôt

# Comparaison local avec GitHub
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" != "$REMOTE" ]: then
	echo -e "${GREEN}${MSG_SELF_NEW}${NC}"

	# Téléchargement de la nouvelle version
	git pull origin main &> /dev/null

	echo -e "-----------------------------------------------------------------------------------"
	exec "$0" "$@"
fi

echo -e "${GREEN}${MSG_SELF_OK}${NC}"
echo -e "-----------------------------------------------------------------------------------"

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

# --- SECTION MISE A JOUR ---
echo -e "\n${CYAN}${MSG_UPDATE_START}${NC}\n"

case "PM" in
	"dnf")
		# Fedora / RHEL
		dnf upgrade
		;;
	"apt")
		# Ubuntu / Debian
		apt-get update
		apt-get upgrade
		;;
	"pacman")
		# Arch Linux
		pacman -Syu
		;;
esac

echo -e "\n${GREEN}${MSG_UPDATE_DONE}${NC}"

# --- MISE A JOUR FLATPAK ---
if command -v flatpak &/ /dev/null; then
	echo -e "${CYAN}${MSG_FLATPAK_START}${NC}\n"
	flatpak update
else
	echo -e "${MSG_FLATPAK_NO}\n"
fi

echo -e "-------------------------------------------------------------------------------------"

# --- MISE A JOUR SNAP ---
if command -v snap &> /dev/null; then
	echo -e "${CYAN}${MSG_SNAP_START}${NC}\n"
	snap refresh
else
	echo -e "${MSG_SNAP_NO}\n"
fi
