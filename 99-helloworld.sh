VERSION_PRO=$(if [ "$(uname -r|cut -d'_' -f3|cut -c2)" == "6" ];then echo " 专业版";fi)
warning=$(if [ "$(df -m / | grep -v File | awk '{print $4}')" == "0" ];then echo " [31m警告，您的 emmc 空间已爆满，请立即检查和处置！[0m";fi)
warningswap=$(if [ "$(free -m | grep Swap | awk '{print $4}')" == "0" ];then echo " [31m警告，您的系统似乎出现问题，强烈建议重置 recoverbackup ！[0m";fi)
IP=$(ifconfig eth0 | grep '\<inet\>'| grep -v '127.0.0.1' | awk '{print $2}' | awk 'NR==1')
mac_now=$(ifconfig eth0 |grep "ether"| awk '{print $2}')

if [ -f /proc/msp/pm_cpu ]; then
	temp=$(grep Tsensor /proc/msp/pm_cpu | awk '{print $4}')°C
	DEVICE="$(cpuid)_$(egrep -oa "hi3798.+reg" /dev/mmcblk0p1 2> /dev/null | cut -d '_' -f1 | sort | uniq)"
else
	temp=$(cat /sys/class/thermal/thermal_zone0/temp | cut -b 1-2)°C
	DEVICE="Amlogic S805 OneCloud WS1608"
fi

clear
echo -e "\e[33m
	 _   _ ___  _   _    _    ____  
	| | | |_ _|| \ | |  / \  / ___| 
	| |_| || | |  \| | / _ \ \___ \ 
	|  _  || | | |\  |/ ___ \ ___) |
	|_| |_|___||_| \_/_/   \_\____/ 
\e[0m

   板型名称 : ${DEVICE}
   CPU 信息 : $(uname -p)
   系统版本 : $(awk -F '[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release)
   可用存储 : $(df -m / | grep -v File | awk '{a=$4*100/$2;b=$4} {printf("%.1f%s %.1fM\n",a,"%",b)}') ${warning}
   可用内存 : $(free -m | grep Mem | awk '{a=$7*100/$2;b=$7} {printf("%.1f%s %.1fM\n",a,"%",b)}') | 交换区：$(free -m | grep Swap | awk '{a=$4*100/$2;b=$4} {printf("%.1f%s %.1fM\n",a,"%",b)}') ${warningswap}
   启动时间 : $(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=($1%60)} {printf("%d 天 %d 小时 %d 分钟 %d 秒\n",a,b,c,d)}' /proc/uptime)
   IP 地址  : $IP$(if [ "$(ifconfig wlan0 2>/dev/null| grep '\<inet\>'| awk '{print $2}' | awk 'NR==1')" != "" ];then echo \($(ifconfig wlan0 2>/dev/null| grep '\<inet\>'| awk '{print $2}' | awk 'NR==1')\);fi)
   设备温度 : $temp
   MAC 地址 : $mac_now
"

alias reload='. /etc/profile'
alias cls='clear'
alias syslog='cat /var/log/syslog'
alias unmount='umount -l'
alias reg="egrep -oa 'hi3798.+' /dev/mmcblk0p1 | awk '{print $1}'"
