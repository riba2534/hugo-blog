---
title: LeetCode 679 24 点游戏(暴力，递归)
date: 2020-08-22T01:57:03+08:00
lastmod: 2020-08-22T01:57:03+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- 递归
categories: OnlineJudge刷题
comment: true

---

题目链接：[24 点游戏](https://leetcode-cn.com/problems/24-game/)

你有 4 张写有 1 到 9 数字的牌。你需要判断是否能通过 `*`，`/`，`+`，`-`，`(`，`)` 的运算得到 24。

**示例 1:**

```
输入: [4, 1, 8, 7]
输出: True
解释: (8-4) * (7-1) = 24
```

**示例 2:**

```
输入: [1, 2, 1, 2]
输出: False
```

**注意:**

1. 除法运算符 `/` 表示实数除法，而不是整数除法。例如 4 / (1 - 2/3) = 12 。
2. 每个运算符对两个数进行运算。特别是我们不能用 `-` 作为一元运算符。例如，`[1, 1, 1, 1]` 作为输入时，表达式 `-1 - 1 - 1 - 1` 是不允许的。
3. 你不能将数字连接在一起。例如，输入为 `[1, 2, 1, 2]` 时，不能写成 12 + 12 。

## 思路

首先括号可以直接忽略掉，因为我们可以从数组中任意取数并组合。括号没啥用。

- 第一步：从 4 个数里面选 2 个数，为  $C_4^2$ ，4种运算符和两个数字，有8种可能，所以情况一共是：`6*8=48` 种
- 第二步：剩下的两个数和上一步生成的新数总共是3个数，所以 $C_3^2 \times 8=24$ 种
- 第三步：$C_2^2*8=8$ 种

则一共有 $48 \times 24 \times 8 = 9216$ 种情况。

由于加法和乘法具有交换律，则：$4$ 种运算符和 $2$ 个数字，只有 $6$ 种可能，所以一共的情况数量为：

$(C_4^2 \times 6) + (C_3^2 \times 6) + (C_2^2 \times 6) = 3888$ 种情况。

具体写法直接递归暴力即可。

需要注意，本题中除法是实数除法，则最后需要判断是否等于 $24$ ，用 `eps=1e-9` 来判断。

## 代码

```cpp
class Solution
{
public:
    vector<double> gen_num(vector<double> n, double num)
    {
        vector<double> new_nums = n;
        new_nums.push_back(num);
        return new_nums;
    }
    bool handler(vector<double> n)
    {
        if (n.size() == 1)
            return fabs(n[0] - 24) < (1e-9);

        bool result = false;
        for (int i = 0; i < n.size(); i++)
        {
            for (int j = i + 1; j < n.size(); j++)
            {
                vector<double> new_n, fin;
                for (int k = 0; k < n.size(); k++)
                    if (k != i && k != j)
                        new_n.push_back(n[k]);
                double x = n[i], y = n[j];
                result |= handler(gen_num(new_n, x + y));
                result |= handler(gen_num(new_n, x - y));
                result |= handler(gen_num(new_n, y - x));
                result |= handler(gen_num(new_n, x * y));
                if (fabs(y) > 1e-8)
                    result |= handler(gen_num(new_n, x / y));
                if (fabs(x) > 1e-8)
                    result |= handler(gen_num(new_n, y / x));
            }
        }
        return result;
    }
    bool judgePoint24(vector<int> &nums)
    {
        vector<double> n;
        for (int num : nums)
            n.push_back(double(num));
        return handler(n);
    }
};
```

优化后：

```cpp
class Solution
{
public:
    bool handler(vector<double> &n)
    {
        if (n.size() == 1)
            return fabs(n[0] - 24) < (1e-9);
        bool result = false;
        for (int i = 0; i < n.size(); i++)
        {
            for (int j = i + 1; j < n.size(); j++)
            {
                vector<double> new_n;
                for (int k = 0; k < n.size(); k++)
                    if (k != i && k != j)
                        new_n.push_back(n[k]);

                double x = n[i], y = n[j];
                new_n.push_back(x + y);
                result |= handler(new_n);
                new_n.pop_back();

                new_n.push_back(x - y);
                result |= handler(new_n);
                new_n.pop_back();

                new_n.push_back(y - x);
                result |= handler(new_n);
                new_n.pop_back();

                new_n.push_back(x * y);
                result |= handler(new_n);
                new_n.pop_back();

                if (fabs(y) > 1e-8)
                {
                    new_n.push_back(x / y);
                    result |= handler(new_n);
                    new_n.pop_back();
                }

                if (fabs(x) > 1e-8)
                {
                    new_n.push_back(y / x);
                    result |= handler(new_n);
                    new_n.pop_back();
                }
            }
        }
        return result;
    }
    bool judgePoint24(vector<int> &nums)
    {
        vector<double> n;
        for (int num : nums)
            n.push_back(double(num));
        return handler(n);
    }
};
```



