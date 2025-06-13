
# Get the current display configuration using gnome-randr
CONFIG=$(gnome-randr --list)

# Generate a command to reproduce the current configuration
OUTPUT="gnome-randr"

# Parse the output from gnome-randr to build the command
while IFS= read -r line; do
    # Skip empty lines
    [[ -z "$line" ]] && continue

    # Extract the name of the output and its settings
    # Example line: "DP-1 connected 1920x1080+0+0"
    if [[ $line =~ ^([A-Z0-9-]+)\ connected\ ([0-9]+x[0-9]+)\+([0-9]+)\+([0-9]+)$ ]]; then
        OUTPUT+=" --output ${BASH_REMATCH[1]} --mode ${BASH_REMATCH[2]} --pos ${BASH_REMATCH[3]}x${BASH_REMATCH[4]}"
    elif [[ $line =~ ^([A-Z0-9-]+)\ disconnected$ ]]; then
        OUTPUT+=" --output ${BASH_REMATCH[1]} --off"
    fi
done <<< "$CONFIG"

# Print the command to reproduce the configuration
echo "$OUTPUT"
