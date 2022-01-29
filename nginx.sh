#!/bin/bash

mkdir -p /home/nginx
cd /home/nginx
rm -f nginx-1.10.2.tar.gz
wget http://nginx.org/download/nginx-1.10.2.tar.gz
rm -f openssl-fips-2.0.10.tar.gz
wget http://www.openssl.org/source/openssl-fips-2.0.10.tar.gz
rm -f zlib-1.2.11.tar.gz
wget http://zlib.net/zlib-1.2.11.tar.gz
rm -f pcre-8.13.tar.gz
wget https://netix.dl.sourceforge.net/project/pcre/pcre/8.13/pcre-8.13.tar.gz
yum -y install gcc gcc-c++ autoconf automake make

tar -zxvf openssl-fips-2.0.10.tar.gz
cd openssl-fips-2.0.10
./config && make && make install
echo "openssl 安装完成！"
cd -

tar -xzvf  pcre-8.13.tar.gz
cd pcre-8.13
./configure --enable-utf8
make && make intall
echo "pcre 安装完成！"
cd -

tar -zxvf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure && make && make install
echo "zlig 安装完成！"
cd -

yum -y install pcre-devel
yum -y install openssl-devel

tar zxvf nginx-1.10.2.tar.gz
cd nginx-1.10.2
./configure
echo "./configure 完成！"
rm -f /home/nginx/nginx-1.10.2/objs/Makefile
cp /home/nginx/Makefile /home/nginx/nginx-1.10.2/objs/Makefile

rm -f /home/nginx/nginx-1.10.2/src/os/unix/ngx_user.c
cp /home/nginx/ngx_user.c /home/nginx/nginx-1.10.2/src/os/unix/ngx_user.c

make && make install
echo "nginx 安装完成！"

fuser -k 80/tcp
cd /usr/local/nginx/sbin/
./nginx
firewall-cmd --zone=public --add-port=80/tcp --permanent
cp /home/nginx/nginx  /etc/init.d/nginx
cd /etc/init.d/
chmod 755 /etc/init.d/nginx
chkconfig --add nginx
chkconfig nginx on/off
chkconfig --list nginx
systemctl restart nginx
service nginx status
