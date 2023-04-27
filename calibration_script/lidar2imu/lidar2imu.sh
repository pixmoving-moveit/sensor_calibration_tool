#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

# ./bin/run_lidar2imu data/top_center_lidar data/top_center_lidar-pose.txt data/gnss-to-top_center_lidar-extrinsic.json

config_file_path=$SCRIPT_DIR/lidar2imu.yaml

idar_pcds_dir=$(yq e  '.idar_pcds_dir' $config_file_path )
lidar_pose_file=$(yq e  '.lidar_pose_file' $config_file_path )
extrinsic_json="$SCRIPT_DIR/"$(yq e  '.extrinsic_json' $config_file_path )


lidar2imu_exe=$SCRIPT_DIR/../../sensors_calibration_tool/SensorsCalibration/lidar2imu/manual_calib/bin/run_lidar2imu

function handle_error {
    echo "Error: Command '$BASH_COMMAND' exited with status $?"
    exit 1
}
trap handle_error ERR

function check_input_params(){
    if is_absolute_path $extrinsic_json;then
        extrinsic_json="$SCRIPT_DIR/../../$extrinsic_json"
    fi

    if is_absolute_path $idar_pcds_dir;then
        idar_pcds_dir="$SCRIPT_DIR/../../$idar_pcds_dir"
    fi

    if is_absolute_path $lidar_pose_file;then
        lidar_pose_file="$SCRIPT_DIR/../../$lidar_pose_file"
    fi
}
function check_file_existence() {
    if ls $SCRIPT_DIR"/../../calibration_"*  $SCRIPT_DIR"/../../calibimg_"* 1>/dev/null 2>&1; then
        log_info "[calibration_*  calibimg_*] file move [output/]"
        
        mv $SCRIPT_DIR"/../../calibimg_"*".jpg"     "$SCRIPT_DIR/output/calibimg.jpg"
        mv $SCRIPT_DIR"/../../calibration_"*".txt"  "$SCRIPT_DIR/output/calibration.txt"
    else
        log_warning "There is no file [calibration_*  calibimg_*]prefixed with cali."
    fi
}

function main(){
    check_input_params
    $lidar2imu_exe $idar_pcds_dir $lidar_pose_file $extrinsic_json
    
    # check_file_existence
    # python3 "$SCRIPT_DIR/parser.py"
}
main