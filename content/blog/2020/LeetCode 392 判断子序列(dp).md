---
title: LeetCode 392 判断子序列(dp)
date: 2020-07-27T01:32:09+08:00
lastmod: 2020-07-27T01:32:09+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[判断子序列](https://leetcode-cn.com/problems/is-subsequence/)

给定字符串 **s** 和 **t** ，判断 **s** 是否为 **t** 的子序列。

你可以认为 **s** 和 **t** 中仅包含英文小写字母。字符串 **t** 可能会很长（长度 ~= 500,000），而 **s** 是个短字符串（长度 <=100）。

字符串的一个子序列是原始字符串删除一些（也可以不删除）字符而不改变剩余字符相对位置形成的新字符串。（例如，`"ace"`是 `"abcde"`的一个子序列，而 `"aec"`不是）。

**示例 1:****s** = `"abc"`, **t** = `"ahbgdc"`

返回 `true`.

**示例 2:****s** = `"axc"`, **t** = `"ahbgdc"`

返回 `false`.

**后续挑战****:**

如果有大量输入的 S，称作S1, S2, ... , Sk 其中 k >= 10亿，你需要依次检查它们是否为 T 的子序列。在这种情况下，你会怎样改变代码？

**致谢:**

特别感谢 [@pbrother ](https://leetcode.com/pbrother/)添加此问题并且创建所有测试用例。

## 思路

### 方案1：双指针

直接模拟，挨个试就行

### 方案2：dp

定义 `dp[i][j]`表示从位置 `i`开始往后的字符 `j`第一次出现的位置。则在状态转移过程中，如果t中位置为 `i`的字符就是 `j`，则$dp[i][j]=j$，否则$dp[i][j]=dp[i+1][j]$，所以需要从后往前枚举。

在预处理完后所有的dp状态后只需要判断，s串是否可以一直转移到最后状态即可。

## 代码

模拟代码：

```cpp
class Solution
{
public:
    bool isSubsequence(string s, string t)
    {
        int i = 0, j = 0;
        while (i < s.size() && j < t.size())
        {
            if (s[i] == t[j])
                i++, j++;
            else
                j++;
        }
        return i == s.size();
    }
};
```

dp代码：

```cpp
class Solution
{
public:
    bool isSubsequence(string s, string t)
    {
        int n = s.size(), m = t.size();
        vector<vector<int>> dp(m + 1, vector<int>(26, 0));
        for (int i = 0; i < 26; i++)
            dp[m][i] = m;

        for (int i = m - 1; i >= 0; i--)
            for (int j = 0; j < 26; j++)
                if (t[i] == j + 'a')
                    dp[i][j] = i;
                else
                    dp[i][j] = dp[i + 1][j];

        int i = 0;
        for (int j = 0; j < n; j++)
        {
            if (dp[i][s[j] - 'a'] == m)
                return false;
            i = dp[i][s[j] - 'a'] + 1;
        }
        return true;
    }
};

```
