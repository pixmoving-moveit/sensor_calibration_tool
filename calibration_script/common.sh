#!/bin/bash

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