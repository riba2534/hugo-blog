---
title: "Go Linq 使用"
date: 2021-05-24T18:40:34+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221223.png"
description: "Golang语言集成查询包"
tags:
- go-linq
- linq
- golang
categories:
- Golang
comment : true
---

# 前言

最近我负责了一个新项目，大概流程是从 DB 里拿出一堆数据之后，得到一个包含字段很多的结构体的 `List`，然后需要对这个 `List` 进行一系列的过滤，包括但不限于类似 sql 中的  `where`、`group by`、`select` 、按照某个字段排序、求并补交集之类的操作。

如果让我自己写，我肯定是一个一个条件慢慢写，但是代码库我是接手的别人的，我看了下现有的实现，大呼牛逼，原来目前对于这种操作已经有了成熟的解决方案了。

那就是：**LINQ**

# `Go-linq` 介绍

语言集成查询（Language Integrated Query），缩写为 `LINQ`，是微软的一项技术，并且被应用在了 C# 中，它直接将一些列的查询操作集成在了编程语言中，使得开发者筛选数据的时候可以大大加快速度。详见：[语言集成查询](https://zh.wikipedia.org/wiki/%E8%AF%AD%E8%A8%80%E9%9B%86%E6%88%90%E6%9F%A5%E8%AF%A2)

在 Golang 中，语言本身并没有内置这种操作，不过好在有开源社区帮助我们实现了一个库 [ahmetb/go-linq](https://github.com/ahmetb/go-linq) ，详细的支持的函数列表和操作可以看这里： https://pkg.go.dev/github.com/ahmetb/go-linq 

特性如下：

- 没有使用任何第三方依赖，只使用了go 原生库
- 通过迭代器模式实现了惰性求值
- 并发安全
- 支持泛型方法
- 支持 array、slice、map、string、channel 和自定义集合类

go-linq 提供的方法可以按照是否支持泛型分为两大类。泛型方法都以 `T` 结尾。非泛型方法需要将函数的入参类型限制为 `interface{}` 并做类型断言。

# 基本使用

首先，肯定是先引入包：

```shell
go get github.com/ahmetb/go-linq/v3
```

引入之后，就可以在项目里面用起来了。

我们找个例子先试一试，假设我要筛选出一个数组中的所有偶数，可以对比一下自己写和使用库的写法的区别：

```go
package main

import (
	"fmt"

	"github.com/ahmetb/go-linq/v3"
)

func main() {
	// 定义数据
	a := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
	// 普通过滤
	a1 := []int{}
	for _, v := range a {
		if v%2 == 0 {
			a1 = append(a1, v)
		}
	}
	fmt.Println(a1) // output: [2 4 6 8]
    // 使用 go-linq
	a2 := []int{}
	linq.From(a).Where(func(i interface{}) bool { return i.(int)%2 == 0 }).ToSlice(&a2)
	fmt.Println(a2) // output: [2 4 6 8]
}
```

可以看出，使用了 go-linq 之后，只用了一行代码，就很方便的完成了过滤，当然这只是一个简单的例子，接下来，我们可以看一些其他的例子。















# 参考链接

1. https://github.com/ahmetb/go-linq
2. https://pkg.go.dev/github.com/ahmetb/go-linq
3. https://blog.csdn.net/qq_34326321/article/details/110422960





