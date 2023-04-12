#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)


# /image_raw
ros2 run camera_calibration cameracalibrator 
    --size 7x9 --square 0.05 
    --ros-args -r image:=/image_raw
    -p camera:=camera



gnome-terminal -- bash -c "ros2 launch $SCRIPT_DIR/usb_cam_launch.py"
gnome-terminal -- bash -c "bash $SCRIPT_DIR/camera_intrinsic_install.sh"