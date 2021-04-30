---
title: LeetCode 632 最小区间(贪心，堆)
date: 2020-08-03T01:50:13+08:00
lastmod: 2020-08-03T01:50:13+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[最小区间](https://leetcode-cn.com/problems/smallest-range-covering-elements-from-k-lists/)

你有 `k` 个升序排列的整数数组。找到一个**最小**区间，使得 `k` 个列表中的每个列表至少有一个数包含在其中。

我们定义如果 `b-a < d-c` 或者在 `b-a == d-c` 时 `a < c`，则区间 [a,b] 比 [c,d] 小。

**示例 1:**

```
输入:[[4,10,15,24,26], [0,9,12,20], [5,18,22,30]]
输出: [20,24]
解释: 
列表 1：[4, 10, 15, 24, 26]，24 在区间 [20,24] 中。
列表 2：[0, 9, 12, 20]，20 在区间 [20,24] 中。
列表 3：[5, 18, 22, 30]，22 在区间 [20,24] 中。
```

**注意:**

1. 给定的列表可能包含重复元素，所以在这里升序表示 >= 。
2. 1 <= `k` <= 3500
3. -105 <= `元素的值` <= 105
4. **对于使用Java的用户，请注意传入类型已修改为List<List<Integer>>。重置代码模板后可以看到这项改动。**

## 思路

题意可以等价转化为：从k个数组中每个数组中找出一个数，使得其中的最大值与最小值的差值最小。

那么为了得到这个数，我们必须每个数都考虑到，不能漏。对于这个k个数组，每一个数组维护一个指针，代表当前遍历的位置。最开始，每个数组的指针都指向第一个元素，则对于这些元素，当前的最优解就是其中最大值与最小值的差值，维护这一个最小差值。这一轮的决策完毕后，对于下一轮的决策，当前的最小值是没有用的，则抛弃当前最小值，把这个值所在的数组的下一个数加入决策。

利用一个最小堆维护，记录当前的数组编号与遍历位置，取元素时最小值出队，把该元素的下一个值入队，入队时更新最大值。之后更新差值，当把某一个数组遍历完之后，此时更新的最小差值就是答案，

## 代码

```cpp
class Solution
{
public:
    struct point
    {
        int row, pos, v;
    };
    friend bool operator<(point a, point b)
    {
        return a.v > b.v;
    }
    vector<int> smallestRange(vector<vector<int>> &nums)
    {
        int n = nums.size();
        priority_queue<point> q;
        int minn = 0, maxx = INT_MIN;
        int l = 0, r = INT_MAX;
        for (int i = 0; i < n; i++)
        {
            q.push(point{i, 0, nums[i][0]});
            maxx = max(maxx, nums[i][0]);
        }
        while (!q.empty())
        {
            point p = q.top();
            q.pop();
            minn = p.v;
            if (maxx - minn < r - l)
            {
                l = minn;
                r = maxx;
            }
            if (p.pos == nums[p.row].size() - 1)
                break;
            maxx = max(maxx, nums[p.row][p.pos + 1]);
            q.push(point{p.row, p.pos + 1, nums[p.row][p.pos + 1]});
        }
        return {l, r};
    }
};
```
