#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh

# ./bin/run_lidar2camera data/0.png data/0.pcd data/center_camera-intrinsic.json data/top_center_lidar-to-center_camera-extrinsic.json

config_file_path=$SCRIPT_DIR/lidar2camera.yaml
pcd_path=$(yq e  '.pcd_path' $config_file_path )
png_path=$(yq e  '.png_path' $config_file_path )
camera_intrinsic=$(yq e  '.camera_intrinsic' $config_file_path )
lidar2camera_extrinsic=$(yq e  '.lidar2camera_extrinsic' $config_file_path )

lidar2camera_exe=$SCRIPT_DIR/../../SensorsCalibration/lidar2camera/manual_calib/bin/run_lidar2camera 

function check_input_params(){
    if is_absolute_path $pcd_path;then
        pcd_path="$SCRIPT_DIR/../../$pcd_path"
    fi

    if is_absolute_path $png_path;then
        png_path="$SCRIPT_DIR/../../$png_path"
    fi

    if is_absolute_path $camera_intrinsic;then
        camera_intrinsic="$SCRIPT_DIR/../../$camera_intrinsic"
    fi

    if is_absolute_path $lidar2camera_extrinsic;then
        lidar2camera_extrinsic="$SCRIPT_DIR/../../$lidar2camera_extrinsic"
    fi
    
}


function main(){
    check_input_params
    $lidar2camera_exe $png_path $pcd_path $camera_intrinsic $lidar2camera_extrinsic
}
main