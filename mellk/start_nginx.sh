docker service create -p 5601:8080 --network monitoring --name nginx-kibana \
-e "WEB_USER=man4j" \
-e "WEB_PASSWORD=PassWord123" \
-e "APP_URL=http://kibana:5601" \
man4j/nginx-protect:2