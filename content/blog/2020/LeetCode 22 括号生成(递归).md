---
title: LeetCode 22 括号生成(递归)
date: 2020-04-09T11:55:17+08:00
lastmod: 2020-04-09T11:55:17+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[括号生成](https://leetcode-cn.com/problems/generate-parentheses/)

数字 *n* 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 **有效的** 括号组合。

**示例：**

```
输入：n = 3
输出：[
       "((()))",
       "(()())",
       "(())()",
       "()(())",
       "()()()"
     ]
```

## 思路

### 方法1：暴力

观察易得，符合括号序列和$n$的关系是，括号序列的个数有$2^{2n}$个，我们先把所有$2^{2n}$的括号全部打表打出来，然后再检验是否合法，最后输出合法的。

```cpp
class Solution
{
public:
    bool valid(string &str)
    {
        int balance = 0;
        for (char c : str)
        {
            if (c == '(')
                balance++;
            else
            {
                balance--;
                if (balance < 0)
                    return false;
            }
        }
        return balance == 0;
    }
    void generate_all(string &cur, int n, vector<string> &result)
    {
        if (n == cur.size())
        {
            if (valid(cur))
                result.push_back(cur);
            return;
        }
        cur += "(";
        generate_all(cur, n, result);
        cur.pop_back();
        cur += ")";
        generate_all(cur, n, result);
        cur.pop_back();
    }
    vector<string> generateParenthesis(int n)
    {
        vector<string> result;
        string cur = "";
        generate_all(cur, n * 2, result);
        return result;
    }
};
```

### 方法2：搜索

对方法1进行改进，可以只在括号序列有效时再添加 `(` 或 `)` ，而不是想方法一每次都添加，可以记录一下目前放置的所有括号的数量来做。

如果左括号数量小于$n$，那么就放置一个左括号，如果右括号的数量小于左括号的数量，就放一个右括号。

```cpp
class Solution
{
public:
    void generate(string &cur, int n, int open, int close, vector<string> &result)
    {
        if (cur.size() == n * 2)
        {
            result.push_back(cur);
            return;
        }
        if (open < n)
        {
            cur += "(";
            generate(cur, n, open + 1, close, result);
            cur.pop_back();
        }
        if (close < open)
        {
            cur += ")";
            generate(cur, n, open, close + 1, result);
            cur.pop_back();
        }
    }
    vector<string> generateParenthesis(int n)
    {
        vector<string> result;
        string cur;
        generate(cur, n, 0, 0, result);
        return result;
    }
};
```

