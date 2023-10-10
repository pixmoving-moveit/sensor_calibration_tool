#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/../../common_script/log.sh

# ./bin/run_lidar2camera data/0.png data/0.pcd data/center_camera-intrinsic.json data/top_center_lidar-to-center_camera-extrinsic.json

config_file_path=$SCRIPT_DIR/lidar2camera.yaml
pcd_path="$SCRIPT_DIR/"$($SCRIPT_DIR/../../yq e  '.pcd_filename' $config_file_path )
png_path="$SCRIPT_DIR/"$($SCRIPT_DIR/../../yq e  '.png_filename' $config_file_path )
camera_intrinsic="$SCRIPT_DIR/"$($SCRIPT_DIR/../../yq e  '.camera_intrinsic_filename' $config_file_path )
lidar2camera_extrinsic="$SCRIPT_DIR/"$($SCRIPT_DIR/../../yq e  '.lidar2camera_extrinsic_filename' $config_file_path )


lidar2camera_exe=$SCRIPT_DIR/../../sensors_calibration_tool/SensorsCalibration/lidar2camera/manual_calib/bin/run_lidar2camera 

function handle_error {
    echo "Error: Command '$BASH_COMMAND' exited with status $?"
    exit 1
}
trap handle_error ERR


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
    $lidar2camera_exe $png_path $pcd_path $camera_intrinsic $lidar2camera_extrinsic
    
    check_file_existence
    python3 "$SCRIPT_DIR/parser.py"
}
main