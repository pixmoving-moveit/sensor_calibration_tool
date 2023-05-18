import os
import sys
import yaml

from launch import LaunchDescription
from launch_ros.actions import Node

from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource

from launch.actions import ExecuteProcess
from launch.actions import TimerAction

def generate_launch_description():
    current_file_path = os.path.dirname(os.path.abspath(__file__))

    with open(os.path.join(current_file_path, 'config.yaml'), 'r') as file:
       config_map = yaml.safe_load(file)

    # Include another launch file
    imu_cail_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(
            os.path.join(current_file_path, "cgi_imu.launch.py")
        ),
        launch_arguments={'data_save_path': 
          os.path.join(current_file_path, '..', 'output', 'output_')}.items()
    )
    
    # Play a ROS2 bag file
    bag_dir = os.path.join(current_file_path, "..", "..", "..", "rosbag/ros2bag/imu_latest_ros2bag")
    if not os.path.exists(bag_dir):
        print(f'\x1b[31m[ERROR] Launch file {bag_dir} not found\x1b[0m')
        sys.exit(1)
    
    bag_player = ExecuteProcess(
        cmd=['ros2', 'bag', 'play', '-r', "200", bag_dir],
        output='screen'
    )

    return LaunchDescription([
        imu_cail_launch,
        TimerAction(
            period=1.0,
            actions=[bag_player]
        )
    ])
