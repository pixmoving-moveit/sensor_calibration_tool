#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh

config_file_path=$SCRIPT_DIR/../../shared_folder/config.yaml
docker_container_name=$(yq e  '.docker_config.docker_container_name' $config_file_path )

function run_cali(){
    docker exec -it -w /root/shared_folder ${docker_container_name}  bash -c "/root/shared_folder/imu_calibration.sh ; exit"
    
    dir_path="$SCRIPT_DIR/../../shared_folder/pix_data/imu/result/xsens_imu_param.yaml"
    
    if [ ! -e $dir_path ]; then
        log_error "Can't find imu's bag file:[$imu_bag_path_env]"
        exit 1
    fi
    cp $dir_path "$SCRIPT_DIR/config/imu_cail.yaml"
    python3 "$SCRIPT_DIR/config/parser.py"
}

function main(){
    run_cali
    log_info "Calibration successful, output [$SCRIPT_DIR/config/param.yaml]"
}
main