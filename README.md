THIS README FILE IS A "WIP"
more detailed instructions on how to run and manage the stack will follow shortly and this readme will be updated

# CbTSP-r2r-Docker
Repository for CbTSP docker stack

# Hello Ride2Rail Docker

This repository contains script files, and external data folders and files for the docker stack of the CbTSP.

[`cbtsp_planner`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_planner).
[`cbtsp_backend`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_backend).
[`cbtsp_director`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/cbtsp_director).
[`mongo:3.6.8`](https://github.com/Ride2Rail/CbTSP-r2r-Docker/pkgs/container/mongo).


## Instructions

1. Login to [ghcr.io](ghcr.io)
```bash
$ docker login ghcr.io -u USERNAME
```
2. Clone this repository in your local working directory, you will need all the files of this repo to correctly run the CbTSP stack

3. Pull the images:
```bash
$ docker pull ghcr.io/ride2rail/cbtsp_planner:latest
$ docker pull ghcr.io/ride2rail/cbtsp_backend:latest
$ docker pull ghcr.io/ride2rail/cbtsp_director:latest
$ docker pull ghcr.io/ride2rail/mongo:3.6.8
```

TO BE CONTINUED...
