#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

build_path=$1
cd $build_path

colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release