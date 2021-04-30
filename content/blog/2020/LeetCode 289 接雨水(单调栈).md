---
title: LeetCode 289 接雨水(单调栈)
date: 2020-04-06T11:48:56+08:00
lastmod: 2020-04-06T11:48:56+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[接雨水](https://leetcode-cn.com/problems/trapping-rain-water/)

给定 *n* 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。

![img](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/22/rainwatertrap.png)

上面是由数组 [0,1,0,2,1,0,1,3,2,1,2,1] 表示的高度图，在这种情况下，可以接 6 个单位的雨水（蓝色部分表示雨水）。 **感谢 Marcos** 贡献此图。

**示例:**

```
输入: [0,1,0,2,1,0,1,3,2,1,2,1]
输出: 6
```

## 思路

用单调栈的思路，维护一个递减的单调栈，当不满足递减条件的时候，每弹出一个元素，就计算出这一块区域能接的水量，最后的和就是答案，复杂度为$O(n)$

## 代码

```cpp
class Solution
{
public:
    int trap(vector<int> &height)
    {
        int ans = 0;
        stack<int> st;
        for (int i = 0; i < height.size(); i++)
        {
            while (!st.empty() && height[i] > height[st.top()])
            {
                int cur = height[st.top()];
                st.pop();
                int l = st.empty() ? -1 : st.top();
                ans += (l == -1) ? 0 : (min(height[l], height[i]) - cur) * (i - l - 1);
            }
            st.push(i);
        }
        return ans;
    }
};
```


