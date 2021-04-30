---
title: LeetCode 726 原子的数量(递归,map)
date: 2019-03-16T10:43:15+08:00
lastmod: 2019-03-16T10:43:15+08:00
draft: false
featured_image: ""
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[原子的数量](https://leetcode-cn.com/problems/number-of-atoms/)


给定一个化学式`formula`（作为字符串），返回每种原子的数量。

原子总是以一个大写字母开始，接着跟随0个或任意个小写字母，表示原子的名字。

如果数量大于 1，原子后会跟着数字表示原子的数量。如果数量等于 1 则不会跟数字。例如，H2O 和 H2O2 是可行的，但 H1O2 这个表达是不可行的。

两个化学式连在一起是新的化学式。例如 H2O2He3Mg4 也是化学式。

一个括号中的化学式和数字（可选择性添加）也是化学式。例如 (H2O2) 和 (H2O2)3 是化学式。

给定一个化学式，输出所有原子的数量。格式为：第一个（按字典序）原子的名子，跟着它的数量（如果数量大于 1），然后是第二个原子的名字（按字典序），跟着它的数量（如果数量大于 1），以此类推。

**示例 1:**

```
输入: 
formula = "H2O"
输出: "H2O"
解释: 
原子的数量是 {'H': 2, 'O': 1}。
```

**示例 2:**

```
输入: 
formula = "Mg(OH)2"
输出: "H2MgO2"
解释: 
原子的数量是 {'H': 2, 'Mg': 1, 'O': 2}。
```

**示例 3:**

```
输入: 
formula = "K4(ON(SO3)2)2"
输出: "K4N2O14S4"
解释: 
原子的数量是 {'K': 4, 'N': 2, 'O': 14, 'S': 4}。
```

**注意:**

- 所有原子的第一个字母为大写，剩余字母都是小写。
- `formula`的长度在`[1, 1000]`之间。
- `formula`只包含字母、数字和圆括号，并且题目中给定的是合法的化学式。

## 思路

给出一个化学式，然后要计算出各个原子的数量，其中，括号可以嵌套。

先不考虑括号的问题，先考虑，假设没有括号，应该怎么做。肯定应该是先把这个元素提取出来，然后再计算个数。

那么我们基于递归的思想，当遇到括号的时候就直接计算括号里面的，然后在外面把递归的结果放到大结果中去。计算完括号里面的计算出括号外面的数字，然后结果就是括号里面的元素个数乘以括号外面的。

因为要考虑字典序，所以用 map 自动排序的特性可以解决这个问题。

## 代码

```cpp
class Solution
{
  public:
    string countOfAtoms(string formula)
    {
        int i = 0;
        string ans;
        for (auto &kv : get_map(formula, i))
        {
            ans += kv.first;
            if (kv.second > 1)
                ans += to_string(kv.second);
        }
        return ans;
    }
    //获结果的map
    map<string, int> get_map(string &s, int &i)
    {
        map<string, int> ans;
        while (i != s.length())
        {
            if (s[i] == '(')
            {
                map<string, int> tmp = get_map(s, ++i);
                int cnt = get_num(s, i);
                for (auto &kv : tmp)
                    ans[kv.first] += kv.second * cnt;
            }
            else if (s[i] == ')')
            {
                ++i;
                return ans;
            }
            else
            {
                string name = get_name(s, i);
                int cnt = get_num(s, i);
                ans[name] += cnt;
            }
        }
        return ans;
    }
    //获取元素名字
    string get_name(string &s, int &i)
    {
        string name;
        while (isalpha(s[i]) && (name.empty() || islower(s[i])))
            name += s[i++];
        return name;
    }
    //获取元素数量
    int get_num(string &s, int &i)
    {
        string num;
        while (isdigit(s[i]))
            num += s[i++];
        return num.empty() ? 1 : stoi(num);
    }
};
```

