### Debian buster 系统加速访问
```
mv /etc/apt/sources.list /etc/apt/sources.list.bak
echo '# rewrite with tuna' > /etc/apt/sources.list
echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free' >> /etc/apt/sources.list
echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free' >> /etc/apt/sources.list
echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free' >> /etc/apt/sources.list
echo 'deb http://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list
cat /etc/apt/sources.list
apt update
```
