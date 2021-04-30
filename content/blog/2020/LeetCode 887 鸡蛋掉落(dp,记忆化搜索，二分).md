---
title: LeetCode 887 鸡蛋掉落(dp,记忆化搜索，二分)
date: 2020-04-11T15:59:00+08:00
lastmod: 2020-04-28T01:49:52+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[鸡蛋掉落](https://leetcode-cn.com/problems/super-egg-drop/)

你将获得 `K` 个鸡蛋，并可以使用一栋从 `1` 到 `N` 共有 `N` 层楼的建筑。

每个蛋的功能都是一样的，如果一个蛋碎了，你就不能再把它掉下去。

你知道存在楼层 `F` ，满足 `0 <= F <= N` 任何从高于 `F` 的楼层落下的鸡蛋都会碎，从 `F` 楼层或比它低的楼层落下的鸡蛋都不会破。

每次*移动*，你可以取一个鸡蛋（如果你有完整的鸡蛋）并把它从任一楼层 `X` 扔下（满足 `1 <= X <= N`）。

你的目标是**确切地**知道 `F` 的值是多少。

无论 `F` 的初始值如何，你确定 `F` 的值的最小移动次数是多少？

**示例 1：**

```
输入：K = 1, N = 2
输出：2
解释：
鸡蛋从 1 楼掉落。如果它碎了，我们肯定知道 F = 0 。
否则，鸡蛋从 2 楼掉落。如果它碎了，我们肯定知道 F = 1 。
如果它没碎，那么我们肯定知道 F = 2 。
因此，在最坏的情况下我们需要移动 2 次以确定 F 是多少。
```

**示例 2：**

```
输入：K = 2, N = 6
输出：3
```

**示例 3：**

```
输入：K = 3, N = 14
输出：4
```

**提示：**

1. `1 <= K <= 100`
2. `1 <= N <= 10000`

## 思路

两种方法：

### 方法一：记忆化搜索+二分

令`dp[t][n]`代表：有`t`层楼，`n`个鸡蛋，最少要扔多少次才可以确定临界值。现在定义一个`k (1<=k<=t)`，我们从第k层扔下去一个鸡蛋，如果鸡蛋碎了，我们就要往低一点的楼层去找，则当前`dp[t][n]`状态是`dp[k-1][n-1]+1`(k-1的原因是第k层已经扔过了)，如果鸡蛋没碎，我们要向上找，当前的状态`dp[t][n]`等价于`dp[t-k][n]+1`。

因为我们考虑的是最坏情况下找到鸡蛋的次数，所以状态转移方程为，$dp[t][n]=max(dp[k-1][n-1],dp[t-k][n])+1$

那么问题来了，我们还有一个`k`没有确定，`k`的取值范围是`(1<=k<=t)`，我们当然可以枚举一下所有的`k`，**然后在所有的k中取最小值(因为题目求的是最小移动次数)**，但是每次枚举全部的`k`，复杂度比较高$O(KN^2)$。

于是我们需要用二分来确定`k`，我们观察上面的状态转移方程：

- `dp[k-1][n-1]`,k增大的时候，楼层越高，则值越大
- `dp[t-k][n]`，k增大的时候，楼层越小，值越小

所以一个是单调递增的，另一个是单调递减的，所以我们要确定的k在他们的交汇点。也就是找到使得`dp[t-k][n]<=dp[t-1][n-1]`的最大的k。用了二分之后的时间复杂度降为：$O(KNlogN)$

## 方法二：dp

定义`dp[k][step]`代表由`k`个鸡蛋，通过移动`step`步所能到达的确定的最大楼层。则易得

- `dp[0][step]=0` : 0 个鸡蛋，不论走多少步，所能确定的最大楼层永远只是0
- `dp[k][1]=1` ：不论有多少个鸡蛋，如果之走一步，那么只能确定最大1层楼。
- `dp[1][step]=step`：只有一个鸡蛋时，能走到的最大楼层只能1层一层试，需要step次数。

根据以上条件，可以得到状态转移方程：

$$dp[k][step]=dp[k-1][step-1]+dp[k][step-1]+1$$

表示：当前楼层有k个鸡蛋，走了step步能确定的最大楼层数量是，丢了鸡蛋碎了走一步能确定的最大楼层(`dp[k-1][step-1]`)+丢了鸡蛋没碎走一步所能确定的最大楼层(`dp[k][step-1]`)+当前这一层丢了鸡蛋只能确定的层数1.时间复杂度为：$O(K*N)$

## 代码

方法一：记忆化搜索+二分

没用二分超时版：

```cpp
class Solution
{
public:
    // 返回有t层，n个鸡蛋的最小移动次数,k是枚举的中间楼层
    int dp[10000 + 50][100 + 50];
    int dfs(int t, int n)
    {
        if (~dp[t][n])
            return dp[t][n];
        if (t == 0 || n == 0)
            return 0;
        if (n == 1)
            return t;
        if (t == 1)
            return 1;
        int minn = INT_MAX;
        for (int k = 1; k <= t; k++)
        {
            minn = min(minn, max(dfs(k - 1, n - 1), dfs(t - k, n)) + 1);
        }
        return dp[t][n] = minn;
    }
    // K 代表鸡蛋个数，N 代表楼层数
    int superEggDrop(int K, int N)
    {
        memset(dp, -1, sizeof(dp));
        return dfs(N, K);
    }
};
```

把k二分后，AC版：

```cpp
class Solution
{
public:
    // 返回有t层，n个鸡蛋的最小移动次数,k是枚举的中间楼层
    int dp[10000 + 50][100 + 50];
    int dfs(int t, int n)
    {
        if (~dp[t][n])
            return dp[t][n];
        if (t == 0 || n == 0)
            return 0;
        if (n == 1)
            return t;
        if (t == 1)
            return 1;
        int l = 1, r = t;
        while (r - l > 1)
        {
            int mid = (l + r) >> 1;
            int ans1 = dfs(mid - 1, n - 1);
            int ans2 = dfs(t - mid, n);
            if (ans1 < ans2)
                l = mid;
            else if (ans1 > ans2)
                r = mid;
            else
                l = r = mid;
        }
        return dp[t][n] = 1 + min(max(dfs(l - 1, n - 1), dfs(t - l, n)),
                                  max(dfs(r - 1, n - 1), dfs(t - r, n)));
    }
    // K 代表鸡蛋个数，N 代表楼层数
    int superEggDrop(int K, int N)
    {
        memset(dp, -1, sizeof(dp));
        return dfs(N, K);
    }
};
```

方法二：dp

```cpp
class Solution
{
public:
    // K个鸡蛋，N层楼
    int superEggDrop(int K, int N)
    {
        // dp[k][step]表示给k个鸡蛋，移动step步所能达到的最大层数
        vector<vector<int>> dp(K + 1, vector<int>(N + 1, 0));
        for (int step = 1; step < N; step++)
        {
            dp[0][step] = 0;
            for (int k = 1; k <= K; k++)
            {
                dp[k][step] = dp[k][step - 1] + dp[k - 1][step - 1] + 1;
                if (dp[k][step] >= N)
                    return step;
            }
        }
        return N;
    }
};
```
