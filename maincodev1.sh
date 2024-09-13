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
    echo $varteam $varname $varsched
done
