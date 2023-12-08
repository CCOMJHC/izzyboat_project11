#!/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/logs"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_${NOW}.txt"

{

echo ""
echo "#############################################"
echo "Running start_tmux_project11.bash"
date
echo "#############################################"
echo ""
echo "Logs:"

source /opt/ros/noetic/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

set -v

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.1.5

#wait for dora to be pingable by self
while ! ping -c 1 -W 1 dora; do
    echo "Waiting for ping to dora..."
    sleep 1
done

echo "Wait 5 seconds before launching ROS..."
sleep 5

/usr/bin/tmux new -d -s roscore roscore

/usr/bin/tmux new -d -s project11 
/usr/bin/tmux send-keys "rosrun rosmon rosmon --name=rosmon_izzyboat izzyboat_project11 izzyboat.launch logDirectory:=${LOGDIR} operator_host:=salmonib" C-m

} >> "${LOG_FILE}" 2>&1
