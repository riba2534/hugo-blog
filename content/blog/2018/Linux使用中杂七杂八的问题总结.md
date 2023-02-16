---
title: Linux使用中杂七杂八的问题总结
date: 2018-12-16T13:07:00+08:00
lastmod: 2020-03-31T16:25:50+08:00
draft: false
featured_image: https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d605b35a.jpg
tags:
- Linux
categories: Linux
comment: true

---

# 前言

在`Linux`的使用中会碰到很多配置上的问题，在这里总结一下自己在使用过程中碰到的问题的一些行之有效的解决方法。


## ubuntu18.04应用程序自启

环境:操作系统是:`Ubuntu18.04 LTS`

1. 按`Alt+F2`,然后输入命令:`gnome-session-properties`,按回车,会进入一个**启动应用程序首选项**的界面
2. 添加要启动的命令即可
3. 如果是桌面应用程序，可以去`/usr/share/applications`目录下找到对应的`.desktop`文件，然后就可以查看当前应用程序的启动参数。

当我亲自试验以后，发现添加到启动菜单候每次只启动一次，第二次开机就没有了。。于是我找到了一个曲线救国的方法。

1. 去坚果云官网下载坚果云
2. 开启坚果云的自动启动
3. 去前面说的目录里面改坚果云的启动参数，改成要启动的软件，这样就可每次开机都有了

参考:
[ubuntu18.04设置开机自启动](https://blog.csdn.net/qq_36807551/article/details/83144813)

## ubuntu18.04开启速度优化

1. `systemd-analyze blame`可以显示开机启动项的启动时间
2. 可以发现`NetworkManager-wait-online.service`这一项特别慢，搜索了一下发现这一项貌似是加载一些网络上的代码，无关紧要可以禁用掉
3. `sudo systemctl disable NetworkManager-wait-online.service`禁用掉

参考链接:
[Ubuntu | Linux加快开机启动](https://www.jianshu.com/p/11491ee15344)
[What does NetworkManager-wait-online.service do?](https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do)
[Ubuntu 18.04 踩坑记录(In Update)](https://www.jianshu.com/p/23b0d3015db8)

## zsh和oh-my-zsh安装

1. 安装git和zsh`sudo apt install git zsh -y`
2. 获取安装脚本:`wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh`
3. 切换成zsh:`chsh -s /bin/zsh`

如果出现`PAM`验证之类的问题，可以参考这个方案:

1. 删除已经写入本地的文件`rm -rf ~/.oh-my-zsh/`
2. 获取脚本:`curl -L http://install.ohmyz.sh > install.sh`
3. `sh install.sh`,接下来会提示输入名户名和密码，输入即可

参考:
[ubuntu 安装oh-my-zsh过程记录](https://www.jianshu.com/p/0f426fd7b44b)
[ubuntu16.04安装oh-my-zsh](http://www.linuxdiyf.com/linux/21401.html)

## ubuntu18.04安装pip

首先，不推荐直接用`apt install python3-pip`的方式去安装pip,这样安装的pip版本较低(个人感觉有点问题)，推荐使用官方的安装脚本`get-pip.py`进行安装，在ubuntu18.04的过程中会提示错误,如:`ImportError: cannot import name 'sysconfig'`这样的错误，下面给出安装方法

1. 如果没有安装curl,首先`apt install curl -y`来安装
2. 获取安装脚本:`curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py`，速度慢的同学自行通过梯子下载
3. 安装之前:`sudo apt install python3-distutils`安装依赖文件
4. `sudo python3 get-pip.py`安装既可，接下来用`pip3 --version`来查看安装的版本

## Linux配置pip镜像源

由于pip镜像源在国外，所以在国内可以配置各大镜像站的源来解决安装速度问题,有两种方法

**方法一**:

1. 编辑`~/.pip/pip.conf`文件，没有就创建一个
2. 填入以下参数:
```shell
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
```
3. 完毕

**方法二**:

升级 pip 到最新的版本 (>=10.0.0) 后进行配置：
```shell
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

参考链接:
[清华pypi 镜像使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/pypi/)
[USTC-PyPI 镜像源使用帮助](http://mirrors.ustc.edu.cn/help/pypi.html)

## ssh终端乱码
问题的原因是，本地的 locale 与服务器上的 locale 不匹配。参考链接里提供了四种解决方案，而我觉得 Stop forwarding locale from the client 这种解决方案最简单。即，修改 Ubuntu 本地的 `/etc/ssh/ssh_config` 文件，注释掉
```shell
SendEnv LANG LC_*
```
参考链接:[解决 Ubuntu 下 ssh 服务器中文显示乱码](https://www.sunzhongwei.com/solve-ssh-server-under-ubuntu-chinese-display-garbled)

## deepin安装问题

安装deepin的过程中会遇到很多坑，比如进不了桌面等关于显卡的问题，在安装的时候先禁用独显

1. 正常安装`deepin15.x`
2. 在开机选项里面按`e`键编辑启动选项，找到`quiet splash`在后面加上`nouveau.modeset=0`
3. 在进入系统后执行命令`apt install nvidia-driver`
4. 重启后会发现系统已经可以正常开机了
5. 当启动出现grub命令行的时候，当实在没有办法解决，先装ubuntu再装win10,然后在ubuntu中安装`boot-repair`来修复启动,方法如下
6. 或许在安装的过程中会让你设置`acpi=off`，跟着照做

```shell
sudo add-apt-repository ppa:yannubuntu/boot-repair
sudo apt-get update
sudo apt-get install boot-repair
```

## SwitchyOmega配置

1. 打开SwitchyOmega 设置，新建情景模式， 选择自动切换模式
2. 导入在线规则列表，类型选择`AutoProxy`，可以选择导入gfwlist – `https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt` 或者自己自定义的`AutoProxy`文件。
3. 然后规则列表的走proxy，剩下的直接连接即可。

## 命令行下走ss/ssr代理

1. 安装: `sudo apt install proxychains`
2. 使用: `sudo vim /etc/proxychains.conf`
3. 在最后的ProxyList里加入Shawdowsocks的代理设置：`socks5 127.0.0.1 1080`
4. 使用：在你要使用的命令前加上`proxychains`，其他的不变

## python一句话服务器

1. 在python2环境下:`python -m SimpleHTTPServer 端口`
2. python3环境下:`python3 -m http.server 端口`

## 好用Linux命令合集

1. `tmux`和`screen`可以在后台跑终端
2. `scp`可以传输本地和服务器的文件
3. `figlet`可以把一句话变成字符画
4. `you-get`可以下载b站，youtobe上面的视频,`pip3 install you-get`
5. `axel`可以替代`wget`
6. Linux下查找文件大小大于100M的文件:`find . -type f -size +100M`
7. `bwm-ng`查看实时网速
8. 使用`unar`解压可以避免unzip乱码
9. tar使用:
	压缩:`tar -zcvf 压缩文件名.tar.gz 被压缩文件名`
	解压缩:`tar -zxvf 压缩文件名.tar.gz`
10. linux查看系统版本信息:`lsb_release -a`
11. 一个命令安装lamp:`apt install lamp-server^`
12. 更改用户组和所有者：
	用户组：`chgrp -R www-data 目录`
	所有者：`chown -R www-data 目录`
	同时：`chown -R www-data:www-data my_files`

## caddy服务器配置:

默认目录:`/usr/local/caddy`
参数:
```shell
echo "http://toyoo.ml {
 root /usr/local/caddy/www/file #网站根目录
 timeouts none  #取消延时操作
 gzip      #对数据进行压缩
 filemanager / /usr/local/caddy/www/file {  #一个文件管理器
  database /usr/local/caddy/filemanager.db
 }
}" > /usr/local/caddy/Caddyfile

```
caddy服务器安装(doubi的临时镜像，需梯子):
[https://doubmirror.cf/plucovvc-2.html](https://doubmirror.cf/plucovvc-2.html)

## apache2的常用配置(ubuntu)

配置文件目录:`/etc/apache2/sites-available`
多站点配置目录:`/etc/apache2/sites-available/000-default.conf`
多站点配置参数:
```shell
<VirtualHost *:80>
    ServerAdmin riba2534@qq.com
    ServerName pan.riba2534.cn
    DocumentRoot "/var/www/pan/"
   <Directory "/var/www/pan">
     Options Indexes FollowSymLinks
     AllowOverride All
     Require all granted
   </Directory>
</VirtualHost>
```
反向代理配置:

首先执行`a2enmod proxy proxy_balancer proxy_http`,然后重启apache2服务
配置文件:
```shell
<VirtualHost *:80>
        #配置站点的域名
        ServerName shell.riba2534.cn
        #配置站点的管理员信息
        ServerAdmin i@riba2534.cn
        #off表示开启反向代理，on表示开启正向代理
        ProxyRequests Off
        ProxyMaxForwards 100
        ProxyPreserveHost On
        #这里表示要将现在这个虚拟主机跳转到本机的4000端口
        ProxyPass / http://127.0.0.1:8888/
        ProxyPassReverse / http://127.0.0.1:8888/

        <Proxy *>
            Order Deny,Allow
            Allow from all
        </Proxy>
</VirtualHost>
```

## Ubuntu18.04 下安装MySQL密码问题

在之前的ubuntu版本中，我们通过`apt install mysql-server mysql-client`这样的方式来安装mysql的时候，会提醒我们设置root用户密码，但是在18.04中不再提示了，所以我们就不知道root密码是啥，导致接下来要做的事情不能继续，经过我的搜索，找到了两个解决办法，任选其一：

如果你的MySQL有问题，建议先卸载：

```shell
apt autoremove mysql-client mysql-server --purge -y
```

然后再安装：

```shell
apt install mysql-client mysql-server -y
```

这个时候在系统的root账户下，直接输入:`mysql`就可以进入，但是在普通用户下输入`mysql -u root -p`后就不能进入，这时参考以下的两个解决办法，以下两种办法都是在系统的普通用户下进行的。

### 方法一

在MySQL安装的时候，系统自动生成了一个配置文件，里面有一个初始的账户和密码：

```shell
sudo cat /etc/mysql/debian.cnf
```

然后这个文件里面有默认的用户名和密码，用这个登录系统:

```shell
mysql -u 用户名 -p 
```

进入MySQL命令提示符下，输入:

```sql
update mysql.user set authentication_string=PASSWORD("密码") where User="root";
# 这个操作是在生成一个用户，但是有一个wraning
```

解决warning：

```sql
update mysql.user set plugin="mysql_native_password";
```

接着，刷新和退出：

```shell
flush privileges;
exit;
```

再重启一下MySQL服务，然后就可以正常的`mysql -u root -p`登录了

### 方法二

首先在系统的shell中输入：
```shell
sudo mysql_secure_installation
```
根据提示，进行初始化密码设置。

在系统普通账户下，直接输入`sudo mysql`，进入MySQL命令提示符，然后输入：

```sql
SELECT user,authentication_string,plugin,host FROM mysql.user;
```

这时候我们看到：

```shell
Output
+------------------+-------------------------------------------+-----------------------+-----------+
| user             | authentication_string                     | plugin                | host      |
+------------------+-------------------------------------------+-----------------------+-----------+
| root             |                                           | auth_socket           | localhost |
| mysql.session    | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | mysql_native_password | localhost |
| mysql.sys        | *THISISNOTAVALIDPASSWORDTHATCANBEUSEDHERE | mysql_native_password | localhost |
| debian-sys-maint | *CC744277A401A7D25BE1CA89AFF17BF607F876FF | mysql_native_password | localhost |
+------------------+-------------------------------------------+-----------------------+-----------+
4 rows in set (0.00 sec)

```

登录的方式不是密码，而是`auth_socket`方式进行登录.

我们修改这个方式即可，继续在MySQL的命令行输入：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '密码';
```
然后刷新:

```sql
FLUSH PRIVILEGES;
```

这时，也可以正常登录了。

参考：[How To Install MySQL on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-18-04)

## Ubuntu18.04安装LAMP环境

### 方法一

直接按照`LAMP`的顺序来

### 方法二

```shell
apt install apache2 -y
apt install mysql-server mysql-client -y # 关于密码的解决问题看前面
apt install phpmyadmin
```
关键在于第三步，`apt install phpmyadmin`,这一步会同时自动安装最新的php。。

### 方法三

这个方法更简单：

```shell
sudo apt install lamp-server^ -y
```

## Ubuntu添加普通用户到sudo组

正常电脑使用或者服务器维护中，我们一般不直接使用 root 账号，如果你现在只有一个 root 账号可以通过下面命令新建一个用户：

```shell
useradd -m steven   //steven 是我的用户名
```
然后通过下面命令设置密码：
```shell
passwd steven    //为刚创建的用户设置密码
```
执行命令添加到sudo组:
```shell
usermod -a -G sudo steven    //注意改成你自己的用户名
```

## Ubuntu安装wordpress让其可以自动更新升级的方法

先将wordpress的所有者设为www-data（当人也可以在apache的那个文件夹里面将apache的所有者改为你喜欢的那个用户，比如root）,在终端执行：
```shell
sudo chown -R www-data /var/www/wordpress
```
然后，让这个文件夹可读写

```shell
sudo chmod -R 755 /var/www/wordpress
```

## man 命令 的代替 tldr

先用 `pip` 安装：

```shell
pip3 install tldr
```
使用：

```
tldr 命令 #替换 man
```

## 删除 ssh 中旧的 key

方法：

```shell
ssh-keygen -R 要删除的地址
```

## 配置 ssh 免密登录

比如 A 主机是本地机器，B 是服务器机器，现在需要 A 免密登陆 B ，那么只需要把 A 生成的秘钥文件放在 B 主机的对应位置上即可。

1. 密钥生成方法 A 执行：`ssh-keygen` 一路回车即可。
2. 然后在 A 机器的 `~/.ssh/id_rsa.pub` 就是我们需要的秘钥文件
3. 把 `id_rsa.pub` 这个文件的内容放在 B 机器的 `~/.ssh/authorized_keys` 加一行，然后就可以免密登陆了
4. 传输 `id_rsa.pub` 的方法可以是：` ssh-copy-id 地址`

## ssh config 配置

编辑 `~/.ssh/config`

```shell
Host 别名
    Hostname 主机名
    Port 端口
    User 用户名
```

之后就可以 `ssh 别名` 连接了。



## vim 配置

编辑 `~/.vimrc` 文件，把下面的粘贴进去：

```shell
set number                  "显示行号
syntax on                   "语法高亮
set showmode                "在底部显示，当前处于命令模式还是插入模式
set encoding=utf-8          "使用 utf-8 编码
set t_Co=256                "256色
set autoindent              "按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致
set tabstop=4               "按下 Tab 键时，Vim 显示的空格数
set expandtab               "由于 Tab 键在不同的编辑器缩进不一致，该设置自动将 Tab 转为空格
set softtabstop=4           "Tab 转为多少个空格
set cursorline              "光标所在的当前行高亮
set  ruler                  "在状态栏显示光标的当前位置（位于哪一行哪一列）
set showmatch               "光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号
set hlsearch                "搜索时，高亮显示匹配结果
set ignorecase              "搜索时忽略大小写
set nobackup                "不创建备份文件
set noswapfile              "不创建交换文件

```

## 使用 vscode Remote Development 插件连接到远程机器上默认shell

发现使用  vscode Remote Development  插件连接到远程机器上默认 shell 是 bash 而不是 zsh 搜了一下，在 github 上面找到了相关的 issue . [Default shell not launched in remote](https://github.com/Microsoft/vscode-remote-release/issues/38) 

解决办法就是：

![](https://user-images.githubusercontent.com/2193314/57120128-f698c200-6d23-11e9-9220-551e7cf16d0e.png)
加入配置：

```json
{
  "terminal.integrated.shell.linux": "/bin/zsh"
}
```
## scp 使用

1. 从本地复制到远程：

```shell
scp local_file remote_username@remote_ip:remote_folder 
或者 
scp local_file remote_username@remote_ip:remote_file 
或者 
scp local_file remote_ip:remote_folder 
或者 
scp local_file remote_ip:remote_file 

复制目录
scp -r local_folder remote_username@remote_ip:remote_folder 
或者 
scp -r local_folder remote_ip:remote_folder 
```

2. 从远程到本地

```shell
scp root@www.runoob.com:/home/root/others/music /home/space/music/1.mp3 
scp -r www.runoob.com:/home/root/others/ /home/space/music/
```
## golang 编译脚本以及跨平台编译和upx压缩

交叉编译：

```shell
1、Mac下编译Linux, Windows平台的64位可执行程序：

$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build test.go

$ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build test.go


2、Linux下编译Mac, Windows平台的64位可执行程序：

$ CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build test.go

$ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build test.go



3、Windows下编译Mac, Linux平台的64位可执行程序：

$ SET CGO_ENABLED=0SET GOOS=darwin3 SET GOARCH=amd64 go build test.go

$ SET CGO_ENABLED=0 SET GOOS=linux SET GOARCH=amd64 go build test.go

注：如果编译web等工程项目，直接cd到工程目录下直接执行以上命令

GOOS：目标可执行程序运行操作系统，支持 darwin，freebsd，linux，windows

GOARCH：目标可执行程序操作系统构架，包括 386，amd64，arm

Golang version 1.5以前版本在首次交叉编译时还需要配置交叉编译环境：

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 ./make.bash

CGO_ENABLED=0 GOOS=windows GOARCH=amd64 ./make.bash
```

upx 使用：

```shell
brew install upx
upx 软件名 # 可以达到加壳压缩操作
```

编译脚本：

写一个 build.sh 可以很方便的把对应的东西都编译一下

```shell
#!/bin/sh

GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" # -ldflags 这个可以抹除代码相关信息，gdb无法调试
upx BaiduPCS-Go
```

## tmux 命令

```
tmux new -s foo # 新建名称为 foo 的会话
tmux ls # 列出所有 tmux 会话
tmux a # 恢复至上一次的会话
tmux a -t foo # 恢复名称为 foo 的会话，会话默认名称为数字
tmux kill-session -t foo # 删除名称为 foo 的会话
tmux kill-server # 删除所有的会话
```

## 查看某个端口被程序占用

```shell
lsof -i:端口号
netstat -tunpl | grep 端口号
```

## vscode cpp-tools无法正常格式化

解决方案：https://github.com/Microsoft/vscode-cpptools/issues/3271


## ubuntu 使用charles教程

基本设置：https://blog.jjonline.cn/mine/242.html
https证书设置：https://www.jianshu.com/p/baea81d30380

## ubuntu 19.10 字体不等宽解决

1. https://www.cnblogs.com/youxia/p/LinuxDesktop003.html?tdsourcetag=s_pctim_aiomsg
2. http://ljf-cnyali.cn/2019/07/18/linux%E5%AD%97%E4%BD%93%E6%B8%B2%E6%9F%93%E7%9A%84%E4%BF%AE%E5%A4%8D%E4%B8%8E%E6%94%B9%E5%96%84/
3. ubuntu19.10美化:https://blog.csdn.net/Hunter808/article/details/102642565

## ubuntu19.10 pip安装mysqlclient失败解决方案

1. [安装Python mysqlclient出现“OSError: mysql_config not found”错误](https://blog.csdn.net/wangtaoking1/article/details/51554959)
2. 

## MYSQL 创建新用户 &开放远程登录

> 适用于 MySQL8.0 之前

首先查看：`netstat -an | grep 3306`

![image-20210729001125308](https://image-1252109614.cos.ap-beijing.myqcloud.com/img/image-20210729001125308.png)

如果显示的是 `127.0.0.1` 就证明只监听了本机的端口，我们需要修改一下：`vim /etc/mysql/my.cnf`

在里面找到：

```
bind-address          = 127.0.0.1
```

这一行，注释掉，重启 mysql，`/etc/init.d/mysql restart`

![image-20210729001358731](https://image-1252109614.cos.ap-beijing.myqcloud.com/img/image-20210729001358731.png)

然后需要创建用户并开放远程登录：

1. 创建用户

```shell
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```

- username：你将创建的用户名
- host：指定该用户在哪个主机上可以登陆，如果是本地用户可用localhost，如果想让该用户可以**从任意远程主机登陆**，可以使用通配符`%`
- password：该用户的登陆密码，密码可以为空，如果为空则该用户可以不需要密码登陆服务器

```shell
# 例子：
CREATE USER 'dog'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'pig'@'192.168.1.101_' IDENDIFIED BY '123456';
CREATE USER 'pig'@'%' IDENTIFIED BY '123456';   # 这个允许任意ip访问
CREATE USER 'pig'@'%' IDENTIFIED BY '';
CREATE USER 'pig'@'%';
```

2. 授权

```shell
GRANT privileges ON databasename.tablename TO 'username'@'host'
```

- privileges：用户的操作权限，如`SELECT`，`INSERT`，`UPDATE`等，如果要授予所的权限则使用`ALL`
- databasename：数据库名
- tablename：表名，如果要授予该用户对所有数据库和表的相应操作权限则可用`*`表示，如`*.*`

例如：**为用户赋予操作数据库testdb的所有权限**

```shell
grant all privileges on testdb.* to test@localhost identified  by '1234';
GRANT ALL ON *.* TO 'test'@'%'; # 给用户所有表的权限
```

## Ubuntu 安装 7Z

https://blog.csdn.net/LEON1741/article/details/54317715

```shell
apt install p7zip-full # 安装
```



