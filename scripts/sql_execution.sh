#!/bin/bash

: <<'EOF'
======================================================================================
Script pour copier les données dans le conteneur SQL Server
======================================================================================

Ce script permet de copier un dossier contenant des fichiers  dans un conteneur SQL Server.

Il est nécessaire de définir les variables d'environnement suivantes dans le fichier .env :
- PASSWORD : Le mot de passe pour l'utilisateur saysadmin du conteneur SQL Server.
- sqlserver_port : Le port sur lequel le conteneur SQL Server est exposé.


======================================================================================
EOF

set -euo pipefail

# 1. Charger les variables d’environnement -----------------------------
# Le fichier .env doit contenir : PASSWORD
source "$(dirname "$0")/../.env"
file_path=$1
file_name=$2


: "${password:?Variable password manquante dans .env}"   # vérification
if [[ -z "$password" ]]; then
    echo "Erreur : La variable password n'est pas définie dans le fichier .env."
    exit 1
fi
: "${sqlserver_port:?Variable sqlserver_port manquante dans .env}"  # vérification
if [[ -z "$sqlserver_port" ]]; then
    echo "Erreur : La variable sqlserver_port n'est pas définie dans le fichier .env."
    exit 1
fi



# 2. Copier le dossier contenant les fichiers de données dans le conteneur ----------------------------

: <<'EOF'
Copie du dossier des données dans le conteneur
--------------------------------------
Cette commande copie le dossier contenant les données depuis le système hôte
vers le conteneur datawarehouse dans le répertoire racine (/).
EOF


echo "Copie du dossier des données dans le conteneur..."
docker cp "$file_path" sqlserver-datawarehouse:/home/"$file_name"
if [ $? -ne 0 ]; then
    echo "Erreur lors de la copie du dossier dans le conteneur."
    exit 1
fi

