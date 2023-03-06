#!/bin/bash

MAILCOW_INSTALL_DIR="/opt/mailcow-dockerized"

# Download and overwrite docker-compose.override.yml if it exists

cp ${MAILCOW_INSTALL_DIR}/helper-scripts/docker-compose.override.yml.d/BUILD_FLAGS/docker-compose.override.yml ${MAILCOW_INSTALL_DIR}
cp docker-compose.yml ${MAILCOW_INSTALL_DIR}
cp -r Dockerfiles/ ${MAILCOW_INSTALL_DIR}/data/

cp ${MAILCOW_INSTALL_DIR}/helper-scripts/backup_and_restore.sh ${MAILCOW_INSTALL_DIR}/helper-scripts/backup_and_restore.original.sh
#Build a local backup image and update the backup script
docker build -t backup ${MAILCOW_INSTALL_DIR}/data/Dockerfiles/backup/ 
awk '{sub("mailcow/backup:latest","backup:latest"); print}' ${MAILCOW_INSTALL_DIR}/helper-scripts/backup_and_restore.original.sh > ${MAILCOW_INSTALL_DIR}/helper-scripts/backup_and_restore.sh

echo -e "\n::: 1. Launch the build using: docker-compose -f docker-compose.override.yml build inside $MAILCOW_INSTALL_DIR"
echo -e "::: 2. Run generate_config.sh"
echo -e "::: 3. Bring up the stack as normal: docker-compose up -d"
