#!/bin/bash

while read input; do
    value='print'
    if [ "$input" = "$value" ]; then break; fi
    echo 'Name:'
    read varname
    echo 'Schedule:'
    read varsched
    echo 'Team:'
    read varteam
    echo $varteam $varname $varsched
done
