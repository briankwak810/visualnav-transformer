#!/bin/bash

# Create a new tmux session
session_name="record_bag_$(date +%s)"
tmux new-session -d -s $session_name

# Split the window into three panes
tmux selectp -t 0    # select the first (0) pane
tmux splitw -v -p 50 # split it into two halves
tmux selectp -t 0    # go back to the first pane
tmux splitw -h -p 50 # split it into two halves

# Run the roslaunch command in the first pane
tmux select-pane -t 0
tmux send-keys "source ~/setup_vintxhab.sh" Enter
tmux send-keys "roscore" Enter

# Run the teleop.py script in the second pane
tmux select-pane -t 1
tmux send-keys "source ~/setup_vintxhab.sh" Enter
tmux send-keys "export MAGNUM_CPU_RUNTIME_DETECT=OFF" Enter
tmux send-keys "export HABITAT_SIM_LOG=quiet" Enter
tmux send-keys "export MAGNUM_LOG=quiet" Enter
tmux send-keys "python ../ros_x_habitat/src/scripts/roam_with_keyboard.py" Enter

# Change the directory to ../topomaps/bags and run the rosbag record command in the third pane
tmux select-pane -t 2
tmux send-keys "source ~/setup_vintxhab.sh" Enter
tmux send-keys "rosbag record /rgb -o $1" # change topic if necessary

# Attach to the tmux session
tmux -2 attach-session -t $session_name