---
title: LeetCode 466 统计重复个数(找循环节)
date: 2020-04-19T14:30:15+08:00
lastmod: 2020-04-19T14:30:15+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[统计重复个数](https://leetcode-cn.com/problems/count-the-repetitions/)

由 n 个连接的字符串 s 组成字符串 S，记作 `S = [s,n]`。例如，`["abc",3]`=“abcabcabc”。

如果我们可以从 s2 中删除某些字符使其变为 s1，则称字符串 s1 可以从字符串 s2 获得。例如，根据定义，"abc" 可以从 “abdbec” 获得，但不能从 “acbbe” 获得。

现在给你两个非空字符串 s1 和 s2（每个最多 100 个字符长）和两个整数 0 ≤ n1 ≤ 106 和 1 ≤ n2 ≤ 106。现在考虑字符串 S1 和 S2，其中 `S1=[s1,n1]` 、`S2=[s2,n2]` 。

请你找出一个可以满足使`[S2,M]` 从 `S1` 获得的最大整数 M 。

 

**示例：**

```
输入：
s1 ="acb",n1 = 4
s2 ="ab",n2 = 2

返回：
2
```

## 思路

题意翻译成白话就是给了你两个串`s1`和`s2`，然后问`s1`中最多包含多少个`s2`。其中，这两个串的给出方式是给一个前缀串和一个数字，最后的串等于前缀串重复几次。

思路就是找循环节，最后用除法计算一下出现了多少次，这一部分可以参考 [官方题解](https://leetcode-cn.com/problems/count-the-repetitions/solution/tong-ji-zhong-fu-ge-shu-by-leetcode-solution/) 。

## 代码

```cpp
class Solution
{
public:
    int getMaxRepetitions(string s1, int n1, string s2, int n2)
    {
        if (n1 == 0)
            return 0;
        int s1cnt = 0, s2cnt = 0, index = 0;

        // mp[index]={s1cnt,s2cnt}表示，第index个字符在遍历s1cnt次s1和s2cnt次s2出现的
        unordered_map<int, pair<int, int>> mp;
        pair<int, int> pre, in;
        while (1)
        {
            s1cnt++;
            for (char ch : s1)
            {
                if (ch == s2[index])
                {
                    index++;
                    if (index == s2.size())
                    {
                        s2cnt++;
                        index = 0;
                    }
                }
            }
            // 没找到循环节，s1没了
            if (s1cnt == n1)
                return s2cnt / n2;

            if (mp.count(index))
            {
                auto [a, b] = mp[index];
                pre = {a, b};
                // 有循环节,以后的每 (s1cnt-a)个s1中包含了(s2cnt-b)个s2
                in = {s1cnt - a, s2cnt - b};
                break;
            }
            else
                mp[index] = {s1cnt, s2cnt};
        }
        int ans = pre.second + (n1 - pre.first) / in.first * in.second;
        // 匹配s1末尾剩下的
        int rest = (n1 - pre.first) % in.first;
        for (int i = 0; i < rest; ++i)
        {
            for (char ch : s1)
            {
                if (ch == s2[index])
                {
                    ++index;
                    if (index == s2.size())
                    {
                        ++ans;
                        index = 0;
                    }
                }
            }
        }
        return ans / n2;
    }
};
```

