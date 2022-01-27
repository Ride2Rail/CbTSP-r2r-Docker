#!/usr/bin/env bash

if [ `whoami` != root ]; 
then
    echo Please run this script as root or using sudo
    exit
else
    echo "Running this script will:"
    echo "- Stop all CbStp related container instances"
    echo "- Remove all persistend data related to DB and Planner"
    echo "############################################################"
    echo "# - REMOVE ALL THE LOCAL DOCKER IMAGES RELATED TO CBTSP!!! #" 
    echo "# - REMOVE THE LOCAL DOCKER SUBNET RELATED TO THE CBTSP!!! #"
    echo "############################################################"
    read -p "Are you sure?(y/n) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "################### STOPPING CBTSP STACK ###################"
        docker-compose --env-file ./compose_env.env -f stack_pass.yml stop
        echo "################ CBTSP STACK SHOULD BE DONW ################"
        echo "############# DELETING MONGODB PERSISTENT DATA #############"
        rm -rf mongo-data/
        echo "############ DELETING PLANNER PERSISTENT GRAPH  ############"
        sudo rm planner-data/Graph.obj
        echo "###### REMOVING CBTSP IMAGES FROM LOCAL REPOSITORY...  #####"
        echo
        
    fi
fi