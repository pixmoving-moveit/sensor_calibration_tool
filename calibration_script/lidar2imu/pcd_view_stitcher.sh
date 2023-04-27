#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

config_file_path=$SCRIPT_DIR/lidar2imu.yaml
lidar_pcds_dir=$(yq e  '.idar_pcds_dir' $config_file_path )
lidar_pose_file=$(yq e  '.lidar_pose_file' $config_file_path )

pcd_view_stitcher_exe=$SCRIPT_DIR/../../sensors_calibration_tool/SensorsCalibration/lidar2imu/manual_calib/bin/pcd_view_stitcher

# ./bin/pcd_view_stitcher data/top_center_lidar data/top_center_lidar-pose.txt
$pcd_view_stitcher_exe $lidar_pcds_dir $lidar_pose_file