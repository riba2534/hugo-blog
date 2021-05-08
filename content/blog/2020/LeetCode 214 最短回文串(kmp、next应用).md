---
title: LeetCode 214 最短回文串(kmp、next应用)
date: 2020-08-29T02:41:03+08:00
lastmod: 2020-08-29T02:41:03+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
- kmp
categories: OnlineJudge刷题
comment: true

---

题目链接：[最短回文串](https://leetcode-cn.com/problems/shortest-palindrome/)

给定一个字符串 ***s***，你可以通过在字符串前面添加字符将其转换为回文串。找到并返回可以用这种方式转换的最短回文串。

**示例 1:**

```
输入: "aacecaaa"
输出: "aaacecaaa"
```

**示例 2:**

```
输入: "abcd"
输出: "dcbabcd"
```

## 思路

kmp

首先我们回归一下 kmp 中 next 数组的含义：

- `next[i]` 代表 从 `[0,i-1]` 的最长的相同**真前后缀的长度**

那么对于这个题目而言，已知题目让我们在字符串前面增加字符让他变成回文串。

我们知道，对于一个回文串而言，它的所有的前缀和后缀是相同的。

假设现在给出的字符串是：`abacd`，可以确定把字符串的逆序加在这个字符串前面一定回文，比如 `dcabaabacd` 就一定是个回文串，但是我们可以发现**原串的前缀**和**逆序后的后缀** 有重合，对于刚刚给出的例子来说。原串是 `abacd`，逆序是 `dcaba`，则前后缀重合的部分是 `aba`，那么我们拼字符串的时候，这一块就不用动，只需要把原串中 `aba`后面的字符串 `cd` 逆序后的字符串 `dc` 加在原串前，变成 `dcabacd` 就是答案。

如何求得这个原串的前缀和逆序后的后缀的最大长度呢，正好kmp的next数组就是专门干这个事的，我们给原串和逆序串中间加一个 `#` 号(防止出现原串中字符都相同的情况)，组成一个新串，然后对这个新串求 next，则新的next数组的最后的值就是最长真前后缀的长度。

知道这个长度后，只需要把这个长度之后的串逆序，加在原串前即可。

## 代码

```cpp
class Solution
{
public:
    vector<int> nxt;
    void get_next(string &p)
    {
        int len = p.length();
        int j = 0, k = -1;
        nxt[0] = -1;
        while (j < len)
            if (k == -1 || p[j] == p[k])
                nxt[++j] = ++k;
            else
                k = nxt[k];
    }
    string shortestPalindrome(string s)
    {
        string rs = s;
        reverse(rs.begin(), rs.end());
        string ns = s + "#" + rs;
        int n = ns.size();
        nxt.resize(n + 1);
        get_next(ns);
        return rs.substr(0, rs.size() - nxt[n]) + s;
    }
};
```

