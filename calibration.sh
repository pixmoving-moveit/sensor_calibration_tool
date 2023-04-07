#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/script/log.sh

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
    $SCRIPT_DIR/script/docker_build.sh
    ;;

    exec)
    log_info "docker exec"
    $SCRIPT_DIR/script/docker_exec.sh
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

  parse_arguments $@

}
main $@