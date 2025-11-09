<?php
// ** Paramètres MySQL - Variables d'environnement Docker ** //
define('DB_NAME', getenv('DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('DB_USER') ?: 'wordpress_user');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: 'password');
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Clés de sécurité uniques (générées automatiquement)
define('AUTH_KEY',         '`openssl rand -base64 48`');
define('SECURE_AUTH_KEY',  '`openssl rand -base64 48`');
define('LOGGED_IN_KEY',    '`openssl rand -base64 48`');
define('NONCE_KEY',        '`openssl rand -base64 48`');
define('AUTH_SALT',        '`openssl rand -base64 48`');
define('SECURE_AUTH_SALT', '`openssl rand -base64 48`');
define('LOGGED_IN_SALT',   '`openssl rand -base64 48`');
define('NONCE_SALT',       '`openssl rand -base64 48`');

// Préfixe des tables
$table_prefix = 'wp_';

// Mode debug
define('WP_DEBUG', false);

// Absolute path to the WordPress directory.
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

// Sets up WordPress vars and included files.
require_once ABSPATH . 'wp-settings.php';
