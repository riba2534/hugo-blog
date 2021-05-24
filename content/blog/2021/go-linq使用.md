---
title: "Go Linq 使用"
date: 2021-05-25T02:35:34+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221223.png"
description: "Golang中的Language Integrated Query介绍"
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

在 Golang 中，语言本身并没有内置这种操作，不过好在有开源社区帮助我们实现了一个库 [ahmetb/go-linq](https://github.com/ahmetb/go-linq/tree/v3.2.0) ，详细的支持的函数列表和操作可以看这里： https://pkg.go.dev/github.com/ahmetb/go-linq/v3

特性如下：

- 没有使用任何第三方依赖，只使用了go 原生库
- 通过迭代器模式实现了惰性求值
- 并发安全
- 支持泛型方法
- 支持 array、slice、map、string、channel 和自定义集合类

go-linq 提供的方法可以按照是否支持泛型分为两大类。泛型方法都以 `T` 结尾。非泛型方法需要将函数的入参类型限制为 `interface{}` 并做类型断言。

# 基本使用

## 牛刀小试

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

可以看出，使用了 go-linq 之后，只用了一行代码，就很方便的完成了过滤，当然这只是一个简单的例子，接下来，我们详细看看具体怎么用

## 获取数据源

我们的目的是进行查询，那么在查询之前首先要获取数据，go-linq 支持将 `slice`、`map`、`channel`、`string` 和自定义的集合作为数据源，并且提供了以下获取数据的方法：

```go
func From(source interface{}) Query
func FromChannel(source <-chan interface{}) Query
func FromChannelT(source interface{}) Query
func FromIterable(source Iterable) Query
func FromString(source string) Query
func Range(start, count int) Query // 生成一个连续的数字list，起始是start，数量为 count 个
func Repeat(value interface{}, count int) Query
```

`From` 方法支持上面的所有类型进行初始化，`slice`、`map` 等只能通过 `From` 方法进行初始化

`From` 函数会将传入的集合类型转换成内部的 `Query` 类型，而 `Query` 中只包含一个方法 `Iterate` ，这个方法的返回值是一个迭代器函数。

```go
// Iterator is an alias for function to iterate over data.
type Iterator func() (item interface{}, ok bool)

// Query is the type returned from query functions. It can be iterated manually
// as shown in the example.
type Query struct {
	Iterate func() Iterator
}

// Iterable is an interface that has to be implemented by a custom collection in
// order to work with linq.
type Iterable interface {
	Iterate() Iterator
}
```

为了描述方便，我们定义如下结构体：

```go
// 一个学生类，里面包含学号和姓名
type Student struct {
	ID   int
	Name string
}

// 定义一个生成 100 个学生的函数
func makeStudents() []Student {
	students := []Student{}
	for i := 1; i <= 100; i++ {
		students = append(students, Student{i, fmt.Sprintf("学生%d", i)})
	}
	return students
}
```

那么，我们以 `students` 作为数据源，则：

```go
students := makeStudents()
linq.From(students)
```

接下来我们介绍一些常用的查询操作。

## 筛选数据 `where`

筛选可以说是最常见的集合操作了。go-linq 提供了以下几种方法方法来进行筛选，它们的区别在于筛选函数中是否提供索引位置。

```go
func (q Query) Where(predicate func(interface{}) bool) Query
func (q Query) WhereIndexed(predicate func(int, interface{}) bool) Query
func (q Query) WhereIndexedT(predicateFn interface{}) Query
func (q Query) WhereT(predicateFn interface{}) Query
```

假设我们要筛选出 `学号 > 50` 的学生，则可以写出如下代码：

```go
func main() {
	result := []Student{}
	students := makeStudents()
	linq.From(students).Where(func(i interface{}) bool {
		return i.(Student).ID > 50
	}).ToSlice(&result)
	fmt.Println(result)
}
```

`where` 接受一个返回值为 `bool` 的函数，我们这里首先断言 `i` 的类型为 `Student` ，然后判断学号是否大于50，最后使用 `ToSlice` 函数，把结果转换成一个 `slice`，得到答案。

> `Toslice` 函数的实现也是经过迭代器的遍历，这里相当于内部做了一个封装：
>
> ```go
> // ToSlice iterates over a collection and saves the results in the slice pointed
> // by v. It overwrites the existing slice, starting from index 0.
> //
> // If the slice pointed by v has sufficient capacity, v will be pointed to a
> // resliced slice. If it does not, a new underlying array will be allocated and
> // v will point to it.
> func (q Query) ToSlice(v interface{}) {
> 	res := reflect.ValueOf(v)
> 	slice := reflect.Indirect(res)
> 
> 	cap := slice.Cap()
> 	res.Elem().Set(slice.Slice(0, cap)) // make len(slice)==cap(slice) from now on
> 
> 	next := q.Iterate()
> 	index := 0
> 	for item, ok := next(); ok; item, ok = next() {
> 		if index >= cap {
> 			slice, cap = grow(slice)
> 		}
> 		slice.Index(index).Set(reflect.ValueOf(item))
> 		index++
> 	}
> 
> 	// reslice the len(res)==cap(res) actual res size
> 	res.Elem().Set(slice.Slice(0, index))
> }
> ```

## 排序数据 `order by`

go-linq 支持升序排序，降序排序，自定义排序，函数签名如下：

```go
func (q Query) OrderBy(selector func(interface{}) interface{}) OrderedQuery
func (q Query) OrderByDescending(selector func(interface{}) interface{}) OrderedQuery
func (q Query) OrderByDescendingT(selectorFn interface{}) OrderedQuery
func (q Query) OrderByT(selectorFn interface{}) OrderedQuery
func (q Query) Sort(less func(i, j interface{}) bool) Query
func (q Query) SortT(lessFn interface{}) Query
```

### 升序排序

还是上面的例子，假设我们要对学生的学号从小到大排序（虽然本身就是升序的，这里只作为一个例子）：

```go
func main() {
	result := []Student{}
	students := makeStudents()
	linq.From(students).OrderBy(func(i interface{}) interface{} {
		return i.(Student).ID
	}).ToSlice(&result)
	fmt.Println(result)
}
```

OrderBy 接收的是要排序的具体字段，这里取出结构体的序号.

### 降序排序

```go
func main() {
	result := []Student{}
	students := makeStudents()
	linq.From(students).OrderByDescending(func(i interface{}) interface{} {
		return i.(Student).ID
	}).ToSlice(&result)
	fmt.Println(result)
}
```

跟上面一样，我们只是把调用方法换成了 OrderByDescending

### 自定义比较函数

```go
func main() {
	result := []Student{}
	students := makeStudents()
	linq.From(students).Sort(func(i interface{}, j interface{}) bool {
		return i.(Student).ID > j.(Student).ID
	}).ToSlice(&result)
	fmt.Println(result)
}
```

如果用过 `C++` 的 `sort` 的同学肯定很熟悉这个操作，就是自定义一个比较函数，我这里只是简单的从大到小排个序，但是实际使用中，你可以任意做一些骚操作。

## 选择 `select`

select 主要用来对结构体字段进行处理筛选

- `Select`、`SelectT`:筛选对应的字段。
- `SelectIndexd`、`SelectIndexdT`:筛选对应字段，这边可以拿到对应结构体的下标信息

函数签名如下：

```go
func (q Query) Select(selector func(interface{}) interface{}) Query
func (q Query) SelectIndexed(selector func(int, interface{}) interface{}) Query
func (q Query) SelectIndexedT(selectorFn interface{}) Query
func (q Query) SelectMany(selector func(interface{}) Query) Query
func (q Query) SelectManyBy(selector func(interface{}) Query, ...) Query
func (q Query) SelectManyByIndexed(selector func(int, interface{}) Query, ...) Query
func (q Query) SelectManyByIndexedT(selectorFn interface{}, resultSelectorFn interface{}) Query
func (q Query) SelectManyByT(selectorFn interface{}, resultSelectorFn interface{}) Query
func (q Query) SelectManyIndexed(selector func(int, interface{}) Query) Query
func (q Query) SelectManyIndexedT(selectorFn interface{}) Query
func (q Query) SelectManyT(selectorFn interface{}) Query
func (q Query) SelectT(selectorFn interface{}) Query
```

假设我要获取这些学生的姓名列表，可以这么做：

```go
func main() {
	students := makeStudents()
	linq.From(students).Select(func(i interface{}) interface{} {
		return i.(Student).Name
	}).ForEachT(func(s string) {
		fmt.Println(s)
	})
}
```

我们从 `[]Students` 中只把 `Name` 字段提取出来了，并且变成了一个 `List`，这里使用的 `ForEachT` 底层也是使用迭代器遍历得到的。

函数签名中带有 `SelectMany` 的函数作用是把多维数组扁平化，对多维度数组进行处理，传入一个返回 `linq.Query` 对象的方法，一次之后把二维数组扁平化为一维数组

```go
func main() {
	input := [][]int{{1, 2, 3}, {4, 5, 6, 7}}
	//二位数组进行合并
	r := linq.From(input).SelectManyT(
		func(i []int) linq.Query {
			return linq.From(i)
		},
	).Results()
	fmt.Println(r)
	//三维数组进行合并
	input1 := [][][]int{{{1, 2, 3}}, {{4, 5, 6, 7}, {8, 9, 10}}}
	r = linq.From(input1).SelectManyT(
		func(i [][]int) linq.Query {
			return linq.From(i)
		},
	).SelectManyT(
		func(i []int) linq.Query {
			return linq.From(i)
		},
	).Results()
	fmt.Println(r)
}

/*
output:
[1 2 3 4 5 6 7]
[1 2 3 4 5 6 7 8 9 10]
*/
```

从例子可以看出，我们把一个二维数组打平成了一个一位数组，三维数组打平了两次，这里使用了 `.Results()` 来获取结果，其实底层实现也是迭代器。

## 分组 `group by`

关于分组的函数签名定义有：

```go
func (q Query) GroupBy(keySelector func(interface{}) interface{}, ...) Query
func (q Query) GroupByT(keySelectorFn interface{}, elementSelectorFn interface{}) Query
func (q Query) GroupJoin(inner Query, outerKeySelector func(interface{}) interface{}, ...) Query
func (q Query) GroupJoinT(inner Query, outerKeySelectorFn interface{}, innerKeySelectorFn
```

假设我们要按照学号的奇偶性把学生分成两组，则可以：

```go
func main() {
	students := makeStudents()
	var res []linq.Group
	linq.From(students).GroupBy(
		func(key interface{}) interface{} { return key.(Student).ID % 2 },
		func(value interface{}) interface{} { return value.(Student) },
	).ToSlice(&res)
	for _, item := range res {
		fmt.Println(item.Key)
		for _, v := range item.Group {
			fmt.Printf("%+v ", v.(Student))
		}
		fmt.Println()
	}
}
```

`GroupBy` 接收两个参数，一个是分组的名称筛选函数，一个是分组的值筛选函数，最后分组后的每一组的结构为 `[]linq.Group`，Group 结构为：

```go
// Group is a type that is used to store the result of GroupBy method.
type Group struct {
	Key   interface{}
	Group []interface{}
}
```

有一个组名称 key，还有组里的元素列表。

另还有 `GroupJoin` 这种函数可以连接其他的集合分组，可以查看 API 文档使用，这里不再叙述。

## 集合操作

我们先把生成学生的函数做一点改造：

```go
func makeStudents1() []Student {
	students := []Student{}
	for i := 1; i <= 100; i++ {
		students = append(students, Student{i, fmt.Sprintf("学生%d", i)})
	}
	return students
}
func makeStudents2() []Student {
	students := []Student{}
	for i := 50; i <= 150; i++ {
		students = append(students, Student{i, fmt.Sprintf("学生%d", i)})
	}
	return students
}
```

令：

```go
students1 := makeStudents1()
students2 := makeStudents2()
```

这里可以生成一个学号为 `1-100` 与 `50-150` 的学生，接下来我们对他进行一些集合操作。

### 求差集 `Except`

go-linq 支持对两个 `Query` 之间求差集，其中：

- `Except` ：根据结构体筛选两个 Query 之间的差集
- `ExceptBy` ：根据结构体的字段筛选两个 Query 之间的差集

```go
func (q Query) Except(q2 Query) Query
func (q Query) ExceptBy(q2 Query, selector func(interface{}) interface{}) Query
func (q Query) ExceptByT(q2 Query, selectorFn interface{}) Query
```

我们先求一下 `students1-students2` 的结果：

```go
res := []Student{}
linq.From(students1).Except(linq.From(students2)).ToSlice(&res)
```

最后的结果是学生学号为 `1-49` 的学生。

如果使用 `ExceptBy` ，则我们就是指定了一个筛选函数，只用学生的ID作比较。最后的结果是学生学号为 `1-49` 的学生。

```go
res := []Student{}
linq.From(students1).ExceptBy(linq.From(students2), func(i interface{}) interface{} {
	return i.(Student).ID
}).ToSlice(&res)
```

### 求交集 `Intersect`

我们来看一下求并集的函数签名：

```go
func (q Query) Intersect(q2 Query) Query
func (q Query) IntersectBy(q2 Query, selector func(interface{}) interface{}) Query
func (q Query) IntersectByT(q2 Query, selectorFn interface{}) Query
```

一看就知道，和求差集差不多，我们来尝试一下。

使用 `Intersect`：

```go
res := []Student{}
linq.From(students1).Intersect(linq.From(students2)).ToSlice(&res)
```

使用 `IntersectBy`：

```go
res := []Student{}
linq.From(students1).IntersectBy(linq.From(students2), func(i interface{}) interface{} {
	return i.(Student).ID
}).ToSlice(&res)
```

结果都是学号为 `50-100` 的学生。

### 求并集 `Union`

先看函数签名：

```go
func (q Query) Union(q2 Query) Query  // 不会排除两个Query中重复的元素，有多少个元素就组合成多少个元素的Query
func (q Query) Concat(q2 Query) Query // 会排除掉两个Query中重复的元素
func (q Query) Append(item interface{}) Query // 将新的元素添加到Query的最后一个位置
func (q Query) Prepend(item interface{}) Query // 将新的元素添加到Query的第一个位置
```

则：

使用 `Union` ：

```go
linq.From(students1).Union(linq.From(students2)).ToSlice(&res)
// 结果是学号 1-150 的学生（没去重）
```

去重后结果 `Concat` ：

```go
linq.From(students1).Concat(linq.From(students2)).ToSlice(&res)
// 结果是学号 1-150 的学生（去重后）
```

`Append` 和 `Prepend` 用法一样，此处不赘述。 

## `All` 判断是否所有元素都满足条件

函数签名：

```go
func (q Query) All(predicate func(interface{}) bool) bool
func (q Query) AllT(predicateFn interface{}) bool
```

使用：

```go
linq.From(students1).All(func(i interface{}) bool { return i.(Student).ID > 0 })
```

返回一个 `bool`，判断学生的学号是否都大于0

## `Any` 判断是否有任意个元素满足条件

函数签名：

```go
func (q Query) Any() bool
func (q Query) AnyWith(predicate func(interface{}) bool) bool
func (q Query) AnyWithT(predicateFn interface{}) bool
```

使用：

```go
linq.From(students1).AnyWith(func(i interface{}) bool { return i.(Student).ID == 0 })
```

返回一个 `bool`，判断是否存在至少一个学生的学号等于0

## `ToMap` 转换为Map

ToMap提供了三个方法：

- `ToMap`：需要配合 SelectT 方法去生成返回一个 linq.KeyValue 的结构，指定对应的Map的key和value

-  `ToMapBy`、`ToMapByT`：提供两个方法，一个方法指定key，一个方法指定value

  如果key相同的话，前面的元素会被覆盖掉，ToMap 方法的使用需要配合Select方法.

函数签名：

```go
func (q Query) ToMap(result interface{})
func (q Query) ToMapBy(result interface{}, keySelector func(interface{}) interface{}, ...)
func (q Query) ToMapByT(result interface{}, keySelectorFn interface{}, valueSelectorFn interface{})
```

使用：

```go
type Product struct {
	Name string
	Code int
}

products := []Product{
	{Name: "orange", Code: 4},
	{Name: "apple", Code: 9},
	{Name: "lemon", Code: 12},
	{Name: "apple", Code: 9},
}

map1 := map[int]string{}
From(products).
	SelectT(
		func(item Product) KeyValue { return KeyValue{Key: item.Code, Value: item.Name} },
	).
	ToMap(&map1)

fmt.Println(map1[4])
fmt.Println(map1[9])
fmt.Println(map1[12])
```

## `Contains` 判断元素是否在Query中

函数签名：

```go
func (q Query) Contains(value interface{}) bool
```

使用：

```go
linq.From(students1).Contains(Student{1, "学生1"})
```

返回一个 bool，判断数据源中是否存在此元素。

# 结语

本文列出了 `go-linq` 的常用操作，应该可以应付很多的场景了，go-linq 还有很多方法，大家可以自行查阅官方 API 文档。

# 参考链接

1. https://github.com/ahmetb/go-linq
2. https://pkg.go.dev/github.com/ahmetb/go-linq/v3
3. https://blog.csdn.net/qq_34326321/article/details/110422960





