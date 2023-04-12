#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh


function main(){
    source $SCRIPT_DIR/workspace/install/setup.bash
    ros2 run camera_calibration cameracalibrator --size 11x8 --square 0.5 --ros-args -r image:=/image_raw -p camera:=/camera
}

main