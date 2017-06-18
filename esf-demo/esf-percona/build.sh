image_version=5.7.16.15.1

docker build -t man4j/percona-esf:${image_version} .
docker push man4j/percona-esf:${image_version}