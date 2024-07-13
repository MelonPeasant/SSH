#!/bin/bash

get_ip() {
	# ip=$(curl -s https://ipinfo.io/ip)
	# [[ -z $ip ]] && ip=$(curl -s https://api.ip.sb/ip)
	# [[ -z $ip ]] && ip=$(curl -s https://api.ipify.org)
	# [[ -z $ip ]] && ip=$(curl -s https://ip.seeip.org)
	# [[ -z $ip ]] && ip=$(curl -s https://ifconfig.co/ip)
	# [[ -z $ip ]] && ip=$(curl -s https://api.myip.com | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	# [[ -z $ip ]] && ip=$(curl -s icanhazip.com)
	# [[ -z $ip ]] && ip=$(curl -s myip.ipip.net | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
	export "$(wget -4 -qO- https://dash.cloudflare.com/cdn-cgi/trace | grep ip=)" >/dev/null 2>&1
	[[ -z $ip ]] && export "$(wget -6 -qO- https://dash.cloudflare.com/cdn-cgi/trace | grep ip=)" >/dev/null 2>&1
	[[ -z $ip ]] && echo -e "\n$red 获取IP失败, 这垃圾小鸡扔了吧！$none\n" && exit
}

echo_ip() {
	echo ${ip}
}

echo "......START......"
get_ip
echo_ip
echo ".......END......."