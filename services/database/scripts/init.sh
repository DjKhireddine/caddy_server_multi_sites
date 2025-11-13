#!/bin/sh
set -eu

echo "🔧 Initialisation personnalisée de la base de données..."

# Vérifs simples
: "${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD manquant}"
: "${MARIADB_USER:?MARIADB_USER manquant}"
: "${MARIADB_PASSWORD:?MARIADB_PASSWORD manquant}"
: "${DB_WORDPRESS:?DB_WORDPRESS manquant}"
: "${DB_DJANGO:?DB_DJANGO manquant}"

# Injecter le SQL directement via heredoc — pas d'écriture disque, pas d'envsubst
mariadb -u root -p"$MARIADB_ROOT_PASSWORD" <<EOF
-- Utilisateur applicatif
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';

-- Bases
CREATE DATABASE IF NOT EXISTS \`${DB_WORDPRESS}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS \`${DB_DJANGO}\`   CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Droits
GRANT ALL PRIVILEGES ON \`${DB_LARAVEL}\`.*   TO '${MARIADB_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${DB_WORDPRESS}\`.* TO '${MARIADB_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${DB_DJANGO}\`.*    TO '${MARIADB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "✅ Initialisation terminée."
