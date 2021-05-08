---
title: LeetCode 207 课程表(拓扑排序)
date: 2020-08-04T01:19:39+08:00
lastmod: 2020-08-04T01:19:39+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
- 拓扑排序
categories: OnlineJudge刷题
comment: true

---

题目链接：[课程表](https://leetcode-cn.com/problems/course-schedule/)

你这个学期必须选修 `numCourse` 门课程，记为 `0` 到 `numCourse-1` 。

在选修某些课程之前需要一些先修课程。 例如，想要学习课程 0 ，你需要先完成课程 1 ，我们用一个匹配来表示他们：`[0,1]`

给定课程总量以及它们的先决条件，请你判断是否可能完成所有课程的学习？

**示例 1:**

```
输入: 2, [[1,0]] 
输出: true
解释: 总共有 2 门课程。学习课程 1 之前，你需要完成课程 0。所以这是可能的。
```

**示例 2:**

```
输入: 2, [[1,0],[0,1]]
输出: false
解释: 总共有 2 门课程。学习课程 1 之前，你需要先完成课程 0；并且学习课程 0 之前，你还应先完成课程 1。这是不可能的。
```

**提示：**

1. 输入的先决条件是由 **边缘列表** 表示的图形，而不是 邻接矩阵 。详情请参见[图的表示法](http://blog.csdn.net/woaidapaopao/article/details/51732947)。
2. 你可以假定输入的先决条件中没有重复的边。
3. `1 <= numCourses <= 10^5`

## 思路

这种有先决顺序的工程安排问题一般就是**拓扑排序**，这道题是拓扑排序的裸题。

方法1：删入度，bfs

拓扑排序有一个显然的算法，**每次删除有向无环图中的入度为0的点，直到没有入度为0的点为止**。因为如果存在环，则一个点必将同时有入度和出度。

所以这个算法在实现的时候可以使用一个队列，每次把入度为0的点加入队列中，然后遍历这个点所有的出边，并删除掉这个点的入度。如果点的进队次数等于点数，则证明此图无环。

方法2：深搜

每一个点开始进行深搜，如果搜到了自己，则存在环。

不存在环时再搜的过程中需要标记路线。

## 代码

bfs删入度：

```cpp
class Solution
{
public:
    bool canFinish(int numCourses, vector<vector<int>> &prerequisites)
    {
        vector<vector<int>> e(numCourses);
        vector<int> in(numCourses, 0);
        for (auto point : prerequisites)
        {
            int u = point[0], v = point[1];
            e[u].push_back(v);
            in[v]++;
        }
        queue<int> q;
        for (int i = 0; i < numCourses; i++)
            if (!in[i])
                q.push(i);
        int cnt = 0;
        while (!q.empty())
        {
            cnt++;
            int u = q.front();
            q.pop();
            for (auto v : e[u])
                if (!--in[v])
                    q.push(v);
        }
        return cnt == numCourses;
    }
};
```

dfs:

```cpp
class Solution
{
public:
    vector<int> vis;
    int dfs(int u, vector<vector<int>> &e)
    {
        vis[u] = -1;
        for (auto v : e[u])
        {
            if (vis[v] == -1)
                return 0;
            else if (!vis[v] && !dfs(v, e))
                return 0;
        }
        vis[u] = 1;
        return 1;
    }
    bool canFinish(int numCourses, vector<vector<int>> &prerequisites)
    {
        vector<vector<int>> e(numCourses);
        vis = vector<int>(numCourses, 0);
        for (auto point : prerequisites)
        {
            int u = point[0], v = point[1];
            e[u].push_back(v);
        }
        for (int u = 0; u < numCourses; u++)
            if (!vis[u])
                if (!dfs(u, e))
                    return false;
        return true;
    }
};

```
