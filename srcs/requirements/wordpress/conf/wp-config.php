<?php

// Database configuration using environment variables
define( 'DB_NAME', getenv('WP_DB') );
define( 'DB_USER', getenv('WP_USER') );
define( 'DB_PASSWORD', getenv('WP_PW') );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// WordPress table prefix
$table_prefix = 'wp_';

// Debug mode - set to false for production, true for development
define( 'WP_DEBUG', false );

// WordPress absolute path definition
if ( ! defined( 'ABSPATH' ) ) {
	    define( 'ABSPATH', __DIR__ . '/' );
}

// Loads the core WordPress engine. It's like "starting up" WordPress.
require_once ABSPATH . 'wp-settings.php';