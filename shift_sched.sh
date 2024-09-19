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

# Define colors
COLOR_RESET="\033[0m"
COLOR_BLUE="\033[1;34m"  
COLOR_ERROR="\033[1;31m"  
COLOR_SUCCESS="\033[1;32m" 

echo ""
echo -e "${COLOR_BLUE}-----------------------------------------------------------------------------------${COLOR_RESET}"

# Centered title
console_width=80
title="SHIFT SCHEDULING APP"
title_length=${#title}
padding=$(( (console_width - title_length) / 2 ))
printf "%*s%s%*s\n" $padding "" "${title}" $padding ""

echo -e "${COLOR_BLUE}-----------------------------------------------------------------------------------${COLOR_RESET}"

while true; do
    echo ""
    # Input for name
    read -p "Enter employee name: " varname
    if [ "$varname" == "print" ]; then
        if [ ${#name_arrays[@]} -eq 0 ] && [ ! -s "$data_file" ]; then
            echo ""
            echo -e "${COLOR_ERROR}No data inputted${COLOR_RESET}"
            echo ""
            break
        fi
 
        echo ""
	echo -e "${COLOR_BLUE}-----------------------------------------------------------------------------------${COLOR_RESET}"
        # Print table header
	printf "%-20s %-20s %-20s %-20s\n" "Team" "Name" "Shift" "Time"	
	echo -e "${COLOR_BLUE}$(printf "%-20s %-20s %-20s %-20s" "--------------------" "--------------------" "--------------------" "--------------------")${COLOR_RESET}" 
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

    elif [ "$varname" == "cleardb" ]; then

    	> "$data_file"     
        name_arrays=()
   	echo ""	
	echo -e "${COLOR_SUCCESS}Database cleared.${COLOR_RESET}"
	echo ""
	exit 1

    else

	prevname=$(echo "$varname" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' | tr -d ' ')

        # Input for shift
        read -p "Enter shift: " varsched
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
                echo -e "${COLOR_ERROR}Invalid input in Schedule. Please input (Morning), (Mid), or (Night) only. Try again.${COLOR_RESET}"
                continue;;
        esac
 
        shift_count=$(count_shift_occurrences "$vartime")
        if [ $shift_count -ge 2 ]; then
            echo ""
            echo -e "${COLOR_ERROR}The $vartime shift already has 2 people. Exiting the program.${COLOR_RESET}"
            echo ""
	    exit 1
        fi
 
        # Input for team
        read -p "Enter team: " varteam
        varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')
        case $varteam in
            A1|A2|A3|B1|B2|B3)
                # Check if the same team
                team_count=$(count_team_occurrences "$varteam")
                if [ $team_count -ge 2 ]; then
                    echo ""
                    echo -e "${COLOR_ERROR}The $varteam team already has 2 people. Exiting the program.${COLOR_RESET}"
                    echo ""
		    exit 1
                fi
                # Send the data to the array
                entry="Name=$prevname Shift=$vartime Team=$varteam"
                name_arrays+=("$entry")
                # Save to file
                printf "%s\n" "$entry" >> "$data_file"

		echo ""
		echo -e "${COLOR_SUCCESS}Employee added successfully.${COLOR_RESET}"
                ;;
            *)
                echo ""
                echo -e "${COLOR_ERROR}Invalid input in Team. Please input (A1-A3), or (B1-B3) only. Try again.${COLOR_RESET}"
                continue;;
        esac
    fi
done
echo -e "${COLOR_BLUE}-----------------------------------------------------------------------------------${COLOR_RESET}"
