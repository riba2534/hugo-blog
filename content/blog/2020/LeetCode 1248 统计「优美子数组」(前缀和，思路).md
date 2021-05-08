---
title: LeetCode 1248 统计「优美子数组」(前缀和，思路)
date: 2020-04-21T11:06:37+08:00
lastmod: 2020-04-21T11:06:37+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[统计「优美子数组」](https://leetcode-cn.com/problems/count-number-of-nice-subarrays/)

给你一个整数数组 `nums` 和一个整数 `k`。

如果某个 **连续** 子数组中恰好有 `k` 个奇数数字，我们就认为这个子数组是「**优美子数组**」。

请返回这个数组中「优美子数组」的数目。

 

**示例 1：**

```
输入：nums = [1,1,2,1,1], k = 3
输出：2
解释：包含 3 个奇数的子数组是 [1,1,2,1] 和 [1,2,1,1] 。
```

**示例 2：**

```
输入：nums = [2,4,6], k = 1
输出：0
解释：数列中不包含任何奇数，所以不存在优美子数组。
```

**示例 3：**

```
输入：nums = [2,2,2,1,2,2,1,2,2,2], k = 2
输出：16
```

 

**提示：**

- `1 <= nums.length <= 50000`
- `1 <= nums[i] <= 10^5`
- `1 <= k <= nums.length`

## 思路

根据题意，偶数是没有用的，先预处理一下，通过 `nums[i]&1` 的方式处理成01字符串，题目就变成了有多少个子数组的区间和为`k`，假设要统计区间$[l,r]$中的区间和为`k`的数量，我们先对数组求一个前缀和，易得：$sum[r]-sum[l-1]=k$，移项得：$sum[l-1]=sum[r]-k$，其中`k`是题目中已经给出的，`sum[r]`是当前求的前缀和的那一项，所以我们只需要累加`sum[l-1]`的个数即可。用一个哈希存一下前缀和的个数，求前缀和时因为满足`l<r`，所以不需要开数组，一直累加即可。

和560题一模一样。

## 代码

```cpp
class Solution
{
public:
    int numberOfSubarrays(vector<int> &nums, int k)
    {
        unordered_map<long long, int> mp;
        mp[0] = 1;
        int sum = 0, ans = 0;
        for (int i = 1; i <= nums.size(); i++)
        {
            sum += nums[i - 1] & 1;
            ans += mp[sum - k];
            mp[sum]++;
        }
        return ans;
    }
};
```



