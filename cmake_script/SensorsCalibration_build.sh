#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/log.sh

build_path=$1
cd $build_path

function main(){
    $SCRIPT_DIR/cmake_build.sh
}
main