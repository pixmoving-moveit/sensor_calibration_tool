import os
import sys
import yaml

from launch import LaunchDescription
from launch_ros.actions import Node

from launch.actions import ExecuteProcess, RegisterEventHandler, EmitEvent
from launch.events import Shutdown
from launch.event_handlers import OnProcessExit

def generate_launch_description():
    current_file_path = os.path.dirname(os.path.abspath(__file__))

    with open(os.path.join(current_file_path, 'lidar_imu_data.yaml'), 'r') as file:
       config_map = yaml.safe_load(file)

    bag_dir = os.path.join(current_file_path, '../../..', 'ros2bag/gnss_lidar_latest_ros2bag')
    if not os.path.exists(bag_dir):
        print(f'\x1b[31m[ERROR] Launch file {bag_dir} not found\x1b[0m')
        sys.exit(1)

    bag_player = ExecuteProcess(
        cmd=['ros2', 'bag', 'play', bag_dir],
        output='screen'
    )

    pcd_dir_path = os.path.join(current_file_path, '../../..', 'ros2bag/gnss_lidar/lidar_top')
    pose_file_path = os.path.join(current_file_path, '../../..', 'ros2bag/gnss_lidar/lidar_gnss_pose.txt')
    pointcloud_topic = config_map["pointcloud_topic"]
    pose_topic = config_map["pose_topic"]

    if not os.path.exists(pcd_dir_path):
	    os.makedirs(pcd_dir_path, exist_ok=True)

    lidar_imu_node = Node(
      package='data_collection',
      executable='data_collection_lidar_imu_node',
      name='data_collection_lidar_imu_node',
      output='screen',
      parameters=[{
          'pcd_dir_path': pcd_dir_path,
          'pose_file_path': pose_file_path,
          'pointcloud_topic': pointcloud_topic,
          'pose_topic': pose_topic}]
        )
    
    bag_player_exit_handler = RegisterEventHandler(
        event_handler=OnProcessExit(
            target_action=bag_player,
            on_exit=[EmitEvent(event=Shutdown())]
        )
    )

    return LaunchDescription([
        lidar_imu_node, 
        bag_player,
        bag_player_exit_handler])
