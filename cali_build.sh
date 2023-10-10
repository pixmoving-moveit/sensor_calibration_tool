#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/common_script/log.sh

lidar2camera_path=""
lidar2imu_path=""
calibration_ws_path=""

function lower() {
  echo $1 | tr '[A-Z]' '[a-z]'
}

function upper() {
  echo $1 | tr '[a-z]' '[A-Z]'
}

function print_help() {
  echo "Sensor calibration tool execution script"
  echo ""
  echo "Usage:"
  echo "  ./calibration.sh <function>"
  echo ""
  echo "  <function>: function name"
  echo "  <function>: [lidar2camera|lidar2imu|calibration_ws]"
  echo "    - lidar2camera : Compile the executable file of lidar2camera"
  echo "    - lidar2imu : Compile the executable file of lidar2imur"
  echo "    - calibration_ws : Compile ROS2 functional space"
  echo ""
}

function error() {
  echo "$1" >&2
}

function is_yq_install(){
  
  if [ -e "$SCRIPT_DIR/yq" ]; then
    log_info "yq File exists"
  else
    YQ_VERSION="v4.16.2"
    YQ_BINARY="yq_linux_amd64"
    wget -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O $SCRIPT_DIR/yq
  fi

  if ! which yq > /dev/null; then
    read -p "yq command not found. Do you want to install it? (Y/n) " choice
    case "$choice" in
      y|Y )
        # 自动安装 yq 命令
        chmod +x $SCRIPT_DIR/yq

        sudo cp $SCRIPT_DIR/yq /usr/bin/yq
        ;;
      * )
        log_warning "Please install yq command manually."
        exit 1
        ;;
    esac
  fi

}

function read_yaml(){
    config_path="$SCRIPT_DIR/config.yaml"
    lidar2camera_path=$($SCRIPT_DIR/yq e  '.build_params.lidar2camera_path' $config_path )
    lidar2imu_path=$($SCRIPT_DIR/yq e  '.build_params.lidar2imu_path' $config_path )
    calibration_ws_path=$($SCRIPT_DIR/yq e  '.build_params.calibration_ws_path' $config_path )

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
    $SCRIPT_DIR/build_script/cmake_build.sh $SCRIPT_DIR/$lidar2imu_path
    ;;

    lidar2camera)
    log_info "lidar2camera exec"
    $SCRIPT_DIR/build_script/cmake_build.sh $SCRIPT_DIR/$lidar2camera_path
    ;;

    calibration_ws)
    log_info "calibration_ws build"
    $SCRIPT_DIR/build_script/colcon_build.sh $SCRIPT_DIR/$calibration_ws_path
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
  if [[ "help" == `lower $1` ]]; then
    print_help
    exit 0
  fi
  # is_yq_install
  read_yaml 
  parse_arguments $@
}
main $@