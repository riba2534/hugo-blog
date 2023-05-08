---
title: "如何获得一个ETH钱包地址靓号"
date: 2023-05-09T00:55:58+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/05/09/645929c2c205d.png"
description: ""
tags:
- ETH
- 加密货币
- cropto
- web3
categories:
- web3
- 以太坊
comment : true
---

# 如何获得一个ETH钱包地址靓号

今天在某个群吹水的时候有个群友发了一个以太坊靓号生成器 [VANITY-ETH](https://vanity-eth.tk/) ，可以生成指定前缀或者后缀的 ETH 钱包地址， 我一想，我之前链上的地址是随便生成的，每次交易时都要仔细核对前缀和后缀，很麻烦，如果生成一个符合我的平时习惯的地址，在 web3 世界里遨游不就会方便很多吗。

这个生成器只能在浏览器中使用，且依赖浏览器自身并不能很好利用 PC 的性能，我的地址前后缀要求比较高，跑了很久都没有跑出需要的，我就在网上尝试搜索一些纯服务端的靓号生成器，找了一会没找到，所以我决定自己写一个。

借助 GO 的天然多核CPU亲和性，我使用 golang 构建了一个靓号生成器，项目地址为: https://github.com/riba2534/rare_eth

 下面是使用说明，大家有同样需求的可以试试：

# ETH 靓号钱包地址生成器 💰

在 Web3 世界冲浪，谁不想要一个靓号呢？ETH 靓号钱包地址生成器是一个 Go 语言编写的工具，用于生成具有 **特定前缀**和 **后缀** 的以太坊钱包地址 🔑。

本项目所有运算均在本地完成，**不能也永远不会存储你生成的内容** 🚫，你可以根据计算机配置的高低自由决定增加线程以达到更快的生成速度 💨，或在计算机运行困难时适当减少线程 😴。

你可以通过命令行参数来控制前缀、后缀和线程数量 🛠️。

## 下载安装 

首先从本项目的 [Releases](https://github.com/riba2534/rare_eth/releases) 中找到符合自己平台的二进制文件下载，下载完成后重命名为 `rare_eth` 📥，如果程序没有可执行权限请手动加一下:

```bash
chmod +x rare_eth
```

## 使用方法

使用命令行运行可执行文件，可指定钱包地址的前缀、后缀和线程数量：

```bash
./rare_eth -p <prefix> -s <suffix> -n <numGoroutines>
```

参数说明：

- `-p` 或 `--prefix`：需要的钱包地址的前缀，不指定则为不限制。注意字母必须为 A-F 之间的字母，数字无要求 🆔。
- `-s` 或 `--suffix`：需要的钱包地址的后缀，不指定则为不限制。注意字母必须为 A-F 之间的字母，数字无要求 🆔。
- `-n` 或 `--numGoroutines`：线程数量，默认为 100 ⚙️。

找到满足条件的钱包地址后，程序会输出对应的钱包地址和私钥，以及私钥的二维码 🎉。

## 示例

生成一个以 `888` 为前缀，以 `888` 为后缀的 ETH 钱包靓号：

```bash
./rare_eth -p 888 -s 888 -n 500
```

👇 下图为程序运行后输出的结果：

![1683563988360.png](https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/05/09/645925d4ed800.png)

我们得到了一个 888 开头 888 结尾的靓号 💯

> 你的前后缀要求越高，程序计算越慢，如果你想要 8个8 这种靓号，推荐 s使用 tmux 或者  screen  这种工具在服务器后台慢慢跑，直到跑出你想要的结果

## 兼容性

ETH 靓号生成器生成的 ETH 靓号地址均符合 ERC-20 标准，支持 Ethereum、BSC、HECO、Polygon、OKEx、Fantom、Optimism、Avalanche 等网络。
Keystore 文件与 MyEtherWallet、imToken、MetaMask、TokenPocket、Mist 及 geth 完全兼容。

## 贡献

欢迎提交 Issue 或 Pull Request 来完善本项目。在提交 Pull Request 之前，请确保你的代码符合 Go 语言的编码规范。

## 许可证

本项目采用 [MIT 许可证](LICENSE) 授权。
