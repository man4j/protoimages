image_version=5.7.17_3

docker build --no-cache -t man4j/percona_slave:${image_version} .
docker push man4j/percona_slave:${image_version}