FROM ros:melodic-ros-core-bionic
LABEL maintainer="zumouse <zymouse@pixmoving.net>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update  \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:rmescandon/yq  \
    && apt update \
    # apt instll base dependmen
    && apt install -y --no-install-recommends \
    git \
    yq \
    build-essential \
    libyaml-cpp-dev \
    libpcap-dev \
    # ROS dependent package
    ros-melodic-usb-cam \
    ros-melodic-pcl-ros \
    ros-melodic-image-view \
    && rm -rf /var/lib/apt/lists/* \
    # ROS ENV
    && echo source /opt/ros/melodic/setup.bash >> /root/.bashrc \
    # intall rs16  ros workspace
    && mkdir -p /root/sensor_driver_ws/src && cd /root/sensor_driver_ws/src && git clone -b ros1 https://github.com/pixmoving-moveit/rslidar_sdk.git \
    && cd /root/sensor_driver_ws/src/rslidar_sdk && git submodule init && git submodule update \
    && mkdir -p /app && chmod 777 /app

COPY ${dockerfile_path}/docker_copy/docker_copy.tar.gz /app/

RUN tar -xzf /app/docker_copy.tar.gz -C /app/ \
    && mv /app/docker_copy/bag2png/  /root/sensor_driver_ws/src/ \
    && mv /app/docker_copy/get_cail_data/  /root/ \
    # catkin_make ROS package
    && cd /root/sensor_driver_ws/ \
    && /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"


CMD ["/bin/bash"]