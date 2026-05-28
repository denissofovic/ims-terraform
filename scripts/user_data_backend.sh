#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y docker.io git

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ubuntu

sleep 10

cd /home/ubuntu

if [ -d "inventory-managment-system" ]; then
    rm -rf inventory-managment-system
fi

git clone https://github.com/denissofovic/inventory-managment-system.git

cd inventory-managment-system/backend

sudo docker build -t backend .

sudo docker rm -f backend || true

sudo docker run -d \
  -p 8080:8080 \
  --restart unless-stopped \
  --name backend \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e ASPNETCORE_URLS=http://0.0.0.0:8080 \
  -e ConnectionStrings__DefaultConnection="Host=${db_host};Database=${db_name};Username=${db_username};Password=${db_password};" \
  backend