#! /bin/bash -eu

PROJ_PATH=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
cd ${PROJ_PATH}/..

docker-compose down
sudo bash -exu <<EOF
tar -czvf "data-$(date '+%Y%m%d').tar.gz" ./data
chown $(id -g):$(id -u) "data-$(date '+%Y%m%d').tar.gz"
EOF
docker-compose up -d
