#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

function move_cali_file() {
    path1="$HOME/Downloads/"
    sudo cp /tmp/calibrationdata.tar.gz $path1/
    path="$path1/calibrationdata.tar.gz"
    sudo chmod 666 $path
    if [ -e "$path" ]; then
        rm -rf $path1/calibrationdata
        mkdir -p $path1/calibrationdata
        tar -xzf $path -C "$path1/calibrationdata"
        mv "$path1/calibrationdata/ost.yaml"  "$SCRIPT_DIR/output/ost.yaml"
        $SCRIPT_DIR/parser.py
        log_info "Calibration successful, output [$SCRIPT_DIR/output/center_camera-intrinsic.json]"
    else
        log_error "The file already not exists:$path"
    fi
}


function main(){
    source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash
    ros2 run camera_calibration cameracalibrator --size 11x8 --square 0.5 --ros-args -r image:=/camera/image_raw -p camera:=/camera

    stop 2
    move_cali_file
}

main
