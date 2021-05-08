---
title: LeetCode LCP18 早餐组合（贪心，思路）
date: 2020-09-15T00:56:00+08:00
lastmod: 2020-09-15T00:57:00+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
- 贪心
- 思路
categories: OnlineJudge刷题
comment: true
series:
- LeetCode题解
---

题目链接：[早餐组合](https://leetcode-cn.com/problems/2vYnGI/)

小扣在秋日市集选择了一家早餐摊位，一维整型数组 `staple` 中记录了每种主食的价格，一维整型数组 `drinks` 中记录了每种饮料的价格。小扣的计划选择一份主食和一款饮料，且花费不超过 `x` 元。请返回小扣共有多少种购买方案。

注意：答案需要以 `1e9 + 7 (1000000007)` 为底取模，如：计算初始结果为：`1000000008`，请返回 `1`

**示例 1：**

> 输入：`staple = [10,20,5], drinks = [5,5,2], x = 15`
>
> 输出：`6`
>
> 解释：小扣有 6 种购买方案，所选主食与所选饮料在数组中对应的下标分别是：
> 第 1 种方案：staple[0] + drinks[0] = 10 + 5 = 15；
> 第 2 种方案：staple[0] + drinks[1] = 10 + 5 = 15；
> 第 3 种方案：staple[0] + drinks[2] = 10 + 2 = 12；
> 第 4 种方案：staple[2] + drinks[0] = 5 + 5 = 10；
> 第 5 种方案：staple[2] + drinks[1] = 5 + 5 = 10；
> 第 6 种方案：staple[2] + drinks[2] = 5 + 2 = 7。

**示例 2：**

> 输入：`staple = [2,1,1], drinks = [8,9,5,1], x = 9`
>
> 输出：`8`
>
> 解释：小扣有 8 种购买方案，所选主食与所选饮料在数组中对应的下标分别是：
> 第 1 种方案：staple[0] + drinks[2] = 2 + 5 = 7；
> 第 2 种方案：staple[0] + drinks[3] = 2 + 1 = 3；
> 第 3 种方案：staple[1] + drinks[0] = 1 + 8 = 9；
> 第 4 种方案：staple[1] + drinks[2] = 1 + 5 = 6；
> 第 5 种方案：staple[1] + drinks[3] = 1 + 1 = 2；
> 第 6 种方案：staple[2] + drinks[0] = 1 + 8 = 9；
> 第 7 种方案：staple[2] + drinks[2] = 1 + 5 = 6；
> 第 8 种方案：staple[2] + drinks[3] = 1 + 1 = 2；

**提示：**

- `1 <= staple.length <= 10^5`
- `1 <= drinks.length <= 10^5`
- `1 <= staple[i],drinks[i] <= 10^5`
- `1 <= x <= 2*10^5`

## 思路

力扣杯2020秋季编程大赛原题。

算是个贪心吧。基本就是给你两个数组，让你从第一个中选一个元素，第二个中选一个元素，然后给出一个数，问不超过这个数的选法的方案数。

给出的数组本身是无序的，那么先给这个两个数组排个序$O(nlogn)$

先进行一波预处理，把两个数组中，从后往前，凡是数组中的值都大于给出的数的数全部筛掉。

在保证有序的情况下，就可以开始选了，用两个指针，一个指针指向第一个数组的最后边，也就是值最大的元素。再用一个指针指向第二个数组的第一个元素。

令第一个数组的指针为 $i$，第二个数组的指针为 $j$，对于当前的 $j$，我们把第一个数组中的指针 $i$ 向左移，直到 `a[i]+b[j]<=x`，此时，第一个数组的下标在 `[0,i]` 内的任意元素，都可以和第二个数组的下标为 $j$ 的元素组成答案，对答案产生的贡献是 `i+1`，然后把 $j$ 向右移，重复这个过程，直到两个数组有一个数组使用完毕。

这个方法建立在一个显然的结论，数组二中的 $b_{j+1}$ 显然大于 $b_j$，所以 $a_i+b_j>x$ 时 $a_i+b_{j+1}>x$ 恒成立，所以第一个数组的下标可以一直往左移。

总的时间复杂度是 $O(2*nlogn+2n)$约等于$O(nlogn)$

## 代码

```cpp
class Solution
{
public:
    int breakfastNumber(vector<int> &staple, vector<int> &drinks, int x)
    {
        int mod = 1000000007;
        sort(staple.begin(), staple.end());
        sort(drinks.begin(), drinks.end());
        int n = staple.size(), m = drinks.size();
        int spos = n - 1, dpos = m - 1;
        while (spos >= 0 && staple[spos] >= x)
            spos--;
        while (dpos >= 0 && drinks[dpos] >= x)
            dpos--;
        if (spos < 0 || dpos < 0)
            return 0;
        int ans = 0;
        int i = spos, j = 0;
        while (i >= 0 && j <= dpos)
        {
            while (i >= 0 && staple[i] + drinks[j] > x)
                i--;
            if (i < 0)
                break;
            ans = (ans + i + 1) % mod;
            j++;
        }
        return ans;
    }
};
```
