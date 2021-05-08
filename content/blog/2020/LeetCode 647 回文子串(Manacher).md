---
title: LeetCode 647 回文子串(Manacher)
date: 2020-08-19T02:35:42+08:00
lastmod: 2020-08-19T02:35:42+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- Manacher
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)

给定一个字符串，你的任务是计算这个字符串中有多少个回文子串。

具有不同开始位置或结束位置的子串，即使是由相同的字符组成，也会被视作不同的子串。

**示例 1：**

```
输入："abc"
输出：3
解释：三个回文子串: "a", "b", "c"
```

**示例 2：**

```
输入："aaa"
输出：6
解释：6个回文子串: "a", "a", "a", "aa", "aa", "aaa"
```

**提示：**

- 输入的字符串长度不会超过 1000 。

## 思路

首先这题长度不超过1000，那$O(n^2)$ 算法肯定能做。

但是标程肯定是用 `Manacher` 算法来做的。

关于此算法原理，可以看 [最长回文子串——Manacher 算法](https://segmentfault.com/a/1190000003914228)

首先给原串间隔的添加一个不相关的符号隔开。

在这里我们知道几点关键点即可：

- `p[i]` 代表以第 `i` 个位置为中心的最长回文半径（包括 `i`）
- `p[i]-1` 代表，原串中以第 `i` 个位置为中心的最长回文串长度
- `pos` 代表当前最右边为 `max_right` 元素时的回文串中心
- `max_right` 代表当前访问到的所有回文子串，所能触及的最右一个字符的位置。

对于本题，我们可以知道所有的 `p[i]` ，则 `p[i]-1` 就是当前位置最长回文串长度，我们对于每个位置的长度向上取整除以2，累加起来就是不同子串数量。

## 代码

```cpp
class Solution
{
public:
    vector<int> p;
    int pos, max_right;
    string init(string s)
    {
        string ans = "#";
        for (char ch : s)
            ans = ans + ch + '#';
        return ans;
    }
    int countSubstrings(string s)
    {
        int ans = 0;
        s = init(s);
        p.resize(s.size());
        pos = 0, max_right = 0;
        for (int i = 0; i < s.size(); i++)
        {
            if (i < max_right)
                p[i] = min(p[2 * pos - i], max_right - i);
            else
                p[i] = 1;
            while (i - p[i] >= 0 && i + p[i] < s.size() && s[i - p[i]] == s[i + p[i]])
                p[i]++;
            if (p[i] + i - 1 > max_right)
            {
                max_right = p[i] + i - 1;
                pos = i;
            }
            ans += ((p[i] - 1) + 1) / 2;
        }
        return ans;
    }
};
```
