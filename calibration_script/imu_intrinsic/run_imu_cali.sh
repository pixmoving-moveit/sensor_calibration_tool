#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh

config_file_path=$SCRIPT_DIR/../../shared_folder/config.yaml
docker_container_name=$(yq e  '.docker_config.docker_container_name' $config_file_path )
docker exec -it -w /root/shared_folder ${docker_container_name}  bash -c "/root/shared_folder/imu_calibration.sh ; exit"
