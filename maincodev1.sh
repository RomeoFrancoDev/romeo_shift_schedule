#!/bin/bash

declare -a name_arrays


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

    read -p "Name: " varname
        if [ $varname == "print" ]
            then
                if [ ${#name_arrays[@]} -eq 0 ];
                    then
                        # If print is inputted on the first run
                        echo "No data inputted"
                    break
                else
                        ### Fetch the data from the other file here ###
                        #echo Fetched the data: Name:$prevname Shift:$vartime Team:$varteam
                        #Print the array
                        for i in "${!name_arrays[@]}";
                        do
                            echo "Set $((i+1))"
                            echo "${name_arrays[$i]}"
                            echo ""
                        done
                    break
            fi
        else

            first_char=$(printf "%s" "$varname" | cut -c1 | tr '[:lower:]' '[:upper:]')
            rest_chars=$(printf "%s" "$varname" | cut -c2-)
            prevname="$first_char$rest_chars"

            read -p "Shift: " varsched
            case $varsched in
                morning)
                    vartime="Morning 6am-3pm";;
                mid)
                    vartime="Mid 2pm-11pm";;
                night)
                    vartime="Night 10pm-7am";;
                *)
                    echo "Invalid input in Schedule. Please input (morning), (mid), or (night) only. Try again."
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
                    echo "Shift $vartime already has 2 people. Exiting program."
                    exit 1
                fi

            read -p "Team: " varteam

            varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')
            case $varteam in
                A1|A2|A3|B1|B2|B3)

                    # Check if same team
                    team_count=$(count_team_occurrences "$varteam")
                    if [ $team_count -ge 2 ];
                        then
                            echo "Team $varteam already has 2 people please try again. Exiting program."
                        exit 1
                    fi

                    ### Send the data to the other file here ###

                    entry="Name=$prevname Shift=$vartime Team=$varteam"
                    name_arrays+=("$entry")
                    ;;
                *)
                    echo "Invalid input in Team. Please input (a1-a3), or (b1-b3) only. Try again."
                    varname=''
                    prevname=''
                    vartime=''
                    varsched=''
                    varteam=''
                    continue;;
            esac
        fi
done
