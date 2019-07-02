# homebrew-iotedge

Homebrew tap to ease Azure IoT Edge runtime installation for macOS users

## How to install

### Prerequisites

1. Install [Homebrew](https://brew.sh)
2. Install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)

### Installation

1. `brew install dmolokanov/iotedge/iotedge`
2. open `/usr/local/etc/iotedge/config.yaml` file and update values for `device_connection_string` and `hostname`
3. `iotedged -c /usr/local/etc/iotedge/config.yaml` 

## To-Do List

- [x] Create formula to build iodedge from sources
- [x] Use git repo instead of git archive tarball 
- [x] Add config file prefilled with values specific for macOS
- [ ] Add dependency on docker in the system, not only from Homebrew repo
- [ ] Prepare package to run as a service `brew service start iotedge`
- [ ] Add bottles to avoid building project from sources
