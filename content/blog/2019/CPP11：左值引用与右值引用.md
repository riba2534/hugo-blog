---
title: C++11：左值引用与右值引用
date: 2019-01-01T20:07:00+08:00
lastmod: 2019-01-01T21:16:10+08:00
draft: false
featured_image: https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d3e48341.jpg
tags:
- C++
categories: C++
comment: true

---

# C++11：左值引用与右值引用

在 C++11 的新标准中，出现了「右值引用」的说法，既然有了右值引用，那么传统的引用也就叫做左值引用。

右值引用 (Rvalue Referene) 是 C++ 新标准 (C++11, 11 代表 2011 年 ) 中引入的新特性 , 它实现了转移语义 (Move Sementics) 和精确传递 (Perfect Forwarding)。它的主要目的有两个方面：

1. 消除两个对象交互时不必要的对象拷贝，节省运算存储资源，提高效率。
2. 能够更简洁明确地定义泛型函数。

## 左值与右值的定义

C++( 包括 C) 中所有的表达式和变量要么是左值，要么是右值。通俗的左值的定义就是非临时对象，那些可以在多条语句中使用的对象。所有的变量都满足这个定义，在多条代码中都可以使用，都是左值。右值是指临时的对象，它们只在当前的语句中有效。请看下列示例 :

1. 简单的赋值语句

   `如：int i = 0;`

   在这条语句中，i 是左值，0 是临时值，就是右值。在下面的代码中，i 可以被引用，0 就不可以了。立即数都是右值。

2. 右值也可以出现在赋值表达式的左边，但是不能作为赋值的对象，因为右值只在当前语句有效，赋值没有意义。

   如：`((i>0) ? i : j) = 1;`

   在这个例子中，0 作为右值出现在了”=”的左边。但是赋值对象是 i 或者 j，都是左值。

   在 C++11 之前，右值是不能被引用的，最大限度就是用常量引用绑定一个右值，如 :

   `const int &a = 1;`

   在这种情况下，右值不能被修改的。但是实际上右值是可以被修改的，如 :

   `T().set().get();`

   T 是一个类，set 是一个函数为 T 中的一个变量赋值，get 用来取出这个变量的值。在这句中，T() 生成一个临时对象，就是右值，set() 修改了变量的值，也就修改了这个右值。

   既然右值可以被修改，那么就可以实现右值引用。右值引用能够方便地解决实际工程中的问题，实现非常有吸引力的解决方案。

## 左值引用

本小节，谈「引用」与「左值引用」同义。

- 具名变量的别名：`类型名 & 引用名 变量名`
  - 例如：`int v0; int & v1 = v0;`其中 v1 是变量 v0 的引用，他们再内存单元中是同一单元中两个不同的名字。 
- **引用必须在定义时进行初始化**
- 被引用变量名可以是结构变量成员，如`S.m`
- 函数参数可以是引用类型，表示函数的形式参数与实际参数是同一个变量，改变形参将改变实参
- 函数返回值可以是引用类型，但不得是函数的临时变量。

> 引用的定义格式：
>
> ```cpp
> 数据类型& 变量名称 = 被引用变量名称;
> int a;
> int& ref = a;
> ```
>
> 引用的性质：
>
> - 引用类型的变量，不占用单独的存储空间
> - 为另一数据对象起别名，与该对象同享存储空间
> - 对引用变量类型的操作就是对被引用变量的操作
>
> 引用的重要用途：
>
> - 作为函数参数
>
>   - 参数传递机制，引用传递，直接修改实际参数值
>     - 使用格式`返回值类型 函数名称(类型 & 参数名称)`
>
> - 常量引用：既能引用常量，不能通过引用改变目标对象值；引用本身也不能改变引用对象
>
>   - 引用作为函数返回值时不生成副本
>
>   - 函数示例：
>
>     ```cpp
>     #include <bits/stdc++.h>
>     using namespace std;
>     int &Inc(int &dest, const int &alpha)
>     {
>         dest += alpha;
>         return dest;
>     }
>     int main()
>     {
>         int a = 10, b = 20, c;
>         c = Inc(a, b)++;
>         printf("a=%d,b=%d,c=%d\n", a, b, c);
>         return 0;
>     }
>     ```
>
>     这个函数首先把 b 累加到 a 上去，然后返回的是 a ，最后给 c 赋值之后，再给 a 加 1 .

## 右值引用

右值引用是 C++11 新标准里面新增加的一种引用类型。

右值引用：

- 右值：不能取地址的、没有名字的就是「右值」

- 匿名变量（临时变量）的别名：

  ```cpp
  类型名 && 引用名 表达式;
  ```

- 例如：

  ```cpp
  int && sum = 3 + 4;//初值是3 + 4 这个表达式
  float && res = ReturnRvalue(f1,f2);
  ```

- 右值引用的典型应用是在函数参数中，例如：

  ```cpp
  void AcceptRvalueRef(T&& s){...}
  ```

  目的是：减少函数拷贝开销

### 左值和右值:

左值的声明符号为`&`， 为了和左值区分，右值的声明符号为`&&`。

```cpp
#include <bits/stdc++.h>
using namespace std;
void process_value(int &i)
{
    std::cout << "LValue processed: " << i << std::endl;
}
void process_value(int &&i)
{
    std::cout << "RValue processed: " << i << std::endl;
}
int main()
{
    int a = 0;
    process_value(a);
    process_value(1);
}
```

运行结果:

```
LValue processed: 0
RValue processed: 1
```

Process_value 函数被重载，分别接受左值和右值。由输出结果可以看出，临时对象是作为右值处理的。

但是如果临时对象通过一个接受右值的函数传递给另一个函数时，就会变成左值，因为这个临时对象在传递过程中，变成了命名对象。比如:

```cpp
#include <bits/stdc++.h>
using namespace std;
void process_value(int &i)
{
    std::cout << "LValue processed: " << i << std::endl;
}

void process_value(int &&i)
{
    std::cout << "RValue processed: " << i << std::endl;
}

void forward_value(int &&i)
{
    process_value(i);
}

int main()
{
    int a = 0;
    process_value(a);
    process_value(1);
    forward_value(2);
}
```

结果:

```
LValue processed: 0
RValue processed: 1
LValue processed: 2
```

虽然 2 这个立即数在函数 forward_value 接收时是右值，但到了 process_value 接收时，变成了左值。

### 作用

前面说了那么多，那么右值引用的意义到底体现在哪里呢，明明我不用引用也可以实现，为什么要用右值引用呢，因为在对性能要求较高时，我们必须减少不必要的内存消耗，节省存储资源，比如以下例子：

```cpp
#include <iostream>
using namespace std;

int g_constructCount = 0;
int g_copyConstructCount = 0;
int g_destructCount = 0;
struct A
{
    A()
    {
        cout << "construct: " << ++g_constructCount << endl;
    }

    A(const A &a)
    {
        cout << "copy construct: " << ++g_copyConstructCount << endl;
    }
    ~A()
    {
        cout << "destruct: " << ++g_destructCount << endl;
    }
};

A GetA()
{
    return A();
}

int main()
{
    A a = GetA();
    return 0;
}
```

为了观察清楚这个程序真正的变化，再编译的时候加上`-fno-elide-constructors`关闭返回值优化效果。

输出结果：

```
construct: 1
copy construct: 1
destruct: 1
copy construct: 2
destruct: 2
destruct: 3
```

很清楚的可以看到，在没有返回值优化的情况下，拷贝构造函数调用了两次，一次是GetA()函数内部创建的对象返回出来构造一个临时对象产生的，另一次是在main函数中构造a对象产生的。第二次的destruct是因为临时对象在构造a对象之后就销毁了。

那么我们把这个程序稍微改改，如果用右值引用来绑定函数返回值的话，结果会是什么样子呢？首先修改代码

```cpp
int main()
{
    A &&a = GetA();
    return 0;
}
```

输出结果：

```
construct: 1
copy construct: 1
destruct: 1
destruct: 2
```

通过右值引用，比之前少了一次拷贝构造和一次析构，原因在于右值引用绑定了右值，让临时右值的生命周期延长了。

所以，**通过右值引用，可以让一个临时对象重获新生，在它完成任务时不用被销毁，而是生存期与引用他的那个变量一样长**

## 参考

关于右值引用，更深入的请参考以下链接:

- [右值引用与转移语义](https://www.ibm.com/developerworks/cn/aix/library/1307_lisl_c11/index.html)
- [从4行代码看右值引用](https://www.cnblogs.com/qicosmos/p/4283455.html)

以及一个知乎问题：

- [如何评价 C++11 的右值引用（Rvalue reference）特性？](https://www.zhihu.com/question/22111546)



