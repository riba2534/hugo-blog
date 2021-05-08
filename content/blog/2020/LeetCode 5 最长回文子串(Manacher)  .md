---
title: 'LeetCode 5 最长回文子串(Manacher)  '
date: 2020-08-19T02:34:55+08:00
lastmod: 2020-08-19T02:34:55+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- Manacher
categories: OnlineJudge刷题
comment: true

---

题目链接：[最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)

给定一个字符串 `s`，找到 `s` 中最长的回文子串。你可以假设 `s` 的最大长度为 1000。

**示例 1：**

```
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```

**示例 2：**

```
输入: "cbbd"
输出: "bb"
```

## 思路

`Manacher` 算法模板题，关于此算法原理，可以看 [最长回文子串——Manacher 算法](https://segmentfault.com/a/1190000003914228)

首先给原串间隔的添加一个不相关的符号隔开。

在这里我们知道几点关键点即可：

- `p[i]` 代表以第 `i` 个位置为中心的最长回文半径（包括 `i`）
- `p[i]-1` 代表，原串中以第 `i` 个位置为中心的最长回文串长度
- `pos` 代表当前最右边为 `max_right` 元素时的回文串中心
- `max_right` 代表当前访问到的所有回文子串，所能触及的最右一个字符的位置。

本题我们只需要求出来最大的 `p[i]` 的位置即可，然后构造答案。

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
    string longestPalindrome(string s)
    {
        s = init(s);
        p.resize(s.size());
        pos = 0, max_right = 0;
        int max_p = 0, max_ppos = 0;
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
            if (p[i] > max_p)
            {
                max_p = p[i];
                max_ppos = i;
            }
        }
        string ans = "";
        for (int i = max_ppos - max_p + 1; i <= max_ppos + max_p - 1; i++)
            if (s[i] != '#')
                ans += s[i];
        return ans;
    }
};
```
