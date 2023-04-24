#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/docker_script/log.sh

config_file_path="$SCRIPT_DIR/shared_folder"
NAME=$config_file_path yq eval -i  '.file_path = strenv(NAME)' "$config_file_path/config.yaml"

lidar2camera_path=""
lidar2imu_path=""
calibration_ws_path=""

function read_yaml(){
    config_path="$config_file_path/config.yaml"

    root_path=$(yq e  '.file_path' $config_path )

    lidar2camera_path=$(yq e  '.build_params.lidar2camera_path' $config_path )
    lidar2camera_path="$root_path/$lidar2camera_path"

    lidar2imu_path=$(yq e  '.build_params.lidar2imu_path' $config_path )
    lidar2imu_path="$root_path/$lidar2imu_path"

    calibration_ws_path=$(yq e  '.build_params.calibration_ws_path' $config_path )
    calibration_ws_path="$root_path/$calibration_ws_path"

}

function parse_arguments() {
  FUNCTION=$1
  shift 1
  if [[ -z $FUNCTION ]]; then
    log_error "Missing required argument(s)."
    echo ""
    # print_help
    exit 1
  fi
  
  case "$FUNCTION" in
    lidar2imu)
    log_info "lidar2imu build"
    $SCRIPT_DIR/build_script/cmake_build.sh $lidar2imu_path
    ;;

    lidar2camera)
    log_info "lidar2camera exec"
    $SCRIPT_DIR/build_script/cmake_build.sh $lidar2camera_path
    ;;

    calibration_ws)
    log_info "calibration_ws build"
    $SCRIPT_DIR/build_script/colcon_build.sh $calibration_ws_path
    ;;
  esac

  while (( "$#" )); do
    case "$1" in

      --)  # end argument parsing
        shift
        break
        ;;

      -*|--*=)  # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        exit 1
        ;;

      *)  # unsupported positional arguments
        echo "Error: Unsupported positional argument $1" >&2
        exit 1
        ;;
    esac
  done
}

function main(){
    read_yaml 
    parse_arguments $@

}
main $@