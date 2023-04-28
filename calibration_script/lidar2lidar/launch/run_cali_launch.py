import os
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration, Command
from launch_ros.actions import Node


from launch.actions import ExecuteProcess, RegisterEventHandler, EmitEvent
from launch.events import Shutdown
from launch.event_handlers import OnProcessExit


def generate_launch_description():

    current_path = os.path.dirname(os.path.abspath(__file__))

    sdk_node = Node(
            namespace='rslidar_sdk', 
            package='rslidar_sdk', 
            executable='rslidar_sdk_node', 
            output='screen',
            parameters=[{"config_path": os.path.join(current_path, "config.yaml")}])
    
    lidar2lidar_node = Node(
            package='multi_lidar_calib',
            executable='multi_lidar_calib',
            name='multi_lidar_calib_node',
            parameters=[os.path.join(current_path, 'params.yaml')],
            output='screen'
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
        sdk_node,
        lidar2lidar_node,
        lidar2lidar_exit_handler,
    ])
