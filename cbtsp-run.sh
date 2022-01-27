#!/usr/bin/env bash

if [ `whoami` != root ]; 
then
    echo "Please run this script (cbtsp-run) as root or using sudo"
    exit
else
    docker-compose --env-file ./compose_env.env -f stack_pass.yml up
fi