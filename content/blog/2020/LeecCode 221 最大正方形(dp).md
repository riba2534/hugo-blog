---
title: LeecCode 221 最大正方形(dp)
date: 2020-05-08T01:56:15+08:00
lastmod: 2020-05-08T01:56:15+08:00
draft: false
featured_image: ""
tags:
- dp
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[最大正方形](https://leetcode-cn.com/problems/maximal-square/)

在一个由 0 和 1 组成的二维矩阵内，找到只包含 1 的最大正方形，并返回其面积。

**示例:**

```
输入: 

1 0 1 0 0
1 0 1 1 1
1 1 1 1 1
1 0 0 1 0

输出: 4
```

## 思路

定义`dp[i][j]`代表以当前坐标`(i,j)`为正方形右下角的点的最大边长。

我们只需要考虑矩阵中为1的点，只有为1的点才会对答案产生影响，易得`dp[i][0]=dp[0][j]=1`

对于其他的点，可以由`左`,`上`,`左上`转移过来，对这三个值取最小值，再加上当前点就是答案。即：

$dp[i][j] = min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1$

## 代码

```cpp
class Solution
{
public:
    int maximalSquare(vector<vector<char>> &matrix)
    {
        if (matrix.size() == 0)
            return 0;
        int n = matrix.size(), m = matrix[0].size();
        vector<vector<int>> dp(n, vector<int>(m, 0));
        int area = 0;
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                if (matrix[i][j] == '1')
                {
                    if (i == 0 || j == 0)
                        dp[i][j] = 1;
                    else
                        dp[i][j] = min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]) + 1;
                    area = max(area, dp[i][j] * dp[i][j]);
                }
            }
        }
        return area;
    }
};

```
