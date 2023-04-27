from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration


def generate_launch_description():

    decl_data_save_path = DeclareLaunchArgument(name="data_save_path",default_value="")
    # Set the parameters in the parameter server
    # SetLaunchConfiguration('parameter_name', 'parameter_value')
    imu_an_node = Node(
            namespace='imu_utils', 
            package='ros2_imu_utils', 
            executable='imu_an', 
            output='screen',
            parameters=[
                {'imu_topic': '/chc/imu'},
                {'imu_name': 'cgi410'},
                {'data_save_path': LaunchConfiguration("data_save_path")},
                {'max_time_min': 120},
                {'max_cluster': 50},
            ])
    
    return LaunchDescription([decl_data_save_path, imu_an_node])