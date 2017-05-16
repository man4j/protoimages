image_version=5.7.16_2

docker build --no-cache -t man4j/esf_percona:${image_version} .
docker push man4j/esf_percona:${image_version}