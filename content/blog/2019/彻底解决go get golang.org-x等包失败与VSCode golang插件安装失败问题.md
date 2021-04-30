---
title: 彻底解决go get golang.org/x等包失败与VSCode golang插件安装失败问题
date: 2019-09-23T16:16:00+08:00
lastmod: 2019-09-23T16:16:00+08:00
draft: false
featured_image: ""
tags:
- GOPROXY
categories: GoLang
comment: true

---

## 问题描述
由于某种众所周知的一些原因，`https://golang.org/` golang 的官方域名是被墙了的，这也就导致了，在广大 go 开发者使用 golang 的时候，总会出现 `go get` 失败的问题。解决这个问题的办法，网上一搜一大堆，总结一下，网上大概有两种解决方案。

1. 因为 `go get` 不到的库，一般来说在 `github` 都有人做了镜像，这个时候一般是曲线救国，从 `github` 上面搞下来，然后把对应的东西放在对应目录，这种方式比较麻烦，而且比较慢。
2. 用代理，需要一台国外服务器，开启一个 http 代理或者 socks5 代理，或者各种梯子，曲线救国，这种方式其实挺好的，我之前一直用这种方式，不过需要国外服务器以及其他一些知识。或者设置 `GOPROXY` 等。

## 解决方案
golang 的 1.13 版本已经正式发布了，这个版本中，新的包管理方式 `Go module` 已经正式被扶正，还有支持 go 模块代理。对于咱们中国的开发者来说，一个优秀的 Go 模块代理可以帮助我们解决很多问题。比如 Go 语言中最知名的 golang.org/x/... 模块在中国大陆是无法访问到的，以前我们会用很多其他的办法来抓取他们，而若依靠一个可以访问到它们的模块代理，那么将事半功倍。更因为 Go 1.13 将 GOPROXY 默认成了中国大陆无法访问的 https://proxy.golang.org ，所以我们中国的开发者从今以后必须先修改 GOPROXY 才能正常使用 go 来开发应用了。为此，我们联合中国备受信赖的云服务提供商七牛云专门为咱们中国开发者而打造了一个 Go 模块代理：goproxy.cn。github地址：[goproxy](https://github.com/goproxy/goproxy.cn)

那么如何使用这个代理呢？只需要一句命令。

```shell
go env -w GOPROXY=https://goproxy.cn,direct
```
完成。然后进行 go get 以及其他获取包的命令，都会经过七牛云进行代理，速度回有一个质的飞跃。前提是需要把 go 版本升级为 `>=1.13`


## 参考资料
- [goproxy.cn - 为中国 Go 语言开发者量身打造的模块代理](https://studygolang.com/topics/10014)
- [Go 1.13 正式发布，看看都有哪些值得关注的特性](https://studygolang.com/topics/10021)
- [goproxy中文说明](https://github.com/goproxy/goproxy.cn/blob/master/README.zh-CN.md)
