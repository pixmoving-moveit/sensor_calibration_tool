#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

gnome-terminal -- bash -c "ros2 launch $SCRIPT_DIR/launch/usb_cam_launch.py"
gnome-terminal -- bash -c "bash $SCRIPT_DIR/camera_intrinsic.sh"