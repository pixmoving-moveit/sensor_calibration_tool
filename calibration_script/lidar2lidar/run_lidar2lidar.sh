#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh


function main(){
    source $SCRIPT_DIR/../../../sensors_calibration_tool/calibration_ws/install/setup.bash
    ros2 launch $SCRIPT_DIR/config/run.launch.py config_path:= $SCRIPT_DIR/config/config.yaml 
}

main