---
title: POJ3249 Test for Job(拓扑排序，dp)
date: 2019-03-03T20:57:03+08:00
lastmod: 2019-03-03T20:57:03+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201518.png"
tags:
- 拓扑排序
categories: OnlineJudge刷题
comment: true

---

## Description

> Mr.Dog was fired by his company. In order to support his family, he must find a new job as soon as possible. Nowadays, It's hard to have a job, since there are swelling numbers of the unemployed. So some companies often use hard tests for their recruitment.
>
> The test is like this: starting from a source-city, you may pass through some directed roads to reach another city. Each time you reach a city, you can earn some profit or pay some fee, Let this process continue until you reach a target-city. The boss will compute the expense you spent for your trip and the profit you have just obtained. Finally, he will decide whether you can be hired.
>
> In order to get the job, Mr.Dog managed to obtain the knowledge of the net profit *Vi* of all cities he may reach (a negative *Vi* indicates that money is spent rather than gained) and the connection between cities. A city with no roads leading to it is a source-city and a city with no roads leading to other cities is a target-city. The mission of Mr.Dog is to start from a source-city and choose a route leading to a target-city through which he can get the maximum profit.

## Input

> The input file includes several test cases. 
> The first line of each test case contains 2 integers *n* and *m*(1 ≤ *n* ≤ 100000, 0 ≤ *m* ≤ 1000000) indicating the number of cities and roads. 
> The next *n* lines each contain a single integer. The *i*th line describes the net profit of the city *i*, *Vi* (0 ≤ |*Vi*| ≤ 20000) 
> The next m lines each contain two integers *x*, *y* indicating that there is a road leads from city *x* to city *y*. It is guaranteed that each road appears exactly once, and there is no way to return to a previous city. 

## Output

> The output file contains one line for each test cases, in which contains an integer indicating the maximum profit Dog is able to obtain (or the minimum expenditure to spend)

## Sample Input

```
6 5
1
2
2
3
3
4
1 2
1 3
2 4
3 4
5 6
```

## Sample Output

```
7
```

### Hint

![img](http://poj.org/images/3249_1.gif)

## 思路

> 回顾一下拓扑排序~

先说题意，有一个 $n$ 的节点的 $DAG$ (有向无环)图，每一个节点都有一个权值，现在题目让你求出，从一个入度为0 的点到一个出度为 0 的点的最大点权和。

这是一个 dp ，我们定义 dp[i] 代表满足题目前提的条件下，走到这一点的最大值。易得状态转移方程为：

$$dp[v]=max(dp[v],dp[u]+val[i])$$

那么我们只需要在拓扑排序的时候，进行一下状态转移，最后求出最大值即可。

拓扑排序的办法是找一个入度为 0 的点，删除它的所有出边，可以用一个队列实现。

## 代码

```cpp
#include <cstdio>
#include <queue>
#include <vector>
using namespace std;
const int N = 100000 + 10;
const int inf = 0x3f3f3f3f;
int n, m;
int val[N], in[N], out[N], dp[N];
vector<int> e[N];
void topsort()
{
    queue<int> q;
    for (int i = 1; i <= n; i++)
        if (!in[i])
        {
            dp[i] = val[i];
            q.push(i);
        }
        else
            dp[i] = -inf;
    while (!q.empty())
    {
        int u = q.front();
        q.pop();
        for (int i = 0; i < e[u].size(); i++)
        {
            int v = e[u][i];
            dp[v] = max(dp[v], dp[u] + val[v]);
            in[v]--;
            if (!in[v])
                q.push(v);
        }
    }
}
int main()
{
    //freopen("in.txt", "r", stdin);
    int u, v;
    while (~scanf("%d%d", &n, &m))
    {
        for (int i = 1; i <= n; i++)
        {
            scanf("%d", &val[i]);
            e[i].clear();
            in[i] = out[i] = 0;
        }
        for (int i = 1; i <= m; i++)
        {
            scanf("%d%d", &u, &v);
            e[u].push_back(v);
            in[v]++, out[u]++;
        }
        topsort();
        int ans = -inf;
        for (int i = 1; i <= n; i++)
            if (!out[i] && dp[i] > ans)
                ans = dp[i];
        printf("%d\n", ans);
    }
    return 0;
}
```

