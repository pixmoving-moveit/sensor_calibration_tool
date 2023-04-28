#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh


function main(){
    source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash

    gnome-terminal -x bash -c "ros2 launch $SCRIPT_DIR/launch/run_cali_launch.py"
    gnome-terminal -x bash -c "rviz2 -d $SCRIPT_DIR/launch/rviz2.rviz"

}

main