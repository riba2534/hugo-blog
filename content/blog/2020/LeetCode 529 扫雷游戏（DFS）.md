---
title: LeetCode 529 扫雷游戏（DFS）
date: 2020-08-20T01:59:22+08:00
lastmod: 2020-08-20T01:59:22+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- dfs
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[扫雷游戏](https://leetcode-cn.com/problems/minesweeper/)

让我们一起来玩扫雷游戏！

给定一个代表游戏板的二维字符矩阵。 **'M'** 代表一个**未挖出的**地雷，**'E'** 代表一个**未挖出的**空方块，**'B'** 代表没有相邻（上，下，左，右，和所有4个对角线）地雷的**已挖出的**空白方块，**数字**（'1' 到 '8'）表示有多少地雷与这块**已挖出的**方块相邻，**'X'** 则表示一个**已挖出的**地雷。

现在给出在所有**未挖出的**方块中（'M'或者'E'）的下一个点击位置（行和列索引），根据以下规则，返回相应位置被点击后对应的面板：

1. 如果一个地雷（'M'）被挖出，游戏就结束了- 把它改为 **'X'**。
2. 如果一个**没有相邻地雷**的空方块（'E'）被挖出，修改它为（'B'），并且所有和其相邻的**未挖出**方块都应该被递归地揭露。
3. 如果一个**至少与一个地雷相邻**的空方块（'E'）被挖出，修改它为数字（'1'到'8'），表示相邻地雷的数量。
4. 如果在此次点击中，若无更多方块可被揭露，则返回面板。

**示例 1：**

```
输入: 

[['E', 'E', 'E', 'E', 'E'],
 ['E', 'E', 'M', 'E', 'E'],
 ['E', 'E', 'E', 'E', 'E'],
 ['E', 'E', 'E', 'E', 'E']]

Click : [3,0]

输出: 

[['B', '1', 'E', '1', 'B'],
 ['B', '1', 'M', '1', 'B'],
 ['B', '1', '1', '1', 'B'],
 ['B', 'B', 'B', 'B', 'B']]

解释:
```

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/12/minesweeper_example_1.png)

**示例 2：**

```
输入: 

[['B', '1', 'E', '1', 'B'],
 ['B', '1', 'M', '1', 'B'],
 ['B', '1', '1', '1', 'B'],
 ['B', 'B', 'B', 'B', 'B']]

Click : [1,2]

输出: 

[['B', '1', 'E', '1', 'B'],
 ['B', '1', 'X', '1', 'B'],
 ['B', '1', '1', '1', 'B'],
 ['B', 'B', 'B', 'B', 'B']]

解释:
```

![](https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/10/12/minesweeper_example_2.png)

**注意：**

1. 输入矩阵的宽和高的范围为 [1,50]。
2. 点击的位置只能是未被挖出的方块 ('M' 或者 'E')，这也意味着面板至少包含一个可点击的方块。
3. 输入面板不会是游戏结束的状态（即有地雷已被挖出）。
4. 简单起见，未提及的规则在这个问题中可被忽略。例如，当游戏结束时你不需要挖出所有地雷，考虑所有你可能赢得游戏或标记方块的情况。

## 思路

直接 `DFS` 即可，需要注意：

- 题目给的数据中，可能包含 `M`、`E`、`B`、数字
- 首先数一下将要点击的点的周围有几个地雷，如果地雷的数量大于0，则这个点不向外扩展（向外递归扩展的条件是当前的点是 `B`），把当前点改为对应的地雷数量
- 如果当前点的周围没有地雷，则把当前的点变为 `B`，再递归的把当前位置周围的所有 `E` 进行搜索。

## 代码

```cpp
class Solution
{
public:
    int n, m;
    int go[8][2] = {0, 1, 0, -1, -1, 0, 1, 0, -1, 1, 1, 1, -1, -1, 1, -1};
    void dfs(vector<vector<char>> &board, int x, int y)
    {
        int cnt = 0;
        for (int i = 0; i < 8; i++)
        {
            int xx = x + go[i][0];
            int yy = y + go[i][1];
            if (xx >= 0 && xx < n && yy >= 0 && yy < m && board[xx][yy] == 'M')
                cnt++;
        }
        if (cnt)
        {
            board[x][y] = '0' + cnt;
            return;
        }
        board[x][y] = 'B';
        for (int i = 0; i < 8; i++)
        {
            int xx = x + go[i][0];
            int yy = y + go[i][1];
            if (xx >= 0 && xx < n && yy >= 0 && yy < m && board[xx][yy] == 'E')
                dfs(board, xx, yy);
        }
    }
    vector<vector<char>> updateBoard(vector<vector<char>> &board, vector<int> &click)
    {
        n = board.size(), m = board[0].size();
        int cx = click[0], cy = click[1];
        if (board[cx][cy] == 'M')
        {
            board[cx][cy] = 'X';
            return board;
        }
        dfs(board, cx, cy);
        return board;
    }
};
```
