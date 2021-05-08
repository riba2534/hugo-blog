---
title: LeetCode 45 跳跃游戏 II(贪心)
date: 2020-05-04T01:56:00+08:00
lastmod: 2020-05-04T01:56:53+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[跳跃游戏 II](https://leetcode-cn.com/problems/jump-game-ii/)

给定一个非负整数数组，你最初位于数组的第一个位置。

数组中的每个元素代表你在该位置可以跳跃的最大长度。

你的目标是使用最少的跳跃次数到达数组的最后一个位置。

**示例:**

```
输入: [2,3,1,1,4]
输出: 2
解释: 跳到最后一个位置的最小跳跃数是 2。
     从下标为 0 跳到下标为 1 的位置，跳 1 步，然后跳 3 步到达数组的最后一个位置。
```

**说明:**

假设你总是可以到达数组的最后一个位置。

## 思路

题目已经给出总是可以到达最后一个位置。

我们考虑贪心的思路，比如样例，第一个数字为`2`，所以能到达的最大区间为 `[i+1,i+nums[i]]` ，也就是能跳到的范围为 `[1,2]`，我们肯定是想尽量到达的比较远，那么我们就从`1,2`这个区间选出跳的最远的，以这个点为起跳点进行跳，也就是样例中下标为1这个位置的值`3`，它所能到达的范围是`[2,4]`，由于`2`这个位置上一次起跳已经能跳到了，所以就是跳到下标为`3`或者`4`的地方时，下标需要加一。

我们维护一个当前能跳到的最远位置`maxPos`，和当前能跳到的边界`end`（在不超过end的范围内不用额外跳），遍历一遍数组即可。时间复杂度为$O(n)$

## 代码

```cpp
class Solution
{
public:
    int jump(vector<int> &nums)
    {
        int maxPos = 0, n = nums.size(), end = 0, step = 0;
        for (int i = 0; i < n - 1; ++i)
        {
            if (maxPos >= i)
            {
                maxPos = max(maxPos, i + nums[i]);
                if (i == end)
                {
                    end = maxPos;
                    ++step;
                }
            }
        }
        return step;
    }
};
```
