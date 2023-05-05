import os
import yaml

from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration

def generate_launch_description():

    current_path = os.path.dirname(os.path.abspath(__file__))

    with open(os.path.join(current_path, 'params.yaml'), 'r') as file:
       config_map = yaml.safe_load(file)


    sdk_node = Node(
            namespace='rslidar_sdk', 
            package='rslidar_sdk', 
            executable='rslidar_sdk_node', 
            output='screen',
            parameters=[{"config_path": os.path.join(current_path, "config.yaml")}])
    
    return LaunchDescription([sdk_node])
