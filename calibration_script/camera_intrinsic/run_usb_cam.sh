#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash

gnome-terminal -x bash -c "ros2 launch $SCRIPT_DIR/launch/usb_cam_launch.py"
gnome-terminal -x bash -c "bash $SCRIPT_DIR/camera_intrinsic.sh"