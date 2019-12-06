#!/usr/bin/env sh
read -p "mysql root password: " rootpwd
read -p "database name: " dbname
read -p "database password: " dbpass
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "CREATE USER '${dbname}'@'localhost' IDENTIFIED BY '${dbpass}';"
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "CREATE USER '${dbname}'@'%' IDENTIFIED BY '${dbpass}';"
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "CREATE DATABASE \`${dbname}\`;"
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'%';"
docker exec -it internal-mysql.local mysql -uroot -p"${rootpwd}" -e "FLUSH PRIVILEGES;"
