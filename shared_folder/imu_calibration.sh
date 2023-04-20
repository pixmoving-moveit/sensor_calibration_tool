#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

export imu_bag_path_env="/root/shared_folder/pix_data/imu/latest_imu.bag"
export imu_topic_name_env="/chc/imu"
export imu_cali_save_env="/root/shared_folder/pix_data/imu/result/"


function run_roslaunch(){
    log_info "get [pcd, png] file"
    source /root/sensor_driver_ws/devel/setup.bash 
    roslaunch /root/shared_folder/get_cail_data/imu_cail.launch
}

function main(){
    if [ ! -e $imu_bag_path_env ]; then
        log_error "Can't find imu's bag file:[$imu_bag_path_env]"
        exit 1
    fi
    dir_path=$imu_cali_save_env
    if [ ! -d $dir_path ]; then
        mkdir -p  $dir_path
    fi
    run_roslaunch
}
main