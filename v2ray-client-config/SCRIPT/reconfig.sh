#!/bin/bash

if jq '{outbounds}' www.json > /var/v2ray/08-outbounds.json; then
	echo "copy file success"
else
	echo "copy file fail"
fi

systemctl restart v2ray.service

sleep 1

systemctl status v2ray.service
