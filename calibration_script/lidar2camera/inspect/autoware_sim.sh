SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
 
source ~/pix/pit-kit/Autoware/install/setup.bash 
ros2 launch autoware_launch planning_simulator.launch.xml vehicle_model:=pixkit sensor_model:=pixkit_sensor_kit map_path:=/home/pixkit/pix/map/factory_20230325