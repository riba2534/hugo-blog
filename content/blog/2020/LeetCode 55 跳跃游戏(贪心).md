---
title: LeetCode 55 跳跃游戏(贪心)
date: 2020-04-17T11:46:08+08:00
lastmod: 2020-04-17T11:46:08+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[跳跃游戏](https://leetcode-cn.com/problems/jump-game/)

给定一个非负整数数组，你最初位于数组的第一个位置。

数组中的每个元素代表你在该位置可以跳跃的最大长度。

判断你是否能够到达最后一个位置。

**示例 1:**

```
输入: [2,3,1,1,4]
输出: true
解释: 我们可以先跳 1 步，从位置 0 到达 位置 1, 然后再从位置 1 跳 3 步到达最后一个位置。
```

**示例 2:**

```
输入: [3,2,1,0,4]
输出: false
解释: 无论怎样，你总会到达索引为 3 的位置。但该位置的最大跳跃长度是 0 ， 所以你永远不可能到达最后一个位置。
```

## 思路

刚开始看题感觉是个dp，于是没想到状态转移，写了发暴搜验证一下正确性，交了一下超时了。然后考虑了一下，这道题应该$O(n)$过，所以应该是个贪心了。

我们从第一个位置开始，维护一下最远能到达的位置，$O(n)$遍历，当当前位置不能到达的时候，那么肯定是到不了最后一个的，直接返回`false`，如果能正常遍历完，那么肯定是可以到最后一个位置的，代码特别简单。

## 代码

```cpp
class Solution
{
public:
    bool canJump(vector<int> &nums)
    {
        int limit_pos = 0;
        for (int i = 0; i < nums.size(); i++)
        {
            if (i > limit_pos)
                return false;
            limit_pos = max(limit_pos, i + nums[i]);
        }
        return true;
    }
};
```
