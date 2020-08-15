#! /bin/bash -eu

PROJ_PATH=$(readlink -f $(cd $(dirname $(readlink -f $0)) && pwd))
cd ${PROJ_PATH}/..

docker-compose down
BACKUP_FILENAME="backup-$(date '+%Y%m%d').tar.gz"
sudo bash -exu <<EOF
tar -czvf "${BACKUP_FILENAME}" ./data
chown $(id -g):$(id -u) "${BACKUP_FILENAME}"
EOF
docker-compose up -d
