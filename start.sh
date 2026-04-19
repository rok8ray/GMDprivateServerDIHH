#!/bin/bash

MYSQL_DATA="/home/runner/mysql_data"
MYSQL_SOCKET="/tmp/mysql.sock"
MYSQL_LOGS="/home/runner/mysql_logs"
MYSQL_PORT=3306

mkdir -p "$MYSQL_DATA" "$MYSQL_LOGS"

start_mysql() {
    if mysql --socket="$MYSQL_SOCKET" -u root -e "SELECT 1;" 2>/dev/null; then
        echo "MySQL already running"
        return 0
    fi
    
    echo "Starting MySQL..."
    mysqld \
        --datadir="$MYSQL_DATA" \
        --socket="$MYSQL_SOCKET" \
        --port=$MYSQL_PORT \
        --bind-address=127.0.0.1 \
        --innodb-use-native-aio=OFF \
        --skip-grant-tables \
        --log-error="$MYSQL_LOGS/error.log" \
        --pid-file="$MYSQL_LOGS/mysql.pid" &
    
    echo "Waiting for MySQL to start..."
    for i in $(seq 1 30); do
        if mysql --socket="$MYSQL_SOCKET" -u root -e "SELECT 1;" 2>/dev/null; then
            echo "MySQL is ready!"
            return 0
        fi
        sleep 1
    done
    echo "ERROR: MySQL failed to start"
    cat "$MYSQL_LOGS/error.log"
    exit 1
}

setup_database() {
    echo "Setting up database..."
    mysql --socket="$MYSQL_SOCKET" -u root -e "CREATE DATABASE IF NOT EXISTS geometrydash CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null || true
    
    TABLE_COUNT=$(mysql --socket="$MYSQL_SOCKET" -u root geometrydash -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='geometrydash';" 2>/dev/null)
    if [ -z "$TABLE_COUNT" ] || [ "$TABLE_COUNT" = "0" ]; then
        echo "Importing database schema..."
        mysql --socket="$MYSQL_SOCKET" -u root geometrydash < /home/runner/workspace/database.sql
        echo "Database schema imported!"
    else
        echo "Database already has $TABLE_COUNT tables, skipping import"
    fi
}

start_mysql
setup_database

echo "Starting PHP web server on 0.0.0.0:5000..."
exec php -S 0.0.0.0:5000 -t /home/runner/workspace
