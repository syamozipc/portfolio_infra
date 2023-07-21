#!/bin/bash

# パッケージインストール
yum update
yum install postgresql15.x86_64 -y
yum install git -y
yum install make -y

# goインストール
wget https://golang.org/dl/go1.19.11.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.19.11.linux-amd64.tar.gz

# pathを通す + 環境変数を設定
cd /home/ec2-user
echo 'export PATH=$PATH:/usr/local/go/bin' >> .bash_profile
echo 'export DB_HOST=${db_host}' >> .bash_profile
echo 'export DB_PORT=${db_port}' >> .bash_profile
echo 'export DB_NAME=${db_name}' >> .bash_profile
echo 'export DB_USER=${db_user}' >> .bash_profile
echo 'export DB_PASSWORD=${db_password}' >> .bash_profile
source .bash_profile

# アプリケーション準備
git clone https://github.com/syamozipc/portfolio_server.git
cd portfolio_server
go mod download
