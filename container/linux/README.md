# Destra Decentralized Storage - Storage Node (Beta) Container Build Instructions


## Prerequisites

Before you start, you will need:
- A system running Ubuntu.
- A .env file pre-populated with the required fields as laid out in the .env.example file
-- Example of what it looks like if you are missing the .env file.
--- The following packages must be installed on the host docker system.
----  => ERROR [destra-storagenode 17/19] COPY .env . 
-- docker.io
-- docker-compose-v2
-- python3


## Build Instructions
- Change to the container/linux directory
- chmod +x build-container.sh
- ./build-container.sh


# Deployment Instructions

## Docker Host

# Exposing storage for your storage node
- Default:  /mnt/destra-storage is where you would mount your additional block storage for the storage node.

# To run the docker container
- Change directory to the container/linux directory
- docker compose up -d

# Inspect Container Status
- docker ps

# Inspect Docker Logs
- docker logs destra-storagenode -f


