docker run --restart=always -d --network monitoring --name=metricbeat --cap-add SYS_ADMIN \
-e ELASTICSEARCH_URL=http://elasticsearch:9200 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /proc:/hostfs/proc:ro \
-v /sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro \
-v /:/hostfs:ro \
-v /etc/hostname:/etc/hostname \
man4j/metricbeat:5.3.0_5 -system.hostfs=/hostfs
