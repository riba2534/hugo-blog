---
title: LeetCode 327 区间和的个数（树状数组、线段树）
date: 2020-11-07T16:41:38+08:00
lastmod: 2020-11-07T16:41:38+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[区间和的个数](https://leetcode-cn.com/problems/count-of-range-sum/)

给定一个整数数组 `nums`，返回区间和在 `[lower, upper]` 之间的个数，包含 `lower` 和 `upper`。
区间和 `S(i, j)` 表示在 `nums` 中，位置从 `i` 到 `j` 的元素之和，包含 `i` 和 `j` (`i` ≤ `j`)。

**说明:**
最直观的算法复杂度是 *O*(*n*2) ，请在此基础上优化你的算法。

**示例:**

```
输入: nums = [-2,5,-1], lower = -2, upper = 2,
输出: 3 
解释: 3个区间分别是: [0,0], [2,2], [0,2]，它们表示的和分别为: -2, -1, 2。
```

## 思路

(树状数组) $O(nlogn)$

这道题一个很直观的做法就是记录前缀和，然后使用双层循环遍历所有的区间，时间复杂度$O(n^2)$。我们考虑如何来优化这个这个双层循环，我们在固定子数组的右边界的时候，采用遍历的方式求出所有区间和在`[lower,upper]`之间的数组个数，我们可以以更优的方式求解所有可行的区间。假设右区间为`A[j]`，前缀和为`preSum[j]`，其实我们需要求的是所有`preSum[j] - upper <= preSum[i] <= preSum[j] - lower(i<j)`的个数。求某一个区间内的个数，我们可以使用树状数组或者线段树来求解。

我们每次读到一个数，先把合法区间内前缀和的个数求出来（区间查询），然后将当前前缀和出现的次数加上一（单点更新）。因为只需要上面两个操作，所以可以使用树状数组来减少代码难度。整体代码思路如下：

1. 求出数组的前缀和数组（包括0），并将前缀和数组离散化。
2. 使用三个哈希表，分别记录每一个前缀和离散化后的大小，以该数字为右边界对应的左边界前缀和的区间`[preSum[j] - upper,preSum[j] - lower]`对应的区间左右端点离散化后的值。

`lower_bound`查找大于等于`preSum[j] - upper`最小值对应的下标；

`upper_bound`查找大于`preSum[j] - lower` 最小值对应的下标；

1. 先将`0`对应的位置加上1（表示一个元素都没有）
2. 然后遍历所有的前缀和，执行区间查询和单点更新操作。

时间复杂度：排序、离散化和树状数组的时间复杂度都是$O(nlogn)$。

## 代码

```cpp
class Solution
{
public:
    vector<int> tree;
    int n, m;
    inline int lowbit(int x)
    {
        return x & (-x);
    }
    void update(int idx, int delta)
    {
        while (idx <= m)
        {
            tree[idx] += delta;
            idx += lowbit(idx);
        }
    }
    int rangeSum(int l, int r)
    {
        //lower_bound/upper_bound找不到合法解是就是m + 1,所以直接返回0。
        if (l == m + 1 || r == m + 1)
            return 0;
        int res = 0;
        while (l != r)
        {
            res += tree[r] - tree[l];
            r -= lowbit(r);
            l -= lowbit(l);
        }
        return res;
    }
    int countRangeSum(vector<int> &nums, int lower, int upper)
    {
        n = nums.size();
        if (n == 0)
            return 0;
        vector<long long> preSum(n + 1, 0);
        unordered_map<int, int> hash, hash_lower, hash_upper;
        for (int i = 0; i < n; i++)
            preSum[i + 1] = preSum[i] + nums[i];
        vector<long long> temp = preSum;
        sort(temp.begin(), temp.end());
        temp.erase(unique(temp.begin(), temp.end()), temp.end());
        m = temp.size();
        tree = vector<int>(m + 1, 0);
        //这里需要注意一下下标，在temp数组中下标是`0～m-1`，但是为了和树状数组对应我们需要转化成`1~m`
        //所以hash就加上了1。假设合法的区间是`[L,R]`，
        //lower_bound找到的是大于等于L最小值的下标idx，加上1之后是`idx + 1`，但是在求区间和的时候，我们需要求的是左端点前面那个元素对应的前缀和，此时又要减去1。所以hash_lower就不变了。
        //upper_bound找到的是大于R的第一个元素下标，也恰好是R对应的下标idx加上1之后的结果，所以治理hash_upper也不变了。
        for (int i = 0; i < m; i++)
        {
            hash[temp[i]] = i + 1;
            hash_lower[temp[i]] = lower_bound(temp.begin(), temp.end(), temp[i] - upper) - temp.begin();
            hash_upper[temp[i]] = upper_bound(temp.begin(), temp.end(), temp[i] - lower) - temp.begin();
        }
        int res = 0;
        update(hash[0], 1);
        for (int i = 1; i <= n; i++)
        {
            res += rangeSum(hash_lower[preSum[i]], hash_upper[preSum[i]]);
            update(hash[preSum[i]], 1);
        }
        return res;
    }
};
```

