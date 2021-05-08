---
title: LeetCode 410 分割数组的最大值(二分,dp)
date: 2020-07-25T17:31:00+08:00
lastmod: 2020-07-25T18:17:39+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[分割数组的最大值](https://leetcode-cn.com/problems/split-array-largest-sum/)

给定一个非负整数数组和一个整数 *m*，你需要将这个数组分成 *m* 个非空的连续子数组。设计一个算法使得这 *m* 个子数组各自和的最大值最小。

**注意:**
数组长度 *n* 满足以下条件:

- 1 ≤ *n* ≤ 1000
- 1 ≤ *m* ≤ min(50, *n*)

**示例:**

```
输入:
nums = [7,2,5,10,8]
m = 2

输出:
18

解释:
一共有四种方法将nums分割为2个子数组。
其中最好的方式是将其分为[7,2,5] 和 [10,8]，
因为此时这两个子数组各自的和的最大值为18，在所有情况中最小。
```

## 思路

### 方案一：二分

枚举满足题意的**和的最大值**，每一次check按照贪心原则最大化分段，如果最后分段出来的段的数量大于0，代表右区间可以缩小，反之左区间增大。

时间复杂度：$O(n*log(sum-max_n))$

### 方案二：dp

定义 `dp[i][j]`表示把前$i$个数分成$j$段，所能达到的段内和的**最大值最小**的值。

则考虑第 `j`段的范围，可以枚举k，把第 `j`段分为：`[0,k]`和 `[k+1,j]`这两段，则 `dp[i][j]`的值就等于 `[0,k]`这一段的最优解的值与 `[k+1,j]`这一段的和的最大值，枚举k，使这个值最小即可，即：

$ dp[i][j] = min(dp[i][j], max(dp[k][j - 1], sub[i] - sub[k]))$

对于 `[k+1,j]`这一段的和，可以预处理出前缀和，直接做减法得到。

时间复杂度：$O(n^2m)$

## 代码

方案一：二分代码：

```cpp
class Solution
{
public:
    bool check(vector<int> &nums, int m, int target)
    {
        long long i = 0, sum = 0;
        while (i < nums.size())
        {
            if (nums[i] > target)
                return false;
            if (sum + nums[i] > target)
            {
                m--;
                sum = 0;
                continue;
            }
            sum += nums[i++];
        }
        if (m > 0)
            return true;
        return false;
    }
    int splitArray(vector<int> &nums, int m)
    {
        long long sum = 0;
        for (auto num : nums)
            sum += num;
        long long l = 0, r = sum;
        while (l < r)
        {
            long long mid = (l + r) >> 1;
            if (check(nums, m, mid))
                r = mid;
            else
                l = mid + 1;
        }
        return int(l);
    }
};
```

方案二：dp

```cpp
class Solution
{
public:
    int splitArray(vector<int> &nums, int m)
    {
        int n = nums.size();
        vector<long long> sub(n + 1, 0);
        // dp[i][j]表示把前i个数分成j段，所能达到的段内和的最大值最小
        vector<vector<long long>> dp(n + 1, vector<long long>(m + 1, LONG_LONG_MAX));
        for (int i = 1; i <= n; i++)
            sub[i] = sub[i - 1] + nums[i - 1];
        dp[0][0] = 0;
        // 分成了 [0,k]和[k+1,j]
        for (int i = 1; i <= n; i++)
            for (int j = 1; j <= min(i, m); j++)
                for (int k = 0; k < i; k++)
                    dp[i][j] = min(dp[i][j], max(dp[k][j - 1], sub[i] - sub[k]));
        return int(dp[n][m]);
    }
};
```
