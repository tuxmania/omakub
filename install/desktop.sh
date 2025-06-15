# Run desktop installers
#!/bin/bash

LOGFILE="/home/fred/desktop_install_logs.txt"
echo "=== Début de l'installation desktop ($(date)) ===" > "$LOGFILE"

# Exécuter tous les scripts du dossier desktop avec log
for installer in ~/.local/share/omakub/install/desktop/*.sh; do
    echo -e "\n▶️ Lancement du script $(basename "$installer")" >> "$LOGFILE"
    source "$installer" >> "$LOGFILE" 2>&1
    echo "✅ Terminé : $(basename "$installer")" >> "$LOGFILE"
done

# Logout to pickup changes
# Demander à l'utilisateur s'il veut redémarrer
echo -e "\n🌀 Demande de redémarrage à l'utilisateur..." >> "$LOGFILE"
if gum confirm "Ready to reboot for all settings to take effect?"; then
    echo "🔁 Reboot confirmé par l'utilisateur." >> "$LOGFILE"
    echo "=== Fin de l'installation desktop ($(date)) ===" >> "$LOGFILE"
    sudo reboot
else
    echo "⏹️ Redémarrage annulé par l'utilisateur." >> "$LOGFILE"
    echo "=== Fin de l'installation desktop sans reboot ($(date)) ===" >> "$LOGFILE"
fi
