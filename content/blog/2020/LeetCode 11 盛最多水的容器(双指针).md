---
title: LeetCode 11 盛最多水的容器(双指针)
date: 2020-04-18T11:44:52+08:00
lastmod: 2020-04-18T11:44:52+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[盛最多水的容器](https://leetcode-cn.com/problems/container-with-most-water/)

给你 *n* 个非负整数 *a*1，*a*2，...，*a*n，每个数代表坐标中的一个点 (*i*, *ai*) 。在坐标内画 *n* 条垂直线，垂直线 *i* 的两个端点分别为 (*i*, *ai*) 和 (*i*, 0)。找出其中的两条线，使得它们与 *x* 轴共同构成的容器可以容纳最多的水。

**说明：**你不能倾斜容器，且 *n* 的值至少为 2。

 

![img](https://aliyun-lc-upload.oss-cn-hangzhou.aliyuncs.com/aliyun-lc-upload/uploads/2018/07/25/question_11.jpg)

图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

 

**示例：**

```
输入：[1,8,6,2,5,4,8,3,7]
输出：49
```

## 思路

根据题意，对于题目的问题，我们假设左右端点为`l`和`r`，那么面积为：$S=(r-l)*min(height[l],height[r])$，我们需要求出最大的$S$。

做法是我们开始让`l`和`r`指向序列的头和尾，此时需要移动双指针，那么如何移动呢，做法是移动左右端点值比较小的那个，如果是左端点就向右移，如果是右端点就向左移，中途每算出一次面积，就求最大值，最后的结果就是答案。

那么如何证明这个策略的正确性呢，我们考虑，根据上面的公式，如果我们移动大的而不是小的，那么移动后$min(height[l],height[r])$的值并没有改变，只可能减小，不可能增大，因为我们进行了移动，则$(r-l)$一定会减小，这样的话，面积$S$一定会减小，所以我们的策略要移动小的，而不是大的。

## 代码

```cpp
class Solution
{
public:
    int maxArea(vector<int> &height)
    {
        // s = (r-l)*min(a[l],a[r]) ,求  max(s)
        int maxx = 0, l = 0, r = height.size() - 1;
        while (r - l >= 1)
        {
            int s = (r - l) * min(height[l], height[r]);
            maxx = max(maxx, s);
            if (height[l] > height[r])
                r--;
            else
                l++;
        }
        return maxx;
    }
};
```

