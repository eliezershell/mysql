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

sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE USER '$usuario'@'localhost' IDENTIFIED BY '$senha';
CREATE DATABASE $banco;
GRANT ALL PRIVILEGES ON $banco.* TO '$usuario'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
if [ $? -gt 0 ]; then
        echo "Erro ao criar Database!"; exit 0
fi

echo "------------------------------Instalação concluída com sucesso!------------------------------"
echo "----------------------Script by: Eliezer Ribeiro | linkedin.com/in/elinux--------------------"
exit 0
