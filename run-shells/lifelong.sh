#!/bin/bash

echo "Running roslaunch slam toolbox..."

source /catkin_ws/install/setup.bash

roslaunch --wait /launch/lifelong.launch
