#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh
config_file_path=$SCRIPT_DIR/../shared_folder/config.yaml


docker_container_name=$(yq e  '.docker_config.docker_container_name' $config_file_path )
docker_image_name=$(yq e      '.docker_config.docker_image_name'     $config_file_path )
docker_image_version=$(yq e   '.docker_config.docker_image_version'  $config_file_path )


function install_container(){
    log_info "create container:$docker_container_name"

    volume_1="-v $SCRIPT_DIR/../shared_folder:/root/shared_folder -w /root/shared_folder"
    # volume_2="--user $(id -u):$(id -g)"
    volume_2=""
    # volume_2='-e DISPLAY=:0 -e LIBGL_DEBUG=verbose -e LIBGL_ALWAYS_SOFTWARE=1 -v /tmp/.X11-unix:/tmp/.X11-unix'
    base='--privileged --network host --device /dev/ttyUSB0'

    docker run -d -it --name ${docker_container_name} $base $volume_1 $volume_2  $docker_image_name:$docker_image_version

}

function start_container(){
    log_info "starting: ${docker_container_name}"

    docker start ${docker_container_name} 
}

function exec_container(){
    log_info "runing: ${docker_container_name}"

    docker exec -it -w /root/shared_folder ${docker_container_name} /bin/bash
}

function is_build_image(){
  read -p "Do you want to build [$docker_image_name] iamge? (Y/n) " choice

  case "$choice" in
    y|Y )
      log_info "Compiling [$docker_image_name]"
      $SCRIPT_DIR/docker_build.sh
      ;;
    n|N )
      exit 1
      ;;
    * )
      log_error "Invalid input. Please enter Y or N."
      exit 1
      ;;
  esac
}

function is_rm_container(){
  read -p "Do you want to remove [$docker_container_name] container? (Y/n) " choice

  case "$choice" in
    y|Y )
      log_info "Compiling [$docker_container_name]"
      ;;
    n|N )
      exit 1
      ;;
    * )
      log_error "Invalid input. Please enter Y or N."
      exit 1
      ;;
  esac
}

function is_rm_container(){
  read -p "Do you want to remove [$docker_container_name] container? (Y/n) " choice

  case "$choice" in
    y|Y )
      log_info "Removing container [$docker_container_name]"

      if docker ps --format '{{.Names}} {{.State}}' | grep -q "${docker_container_name} running"; then
        docker stop ${docker_container_name}
      fi

      docker rm $docker_container_name
      ;;
    n|N )
      ;;
    * )
      log_error "Invalid input. Please enter Y or N."
      ;;
  esac
}


function main(){
    if docker images | grep -q "${docker_image_name}"; then
        log_info "docker image exists [${docker_image_name}]"
    else
        log_error "docker image [$docker_container_name] not exists"
        is_build_image
    fi

    if docker ps -a | grep -q "${docker_container_name}"; then
        log_warning "docker container exists [$docker_container_name]"
        # is_rm_container
        install_container
    else
        install_container
    fi

    if docker ps --format '{{.Names}} {{.State}}' | grep -q "${docker_container_name} running"; then
        exec_container
    else
        start_container
        exec_container
    fi
}
main