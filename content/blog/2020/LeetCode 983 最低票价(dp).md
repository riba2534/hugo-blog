---
title: LeetCode 983 最低票价(dp)
date: 2020-05-06T01:14:04+08:00
lastmod: 2020-05-06T01:14:04+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- dp
- LeetCode
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[最低票价](https://leetcode-cn.com/problems/minimum-cost-for-tickets/)

在一个火车旅行很受欢迎的国度，你提前一年计划了一些火车旅行。在接下来的一年里，你要旅行的日子将以一个名为 `days` 的数组给出。每一项是一个从 `1` 到 `365` 的整数。

火车票有三种不同的销售方式：

- 一张为期一天的通行证售价为 `costs[0]` 美元；
- 一张为期七天的通行证售价为 `costs[1]` 美元；
- 一张为期三十天的通行证售价为 `costs[2]` 美元。

通行证允许数天无限制的旅行。 例如，如果我们在第 2 天获得一张为期 7 天的通行证，那么我们可以连着旅行 7 天：第 2 天、第 3 天、第 4 天、第 5 天、第 6 天、第 7 天和第 8 天。

返回你想要完成在给定的列表 `days` 中列出的每一天的旅行所需要的最低消费。

**示例 1：**

```
输入：days = [1,4,6,7,8,20], costs = [2,7,15]
输出：11
解释： 
例如，这里有一种购买通行证的方法，可以让你完成你的旅行计划：
在第 1 天，你花了 costs[0] = $2 买了一张为期 1 天的通行证，它将在第 1 天生效。
在第 3 天，你花了 costs[1] = $7 买了一张为期 7 天的通行证，它将在第 3, 4, ..., 9 天生效。
在第 20 天，你花了 costs[0] = $2 买了一张为期 1 天的通行证，它将在第 20 天生效。
你总共花了 $11，并完成了你计划的每一天旅行。
```

**示例 2：**

```
输入：days = [1,2,3,4,5,6,7,8,9,10,30,31], costs = [2,7,15]
输出：17
解释：
例如，这里有一种购买通行证的方法，可以让你完成你的旅行计划： 
在第 1 天，你花了 costs[2] = $15 买了一张为期 30 天的通行证，它将在第 1, 2, ..., 30 天生效。
在第 31 天，你花了 costs[0] = $2 买了一张为期 1 天的通行证，它将在第 31 天生效。 
你总共花了 $17，并完成了你计划的每一天旅行。
```

**提示：**

1. `1 <= days.length <= 365`
2. `1 <= days[i] <= 365`
3. `days` 按顺序严格递增
4. `costs.length == 3`
5. `1 <= costs[i] <= 1000`

## 思路

首先我们看一眼题目类型，基本就是搜索，贪心，dp了，再看一眼数据范围`365`，基本上是dp，暴搜会爆炸的。

考虑 `dp[i]` 代表一年之内从 `1` 到  `i` 天旅行需要的最小花费。

如果第`i`天不需要出去旅行，既然不旅行，那么最优解就是尽量不花钱，所以 `dp[i]=dp[i-1]`

如果第`i`天需要出去旅行，那么有三种情况：

1. 买第`i`天当天的票，花费`costs[0]`元，即 `dp[i]=dp[i-1]+costs[0]`
2. 7天前买的票正好延续到今天，花费即为：`dp[i]=dp[i-7]+costs[1]`
3. 30天前买的票正好延续到今天，花费为：`dp[i]=dp[i-30]+costs[2]`

那么既然是最小值，我们肯定要求出这三种情况里面最小的那个了。则：`dp[i]=min(dp[i-1]+costs[0],dp[i-7]+costs[1],dp[i]=dp[i-30]+costs[2])`，注意如果i减去的值小于0，则答案为0。

## 代码

```cpp
class Solution
{
public:
    int mincostTickets(vector<int> &days, vector<int> &costs)
    {
        unordered_map<int, int> mp;
        for (int day : days)
            mp[day]++;
        int n = days.size();
        vector<int> dp(days[n - 1] + 1, 0);
        for (int i = 1; i <= days[n - 1]; i++)
        {
            if (mp[i])
                dp[i] = min(min(dp[i - 1] + costs[0], dp[i - 7 > 0 ? i - 7 : 0] + costs[1]), dp[i - 30 > 0 ? i - 30 : 0] + costs[2]);
            else
                dp[i] = dp[i - 1];
        }
        return dp[days[n - 1]];
    }
};
```
