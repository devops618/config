docker run -itd --restart=always -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  prom/node-exporter

mkdir /data1/prometheus
docker run  -itd --restart=always \
  -p 9090:9090 \
  -v /data1/prometheus:/etc/prometheus  \
  prom/prometheus

docker run -itd --name prometheus --restart=always \
  -p 29090:9090 \
  -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro \
  -v /data_disk/vdc1/docker_volume/devops/prometheus/prometheus-monitor:/etc/prometheus \
  -v /data_disk/vdc1/docker_volume/devops/prometheus/storage:/prometheus \
  prom/prometheus --config.file=/etc/prometheus/prometheus.yml --web.enable-lifecycle

# config reload
# curl -X POST http://XXXX:29090/-/reload

mkdir /data1/grafana-storage
chmod 777 -R /data1/grafana-storage
docker run -itd --restart=always \
  -p 3000:3000 \
  --name=grafana \
  -v /data1/grafana-storage:/var/lib/grafana \
  grafana/grafana

docker run -itd --name alertmanager --restart=always \
  -p 9093:9093 \
  -v /data1/prometheus:/etc/alertmanager \
  prom/alertmanager

docker run -itd --name alertmanager --restart=always \
  -p 9093:9093 \
  -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro \
  -v /data_disk/vdc1/docker_volume/devops/alertmanager/alertmanager:/etc/alertmanager \
  -v /data_disk/vdc1/docker_volume/devops/alertmanager/storage:/alertmanager \
  quay.io/prometheus/alertmanager

docker run -itd --name webhook-dingtalk --restart=always \
  -p 8060:8060 \
  -v /data1/prometheus:/etc/prometheus-webhook-dingtalk \
  timonwong/prometheus-webhook-dingtalk

docker run -itd --restart=always \
-p 8080:8080 \
-v /opt/prometheus/app.conf:/app/conf/app.conf \
feiyu563/prometheus-alert:latest

docker run -itd --restart=always \
  -p 9115:9115 \
  --name blackbox_exporter \
  -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro \
  -v /data/monitor/blackbox-exporter:/config \
  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml