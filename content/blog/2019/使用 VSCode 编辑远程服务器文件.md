---
title: 使用 VSCode 编辑远程服务器文件
date: 2019-04-29T17:02:00+08:00
lastmod: 2019-04-30T10:45:28+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201518.png"
tags:
- VSCode
categories: 工具资源
comment: true

---

# 使用 VSCode 编辑远程服务器文件

在远程服务器上使用 vim 编辑文件一直觉得不太顺手，个人比较喜欢用 VSCode  ，终于解决了使用 VSCode 编辑远程文件。

介绍两种方法：

1. `Remote VSCode` 插件
2. `SFTP` 插件

## Remote VSCode
### 安装 Remote VSCode

发现一款插件 Remote VSCode，可以实现这个功能

![](https://i.loli.net/2019/04/29/5cc6bad090c28.png)

如图，好评数还是很多的。

1. 首先我们打开 [Remote VSCode](https://marketplace.visualstudio.com/items?itemName=rafaelmaiolla.remote-vscode&ssr=false#review-details) 这个插件的官方页面，点击安装即可，或者直接在 VSCode 中搜索这个插件。这个动作需要在本地进行。

2. 我们需要在远程服务器上安装 rmate 这个软件：

   ```bash
   sudo wget -O /usr/local/bin/rmate https://raw.github.com/aurora/rmate/master/rmate
   sudo chmod a+x /usr/local/bin/rmate
   ```

### 使用

1. 在本机的 VSCode 中按 `F1` ,然后输入 `Remote: Start server` ,回车后启动服务

   ![](https://i.loli.net/2019/04/29/5cc6bbfeb7b8e.png)

2. 按一下 `Ctrl+~`打开自带终端， 在 VSCode 的命令行中输入 `ssh -R 52698:127.0.0.1:52698 用户名@地址 -p ssh端口(一般是22)`

3. 然后在终端中找到你要修改的文件，输入 `rmate 文件名`

### 配置

一般来说，前面的已经够用了，但是如果要进行定制的话，可以打开设置自行修改。

```json
//-------- Remote VSCode configuration --------

// Port number to use for connection.
"remote.port": 52698,

// Launch the server on start up.
"remote.onstartup": true

// Address to listen on.
"remote.host": "127.0.0.1"

// If set to true, error for remote.port already in use won't be shown anymore.
"remote.dontShowPortAlreadyInUseError": false
```

## SFTP
### 安装 `SFTP` 插件
去插件官方地址点击安装：[SFTP](https://marketplace.visualstudio.com/items?itemName=liximomo.sftp)

可以看一下插件的介绍：
![](https://i.loli.net/2019/04/30/5cc7b4c3dbc66.png)
利用 `SFTP` 在本地工作区和服务器工作区完全同步。可以在本地工作区点右键上传/下载（一般是自动保持同步）

### 使用
首先用 `VSCODE` 打开一个新的工作区，然后按 `F1` 键，运行 `SFTP: config` 命令，打开一个配置文件。把里面的内容改成如下所示：

```json
{
    "host": "服务器ip地址",
    "port": 22,
    "username": "用户名",
    "password": "密码",
    "protocol": "sftp",
    "agent": null,
    "privateKeyPath": null,
    "passphrase": null,
    "passive": false,
    "interactiveAuth": true,
    "remotePath": "要同步的远程服务器目录",
    "uploadOnSave": true,
    "syncMode": "update",
    "ignore": [
        "**/.vscode/**",
        "**/.git/**",
        "**/.DS_Store"
    ],
    "watcher": {
        "files": "glob",
        "autoUpload": true,
        "autoDelete": true
    }
}
```

修改这几个配置，点击保存即可。这时候可以通过鼠标右键拉取或者上传。

## 总结
1. 以上两个插件各有优缺点
2. `Remote VSCode` 可以编辑远程服务器的任何文件，没有工作区的限制，可以在平时修改文件中用一下。
3. `SFTP` 正是因为有了工作区的概念，它可以同步一个完整的项目目录，推荐在日常开发中使用。