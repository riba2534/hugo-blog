---
title: LeetCode 332 重新安排行程(输出欧拉路经)
date: 2020-08-27T02:00:55+08:00
lastmod: 2020-08-27T02:00:55+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[重新安排行程](https://leetcode-cn.com/problems/reconstruct-itinerary/)

给定一个机票的字符串二维数组 `[from, to]`，子数组中的两个成员分别表示飞机出发和降落的机场地点，对该行程进行重新规划排序。所有这些机票都属于一个从 JFK（肯尼迪国际机场）出发的先生，所以该行程必须从 JFK 开始。

**说明:**

1. 如果存在多种有效的行程，你可以按字符自然排序返回最小的行程组合。例如，行程 ["JFK", "LGA"] 与 ["JFK", "LGB"] 相比就更小，排序更靠前
2. 所有的机场都用三个大写字母表示（机场代码）。
3. 假定所有机票至少存在一种合理的行程。

**示例 1:**

```
输入: [["MUC", "LHR"], ["JFK", "MUC"], ["SFO", "SJC"], ["LHR", "SFO"]]
输出: ["JFK", "MUC", "LHR", "SFO", "SJC"]
```

**示例 2:**

```
输入: [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
输出: ["JFK","ATL","JFK","SFO","ATL","SFO"]
解释: 另一种有效的行程是 ["JFK","SFO","ATL","JFK","ATL","SFO"]。但是它自然排序更大更靠后。
```

## 思路

看到类似于「一笔画问题」，第一时间想到欧拉路。

- 通过图中所有边恰好一次且行遍所有顶点的通路称为欧拉通路。
- 通过图中所有边恰好一次且行遍所有顶点的回路称为欧拉回路。
- 具有欧拉回路的无向图称为欧拉图。
- 具有欧拉通路但不具有欧拉回路的无向图称为半欧拉图。

因为本题保证至少存在一种合理的路径，也就告诉了我们，这张图是一个欧拉图或者半欧拉图。我们只需要输出这条欧拉通路的路径即可。

所以我们可以直接从起点进行 `DFS`，然后但是要注意走过的边不能重复走，直到走完所有边最后就是答案。

官方题解的实现比较骚，没想到。

用了一个哈希到优先队列的映射，一个字符串映射一个最小堆，这样就可以根据贪心思路来保证字典序了。

搞一个栈存答案，因为是dfs从后网前回溯，所以答案是反着的，最后反转一下即可。

关于欧拉路的判断，可以看 [NYOJ42 一笔画问题(欧拉路+并查集)](https://blog.csdn.net/riba2534/article/details/53728084)

## 代码

```cpp
class Solution
{
public:
    unordered_map<string, priority_queue<string, vector<string>, greater<string>>> e;
    vector<string> stk;
    void dfs(string u)
    {
        while (!e[u].empty())
        {
            string v = e[u].top();
            e[u].pop();
            dfs(v);
        }
        stk.push_back(u);
    }
    vector<string> findItinerary(vector<vector<string>> &tickets)
    {
        for (vector<string> ticket : tickets)
            e[ticket[0]].push(ticket[1]);
        dfs("JFK");
        reverse(stk.begin(), stk.end());
        return stk;
    }
};
```

