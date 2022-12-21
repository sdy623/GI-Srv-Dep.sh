#!/bin/bash
# Author sdy623 github
# 2022-12-21

CURRENT_DIR=$PWD
Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}

if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
        if grep -Eq "CentOS Stream" /etc/*-release; then
            isCentosStream='y'
        fi
    elif grep -Eqi "Alibaba" /etc/issue || grep -Eq "Alibaba Cloud Linux" /etc/*-release; then
        DISTRO='Alibaba'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun Linux" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
        DISTRO='Amazon'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Oracle Linux" /etc/issue || grep -Eq "Oracle Linux" /etc/*-release; then
        DISTRO='Oracle'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux" /etc/issue || grep -Eq "Red Hat Enterprise Linux" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "rockylinux" /etc/issue || grep -Eq "Rocky Linux" /etc/*-release; then
        DISTRO='Rocky'
        PM='yum'
    elif grep -Eqi "almalinux" /etc/issue || grep -Eq "AlmaLinux" /etc/*-release; then
        DISTRO='Alma'
        PM='yum'
    elif grep -Eqi "openEuler" /etc/issue || grep -Eq "openEuler" /etc/*-release; then
        DISTRO='openEuler'
        PM='yum'
    elif grep -Eqi "Anolis OS" /etc/issue || grep -Eq "Anolis OS" /etc/*-release; then
        DISTRO='Anolis'
        PM='yum'
    elif grep -Eqi "Kylin Linux Advanced Server" /etc/issue || grep -Eq "Kylin Linux Advanced Server" /etc/*-release; then
        DISTRO='Kylin'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
        DISTRO='Mint'
        PM='apt'
    elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
        DISTRO='Kali'
        PM='apt'
    elif grep -Eqi "UnionTech OS" /etc/issue || grep -Eq "UnionTech OS" /etc/*-release; then
        DISTRO='UOS'
        if command -v apt >/dev/null 2>&1; then
            PM='apt'
        elif command -v yum >/dev/null 2>&1; then
            PM='yum'
        fi
    elif grep -Eqi "Kylin Linux Desktop" /etc/issue || grep -Eq "Kylin Linux Desktop" /etc/*-release; then
        DISTRO='Kylin'
        PM='yum'
    else
        DISTRO='unknow'
    fi
    Get_OS_Bit
}

Get_Dist_Name

if [ "${DISTRO}" != "Ubuntu" ]; then
    Echo_Red "The Installation Script ONLY compatible with Ubuntu, do NOT support the current distribution."
    exit 1
fi

clear
echo "+------------------------------------------------------------------------+"
echo "|     Anime Game Server Prerequisites Installation Written by sdy623     |"
echo "+------------------------------------------------------------------------+"
echo "|           A tool to auto-compile & install GameSF on Ubuntu            |"
echo "+------------------------------------------------------------------------+"
echo "|         For more information please visit Anti Genshit Center          |"
echo "+------------------------------------------------------------------------+"

Install_Phase1(){

    echo "+----------------------------------------+"
    echo "|    Installation Phase 1 basic-utils    |"
    echo "+----------------------------------------+"
 
    sudo rm -rf /bin/sh
    sudo ln -sv /bin/bash /bin/sh
    sudo apt install -y net-tools openssh-server build-essential python2 python2-dev vim libmysqlclient-dev git golang
    
    sudo pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
    sudo python2 ./get-pip.py -i https://pypi.tuna.tsinghua.edu.cn/simple
    sudo python2 -m pip install requests Jinja2 enum pyyaml netifaces
    
    Echo_Green "Phase 1 Installation Done!"
    
}

Install_Phase2(){
    echo "+------------------------------------+"
    echo "|     Installation Phase 2 LNMP      |"
    echo "+------------------------------------+"
    wget http://soft1.vpser.net/lnmp/lnmp1.9.tar.gz -cO lnmp1.9.tar.gz && tar zxf lnmp1.9.tar.gz && cd lnmp1.9 && LNMP_Auto="y" DBSelect="5" Bin="n" DB_Root_Password="+nL%]2E~" InstallInnodb="y" PHPSelect="9" SelectMalloc="1" ./install.sh lnmp
    
    cd ${CURRENT_DIR}/lnmp1.9 && ./addons.sh
    sudo ln -sv /usr/local/redis/bin/redis-cli /bin/redis-cli
    sudo timedatectl set-timezone UTC
    cd ~
    Echo_Green "Phase 2 Installation Done!"
    
}

Install_Phase3(){

    mysql -uroot -p+nL%]2E~ -e "CREATE USER 'work'@'localhost' IDENTIFIED WITH mysql_native_password BY 'GenshinImpactOffline2022';CREATE USER 'work'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'GenshinImpactOffline2022';"
    mysql -uroot -p+nL%]2E~ -e "GRANT ALL PRIVILEGES ON *.* TO 'work'@'localhost'; GRANT ALL PRIVILEGES ON *.* TO 'work'@'127.0.0.1';"

    sudo systemctl restart mysql
    
    sudo mkdir -pv /etc/redis/
    sudo sed -i 's/databases 16/databases 32/g' /usr/local/redis/etc/redis.conf
    sudo sed -i 's/# requirepass foobared/requirepass GenshinImpactOffline2022/g' /usr/local/redis/etc/redis.conf
    sudo sed -i 's/# maxmemory <bytes>/maxmemory 2G/g' /usr/local/redis/etc/redis.conf
    sudo sed -i 's/# maxmemory-policy noeviction/maxmemory-policy volatile-lfu/g' /usr/local/redis/etc/redis.conf
    sudo ln -sv /usr/local/redis/etc/redis.conf /etc/redis/redis.conf

}

Install_Phase4(){
    wget https://downloads.mysql.com/archives/get/p/29/file/mysql-connector-python-2.0.5.tar.gz
    tar -zxf mysql-connector-python-2.0.5.tar.gz
    cd ./mysql-connector-python-2.0.5
    python2 ./setup.py build
    sudo python2 ./setup.py install
    
}

Finalization(){
    echo "+------------------------------------------------------------------------+"
    echo "|              Prerequisites Installation Done Successfully              |"
    echo "+------------------------------------------------------------------------+"
    echo "|         Please run 'sudo ./main init' to make the configuration        |"
    echo "+------------------------------------------------------------------------+"
    echo "|              The mysql root user password is '+nL%]2E~'                |"
    echo "+------------------------------------------------------------------------+"
    echo "|         For more information please visit Anti Genshit Center          |"
    echo "+------------------------------------------------------------------------+"

}

main(){
    Install_Phase1
    Install_Phase2
    Install_Phase3
    Install_Phase4
	Finalization
	
}

swap_conf(){
    sudo fallocate -l 8G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swwapfile
    
}

read -r -p "Are You Sure? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
        main
        ;;

    [nN][oO]|[nN])
        
           ;;

    *)
        echo "Invalid input..."
        exit 1
        ;;
esac

read -r -p "是否设置虚拟内存 ？ [Y/n] " input

case $input in
    [yY][eE][sS]|[yY])
        swap_conf
        ;;

    [nN][oO]|[nN])
        
           ;;

    *)
        echo "Invalid input..."
        exit 1
        ;;
esac



