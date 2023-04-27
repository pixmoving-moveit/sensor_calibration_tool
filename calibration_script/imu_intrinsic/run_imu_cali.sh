#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

function run_cali(){
    dir_path="$SCRIPT_DIR/output/output_cgi410_imu_param.yaml"
    
    if [ ! -e $dir_path ]; then
        log_error "Can't find imu's bag file:[$imu_bag_path_env]"
        exit 1
    fi
    python3 "$SCRIPT_DIR/parser.py"
}

function main(){
    source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash
    ros2 launch $SCRIPT_DIR/launch/imu_intrinsic_cali.launch.py
    run_cali
    log_info "Calibration successful, output [$SCRIPT_DIR/output/param.yaml]"
}
main