---
title: LeetCode 336 回文对（字典树，思路）
date: 2020-08-06T09:28:51+08:00
lastmod: 2020-08-06T09:28:51+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
- 字典树
categories: OnlineJudge刷题
comment: true

---

题目链接：[回文对](https://leetcode-cn.com/problems/palindrome-pairs/)

给定一组**唯一**的单词， 找出所有***不同\*** 的索引对 `(i, j)`，使得列表中的两个单词， `words[i] + words[j]` ，可拼接成回文串。

**示例 1:**

```
输入: ["abcd","dcba","lls","s","sssll"]
输出: [[0,1],[1,0],[3,2],[2,4]] 
解释: 可拼接成的回文串为 ["dcbaabcd","abcddcba","slls","llssssll"]
```

**示例 2:**

```
输入: ["bat","tab","cat"]
输出: [[0,1],[1,0]] 
解释: 可拼接成的回文串为 ["battab","tabbat"]
```

## 思路

1. 枚举所有的串，利用某种数据结构，存储后缀是否存在
2. 对于每个串，假设一个串的取值范围是 `[0,m-1]`，以 `j`为界，把串分成两个子串 `[0,j-1]`和 `[j,m-1]`
3. 处理这两个子串，如果 `[0,j-1]`是回文串，那么只需要找到 `[j,m-1]`这个串的镜像串，这样就可以组成一个大回文串。同理 `[j,m-1]`回文，那么只需要找到 `[0,j-1]`的镜像串，保存答案即可。

对于存储后缀，可以用哈希也可以用字典树，对于这种如果数据量太大的话，无意字典树更节省空间。

本代码采用标程中给的字典树。

## 代码

```cpp
class Solution
{
public:
    struct node
    {
        int ch[26];
        int flag;
        node()
        {
            flag = -1;
            memset(ch, 0, sizeof(ch));
        }
    };

    vector<node> tree;

    void insert(string &s, int id)
    {
        int len = s.length(), add = 0;
        for (int i = 0; i < len; i++)
        {
            int x = s[i] - 'a';
            if (!tree[add].ch[x])
            {
                tree.push_back(node());
                tree[add].ch[x] = tree.size() - 1;
            }
            add = tree[add].ch[x];
        }
        tree[add].flag = id;
    }

    int findWord(string &s, int left, int right)
    {
        int add = 0;
        for (int i = right; i >= left; i--)
        {
            int x = s[i] - 'a';
            if (!tree[add].ch[x])
            {
                return -1;
            }
            add = tree[add].ch[x];
        }
        return tree[add].flag;
    }

    bool isPalindrome(string &s, int l, int r)
    {
        while (l < r)
            if (s[l++] != s[r--])
                return false;
        return true;
    }

    vector<vector<int>> palindromePairs(vector<string> &words)
    {
        tree.push_back(node());
        int n = words.size();
        for (int i = 0; i < n; i++)
            insert(words[i], i);
        vector<vector<int>> ret;
        for (int i = 0; i < n; i++)
        {
            int m = words[i].size();
            for (int j = 0; j <= m; j++)
            {
                if (isPalindrome(words[i], j, m - 1))
                {
                    int left_id = findWord(words[i], 0, j - 1);
                    if (left_id != -1 && left_id != i)
                        ret.push_back({i, left_id});
                }
                if (j && isPalindrome(words[i], 0, j - 1))
                {
                    int right_id = findWord(words[i], j, m - 1);
                    if (right_id != -1 && right_id != i)
                        ret.push_back({right_id, i});
                }
            }
        }
        return ret;
    }
};
```
