---
title: LeetCode 546 移除盒子(区间dp，记忆化搜索)
date: 2020-08-15T12:32:00+08:00
lastmod: 2020-08-21T01:01:31+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[移除盒子](https://leetcode-cn.com/problems/remove-boxes/)

给出一些不同颜色的盒子，盒子的颜色由数字表示，即不同的数字表示不同的颜色。
你将经过若干轮操作去去掉盒子，直到所有的盒子都去掉为止。每一轮你可以移除具有相同颜色的连续 k 个盒子（k >= 1），这样一轮之后你将得到 `k*k` 个积分。
当你将所有盒子都去掉之后，求你能获得的最大积分和。

**示例：**

```
输入：boxes = [1,3,2,2,2,3,4,3,1]
输出：23
解释：
[1, 3, 2, 2, 2, 3, 4, 3, 1] 
----> [1, 3, 3, 4, 3, 1] (3*3=9 分) 
----> [1, 3, 3, 3, 1] (1*1=1 分) 
----> [1, 1] (3*3=9 分) 
----> [] (2*2=4 分)
```

**提示：**

- `1 <= boxes.length <= 100`
- `1 <= boxes[i] <= 100`

## 思路

区间dp，记忆化搜索。

令 $dp[l][r][k]$ 表示消除区间 $[l,r]$ 内的所有盒子，以及消除 $r$ 之后 $k$ 个等于 $A_r$ 的盒子组成的序列的最大积分，则当前值为 $A_r$ 的盒子有 $(k+1)$ 个，产生的价值为：$(k+1)^2$，则：

- $dp[l][r][k]=dp[l][r-1][0]+(k+1)^2$

区间 $[l,r-1]$ 内可能还存在着值等于 $A_r$ 的盒子，设这个位置为 $i$ ，则之前的 $k$ 个盒子加上位置在 $r$ 处的盒子组成了新的 $k$，值为 $(k+1)$ ：

- $dp[l][r][k]=max(dp[l][r][k],dp[l][i][k+1]+dp[i+1][r-1][0])$

则，最后的答案就是求出 $dp[0][boxes.size()-1][0]$ 的值。

## 代码

```cpp
class Solution
{
public:
    int dp[110][110][110];
    int removeBoxes(vector<int> &boxes)
    {
        memset(dp, 0, sizeof(dp));
        return dfs(boxes, 0, boxes.size() - 1, 0);
    }
    int dfs(vector<int> &nums, int l, int r, int k)
    {
        if (l > r)
            return 0;
        if (dp[l][r][k])
            return dp[l][r][k];
        while (r > 0 && nums[r] == nums[r - 1])
            r--, k++;
        dp[l][r][k] = dfs(nums, l, r - 1, 0) + (k + 1) * (k + 1);
        for (int i = l; i < r; i++)
            if (nums[i] == nums[r])
                dp[l][r][k] = max(dp[l][r][k], dfs(nums, l, i, k + 1) + dfs(nums, i + 1, r - 1, 0));
        return dp[l][r][k];
    }
};
```
