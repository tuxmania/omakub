# Install default databases

# Fichier de log
LOGFILE="/home/fred/select_dev_storage_logs.txt"
echo "=== Début de l'installation des bases de données ($(date)) ===" > "$LOGFILE"

# Sélection ou lecture de la variable
if [[ -v OMAKUB_FIRST_RUN_DBS ]]; then
    dbs=$OMAKUB_FIRST_RUN_DBS
    echo "OMAKUB_FIRST_RUN_DBS détectée : $dbs" >> "$LOGFILE"
else
    AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
    echo "Aucune variable OMAKUB_FIRST_RUN_DBS. Demande à l'utilisateur..." >> "$LOGFILE"
    dbs=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker)")
    echo "Bases sélectionnées par l'utilisateur : $dbs" >> "$LOGFILE"
fi




# Fonction utilitaire : supprime un conteneur s'il existe déjà
remove_if_exists() {
    container_name=$1
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        echo "⚠️  Un conteneur nommé \"$container_name\" existe déjà. Suppression..." >> "$LOGFILE"
        sudo docker rm -f "$container_name" >> "$LOGFILE" 2>&1
        echo "🗑️  Conteneur \"$container_name\" supprimé." >> "$LOGFILE"
    fi
}

# Lancement des bases
if [[ -n "$dbs" ]]; then
    for db in $dbs; do
        echo "Lancement du conteneur pour $db..." >> "$LOGFILE"
        case $db in
        MySQL)
            remove_if_exists mysql8
            sudo docker run -d --restart unless-stopped \
                -p "127.0.0.1:3306:3306" \
                --name=mysql8 \
                -e MYSQL_ROOT_PASSWORD= \
                -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
                mysql:8.4 >> "$LOGFILE" 2>&1
            echo "✅ MySQL lancé." >> "$LOGFILE"
            ;;
        Redis)
            remove_if_exists redis
            sudo docker run -d --restart unless-stopped \
                -p "127.0.0.1:6379:6379" \
                --name=redis \
                redis:7 >> "$LOGFILE" 2>&1
            echo "✅ Redis lancé." >> "$LOGFILE"
            ;;
        PostgreSQL)
            remove_if_exists postgres16
            sudo docker run -d --restart unless-stopped \
                -p "127.0.0.1:5432:5432" \
                --name=postgres16 \
                -e POSTGRES_HOST_AUTH_METHOD=trust \
                postgres:16 >> "$LOGFILE" 2>&1
            echo "✅ PostgreSQL lancé." >> "$LOGFILE"
            ;;
        *)
            echo "⚠️ Base de données inconnue : $db (ignorée)" >> "$LOGFILE"
            ;;
        esac
    done
else
    echo "Aucune base de données sélectionnée. Rien à faire." >> "$LOGFILE"
fi

echo "=== Fin de l'installation ($(date)) ===" >> "$LOGFILE"
