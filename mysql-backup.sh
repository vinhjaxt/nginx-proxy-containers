#!/usr/bin/env sh
read -p "Database username: " dbuser
read -p "Database password: " dbpass
read -p "Database name: " dbname
mysqldump -u"${dbuser}" -p"${dbpass}" "${dbname}" -R -e --triggers --single-transaction > "database_${dbname}_backup.sql"
