#!/bin/bash

apt-get update
apt-get --assume-yes upgrade

#Install ffmpeg and v4l-utils:
apt-get install ffmpeg v4l-utils --assume-yes

#Install libmariadbclient18 and libpq5 required by motion:
apt-get install libmariadbclient18 libpq5 --assume-yes

#Install motion:
wget https://github.com/Motion-Project/motion/releases/download/release-4.2.1/pi_stretch_motion_4.2.1-1_armhf.deb
dpkg -i pi_stretch_motion_4.2.1-1_armhf.deb

#Install the dependencies from the repositories:
apt-get install python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev --assume-yes

#Install motioneye, which will automatically pull Python dependencies (tornado, jinja2, pillow and pycurl):
pip install motioneye

#Prepare the configuration directory:
mkdir -p /etc/motioneye
cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
Prepare the media directory:

mkdir -p /var/lib/motioneye

#Add an init script, configure it to run at startup and start the motionEye server:
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
systemctl daemon-reload
systemctl enable motioneye
systemctl start motioneye


curl -SL https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-armv7.tar.gz > node_exporter.tar.gz && \
tar -xvf node_exporter.tar.gz -C /usr/local/bin/ --strip-components=1

mkdir -p /var/lib/node_exporter/textfile
chmod 777 /var/lib/node_exporter/textfile 

cp nodeexporter.service /etc/systemd/system

systemctl daemon-reload 
systemctl enable nodeexporter 
systemctl start nodeexporter
