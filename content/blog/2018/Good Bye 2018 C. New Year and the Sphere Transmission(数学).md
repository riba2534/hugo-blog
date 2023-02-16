---
title: Good Bye 2018 C. New Year and the Sphere Transmission(数学)
date: 2018-12-31T16:41:02+08:00
lastmod: 2018-12-31T16:41:02+08:00
draft: false
featured_image: https://image-1252109614.cos.ap-beijing.myqcloud.com/2023/02/17/63ee7d56e59a4.jpg
tags:
- CodeForces
- 数论
categories: OnlineJudge刷题
comment: true

---

题目链接：[C. New Year and the Sphere Transmission](https://codeforces.com/contest/1091/problem/C)

> There are $n$ people sitting in a circle, numbered from $1$ to $n$ in the order in which they are seated. That is, for all $i$ from $1$ to $n-1$, the people with id $i$ and $i+1$ are adjacent. People with id $n$ and $1$ are adjacent as well.
>
> The person with id $1$ initially has a ball. He picks a positive integer $k$ at most $n$, and passes the ball to his $k$-th neighbour in the direction of increasing ids, that person passes the ball to his $k$-th neighbour in the same direction, and so on until the person with the id $1$ gets the ball back. When he gets it back, people do not pass the ball any more.
>
> For instance, if $n = 6$ and $k = 4$, the ball is passed in order $[1, 5, 3, 1]$.
>
> Consider the set of all people that touched the ball. The fun value of the game is the sum of the ids of people that touched it. In the above example, the fun value would be $1 + 5 + 3 = 9$.
>
> Find and report the set of possible fun values for all choices of positive integer $k$. It can be shown that under the constraints of the problem, the ball always gets back to the $1$-st player after finitely many steps, and there are no more than $10^5$ possible fun values for given $n$.

## Input

> The only line consists of a single integer $n$ ($2 \leq n \leq 10^9$) — the number of people playing with the ball.

## Output

> Suppose the set of all fun values is $f_1, f_2, \dots, f_m$.
>
> Output a single line containing $m$ space separated integers $f_1$ through $f_m$ in increasing order.

## Examples

### Input
```
6
```
### Output
```
1 5 9 21
```
### Input
```
16
```
### Output
```
1 10 28 64 136
```
## Note

> In the first sample, we've already shown that picking $k = 4$ yields fun value $9$, as does $k = 2$. Picking $k = 6$ results in fun value of $1$. For $k = 3$ we get fun value $5$ and with $k = 1$ or $k = 5$ we get $21$.
>
> ![](https://codeforces.com/predownloaded/cf/a9/cfa92b3228335c77776143e8991a2c9a96a0cbe9.png)
>
> In the second sample, the values $1$, $10$, $28$, $64$ and $136$ are achieved for instance for $k = 16$, $8$, $4$, $10$ and $11$, respectively.

## 思路

有$n$个数围成一个环，编号是从$1$到$n$ ，现在你可以随意选择一个不超过$n$的数$k$，从$1$开始，按照环上字符增大的顺序，每隔$k$个选择一个数字，直到回到起点$1$，然后计算出路径上不同数字的和，记为`fun value`，题目给出你一个数$n$，然后让你求出这$n$个数的所有的`fun value`，从小到大输出结果。

如果选择的$k$是$n$的因数，那么一定可以一轮就走完，不同的因数，获得的`fun value`的值也不一样。

当选择的$k$不是$n$的因数时，那么一轮一定走不完，然后直到某一轮走的路径正好和$k$是$n$的因数的某一条路径重合，所以我们计算$k$是$n$的因数的路径时，已经把这种情况包含了。

所以，利用等差数列求和公式$S_n=\frac{n(a_1+a_n)}{2}$可以计算出结果。第一项一定为$1$，数字的个数就是当前枚举的$i$或者$\frac{n}{i}$.

可以打个表验证一下:

<details><summary>打表代码</summary>

```cpp
#include <bits/stdc++.h>
using namespace std;
#define mem(a, b) memset(a, b, sizeof(a))
typedef long long ll;
int get_x(int n, int x)
{
    if (x == n)
        return 1;
    int s = x, sum = x + 1;
    while (s != 0)
    {
        s = (s + x) % n;
        sum += (s + 1);
    }
    return sum;
}
set<int> getall_n(int n)
{
    set<int> s;
    for (int i = 1; i <= n; i++)
        s.insert(get_x(n, i));
    return s;
}
int main()
{
    for (int i = 1; i <= 100; i++)
    {
        printf("n=%d:\n", i);
        set<int> s = getall_n(i);
        for (auto x : s)
            printf("%d ", x);
        printf("\n");
    }
    return 0;
}
```

</details>

然后印证了我们的观点，每个数的答案个数就是他的因子个数。

## 代码

```cpp
#include <bits/stdc++.h>
using namespace std;
typedef long long ll;
set<ll> s;
int main()
{
    ll n;
    scanf("%lld", &n);
    for (ll i = 1; i * i <= n; i++)
    {
        if (n % i == 0)
        {
            ll x = n / i;
            s.insert((1 + n - i + 1) * x / 2);
            s.insert((1 + n - x + 1) * i / 2);
        }
    }
    for (auto x : s)
        printf("%lld ", x);
    puts("");
    return 0;
}
```