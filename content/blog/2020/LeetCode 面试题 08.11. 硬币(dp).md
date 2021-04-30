---
title: LeetCode 面试题 08.11. 硬币(dp)
date: 2020-04-23T01:48:52+08:00
lastmod: 2020-04-23T01:48:52+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[硬币](https://leetcode-cn.com/problems/coin-lcci/)

硬币。给定数量不限的硬币，币值为25分、10分、5分和1分，编写代码计算n分有几种表示法。(结果可能会很大，你需要将结果模上1000000007)

**示例1:**

```
 输入: n = 5
 输出：2
 解释: 有两种方式可以凑成总金额:
5=5
5=1+1+1+1+1
```

**示例2:**

```
 输入: n = 10
 输出：4
 解释: 有四种方式可以凑成总金额:
10=10
10=5+5
10=5+1+1+1+1+1
10=1+1+1+1+1+1+1+1+1+1
```

**说明：**

注意:

你可以假设：

- 0 <= n (总金额) <= 1000000

## 思路

类似于完全背包，求方案数。

定义`dp[n]`表示用这些硬币凑成面额为`n`的方案数。如果需要凑出一个面额，假设当前硬币面额为`v[i]`，则方案数可以累加为：`dp[n]+=dp[n-v[i]]`，代表用已知的可以凑成`n-v[i]`面额的方案数加上当前的硬币面额，可以凑出`n`。

时间复杂度：$O(n)$

## 代码

```cpp
class Solution
{
public:
    int mod = 1e9 + 7;
    int v[4] = {1, 5, 10, 25};
    int waysToChange(int n)
    {
        vector<int> dp(n + 1, 0);
        dp[0] = 1;
        for (int i = 0; i < 4; i++)
            for (int j = v[i]; j <= n; j++)
                dp[j] = (dp[j] + dp[j - v[i]]) % mod;
        return dp[n];
    }
};
```








