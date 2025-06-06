#!/bin/bash

# Set variables
BACKUP_DIR="/home/FreshStart/db_backups"
DB_NAME="FreshStart\$freshstart_db"
DB_USER="FreshStart"
DB_HOST="FreshStart.mysql.pythonanywhere-services.com"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/db_backup_${TIMESTAMP}.sql"
LATEST_BACKUP="$BACKUP_DIR/db_backup_LATEST.sql"

# Perform MySQL Dump
mysqldump -u $DB_USER -h $DB_HOST --password=Fr35h574r7 --no-tablespaces $DB_NAME > $BACKUP_FILE

# Update the latest backup
cp $BACKUP_FILE $LATEST_BACKUP

# Confirm Backup Completion
echo "✅ Backup completed: $BACKUP_FILE"
echo "✅ Latest backup linked to: $LATEST_BACKUP"
