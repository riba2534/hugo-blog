---
title: LeetCode 491 递增子序列(枚举子集)
date: 2020-08-25T01:22:00+08:00
lastmod: 2020-08-25T01:23:07+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- 枚举子集
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[递增子序列](https://leetcode-cn.com/problems/increasing-subsequences/)

给定一个整型数组, 你的任务是找到所有该数组的递增子序列，递增子序列的长度至少是2。

**示例:**

```
输入: [4, 6, 7, 7]
输出: [[4, 6], [4, 7], [4, 6, 7], [4, 6, 7, 7], [6, 7], [6, 7, 7], [7,7], [4,7,7]]
```

**说明:**

1. 给定数组的长度不会超过15。
2. 数组中的整数范围是 [-100,100]。
3. 给定数组中可能包含重复数字，相等的数字应该被视为递增的一种情况。

## 思路

先看一眼数据范围，是15，猜一下复杂度，大概 $2^{15}$ 能过，应该就是二进制枚举子集了。

关于枚举子集，可以看我之前写的博客 ：[二进制枚举子集详解](https://blog.csdn.net/riba2534/article/details/79834558)

枚举子集可以求出，所有的组合方式。接下来我们只需要判断

- 这个序列是不是一个递增序列
- 去重

关于判断是否是一个递增序列，我们只需要找一个比较小的数 t ，其值一直跟随当前遍历的数的值，如果遍历到的数小于t，则这肯定是一个递减序列。

关于去重，可以用 `unordered_map` 做一个 `string` 的映射，比如现在有列表 `[1,12,-3,4]`，我们给每个数字加上分隔符，变成一个字符串 `1|12|-3|4`，将这个值进行映射，可以保证不重复。

## 代码

```cpp
class Solution
{
public:
    vector<vector<int>> findSubsequences(vector<int> &nums)
    {
        vector<vector<int>> ans;
        unordered_map<string, int> mp;
        int n = nums.size();
        if (!n)
            return ans;
        vector<int> tmp;
        for (int i = 0; i < (1 << n); i++)
        {
            tmp.clear();
            string s = "";
            int t = -200, flag = 1;
            for (int j = 0; j < n; j++)
                if (i & (1 << j))
                {
                    if (nums[j] < t)
                    {
                        flag = 0;
                        break;
                    }
                    t = nums[j];
                    tmp.push_back(nums[j]);
                    s = s + to_string(nums[j]) + "|";
                }
            if (flag && tmp.size() >= 2 && !mp[s])
            {
                ans.push_back(tmp);
                mp[s]++;
            }
        }
        return ans;
    }
};
```

