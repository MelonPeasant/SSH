#!/bin/bash

display_alert()
{
	local tmp=""
	[ -n "${2}" ] && tmp="[\e[0;33m $2 \x1B[0m]"
	case "${3}" in
		err) echo -e "[\e[0;31m 错误 \x1B[0m] $1 $tmp" ;;
		wrn) echo -e "[\e[0;35m warn \x1B[0m] $1 $tmp" ;;
		ext) echo -e "[\e[0;32m o.k. \x1B[0m] \e[1;32m$1\x1B[0m $tmp" ;;
		info) echo -e "[\e[0;32m o.k. \x1B[0m] $1 $tmp" ;;
		*) echo -e "[\e[0;32m .... \x1B[0m] $1 $tmp" ;;
	esac
}
exit_with_error()
{
	local _description=$1
	local _highlight=$2
	display_alert "$_description" "$_highlight" "err"
	display_alert "程序终止" "" "info"
	exit 255
}

function Check_Mysql(){
if which mysql >/dev/null 2>&1; then
	display_alert "..." "Mysql 已经安装" "info"
	netstat -tap | grep mysql
else
	Install_Mysql
fi
if [ -f /etc/mysql/mysqlpassword.txt ]; then
	MYSQL_ROOT_PASSWORD=`cat /etc/mysql/mysqlpassword.txt`
    display_alert "..." "您的 Mysql 用户 root 密码是 $MYSQL_ROOT_PASSWORD" "info"
fi
}

function Install_Mysql(){
	MYSQL_ROOT_PASSWORD=$(openssl rand -base64 6)
	if [ -f /etc/mysql/mysqlpassword.txt ]; then
	MYSQL_ROOT_PASSWORD=`cat /etc/mysql/mysqlpassword.txt`
	fi
	apt update
	debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
	debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
	apt install mysql-server -y
	systemctl start mysql
	sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
	systemctl restart mysql
	display_alert "..." "Mysql 已经成功安装" "info"
	display_alert "..." "您的 Mysql 用户 root 密码是 $MYSQL_ROOT_PASSWORD" "info"
	echo $MYSQL_ROOT_PASSWORD > /etc/mysql/mysqlpassword.txt
	netstat -tap | grep mysql
	display_alert "..." "如果忘记密码，在任何时候输入 install-mysql.sh 即可获取" "info"
}

Check_Mysql