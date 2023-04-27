#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

function main(){
    source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash
    ros2 launch $SCRIPT_DIR/launch/pcd_png_extractor.launch.py

    dir=$(yq e ".png_folder_path" "$SCRIPT_DIR/launch/pcd_png_extractor.yaml")

    pcd_files=($(find "$dir" -name "*.pcd" -type f -printf "%T+\t%p\n" | sort -r | cut -f2))
    png_files=($(find "$dir" -name "*.png" -type f -printf "%T+\t%p\n" | sort -r | cut -f2))
    
    ln -sf "${pcd_files[0]}" "$dir/latest.pcd"
    ln -sf "${png_files[0]}" "$dir/latest.png"

    log_info "collect successful png and pcd file"
}
main