#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

apt-get update -y
apt-get install -y docker.io git curl

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu || true

until docker info >/dev/null 2>&1; do
  echo "Waiting for docker..."
  sleep 2
done

cd /home/ubuntu

if [ ! -d "inventory-managment-system" ]; then
  git clone https://github.com/denissofovic/inventory-managment-system.git
fi

cd inventory-managment-system/frontend

docker build \
  --build-arg REACT_APP_API_URL=http://${backend_url} \
  --build-arg REACT_APP_S3_URL=${s3_url} \
  -t frontend .

docker rm -f frontend || true

docker run -d \
  -p 3000:80 \
  --restart unless-stopped \
  --name frontend \
  frontend

