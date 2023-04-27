#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

pcd_view_stitcher_exe=$SCRIPT_DIR/../../sensors_calibration_tool/SensorsCalibration/lidar2imu/manual_calib/bin/pcd_view_stitcher
