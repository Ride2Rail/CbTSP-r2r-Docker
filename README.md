# CbTSP-r2r-Docker
Repository for CbTSP docker stack
#### Updates
01/02/2022 - Externalized *cbtsp_director* from docker image, and adjusted *stack_pass.yml* accordingly, fixed a bug in *cbtsp_director* (string instead of boolean in a pojo)
11/02/2022 - Fixed wrong naming of docker images in "stack_pass.yml" it was referencing a local naming, instead of the github docker registry naming convention

# Hello Ride2Rail Docker

This repository contains script files, and external data folders and files for the docker stack of the CbTSP.

[`cbtsp_planner`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_planner).
[`cbtsp_backend`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_backend).
[`cbtsp_director`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_director).
[`mongo:3.6.8`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/mongo).

### Project Contents
CbTSP is composed by more than one component. It includes:
 1. A relational database
 2. A backend for anagraphics and plan caching
 3. A planner component which is responsible for the effective route calculation and plans (rides) storing and retrieving
 4. An orchestrator which ties all togheter and exposes a set of API to interact with.

**These components are delivered as docker images as agreed with partners, they are mostly self contained with exception to some externalized folders and files, which are either configuration files, or persistance folders mapped to their respective containers**

### Prerequisites

 - A docker engine
 - Docker compose

## Install and first run
 - Login to [ghcr.io](ghcr.io)
```bash
$ docker login ghcr.io -u USERNAME
```
 - Clone this repository in your local working directory, you will need all the files of this repo to correctly run the CbTSP stack

 - Pull the images:
```bash
$ docker pull ghcr.io/ride2rail/cbtsp_planner:latest
$ docker pull ghcr.io/ride2rail/cbtsp_backend:latest
$ docker pull ghcr.io/ride2rail/cbtsp_director:latest
$ docker pull ghcr.io/ride2rail/mongo:3.6.8
```
At this point you should have on your local repository, the images listed above. Next steps are:

 - Clone this github repository in your working directory and move into it.
	 ```shell
	cd
	git clone https://github.com/Ride2Rail/CbTSP-r2r-Docker.git
	```
 - Make sure that all the scripts (.sh) are set as executables (you probably will not need all of them)
    ```shell
	chmod +x ./cbtsp-run.sh
	chmod +x ./cleanup.sh
	```
 - You can directly bring online the stack by issuing the command:
	```bash
	$ docker-compose --env-file ./compose_env.env -f stack_pass.yml up
	```
	if you want to run the stack attached, or:
	```bash
	$ docker-compose --env-file ./compose_env.env -f stack_pass.yml up -d
	```
	for detached mode.
### Working directory content and meaning
Once you have cloned this repository in your working directory you should find these folders:

 - **FOLDER: planner-data** - It contains the **padova.pbf** which is the openstreetmap file from which, upon first run, the planner 		 		builds its internal graph, upon first run, this folder will contain also the persisted planner graph object. **For other demos other than "Padova", you must change the padova.pbf file with the one of your interest, before the first run**

 - **FOLDER: director-data** - It contains SpringBoot **application.properties** and the directore executable **(.jar)**, those files should not be altered unless you are 100% sure of what you are doing, *.properties* basically contains all the configuration parameters of the orchestrator, including other api's endpoints, ip addresses, ports, usernames, passwords and so on. It's externalized so that if something changes down the line, it may just require editing this file and relaunching the container instead of redeployng a new one. 
 **BEWARE THAT: the content of this file may be correlated to other configuration files listed, so in case of any planned change, you should check the correlation on theese other files also**
 

 - **FOLDER: mongo-data** - ***IT GETS CREATED ON FIRST RUN*** it contains the persistance data for the *mongo-db* container

 - **FILE: compose_env.env** -  This files contains some enviroment variables that are used by the docker compose when launching, those environment variables are common to use for all the containers (it mainly includes subnet definition for the docker network that gets build up during deploy)
 **BEWARE THAT: the content of this file may be correlated to other configuration files listed, so in case of any planned change, you should check the correlation on theese other files also**
 - **FILE: mongo-init.js** - This files contains first run configuration for the *mongo-db* container like users, passwords, initial db creation and grants
**BEWARE THAT: the content of this file may be correlated to other configuration files listed, so in case of any planned change, you should check the correlation on theese other files also**

 - **FILE: stack_pass.yml** - It's the main entrypoint for *docker-compose* it contains the definition of the services, their order of startup, theri mapping to the host system and so on

### First and subsequent runs
First time you issue the docker compose command, many things happens:

 - Containers gets created
 - A specific subnetwork in the docker space gets created
 - needed ports of every container gets exposed (in the meaning of docker syntax, which implies that some ports are seen in the docker sub-network but not from the host, i.e the *mondo-db* port
 - The port for the entrypoint *(cbtsp-orchestrator)* gets published instead to the host so to be reachable ***(default API entrypoint: 8888)***
 - configuration files per specific container are read and used, this implies:
	 1. mongodb-init
	 2. orchestrator application properties
	 3. planner initialization (creation of the graph object from the **.pbf** file
	 4. planner launch after initialization

### **Note: first run generally requires more time to startup than subsequent one**

### **Note: some exceptions on the planner launch may happen, this is totally normal and does not implies generally a problem with it, it's just set to be very verbose at the moment**

### **Note: the orchestrator is wrapped in a safety script that blocks it from starting untill everything else is up and running, you should see in the log a message telling you that the launch is delayed more than one times until it's finally safe to start it, once you see the springboot logo in the logs, you should be ready to go**

## Operating the stack
Generally speaking you should only need to use the proper docker-compose command to start and stop the whole stack, and everything should work fine, and data persist trhough restarts

**To start:**
```bash
	$ docker-compose --env-file ./compose_env.env -f stack_pass.yml up
	or
	$ docker-compose --env-file ./compose_env.env -f stack_pass.yml up -d
```

**To stop:**
```bash
	$ docker-compose --env-file ./compose_env.env -f stack_pass.yml stop
```
**CAVEATS:**
If for any reason, you need to stop only the ***cbtsp-planner*** container, **BEWARE THAT** planning data is persisted in the backend and not in the planner which operates in memory, the component responsible for checking consistency of the planner is the ***cbtsp-orchestrator*** at its stratup, so if you manually restart the ***cbtsp-planner***, remember to restart **AFTER THAT** also the ***cbtsp-planner***
In any case, after a *stack restart* you should see the last component starting (the orchestrator) checking for plans to restore into the planner memory, you should see in the logs how many plans need to be reinserted into the planner and should be able to follow throug while the orchestrator proceeds to ask the planner to recreate all the cached plans

## You want the clean slate?
In case you want /need to start fresh, there's a handy script that you should find in your working directory if you cloned this reposistory, it's name is:
```bash
	$ sudo ./cleanup.sh
```
This script is very basic and you should be able to simply inspect it to understand what it does, but if for any reason you want to do a manual cleanup, this is the correct procedure:

 1. Stop all the cbts related running containers and delete them and their associated volumes
 2. Delete the docker network associated with the stack (the name may vary depending on your working dir name)
 3. Completely delte the ***mongo-data*** folder (you might need administrative credentials)
	 ```bash
	$ sudo rm -rf ./mongo-data
    ```
 4. Delete **ONLY** the ***Graph.obj*** file in the ***planner-data*** folder **Beare not to delete the file named {City}.pbf** 
 5. Issue the docker compose up command as instructed in the first run chapter.


TO BE UPDATED...
