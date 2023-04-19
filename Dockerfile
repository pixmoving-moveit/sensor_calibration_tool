FROM ros:melodic-ros-core-bionic
LABEL maintainer="zumouse <zymouse@pixmoving.net>"

ENV DEBIAN_FRONTEND noninteractive

COPY ${dockerfile_path}/shared_folder/docker_copy.tar.gz /root/


RUN tar -xzf /root/docker_copy.tar.gz -C /root/ \
    && mkdir -p /root/sensor_driver_ws/src \
    && mv /root/docker_copy/bag2png/  /root/sensor_driver_ws/src/ \
    && mv /root/docker_copy/yq /usr/bin/yq

RUN sed -i s@/archive.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list \
    && apt-get clean \
    # apt instll base dependmen ------------------------------------------------------------------------
    && apt-get update  && apt install -y --no-install-recommends \
    git \
    vim \
    build-essential \
    libyaml-cpp-dev \
    libpcap-dev \
    iputils-ping \
    # ROS dependent package
    ros-melodic-usb-cam \
    ros-melodic-pcl-ros \
    ros-melodic-image-view \
    ros-melodic-ublox-msgs \
    # ROS imu
    libceres-dev \
    libdw-dev \
    && rm -rf /var/lib/apt/lists/*  \
    # ROS ENV -------------------------------------------------------------------------------------
    && echo source /opt/ros/melodic/setup.bash >> /root/.bashrc \
    # intall rs16  ros workspace && mkdir -p /root/sensor_driver_ws/src 
    && cd /root/sensor_driver_ws/src \
    && git clone -b ros1 https://github.com/pixmoving-moveit/rslidar_sdk.git \
    && git clone -b bugfix/code_utils https://github.com/pixmoving-moveit/code_utils.git \
    && git clone https://github.com/gaowenliang/imu_utils.git \
    && git clone -b feature/melodic-devel/chc https://github.com/pixmoving-moveit/nmea_navsat_driver.git \
    && cd /root/sensor_driver_ws/src/rslidar_sdk && git submodule init && git submodule update \
    # catkin_make ROS package
    && cd /root/sensor_driver_ws/ \
    && /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make --only-pkg-with-deps code_utils" \
    && /bin/bash -c "source /opt/ros/melodic/setup.bash && source /root/sensor_driver_ws/devel/setup.bash  && catkin_make" \
    && cd /root/ && mkdir shared_folder && chmod 777 -R /root/shared_folder/

CMD ["/bin/bash"]