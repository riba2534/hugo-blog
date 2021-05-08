---
title: LeetCode 56 合并区间(贪心)
date: 2020-04-16T14:31:58+08:00
lastmod: 2020-04-16T14:31:58+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[合并区间](https://leetcode-cn.com/problems/merge-intervals/)

给出一个区间的集合，请合并所有重叠的区间。

**示例 1:**

```
输入: [[1,3],[2,6],[8,10],[15,18]]
输出: [[1,6],[8,10],[15,18]]
解释: 区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6].
```

**示例 2:**

```
输入: [[1,4],[4,5]]
输出: [[1,5]]
解释: 区间 [1,4] 和 [4,5] 可被视为重叠区间。
```

## 思路

一个小贪心，把区间按照左端点排序。初始值设置为第一个区间的左和右。

然后遍历排序好的区间，如果遍历到的区间左端点小于等于`r`，就扩展`r`，等到不满足条件时证明这个区间最多就包含这么多，继续下一个区间即可。

## 代码

```cpp
class Solution
{
public:
    static bool cmp(pair<int, int> a, pair<int, int> b)
    {
        return a.first < b.first;
    }
    vector<vector<int>> merge(vector<vector<int>> &intervals)
    {
        vector<vector<int>> ans;
        if (intervals.size() == 0)
            return ans;
        vector<pair<int, int>> v;
        for (auto interval : intervals)
            v.push_back({interval[0], interval[1]});
        sort(v.begin(), v.end(), cmp);
        auto [l, r] = v[0];
        for (int i = 1; i < v.size(); i++)
        {
            if (v[i].first <= r)
                r = max(r, v[i].second);
            else
            {
                ans.push_back({l, r});
                l = v[i].first;
                r = v[i].second;
            }
        }
        ans.push_back({l, r});
        return ans;
    }
};
```
