import os
import yaml

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration, Command
from launch_ros.actions import Node


from launch.actions import ExecuteProcess, RegisterEventHandler, EmitEvent
from launch.events import Shutdown
from launch.event_handlers import OnProcessExit


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
    

    source_pointcloud_filters = Node(
        package='multi_lidar_calibration',
        executable='point_cloud_filter_node',
        name='source_point_cloud_filter_node',
        output='screen',
        parameters=[{
            'input_topic_name': config_map["source_pointcloud_filter"]["input_topic_name"],
            'output_topic_name': config_map["source_pointcloud_filter"]["output_topic_name"],
            "min_x": config_map["source_pointcloud_filter"]["min_x"],
            "max_x": config_map["source_pointcloud_filter"]["max_x"],

            "min_y": config_map["source_pointcloud_filter"]["min_y"],
            "max_y": config_map["source_pointcloud_filter"]["max_y"],

            "min_z": config_map["source_pointcloud_filter"]["min_z"],
            "max_z": config_map["source_pointcloud_filter"]["max_z"],
        }]
    )
    

    lidar2lidar_node = Node(
        package='multi_lidar_calibration',
        executable='multi_lidar_calibration_ndt_node',
        name='multi_lidar_calibration_ndt_node',
        output='screen',
        parameters=[{
            'initial_pose':config_map[ "initial_pose"],
            'leaf_size': config_map["leaf_size"],
            'max_iteration': config_map["max_iteration"],
            'transform_epsilon': config_map["transform_epsilon"],
            'step_size': config_map["step_size"],
            'resolution': config_map["resolution"],
        }],
        remappings=[
            ('~/input/source_pointcloud', config_map["source_pointcloud"]),
            ('~/input/target_pointcloud', config_map["target_pointcloud"]),
        ]
    )
    
    rviz2_node = Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            arguments=['-d', os.path.join(current_path, 'rviz2.rviz')],
            parameters=[{"rviz2_log_level": "none"}],
            output='log'
        )


    lidar2lidar_exit_handler = RegisterEventHandler(
    event_handler=OnProcessExit(
        target_action=lidar2lidar_node,
        on_exit=[EmitEvent(event=Shutdown())]
        ) 
    )

    return LaunchDescription([
        # sdk_node,
        # source_pointcloud_filters,
        lidar2lidar_node,
        # lidar2lidar_exit_handler
    ])
