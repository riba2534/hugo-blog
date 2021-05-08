---
title: LeetCode 4. Median of Two Sorted Arrays(思路，递归)
date: 2019-03-02T16:43:22+08:00
lastmod: 2019-03-02T16:43:22+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[寻找两个有序数组的中位数](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/)


给定两个大小为 m 和 n 的有序数组 `nums1` 和 `nums2`。

请你找出这两个有序数组的中位数，并且要求算法的时间复杂度为 O(log(m + n))。

你可以假设 `nums1` 和 `nums2` 不会同时为空。

**示例 1:**

```
nums1 = [1, 3]
nums2 = [2]

则中位数是 2.0
```

**示例 2:**

```
nums1 = [1, 2]
nums2 = [3, 4]

则中位数是 (2 + 3)/2 = 2.5
```

## 思路

##### (递归) $O(log(n + m))$

原问题难以直接递归求解，所以我们先考虑这样一个问题：

> 在两个有序数组中，找出第k大数。

如果该问题可以解决，那么第 $(n + m) / 2$ 大数就是我们要求的中位数.

先从简单情况入手，假设 $m, n \geq k/2$，我们先从 $nums1$ 和 $nums2$ 中各取前 $k/2$ 个元素：

- 如果 $nums1[k/2-1] > nums2[k/2-1]$，则说明 $nums1$ 中取的元素过多，$nums2$ 中取的元素过少；因此 $nums2$ 中的前 $k/2$ 个元素一定都小于等于第 $k$ 大数，所以我们可以先取出这些数，将问题归约成在剩下的数中找第 $k - \lfloor k/2 \rfloor​$ 大数.
- 如果 $nums1[k/2-1] \leq nums2[k/2-1]$，同理可说明 $nums1$ 中的前 $k/2$ 个元素一定都小于等于第 $k$ 大数，类似可将问题的规模减少一半.

现在考虑边界情况，如果 $m < k/2$，则我们从 $nums1$ 中取m个元素，从$nums2$ 中取 $k/2$ 个元素（由于 $k = (n + m) / 2$，因此 $m,n$ 不可能同时小于 $k/2$.）：

- 如果 $nums1[m-1] > nums2[k/2-1]$，则 $nums2$ 中的前 $k/2$ 个元素一定都小于等于第 $k$ 大数，我们可以将问题归约成在剩下的数中找第 $k - \lfloor k/2 \rfloor$ 大数.
- 如果 $nums1[m-1] \leq nums2[k/2-1]$，则 $nums1$ 中的所有元素一定都小于等于第 $k$ 大数，因此第k大数是 $nums2[k - m - 1]​$.

时间复杂度分析：$k = (m + n) / 2$，且每次递归 $k$ 的规模都减少一半，因此时间复杂度是 $O(log(m + n))$.

## 代码

```cpp
class Solution
{
  public:
    //在两个有序数组中找到第 k 大数，第一个数组从 i 开始选，第二个数组从 j 开始选
    int findKthNumber(vector<int> &nums1, int i, vector<int> &nums2, int j, int k)
    {
        if (nums1.size() - i > nums2.size() - j)
            return findKthNumber(nums2, j, nums1, i, k);
        if (nums1.size() == i)
            return nums2[j + k - 1];
        if (k == 1)
            return min(nums1[i], nums2[j]);
        int si = min(i + k / 2, int(nums1.size())), sj = j + k / 2;
        if (nums1[si - 1] > nums2[sj - 1])
            return findKthNumber(nums1, i, nums2, j + k / 2, k - k / 2);
        else
            return findKthNumber(nums1, si, nums2, j, k - (si - i));
    }
    double findMedianSortedArrays(vector<int> &nums1, vector<int> &nums2)
    {
        int n = nums1.size() + nums2.size();
        if (n & 1)
            return findKthNumber(nums1, 0, nums2, 0, n / 2 + 1);
        else
        {
            int l = findKthNumber(nums1, 0, nums2, 0, n / 2);
            int r = findKthNumber(nums1, 0, nums2, 0, n / 2 + 1);
            return (l + r) / 2.0;
        }
    }
};
```

