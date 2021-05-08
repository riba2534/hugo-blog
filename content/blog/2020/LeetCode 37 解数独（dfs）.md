---
title: LeetCode 37 解数独（dfs）
date: 2020-09-15T00:53:33+08:00
lastmod: 2020-09-15T00:53:33+08:00
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

题目链接：[解数独](https://leetcode-cn.com/problems/sudoku-solver/)

编写一个程序，通过已填充的空格来解决数独问题。

一个数独的解法需**遵循如下规则**：

1. 数字 `1-9` 在每一行只能出现一次。
2. 数字 `1-9` 在每一列只能出现一次。
3. 数字 `1-9` 在每一个以粗实线分隔的 `3x3` 宫内只能出现一次。

空白格用 `'.'` 表示。

![img](https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20200915004540.png)

一个数独。

![img](https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20200915004540.png)

答案被标成红色。

**Note:**

- 给定的数独序列只包含数字 `1-9` 和字符 `'.'` 。
- 你可以假设给定的数独只有唯一解。
- 给定数独永远是 `9x9` 形式的。

## 思路

经典的解数独游戏。

首先记录下来所有的需要填数字的坐标信息，然后从第一个需要填数的地方开始填数，依次判断数字 `1-9` ，当前位置是否可以填数，可以的话填数，继续搜索下一层，最后回溯的时候需要取消填数继续试。如果找到答案，就记录一下，这里可以剪枝。

要判断一个地方能不能填数字，要满足：

- 这一行中有没有相同数字
- 这一列中有没有相同数字
- 当前的小9宫格中，有没有相同数字（对当前坐标`*3`和`/3`的操作是为了确定当前小九宫格的起始点坐标）

如果满足这个条件，证明这个地方可以填数。

具体看代码

## 代码

```cpp
class Solution
{
public:
    vector<pair<int, int>> point;
    vector<vector<char>> ans;
    bool flag;
    bool check(vector<vector<char>> &board, int k, int step)
    {
        for (int i = 0; i < 9; i++)
            if (board[point[step].first][i] - '0' == k || board[i][point[step].second] - '0' == k)
                return false;
        // 计算当前所在的小九宫格坐标
        int x = (point[step].first / 3) * 3;
        int y = (point[step].second / 3) * 3;
        for (int i = x; i < x + 3; i++)
            for (int j = y; j < y + 3; j++)
                if (board[i][j] - '0' == k)
                    return false;
        return true;
    }
    void dfs(vector<vector<char>> &board, int step)
    {
        if (flag)
            return;
        if (step == point.size())
        {
            flag = true;
            ans = board;
            return;
        }
        for (int i = 1; i <= 9; i++)
        {
            if (check(board, i, step))
            {
                board[point[step].first][point[step].second] = i + '0';
                dfs(board, step + 1);
                board[point[step].first][point[step].second] = '.';
            }
        }
    }
    void solveSudoku(vector<vector<char>> &board)
    {
        flag = false;
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++)
                if (board[i][j] == '.')
                    point.push_back({i, j});
        dfs(board, 0);
        board = ans;
    }
};
```

