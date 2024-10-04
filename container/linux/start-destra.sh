tmux new-session -d -s storage-node

# Run the storage node inside the tmux session
tmux send-keys -t storage-node "npm run destra-storage-node" C-m

echo "Destra Storage Node setup completed and running in tmux session 'storage-node'."


# Define the process name or command to check for
PROCESS_NAME="storage-node"

# Define the sleep interval in seconds
SLEEP_INTERVAL=5

# Function to check if the process is running
check_process() {
    if pgrep -f "$PROCESS_NAME" > /dev/null; then
        return 0  # Process exists
    else
        return 1  # Process does not exist
    fi
}

# Main loop to check for process existence
while true; do
    if check_process; then
        echo "$(date): $PROCESS_NAME is running."
        tmux capture-pane -p -S -
    else
        echo "$(date): $PROCESS_NAME is not running."
        echo "$(date): $PROCESS_NAME died, ceasing health check tests, dumping last log entries from tmux and quitting..."
        tmux capture-pane -p -S -
        exit 1
    fi

    # Sleep before checking again
    sleep $SLEEP_INTERVAL
done
