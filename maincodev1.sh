#!/bin/bash

declare -A name_array_1
declare -A name_array_2
declare -A name_array_3

set_counter=1

count_team_occurrences() {
    local team_to_check="$1"
    local count=0

    for array in name_array_1 name_array_2 name_array_3;
        do
            eval "team_value=\${$array[Team]}"
                    if [[ "$team_value" == "$team_to_check" ]];
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
                if [[ -z ${name_array_1["Shift"]} && -z ${name_array_2["Shift"]} && -z ${name_array_3["Shift"]} ]];
                    then
                        # If print is inputted on the first run
                        echo "No data inputted"
                    break
                else
                        ### Fetch the data from the other file here ###
                        #echo Fetched the data: Name:$prevname Shift:$vartime Team:$varteam
                        #Print the array
                        for i in 1 2 3;
                        do
                            case $i in
                                1)
                                    name_array=("${name_array_1[@]}")
                                    echo "Set $i"
                                    for key in "${!name_array_1[@]}";
                                    do
                                        echo "$key: ${name_array_1[$key]}"
                                    done
                                    ;;
                                2)
                                    name_array=("${name_array_2[@]}")
                                    echo "Set $i"
                                    for key in "${!name_array_2[@]}";
                                    do
                                        echo "$key: ${name_array_2[$key]}"
                                    done
                                    ;;
                                3)
                                    name_array=("${name_array_3[@]}")
                                    echo "Set $i"
                                    for key in "${!name_array_3[@]}";
                                    do
                                        echo "$key: ${name_array_3[$key]}"
                                    done
                                    ;;
                            esac

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
                    #echo Sent the data: Name:$prevname Shift:$vartime Team:$varteam
                    case $set_counter in
                        1)
                            name_array_1["Name"]="$prevname"
                            name_array_1["Shift"]="$vartime"
                            name_array_1["Team"]="$varteam"
                            ;;
                        2)
                            name_array_2["Name"]="$prevname"
                            name_array_2["Shift"]="$vartime"
                            name_array_2["Team"]="$varteam"
                            ;;
                        3)
                            name_array_3["Name"]="$prevname"
                            name_array_3["Shift"]="$vartime"
                            name_array_3["Team"]="$varteam"
                        ;;
                    esac

                    ((set_counter++))
                    if [ $set_counter -gt 3 ];
                    then
                        set_counter=1
                    fi

                    ;;
                    ### Delete the current datas after sending ###
                    # Saka na pag nagawa na yung separaite file
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
