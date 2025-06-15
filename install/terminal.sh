
# Needed for all installers
#!/bin/bash

LOGFILE="/home/fred/logs.txt"
echo "=== Début de l'installation terminal ($(date)) ===" > "$LOGFILE"

# Mise à jour du système
echo -e "\n📦 Mise à jour des paquets système..." >> "$LOGFILE"
{
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y curl git unzip
} >> "$LOGFILE" 2>&1
echo "✅ Paquets système installés." >> "$LOGFILE"

# Exécution des installateurs dans le dossier terminal/
for installer in ~/.local/share/omakub/install/terminal/*.sh; do
    echo -e "\n▶️ Lancement du script $(basename "$installer") ($(date))" >> "$LOGFILE"
    {
        source "$installer"
        echo "✅ Terminé : $(basename "$installer")" >> "$LOGFILE"
    } || {
        echo "❌ Échec du script : $(basename "$installer")" >> "$LOGFILE"
    }
done

echo -e "\n=== Fin de l'installation terminal ($(date)) ===" >> "$LOGFILE"
