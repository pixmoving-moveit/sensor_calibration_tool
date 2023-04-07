#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

config_file_path=/root/shared_folder/config.yaml

export png_topic_name_env=$(yq e  '.get_cail_data.png_topic_name' $config_file_path)
# export png_file_path_env

export pcd_topic_name_env=$(yq e  '.get_cail_data.pcd_topic_name' $config_file_path)
# export pcd_file_path_env

function creat_folder(){
    log_info "create calibration save data folder"

    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

    pcd_path="/root/shared_folder/$timestamp/pcd"
    mkdir -p pcd_path
    export pcd_file_path_env=pcd_path

    png_path="/root/shared_folder/$timestamp/png"
    mkdir -p png_path
    export png_file_path_env=png_path
}

function run_roslaunch(){
    log_info "get [pcd, png] file"

    roslaunch /root/get_cail_data/get_pcd_png.launch
}

function main(){
    creat_folder
    run_roslaunch
}
main


