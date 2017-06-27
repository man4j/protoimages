image_version=6.9.2_2

docker build -t man4j/esf_voltdb:${image_version} .
docker push man4j/esf_voltdb:${image_version}