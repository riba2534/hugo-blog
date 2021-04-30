---
title: POJ2796 Feel Good(单调栈)
date: 2019-03-03T20:55:30+08:00
lastmod: 2019-03-03T20:55:30+08:00
draft: false
featured_image: ""
tags:
- 单调栈
categories: OnlineJudge刷题
comment: true

---

## Description

> Bill is developing a new mathematical theory for human emotions. His recent investigations are dedicated to studying how good or bad days influent people's memories about some period of life. 
>
> A new idea Bill has recently developed assigns a non-negative integer value to each day of human life. 
>
> Bill calls this value the emotional value of the day. The greater the emotional value is, the better the daywas. Bill suggests that the value of some period of human life is proportional to the sum of the emotional values of the days in the given period, multiplied by the smallest emotional value of the day in it. This schema reflects that good on average period can be greatly spoiled by one very bad day. 
>
> Now Bill is planning to investigate his own life and find the period of his life that had the greatest value. Help him to do so.

## Input

> The first line of the input contains n - the number of days of Bill's life he is planning to investigate(1 <= n <= 100 000). The rest of the file contains n integer numbers a1, a2, ... an ranging from 0 to 106 - the emotional values of the days. Numbers are separated by spaces and/or line breaks.

## Output

> Print the greatest value of some period of Bill's life in the first line. And on the second line print two numbers l and r such that the period from l-th to r-th day of Bill's life(inclusive) has the greatest possible value. If there are multiple periods with the greatest possible value,then print any one of them.

## Sample Input

```
6
3 1 6 4 5 2
```

## Sample Output

```
60
3 5
```

## 思路

先说题意，首先给你 $n$ 个数，然后接下来是这些数字 $a[i]$ ，现在我们需要计算出一个值。这个值是这个序列的一段连续的子序列中的最小值 * 这个子序列中所有元素的和。对于整个序列而言，我们要使这个值最大。比如样例中使这个值最大的子序列是 `6 4 5` 其中，4 最小 ，所以这个子序列获得的值就是 $4*(6+4+5)=60$.

我们考虑，对于这个序列中的每一个数而言，我们只需要求出，以它为最小值的子序列的最左端点和最右端点，易证，这个数在一个序列中为最小值时，只有尽力的向左右扩展，它的值才会更大。

那么现在，问题就转化成了，求出所有数的最左能扩展的端点和最右能扩展的端点。我们使用一个单调栈来维护这个过程，我们定义一个结构体存储这个元素的值与这个元素的下标，遍历一下这个序列，栈顶元素比当前元素大时，代表栈顶元素的最右端点就是当前遍历的 `i-1` ，因为再向右扩展的话，就有元素比他小了，这样就不满足一个元素在子序列中最小的前提了。我们从头到尾扫一遍可以获得所有的右端点，然后再从右到左扫一遍获取所有的左端点。

然后利用一个前缀和计算一下最大值就行了。利用单调栈，时间复杂度是 $O(n)$

## 代码

```cpp
#include <cstdio>
#include <stack>
using namespace std;
typedef long long ll;
const ll N = 1e6 + 10;
ll a[N], num[N], l[N], r[N];
struct node
{
    ll x, id;
};
int main()
{
    //freopen("in.txt", "r", stdin);
    ll n;
    while (~scanf("%lld", &n))
    {
        stack<node> s;
        for (ll i = 1; i <= n; i++)
        {
            scanf("%lld", &a[i]);
            num[i] = num[i - 1] + a[i];
        }
        for (ll i = 1; i <= n; i++)
        {
            while (!s.empty() && s.top().x > a[i])
            {
                ll id = s.top().id;
                s.pop();
                r[id] = i - 1;
            }
            s.push({a[i], i});
        }
        while (!s.empty())
        {
            ll id = s.top().id;
            s.pop();
            r[id] = n;
        }
        for (ll i = n; i >= 1; i--)
        {
            while (!s.empty() && s.top().x > a[i])
            {
                ll id = s.top().id;
                s.pop();
                l[id] = i + 1;
            }
            s.push({a[i], i});
        }
        while (!s.empty())
        {
            ll id = s.top().id;
            s.pop();
            l[id] = 1;
        }
        ll maxx = -1, ansl, ansr;
        for (ll i = 1; i <= n; i++)
        {
            ll sum = a[i] * (num[r[i]] - num[l[i] - 1]);
            if (sum > maxx)
            {
                maxx = sum;
                ansl = l[i];
                ansr = r[i];
            }
        }
        printf("%lld\n%lld %lld\n", maxx, ansl, ansr);
    }
    return 0;
}
```

