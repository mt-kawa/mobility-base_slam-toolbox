# ROS Node for LifeLong Mapping

Extensive 2D SLAM library for creating and maintaining mobile robot navigation
maps. Check out the project on
[GitHub](https://github.com/SteveMacenski/slam_toolbox) for more information.

## Introduction

This project creates a Docker images to be used in any environment. Although it
is limited by ROS Kinetic message definitions. It was originally built for the
Mobility Base for Baxter but should be easily portable to other platforms using
the provided image and compose files.

## Building the Image Yourself

Clone the repository using git and build the image using

```zsh
docker build -t ros-kinetic-slam-toolbox .
```

## Use It in Your Compose

To use this node in conjunction with the rest of the environment add it to the
same network. Define the dependencies of the node, which usually should be some
odometry source. Further, to be able to (de-)serialize maps create and add a
volume to the node. Also give some names and set the ROS environment variables.
Finally, run the lifelong mapping node using the shell script provided in the
container or create your own.

```yaml
ros-slam-toolbox:
        image: ros-kinetic-slam-toolbox:latest
        depends_on:
                - ros-odom
        container_name: ros-slam-toolbox
        hostname: ros-slam-toolbox
        networks:
                - ros-overnet
        environment:
                - ROS_HOSTNAME=ros-slam-toolbox
                - ROS_MASTER_URI=http://ros-master:11311
        volumes:
                - maps:/root/.ros/
        command: /run-shells/lifelong.sh
```

## Serializing a Map

```zsh
rosservice call /slam_toolbox/serialize_map map_name
```

## Deserializing a Map

```zsh
rosservice call /slam_toolbox/deserialize_map "{filename: map_name, match_type: 1, initial_pose: {x: 0.0, y: 0.0, theta: 0.0}}"
```
