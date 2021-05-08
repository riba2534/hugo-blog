---
title: LeetCode 1095 山脉数组中查找目标值(二分)
date: 2020-04-29T01:42:19+08:00
lastmod: 2020-04-29T01:42:19+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[山脉数组中查找目标值](https://leetcode-cn.com/problems/find-in-mountain-array/)

（这是一个 **交互式问题** ）

给你一个 **山脉数组** `mountainArr`，请你返回能够使得 `mountainArr.get(index)` **等于** `target` **最小** 的下标 `index` 值。

如果不存在这样的下标 `index`，就请返回 `-1`。

何为山脉数组？如果数组 `A` 是一个山脉数组的话，那它满足如下条件：

**首先**，`A.length >= 3`

**其次**，在 `0 < i < A.length - 1` 条件下，存在 `i` 使得：

- `A[0] < A[1] < ... A[i-1] < A[i]`
- `A[i] > A[i+1] > ... > A[A.length - 1]`

你将 **不能直接访问该山脉数组**，必须通过 `MountainArray` 接口来获取数据：

- `MountainArray.get(k)` - 会返回数组中索引为`k` 的元素（下标从 0 开始）
- `MountainArray.length()` - 会返回该数组的长度

**注意：**

对 `MountainArray.get` 发起超过 `100` 次调用的提交将被视为错误答案。此外，任何试图规避判题系统的解决方案都将会导致比赛资格被取消。

为了帮助大家更好地理解交互式问题，我们准备了一个样例 “**答案**”：https://leetcode-cn.com/playground/RKhe3ave，请注意这 **不是一个正确答案**。

**示例 1：**

```
输入：array = [1,2,3,4,5,3,1], target = 3
输出：2
解释：3 在数组中出现了两次，下标分别为 2 和 5，我们返回最小的下标 2。
```

**示例 2：**

```
输入：array = [0,1,2,4,2,1], target = 3
输出：-1
解释：3 在数组中没有出现，返回 -1。 
```

**提示：**

- `3 <= mountain_arr.length() <= 10000`
- `0 <= target <= 10^9`
- `0 <= mountain_arr.get(index) <= 10^9`

## 思路

不用管此题是否为交互题，此题交互的点是不直接给你给数组，而是给你个函数让你自己求。

总体的思路看数据范围肯定时间复杂度是log级别的。

我们先根据山脉数组特点求出山顶的值，然后此时就会变成两个序列，一个递增，一个递减，分别二分找即可。

如何寻找山顶元素的值的，在二分出一个 `mid` 值时，如果 `nums[mid]<nums[mid+1]` 时代表此时序列还在递增的过程，需要向右找，则`l=mid+1`，如果不是，则证明此时是序列的递减过程，向左找 `r=mid`。最后找到山顶元素的值。

## 代码

```cpp
#include <bits/stdc++.h>
using namespace std;

class MountainArray
{
private:
    vector<int> v;

public:
    int get(int index)
    {
        return v[index];
    }
    int length()
    {
        return v.size();
    }
    MountainArray(vector<int> nums)
    {
        v = nums;
    }
};

class Solution
{
public:
    int findReverseArray(MountainArray &mountainArr, int l, int r, int target)
    {
        while (l < r)
        {
            // 防止两个元素的情况，下取整改成上取整
            int mid = l + (r - l + 1) / 2;
            if (mountainArr.get(mid) < target)
                r = mid - 1;
            else
                l = mid;
        }
        if (mountainArr.get(l) == target)
            return l;
        return -1;
    }
    int findSortedArray(MountainArray &mountainArr, int l, int r, int target)
    {
        while (l < r)
        {
            int mid = l + (r - l) / 2;
            if (mountainArr.get(mid) < target)
                l = mid + 1;
            else
                r = mid;
        }
        if (mountainArr.get(l) == target)
            return l;
        return -1;
    }
    int findMountainTop(MountainArray &mountainArr, int l, int r)
    {
        while (l < r)
        {
            int mid = l + (r - l) / 2;
            // 当前处于递增序列中
            if (mountainArr.get(mid) < mountainArr.get(mid + 1))
                l = mid + 1;
            else
                r = mid;
        }
        // 此时一定l==r
        return l;
    }
    int findInMountainArray(int target, MountainArray &mountainArr)
    {
        int n = mountainArr.length();
        // 找山顶元素
        int peakIndex = findMountainTop(mountainArr, 0, n - 1);
        // 在递增序列中找
        int res = findSortedArray(mountainArr, 0, peakIndex, target);
        if (res != -1)
            return res;
        // 在递减序列中找
        return findReverseArray(mountainArr, peakIndex + 1, n - 1, target);
    }
};

int main()
{
    Solution ac;
    vector<int> nums{1, 2, 3, 4, 5, 3, 1};
    MountainArray m = MountainArray(nums);
    cout << ac.findInMountainArray(3, m) << endl;

    return 0;
}
```
