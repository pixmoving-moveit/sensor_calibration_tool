from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration

def generate_launch_description():

    rviz_config=get_package_share_directory('rslidar_sdk')+'/rviz/rviz2.rviz'

    decl_config_path = DeclareLaunchArgument(name="config_path",default_value="")

    sdk_node = Node(
            namespace='rslidar_sdk', 
            package='rslidar_sdk', 
            executable='rslidar_sdk_node', 
            output='screen',
            parameters=[{"config_path": LaunchConfiguration("config_path")}])
    
    rviz2_node = Node(namespace='rviz2', package='rviz2', executable='rviz2', arguments=['-d',rviz_config])
    

    return LaunchDescription([decl_config_path, sdk_node])