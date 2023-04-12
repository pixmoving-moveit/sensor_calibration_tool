#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

config_file_path=/root/shared_folder/config.yaml

export png_topic_name_env=$(yq e  '.get_cail_data.png_topic_name' $config_file_path)
# export png_file_path_env

export pcd_topic_name_env=$(yq e  '.get_cail_data.pcd_topic_name' $config_file_path)
# export pcd_file_path_env

png_path=""
pcd_path=""

function creat_folder(){
    log_info "create calibration save data folder"

    timestamp=$(date "+%Y-%m-%d_%H-%M-%S")

    png_path="/root/shared_folder/pix_data/$timestamp/png"
    mkdir -p $png_path
    export png_file_path_env="$png_path/%02d.png"

    pcd_path="/root/shared_folder/pix_data/$timestamp/pcd"
    mkdir -p $pcd_path
    export pcd_file_path_env="$pcd_path/"
}

function run_roslaunch(){
    log_info "get [pcd, png] file"
    source /root/sensor_driver_ws/devel/setup.bash 
    roslaunch /root/shared_folder/get_cail_data/get_pcd_png.launch
}
function rename_pcd(){
    i=0
    for file in $pcd_path/*
    do
        mv "$file" "$(printf $pcd_path/'%02d.pcd' $i)"
        i=$((i+1))
    done
}

function create_latest_symlink() {
    if [[ -d "$1" ]]; then
        cd "$1" || { log_error "Failed to enter directory: $1"; return 1; }

        latest_dir=$(ls -dt */ 2>/dev/null | head -n1)
        if [[ -n "$latest_dir" ]]; then
            ln -sfn "$latest_dir" latest
            log_info "$latest_dir/latest"
        else
            log_error "No directories found in $1"
            return 1
        fi
    else
        log_error "Directory not found: $1"
        return 1
    fi
}


function main(){
    creat_folder
    run_roslaunch
    
    rename_pcd 
    create_latest_symlink "$SCRIPT_DIR/pix_data"
}
main