#!/usr/bin/env sh
read -p "mysql login command (without -e): " mysqlcommand
read -p "database name: " dbname
read -p "database password: " dbpass
eval "$mysqlcommand -e "\""CREATE USER '${dbname}'@'localhost' IDENTIFIED BY '${dbpass}';"\"""
eval "$mysqlcommand -e "\""CREATE USER '${dbname}'@'%' IDENTIFIED BY '${dbpass}';"\"""
eval "$mysqlcommand -e "\""CREATE DATABASE \\\`${dbname}\\\`;"\"""
eval "$mysqlcommand -e "\""GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'localhost';"\"""
eval "$mysqlcommand -e "\""GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbname}'@'%';"\"""
eval "$mysqlcommand -e "\""FLUSH PRIVILEGES;"\"""
