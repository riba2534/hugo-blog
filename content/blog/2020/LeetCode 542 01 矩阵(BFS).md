---
title: LeetCode 542 01 矩阵(BFS)
date: 2020-04-15T11:44:49+08:00
lastmod: 2020-04-15T11:44:49+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[01 矩阵](https://leetcode-cn.com/problems/01-matrix/)

给定一个由 0 和 1 组成的矩阵，找出每个元素到最近的 0 的距离。

两个相邻元素间的距离为 1 。

**示例 1:**
输入:

```
0 0 0
0 1 0
0 0 0
```

输出:

```
0 0 0
0 1 0
0 0 0
```

**示例 2:**
输入:

```
0 0 0
0 1 0
1 1 1
```

输出:

```
0 0 0
0 1 0
1 2 1
```

**注意:**

1. 给定矩阵的元素个数不超过 10000。
2. 给定矩阵中至少有一个元素是 0。
3. 矩阵中的元素只在四个方向上相邻: 上、下、左、右。

## 思路

广搜BFS，和 1162 地图分析有点像，题目要求出每个元素与0最近的距离是多少，那么不用问，肯定值为0的点的距离还是0，其余的可以搜出来。

首先把值为0的坐标全部入队，像四个方向搜索，如果是1，当前的步数就+1，如果是0，那步数不变，只需要在搜索的时候，一直给答案的距离与当前步数取最小值即可。

## 代码

```cpp
class Solution
{
public:
    struct node
    {
        int x, y, step;
    };
    int go[4][2] = {1, 0, -1, 0, 0, 1, 0, -1};
    vector<vector<int>> updateMatrix(vector<vector<int>> &matrix)
    {
        int n = matrix.size(), m = matrix[0].size();
        vector<vector<int>> result(n, vector<int>(m, 99999));
        vector<vector<int>> vis(n + 1, vector<int>(m + 1, 0));
        queue<node> q;
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                if (matrix[i][j] == 0)
                {
                    q.push({i, j, 0});
                    vis[i][j] = 1;
                }
        while (!q.empty())
        {
            node now = q.front();
            q.pop();
            result[now.x][now.y] = min(result[now.x][now.y], now.step);
            for (int i = 0; i < 4; i++)
            {
                int xx = now.x + go[i][0];
                int yy = now.y + go[i][1];
                if (xx >= 0 && xx < n && yy >= 0 && yy < m && !vis[xx][yy])
                {
                    if (matrix[xx][yy] == 1)
                        q.push({xx, yy, now.step + 1});
                    else
                        q.push({xx, yy, now.step});
                    vis[xx][yy] = 1;
                }
            }
        }
        return result;
    }
};
```

