#!/bin/bash

sudo apt update
if [ $? -gt 0 ]; then
        echo "Erro ao atualizar pacotes do repositório APT!"; exit 0
fi

sudo apt install mysql-server -y
if [ $? -gt 0 ]; then
        echo "Erro ao instalar MySQL!"; exit 0
fi

echo "------------------------------Verificando MySQL-Server------------------------------"
service mysql status
echo "------------------------------------------------------------------------------------"

echo "----------------------------------Criando Database----------------------------------"
read -p "Nome de usuário: " usuario
read -p "Senha de usuário: " senha
read -p "Nome do banco de dados: " banco

sudo mysql -u root <<MYSQL_SCRIPT
CREATE USER '$usuario'@'%' IDENTIFIED BY '$senha';
CREATE DATABASE $banco;
GRANT ALL PRIVILEGES ON $banco.* TO '$usuario'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
if [ $? -gt 0 ]; then
        echo "Erro ao criar Database!"; exit 0
fi

sudo sed -i 's/^bind-address/# bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
if [ $? -gt 0 ]; then
        echo "Erro ao alterar o arquivo mysqls.cnf!"; exit 0
fi

sudo sed -i 's/^mysqlx-bind-address/# mysqlx-bind-address/' /etc/mysql/mysql.conf.d/mysqld.cnf
if [ $? -gt 0 ]; then
        echo "Erro ao alterar o arquivo mysqls.cnf!"; exit 0
fi

sudo systemctl restart mysql

echo "------------------------------Instalação concluída com sucesso!------------------------------"
echo "----------------------Script by: Eliezer Ribeiro | linkedin.com/in/elinux--------------------"
exit 0
