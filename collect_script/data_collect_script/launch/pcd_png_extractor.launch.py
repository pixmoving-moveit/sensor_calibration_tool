import os
import sys
import yaml

from launch import LaunchDescription
from launch_ros.actions import Node

from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration

from launch.actions import ExecuteProcess, RegisterEventHandler, EmitEvent
from launch.events import Shutdown
from launch.event_handlers import OnProcessExit

def generate_launch_description():

    current_file_path = os.path.dirname(os.path.abspath(__file__))

    with open(os.path.join(current_file_path, 'pcd_png_extractor.yaml'), 'r') as file:
        config_map = yaml.safe_load(file)

    pointcloud_topic = config_map["pointcloud_topic"]
    image_topic = config_map["image_topic"]
    collect_number = config_map["collect_number"]
    pcd_folder_path = os.path.join(current_file_path, "../../..", "ros2bag/pcd_png_data")
    png_folder_path = os.path.join(current_file_path, "../../..", "ros2bag/pcd_png_data")

    if not os.path.exists(png_folder_path):
        os.makedirs(png_folder_path, exist_ok=True)

    pcd_png_extractor_node = Node(
        package='data_collection',
        executable='data_collection_pcd_png_extractor_node',
        name='pcd_png_extractor_node',
        parameters=[{
            "pointcloud_topic": pointcloud_topic,
            "image_topic" : image_topic,
            "collect_number" : collect_number,
            "pcd_dir_path" : pcd_folder_path,
            "png_file_path" : png_folder_path
        }],
        output='screen')

    rs_sdk_node = Node(
        namespace='rslidar_sdk', 
        package='rslidar_sdk', 
        executable='rslidar_sdk_node', 
        output='screen',
        parameters=[{"config_path": os.path.join(current_file_path, 'config.yaml')}])
    
    camera_node = Node(
        package='usb_cam',
        executable='usb_cam_node_exe', 
        output='screen',
        name="usb_cam_node",
        parameters=[os.path.join(current_file_path, 'usb_cam_params.yaml')]
    )

    pcd_png_extractor_node_exit_handler = RegisterEventHandler(
    event_handler=OnProcessExit(
        target_action=pcd_png_extractor_node,
        on_exit=[EmitEvent(event=Shutdown())]
        ) 
    )

    return LaunchDescription([camera_node, rs_sdk_node, pcd_png_extractor_node, pcd_png_extractor_node_exit_handler])