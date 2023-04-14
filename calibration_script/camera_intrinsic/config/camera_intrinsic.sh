#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh

function move_cali_file() {
    path=/tmp/calibrationdata.tar.gz
    if [ -e "$path" ]; then
        tar -xzf $path -C /tmp/
        mv /tmp/calibrationdata/ost.yaml  "$SCRIPT_DIR/ost.yaml"
        $SCRIPT_DIR/parser.py
        log_info "Camera internal reference calibration"

    else
        log_warning "The file already not exists:$path"
    fi
}

function main(){
    source $SCRIPT_DIR/../workspace/install/setup.bash
    ros2 run camera_calibration cameracalibrator --size 11x8 --square 0.5 --ros-args -r image:=/image_raw -p camera:=/camera

    stop 2
    move_cali_file
}

main