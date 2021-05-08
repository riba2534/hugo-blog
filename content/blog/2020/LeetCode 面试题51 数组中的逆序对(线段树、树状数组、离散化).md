---
title: LeetCode 面试题51 数组中的逆序对(线段树+树状数组+离散化)
date: 2020-04-24T02:40:25+08:00
lastmod: 2020-04-24T02:40:25+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[数组中的逆序对](https://leetcode-cn.com/problems/shu-zu-zhong-de-ni-xu-dui-lcof/)

在数组中的两个数字，如果前面一个数字大于后面的数字，则这两个数字组成一个逆序对。输入一个数组，求出这个数组中的逆序对的总数。

**示例 1:**

```
输入: [7,5,6,4]
输出: 5
```

**限制：**

```
0 <= 数组长度 <= 50000
```

## 思路

逆序数的定义，题目已经给出。我们的核心诉求就是，**对于每一项`nums[i]`，求出在这个数之前，比它大的数的个数，累加起来就是答案**。我们考虑如何解决这个问题。

由于只给出了数字的数量，没有给出数字的大小范围，所以先用离散化处理一下，保证所有数的区间都在`[1,50000]`内。

方法1：线段树

首先此题可以用一个线段树来维护，线段树的功能是区间求和。依次遍历数组，先求出当前线段树中，大于当前遍历的`nums[i]`的数的个数，然后再把当前的数更新到线段树上去（为了保证线段树上的数都是遍历的数之前的），让树上的这个点加一，然后累加起来就是答案。

方法2：树状数组

顺着这个思路，我们可以同样考虑一下用树状数组来实现，离散化不用说。首先，要知道树状数组的功能是啥，功能是：单点更新，可以求出`[1,n]`的和。那么这个性质如何在逆序数中使用呢？考虑，数字的数量是固定的，对于当前遍历到的`nums[i]`，可以求出`[1,num[i]]`的和，代表`比nums[i]小的数有多少个`，那么`i-sum(1,nums[i])`就求出了它之前比它大的有多少个。同样也是边遍历边更新。

## 代码

线段树：

```cpp
class Solution
{
public:
    int sum[4 * 50001];
    void pushup(int rt)
    {
        sum[rt] = sum[rt << 1] + sum[rt << 1 | 1];
    }
    void build(int l, int r, int rt)
    {
        sum[rt] = 0;
        if (l == r)
            return;
        int m = (l + r) >> 1;
        build(l, m, rt << 1);
        build(m + 1, r, rt << 1 | 1);
    }
    void update(int p, int l, int r, int rt)
    {
        if (l == r)
        {
            sum[rt]++;
            return;
        }
        int m = (l + r) >> 1;
        if (p <= m)
            update(p, l, m, rt << 1);
        else
            update(p, m + 1, r, rt << 1 | 1);
        pushup(rt);
    }
    int query(int L, int R, int l, int r, int rt)
    {
        if (L <= l && r <= R)
        {
            return sum[rt];
        }
        int m = (l + r) >> 1;
        int ret = 0;
        if (L <= m)
            ret += query(L, R, l, m, rt << 1);
        if (R > m)
            ret += query(L, R, m + 1, r, rt << 1 | 1);
        return ret;
    }
    int reversePairs(vector<int> &nums)
    {
        if (nums.size() == 0)
            return 0;
        vector<int> temp(nums);
        sort(temp.begin(), temp.end());
        temp.erase(unique(temp.begin(), temp.end()), temp.end());
        build(1, temp.size(), 1);
        int cnt = 0;
        for (int i = 0; i < nums.size(); i++)
        {
            int l = lower_bound(temp.begin(), temp.end(), nums[i]) - temp.begin() + 1;
            int r = temp.size();
            cnt += query(l + 1, r, 1, r, 1);
            update(l, 1, r, 1);
        }
        return cnt;
    }
};
```

树状数组：

```cpp
class Solution
{
public:
    int c[50000 + 1], N;
    void init(int n)
    {
        memset(c, 0, sizeof(0));
        N = n;
    }
    int lowbit(int x)
    {
        return x & -x;
    }
    void add(int i, int k)
    {
        while (i <= N)
        {
            c[i] += k;
            i += lowbit(i);
        }
    }
    int sum(int n)
    {
        int sum = 0;
        while (n > 0)
        {
            sum += c[n];
            n -= lowbit(n);
        }
        return sum;
    }
    int reversePairs(vector<int> &nums)
    {
        if (nums.size() == 0)
            return 0;
        vector<int> temp(nums);
        sort(temp.begin(), temp.end());
        temp.erase(unique(temp.begin(), temp.end()), temp.end());
        init(temp.size());
        int cnt = 0;
        for (int i = 0; i < nums.size(); i++)
        {
            int x = lower_bound(temp.begin(), temp.end(), nums[i]) - temp.begin() + 1;
            add(x, 1);
            cnt += i + 1 - sum(x);
        }
        return cnt;
    }
};
```
