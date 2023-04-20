#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

export imu_record_path_env=""
export imu_topic_name_env="/chc/imu"
png_path=""

function creat_folder(){
    log_info "create calibration save data folder"

    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

    dir_path="/root/shared_folder/pix_data/imu"
    if [ ! -d $dir_path ]; then
        mkdir -p  $dir_path
    fi

    export imu_record_path_env="$dir_path/$timestamp.bag"
}

function run_roslaunch(){
    log_info "get [pcd, png] file"
    source /root/sensor_driver_ws/devel/setup.bash 
    roslaunch /root/shared_folder/get_cail_data/imu_topic_record.launch
    ln -sfn $imu_record_path_env "$dir_path/latest_imu.bag"
}

function main(){
   creat_folder
   run_roslaunch
}
main