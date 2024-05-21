docker run -d --name elastalert --restart=always \
-e TZ=Asia/Shanghai \
-v /data/monitor/elastalert2/elastalert.yaml:/opt/elastalert/config.yaml \
-v /data/monitor/elastalert2/rules:/opt/elastalert/rules \
jertel/elastalert2 --prometheus_port 9099 --verbose