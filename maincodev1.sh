#!/bin/bash


while true; do

    declare -A name_array

    read -p "Name: " varname
        if [ $varname == "print" ]
            then
                if [[ -z $varsched && -z $varteam ]]
                    then
                        # If print is inputted on the first run
                        echo "No data in the database"
                    break
                else
                        ### Fetch the data from the other file here ###
                        #echo Fetched the data: Name:$prevname Shift:$vartime Team:$varteam
                        #Print the array
                        for key in "${!name_array[@]}";
                        do
                            echo "$key: ${name_array[$key]}"
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
                    ### Send the data to the other file here ###
                    #echo Sent the data: Name:$prevname Shift:$vartime Team:$varteam
                    name_array["Name"]="$prevname"
                    name_array["Shift"]="$vartime"
                    name_array["Team"]="$varteam"
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
