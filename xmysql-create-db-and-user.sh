#!/usr/bin/env sh
read -p "mysql root password: " rootpwd
read -p "database name: " dbname
read -p "database password: " dbpass
command="docker exec -it internal-mysql.local sh -c 'mysql -uroot -p"\""${rootpwd}"\"" -e "
sh -c "$command "\""CREATE USER '\\''${dbname}'\\''@'\\''localhost'\\'' IDENTIFIED BY '\\''${dbpass}'\\'';"\""'"
sh -c "$command "\""CREATE USER '\\''${dbname}'\\''@'\\''%'\\'' IDENTIFIED BY '\\''${dbpass}'\\'';"\""'"
sh -c "$command "\""CREATE DATABASE \\\`${dbname}\\\`;"\""'"
sh -c "$command "\""GRANT ALL PRIVILEGES ON \\\`${dbname}\\\`.* TO '\\''${dbname}'\\''@'\''localhost'\\'';"\""'"
sh -c "$command "\""GRANT ALL PRIVILEGES ON \\\`${dbname}\\\`.* TO '\\''${dbname}'\\''@'\\''%'\\'';"\""'"
sh -c "$command "\""FLUSH PRIVILEGES;"\""'"
