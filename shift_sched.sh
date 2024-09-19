#!/bin/bash
data_file="data.txt"
 
# Load existing data from the file into an array
declare -a name_arrays
if [ -s "$data_file" ]; then
    while IFS= read -r line; do
        name_arrays+=("$line")
    done < "$data_file"
fi
 
# Counter for multiple teams
count_team_occurrences() {
    local to_check="$1"
    local count=0
    for entry in "${name_arrays[@]}"; do
        if [[ "$entry" == *"Team=$to_check"* ]]; then
            ((count++))
        fi
    done
    echo $count
}
 
# Counter for multiple shifts
count_shift_occurrences() {
    local to_check="$1"
    local count=0
    for entry in "${name_arrays[@]}"; do
        if [[ "$entry" == *"Shift=$to_check"* ]]; then
            ((count++))
        fi
    done
    echo $count
}
 
while true; do
    echo ""
    # Input for name
    read -p "Name: " varname
    if [ "$varname" == "print" ]; then
        if [ ${#name_arrays[@]} -eq 0 ] && [ ! -s "$data_file" ]; then
            echo ""
            echo "No data inputted"
            echo ""
            break
        fi
 
        echo ""
        echo "-----------------------------------------------------------------------------------"
        # Print table header
        printf "%-20s %-20s %-20s %-20s\n" "Team" "Name" "Shift" "Time"
        printf "%-20s %-20s %-20s %-20s\n" "--------------------" "--------------------" "--------------------" "--------------------"
 
        # Read and print data from the array
        for entry in "${name_arrays[@]}"; do
            team=$(echo "$entry" | awk -F' ' '{print $4}' | cut -d'=' -f2)
            name=$(echo "$entry" | awk -F' ' '{print $1}' | cut -d'=' -f2)
            shift=$(echo "$entry" | awk -F' ' '{print $2}' | cut -d'=' -f2)
            time=$(echo "$entry" | awk -F' ' '{print $3}' | cut -d'=' -f2)
            printf "%-20s %-20s %-20s %-20s\n" "$team" "$name" "$shift" "$time"
        done
 
        echo ""
        break
    else
        first_char=$(printf "%s" "$varname" | cut -c1 | tr '[:lower:]' '[:upper:]')
        rest_chars=$(printf "%s" "$varname" | cut -c2-)
        prevname="$first_char$rest_chars"
        # Input for shift
        read -p "Shift: " varsched
        varsched=$(echo "${varsched^}")
        case $varsched in
            Morning)
                vartime="Morning 6am-3pm";;
            Mid)
                vartime="Mid 2pm-11pm";;
            Night)
                vartime="Night 10pm-7am";;
            *)
                echo ""
                echo "Invalid input in Schedule. Please input (Morning), (Mid), or (Night) only. Try again."
                continue;;
        esac
 
        shift_count=$(count_shift_occurrences "$vartime")
        if [ $shift_count -ge 2 ]; then
            echo ""
            echo "Shift $vartime already has 2 people. Exiting program."
            exit 1
        fi
 
        # Input for team
        read -p "Team: " varteam
        varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')
        case $varteam in
            A1|A2|A3|B1|B2|B3)
                # Check if the same team
                team_count=$(count_team_occurrences "$varteam")
                if [ $team_count -ge 2 ]; then
                    echo ""
                    echo "Team $varteam already has 2 people. Exiting program."
                    exit 1
                fi
                # Send the data to the array
                entry="Name=$prevname Shift=$vartime Team=$varteam"
                name_arrays+=("$entry")
                # Save to file
                printf "%s\n" "$entry" >> "$data_file"
                ;;
            *)
                echo ""
                echo "Invalid input in Team. Please input (A1-A3), or (B1-B3) only. Try again."
                continue;;
        esac
    fi
done
