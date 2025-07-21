#!/bin/bash

: <<'EOF'
======================================================================================
Script d'exécution SQL pour le projet Data Warehouse
======================================================================================

Description :
Ce script automatise l'exécution de scripts SQL dans un conteneur SQL Server.
Il charge les variables d'environnement depuis le fichier .env et exécute
le script init_database.sql pour initialiser la base de données.

Prérequis :
- Docker doit être installé et en cours d'exécution
- Le conteneur sqlserver doit être démarré
- Le fichier .env doit contenir les variables password et sqlserver_port

Utilisation :
./sql_execution.sh
======================================================================================
EOF

set -euo pipefail

# 1. Charger les variables d’environnement -----------------------------
# Le fichier .env doit contenir : PASSWORD
source "$(dirname "$0")/../.env"
file=$1

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

# 2. Exécuter le script SQL dans le conteneur SQL Server -------------

: <<'EOF'
======================================================================================
Section d'exécution SQL
======================================================================================

Cette section copie le script SQL dans le conteneur et l'exécute.

Étapes :
1. Copie du fichier init_database.sql dans le conteneur sqlserver
2. Exécution du script via sqlcmd avec les paramètres appropriés

Options sqlcmd utilisées :
- -S : Spécifie le serveur et le port de connexion
- -C : Accepte les certificats auto-signés (nécessaire pour les conteneurs)
- -U : Nom d'utilisateur SQL Server 
- -P : Mot de passe pour l'utilisateur
- -d : Base de données cible (master pour les opérations administratives)
- -i : Fichier d'entrée contenant les commandes SQL à exécuter
======================================================================================
EOF

# 2. Copier le script SQL dans le conteneur ----------------------------

: <<'EOF'
Copie du fichier SQL dans le conteneur
--------------------------------------
Cette commande copie le fichier init_database.sql depuis le système hôte
vers le conteneur sqlserver dans le répertoire racine (/).
EOF

echo "Copie du fichier SQL dans le conteneur..."
docker cp ./$file sqlserver:/$file

# 3. Exécuter le script -------------------------------------------------

: <<'EOF'
Exécution du script SQL
-----------------------
Utilisation de sqlcmd pour exécuter le script SQL dans le conteneur.
La connexion se fait via localhost avec le port spécifié dans .env.

Important :
- L'option -C est cruciale pour accepter les certificats auto-signés
- Le port doit être explicitement spécifié pour éviter les problèmes de connexion
EOF


echo "Exécution du script SQL..."
docker exec -i sqlserver /opt/mssql-tools18/bin/sqlcmd \
    -S "localhost,$sqlserver_port" \
    -C \
    -U sa -P "$password" \
    -d master \
    -i /$file

echo "Script terminé."

