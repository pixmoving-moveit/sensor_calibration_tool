#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../../common_script/log.sh

pcd_dir_path=$($SCRIPT_DIR/../../yq e ".pcd_dir_path", "$SCRIPT_DIR/launch/lidar_imu_data.yaml")

function main(){
    source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash
    ros2 launch $SCRIPT_DIR/launch/lidar_imu_data.launch.py

    
    file_count=$(find $pcd_dir_path -type f -name "*.pcd" | wc -l)
    log_info "collect successful number=[$file_count] pcd file"
}
main