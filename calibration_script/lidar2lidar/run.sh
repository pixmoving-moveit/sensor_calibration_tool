#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh

source $SCRIPT_DIR/../../sensors_calibration_tool/calibration_ws/install/setup.bash
ros2 launch config/run_launch.py params_file:=config/params.yaml