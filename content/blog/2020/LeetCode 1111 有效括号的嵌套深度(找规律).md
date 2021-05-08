---
title: LeetCode 1111 有效括号的嵌套深度(找规律)
date: 2020-04-01T14:29:14+08:00
lastmod: 2020-04-01T14:29:14+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: 数据结构和算法
comment: true

---

题目链接：[有效括号的嵌套深度](https://leetcode-cn.com/problems/maximum-nesting-depth-of-two-valid-parentheses-strings/)

有效括号字符串 定义：对于每个左括号，都能找到与之对应的右括号，反之亦然。详情参见题末「有效括号字符串」部分。

嵌套深度 `depth` 定义：即有效括号字符串嵌套的层数。详情参见题末「嵌套深度」部分。

 

给你一个「有效括号字符串」 `seq`，请你将其分成两个不相交的子序列 `A` 和 `B`，且 `A` 和 `B` 都满足有效括号字符串的定义（注意：`A.length + B.length = seq.length`）。

由于可能存在多种划分方案，请你从中选出 任意 一组有效括号字符串 `A` 和 `B`，使 `max(depth(A), depth(B))` 的可能取值最小。其中 `depth(A)` 表示 `A` 的嵌套深度，`depth(B)` 表示 `B` 的嵌套深度。

请你返回一个长度为 `seq.length` 的答案数组 `answer`，编码规则如下：如果 `seq[i]` 是 `A` 的一部分，那么 `answer[i] = 0`。否则，`answer[i] = 1`。即便有多个满足要求的答案存在，你也只需返回 一个。



示例 1：

```
输入：seq = "(()())"
输出：[0,1,1,1,1,0]
```


示例 2：

```
输入：seq = "()(())()"
输出：[0,0,0,1,1,0,1,1]
```


提示：

```
1 <= text.size <= 10000
```

**有效括号字符串**：

仅由 `"("` 和 `")"` 构成的字符串，对于每个左括号，都能找到与之对应的右括号，反之亦然。

下述几种情况同样属于有效括号字符串：

- 空字符串
- 连接，可以记作 AB（A 与 B 连接），其中 A 和 B 都是有效括号字符串
- 嵌套，可以记作 (A)，其中 A 是有效括号字符串

**嵌套深度**：

类似地，我们可以定义任意有效括号字符串 s 的 嵌套深度 depth(S)：

- s 为空时，depth("") = 0
- s 为 A 与 B 连接时，depth(A + B) = max(depth(A), depth(B))，其中 A 和 B 都是有效括号字符串
- s 为嵌套情况，depth("(" + A + ")") = 1 + depth(A)，其中 A 是有效括号字符串

例如：""，"()()"，和 "()(()())" 都是有效括号字符串，嵌套深度分别为 0，1，2，而 ")(" 和 "(()" 都不是有效括号字符串。

## 思路

题意很简单，就是给你一个已经配对好的括号序列。让你分成两个括号序列，且需要分成的这两个序列的的深度的最大值尽可能小，也就是使`max(depth(A), depth(B))` 最小.

容易想到，我们需要尽量把这两个序列分成两个相同深度的序列，这样就可以满足深度差最小，那如何对半分呢，用一个变量 `depth` 来记录深度，O(n)扫一遍序列，遇到左括号深度加一，遇到右括号深度减一，把奇数深度的放一起，把偶数深度的放一起。

## 代码

```cpp
class Solution
{
public:
    vector<int> maxDepthAfterSplit(string seq)
    {
        vector<int> res;
        int depth = 0;
        for (int i = 0; i < seq.size(); i++)
        {
            if (seq[i] == '(')
                res.push_back((++depth) & 1);
            else
                res.push_back((depth--) & 1);
        }
        return res;
    }
};
```



