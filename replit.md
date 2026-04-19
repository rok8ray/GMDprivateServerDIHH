# GMDprivateServer - Geometry Dash Private Server

## Overview
A Geometry Dash Private Server emulator supporting game versions 1.0 - 2.2. Implements the full GD API with PHP backend and MySQL/MariaDB database.

## Architecture
- **Language:** PHP 8.2
- **Database:** MariaDB 10.11 (MySQL-compatible), running locally
- **Web Server:** PHP built-in development server (port 5000)
- **No build system** - PHP files served directly

## Project Structure
- `/` (root) - API endpoints called by GD clients (uploadGJLevel.php, loginGJAccount.php, etc.)
- `incl/lib/` - Core libraries: database connection, encryption, mainLib
- `config/` - Configuration files (connection.php, security.php, discord.php, etc.)
- `dashboard/` - Web admin interface at `/dashboard/`
- `tools/` - Utility scripts and cron jobs
- `accounts/` - Account management
- `database.sql` - Full database schema
- `_updates/` - Incremental database migration scripts
- `data/` - File-based storage (account keys, etc.)

## Running the Application
The application is started via `start.sh`, which:
1. Starts MariaDB with data stored in `/home/runner/mysql_data/`
2. Creates the `geometrydash` database if needed
3. Imports `database.sql` schema on first run
4. Starts PHP built-in server on `0.0.0.0:5000`

## Database Configuration
- **Config file:** `config/connection.php`
- **Host:** 127.0.0.1
- **Port:** 3306
- **Database:** geometrydash
- **User:** root (no password - skip-grant-tables mode for dev)
- **MySQL socket:** `/tmp/mysql.sock`
- **MySQL data dir:** `/home/runner/mysql_data/`

## Key Endpoints
- `/dashboard/` - Admin dashboard (GDPS Dashboard)
- `/getGJLevels.php` - Fetch levels
- `/uploadGJLevel.php` - Upload a level
- `/loginGJAccount.php` - Account login
- (many more GD API endpoints at root)

## Deployment
Configured as VM deployment (always-on) via `start.sh` since MySQL runs locally.
Run command: `bash /home/runner/workspace/start.sh`
