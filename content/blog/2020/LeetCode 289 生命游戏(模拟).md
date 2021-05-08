---
title: LeetCode 289 生命游戏(模拟)
date: 2020-04-02T14:40:49+08:00
lastmod: 2020-04-02T14:40:49+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[生命游戏](https://leetcode-cn.com/problems/game-of-life/)

根据 `百度百科` ，生命游戏，简称为生命，是英国数学家约翰·何顿·康威在 1970 年发明的细胞自动机。

给定一个包含 `m × n` 个格子的面板，每一个格子都可以看成是一个细胞。每个细胞都具有一个初始状态：`1` 即为活细胞（live），或 `0` 即为死细胞（dead）。每个细胞与其八个相邻位置（水平，垂直，对角线）的细胞都遵循以下四条生存定律：

1. 如果活细胞周围八个位置的活细胞数少于两个，则该位置活细胞死亡；
2. 如果活细胞周围八个位置有两个或三个活细胞，则该位置活细胞仍然存活；
3. 如果活细胞周围八个位置有超过三个活细胞，则该位置活细胞死亡；
4. 如果死细胞周围正好有三个活细胞，则该位置死细胞复活；

根据当前状态，写一个函数来计算面板上所有细胞的下一个（一次更新后的）状态。下一个状态是通过将上述规则同时应用于当前状态下的每个细胞所形成的，其中细胞的出生和死亡是同时发生的。

示例：

输入： 
```
[
  [0,1,0],
  [0,0,1],
  [1,1,1],
  [0,0,0]
]
```
输出：
```
[
  [0,0,0],
  [1,0,1],
  [0,1,1],
  [0,1,0]
]
```

进阶：

你可以使用原地算法解决本题吗？请注意，面板上所有格子需要同时被更新：你不能先更新某些格子，然后使用它们的更新后的值再更新其他格子。
本题中，我们使用二维数组来表示面板。原则上，面板是无限的，但当活细胞侵占了面板边界时会造成问题。你将如何解决这些问题？

## 思路

中文题意，刚开始看到题以为是个搜索之类的，用手推了一下样例。发现一个格子的状态改变不会，以后的格子计算状态还是按照格子上原来的数字计算状态的，所以问题就非常简单了，把原数组复制一遍，计算八个方向的活细胞的数量，直接按照题意改一下活细胞或死细胞状态即可，最后用复制出来的数组覆盖原数组。

或者也可以不复制数组，直接在原数组上做一些标记也可以实现。

## 代码

```cpp
class Solution
{
public:
    int go[8][2] = {1, 0, -1, 0, 0, 1, 0, -1, 1, 1, 1, -1, -1, 1, -1, -1};
    void gameOfLife(vector<vector<int>> &board)
    {
        vector<vector<int>> grid = board;
        int n = board.size(), m = board[0].size();
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                int cnt1 = 0;
                for (int p = 0; p < 8; p++)
                {
                    int xx = i + go[p][0];
                    int yy = j + go[p][1];
                    if (xx >= 0 && xx < n && yy >= 0 && yy < m)
                        if (board[xx][yy] == 1)
                            cnt1++;
                }
                if (board[i][j] == 1)
                {
                    if (cnt1 < 2 || cnt1 > 3)
                        grid[i][j] = 0;
                }
                else
                {
                    if (cnt1 == 3)
                        grid[i][j] = 1;
                }
            }
        }
        board = grid;
    }
};
```

golang:

```go
func gameOfLife(board [][]int) {
	vis := [8][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}}
	grid := [][]int{}
	n := len(board)
	m := len(board[0])
	for i := 0; i < n; i++ {
		row := []int{}
		for j := 0; j < m; j++ {
			row = append(row, board[i][j])
		}
		grid = append(grid, row)
	}
	for i := 0; i < n; i++ {
		for j := 0; j < m; j++ {
			cnt1 := 0
			for p := 0; p < 8; p++ {
				xx := i + vis[p][0]
				yy := j + vis[p][1]
				if xx >= 0 && xx < n && yy >= 0 && yy < m {
					if board[xx][yy] == 1 {
						cnt1++
					}
				}
			}
			if board[i][j] == 1 {
				if cnt1 < 2 || cnt1 > 3 {
					grid[i][j] = 0
				}
			} else {
				if cnt1 == 3 {
					grid[i][j] = 1
				}
			}
		}
	}
	for i := 0; i < n; i++ {
		for j := 0; j < m; j++ {
			board[i][j] = grid[i][j]
		}
	}
}
```
