#!/bin/bash

while true; do
    read -p "Name: " varname
	if [ $varname == "print" ]
	then
	  if [[ $varname == "print" && $varsched == '' && $varteam == '' ]]
	    then
			# If print is inputted on the first run
			echo "No data in the database"
	    break
	  fi
	else
	  read -p "Shift: " varsched
	  read -p "Team: " varteam
	fi

		varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')

	case $varsched in
                morning)
                        vartime="Morning 6am-3pm";;
                mid)
                        vartime="Mid 2pm-11pm";;
                night)
                        vartime="Night 10pm-7am";;
                *)
                        echo "schedule does not exist";;
        esac

	case $varteam in 
		A1|A2|A3|B1|B2|B3)
			# Send the data to the other file here
			echo $varname $vartime $varteam checker;;
		*)
			echo "team does not exist" ;;
	esac
done
