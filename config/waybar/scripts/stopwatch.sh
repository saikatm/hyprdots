#!/usr/bin/env bash

# Initialize variables
seconds=0
running=0
file="/tmp/waybar_stopwatch_status"

# Create status file if it doesn't exist
echo "$seconds $running" > "$file"

# Function to format seconds to HH:MM:SS
format_time() {
    local T=$1
    printf "%02d:%02d:%02d" $((T/3600)) $(((T/60)%60)) $((T%60))
}

# Handle left click (toggle play/pause)
if [[ "$WAYBAR_CLICK" == "1" ]]; then
    read seconds running < "$file"
    if [[ $running -eq 0 ]]; then
        running=1
    else
        running=0
    fi
    echo "$seconds $running" > "$file"
    exit 0
fi

# Handle right click (reset)
if [[ "$WAYBAR_CLICK" == "3" ]]; then
    running=0
    seconds=0
    echo "$seconds $running" > "$file"
    exit 0
fi

# Main loop for updating time
while true; do
    read seconds running < "$file"
    if [[ $running -eq 1 ]]; then
        ((seconds++))
        echo "$seconds $running" > "$file"
    fi
    echo "{\"text\":\"$(format_time $seconds)\", \"tooltip\":\"Left click: Play/Pause | Right click: Reset\"}"
    sleep 1
done
