---
title: LeetCode 72 编辑距离(dp)
date: 2020-04-06T11:50:20+08:00
lastmod: 2020-04-06T11:50:20+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[编辑距离](https://leetcode-cn.com/problems/edit-distance/)

给你两个单词 *word1* 和 *word2*，请你计算出将 *word1* 转换成 *word2* 所使用的最少操作数 。

你可以对一个单词进行如下三种操作：

1. 插入一个字符
2. 删除一个字符
3. 替换一个字符

 

**示例 1：**

```
输入：word1 = "horse", word2 = "ros"
输出：3
解释：
horse -> rorse (将 'h' 替换为 'r')
rorse -> rose (删除 'r')
rose -> ros (删除 'e')
```

**示例 2：**

```
输入：word1 = "intention", word2 = "execution"
输出：5
解释：
intention -> inention (删除 't')
inention -> enention (将 'i' 替换为 'e')
enention -> exention (将 'n' 替换为 'x')
exention -> exection (将 'n' 替换为 'c')
exection -> execution (插入 'u')
```

## 思路

简单dp，定义`dp[i][j]`代表把第一个串的前`i`个字符，变成第2个串的前`j`个字符，需要花费的代价。

由题意易得`dp[i][0]=i`，`dp[0][j]=j`，因为当一个串为空，变为第二个串，必然要花费和第二个串长度相同的代价。所以得到状态转移方程：

$$dp[i][j]=\left\{\begin{matrix}
dp[i-1][j]+1\\ 
dp[i][j-1]+1\\ 
dp[i-1][j-1]+(s1[i]!=s2[j])
\end{matrix}\right.$$

可参考我之前博客:[51Nod - 1183 编辑距离(dp)](https://blog.csdn.net/riba2534/article/details/79884301)

## 代码

```cpp
class Solution
{
public:
    int minDistance(string word1, string word2)
    {
        int len1 = word1.size();
        int len2 = word2.size();
        vector<vector<int>> dp(len1 + 10, vector<int>(len2 + 10, 0));
        for (int i = 0; i <= len1; i++)
            dp[i][0] = i;
        for (int j = 0; j <= len2; j++)
            dp[0][j] = j;
        for (int i = 1; i <= len1; i++)
            for (int j = 1; j <= len2; j++)
                dp[i][j] = min(min(dp[i - 1][j] + 1, dp[i][j - 1] + 1), dp[i - 1][j - 1] + (word1[i - 1] == word2[j - 1] ? 0 : 1));
        return dp[len1][len2];
    }
};
```
