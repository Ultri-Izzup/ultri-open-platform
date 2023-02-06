#!/bin/bash
sudo apt update 
sudo apt upgrade -y
sudo apt install redis postgresql-client git curl -y

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git -y

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update 

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo usermod -aG docker admin

sudo service docker start

USER admin

cd /home/admin

git clone https://github.com/Ultri-Izzup/ultri-open-platform.git

cd ultri-open-platform

sh gateway/scripts/prod-defaults.sh

mv example.env .env

chown -Rf admin /home/admin/ultri-open-platform

docker compose up
