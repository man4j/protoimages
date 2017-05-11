docker service create -p 8041:80 --network skynet --name nginx-kibana --constraint "node.labels.dc == dc1" \
-e "APP_USER=man4j" \
-e "APP_PASSWORD=PassWord123" \
-e "APP_URL=http://kibana:5601" \
man4j/nginx-protect:1