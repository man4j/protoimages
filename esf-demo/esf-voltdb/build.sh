image_version=6.9.2_1

docker build --no-cache -t man4j/esf_voltdb:${image_version} .
docker push man4j/esf_voltdb:${image_version}