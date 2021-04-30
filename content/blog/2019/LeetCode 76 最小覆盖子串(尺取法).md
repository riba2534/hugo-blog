---
title: LeetCode 76 最小覆盖子串(尺取法)
date: 2019-03-16T10:43:40+08:00
lastmod: 2019-03-16T10:43:40+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[最小覆盖子串](https://leetcode-cn.com/problems/minimum-window-substring/)

给定一个字符串 S 和一个字符串 T，请在 S 中找出包含 T 所有字母的最小子串。

**示例：**

```
输入: S = "ADOBECODEBANC", T = "ABC"
输出: "BANC"
```

**说明：**

- 如果 S 中不存这样的子串，则返回空字符串 `""`。
- 如果 S 中存在这样的子串，我们保证它是唯一的答案。

## 思路

##### (滑动窗口) $O(n)$

首先用哈希表统计出 $T$ 中所有字符出现的次数。
然后我们用两个指针 $i, j(i \ge j)$来扫描整个字符串，同时用一个哈希表统计 $i, j$ 之间每种字符出现的次数，每次遍历需要的操作如下：

1. 加入 $s[i]$，同时更新哈希表；
2. 检查 $s[j]$ 是否多余，如果是，则移除 $s[j]$；
3. 检查当前窗口是否已经满足 $T​$ 中所有字符，如果是，则更新答案；

时间复杂度分析：两个指针都严格递增，最多移动 $n$ 次，所以总时间复杂度是 $O(n)$。

## 思路

```cpp
class Solution
{
  public:
    //s中最短的一段，包含t中的所有字符
    string minWindow(string s, string t)
    {
        string res;
        unordered_map<char, int> S, T;
        int total = t.size();
        for (auto &c : t) //t串中字母的种类
        {
            T[c]++;
            if (T[c] > 1)
                total--;
        }
        int slen = s.size(), cnt = 0; //当前窗口中所有字符
        for (int i = 0, j = 0; i < slen; i++)
        {
            S[s[i]]++; //更新哈希表
            if (S[s[i]] == T[s[i]])
                cnt++;
            while (j <= i && S[s[j]] > T[s[j]])
            {
                S[s[j]]--;
                j++;
            }
            if (cnt >= total && (res.empty() || i - j + 1 < res.size()))
                res = s.substr(j, i - j + 1);
        }
        return res;
    }
};
```

