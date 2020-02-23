# Prometheus Setup
1. Create a system user for Prometheus:
```
 sudo useradd --no-create-home --shell /bin/false prometheus
``` 
2. Create the directories in which we'll be storing our configuration files and libraries:
```
 sudo mkdir /etc/prometheus
 sudo mkdir /var/lib/prometheus
```
3. Set the ownership of the /var/lib/prometheus directory:
```
 sudo chown prometheus:prometheus /var/lib/prometheus
```
4. Pull down the tar.gz file from the Prometheus downloads page:
```
 cd /tmp/
 wget https://github.com/prometheus/prometheus/releases/download/v2.7.1/prometheus-2.7.1.linux-amd64.tar.gz
``` 
5. Extract the files:
```
 tar -xvf prometheus-2.7.1.linux-amd64.tar.gz
```
6. Move the configuration file and set the owner to the prometheus user:
```
 cd prometheus-2.7.1.linux-amd64
 sudo mv console* /etc/prometheus
 sudo mv prometheus.yml /etc/prometheus
 sudo chown -R prometheus:prometheus /etc/prometheus
``` 
7. Move the binaries and set the owner:
```
 sudo mv prometheus /usr/local/bin/
 sudo mv promtool /usr/local/bin/
 sudo chown prometheus:prometheus /usr/local/bin/prometheus
 sudo chown prometheus:prometheus /usr/local/bin/promtool
``` 
8. Create the service file:
```
 sudo vim /etc/systemd/system/prometheus.service
``` 
Add:
```
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```
Save and exit.

9. Reload systemd:
```
 sudo systemctl daemon-reload
``` 
10. Start Prometheus, and make sure it automatically starts on boot:
```
 sudo systemctl start prometheus
 sudo systemctl enable prometheus
``` 
11. Visit Prometheus in your web browser at PUBLICIP:9090.

# Alertmanager Setup

1. Create the alertmanager system user:
```
 sudo useradd --no-create-home --shell /bin/false alertmanager
``` 
2. Create the /etc/alertmanager directory:
```
 sudo mkdir /etc/alertmanager
```
3. Download Alertmanager from the Prometheus downloads page:
```
 cd /tmp/
 wget https://github.com/prometheus/alertmanager/releases/download/v0.16.1/alertmanager-0.16.1.linux-amd64.tar.gz
``` 
4. Extract the files:
```
 tar -xvf alertmanager-0.16.1.linux-amd64.tar.gz
``` 
5. Move the binaries:
```
 cd alertmanager-0.16.1.linux-amd64
 sudo mv alertmanager /usr/local/bin/
 sudo mv amtool /usr/local/bin/
``` 
6. Set the ownership of the binaries:
```
 sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
 sudo chown alertmanager:alertmanager /usr/local/bin/amtool
``` 
7. Move the configuration file into the /etc/alertmanager directory:
```
 sudo mv alertmanager.yml /etc/alertmanager/
``` 
8. Set the ownership of the /etc/alertmanager directory:
```
 sudo chown -R alertmanager:alertmanager /etc/alertmanager/
``` 
9. Create the alertmanager.service file for systemd:
```
 sudo vim /etc/systemd/system/alertmanager.service
``` 
Add:
```
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
WorkingDirectory=/etc/alertmanager/
ExecStart=/usr/local/bin/alertmanager \
    --config.file=/etc/alertmanager/alertmanager.yml
[Install]
WantedBy=multi-user.target
```
Save and exit.

10. Stop Prometheus, and then update the Prometheus configuration file to use Alertmanager:
```
sudo systemctl stop prometheus
sudo $EDITOR /etc/prometheus/prometheus.yml

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093
```      
11. Reload systemd, and then start the prometheus and alertmanager services:
```
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl start alertmanager
```
12. Make sure alertmanager starts on boot:
```
sudo systemctl enable alertmanager
```
13. Visit PUBLICIP:9093 in your browser to confirm Alertmanager is working.
