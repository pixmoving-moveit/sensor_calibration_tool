#!/bin/bash
source ~/pix/pit-kit/Autoware/install/setup.bash

PoseStamped=$($SCRIPT_DIR/../../yq e '.' PoseStamped.yaml)
ros2 topic pub -1 /planning/mission_planning/goal geometry_msgs/msg/PoseStamped "$PoseStamped"