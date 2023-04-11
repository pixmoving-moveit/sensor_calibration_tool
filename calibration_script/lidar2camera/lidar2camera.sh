#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../log.sh

# ./bin/run_lidar2camera data/0.png data/0.pcd data/center_camera-intrinsic.json data/top_center_lidar-to-center_camera-extrinsic.json

lidar2camera_exe=$SCRIPT_DIR/../../SensorsCalibration/lidar2camera/manual_calib/bin/run_lidar2camera 
pcd_path=$SCRIPT_DIR/../../shared_folder/pix_data/2023-04-10_03-46-53/pcd/01.pcd
png_path=$SCRIPT_DIR/../../shared_folder/pix_data/2023-04-10_03-46-53/png/01.png

lidar2camera_exe $png_path $pcd_path 