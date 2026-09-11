#!/data/data/com.termux/files/usr/bin/bash
tmux new-session -d -c ~/Ashen -s azeroth './bin/authserver' \; split-window -h -c ~/Ashen './bin/worldserver' \; attach
