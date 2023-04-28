#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../../common_script/log.sh

# shell function to check if a ROS2 topic has output
function check_ros2_topic {
    local topic_name=$1
    local timeout_time=${2:-2s}

    start=$(date +%s.%N) 
    timeout $timeout_time ros2 topic echo  ${topic_name} --once  > /dev/null 2>&1
    
    if [ ! $? -eq 0 ]; then
        end=$(date +%s.%N)
        runtime=$(echo "$end - $start" | bc)

        if (( $(echo "$runtime > 1" | bc -l) )); then  
            log_error "$topic_name -- NoData"
        else
            log_error "$topic_name -- non-existent"
        fi
        
        return 1
    fi

    local output=""
    output=$(ros2 topic echo ${topic_name} --once 2>/dev/null)

    if [[ ! -z "${output}" ]]; then
        log_info "$topic_name -- state normal"
        return 0
    fi
}

function read_topic_names(){
    topic_names=$(yq e '.topic_names | .[]' $1)
    # output:/sensing/gnss/pose /sensing/lidar/top/rslidar_sdk/rs/points
    conut=0

    for ITEM in $topic_names; do
        check_ros2_topic $ITEM
        conut=$(expr $conut + $?)
    done
    
    if [[ $conut>0 ]];then
        log_error "Record the success or failure of the topic"
        exit 1
    fi
}

function collect_ros2bag(){
    bag_prefix_name=$(yq e '.bag_prefix_name' $config_name)
    ros2bag_path="$SCRIPT_DIR/../../ros2bag/"$bag_prefix_name"_"$(date +"%Y-%m-%d-%H_%M_%S")

    log_info "Start collect:[$ros2bag_path]"
    # # output: gnss_lidar_2023-04-25-11_07_02
    ros2 bag record -o $ros2bag_path $topic_names
    ln -sf $ros2bag_path "$SCRIPT_DIR/../../ros2bag/$bag_prefix_name""_latest_ros2bag"
}

function main(){
    topic_names=""
    config_name=$1

    source ~/pix/pit-kit/Autoware/install/setup.bash 

    if [ -z "$config_name" ];then
        log_error "请输入[ ./collect_ros2bag.sh imu.yaml]"
        exit 1
    fi
    
    read_topic_names $config_name
    collect_ros2bag
    
    # log_info "collect Success:[$bag_prefix_name]"
}
main $1
