FROM ros:kinetic-ros-base-xenial

# USE BASH
SHELL ["/bin/bash", "-c"]

# RUN LINE BELOW TO REMOVE debconf ERRORS (MUST RUN BEFORE ANY apt-get CALLS)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils

# slam_toolbox
RUN mkdir -p catkin_ws/src
RUN cd catkin_ws/src && git clone https://github.com/SteveMacenski/slam_toolbox.git
RUN source /opt/ros/kinetic/setup.bash \
    && cd catkin_ws \
    && rosdep update \
    && rosdep install -y -r --from-paths src --ignore-src --rosdistro=kinetic -y

RUN apt install python-catkin-tools -y
RUN source /opt/ros/kinetic/setup.bash \ 
    && cd catkin_ws/src \
    && catkin_init_workspace \
    && cd .. \
    && catkin config --install \
    && catkin build -DCMAKE_BUILD_TYPE=Release

#RUN echo "source /catkin_ws/install/setup.bash" >> ~/.bashrc

#COPY ros-entrypoint.sh /ros-entrypoint.sh
#ENTRYPOINT ["/ros-entrypoint.sh"]

COPY run-shells /run-shells
COPY launch /launch
COPY config /config
COPY maps /maps

ENV ROS_MASTER_URI "http://ros-master:11311"

