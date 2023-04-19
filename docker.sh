#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/docker_script/log.sh

FUNCTION=""
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
  echo "  ./calibration.sh.sh <function>"
  echo ""
  echo "  <function>: function name"
  echo "  <function>: build exec "
  echo "    - build build docke file"
  echo "    - exec Entering Docker Container"
  echo ""
}

function error() {
  echo "$1" >&2
}


function is_yq_install(){
  
  if [ -e "$SCRIPT_DIR/docker_copy/yq" ]; then
    log_info "yq File exists"
  else
    YQ_VERSION="v4.16.2"
    YQ_BINARY="yq_linux_amd64"
    wget -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O $SCRIPT_DIR/docker_copy/yq
  fi


  if ! which yq > /dev/null; then
    read -p "yq command not found. Do you want to install it? (Y/n) " choice
    case "$choice" in
      y|Y )
        # 自动安装 yq 命令
        chmod +x $SCRIPT_DIR/docker_copy/yq

        sudo cp $SCRIPT_DIR/docker_copy/yq /usr/bin/yq
        ;;
      * )
        log_warning "Please install yq command manually."
        exit 1
        ;;
    esac
  fi

}

function docker_install(){

  # 卸载旧版本 Docker
  sudo apt-get remove docker docker-engine docker.io containerd runc

  # 安装依赖包
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

  # 添加 Docker 官方 GPG 密钥
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  # 添加 Docker 官方 APT 源
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # 安装 Docker Engine
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  # 启动 Docker 服务
  sudo systemctl start docker

  # 添加当前用户到 Docker 用户组，以避免使用 sudo 来执行 Docker 命令
  sudo usermod -aG docker $USER

  # 重新登录以使用户组更改生效
  log_info "Please logout and login again to use Docker without sudo."

}

is_docker_install(){
  #!/bin/bash

  if ! which docker > /dev/null; then
    read -p "Docker command not found. Do you want to install it? (Y/n) " choice
    case "$choice" in
      y|Y )
        # 自动安装 Docker
        docker_install
        ;;
      * )
        log_warning "Please install Docker manually."
        exit 1
        ;;
    esac
  fi
}

function parse_arguments() {
  FUNCTION=$1
  shift 1
  if [[ -z $FUNCTION ]]; then
    log_error "Missing required argument(s)."
    echo ""
    print_help
    exit 1
  fi
  
  case "$FUNCTION" in
    build)
    log_info "docker build"
    $SCRIPT_DIR/docker_script/docker_build.sh
    ;;

    exec)
    log_info "docker exec"
    $SCRIPT_DIR/docker_script/docker_exec.sh
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

  is_yq_install
  is_docker_install

  parse_arguments $@

}
main $@