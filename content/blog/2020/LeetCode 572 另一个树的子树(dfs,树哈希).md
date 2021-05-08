---
title: LeetCode 572 另一个树的子树(dfs,树哈希)
date: 2020-05-07T02:05:57+08:00
lastmod: 2020-05-07T02:05:57+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508221015.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[另一个树的子树](https://leetcode-cn.com/problems/subtree-of-another-tree/)

给定两个非空二叉树 **s** 和 **t**，检验 **s** 中是否包含和 **t** 具有相同结构和节点值的子树。**s** 的一个子树包括 **s** 的一个节点和这个节点的所有子孙。**s** 也可以看做它自身的一棵子树。

**示例 1:**
给定的树 s:

```
     3
    / \
   4   5
  / \
 1   2
```

给定的树 t：

```
   4 
  / \
 1   2
```

返回 **true**，因为 t 与 s 的一个子树拥有相同的结构和节点值。

**示例 2:**
给定的树 s：

```
     3
    / \
   4   5
  / \
 1   2
    /
   0
```

给定的树 t：

```
   4
  / \
 1   2
```

返回 **false**。

## 思路

方法一：

刚一看这个题，没啥思路，一看难度是简单，就试着写了一发暴力，结果还过了，还超越了70%，那这题基本考察点应该就是暴力dfs了。

首先需要一个dfs函数，用来找到以当前点为根的树是否和给出的`t`树相等。

然后就遍历一下给出的`s`树的每一个点，每个点都暴力和`t`做一次匹配，如果有一次成功，那么就是成功的。

写代码的时候要注意，dfs函数只是写了a树是否被b树包含，所以要互相包含才可以视为成功。

方法二：

有一种算法，就是用来判断某两个树是否是同构的：**树哈希**

通过某种方式，把当前的树映射成一个哈希值，然后对比一下两个树的哈希值，即可知道两个树是否同构。

一般来说，对于树哈希我们要设计一个复杂的哈希函数，用来防止哈希碰撞。通常是用一系列的数学方法来实现。

关于树哈希的知识，可以从 [树哈希](https://oi-wiki.org/graph/tree-hash/) 了解到。

但是我太懒，只是想说明这道题可以用树哈希来做，并不想设计哈希函数，于是就暴力存了一下以每一个点为根的前序遍历序列。先存起来给出的`s`树的所有哈希，最后算出`t`为根的哈希值，查询哈希值是否出现了两次以上就可以知道`t`是否被`s`包含。

## 代码

方法一：

```cpp
class Solution
{
public:
    // 判断当前的s树是否被t树包含
    bool dfs(TreeNode *s, TreeNode *t)
    {
        if (!s || !t)
            return false;
        if (s->val != t->val)
            return false;
        bool f1 = true, f2 = true;
        if (s->left)
            f1 = dfs(s->left, t->left);
        if (s->right)
            f2 = dfs(s->right, t->right);
        if (f1 && f2)
            return true;
        return false;
    }
    bool isSubtree(TreeNode *s, TreeNode *t)
    {
        if (!s && !t)
            return true;
        queue<TreeNode *> q;
        q.push(s);
        while (!q.empty())
        {
            TreeNode *node = q.front();
            q.pop();
            if (dfs(node, t) && dfs(t, node))
                return true;
            if (node->left)
                q.push(node->left);
            if (node->right)
                q.push(node->right);
        }
        return false;
    }
};
```

或

```cpp
class Solution
{
public:
    // 判断s树是否等于t树
    bool dfs(TreeNode *s, TreeNode *t)
    {
        if (!s && !t)
            return true;
        if ((!s && t) || (s && !t))
            return false;
        return (s->val == t->val) && dfs(s->left, t->left) && dfs(s->right, t->right);
    }
    bool isSubtree(TreeNode *s, TreeNode *t)
    {
        if (!s)
            return false;
        if (dfs(s, t))
            return true;
        return isSubtree(s->left, t) || isSubtree(s->right, t);
    }
};
```

方法二：

这种没有设计哈希函数的解法，速度比暴力匹配都慢。以下代码只是想说明一个简单的树哈希的原理。

```cpp
class Solution
{
public:
    // 存储以当前点为根的前序遍历序列
    unordered_map<TreeNode *, string> mp;
    // 记录序列的数量
    unordered_map<string, int> scnt;

    void dfs(TreeNode *s)
    {
        mp[s] += to_string(s->val);
        if (!s->left && !s->right)
        {
            scnt[mp[s]]++;
            return;
        }
        if (s->left)
        {
            dfs(s->left);
            mp[s] += mp[s->left];
        }
        if (s->right)
        {
            dfs(s->right);
            mp[s] += mp[s->right];
        }
        scnt[mp[s]]++;
    }
    bool isSubtree(TreeNode *s, TreeNode *t)
    {
        if (!s && !t)
            return true;
        dfs(s);
        dfs(t);
        if (scnt[mp[t]] >= 2)
            return true;
        return false;
    }
};
```
