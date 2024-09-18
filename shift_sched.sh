#!/bin/bash

declare -a name_arrays

# counter for multiple team
count_team_occurrences() {
    local to_check="$1"
    local count=0

    for entry in "${name_arrays[@]}";
        do
            if [[ "$entry" == *"Team=$to_check"* ]];
                then
                    ((count++))
                fi
        done
    echo $count
}
# counter for multiple shifts
count_shift_occurrences() {
    local to_check="$1"
    local count=0

    for entry in "${name_arrays[@]}";
        do
            if [[ "$entry" == *"Shift=$to_check"* ]];
                then

                    ((count++))
                fi

        done

    echo $count
}

while true; do

    declare -A name_array

    echo ""
    # input for name
    read -p "Name: " varname
        if [ $varname == "print" ]
            then
                if [ ${#name_arrays[@]} -eq 0 ];
                    then
			echo ""
                        # If print is inputted on the first run
                        echo "No data inputted"
			echo ""
                    break
                else
		    echo ""
		    echo ""	
                    echo "-----------------------------------------------------------------------------------"
                    # Print table header
                    printf "%-20s %-20s %-20s %-20s\n" "Team" "Name" "Shift" "Time"
                    printf "%-20s %-20s %-20s %-20s\n" "--------------------" "--------------------" "--------------------" "--------------------"
                    # Print table rowsii
                    for entry in "${name_arrays[@]}";
                        do
                            team=$(echo "$entry" | awk -F' ' '{print $4}' | cut -d'=' -f2)
                            name=$(echo "$entry" | awk -F' ' '{print $1}' | cut -d'=' -f2)
                            shift=$(echo "$entry" | awk -F' ' '{print $2}' | cut -d'=' -f2)
                            time=$(echo "$entry" | awk -F' ' '{print $3}' | cut -d'=' -f2)

                            printf "%-20s %-20s %-20s %-20s\n" "$team" "$name" "$shift" "$time"
                        done


                    # Debug
                        #echo "Raw entries in name_arrays:"
                            #for entry in "${name_arrays[@]}"; do
                                            #echo "$entry"
                                                #done
                    echo ""
                fi
            break
        else

            first_char=$(printf "%s" "$varname" | cut -c1 | tr '[:lower:]' '[:upper:]')
            rest_chars=$(printf "%s" "$varname" | cut -c2-)
            prevname="$first_char$rest_chars"

	    # input for sched
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
		    
                    varname=''
                    prevname=''
                    vartime=''
                    varsched=''
                    varteam=''
                    continue;;
            esac

            shift_count=$(count_shift_occurrences "$vartime")
            if [ $shift_count -ge 2 ];
                then
		    echo ""
                    echo "Shift $vartime already has 2 people. Exiting program."
                    echo ""
		    exit 1
                fi

	    # input for team
            read -p "Team: " varteam

            varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')
            case $varteam in
                A1|A2|A3|B1|B2|B3)

                    # Check if same team
                    team_count=$(count_team_occurrences "$varteam")
                    if [ $team_count -ge 2 ];
                        then
			    echo ""
                            echo "Team $varteam already has 2 people please try again. Exiting program."
                            echo ""
			exit 1
                    fi

                    # send the data to the array
                    entry="Name=$prevname Shift=$vartime Team=$varteam"
                    name_arrays+=("$entry")
                    
		    ;;
                *)
		    echo ""
                    echo "Invalid input in Team. Please input (A1-A3), or (B1-B3) only. Try again."
                    
		    varname=''
                    prevname=''
                    vartime=''
                    varsched=''
                    varteam=''
                    continue;;
            esac
        fi
done
