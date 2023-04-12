#!/bin/bash

function log_info() {
  echo -e "\033[32m[INFO] $*\033[0m"
}

function log_warning() {
  echo -e "\033[33m[WARNING] $*\033[0m"
}

function log_error() {
  echo -e "\033[31m[ERROR] $*\033[0m"
}

function is_absolute_path(){
  case "$1" in
    /*)
        return 1 # Absolute path
        ;;
    *)
        return 0 # Relative path
        ;;
  esac
}


function is_file_exists() {
    if [ -e "$1" ]
    then
        return 1   # "File exists."
    else
        return 0  # "File does not exist."
    fi
}

function common_main(){
  script_name=$(basename "$0")

  if [ "$script_name" = "common.sh" ]; then
      # 主程序代码块
      echo "This is the main program."
  else
      # 模块代码块
      echo "This is a module."
  fi
}
common_main