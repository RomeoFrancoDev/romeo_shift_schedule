#!/bin/bash

while true; do
    read -p "Name: " varname
	if [ $varname == "print" ]
	then
	  break
	else
	  read -p "Shift: " varsched
	  read -p "Team: " varteam
	fi

		varteam=$(echo "$varteam" | tr '[:lower:]' '[:upper:]')

		case $varteam in 
		A1|A2|A3|B1|B2|B3)
			echo $varname $varsched $varteam ;;
		*)
			echo "team does not exist" ;;
	esac
		case $varsched in
		morning)
			echo $varteam $varname "Morning 6am-3pm";;
		mid)
			echo $varteam $varname "Mid 2pm-11pm";;
		night)
			echo $varteam $varname "Night 10pm-7am";;
		*)	
			echo "schedule does not exist";;
	esac	
done
