#!/bin/bash
set -e

docker network create --driver overlay --attachable skynet
docker network create --driver overlay --attachable monitoring
docker network create --driver overlay --attachable dc1
docker network create --driver overlay --attachable dc2
docker network create --driver overlay --attachable dc3