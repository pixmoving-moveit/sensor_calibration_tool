#!/bin/bash
# docker_image=ros:melodic-ros-core-bionic  
docker_image=sensor_calibration_tool:latest 
docker run  --network host --rm --name test -it  $docker_image