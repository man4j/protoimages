image_version=5.7.16_3

docker build --no-cache -t man4j/percona_galera_master:${image_version} .
docker push man4j/percona_galera_master:${image_version}